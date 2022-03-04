open Core
open Bonsai_web_test
open Lab_calculator_app_lib.Lib

let%test_module "q" =
  (module struct
    let%expect_test "w" =
      print_string "1231";
      [%expect {| 1231 |}]
    ;;

    let%expect_test "1" =
      let handle = Handle.create (Result_spec.vdom Fn.id) app in
      Handle.show handle;
      [%expect
        {|
        <div>
          <div>
            <pre class="state"> WaitInitial </pre>
            <div>
              <form onsubmit>
                <input class="form" #value="" oninput> </input>
              </form>
              <button class="enter" onclick> enter </button>
              <div>
                <button class="back" onclick> back </button>
                <button class="calc" onclick> calc </button>
                <button class="empty" onclick> empty </button>
                <button class="invalid" onclick> invalid </button>
                <button class="reset" onclick> reset </button>
                <button class="quit" onclick> quit </button>
              </div>
            </div>
          </div>
          <div>
            <input type="radio" name="variants" value="float" checked="" class="radio-float" onchange> </input>
            <label> float </label>
          </div>
          <div>
            <input type="radio" name="variants" value="int" class="radio-int" onchange> </input>
            <label> int </label>
          </div>
          <div>
            <input type="radio" name="variants" value="vector0" class="radio-vector0" onchange> </input>
            <label> vector0 </label>
          </div>
          <div>
            <input type="radio" name="variants" value="vector1" class="radio-vector1" onchange> </input>
            <label> vector1 </label>
          </div>
          <div>
            <input type="radio" name="variants" value="vector2" class="radio-vector2" onchange> </input>
            <label> vector2 </label>
          </div>
        </div> |}];
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"1";
      Handle.show_diff handle;
      [%expect
        {|
            <div>
              <div>
                <pre class="state"> WaitInitial </pre>
                <div>
                  <form onsubmit>
          -|        <input class="form" #value="" oninput> </input>
          +|        <input class="form" #value="1" oninput> </input>
                  </form>
                  <button class="enter" onclick> enter </button>
                  <div>
                    <button class="back" onclick> back </button>
                    <button class="calc" onclick> calc </button>
                    <button class="empty" onclick> empty </button>
                    <button class="invalid" onclick> invalid </button>
                    <button class="reset" onclick> reset </button>
                    <button class="quit" onclick> quit </button>
                  </div>
                </div>
              </div>
              <div>
                <input type="radio" name="variants" value="float" checked="" class="radio-float" onchange> </input>
                <label> float </label>
              </div> |}]
    ;;
  end)
;;
