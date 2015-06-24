var riot = require('riot');
SocialCapitalStore = require('./social-capital-store')

<social-capital-meter>
    <!--
    http://ruwix.com/simple-javascript-html-css-slider-progress-bar/
    -->
    <div class="scm__bg"></div>
    <div class="scm__bar"></div>
    <div class="scm__label">Resentment:
        <span class="scm__label__value"> { capital }%</span>
         ({ deltaPerSecond } per second)
    </div>

    <style scoped>
        :scope {
            width: 100%;
            overflow: hidden;
        }
        .scm__bg {
            width: 100%;
            height: 2em;
            min-height: 2em;
            border: 1px solid #000;
            background: #999999;

            position: fixed;
            left: 0;
            top: 0;
        }
        .scm__bar {
            width: 37%;
            height: 2em;
            //border-right: 1px solid #000000;
            background: #222222;

            position: fixed;
            left: 0;
            top: 0;
        }
        .scm__label {
            color: #cccccc;
            font-size: 1em;

            position: fixed;
            left: 1em;
            top: 0.5em;
        }

        .scm__label .scm__label__value {
            color: #eeeeee;
            font-weight: bold;
        }
    </style>

    global.window.scm = this;

    var scs = new SocialCapitalStore();
    this.capital = Math.floor(scs.get() * 100);
    scs.on("change", function(){
        this.update()
    }.bind(this));

    this.on('update', function(){
        //  console.log(this.scm__bar.style
        this.capital = Math.floor(scs.get() * 100);
        this.root.querySelector('.scm__bar').style.width = this.capital + "%";
        this.deltaPerSecond = Math.floor(scs.resentmentPerSecond() * 100);
    }.bind(this))

</social-capital-meter>
