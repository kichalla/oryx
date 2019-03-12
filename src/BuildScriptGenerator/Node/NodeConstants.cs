﻿// --------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.
// --------------------------------------------------------------------------------------------

namespace Microsoft.Oryx.BuildScriptGenerator.Node
{
    internal static class NodeConstants
    {
        internal const string NodeJsName = "nodejs";
        internal const string PackageJsonFileName = "package.json";
        internal const string PackageLockJsonFileName = "package-lock.json";
        internal const string YarnLockFileName = "yarn.lock";
        internal const string NpmCommand = "npm";
        internal const string NpmStartCommand = "npm start";
        internal const string YarnStartCommand = "yarn run start";
        internal const string YarnCommand = "yarn";
        internal const string PackageInstallCommandTemplate = "{0} install";
        internal const string ProductionOnlyPackageInstallCommandTemplate = "{0} install --production";
        internal const string PkgMgrRunBuildCommandTemplate = "{0} run build";
        internal const string PkgMgrRunBuildAzureCommandTemplate = "{0} run build:azure";
        internal const string NodeModulesDirName = "node_modules";
    }
}