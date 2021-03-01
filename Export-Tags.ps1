$vc = Read-Host -Prompt "Incregre el Vcenter"

#Conectarse al Vcenter
try {
    Write-Host "Conectando con vCenter $vcenter , por favor espere ..." -ForegroundColor Cyan
    Connect-VIServer $vc -ErrorAction Stop | Out-Null
}#Fin del Try
catch {
    Write-Host "No se puede conectar con el servidor" -ForegroundColor Yellow
    Break
}#Fin del Catch

# Crea directorio para las xml de las tags
$dir_tags = "$env:USERPROFILE\Tags"
mkdir $dir_tags



# Obterner las categorias
$categoryList = Get-TagCategory -Server $server
# Obtener las Tags
$tagList = Get-Tag -Server $server
# Se crea lista con categorias y tags para exportarlas
$export = @($categoryList, $tagList)
# Se realiza export
Export-Clixml -InputObject $export -Path $dir_tags\tags.xml


Disconnect-VIServer * -Force
