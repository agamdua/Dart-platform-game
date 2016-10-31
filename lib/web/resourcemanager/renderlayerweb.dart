part of game.web;

abstract class RenderLayerWeb extends RenderLayer {
  CanvasImageSource img;
}

class RenderLayerWebCanvas extends DrawableRenderLayer<RenderLayerWeb> with RenderLayerWeb {
  CanvasElement el_canvas;
  CanvasRenderingContext2D ctx;

  @override
  int get h => el_canvas.height;
  @override
  int get w => el_canvas.width;

  RenderLayerWebCanvas() {
    el_canvas = new Element.tag("canvas");
    img = el_canvas;
    ctx = el_canvas.getContext("2d");
  }

  RenderLayerWebCanvas.fromCanvas(this.el_canvas) {
    img = el_canvas;
    ctx = el_canvas.getContext("2d");
  }

  RenderLayerWebCanvas.withSize(int w, int h) {
    el_canvas = new Element.tag("canvas");
    el_canvas.height = h;
    el_canvas.width = w;
    img = el_canvas;
    ctx = el_canvas.getContext("2d");
  }

  @override
  void resize(int w, int h) {
    el_canvas.width = w;
    el_canvas.height = h;
  }

  @override
  void drawLayer(RenderLayerWeb layer, int x, int y) {
    ctx.drawImage(layer.img, x, y);
  }

  @override
  void drawLayerPart(RenderLayerWeb layer, int x, int y, int img_x, int img_y, int img_w, int img_h) {
    ctx.drawImageScaledFromSource(layer.img, img_x, img_y, img_w, img_h, x, y, img_w, img_h);
  }

  @override
  void clear() {
    el_canvas.width = el_canvas.width;
  }

  @override
  void clearArea(int x, int y, int w, int h) {
    ctx.clearRect(x, y, w, h);
  }
}

class RenderLayerWebImage extends RenderLayer with RenderLayerWeb {
  ImageElement el_img;

  @override
  int get h => el_img.height;
  @override
  int get w => el_img.width;

  RenderLayerWebImage(this.el_img) {
    img = el_img;
  }
}
