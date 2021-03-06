open Amqp
open Thread

let test =
  Connection.connect ~id:"fugmann" "localhost" >>= fun connection ->
  Log.info "Connection started";
  Connection.open_channel ~id:"test" Channel.no_confirm connection >>= fun channel ->
  Log.info "Channel opened";
  Exchange.declare channel ~auto_delete:true Exchange.direct_t "test1" >>= fun exchange1 ->
  Log.info "Exchange declared";
  Exchange.declare channel ~auto_delete:true Exchange.direct_t "test2" >>= fun exchange2 ->
  Log.info "Exchange declared";
  Exchange.bind channel ~source:exchange1 ~destination:exchange2 (`Queue "test") >>= fun () ->
  Log.info "Exchange Bind";
  Exchange.unbind channel ~source:exchange1 ~destination:exchange2 (`Queue "test") >>= fun () ->
  Log.info "Exchange Unbind";
  Exchange.delete channel exchange1 >>= fun () ->
  Log.info "Exchange deleted";
  Exchange.delete channel exchange2 >>= fun () ->
  Log.info "Exchange deleted";
  Channel.close channel >>= fun () ->
  Log.info "Channel closed";
  Connection.close connection >>| fun () ->
  Log.info "Connection closed";
  Scheduler.shutdown 0

let _ =
  Scheduler.go ()
let () = Printf.printf "Done\n"
