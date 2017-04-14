From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace multipath
	configuration output
Date: Fri, 14 Apr 2017 10:29:50 +0200
Message-ID: <CABr-GnfmiLVFyJdcb=+bKs+=8mMLu_937LvFmZEMhzqmN7F5+Q@mail.gmail.com>
References: <20170408133042.4478-1-xose.vazquez@gmail.com>
	<CABr-Gnee6+q-wco7662ptvYuUKWHgdQbEC=zFYQCi_cUHGQ+EQ@mail.gmail.com>
	<1b9e3811-796a-7d5b-b217-2224fffe3a36@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1268925734183249485=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1b9e3811-796a-7d5b-b217-2224fffe3a36@gmail.com>
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

--===============1268925734183249485==
Content-Type: multipart/alternative; boundary=001a11c16230c66f23054d1c3e2a

--001a11c16230c66f23054d1c3e2a
Content-Type: text/plain; charset=UTF-8

Right,
pushed now.

Thanks,
Christophe.

On Fri, Apr 14, 2017 at 1:56 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 04/12/2017 09:35 AM, Christophe Varoqui wrote:
>
> > Merged,
>
> No, it's missing.
>
> > On Sat, Apr 8, 2017 at 3:30 PM, Xose Vazquez Perez <
> xose.vazquez@gmail.com <mailto:xose.vazquez@gmail.com>> wrote:
> >
> >     Cc: Christophe Varoqui <christophe.varoqui@opensvc.com <mailto:
> christophe.varoqui@opensvc.com>>
> >     Cc: device-mapper development <dm-devel@redhat.com <mailto:
> dm-devel@redhat.com>>
> >     Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com <mailto:
> xose.vazquez@gmail.com>>
> >     ---
> >      libmultipath/propsel.c | 12 ++++++------
> >      1 file changed, 6 insertions(+), 6 deletions(-)
> >
> >     diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> >     index dd10ceb..5f70d86 100644
> >     --- a/libmultipath/propsel.c
> >     +++ b/libmultipath/propsel.c
> >     @@ -162,7 +162,7 @@ int select_pgpolicy(struct config *conf, struct
> multipath * mp)
> >
> >             if (conf->pgpolicy_flag > 0) {
> >                     mp->pgpolicy = conf->pgpolicy_flag;
> >     -               origin = "(cmd line flag)";
> >     +               origin = "(setting: multipath command line [-p]
> flag)";
> >                     goto out;
> >             }
> >             mp_set_mpe(pgpolicy);
> >     @@ -251,18 +251,18 @@ int select_alias(struct config *conf, struct
> multipath * mp)
> >                                     mp->alias_old, mp->alias_prefix,
> >                                     conf->bindings_read_only);
> >                     memset (mp->alias_old, 0, WWID_SIZE);
> >     -               origin = "(using existing alias)";
> >     +               origin = "(setting: using existing alias)";
> >             }
> >
> >             if (mp->alias == NULL) {
> >                     mp->alias = get_user_friendly_alias(mp->wwid,
> >                                     conf->bindings_file,
> mp->alias_prefix, conf->bindings_read_only);
> >     -               origin = "(user_friendly_name)";
> >     +               origin = "(setting: user_friendly_name)";
> >             }
> >      out:
> >             if (mp->alias == NULL) {
> >                     mp->alias = STRDUP(mp->wwid);
> >     -               origin = "(default to wwid)";
> >     +               origin = "(setting: default to WWID)";
> >             }
> >             if (mp->alias)
> >                     condlog(3, "%s: alias = %s %s", mp->wwid, mp->alias,
> origin);
> >     @@ -565,7 +565,7 @@ int select_retain_hwhandler(struct config *conf,
> struct multipath *mp)
> >
> >             if (!VERSION_GE(conf->version, minv_dm_retain)) {
> >                     mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
> >     -               origin = "(requires kernel version >= 1.5.0)";
> >     +               origin = "(setting: WARNING, requires kernel version
> >= 1.5.0)";
> >                     goto out;
> >             }
> >             mp_set_ovr(retain_hwhandler);
> >     @@ -614,7 +614,7 @@ int select_deferred_remove(struct config *conf,
> struct multipath *mp)
> >
> >      #ifndef LIBDM_API_DEFERRED
> >             mp->deferred_remove = DEFERRED_REMOVE_OFF;
> >     -       origin = "(not compiled with support)";
> >     +       origin = "(setting: WARNING, not compiled with support)";
> >             goto out;
> >      #endif
> >             if (mp->deferred_remove == DEFERRED_REMOVE_IN_PROGRESS) {
> >     --
> >     2.12.2
> >
> >
>
>

--001a11c16230c66f23054d1c3e2a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Right,<div>pushed now.</div><div><br></div><div>Thanks,</d=
iv><div>Christophe.</div></div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Fri, Apr 14, 2017 at 1:56 AM, Xose Vazquez Perez <span dir=
=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank">xo=
se.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex=
">On 04/12/2017 09:35 AM, Christophe Varoqui wrote:<br>
<br>
&gt; Merged,<br>
<br>
No, it&#39;s missing.<br>
<br>
&gt; On Sat, Apr 8, 2017 at 3:30 PM, Xose Vazquez Perez &lt;<a href=3D"mail=
to:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a> &lt;mailto:<a href=3D=
"mailto:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a><wbr>&gt;&gt; wro=
te:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Cc: Christophe Varoqui &lt;<a href=3D"mailto:christ=
ophe.varoqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a> &lt;mailt=
o:<a href=3D"mailto:christophe.varoqui@opensvc.com">christophe.varoqui@<wbr=
>opensvc.com</a>&gt;&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Cc: device-mapper development &lt;<a href=3D"mailto=
:dm-devel@redhat.com">dm-devel@redhat.com</a> &lt;mailto:<a href=3D"mailto:=
dm-devel@redhat.com">dm-devel@redhat.com</a>&gt;&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"ma=
ilto:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a> &lt;mailto:<a href=
=3D"mailto:xose.vazquez@gmail.com">xose.vazquez@gmail.com</a><wbr>&gt;&gt;<=
br>
<div class=3D"HOEnZb"><div class=3D"h5">&gt;=C2=A0 =C2=A0 =C2=A0---<br>
&gt;=C2=A0 =C2=A0 =C2=A0 libmultipath/propsel.c | 12 ++++++------<br>
&gt;=C2=A0 =C2=A0 =C2=A0 1 file changed, 6 insertions(+), 6 deletions(-)<br=
>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0diff --git a/libmultipath/propsel.c b/libmultipath/=
propsel.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0index dd10ceb..5f70d86 100644<br>
&gt;=C2=A0 =C2=A0 =C2=A0--- a/libmultipath/propsel.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0+++ b/libmultipath/propsel.c<br>
&gt;=C2=A0 =C2=A0 =C2=A0@@ -162,7 +162,7 @@ int select_pgpolicy(struct conf=
ig *conf, struct multipath * mp)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (conf-&gt;pgpolicy_f=
lag &gt; 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0mp-&gt;pgpolicy =3D conf-&gt;pgpolicy_flag;<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(cmd line flag)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(setting: multipath command line [-p] flag)&quot;;<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_mpe(pgpolicy);<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0@@ -251,18 +251,18 @@ int select_alias(struct confi=
g *conf, struct multipath * mp)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;alias_=
old, mp-&gt;alias_prefix,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;bind=
ings_read_only);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0memset (mp-&gt;alias_old, 0, WWID_SIZE);<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(using existing alias)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(setting: using existing alias)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mp-&gt;alias =3D=3D=
 NULL) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0mp-&gt;alias =3D get_user_friendly_alias(mp-&gt;<wbr>wwid,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;bind=
ings_file, mp-&gt;alias_prefix, conf-&gt;bindings_read_only);<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(user_friendly_name)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(setting: user_friendly_name)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mp-&gt;alias =3D=3D=
 NULL) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0mp-&gt;alias =3D STRDUP(mp-&gt;wwid);<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(default to wwid)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(setting: default to WWID)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mp-&gt;alias)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0condlog(3, &quot;%s: alias =3D %s %s&quot;, mp-&gt;wwid, mp-&gt;alias=
, origin);<br>
&gt;=C2=A0 =C2=A0 =C2=A0@@ -565,7 +565,7 @@ int select_retain_hwhandler(str=
uct config *conf, struct multipath *mp)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!VERSION_GE(conf-&g=
t;version, minv_dm_retain)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0mp-&gt;retain_hwhandler =3D RETAIN_HWHANDLER_OFF;<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(requires kernel version &gt;=3D 1.5.0)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0origin =3D &quot;(setting: WARNING, requires kernel version &gt;=3D 1=
.5.0)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(retain_hwhan=
dler);<br>
&gt;=C2=A0 =C2=A0 =C2=A0@@ -614,7 +614,7 @@ int select_deferred_remove(stru=
ct config *conf, struct multipath *mp)<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 #ifndef LIBDM_API_DEFERRED<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;deferred_remove =
=3D DEFERRED_REMOVE_OFF;<br>
&gt;=C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(not c=
ompiled with support)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(setti=
ng: WARNING, not compiled with support)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 #endif<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mp-&gt;deferred_rem=
ove =3D=3D DEFERRED_REMOVE_IN_PROGRESS) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0--<br>
&gt;=C2=A0 =C2=A0 =C2=A02.12.2<br>
&gt;<br>
&gt;<br>
<br>
</div></div></blockquote></div><br></div>

--001a11c16230c66f23054d1c3e2a--


--===============1268925734183249485==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1268925734183249485==--
