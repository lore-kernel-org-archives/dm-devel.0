From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 10/15] multipath: blacklist virtio-blk devices
Date: Sun, 8 Mar 2015 11:33:38 +0100
Message-ID: <CABr-GncMe=qP=6MiDfLt6KAe0AQEByHZzEqfZ-W2i3crgEEDAQ@mail.gmail.com>
References: <54FC235D.2060500@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2615039079645166447=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54FC235D.2060500@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============2615039079645166447==
Content-Type: multipart/alternative; boundary=001a114225f254e35b0510c473fd

--001a114225f254e35b0510c473fd
Content-Type: text/plain; charset=UTF-8

Hi Xose,

it sure wouldn't hurt, be as there is no trailing "$" I guess the pattern
does its job as-is.
Please let me know if I'm reading this wrong.

Best regards,
Christophe Varoqui
OpenSVC

On Sun, Mar 8, 2015 at 11:24 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Benjamin Marzinski wrote:
>
> > virtio-blk devices don't report anything to use as a WWID, so
> > multipath shouldn't waste it's time checking them.
> >
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/blacklist.c | 2 +-
> >  multipath.conf.defaults  | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> > index 05f1697..cea128c 100644
> > --- a/libmultipath/blacklist.c
> > +++ b/libmultipath/blacklist.c
> > @@ -178,7 +178,7 @@ setup_default_blist (struct config * conf)
> >       if (store_ble(conf->blist_devnode, str, ORIGIN_DEFAULT))
> >               return 1;
> >
> > -     str = STRDUP("^(td|hd)[a-z]");
> > +     str = STRDUP("^(td|hd|vd)[a-z]");
>                                       ^
>                                       Missing "*" ?
>

--001a114225f254e35b0510c473fd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Xose,<div><br></div><div>it sure wouldn&#39;t hurt, be =
as there is no trailing &quot;$&quot; I guess the pattern does its job as-i=
s.</div><div>Please let me know if I&#39;m reading this wrong.</div><div><b=
r></div><div>Best regards,</div><div>Christophe Varoqui</div><div>OpenSVC</=
div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Sun,=
 Mar 8, 2015 at 11:24 AM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=
=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com=
</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">B=
enjamin Marzinski wrote:<br>
<br>
&gt; virtio-blk devices don&#39;t report anything to use as a WWID, so<br>
&gt; multipath shouldn&#39;t waste it&#39;s time checking them.<br>
&gt;<br>
&gt; Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redha=
t.com">bmarzins@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/blacklist.c | 2 +-<br>
&gt;=C2=A0 multipath.conf.defaults=C2=A0 | 2 +-<br>
&gt;=C2=A0 2 files changed, 2 insertions(+), 2 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c<br>
&gt; index 05f1697..cea128c 100644<br>
&gt; --- a/libmultipath/blacklist.c<br>
&gt; +++ b/libmultipath/blacklist.c<br>
&gt; @@ -178,7 +178,7 @@ setup_default_blist (struct config * conf)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (store_ble(conf-&gt;blist_devnode, str, O=
RIGIN_DEFAULT))<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(td|hd)[a-z]&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0str =3D STRDUP(&quot;^(td|hd|vd)[a-z]&quot;);<br>
</span>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Missing &quot;*=
&quot; ?<br>
</blockquote></div><br></div>

--001a114225f254e35b0510c473fd--


--===============2615039079645166447==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2615039079645166447==--
