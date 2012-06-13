require 'em-websocket'
require 'json'

#Configuracion
Puerto = 3009
Servidor = "0.0.0.0"

EventMachine.run { 

  Sesiones = Hash.new{ |h,k| h[k] = EM::Channel.new }

  EventMachine::WebSocket.start(:host => Servidor, :port => Puerto, :debug => true) { |ws| 

      ws.onopen { 
         
         sid = Sesiones[ws.request['query']["canal_id"]].subscribe{ |msg| ws.send msg } 
         object = {
            :accion => "silencio",
            :mensaje => "socket #{sid} en sesion #{ws.request['query']["canal_id"]} connectado!",
            :actor => "server",
            :canal_id => ws.request['query']["canal_id"]
            
         }
        
         Sesiones[ws.request['query']["canal_id"]].push object.to_json
        
      }

      ws.onmessage { |msg| 
         puts msg
         ws.send msg
         Sesiones[ws.request['query']["canal_id"]].push msg 
      } 

      ws.onclose { 
        
          Sesiones[ws.request['query']["canal_id"]].unsubscribe(ws.request['signature'].to_i)
     
      } 

      } 
  } 



