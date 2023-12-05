using System.Net;
using Azure.Identity;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace FunctionApp1
{
    public class Function1
    {
        private readonly ILogger logger;

        public Function1(ILoggerFactory loggerFactory)
        {
            logger = loggerFactory.CreateLogger<Function1>();
        }

        [Function("Function1")]
        public async Task<HttpResponseData> RunAsync([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = "test")] HttpRequestData request, CancellationToken cancellationToken)
        {
            HttpResponseData response = request.CreateResponse(HttpStatusCode.OK);
            response.Headers.Add("Content-Type", "text/plain; charset=utf-8");
            // Get the request content, and concatenate it as a file content
            var requestRoute = request.Url.ToString();
            var requestBody = request.ReadAsString();
            string content = $"Route: {requestRoute}\nBody: {requestBody}";

            // Create a blob in the Storage Account, to store the request content as a blob
            var storageAccountName = Environment.GetEnvironmentVariable("STORAGE_ACCOUNT__1");
            var blobServiceUri = new Uri($"https://{storageAccountName}.blob.core.windows.net");
            var blobContainerName = "content";
            var tokenCredential = new DefaultAzureCredential();
            var blobServiceClient = new Azure.Storage.Blobs.BlobServiceClient(blobServiceUri, tokenCredential);
            var blobContainerClient = blobServiceClient.GetBlobContainerClient(blobContainerName);

            var blobName = Guid.NewGuid().ToString();
            using var stream = new MemoryStream();
            using var streamWriter = new StreamWriter(stream);
            streamWriter.Write(content);

            var blobClient = blobContainerClient.GetBlobClient(blobName);
            await blobClient.UploadAsync(stream, cancellationToken);

            response.WriteString($"Content has been stored into a blob (name: {blobName})");

            return response;
        }
    }
}
