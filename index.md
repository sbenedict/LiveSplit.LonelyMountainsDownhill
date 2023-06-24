# LiveSplit - Lonely Mountains: Downhill
An Auto Splitting Script (ASL) and splits files (LSS) for LiveSplit that splits Lonely Mountains: Downhill.

---

Autosplit Script (ASL file): 
- [lmd.asl](autosplit/lmd.asl)

---

Splits (LSS files):
- all moutains
   - [by trail](splits/en/Lonely%20Mountains%20Downhill%20by%20trail.lss)
   - [by checkpoint](splits/en/Lonely%20Mountains%20Downhill%20by%20checkpoint.lss)
- per mountain by checkpoint
   - [Graterhorn](splits/en/Lonely%20Mountains%20Downhill%20-%20Graterhorn.lss)
   - [Redmoor Peaks](splits/en/Lonely%20Mountains%20Downhill%20-%20Redmoor%20Peaks.lss)
   - [Sierra Rivera](splits/en/Lonely%20Mountains%20Downhill%20-%20Sierra%20Rivera.lss)
   - [Mount Riley](splits/en/Lonely%20Mountains%20Downhill%20-%20Mount%20Riley.lss)


<script defer>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
      (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
      ga('create', 'UA-153178211-1', 'auto');
      //ga('require', 'linkid');
      ga('send', 'pageview');
      
      // setup download tracking
      document.querySelectorAll("a[href $= '.lss'], a[href $= '.asl']")
        .forEach(x => {
            x.addEventListener('click', e => {
                var page = new URL(e.target.href).pathname;
                var title = decodeURI(page.substring(page.lastIndexOf("/") + 1));
                ga('send', {
                    hitType: 'pageview',
                    page: page,
                    title: title
                });
            });
        });
</script>
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-B8FBFX1JBJ"></script>
<script defer>
   window.dataLayer = window.dataLayer || [];
   function gtag(){dataLayer.push(arguments);}
   gtag('js', new Date());

   gtag('config', 'G-B8FBFX1JBJ');
</script>
<!-- End Google tag (gtag.js) -->
