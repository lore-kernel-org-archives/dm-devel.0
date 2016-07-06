From: Lukas Herbolt <lherbolt@redhat.com>
Subject: Re: dm-flakey NOT to return -EIO on READ?
Date: Wed, 6 Jul 2016 11:52:50 +0200
Message-ID: <CAM4Jq_5kBs2WKNOiLrVL8XMTSJQhPdvO-XKROhzpLXdOATFw7w@mail.gmail.com>
References: <217a0cf8-4853-6316-3016-77460073061d@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6238848682113240950=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <217a0cf8-4853-6316-3016-77460073061d@gmail.com>
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

--===============6238848682113240950==
Content-Type: multipart/alternative; boundary=001a1149e8e4573bb10536f48817

--001a1149e8e4573bb10536f48817
Content-Type: text/plain; charset=UTF-8

Hi,
Yes this part is wrong and reads are not dropped.
I have a patch ready, just have to send it out.

Lukas

On Wed, Jul 6, 2016 at 8:33 AM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> Hi,
>
> I am using dm-flakey to emulate a broken device that should return -EIO on
> both read and write.
> I use the parameter up_interval=0 and down_interval=1.
>
> But when I am dd-ing the flakey device, while write fails, read succeeds.
> This isn't the behavior I expect.
>
> Then I looked into the code.
>
> 326 static int flakey_end_io(struct dm_target *ti, struct bio *bio, int
> error)
> 327 {
> 328         struct flakey_c *fc = ti->private;
> 329         struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct
> per_bio_data));
> 330
> 331         /*
> 332          * Corrupt successful READs while in down state.
> 333          * If flags were specified, only corrupt those that match.
> 334          */
> 335         if (fc->corrupt_bio_byte && !error && pb->bio_submitted &&
> 336             (bio_data_dir(bio) == READ) && (fc->corrupt_bio_rw ==
> READ) &&
> 337             all_corrupt_bio_flags_match(bio, fc))
> 338                 corrupt_bio_data(bio, fc);
> 339
> 340         return error;
> 341 }
>
> When the bio direction is READ and currupt_bio_bytes isn't specified
> the READ bio is handled normally right?
>
> I think READ requests should return -EIO if
>
> 1. corrupt_bio_bytes isn't specified
> 2. but the requested is handled during down interval.
>
> as well as WRITE requests:
>
> 305                 /*
> 306                  * Corrupt matching writes.
> 307                  */
> 308                 if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw ==
> WRITE)) {
> 309                         if (all_corrupt_bio_flags_match(bio, fc))
> 310                                 corrupt_bio_data(bio, fc);
> 311                         goto map_bio;
> 312                 }
> 313
> 314                 /*
> 315                  * By default, error all I/O.
> 316                  */
> 317                 return -EIO;
> 318         }
>
> This code is similar to what we see in the end_io.
>
> If my understanding is correct, I would like to modify dm-flakey to return
> -EIO in the end_io.
>
> I would like to request for comments.
>
> Thanks,
>
> - Akira
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Lukas Herbolt
RHCE, RH436, BSc, SSc
Senior Technical Support Engineer
Global Support Services (GSS)
Email:    lherbolt@redhat.com

--001a1149e8e4573bb10536f48817
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:monospac=
e,monospace">Hi,</div><div class=3D"gmail_default" style=3D"font-family:mon=
ospace,monospace">Yes this part is wrong and reads are not dropped.</div><d=
iv class=3D"gmail_default" style=3D"font-family:monospace,monospace">I have=
 a patch ready, just have to send it out.</div><div class=3D"gmail_default"=
 style=3D"font-family:monospace,monospace"><br></div><div class=3D"gmail_de=
fault" style=3D"font-family:monospace,monospace">Lukas</div></div><div clas=
s=3D"gmail_extra"><br><div class=3D"gmail_quote">On Wed, Jul 6, 2016 at 8:3=
3 AM, Akira Hayakawa <span dir=3D"ltr">&lt;<a href=3D"mailto:ruby.wktk@gmai=
l.com" target=3D"_blank">ruby.wktk@gmail.com</a>&gt;</span> wrote:<br><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex">Hi,<br>
<br>
I am using dm-flakey to emulate a broken device that should return -EIO on =
both read and write.<br>
I use the parameter up_interval=3D0 and down_interval=3D1.<br>
<br>
But when I am dd-ing the flakey device, while write fails, read succeeds.<b=
r>
This isn&#39;t the behavior I expect.<br>
<br>
Then I looked into the code.<br>
<br>
326 static int flakey_end_io(struct dm_target *ti, struct bio *bio, int err=
or)<br>
327 {<br>
328=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct flakey_c *fc =3D ti-&gt;private=
;<br>
329=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct per_bio_data *pb =3D dm_per_bio=
_data(bio, sizeof(struct per_bio_data));<br>
330<br>
331=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
332=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Corrupt successful READs while in d=
own state.<br>
333=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * If flags were specified, only corru=
pt those that match.<br>
334=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
335=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fc-&gt;corrupt_bio_byte &amp;&amp;=
 !error &amp;&amp; pb-&gt;bio_submitted &amp;&amp;<br>
336=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(bio_data_dir(bio) =3D=
=3D READ) &amp;&amp; (fc-&gt;corrupt_bio_rw =3D=3D READ) &amp;&amp;<br>
337=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0all_corrupt_bio_flags_ma=
tch(bio, fc))<br>
338=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0corrupt_bi=
o_data(bio, fc);<br>
339<br>
340=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return error;<br>
341 }<br>
<br>
When the bio direction is READ and currupt_bio_bytes isn&#39;t specified<br=
>
the READ bio is handled normally right?<br>
<br>
I think READ requests should return -EIO if<br>
<br>
1. corrupt_bio_bytes isn&#39;t specified<br>
2. but the requested is handled during down interval.<br>
<br>
as well as WRITE requests:<br>
<br>
305=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
306=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Corrupt=
 matching writes.<br>
307=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
308=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fc-&gt=
;corrupt_bio_byte &amp;&amp; (fc-&gt;corrupt_bio_rw =3D=3D WRITE)) {<br>
309=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if (all_corrupt_bio_flags_match(bio, fc))<br>
310=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0corrupt_bio_data(bio, fc);<=
br>
311=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0goto map_bio;<br>
312=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
313<br>
314=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
315=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * By defa=
ult, error all I/O.<br>
316=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
317=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EI=
O;<br>
318=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
This code is similar to what we see in the end_io.<br>
<br>
If my understanding is correct, I would like to modify dm-flakey to return =
-EIO in the end_io.<br>
<br>
I would like to request for comments.<br>
<br>
Thanks,<br>
<br>
- Akira<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><d=
iv><div dir=3D"ltr"><div dir=3D"ltr"><div><span style=3D"font-family:monosp=
ace,monospace;font-size:12.8px">Lukas Herbolt</span><br></div><div><font fa=
ce=3D"monospace, monospace">RHCE, RH436, BSc, SSc</font></div><div><font fa=
ce=3D"monospace, monospace">Senior Technical Support Engineer</font></div><=
div><font face=3D"monospace, monospace">Global Support Services (GSS)</font=
></div><div><font face=3D"monospace, monospace">Email: =C2=A0 =C2=A0<a href=
=3D"mailto:lherbolt@redhat.com" target=3D"_blank">lherbolt@redhat.com</a></=
font></div><div><br></div></div></div></div></div></div>
</div>

--001a1149e8e4573bb10536f48817--


--===============6238848682113240950==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6238848682113240950==--
