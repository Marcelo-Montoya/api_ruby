require "uri"
require "net/http"
require "json"

def request(url_request)
    url = URI(url_request)

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER
    
    request = Net::HTTP::Get.new(url)
    # request["cache-control"] = 'no-cache'
    # request["postman-token"] = '5f4b1b36-5bcd-4c49-f578-75a752af8fd5'

    response = https.request(request)

    return JSON.parse(response.body)
    
end


data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1&api_key=EQM1HIvnpP0ufN82lIOhQFxCP68Y3olSkeduzBYz").values[0]


photos = data.map do |photo|

    photo["img_src"]

end

print photos


def build_web_page(photos)
    photos_list = ""    


    photos.each do |photo|

        photos_list += "
            <li>
            <img src=\"#{photo}\">
            </li>         
        "
    end

    html = "<!DOCTYPE html>
            <html>
                <head>
                    <title>Imagenes desde Marte</title>
                </head>
                <body>
                    <ul>
                        #{photos_list}
                    </ul>
                </body>
            </html>"
    
    File.write('index.html', html)
end

build_web_page(photos)


def photos_count(data)

    camera = data.each do |photo|

        print photo["camera"]["full_name"]
        
        puts
    end

end


photos_count(data)