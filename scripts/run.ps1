$helmOptions=@()
$kubevalOptions=@()
$HELM_PLUGIN_DIR="$($args[0])" #This is not getting set when the powershell is called, so we pass it
$kubevalCommand="$HELM_PLUGIN_DIR\\bin\\kubeval"

# We're going to try and take out the kubeval options from the helm ones
for ($i=1; $i -lt $args.Length; $i++)
{
    $currArg="$($args[$i])"

    switch ("$($args[$i])")
    {
        # Kubeval commands
        { ($_ -eq "--version") -or ($_ -eq "--help")}
        { 
            # Just send to kubeval
            Invoke-Expression "& $kubevalCommand $currArg"
            exit
        }
        {($_ -eq "--strict") -or ($_ -eq "--exit-on-error") -or ($_ -eq "--openshift") -or ($_ -eq "--force-color") -or ($_ -eq "--ignore-missing-schemas")}
        {
            $kubevalOptions += "$currArg"
        }
        {($_ -eq "--output") -or ($_ -eq "-o") -or ($_ -eq "--kubernetes-version") -or ($_ -eq "-v") -or ($_ -eq "--schema-location") -or ($_ -eq "-s") -or ($_ -eq "--skip-kinds")}
        {
            $kubevalOptions += "$currArg"
            $kubevalOptions += "$($args[$i+1])"

            #Skip the "value"
            $i++
        }
        Default { $helmOptions += "$currArg" }
    }
}

# Send it to kubeval
Invoke-Expression "helm template $helmOptions | $kubevalCommand $kubevalOptions"