package rendertest
{
    import flash.display.MovieClip;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.utils.getTimer;

    import com.ccaleb.utils.gfx.BitmapLibrary;
    import com.ccaleb.utils.gfx.BitmapSheet;
    import com.ccaleb.utils.gfx.Rectangles;
    import com.ccaleb.utils.gfx.Names;

    import flash.display.Bitmap;
    import flash.display.Sprite;
    import flash.geom.Matrix;

    public final class RenderTest1 extends MovieClip
    {
        private var lastTime : int;
        private var bl : BitmapLibrary;

        private var succubusContainer : Sprite;
        private var succubi : Vector.<Bitmap> = new Vector.<Bitmap>();
        private var succubusFrame : int = 0;
        private var succubusCount : int = 0;
        private var frameThrottle : int = 0;

        public var out_fps : TextField;
        public var out_succubus : TextField;

        private var samples : Vector.<Number> = new Vector.<Number>(100, true);
        private var sampleIndex : int = 0;
        private var showFPS : Boolean = false;

        public function RenderTest1()
        {
            lastTime = getTimer();
            var bs : BitmapSheet = new BitmapSheet();
            bs.setRegions(Rectangles.create(64, 88, 8, 1), Names.create(8, "succubus", 0));
            bs.load(new succubus_walk());
            bl = new BitmapLibrary();
            bl.addBitmapSheet(bs);
            bs.destroy();
            succubusContainer = new Sprite();
            succubusContainer.mouseEnabled = false;
            succubusContainer.mouseChildren = false;
            addChildAt(succubusContainer, 0);
            addEventListener(Event.ADDED_TO_STAGE, addedToStage);
            addEventListener(Event.ENTER_FRAME, enterFrame);
        }

        private function addSuccubus(x : int, y : int) : void
        {
            var succubus : Bitmap = new Bitmap();
            succubus.x = x;
            succubus.y = y;
            succubusContainer.addChild(succubus);
            succubi[succubusCount++] = succubus;
            out_succubus.text = "Succubus count: " + succubusCount;
        }

        private function mouseClick(e : MouseEvent) : void
        {
            addSuccubus(e.stageX - (64 / 2), e.stageY - (88 / 2));
        }

        private function addedToStage(e : Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
            stage.addEventListener(MouseEvent.CLICK, mouseClick);
        }

        private function enterFrame(e : Event) : void
        {
            var i : int;
            for (i = 0; i < succubi.length; i++)
            {
                succubi[i].bitmapData = bl.bitmaps[succubusFrame];
            }
            if (++frameThrottle >= 4)
            {
                frameThrottle = 0;
                succubusFrame++;
                if (succubusFrame >= bl.bitmaps.length)
                {
                    succubusFrame = 0;
                }
            }
            var now : int = getTimer();
            samples[sampleIndex++] = 1000.0 / (now - lastTime);
            lastTime = now;
            if (sampleIndex >= samples.length)
            {
                sampleIndex = 0;
                showFPS = true;
            }
            var acc : int = 0;
            for (i = 0; i < samples.length; i++)
            {
                acc += samples[i];
            }
            var avg : int = Math.round(acc / samples.length);
            if (showFPS)
            {
                out_fps.text = avg + " fps";
            }
        }
    }
}