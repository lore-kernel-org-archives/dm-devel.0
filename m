From: Lukas Herbolt <lherbolt@redhat.com>
Subject: Re: dm-flakey NOT to return -EIO on READ?
Date: Fri, 29 Jul 2016 08:25:50 +0200
Message-ID: <CAM4Jq_7WWFsviFXeAYa5gd_wrL73Fuz0goXbzG7Q-dYujkh1ag@mail.gmail.com>
References: <217a0cf8-4853-6316-3016-77460073061d@gmail.com>
	<CAM4Jq_5kBs2WKNOiLrVL8XMTSJQhPdvO-XKROhzpLXdOATFw7w@mail.gmail.com>
	<07b6affb-a09d-7d55-65f8-6d476a5471aa@gmail.com>
	<f059f3f1-a860-aee5-20b7-d6b3ed6b467d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1290401401865102504=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f059f3f1-a860-aee5-20b7-d6b3ed6b467d@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1290401401865102504==
Content-Type: multipart/alternative; boundary=001a11441dd869464f0538c0529b

--001a11441dd869464f0538c0529b
Content-Type: text/plain; charset=UTF-8

Hi Akira,
Sorry I was on holiday.
I have patch ready, would you be able to test it before posting it.

Let me know if I should build the kernel for you or just share the source
with you.

Lukas

On Sun, Jul 17, 2016 at 3:36 AM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> > On 2016/07/06 18:52, Lukas Herbolt wrote:
> >> Hi,
> >> Yes this part is wrong and reads are not dropped.
> >> I have a patch ready, just have to send it out.
>
> btw, is this fix going to be included in the next release?
>
> On 2016/07/06 21:54, Akira Hayakawa wrote:
> > Thanks,
> >
> > I want the patch in the main-tree quickly.
> > Because without it, my tests will not be green.
> > This is really annoying.
> >
> > I made a quick reproducer of this problem.
> > If you are looking for one, this will help.
> > (You need to install sbt first)
> >
> > https://github.com/akiradeveloper/writeboost-test-suite
> >
> >   test("flakey (read)") {
> >     Memory(Sector.M(16)) { a =>
> >       Flakey.Table(a, 0, 1).create { b =>
> >         intercept[Exception] {
> >           Shell(s"dd status=none if=${b.bdev.path} iflag=direct
> of=/dev/null")
> >         }
> >       }
> >     }
> >   }
> >
> > $ sudo sbt "testOnly dmtest.FlakeyTest"
> > 12:44:00.643 [pool-2-thread-3-ScalaTest-running-FlakeyTest] INFO dmtest
> - [TEST] flakey (read)
> > 12:44:00.752 [pool-2-thread-3-ScalaTest-running-FlakeyTest] DEBUG dmtest
> - reload: table=0 32768 flakey /dev/loop0 0 0 1
> > [info] FlakeyTest:
> > [info] - flakey (read) *** FAILED ***
> > [info]   Expected exception java.lang.Exception to be thrown, but no
> exception was thrown. (FlakeyTest.scala:9)
> > [info] Run completed in 2 seconds, 781 milliseconds.
> > [info] Total number of tests run: 1
> > [info] Suites: completed 1, aborted 0
> > [info] Tests: succeeded 0, failed 1, canceled 0, ignored 0, pending 0
> >
> > - Akira
> >
> > On 2016/07/06 18:52, Lukas Herbolt wrote:
> >> Hi,
> >> Yes this part is wrong and reads are not dropped.
> >> I have a patch ready, just have to send it out.
> >>
> >> Lukas
> >>
> >> On Wed, Jul 6, 2016 at 8:33 AM, Akira Hayakawa <ruby.wktk@gmail.com>
> wrote:
> >>
> >>> Hi,
> >>>
> >>> I am using dm-flakey to emulate a broken device that should return
> -EIO on
> >>> both read and write.
> >>> I use the parameter up_interval=0 and down_interval=1.
> >>>
> >>> But when I am dd-ing the flakey device, while write fails, read
> succeeds.
> >>> This isn't the behavior I expect.
> >>>
> >>> Then I looked into the code.
> >>>
> >>> 326 static int flakey_end_io(struct dm_target *ti, struct bio *bio, int
> >>> error)
> >>> 327 {
> >>> 328         struct flakey_c *fc = ti->private;
> >>> 329         struct per_bio_data *pb = dm_per_bio_data(bio,
> sizeof(struct
> >>> per_bio_data));
> >>> 330
> >>> 331         /*
> >>> 332          * Corrupt successful READs while in down state.
> >>> 333          * If flags were specified, only corrupt those that match.
> >>> 334          */
> >>> 335         if (fc->corrupt_bio_byte && !error && pb->bio_submitted &&
> >>> 336             (bio_data_dir(bio) == READ) && (fc->corrupt_bio_rw ==
> >>> READ) &&
> >>> 337             all_corrupt_bio_flags_match(bio, fc))
> >>> 338                 corrupt_bio_data(bio, fc);
> >>> 339
> >>> 340         return error;
> >>> 341 }
> >>>
> >>> When the bio direction is READ and currupt_bio_bytes isn't specified
> >>> the READ bio is handled normally right?
> >>>
> >>> I think READ requests should return -EIO if
> >>>
> >>> 1. corrupt_bio_bytes isn't specified
> >>> 2. but the requested is handled during down interval.
> >>>
> >>> as well as WRITE requests:
> >>>
> >>> 305                 /*
> >>> 306                  * Corrupt matching writes.
> >>> 307                  */
> >>> 308                 if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw ==
> >>> WRITE)) {
> >>> 309                         if (all_corrupt_bio_flags_match(bio, fc))
> >>> 310                                 corrupt_bio_data(bio, fc);
> >>> 311                         goto map_bio;
> >>> 312                 }
> >>> 313
> >>> 314                 /*
> >>> 315                  * By default, error all I/O.
> >>> 316                  */
> >>> 317                 return -EIO;
> >>> 318         }
> >>>
> >>> This code is similar to what we see in the end_io.
> >>>
> >>> If my understanding is correct, I would like to modify dm-flakey to
> return
> >>> -EIO in the end_io.
> >>>
> >>> I would like to request for comments.
> >>>
> >>> Thanks,
> >>>
> >>> - Akira
> >>>
> >>> --
> >>> dm-devel mailing list
> >>> dm-devel@redhat.com
> >>> https://www.redhat.com/mailman/listinfo/dm-devel
> >>>
> >>
> >>
> >>
>



-- 
Lukas Herbolt
RHCE, RH436, BSc, SSc
Senior Technical Support Engineer
Global Support Services (GSS)
Email:    lherbolt@redhat.com

--001a11441dd869464f0538c0529b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:monospac=
e,monospace">Hi Akira,</div><div class=3D"gmail_default" style=3D"font-fami=
ly:monospace,monospace">Sorry I was on holiday.</div><div class=3D"gmail_de=
fault" style=3D"font-family:monospace,monospace">I have patch ready, would =
you be able to test it before posting it.</div><div class=3D"gmail_default"=
 style=3D"font-family:monospace,monospace"><br></div><div class=3D"gmail_de=
fault" style=3D"font-family:monospace,monospace">Let me know if I should bu=
ild the kernel for you or just share the source with you.=C2=A0</div><div c=
lass=3D"gmail_default" style=3D"font-family:monospace,monospace"><br></div>=
<div class=3D"gmail_default" style=3D"font-family:monospace,monospace">Luka=
s</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On S=
un, Jul 17, 2016 at 3:36 AM, Akira Hayakawa <span dir=3D"ltr">&lt;<a href=
=3D"mailto:ruby.wktk@gmail.com" target=3D"_blank">ruby.wktk@gmail.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">&gt; On=
 2016/07/06 18:52, Lukas Herbolt wrote:<br>
&gt;&gt; Hi,<br>
&gt;&gt; Yes this part is wrong and reads are not dropped.<br>
&gt;&gt; I have a patch ready, just have to send it out.<br>
<br>
</span>btw, is this fix going to be included in the next release?<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
On 2016/07/06 21:54, Akira Hayakawa wrote:<br>
&gt; Thanks,<br>
&gt;<br>
&gt; I want the patch in the main-tree quickly.<br>
&gt; Because without it, my tests will not be green.<br>
&gt; This is really annoying.<br>
&gt;<br>
&gt; I made a quick reproducer of this problem.<br>
&gt; If you are looking for one, this will help.<br>
&gt; (You need to install sbt first)<br>
&gt;<br>
&gt; <a href=3D"https://github.com/akiradeveloper/writeboost-test-suite" re=
l=3D"noreferrer" target=3D"_blank">https://github.com/akiradeveloper/writeb=
oost-test-suite</a><br>
&gt;<br>
&gt;=C2=A0 =C2=A0test(&quot;flakey (read)&quot;) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0Memory(Sector.M(16)) { a =3D&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0Flakey.Table(a, 0, 1).create { b =3D&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0intercept[Exception] {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Shell(s&quot;dd status=3Dnone =
if=3D${b.bdev.path} iflag=3Ddirect of=3D/dev/null&quot;)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0}<br>
&gt;<br>
&gt; $ sudo sbt &quot;testOnly dmtest.FlakeyTest&quot;<br>
&gt; 12:44:00.643 [pool-2-thread-3-ScalaTest-running-FlakeyTest] INFO dmtes=
t - [TEST] flakey (read)<br>
&gt; 12:44:00.752 [pool-2-thread-3-ScalaTest-running-FlakeyTest] DEBUG dmte=
st - reload: table=3D0 32768 flakey /dev/loop0 0 0 1<br>
&gt; [info] FlakeyTest:<br>
&gt; [info] - flakey (read) *** FAILED ***<br>
&gt; [info]=C2=A0 =C2=A0Expected exception java.lang.Exception to be thrown=
, but no exception was thrown. (FlakeyTest.scala:9)<br>
&gt; [info] Run completed in 2 seconds, 781 milliseconds.<br>
&gt; [info] Total number of tests run: 1<br>
&gt; [info] Suites: completed 1, aborted 0<br>
&gt; [info] Tests: succeeded 0, failed 1, canceled 0, ignored 0, pending 0<=
br>
&gt;<br>
&gt; - Akira<br>
&gt;<br>
&gt; On 2016/07/06 18:52, Lukas Herbolt wrote:<br>
&gt;&gt; Hi,<br>
&gt;&gt; Yes this part is wrong and reads are not dropped.<br>
&gt;&gt; I have a patch ready, just have to send it out.<br>
&gt;&gt;<br>
&gt;&gt; Lukas<br>
&gt;&gt;<br>
&gt;&gt; On Wed, Jul 6, 2016 at 8:33 AM, Akira Hayakawa &lt;<a href=3D"mail=
to:ruby.wktk@gmail.com">ruby.wktk@gmail.com</a>&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt;&gt; Hi,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I am using dm-flakey to emulate a broken device that should re=
turn -EIO on<br>
&gt;&gt;&gt; both read and write.<br>
&gt;&gt;&gt; I use the parameter up_interval=3D0 and down_interval=3D1.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; But when I am dd-ing the flakey device, while write fails, rea=
d succeeds.<br>
&gt;&gt;&gt; This isn&#39;t the behavior I expect.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Then I looked into the code.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; 326 static int flakey_end_io(struct dm_target *ti, struct bio =
*bio, int<br>
&gt;&gt;&gt; error)<br>
&gt;&gt;&gt; 327 {<br>
&gt;&gt;&gt; 328=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct flakey_c *fc =3D t=
i-&gt;private;<br>
&gt;&gt;&gt; 329=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct per_bio_data *pb =
=3D dm_per_bio_data(bio, sizeof(struct<br>
&gt;&gt;&gt; per_bio_data));<br>
&gt;&gt;&gt; 330<br>
&gt;&gt;&gt; 331=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;&gt;&gt; 332=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Corrupt successful REA=
Ds while in down state.<br>
&gt;&gt;&gt; 333=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If flags were specifie=
d, only corrupt those that match.<br>
&gt;&gt;&gt; 334=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;&gt;&gt; 335=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fc-&gt;corrupt_bio_by=
te &amp;&amp; !error &amp;&amp; pb-&gt;bio_submitted &amp;&amp;<br>
&gt;&gt;&gt; 336=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(bio_data_d=
ir(bio) =3D=3D READ) &amp;&amp; (fc-&gt;corrupt_bio_rw =3D=3D<br>
&gt;&gt;&gt; READ) &amp;&amp;<br>
&gt;&gt;&gt; 337=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0all_corrupt=
_bio_flags_match(bio, fc))<br>
&gt;&gt;&gt; 338=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0corrupt_bio_data(bio, fc);<br>
&gt;&gt;&gt; 339<br>
&gt;&gt;&gt; 340=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return error;<br>
&gt;&gt;&gt; 341 }<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; When the bio direction is READ and currupt_bio_bytes isn&#39;t=
 specified<br>
&gt;&gt;&gt; the READ bio is handled normally right?<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I think READ requests should return -EIO if<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; 1. corrupt_bio_bytes isn&#39;t specified<br>
&gt;&gt;&gt; 2. but the requested is handled during down interval.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; as well as WRITE requests:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; 305=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/*<br>
&gt;&gt;&gt; 306=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * Corrupt matching writes.<br>
&gt;&gt;&gt; 307=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 */<br>
&gt;&gt;&gt; 308=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0if (fc-&gt;corrupt_bio_byte &amp;&amp; (fc-&gt;corrupt_bio_rw =3D=3D<br>
&gt;&gt;&gt; WRITE)) {<br>
&gt;&gt;&gt; 309=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (all_corrupt_bio_flags_match(bio, fc))<br=
>
&gt;&gt;&gt; 310=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0corrupt_bio_data=
(bio, fc);<br>
&gt;&gt;&gt; 311=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto map_bio;<br>
&gt;&gt;&gt; 312=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0}<br>
&gt;&gt;&gt; 313<br>
&gt;&gt;&gt; 314=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0/*<br>
&gt;&gt;&gt; 315=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 * By default, error all I/O.<br>
&gt;&gt;&gt; 316=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 */<br>
&gt;&gt;&gt; 317=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0return -EIO;<br>
&gt;&gt;&gt; 318=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; This code is similar to what we see in the end_io.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; If my understanding is correct, I would like to modify dm-flak=
ey to return<br>
&gt;&gt;&gt; -EIO in the end_io.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I would like to request for comments.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Thanks,<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; - Akira<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; --<br>
&gt;&gt;&gt; dm-devel mailing list<br>
&gt;&gt;&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>=
<br>
&gt;&gt;&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" r=
el=3D"noreferrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo=
/dm-devel</a><br>
&gt;&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt;<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=
=3D"ltr"><div><div dir=3D"ltr"><div dir=3D"ltr"><div><span style=3D"font-fa=
mily:monospace,monospace;font-size:12.8px">Lukas Herbolt</span><br></div><d=
iv><font face=3D"monospace, monospace">RHCE, RH436, BSc, SSc</font></div><d=
iv><font face=3D"monospace, monospace">Senior Technical Support Engineer</f=
ont></div><div><font face=3D"monospace, monospace">Global Support Services =
(GSS)</font></div><div><font face=3D"monospace, monospace">Email: =C2=A0 =
=C2=A0<a href=3D"mailto:lherbolt@redhat.com" target=3D"_blank">lherbolt@red=
hat.com</a></font></div><div><br></div></div></div></div></div></div>
</div>

--001a11441dd869464f0538c0529b--


--===============1290401401865102504==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1290401401865102504==--
