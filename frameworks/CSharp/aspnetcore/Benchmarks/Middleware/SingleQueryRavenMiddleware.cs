// Copyright (c) .NET Foundation. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Benchmarks.Configuration;
using Benchmarks.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;

namespace Benchmarks.Middleware
{
    public class SingleQueryRavenMiddleware
    {
        private static readonly PathString _path = new PathString(Scenarios.GetPath(s => s.DbSingleQueryRaven));
        private static readonly JsonSerializerSettings _jsonSettings = new JsonSerializerSettings
        {
            ContractResolver = new CamelCasePropertyNamesContractResolver()
        };

        private readonly RequestDelegate _next;
        private readonly RavenDb _db;

        public SingleQueryRavenMiddleware(RequestDelegate next, RavenDb provider)
        {
            _next = next;
            _db = provider;
        }

        public async Task Invoke(HttpContext httpContext)
        {
            if (httpContext.Request.Path.StartsWithSegments(_path, StringComparison.Ordinal))
            {               
                var row = await _db.LoadSingleQueryRow();

                var result = JsonConvert.SerializeObject(row, _jsonSettings);

                httpContext.Response.StatusCode = StatusCodes.Status200OK;
                httpContext.Response.ContentType = "application/json";
                httpContext.Response.ContentLength = result.Length;

                await httpContext.Response.WriteAsync(result);

                return;
            }

            await _next(httpContext);
        }
    }

    public static class SingleQueryRavenMiddlewareExtensions
    {
        public static IApplicationBuilder UseSingleQueryRavenDb(this IApplicationBuilder builder)
        {
            return builder.UseMiddleware<SingleQueryRavenMiddleware>();
        }
    }
}
