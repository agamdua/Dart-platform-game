part of game.web;

/*
1. new Dashboard
2. new Game
3.
 */

class Dashboard extends GameOutput {
  Game game;
  RenderWeb render;
  ResourceManager resourceManager;
  InputControllerWebKeyboard inputController;
  MessageController messages;
  Dashboard() {
    resourceManager = new ResourceManagerWeb();
    messages = new MessageController();
  }
  void init() {}
  void start() {
    resourceManager.onResourcesLoaded = _loadingFinished;

    //load resources
    resourceManager.loadJson("level0", "resources/levels/level_0.json");
    resourceManager.loadImage("assets", "resources/images/images.png");
    resourceManager.loadImage("player", "resources/images/c0v0a16t1uv1t80Cs1Cd.png");
    resourceManager.loadImage("text", "resources/images/text_arial.png");
    resourceManager.startLoading();
  }

  void _loadingFinished() {
    RenderLayerWebCanvas.imageText = new ImageText(resourceManager.getImage("text"));

    render = new RenderWeb();
    game = new Game(resourceManager, render, this, new GameLoopWeb());
    inputController = new InputControllerWebKeyboard(game);

    //when loading has finsished, display a start button
    ButtonElement dombutton = new ButtonElement();
    DivElement main = document.querySelector("#openscreen");
    main.style.transition = "opacity 0.5s ease-in-out";

    document.querySelector("#loading").text = "";

    dombutton.text = "Start!";

    dombutton.onClick.listen((e) {
      main.style.opacity = "0.0";
      new Timer(const Duration(milliseconds: 500), () {
        main.remove();

        game.start();

        RenderLayerWebCanvas gameLayer = render.layer;
        gameLayer.el_canvas.id = "game";
        //fade-in effect
        gameLayer.el_canvas.style.opacity = "0.0";
        gameLayer.el_canvas.style.transition = "opacity 1s ease-in-out";
        document.body.nodes.add(gameLayer.el_canvas);
        gameLayer.el_canvas.style.opacity = "1.0";

        document.onKeyDown.listen(inputController.handleKey);
        document.onKeyUp.listen(inputController.handleKey);
        if (isMobile()) addMobileControls();
      });
    });
    main.nodes.add(dombutton);
  }

  static bool isMobile() {
    String userAgent = window.navigator.userAgent;
    List<String> mobiledevices = ["Android", "webOS", "iPhone", "iPad", "iPod", "BlackBerry", "Windows Phone"];

    for (String s in mobiledevices) if (userAgent.contains(s)) return true;
    return false;
  }

  void addMobileControls() {
    Element elwrapper = new DivElement();
    elwrapper.id = "touch_controls";
    elwrapper.append(createTouchButton("Left", 37));
    elwrapper.append(createTouchButton("Right", 39));
    elwrapper.append(createTouchButton("Jump", 38));
    elwrapper.append(createTouchButton("Jump2", 40));
    elwrapper.append(createTouchButton("Enter", 13));
    document.body.append(elwrapper);
  }

  Element createTouchButton(String text, int key, [bool icon = true]) {
    Element el = new DivElement();
    el.text = text;
    el.className = "touch_control";
    el.onTouchStart.listen((TouchEvent e) {
      e.preventDefault();
      el.classes.add("hover");
      inputController.handleControl(key, true);
    });
    el.onTouchEnd.listen((TouchEvent e) {
      e.preventDefault();
      el.classes.remove("hover");
      inputController.handleControl(key, false);
    });

    el.onMouseDown.listen((MouseEvent e) {
      e.preventDefault();
      el.classes.add("hover");
      inputController.handleControl(key, true);
    });
    el.onMouseUp.listen((MouseEvent e) {
      e.preventDefault();
      el.classes.remove("hover");
      inputController.handleControl(key, false);
    });
    return el;
  }

  @override
  void onGameGoToLocation(String url) {
    window.location.assign(url);
  }

  @override
  void onGameMessage(String message) {
    messages.sendMessage(message);
  }

  @override
  void onGameLevelFinished() {
    // TODO: implement onGameLevelFinished
  }

  @override
  void onGameLevelLoaded() {
    game.camera.w = Math.min(window.innerWidth, game.level.w);
    //-38 for top bar
    game.camera.h = Math.min(window.innerHeight - 44, game.level.h);

    //verticaly center the game
    int offsettop = 38;
    if (game.camera.h == game.level.h) offsettop = (window.innerHeight - 44 - game.camera.h) ~/ 2;

    RenderLayerWebCanvas gameLayer = render.layer;
    gameLayer.el_canvas.style.marginTop = "${offsettop}px";

    int minborder = Math.min(game.camera.w, game.camera.h);
    game.camera.border = (minborder * 0.3).toInt(); //10%

    render.layer.resize(game.camera.w, game.camera.h);
  }

  @override
  void onGameStart() {
    // TODO: implement onGameStart
  }
}
