From: Lukas Herbolt <lherbolt@redhat.com>
Subject: Re: dm-flakey NOT to return -EIO on READ?
Date: Fri, 29 Jul 2016 20:00:33 +0200
Message-ID: <CAM4Jq_7Fi0Ue-_x1-5o0MqzxTfRKCb4YZSNo3p5Ef3rPjQjPfQ@mail.gmail.com>
References: <217a0cf8-4853-6316-3016-77460073061d@gmail.com>
	<CAM4Jq_5kBs2WKNOiLrVL8XMTSJQhPdvO-XKROhzpLXdOATFw7w@mail.gmail.com>
	<07b6affb-a09d-7d55-65f8-6d476a5471aa@gmail.com>
	<f059f3f1-a860-aee5-20b7-d6b3ed6b467d@gmail.com>
	<CAM4Jq_7WWFsviFXeAYa5gd_wrL73Fuz0goXbzG7Q-dYujkh1ag@mail.gmail.com>
	<0dc69d8f-1595-1677-5028-f920d7b54eb0@gmail.com>
	<CAM4Jq_4+RuRppTQXDBkp7Kg4tRV52pwcfEfm5HZtC88h0v-aWw@mail.gmail.com>
	<20160729143542.GA19246@redhat.com> <20160729173012.GA88908@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5724191652800612531=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160729173012.GA88908@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Akira Hayakawa <ruby.wktk@gmail.com>
List-Id: dm-devel.ids

--===============5724191652800612531==
Content-Type: multipart/alternative; boundary=001a113a1b2aede7460538ca06dd

--001a113a1b2aede7460538ca06dd
Content-Type: text/plain; charset=UTF-8

Thanks Mike for fixing.
This was my first attempt to fix something in kernel so I wasn't sure about
the patch itself.
 - Lukas

On Fri, Jul 29, 2016 at 7:30 PM, Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Jul 29 2016 at 10:35am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
> > On Fri, Jul 29 2016 at 10:31am -0400,
> > Lukas Herbolt <lherbolt@redhat.com> wrote:
> >
> > >  - http://people.redhat.com/~lherbolt/dm-flakey/v4.7-dm_flakey.tar.gz
> > >
> > > Lukas
> >
> > Please post an incremental patch relative to 4.7 or latest Linus
> > kernel.  Don't make people suffer with tarballs of whatever you've
> > packaged above.
>
> I pulled out your incremental diff.  Your proposed fix isn't correct.  It
> breaks the corrupt_bio_byte feature.  We cannot blindly drop reads early
> in flakey_map(), like you've proposed, because the corrupt_bio_byte
> feature relies on corrupt data being returned on read during the
> down_interval.
>
> The issue reported is: reads aren't dropped during the "down_interval".
>
> I do agree that this needs fixing, and it was commit a3998799fb4df ("dm
> flakey: add corrupt_bio_byte feature") that caused this regression.
>
> But a fix must not break the corrupt_bio_byte feature.
>
> This fix should resolve the problem, I'll be staging it to go upstream
> during the 4.8-rc cycle (Akira, please test to verify your test fails as
> expected now):
>
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Fri, 29 Jul 2016 13:19:55 -0400
> Subject: [PATCH] dm flakey: error READ bios during the down_interval
>
> When the corrupt_bio_byte feature was introduced it caused READ bios to
> no longer be errored with -EIO during the down_interval.  This had to do
> with the complexity of needing to submit READs if the corrupt_bio_byte
> feature was used.
>
> Fix it so READ bios are properly errored with -EIO; doing so early in
> flakey_map() as long as there isn't a match for the corrupt_bio_byte
> feature.
>
> Fixes: a3998799fb4df ("dm flakey: add corrupt_bio_byte feature")
> Reported-by: Akira Hayakawa <ruby.wktk@gmail.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/md/dm-flakey.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index 29b99fb..19db13e 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -289,10 +289,16 @@ static int flakey_map(struct dm_target *ti, struct
> bio *bio)
>                 pb->bio_submitted = true;
>
>                 /*
> -                * Map reads as normal.
> +                * Map reads as normal only if corrupt_bio_byte set.
>                  */
> -               if (bio_data_dir(bio) == READ)
> -                       goto map_bio;
> +               if (bio_data_dir(bio) == READ) {
> +                       /* If flags were specified, only corrupt those
> that match. */
> +                       if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw ==
> READ) &&
> +                           all_corrupt_bio_flags_match(bio, fc))
> +                               goto map_bio;
> +                       else
> +                               return -EIO;
> +               }
>
>                 /*
>                  * Drop writes?
> @@ -330,12 +336,13 @@ static int flakey_end_io(struct dm_target *ti,
> struct bio *bio, int error)
>
>         /*
>          * Corrupt successful READs while in down state.
> -        * If flags were specified, only corrupt those that match.
>          */
> -       if (fc->corrupt_bio_byte && !error && pb->bio_submitted &&
> -           (bio_data_dir(bio) == READ) && (fc->corrupt_bio_rw == READ) &&
> -           all_corrupt_bio_flags_match(bio, fc))
> -               corrupt_bio_data(bio, fc);
> +       if (!error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
> +               if (fc->corrupt_bio_byte)
> +                       corrupt_bio_data(bio, fc);
> +               else
> +                       return -EIO;
> +       }
>
>         return error;
>  }
> --
> 2.7.4 (Apple Git-66)
>
>


-- 
Lukas Herbolt
RHCE, RH436, BSc, SSc
Senior Technical Support Engineer
Global Support Services (GSS)
Email:    lherbolt@redhat.com

--001a113a1b2aede7460538ca06dd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:monospac=
e,monospace">Thanks Mike for fixing.=C2=A0</div><div class=3D"gmail_default=
" style=3D"font-family:monospace,monospace">This was my first attempt to fi=
x something in kernel so I wasn&#39;t sure about the patch itself.</div><di=
v class=3D"gmail_default" style=3D"font-family:monospace,monospace">=C2=A0-=
 Lukas</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote"=
>On Fri, Jul 29, 2016 at 7:30 PM, Mike Snitzer <span dir=3D"ltr">&lt;<a hre=
f=3D"mailto:snitzer@redhat.com" target=3D"_blank">snitzer@redhat.com</a>&gt=
;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Fri, =
Jul 29 2016 at 10:35am -0400,<br>
Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com">snitzer@redhat.com</=
a>&gt; wrote:<br>
<br>
&gt; On Fri, Jul 29 2016 at 10:31am -0400,<br>
&gt; Lukas Herbolt &lt;<a href=3D"mailto:lherbolt@redhat.com">lherbolt@redh=
at.com</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt;=C2=A0 - <a href=3D"http://people.redhat.com/~lherbolt/dm-flakey/v=
4.7-dm_flakey.tar.gz" rel=3D"noreferrer" target=3D"_blank">http://people.re=
dhat.com/~lherbolt/dm-flakey/v4.7-dm_flakey.tar.gz</a><br>
&gt; &gt;<br>
&gt; &gt; Lukas<br>
&gt;<br>
&gt; Please post an incremental patch relative to 4.7 or latest Linus<br>
&gt; kernel.=C2=A0 Don&#39;t make people suffer with tarballs of whatever y=
ou&#39;ve<br>
&gt; packaged above.<br>
<br>
</span>I pulled out your incremental diff.=C2=A0 Your proposed fix isn&#39;=
t correct.=C2=A0 It<br>
breaks the corrupt_bio_byte feature.=C2=A0 We cannot blindly drop reads ear=
ly<br>
in flakey_map(), like you&#39;ve proposed, because the corrupt_bio_byte<br>
feature relies on corrupt data being returned on read during the<br>
down_interval.<br>
<br>
The issue reported is: reads aren&#39;t dropped during the &quot;down_inter=
val&quot;.<br>
<br>
I do agree that this needs fixing, and it was commit a3998799fb4df (&quot;d=
m<br>
flakey: add corrupt_bio_byte feature&quot;) that caused this regression.<br=
>
<br>
But a fix must not break the corrupt_bio_byte feature.<br>
<br>
This fix should resolve the problem, I&#39;ll be staging it to go upstream<=
br>
during the 4.8-rc cycle (Akira, please test to verify your test fails as<br=
>
expected now):<br>
<br>
From: Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com">snitzer@redhat=
.com</a>&gt;<br>
Date: Fri, 29 Jul 2016 13:19:55 -0400<br>
Subject: [PATCH] dm flakey: error READ bios during the down_interval<br>
<br>
When the corrupt_bio_byte feature was introduced it caused READ bios to<br>
no longer be errored with -EIO during the down_interval.=C2=A0 This had to =
do<br>
with the complexity of needing to submit READs if the corrupt_bio_byte<br>
feature was used.<br>
<br>
Fix it so READ bios are properly errored with -EIO; doing so early in<br>
flakey_map() as long as there isn&#39;t a match for the corrupt_bio_byte<br=
>
feature.<br>
<br>
Fixes: a3998799fb4df (&quot;dm flakey: add corrupt_bio_byte feature&quot;)<=
br>
Reported-by: Akira Hayakawa &lt;<a href=3D"mailto:ruby.wktk@gmail.com">ruby=
.wktk@gmail.com</a>&gt;<br>
Signed-off-by: Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com">snitz=
er@redhat.com</a>&gt;<br>
Cc: <a href=3D"mailto:stable@vger.kernel.org">stable@vger.kernel.org</a><br=
>
---<br>
=C2=A0drivers/md/dm-flakey.c | 23 +++++++++++++++--------<br>
=C2=A01 file changed, 15 insertions(+), 8 deletions(-)<br>
<br>
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c<br>
index 29b99fb..19db13e 100644<br>
--- a/drivers/md/dm-flakey.c<br>
+++ b/drivers/md/dm-flakey.c<br>
@@ -289,10 +289,16 @@ static int flakey_map(struct dm_target *ti, struct bi=
o *bio)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pb-&gt;bio_submitte=
d =3D true;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Map reads as nor=
mal.<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Map reads as nor=
mal only if corrupt_bio_byte set.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bio_data_dir(bi=
o) =3D=3D READ)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0goto map_bio;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (bio_data_dir(bi=
o) =3D=3D READ) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0/* If flags were specified, only corrupt those that match. */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (fc-&gt;corrupt_bio_byte &amp;&amp; (fc-&gt;corrupt_bio_rw =3D=
=3D READ) &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0all_corrupt_bio_flags_match(bio, fc))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto map_bio;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EIO;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Drop writes=
?<br>
@@ -330,12 +336,13 @@ static int flakey_end_io(struct dm_target *ti, struct=
 bio *bio, int error)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
<span class=3D"">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Corrupt successful REA=
Ds while in down state.<br>
</span>-=C2=A0 =C2=A0 =C2=A0 =C2=A0 * If flags were specified, only corrupt=
 those that match.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (fc-&gt;corrupt_bio_byte &amp;&amp; !error &=
amp;&amp; pb-&gt;bio_submitted &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(bio_data_dir(bio) =3D=3D READ) &=
amp;&amp; (fc-&gt;corrupt_bio_rw =3D=3D READ) &amp;&amp;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0all_corrupt_bio_flags_match(bio, =
fc))<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0corrupt_bio_data(bi=
o, fc);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!error &amp;&amp; pb-&gt;bio_submitted &amp=
;&amp; (bio_data_dir(bio) =3D=3D READ)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (fc-&gt;corrupt_=
bio_byte)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0corrupt_bio_data(bio, fc);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0else<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0return -EIO;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return error;<br>
=C2=A0}<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4 (Apple Git-66)<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div di=
r=3D"ltr"><div><div dir=3D"ltr"><div dir=3D"ltr"><div><span style=3D"font-f=
amily:monospace,monospace;font-size:12.8px">Lukas Herbolt</span><br></div><=
div><font face=3D"monospace, monospace">RHCE, RH436, BSc, SSc</font></div><=
div><font face=3D"monospace, monospace">Senior Technical Support Engineer</=
font></div><div><font face=3D"monospace, monospace">Global Support Services=
 (GSS)</font></div><div><font face=3D"monospace, monospace">Email: =C2=A0 =
=C2=A0<a href=3D"mailto:lherbolt@redhat.com" target=3D"_blank">lherbolt@red=
hat.com</a></font></div><div><br></div></div></div></div></div></div>
</div>

--001a113a1b2aede7460538ca06dd--


--===============5724191652800612531==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5724191652800612531==--
