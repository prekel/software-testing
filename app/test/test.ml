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
      module I = Calc.MakeStateMachine (struct
        type num = float [@@deriving sexp, equal]
        type op = [ `Sub ] [@@deriving sexp, equal]

        let calculate _ b c = Some (b -. c)
      end)

      include I

      let line_to_action ?quit:_ = function
        | "number1" -> Num 123.
        | "number2" -> Num (-100.)
        | "minus" -> Op `Sub
        | _ -> assert false
      ;;
    end

    module Component = MakeComponent (StubCalculator)
    open Bonsai

    let%expect_test "" =
      let a = Bonsai.Var.create None in
      let update_var =
        Bonsai.Var.create (fun ac -> Effect.return @@ Bonsai.Var.set a (Some ac))
      in
      let update = Bonsai.Var.value update_var in
      let handle = Handle.create (Result_spec.vdom Fn.id) (Component.form update) in
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get a : StubCalculator.action option)];
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
      (* 2 *)
      Handle.input_text handle ~get_vdom:Fn.id ~selector:".form" ~text:"number1";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get a : StubCalculator.action option)];
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
      (* 2 *)
      Handle.click_on handle ~get_vdom:Fn.id ~selector:".enter";
      Handle.show handle;
      print_s [%sexp (Bonsai.Var.get a : StubCalculator.action option)];
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
            ((Num 123)) |}]
    ;;
  end)
;;
