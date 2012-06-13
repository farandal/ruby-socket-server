require File.expand_path('../../lib/em-websocket', __FILE__)

#Configuracion
Puerto = 3009
Servidor = "0.0.0.0"

#module CumploSocketServer
#     def receive_data(data)
#       send_data data
#     end 
#end   
#
#
#   
#class Channel
#           def initialize
#             @sockets = []
#           end
#           def suscribir( socket )
#             puts 'Channel.suscribir'
#             @sockets << socket
#           end
#           
#           def enviar_mensaje( msg )
#               @sockets.each { |socket|
#                 socket.send msg
#                 puts 'Channel.send_msg' +msg.to_s
#               }
#          end
#          
#          def desuscribir( socket )
#             @sockets.delete socket
#              puts 'Channel.delete'
#             
#          end
#end
#   
#EventMachine::run {
#  EventMachine::start_server Servidor, Puerto, CumploSocketServer
#  puts 'CumploSocketServer escuchando en el puerto '+Puerto.to_s
#}
#
#EventMachine.run {
#  
#        EventMachine::WebSocket.start(:host=>Servidor,:port=>Puerto) {  |socket|
#          
#          @channel = Channel.new
#          
#          socket.onopen {
#            @channel.suscribir socket
#             puts 'suscribir'
#          }
#          socket.onmessage { |msg|
#            @channel.enviar_mensaje msg
#             puts 'onmessage '+msg.to_s
#          }
#          socket.onclose {
#            @channel.desuscribir socket
#            puts 'desuscribir'
#          }  
#
#       
#       }
#}


EventMachine.run {

    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => Puerto) do |ws|
        ws.onopen {
          puts "WebSocket connection open"

          # publish message to the client
          ws.send "Hello Client"
        }

        ws.onclose { puts "Connection closed" }
        ws.onmessage { |msg|
          puts "Recieved message: #{msg}"
          ws.send "Pong: #{msg}"
        }
    end
}