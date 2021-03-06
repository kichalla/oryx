﻿// --------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.
// --------------------------------------------------------------------------------------------
using Microsoft.Extensions.Options;

namespace Microsoft.Oryx.BuildScriptGenerator.Node
{
    internal class NodeScriptGeneratorOptionsSetup : IConfigureOptions<NodeScriptGeneratorOptions>
    {
        internal const string NodeJsDefaultVersion = "ORYX_NODE_DEFAULT_VERSION";
        internal const string NpmDefaultVersion = "ORYX_NPM_DEFAULT_VERSION";
        internal const string NodeSupportedVersionsEnvVariable = "NODE_SUPPORTED_VERSIONS";
        internal const string NpmSupportedVersionsEnvVariable = "NPM_SUPPORTED_VERSIONS";
        internal const string NodeLtsVersion = "8.11.2";
        internal const string InstalledNodeVersionsDir = "/opt/nodejs/";
        internal const string InstalledNpmVersionsDir = "/opt/npm/";

        private readonly IEnvironment _environment;

        public NodeScriptGeneratorOptionsSetup(IEnvironment environment)
        {
            _environment = environment;
        }

        public void Configure(NodeScriptGeneratorOptions options)
        {
            var defaultVersion = _environment.GetEnvironmentVariable(NodeJsDefaultVersion);
            if (string.IsNullOrEmpty(defaultVersion))
            {
                defaultVersion = NodeLtsVersion;
            }

            options.NodeJsDefaultVersion = defaultVersion;
            options.NpmDefaultVersion = _environment.GetEnvironmentVariable(NpmDefaultVersion);
            options.InstalledNodeVersionsDir = InstalledNodeVersionsDir;
            options.InstalledNpmVersionsDir = InstalledNpmVersionsDir;
            options.SupportedNodeVersions = _environment.GetEnvironmentVariableAsList(NodeSupportedVersionsEnvVariable);
            options.SupportedNpmVersions = _environment.GetEnvironmentVariableAsList(NpmSupportedVersionsEnvVariable);
        }
    }
}