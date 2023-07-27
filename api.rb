require 'uri'
require 'net/http'
require 'json'

#Método para realizar solicitud HTTP GET 
def request (url_requested)
    url = URI(url_requested)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(url)
    #Se obtiene un JSON
    response = http.request(request)
    return JSON.parse(response.body)
end

# Método para construir una página web en formato HTML con las imágenes de las fotos
def build_web_page(data)
    html = "<html>\n<head>\n" #"<html>\n<head>\n</head>\n<body>\n<ul>\n"
    html += "<link rel='stylesheet' type='text/css' href='./css/styles.css'>\n"
    html += "</head>\n<body>\n<ul>\n"
    #Formato como se muestra la imagen en html
    data['photos'].each do |photo|
        html += "<li><img src='#{photo['img_src']}'></li>\n"
    end      
    html += "</ul>\n</body>\n</html>"
    return html
end

# Método para contar la cantidad de fotos por cámara y devolver un nuevo hash con los resultados
def photos_count(data)
    count_hash = {}
    data['photos'].each do |photo|
        camera = photo['camera']['name']
        count_hash[camera] ||= 0
        count_hash[camera] += 1
    end
    return count_hash
end

# URL de la API de la NASA
url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=rf7P5WljIhoXoImjURuifsXoqMYX5L8e2gex5P4n'

# Realizar la consulta a la API y obtener los datos
data = request(url)

# Generar la página web con las imágenes de las fotos
html = build_web_page(data)

# Guardar en archivo html
File.write('index.html', html)

# Contar la cantidad de fotos por cámara y mostrar los resultados
count_hash = photos_count(data)
puts count_hash
puts ("Hola a todos!!")