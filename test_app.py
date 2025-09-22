import app

def test_main(capfd):
    app.main()
    out, _ = capfd.readouterr()
    assert "Hello ToDoApp" in out
