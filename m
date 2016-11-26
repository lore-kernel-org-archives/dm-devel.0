From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: replace multipath
 configuration output
Date: Sat, 26 Nov 2016 10:21:09 +0100
Message-ID: <CABr-Gne32p_=xy7rrZ9ZgvPnEbkocYF=mded-8HEk37pofgTug@mail.gmail.com>
References: <20161124224427.12609-1-xose.vazquez@gmail.com>
	<1480064411.23852.1.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1354945426892463679=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1480064411.23852.1.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1354945426892463679==
Content-Type: multipart/alternative; boundary=001a113a2e04549b04054230c2ef

--001a113a2e04549b04054230c2ef
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I also like the more structured wording you propose, and I can see how
greping "setting:" can help.

I'll wait a little longer to receive ack (not receive nack?) from
distributors, as they face the annoyed users whose scripts break when we
change our log strings format.

Thanks.

On Fri, Nov 25, 2016 at 10:00 AM, Martin Wilck <mwilck@suse.com> wrote:

> I am not sure I see the merit of these changes. If it's really
> necessary to change the wording of the log messages which people have
> got used to, the new ones should be really more self-explanatory than
> the old ones.
>
> The common "setting: " formatting is nice but IMHO this alone doesn't
> really justify overthrowing old habits.
>
> On Thu, 2016-11-24 at 23:44 +0100, Xose Vazquez Perez wrote:
> > sysfs setting           -> setting: kernel sysfs
> >
> > detected setting        -> setting: array autodetected
> >
> > controller setting      -> setting: array configuration
>
> Is "array" really more understandable to users than "controller"?
> These settings come from hwentries, so in reality they're either part
> of the built-in hwtable or of the multipath.conf "devices" section, or
> am I wrong here?
>
> > internal default        -> setting: multipath internal
> >
> > overrides setting       -> setting: multipath.conf overrides section
> >
> > LUN setting             -> setting: multipath.conf multipaths section
> >
> > config file default
> > config file setting     -> setting: multipath.conf defaults/devices
> > section
>
> Have you double-checked if this is correct for all options? It would be
> helpful for users to be able to distinguish which config file section
> the option was taken from (defaults/devices/multipaths/overrides). The
> same argument applies to the hardware enries - being able to
> distinguish built in hardware defaults from config file "devices"
> settings would be really helpful, but this patch doesn't provide that
> functionality.
>
> Regards
> Martin
>
>
>
>
> >
> >
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: device-mapper development <dm-devel@redhat.com>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> >  libmultipath/propsel.c | 66 +++++++++++++++++++++++++---------------
> > ----------
> >  1 file changed, 33 insertions(+), 33 deletions(-)
> >
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index d1db7c3..c0bc616 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -41,28 +41,28 @@ do {
> >                       \
> >  #define do_default(dest, value)
> >       \
> >  do {
> > \
> >       dest =3D value;
> >       \
> > -     origin =3D "(internal default)";
> >       \
> > +     origin =3D "(setting: multipath internal)";
> > \
> >  } while(0)
> >
> >  #define mp_set_mpe(var)
> >       \
> > -do_set(var, mp->mpe, mp->var, "(LUN setting)")
> > +do_set(var, mp->mpe, mp->var, "(setting: multipath.conf multipaths
> > section)")
> >  #define mp_set_hwe(var)
> >       \
> > -do_set(var, mp->hwe, mp->var, "(controller setting)")
> > +do_set(var, mp->hwe, mp->var, "(setting: array configuration)")
> >  #define mp_set_ovr(var)
> >       \
> > -do_set(var, conf->overrides, mp->var, "(overrides setting)")
> > +do_set(var, conf->overrides, mp->var, "(setting: multipath.conf
> > overrides section)")
> >  #define mp_set_conf(var)
> > \
> > -do_set(var, conf, mp->var, "(config file default)")
> > +do_set(var, conf, mp->var, "(setting: multipath.conf
> > defaults/devices section)")
> >  #define mp_set_default(var, value)
> > \
> >  do_default(mp->var, value)
> >
> >  #define pp_set_mpe(var)
> >       \
> > -do_set(var, mpe, pp->var, "(LUN setting)")
> > +do_set(var, mpe, pp->var, "(setting: multipath.conf multipaths
> > section)")
> >  #define pp_set_hwe(var)
> >       \
> > -do_set(var, pp->hwe, pp->var, "(controller setting)")
> > +do_set(var, pp->hwe, pp->var, "(setting: array configuration)")
> >  #define pp_set_conf(var)
> > \
> > -do_set(var, conf, pp->var, "(config file default)")
> > +do_set(var, conf, pp->var, "(setting: multipath.conf
> > defaults/devices section)")
> >  #define pp_set_ovr(var)
> >       \
> > -do_set(var, conf->overrides, pp->var, "(overrides setting)")
> > +do_set(var, conf->overrides, pp->var, "(setting: multipath.conf
> > overrides section)")
> >  #define pp_set_default(var, value)
> > \
> >  do_default(pp->var, value)
> >
> > @@ -77,9 +77,9 @@ do {
> >                       \
> >  } while(0)
> >
> >  #define set_attr_mpe(var, shift)
> > \
> > -do_attr_set(var, mp->mpe, shift, "(LUN setting)")
> > +do_attr_set(var, mp->mpe, shift, "(setting: multipath.conf
> > multipaths section)")
> >  #define set_attr_conf(var, shift)
> > \
> > -do_attr_set(var, conf, shift, "(config file default)")
> > +do_attr_set(var, conf, shift, "(setting: multipath.conf
> > defaults/devices section)")
> >
> >  int select_mode(struct config *conf, struct multipath *mp)
> >  {
> > @@ -214,13 +214,13 @@ want_user_friendly_names(struct config *conf,
> > struct multipath * mp)
> >       int user_friendly_names;
> >
> >       do_set(user_friendly_names, mp->mpe, user_friendly_names,
> > -            "(LUN setting)");
> > +            "(setting: multipath.conf multipaths section)");
> >       do_set(user_friendly_names, conf->overrides,
> > user_friendly_names,
> > -            "(overrides setting)");
> > +            "(setting: multipath.conf overrides section)");
> >       do_set(user_friendly_names, mp->hwe, user_friendly_names,
> > -            "(controller setting)");
> > +            "(setting: array configuration)");
> >       do_set(user_friendly_names, conf, user_friendly_names,
> > -            "(config file setting)");
> > +            "(setting: multipath.conf defaults/devices
> > section)");
> >       do_default(user_friendly_names,
> > DEFAULT_USER_FRIENDLY_NAMES);
> >  out:
> >       condlog(3, "%s: user_friendly_names =3D %s %s", mp->wwid,
> > @@ -235,7 +235,7 @@ int select_alias(struct config *conf, struct
> > multipath * mp)
> >
> >       if (mp->mpe && mp->mpe->alias) {
> >               mp->alias =3D STRDUP(mp->mpe->alias);
> > -             origin =3D "(LUN setting)";
> > +             origin =3D "(setting: multipath.conf multipaths
> > section)";
> >               goto out;
> >       }
> >
> > @@ -312,24 +312,24 @@ int select_checker(struct config *conf, struct
> > path *pp)
> >       char *origin, *checker_name;
> >       struct checker * c =3D &pp->checker;
> >
> > -     do_set(checker_name, conf->overrides, checker_name,
> > "(overrides setting)");
> > -     do_set(checker_name, pp->hwe, checker_name, "(controller
> > setting)");
> > -     do_set(checker_name, conf, checker_name, "(config file
> > setting)");
> > +     do_set(checker_name, conf->overrides, checker_name,
> > "(setting: multipath.conf overrides section)");
> > +     do_set(checker_name, pp->hwe, checker_name, "(setting: array
> > configuration)");
> > +     do_set(checker_name, conf, checker_name, "(setting:
> > multipath.conf defaults/devices section)");
> >       do_default(checker_name, DEFAULT_CHECKER);
> >  out:
> >       checker_get(conf->multipath_dir, c, checker_name);
> >       condlog(3, "%s: path_checker =3D %s %s", pp->dev, c->name,
> > origin);
> >       if (conf->checker_timeout) {
> >               c->timeout =3D conf->checker_timeout;
> > -             condlog(3, "%s: checker timeout =3D %u s (config file
> > default)",
> > +             condlog(3, "%s: checker timeout =3D %u s (setting:
> > multipath.conf defaults/devices section)",
> >                               pp->dev, c->timeout);
> >       }
> >       else if (sysfs_get_timeout(pp, &c->timeout) > 0)
> > -             condlog(3, "%s: checker timeout =3D %u ms (sysfs
> > setting)",
> > +             condlog(3, "%s: checker timeout =3D %u ms (setting:
> > kernel sysfs)",
> >                               pp->dev, c->timeout);
> >       else {
> >               c->timeout =3D DEF_TIMEOUT;
> > -             condlog(3, "%s: checker timeout =3D %u ms (internal
> > default)",
> > +             condlog(3, "%s: checker timeout =3D %u ms (setting:
> > multipath internal)",
> >                               pp->dev, c->timeout);
> >       }
> >       return 0;
> > @@ -397,17 +397,17 @@ int select_prio(struct config *conf, struct
> > path *pp)
> >       if (pp->detect_prio =3D=3D DETECT_PRIO_ON) {
> >               detect_prio(conf, pp);
> >               if (prio_selected(p)) {
> > -                     origin =3D "(detected setting)";
> > +                     origin =3D "(setting: array autodetected)";
> >                       goto out;
> >               }
> >       }
> >       mpe =3D find_mpe(conf->mptable, pp->wwid);
> > -     set_prio(conf->multipath_dir, mpe, "(LUN setting)");
> > -     set_prio(conf->multipath_dir, conf->overrides, "(overrides
> > setting)");
> > -     set_prio(conf->multipath_dir, pp->hwe, "controller
> > setting)");
> > -     set_prio(conf->multipath_dir, conf, "(config file
> > default)");
> > +     set_prio(conf->multipath_dir, mpe, "(setting: multipath.conf
> > multipaths section)");
> > +     set_prio(conf->multipath_dir, conf->overrides, "(setting:
> > multipath.conf overrides section)");
> > +     set_prio(conf->multipath_dir, pp->hwe, "(setting: array
> > configuration)");
> > +     set_prio(conf->multipath_dir, conf, "(setting:
> > multipath.conf defaults/devices section)");
> >       prio_get(conf->multipath_dir, p, DEFAULT_PRIO,
> > DEFAULT_PRIO_ARGS);
> > -     origin =3D "(internal default)";
> > +     origin =3D "(setting: multipath internal)";
> >  out:
> >       /*
> >        * fetch tpgs mode for alua, if its not already obtained
> > @@ -448,7 +448,7 @@ out:
> >               condlog(3, "%s: no_path_retry =3D %s (inherited
> > setting)",
> >                       mp->alias, buff);
> >       else
> > -             condlog(3, "%s: no_path_retry =3D undef (internal
> > default)",
> > +             condlog(3, "%s: no_path_retry =3D undef (setting:
> > multipath internal)",
> >                       mp->alias);
> >       return 0;
> >  }
> > @@ -458,10 +458,10 @@ select_minio_rq (struct config *conf, struct
> > multipath * mp)
> >  {
> >       char *origin;
> >
> > -     do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
> > -     do_set(minio_rq, conf->overrides, mp->minio, "(overrides
> > setting)");
> > -     do_set(minio_rq, mp->hwe, mp->minio, "(controller
> > setting)");
> > -     do_set(minio_rq, conf, mp->minio, "(config file setting)");
> > +     do_set(minio_rq, mp->mpe, mp->minio, "(setting:
> > multipath.conf multipaths section)");
> > +     do_set(minio_rq, conf->overrides, mp->minio, "(setting:
> > multipath.conf overrides section)");
> > +     do_set(minio_rq, mp->hwe, mp->minio, "(setting: array
> > configuration)");
> > +     do_set(minio_rq, conf, mp->minio, "(setting: multipath.conf
> > defaults/devices section)");
> >       do_default(mp->minio, DEFAULT_MINIO_RQ);
> >  out:
> >       condlog(3, "%s: minio =3D %i %s", mp->alias, mp->minio,
> > origin);
>
> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--001a113a2e04549b04054230c2ef
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I also like the more structured wording you propose, and I=
 can see how greping &quot;setting:&quot; can help.<div><br></div><div>I&#3=
9;ll wait a little longer to receive ack (not receive nack?) from distribut=
ors, as they face the annoyed users whose scripts break when we change our =
log strings format.</div><div><br></div><div>Thanks.</div></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Nov 25, 2016 at 10:=
00 AM, Martin Wilck <span dir=3D"ltr">&lt;<a href=3D"mailto:mwilck@suse.com=
" target=3D"_blank">mwilck@suse.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">I am not sure I see the merit of these changes. If it&#39;=
s really<br>
necessary to change the wording of the log messages which people have<br>
got used to, the new ones should be really more self-explanatory than<br>
the old ones.<br>
<br>
The common &quot;setting: &quot; formatting is nice but IMHO this alone doe=
sn&#39;t<br>
really justify overthrowing old habits.<br>
<span class=3D""><br>
On Thu, 2016-11-24 at 23:44 +0100, Xose Vazquez Perez wrote:<br>
&gt; sysfs setting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0-&gt; setting: kernel sysfs<br>
&gt;<br>
&gt; detected setting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-&gt; =
setting: array autodetected<br>
&gt;<br>
&gt; controller setting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-&gt; setting: a=
rray configuration<br>
<br>
</span>Is &quot;array&quot; really more understandable to users than &quot;=
controller&quot;?<br>
These settings come from hwentries, so in reality they&#39;re either part<b=
r>
of the built-in hwtable or of the multipath.conf &quot;devices&quot; sectio=
n, or<br>
am I wrong here?<br>
<span class=3D""><br>
&gt; internal default=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-&gt; =
setting: multipath internal<br>
&gt;<br>
&gt; overrides setting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-&gt; setti=
ng: multipath.conf overrides section<br>
&gt;<br>
&gt; LUN setting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0-&gt; setting: multipath.conf multipaths section<br>
&gt;<br>
&gt; config file default<br>
&gt; config file setting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0-&gt; setting: multip=
ath.conf defaults/devices<br>
&gt; section<br>
<br>
</span>Have you double-checked if this is correct for all options? It would=
 be<br>
helpful for users to be able to distinguish which config file section<br>
the option was taken from (defaults/devices/multipaths/<wbr>overrides). The=
<br>
same argument applies to the hardware enries - being able to<br>
distinguish built in hardware defaults from config file &quot;devices&quot;=
<br>
settings would be really helpful, but this patch doesn&#39;t provide that<b=
r>
functionality.<br>
<br>
Regards<br>
Martin<br>
<div><div class=3D"h5"><br>
<br>
<br>
<br>
&gt;<br>
&gt;<br>
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
&gt; =C2=A0libmultipath/propsel.c | 66 +++++++++++++++++++++++++-----<wbr>-=
---------<br>
&gt; ----------<br>
&gt; =C2=A01 file changed, 33 insertions(+), 33 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
&gt; index d1db7c3..c0bc616 100644<br>
&gt; --- a/libmultipath/propsel.c<br>
&gt; +++ b/libmultipath/propsel.c<br>
&gt; @@ -41,28 +41,28 @@ do {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0\<br>
&gt; =C2=A0#define do_default(dest, value)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; =C2=A0do {<br>
&gt; \<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0dest =3D value;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; -=C2=A0 =C2=A0 =C2=A0origin =3D &quot;(internal default)&quot;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; +=C2=A0 =C2=A0 =C2=A0origin =3D &quot;(setting: multipath internal)&qu=
ot;;<br>
&gt; \<br>
&gt; =C2=A0} while(0)<br>
&gt; =C2=A0<br>
&gt; =C2=A0#define mp_set_mpe(var)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; -do_set(var, mp-&gt;mpe, mp-&gt;var, &quot;(LUN setting)&quot;)<br>
&gt; +do_set(var, mp-&gt;mpe, mp-&gt;var, &quot;(setting: multipath.conf mu=
ltipaths<br>
&gt; section)&quot;)<br>
&gt; =C2=A0#define mp_set_hwe(var)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; -do_set(var, mp-&gt;hwe, mp-&gt;var, &quot;(controller setting)&quot;)=
<br>
&gt; +do_set(var, mp-&gt;hwe, mp-&gt;var, &quot;(setting: array configurati=
on)&quot;)<br>
&gt; =C2=A0#define mp_set_ovr(var)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; -do_set(var, conf-&gt;overrides, mp-&gt;var, &quot;(overrides setting)=
&quot;)<br>
&gt; +do_set(var, conf-&gt;overrides, mp-&gt;var, &quot;(setting: multipath=
.conf<br>
&gt; overrides section)&quot;)<br>
&gt; =C2=A0#define mp_set_conf(var)<br>
&gt; \<br>
&gt; -do_set(var, conf, mp-&gt;var, &quot;(config file default)&quot;)<br>
&gt; +do_set(var, conf, mp-&gt;var, &quot;(setting: multipath.conf<br>
&gt; defaults/devices section)&quot;)<br>
&gt; =C2=A0#define mp_set_default(var, value)<br>
&gt; \<br>
&gt; =C2=A0do_default(mp-&gt;var, value)<br>
&gt; =C2=A0<br>
&gt; =C2=A0#define pp_set_mpe(var)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; -do_set(var, mpe, pp-&gt;var, &quot;(LUN setting)&quot;)<br>
&gt; +do_set(var, mpe, pp-&gt;var, &quot;(setting: multipath.conf multipath=
s<br>
&gt; section)&quot;)<br>
&gt; =C2=A0#define pp_set_hwe(var)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; -do_set(var, pp-&gt;hwe, pp-&gt;var, &quot;(controller setting)&quot;)=
<br>
&gt; +do_set(var, pp-&gt;hwe, pp-&gt;var, &quot;(setting: array configurati=
on)&quot;)<br>
&gt; =C2=A0#define pp_set_conf(var)<br>
&gt; \<br>
&gt; -do_set(var, conf, pp-&gt;var, &quot;(config file default)&quot;)<br>
&gt; +do_set(var, conf, pp-&gt;var, &quot;(setting: multipath.conf<br>
&gt; defaults/devices section)&quot;)<br>
&gt; =C2=A0#define pp_set_ovr(var)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
&gt; -do_set(var, conf-&gt;overrides, pp-&gt;var, &quot;(overrides setting)=
&quot;)<br>
&gt; +do_set(var, conf-&gt;overrides, pp-&gt;var, &quot;(setting: multipath=
.conf<br>
&gt; overrides section)&quot;)<br>
&gt; =C2=A0#define pp_set_default(var, value)<br>
&gt; \<br>
&gt; =C2=A0do_default(pp-&gt;var, value)<br>
&gt; =C2=A0<br>
&gt; @@ -77,9 +77,9 @@ do {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0\<br>
&gt; =C2=A0} while(0)<br>
&gt; =C2=A0<br>
&gt; =C2=A0#define set_attr_mpe(var, shift)<br>
&gt; \<br>
&gt; -do_attr_set(var, mp-&gt;mpe, shift, &quot;(LUN setting)&quot;)<br>
&gt; +do_attr_set(var, mp-&gt;mpe, shift, &quot;(setting: multipath.conf<br=
>
&gt; multipaths section)&quot;)<br>
&gt; =C2=A0#define set_attr_conf(var, shift)<br>
&gt; \<br>
&gt; -do_attr_set(var, conf, shift, &quot;(config file default)&quot;)<br>
&gt; +do_attr_set(var, conf, shift, &quot;(setting: multipath.conf<br>
&gt; defaults/devices section)&quot;)<br>
&gt; =C2=A0<br>
&gt; =C2=A0int select_mode(struct config *conf, struct multipath *mp)<br>
&gt; =C2=A0{<br>
&gt; @@ -214,13 +214,13 @@ want_user_friendly_names(<wbr>struct config *con=
f,<br>
&gt; struct multipath * mp)<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0int user_friendly_names;<br>
&gt; =C2=A0<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, mp-&gt;mpe, user=
_friendly_names,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&quot;(=
LUN setting)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&quot;(=
setting: multipath.conf multipaths section)&quot;);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, conf-&gt;overrid=
es,<br>
&gt; user_friendly_names,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&quot;(=
overrides setting)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&quot;(=
setting: multipath.conf overrides section)&quot;);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, mp-&gt;hwe, user=
_friendly_names,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&quot;(=
controller setting)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&quot;(=
setting: array configuration)&quot;);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0do_set(user_friendly_names, conf, user_frien=
dly_names,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&quot;(=
config file setting)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&quot;(=
setting: multipath.conf defaults/devices<br>
&gt; section)&quot;);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0do_default(user_friendly_<wbr>names,<br>
&gt; DEFAULT_USER_FRIENDLY_NAMES);<br>
&gt; =C2=A0out:<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: user_friendly_names =3D=
 %s %s&quot;, mp-&gt;wwid,<br>
&gt; @@ -235,7 +235,7 @@ int select_alias(struct config *conf, struct<br>
&gt; multipath * mp)<br>
&gt; =C2=A0<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0if (mp-&gt;mpe &amp;&amp; mp-&gt;mpe-&gt;ali=
as) {<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mp-&gt;alias =3D=
 STRDUP(mp-&gt;mpe-&gt;alias);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(LUN=
 setting)&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0origin =3D &quot;(set=
ting: multipath.conf multipaths<br>
&gt; section)&quot;;<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0}<br>
&gt; =C2=A0<br>
&gt; @@ -312,24 +312,24 @@ int select_checker(struct config *conf, struct<b=
r>
&gt; path *pp)<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0char *origin, *checker_name;<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0struct checker * c =3D &amp;pp-&gt;checker;<=
br>
&gt; =C2=A0<br>
&gt; -=C2=A0 =C2=A0 =C2=A0do_set(checker_name, conf-&gt;overrides, checker_=
name,<br>
&gt; &quot;(overrides setting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0do_set(checker_name, pp-&gt;hwe, checker_name, &q=
uot;(controller<br>
&gt; setting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0do_set(checker_name, conf, checker_name, &quot;(c=
onfig file<br>
&gt; setting)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0do_set(checker_name, conf-&gt;overrides, checker_=
name,<br>
&gt; &quot;(setting: multipath.conf overrides section)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0do_set(checker_name, pp-&gt;hwe, checker_name, &q=
uot;(setting: array<br>
&gt; configuration)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0do_set(checker_name, conf, checker_name, &quot;(s=
etting:<br>
&gt; multipath.conf defaults/devices section)&quot;);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0do_default(checker_name, DEFAULT_CHECKER);<b=
r>
&gt; =C2=A0out:<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0checker_get(conf-&gt;multipath_<wbr>dir, c, =
checker_name);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: path_checker =3D %s %s&=
quot;, pp-&gt;dev, c-&gt;name,<br>
&gt; origin);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0if (conf-&gt;checker_timeout) {<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;timeout =
=3D conf-&gt;checker_timeout;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
checker timeout =3D %u s (config file<br>
&gt; default)&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
checker timeout =3D %u s (setting:<br>
&gt; multipath.conf defaults/devices section)&quot;,<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;dev, c-&gt;timeout);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0}<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0else if (sysfs_get_timeout(pp, &amp;c-&gt;ti=
meout) &gt; 0)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
checker timeout =3D %u ms (sysfs<br>
&gt; setting)&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
checker timeout =3D %u ms (setting:<br>
&gt; kernel sysfs)&quot;,<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;dev, c-&gt;timeout);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0else {<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c-&gt;timeout =
=3D DEF_TIMEOUT;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
checker timeout =3D %u ms (internal<br>
&gt; default)&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
checker timeout =3D %u ms (setting:<br>
&gt; multipath internal)&quot;,<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;dev, c-&gt;timeout);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0}<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; @@ -397,17 +397,17 @@ int select_prio(struct config *conf, struct<br>
&gt; path *pp)<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0if (pp-&gt;detect_prio =3D=3D DETECT_PRIO_ON=
) {<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0detect_prio(conf=
, pp);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (prio_selecte=
d(p)) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0origin =3D &quot;(detected setting)&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0origin =3D &quot;(setting: array autodetected)&quot;;<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0goto out;<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0}<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0mpe =3D find_mpe(conf-&gt;mptable, pp-&gt;ww=
id);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;multipath_dir, mpe, &quot;(LUN =
setting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;multipath_dir, conf-&gt;overrid=
es, &quot;(overrides<br>
&gt; setting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;multipath_dir, pp-&gt;hwe, &quo=
t;controller<br>
&gt; setting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;multipath_dir, conf, &quot;(con=
fig file<br>
&gt; default)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;multipath_dir, mpe, &quot;(sett=
ing: multipath.conf<br>
&gt; multipaths section)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;multipath_dir, conf-&gt;overrid=
es, &quot;(setting:<br>
&gt; multipath.conf overrides section)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;multipath_dir, pp-&gt;hwe, &quo=
t;(setting: array<br>
&gt; configuration)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0set_prio(conf-&gt;multipath_dir, conf, &quot;(set=
ting:<br>
&gt; multipath.conf defaults/devices section)&quot;);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0prio_get(conf-&gt;multipath_dir, p, DEFAULT_=
PRIO,<br>
&gt; DEFAULT_PRIO_ARGS);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0origin =3D &quot;(internal default)&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0origin =3D &quot;(setting: multipath internal)&qu=
ot;;<br>
&gt; =C2=A0out:<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0=C2=A0* fetch tpgs mode for alua, if its not=
 already obtained<br>
&gt; @@ -448,7 +448,7 @@ out:<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot=
;%s: no_path_retry =3D %s (inherited<br>
&gt; setting)&quot;,<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0mp-&gt;alias, buff);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0else<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
no_path_retry =3D undef (internal<br>
&gt; default)&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: =
no_path_retry =3D undef (setting:<br>
&gt; multipath internal)&quot;,<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0mp-&gt;alias);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; =C2=A0}<br>
&gt; @@ -458,10 +458,10 @@ select_minio_rq (struct config *conf, struct<br>
&gt; multipath * mp)<br>
&gt; =C2=A0{<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0char *origin;<br>
&gt; =C2=A0<br>
&gt; -=C2=A0 =C2=A0 =C2=A0do_set(minio_rq, mp-&gt;mpe, mp-&gt;minio, &quot;=
(LUN setting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0do_set(minio_rq, conf-&gt;overrides, mp-&gt;minio=
, &quot;(overrides<br>
&gt; setting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0do_set(minio_rq, mp-&gt;hwe, mp-&gt;minio, &quot;=
(controller<br>
&gt; setting)&quot;);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0do_set(minio_rq, conf, mp-&gt;minio, &quot;(confi=
g file setting)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0do_set(minio_rq, mp-&gt;mpe, mp-&gt;minio, &quot;=
(setting:<br>
&gt; multipath.conf multipaths section)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0do_set(minio_rq, conf-&gt;overrides, mp-&gt;minio=
, &quot;(setting:<br>
&gt; multipath.conf overrides section)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0do_set(minio_rq, mp-&gt;hwe, mp-&gt;minio, &quot;=
(setting: array<br>
&gt; configuration)&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0do_set(minio_rq, conf, mp-&gt;minio, &quot;(setti=
ng: multipath.conf<br>
&gt; defaults/devices section)&quot;);<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0do_default(mp-&gt;minio, DEFAULT_MINIO_RQ);<=
br>
&gt; =C2=A0out:<br>
&gt; =C2=A0=C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: minio =3D %i %s&quot;, =
mp-&gt;alias, mp-&gt;minio,<br>
&gt; origin);<br>
<br>
--<br>
</div></div>Dr. Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com">mwilck@=
suse.com</a>&gt;, Tel.=C2=A0<a href=3D"tel:%2B49%20%280%29911%2074053%20210=
7" value=3D"+49911740532107">+49 (0)911 74053 2107</a><br>
SUSE Linux GmbH, GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton<b=
r>
HRB 21284 (AG N=C3=BCrnberg)<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm-deve=
l</a></blockquote></div><br></div>

--001a113a2e04549b04054230c2ef--


--===============1354945426892463679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1354945426892463679==--
