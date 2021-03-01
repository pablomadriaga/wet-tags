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

# Directorio de las Tags
$dir_tags = "$env:USERPROFILE\Tags\"


# Se realiza el import
$import = Import-Clixml -Path $dir_tags\tags.xml
# Se prepara listas de Categorias y Tags
$categoryList = $import[0]
$tagList = $import[1]
   
# Se crea lista vacia de categorias
$categories = @()

# Se crean las categorias
foreach ($category in $categoryList) {
    $categories += `
        New-TagCategory `
        -Name $category.Name `
        -Description $category.Description `
        -Cardinality $category.Cardinality `
        -EntityType $category.EntityType `
        -Server $server `
        | Out-Null
}
   
# Se crean las Tags
foreach ($tag in $tagList) {
    # Se realiza por categoria
    $category = $categories | where {$_.Name -eq $tag.Category.Name}
    if ($category -eq $null) {$category = $tag.Category.Name}
    
    New-Tag `
        -Name $tag.Name `
        -Description $tag.Description `
        -Category $category `
        -Server $server `
    | Out-Null
}

Disconnect-VIServer * -Force
