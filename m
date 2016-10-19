From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace hardcoded
 USER_FRIENDLY_NAMES_OFF by default
Date: Wed, 19 Oct 2016 08:08:04 +0200
Message-ID: <CABr-GndTXL79b95r9qnas9x6pmtmi3Y8O6APfuCROH9qUnzLrg@mail.gmail.com>
References: <20161018132245.3061-1-xose.vazquez@gmail.com>
	<20161018170327.GO1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1578769248794013216=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161018170327.GO1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============1578769248794013216==
Content-Type: multipart/alternative; boundary=94eb2c0c8ea2e50fb6053f31a1e1

--94eb2c0c8ea2e50fb6053f31a1e1
Content-Type: text/plain; charset=UTF-8

Merged.

On Tue, Oct 18, 2016 at 7:03 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> On Tue, Oct 18, 2016 at 03:22:45PM +0200, Xose Vazquez Perez wrote:
>
> ACK
>
> -Ben
>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  libmultipath/defaults.h | 1 +
> >  libmultipath/propsel.c  | 2 +-
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> > index d00a86f..e9581a6 100644
> > --- a/libmultipath/defaults.h
> > +++ b/libmultipath/defaults.h
> > @@ -32,6 +32,7 @@
> >  #define DEFAULT_PRIO_ARGS    ""
> >  #define DEFAULT_CHECKER              TUR
> >  #define DEFAULT_FLUSH                FLUSH_DISABLED
> > +#define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF
> >
> >  #define DEFAULT_CHECKINT     5
> >  #define MAX_CHECKINT(a)              (a << 2)
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 88a1916..aaf99fb 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -228,7 +228,7 @@ want_user_friendly_names(struct config *conf,
> struct multipath * mp)
> >              "(controller setting)");
> >       do_set(user_friendly_names, conf, user_friendly_names,
> >              "(config file setting)");
> > -     do_default(user_friendly_names, USER_FRIENDLY_NAMES_OFF);
> > +     do_default(user_friendly_names, DEFAULT_USER_FRIENDLY_NAMES);
> >  out:
> >       condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
> >               (user_friendly_names == USER_FRIENDLY_NAMES_ON)? "yes" :
> "no",
> > --
> > 2.10.1
>

--94eb2c0c8ea2e50fb6053f31a1e1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Tue, Oct 18, 2016 at 7:03 PM, Benjamin Marzinski <span dir=
=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_blank">bmarz=
ins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On T=
ue, Oct 18, 2016 at 03:22:45PM +0200, Xose Vazquez Perez wrote:<br>
<br>
ACK<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Cc: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmar=
zins@redhat.com</a>&gt;<br>
&gt; Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</=
a>&gt;<br>
&gt; Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensv=
c.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
&gt; Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.co=
m">dm-devel@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@g=
mail.com">xose.vazquez@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libmultipath/defaults.h | 1 +<br>
&gt;=C2=A0 libmultipath/propsel.c=C2=A0 | 2 +-<br>
&gt;=C2=A0 2 files changed, 2 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h<br>
&gt; index d00a86f..e9581a6 100644<br>
&gt; --- a/libmultipath/defaults.h<br>
&gt; +++ b/libmultipath/defaults.h<br>
&gt; @@ -32,6 +32,7 @@<br>
&gt;=C2=A0 #define DEFAULT_PRIO_ARGS=C2=A0 =C2=A0 &quot;&quot;<br>
&gt;=C2=A0 #define DEFAULT_CHECKER=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 TUR<br>
&gt;=C2=A0 #define DEFAULT_FLUSH=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 FLUSH_DISABLED<br>
&gt; +#define DEFAULT_USER_FRIENDLY_NAMES USER_FRIENDLY_NAMES_OFF<br>
&gt;<br>
&gt;=C2=A0 #define DEFAULT_CHECKINT=C2=A0 =C2=A0 =C2=A05<br>
&gt;=C2=A0 #define MAX_CHECKINT(a)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (a &lt;&lt; 2)<br>
&gt; diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
&gt; index 88a1916..aaf99fb 100644<br>
&gt; --- a/libmultipath/propsel.c<br>
&gt; +++ b/libmultipath/propsel.c<br>
&gt; @@ -228,7 +228,7 @@ want_user_friendly_names(<wbr>struct config *conf,=
 struct multipath * mp)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;(controller sett=
ing)&quot;);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, conf, user_frien=
dly_names,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;(config file set=
ting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0do_default(user_friendly_<wbr>names, USER_FRIENDL=
Y_NAMES_OFF);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0do_default(user_friendly_<wbr>names, DEFAULT_USER=
_FRIENDLY_NAMES);<br>
&gt;=C2=A0 out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: user_friendly_names =3D=
 %s %s&quot;, mp-&gt;wwid,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(user_friendly_n=
ames =3D=3D USER_FRIENDLY_NAMES_ON)? &quot;yes&quot; : &quot;no&quot;,<br>
&gt; --<br>
&gt; 2.10.1<br>
</div></div></blockquote></div><br></div>

--94eb2c0c8ea2e50fb6053f31a1e1--


--===============1578769248794013216==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1578769248794013216==--
