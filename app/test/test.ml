open Core
open Bonsai_web_test
open Lab_calculator
open Lab_calculator_app_lib.Lib

let%test_module "full component tests" =
  (module struct
    let%expect_test "full component test" =
      let handle = Handle.create (Result_spec.vdom Fn.id) app in
      Handle.show handle;
      [%expect
        {|
        <div class="root">
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
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"123";
      Handle.show_diff handle;
      [%expect
        {|
            <div class="root">
              <div>
                <pre class="state"> WaitInitial </pre>
                <div>
                  <form onsubmit>
          -|        <input class="form" #value="" oninput> </input>
          +|        <input class="form" #value="123" oninput> </input>
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
              </div> |}];
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show_diff handle;
      [%expect
        {|
          <div class="root">
            <div>
        -|    <pre class="state"> WaitInitial </pre>
        +|    <pre class="state"> (WaitOperation (acc 123)) </pre>
              <div>
                <form onsubmit>
        -|        <input class="form" #value="123" oninput> </input>
        +|        <input class="form" #value="" oninput> </input>
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
            </div> |}];
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"-";
      Handle.show_diff handle;
      [%expect
        {|
          <div class="root">
            <div>
              <pre class="state"> (WaitOperation (acc 123)) </pre>
              <div>
                <form onsubmit>
        -|        <input class="form" #value="" oninput> </input>
        +|        <input class="form" #value="-" oninput> </input>
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
            </div> |}];
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show_diff handle;
      [%expect
        {|
          <div class="root">
            <div>
        -|    <pre class="state"> (WaitOperation (acc 123)) </pre>
        +|    <pre class="state"> (WaitArgument (acc 123) (op Sub)) </pre>
              <div>
                <form onsubmit>
        -|        <input class="form" #value="-" oninput> </input>
        +|        <input class="form" #value="" oninput> </input>
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
            </div> |}];
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"123";
      Handle.show_diff handle;
      [%expect
        {|
          <div class="root">
            <div>
              <pre class="state"> (WaitArgument (acc 123) (op Sub)) </pre>
              <div>
                <form onsubmit>
        -|        <input class="form" #value="" oninput> </input>
        +|        <input class="form" #value="123" oninput> </input>
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
            </div> |}];
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show_diff handle;
      [%expect
        {|
          <div class="root">
            <div>
        -|    <pre class="state"> (WaitArgument (acc 123) (op Sub)) </pre>
        +|    <pre class="state"> (Calculation (acc 123) (op Sub) (arg 123)) </pre>
              <div>
                <form onsubmit>
        -|        <input class="form" #value="123" oninput> </input>
        +|        <input class="form" #value="" oninput> </input>
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
            </div> |}];
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"=";
      Handle.show_diff handle;
      [%expect
        {|
          <div class="root">
            <div>
              <pre class="state"> (Calculation (acc 123) (op Sub) (arg 123)) </pre>
              <div>
                <form onsubmit>
        -|        <input class="form" #value="" oninput> </input>
        +|        <input class="form" #value="=" oninput> </input>
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
            </div> |}];
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show_diff handle;
      [%expect
        {|
          <div class="root">
            <div>
        -|    <pre class="state"> (Calculation (acc 123) (op Sub) (arg 123)) </pre>
        +|    <pre class="state"> (WaitOperation (acc 0)) </pre>
              <div>
                <form onsubmit>
        -|        <input class="form" #value="=" oninput> </input>
        +|        <input class="form" #value="" oninput> </input>
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
            </div> |}];
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"";
      Handle.show_diff handle;
      [%expect {||}];
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show_diff handle;
      [%expect
        {|
          <div class="root">
            <div>
        -|    <pre class="state"> (WaitOperation (acc 0)) </pre>
        +|    <pre class="state"> (Finish 0) </pre>
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
            <div> |}]
    ;;
  end)
;;

let%test_module "test with stub" =
  (module struct
    module StubCalculator : Calculator.S = struct
      include Calc.MakeStateMachine (struct
        type num = float [@@deriving sexp, equal]
        type op = [ `Sub ] [@@deriving sexp, equal]

        let calculate _ b c = Some (b -. c)
      end)

      let line_to_action ?quit:_ = function
        | "number1" -> Num 123.
        | "number2" -> Num (-100.)
        | "minus" -> Op `Sub
        | _ -> assert false
      ;;
    end

    module Component = MakeComponent (StubCalculator)
    open Bonsai

    let%expect_test "form test" =
      (* Arrange *)
      let state_var = Bonsai.Var.create None in
      let update_var =
        Bonsai.Var.create (fun ac -> Effect.return @@ Bonsai.Var.set state_var (Some ac))
      in
      let update = Bonsai.Var.value update_var in
      let handle = Handle.create (Result_spec.vdom Fn.id) (Component.form update) in
      (* Act, Assert: initial state *)
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
        () |}];
      (* Act, Assert: inpun number1, but do not click *)
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"number1";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
        <div>
          <form onsubmit>
            <input class="form" #value="number1" oninput> </input>
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
        () |}];
      (* Act, Assert: click on enter *)
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
        ((Num 123)) |}];
      (* Act, Assert: type end enter number2 *)
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"number2";
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
        ((Num -100)) |}];
      (* Act, Assert: type end enter minus *)
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"minus";
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
        ((Op Sub)) |}];
      (* Act, Assert: click on back *)
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".back";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
          (Back) |}];
      (* Act, Assert: click on calc *)
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".calc";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
          (Calculate) |}];
      (* Act, Assert: click on empty *)
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".empty";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
          (Empty) |}];
      (* Act, Assert: click on invalid *)
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".invalid";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
          ((Invalid "")) |}];
      (* Act, Assert: click on reset *)
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".reset";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect
        {|
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
          (Reset) |}];
      (* Act, Assert: click on quit (should fail because quit triggers reload) *)
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".quit";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get state_var : StubCalculator.action option)];
      [%expect.unreachable]
      [@@expect.uncaught_exn
        {| ("TypeError: Cannot read properties of undefined (reading 'reload')") |}]
    ;;
  end)
;;
