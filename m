From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools: replace multipath
 configuration output
Date: Thu, 1 Dec 2016 21:52:07 -0600
Message-ID: <20161202035207.GG3099@octiron.msp.redhat.com>
References: <20161124224427.12609-1-xose.vazquez@gmail.com>
	<1480064411.23852.1.camel@suse.com>
	<CABr-Gne32p_=xy7rrZ9ZgvPnEbkocYF=mded-8HEk37pofgTug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CABr-Gne32p_=xy7rrZ9ZgvPnEbkocYF=mded-8HEk37pofgTug@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Sat, Nov 26, 2016 at 10:21:09AM +0100, Christophe Varoqui wrote:
>    I also like the more structured wording you propose, and I can see how
>    greping "setting:" can help.
>    I'll wait a little longer to receive ack (not receive nack?) from
>    distributors, as they face the annoyed users whose scripts break when =
we
>    change our log strings format.

I don't really see the need for this change. But we wouldn't be pulling
it in until the next major RHEL release, and if the debug messages
change on a major relese, I'm not too worried about that. I can also see
the benefit of the "setting:" prefix, but in truth, I don't think anyone
looks at these except when something goes wrong, and in that case, they
are probably grepping for the option name anyway.

So, I'm not NACKing this, but I'm not pushing for it either. I really
don't care, one way or ther other.

-Ben

>    Thanks.
>    On Fri, Nov 25, 2016 at 10:00 AM, Martin Wilck <[1]mwilck@suse.com> wr=
ote:
> =

>      I am not sure I see the merit of these changes. If it's really
>      necessary to change the wording of the log messages which people have
>      got used to, the new ones should be really more self-explanatory than
>      the old ones.
> =

>      The common "setting: " formatting is nice but IMHO this alone doesn't
>      really justify overthrowing old habits.
>      On Thu, 2016-11-24 at 23:44 +0100, Xose Vazquez Perez wrote:
>      > sysfs setting=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0-> setting: kernel s=
ysfs
>      >
>      > detected setting=A0=A0=A0=A0=A0=A0=A0=A0-> setting: array autodete=
cted
>      >
>      > controller setting=A0=A0=A0=A0=A0=A0-> setting: array configuration
> =

>      Is "array" really more understandable to users than "controller"?
>      These settings come from hwentries, so in reality they're either part
>      of the built-in hwtable or of the multipath.conf "devices" section, =
or
>      am I wrong here?
>      > internal default=A0=A0=A0=A0=A0=A0=A0=A0-> setting: multipath inte=
rnal
>      >
>      > overrides setting=A0=A0=A0=A0=A0=A0=A0-> setting: multipath.conf o=
verrides section
>      >
>      > LUN setting=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0-> setting: mult=
ipath.conf multipaths section
>      >
>      > config file default
>      > config file setting=A0=A0=A0=A0=A0-> setting: multipath.conf defau=
lts/devices
>      > section
> =

>      Have you double-checked if this is correct for all options? It would=
 be
>      helpful for users to be able to distinguish which config file section
>      the option was taken from (defaults/devices/multipaths/overrides). T=
he
>      same argument applies to the hardware enries - being able to
>      distinguish built in hardware defaults from config file "devices"
>      settings would be really helpful, but this patch doesn't provide that
>      functionality.
> =

>      Regards
>      Martin
> =

>      >
>      >
>      > Cc: Benjamin Marzinski <[2]bmarzins@redhat.com>
>      > Cc: Hannes Reinecke <[3]hare@suse.de>
>      > Cc: Christophe Varoqui <[4]christophe.varoqui@opensvc.com>
>      > Cc: device-mapper development <[5]dm-devel@redhat.com>
>      > Signed-off-by: Xose Vazquez Perez <[6]xose.vazquez@gmail.com>
>      > ---
>      > =A0libmultipath/propsel.c | 66 +++++++++++++++++++++++++----------=
-----
>      > ----------
>      > =A01 file changed, 33 insertions(+), 33 deletions(-)
>      >
>      > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
>      > index d1db7c3..c0bc616 100644
>      > --- a/libmultipath/propsel.c
>      > +++ b/libmultipath/propsel.c
>      > @@ -41,28 +41,28 @@ do {
>      >=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>      > =A0#define do_default(dest, value)
>      >=A0 =A0 =A0 =A0\
>      > =A0do {
>      > \
>      > =A0=A0 =A0 =A0dest =3D value;
>      >=A0 =A0 =A0 =A0\
>      > -=A0 =A0 =A0origin =3D "(internal default)";
>      >=A0 =A0 =A0 =A0\
>      > +=A0 =A0 =A0origin =3D "(setting: multipath internal)";
>      > \
>      > =A0} while(0)
>      > =A0
>      > =A0#define mp_set_mpe(var)
>      >=A0 =A0 =A0 =A0\
>      > -do_set(var, mp->mpe, mp->var, "(LUN setting)")
>      > +do_set(var, mp->mpe, mp->var, "(setting: multipath.conf multipaths
>      > section)")
>      > =A0#define mp_set_hwe(var)
>      >=A0 =A0 =A0 =A0\
>      > -do_set(var, mp->hwe, mp->var, "(controller setting)")
>      > +do_set(var, mp->hwe, mp->var, "(setting: array configuration)")
>      > =A0#define mp_set_ovr(var)
>      >=A0 =A0 =A0 =A0\
>      > -do_set(var, conf->overrides, mp->var, "(overrides setting)")
>      > +do_set(var, conf->overrides, mp->var, "(setting: multipath.conf
>      > overrides section)")
>      > =A0#define mp_set_conf(var)
>      > \
>      > -do_set(var, conf, mp->var, "(config file default)")
>      > +do_set(var, conf, mp->var, "(setting: multipath.conf
>      > defaults/devices section)")
>      > =A0#define mp_set_default(var, value)
>      > \
>      > =A0do_default(mp->var, value)
>      > =A0
>      > =A0#define pp_set_mpe(var)
>      >=A0 =A0 =A0 =A0\
>      > -do_set(var, mpe, pp->var, "(LUN setting)")
>      > +do_set(var, mpe, pp->var, "(setting: multipath.conf multipaths
>      > section)")
>      > =A0#define pp_set_hwe(var)
>      >=A0 =A0 =A0 =A0\
>      > -do_set(var, pp->hwe, pp->var, "(controller setting)")
>      > +do_set(var, pp->hwe, pp->var, "(setting: array configuration)")
>      > =A0#define pp_set_conf(var)
>      > \
>      > -do_set(var, conf, pp->var, "(config file default)")
>      > +do_set(var, conf, pp->var, "(setting: multipath.conf
>      > defaults/devices section)")
>      > =A0#define pp_set_ovr(var)
>      >=A0 =A0 =A0 =A0\
>      > -do_set(var, conf->overrides, pp->var, "(overrides setting)")
>      > +do_set(var, conf->overrides, pp->var, "(setting: multipath.conf
>      > overrides section)")
>      > =A0#define pp_set_default(var, value)
>      > \
>      > =A0do_default(pp->var, value)
>      > =A0
>      > @@ -77,9 +77,9 @@ do {
>      >=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0\
>      > =A0} while(0)
>      > =A0
>      > =A0#define set_attr_mpe(var, shift)
>      > \
>      > -do_attr_set(var, mp->mpe, shift, "(LUN setting)")
>      > +do_attr_set(var, mp->mpe, shift, "(setting: multipath.conf
>      > multipaths section)")
>      > =A0#define set_attr_conf(var, shift)
>      > \
>      > -do_attr_set(var, conf, shift, "(config file default)")
>      > +do_attr_set(var, conf, shift, "(setting: multipath.conf
>      > defaults/devices section)")
>      > =A0
>      > =A0int select_mode(struct config *conf, struct multipath *mp)
>      > =A0{
>      > @@ -214,13 +214,13 @@ want_user_friendly_names(struct config *conf,
>      > struct multipath * mp)
>      > =A0=A0 =A0 =A0int user_friendly_names;
>      > =A0
>      > =A0=A0 =A0 =A0do_set(user_friendly_names, mp->mpe, user_friendly_n=
ames,
>      > -=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0"(LUN setting)");
>      > +=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0"(setting: multipath.conf multipa=
ths section)");
>      > =A0=A0 =A0 =A0do_set(user_friendly_names, conf->overrides,
>      > user_friendly_names,
>      > -=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0"(overrides setting)");
>      > +=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0"(setting: multipath.conf overrid=
es section)");
>      > =A0=A0 =A0 =A0do_set(user_friendly_names, mp->hwe, user_friendly_n=
ames,
>      > -=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0"(controller setting)");
>      > +=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0"(setting: array configuration)");
>      > =A0=A0 =A0 =A0do_set(user_friendly_names, conf, user_friendly_name=
s,
>      > -=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0"(config file setting)");
>      > +=A0 =A0 =A0=A0=A0=A0=A0=A0=A0=A0"(setting: multipath.conf default=
s/devices
>      > section)");
>      > =A0=A0 =A0 =A0do_default(user_friendly_names,
>      > DEFAULT_USER_FRIENDLY_NAMES);
>      > =A0out:
>      > =A0=A0 =A0 =A0condlog(3, "%s: user_friendly_names =3D %s %s", mp->=
wwid,
>      > @@ -235,7 +235,7 @@ int select_alias(struct config *conf, struct
>      > multipath * mp)
>      > =A0
>      > =A0=A0 =A0 =A0if (mp->mpe && mp->mpe->alias) {
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0mp->alias =3D STRDUP(mp->mpe->alias);
>      > -=A0 =A0 =A0 =A0 =A0 =A0 =A0origin =3D "(LUN setting)";
>      > +=A0 =A0 =A0 =A0 =A0 =A0 =A0origin =3D "(setting: multipath.conf m=
ultipaths
>      > section)";
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>      > =A0=A0 =A0 =A0}
>      > =A0
>      > @@ -312,24 +312,24 @@ int select_checker(struct config *conf, stru=
ct
>      > path *pp)
>      > =A0=A0 =A0 =A0char *origin, *checker_name;
>      > =A0=A0 =A0 =A0struct checker * c =3D &pp->checker;
>      > =A0
>      > -=A0 =A0 =A0do_set(checker_name, conf->overrides, checker_name,
>      > "(overrides setting)");
>      > -=A0 =A0 =A0do_set(checker_name, pp->hwe, checker_name, "(controll=
er
>      > setting)");
>      > -=A0 =A0 =A0do_set(checker_name, conf, checker_name, "(config file
>      > setting)");
>      > +=A0 =A0 =A0do_set(checker_name, conf->overrides, checker_name,
>      > "(setting: multipath.conf overrides section)");
>      > +=A0 =A0 =A0do_set(checker_name, pp->hwe, checker_name, "(setting:=
 array
>      > configuration)");
>      > +=A0 =A0 =A0do_set(checker_name, conf, checker_name, "(setting:
>      > multipath.conf defaults/devices section)");
>      > =A0=A0 =A0 =A0do_default(checker_name, DEFAULT_CHECKER);
>      > =A0out:
>      > =A0=A0 =A0 =A0checker_get(conf->multipath_dir, c, checker_name);
>      > =A0=A0 =A0 =A0condlog(3, "%s: path_checker =3D %s %s", pp->dev, c-=
>name,
>      > origin);
>      > =A0=A0 =A0 =A0if (conf->checker_timeout) {
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0c->timeout =3D conf->checker_timeout;
>      > -=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: checker timeout =3D %u=
 s (config file
>      > default)",
>      > +=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: checker timeout =3D %u=
 s (setting:
>      > multipath.conf defaults/devices section)",
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pp->=
dev, c->timeout);
>      > =A0=A0 =A0 =A0}
>      > =A0=A0 =A0 =A0else if (sysfs_get_timeout(pp, &c->timeout) > 0)
>      > -=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: checker timeout =3D %u=
 ms (sysfs
>      > setting)",
>      > +=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: checker timeout =3D %u=
 ms (setting:
>      > kernel sysfs)",
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pp->=
dev, c->timeout);
>      > =A0=A0 =A0 =A0else {
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0c->timeout =3D DEF_TIMEOUT;
>      > -=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: checker timeout =3D %u=
 ms (internal
>      > default)",
>      > +=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: checker timeout =3D %u=
 ms (setting:
>      > multipath internal)",
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pp->=
dev, c->timeout);
>      > =A0=A0 =A0 =A0}
>      > =A0=A0 =A0 =A0return 0;
>      > @@ -397,17 +397,17 @@ int select_prio(struct config *conf, struct
>      > path *pp)
>      > =A0=A0 =A0 =A0if (pp->detect_prio =3D=3D DETECT_PRIO_ON) {
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0detect_prio(conf, pp);
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0if (prio_selected(p)) {
>      > -=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0origin =3D "(detected =
setting)";
>      > +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0origin =3D "(setting: =
array autodetected)";
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0}
>      > =A0=A0 =A0 =A0}
>      > =A0=A0 =A0 =A0mpe =3D find_mpe(conf->mptable, pp->wwid);
>      > -=A0 =A0 =A0set_prio(conf->multipath_dir, mpe, "(LUN setting)");
>      > -=A0 =A0 =A0set_prio(conf->multipath_dir, conf->overrides, "(overr=
ides
>      > setting)");
>      > -=A0 =A0 =A0set_prio(conf->multipath_dir, pp->hwe, "controller
>      > setting)");
>      > -=A0 =A0 =A0set_prio(conf->multipath_dir, conf, "(config file
>      > default)");
>      > +=A0 =A0 =A0set_prio(conf->multipath_dir, mpe, "(setting: multipat=
h.conf
>      > multipaths section)");
>      > +=A0 =A0 =A0set_prio(conf->multipath_dir, conf->overrides, "(setti=
ng:
>      > multipath.conf overrides section)");
>      > +=A0 =A0 =A0set_prio(conf->multipath_dir, pp->hwe, "(setting: array
>      > configuration)");
>      > +=A0 =A0 =A0set_prio(conf->multipath_dir, conf, "(setting:
>      > multipath.conf defaults/devices section)");
>      > =A0=A0 =A0 =A0prio_get(conf->multipath_dir, p, DEFAULT_PRIO,
>      > DEFAULT_PRIO_ARGS);
>      > -=A0 =A0 =A0origin =3D "(internal default)";
>      > +=A0 =A0 =A0origin =3D "(setting: multipath internal)";
>      > =A0out:
>      > =A0=A0 =A0 =A0/*
>      > =A0=A0 =A0 =A0=A0* fetch tpgs mode for alua, if its not already ob=
tained
>      > @@ -448,7 +448,7 @@ out:
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: no_path_retry =3D %s=
 (inherited
>      > setting)",
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mp->alias, buff);
>      > =A0=A0 =A0 =A0else
>      > -=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: no_path_retry =3D unde=
f (internal
>      > default)",
>      > +=A0 =A0 =A0 =A0 =A0 =A0 =A0condlog(3, "%s: no_path_retry =3D unde=
f (setting:
>      > multipath internal)",
>      > =A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mp->alias);
>      > =A0=A0 =A0 =A0return 0;
>      > =A0}
>      > @@ -458,10 +458,10 @@ select_minio_rq (struct config *conf, struct
>      > multipath * mp)
>      > =A0{
>      > =A0=A0 =A0 =A0char *origin;
>      > =A0
>      > -=A0 =A0 =A0do_set(minio_rq, mp->mpe, mp->minio, "(LUN setting)");
>      > -=A0 =A0 =A0do_set(minio_rq, conf->overrides, mp->minio, "(overrid=
es
>      > setting)");
>      > -=A0 =A0 =A0do_set(minio_rq, mp->hwe, mp->minio, "(controller
>      > setting)");
>      > -=A0 =A0 =A0do_set(minio_rq, conf, mp->minio, "(config file settin=
g)");
>      > +=A0 =A0 =A0do_set(minio_rq, mp->mpe, mp->minio, "(setting:
>      > multipath.conf multipaths section)");
>      > +=A0 =A0 =A0do_set(minio_rq, conf->overrides, mp->minio, "(setting:
>      > multipath.conf overrides section)");
>      > +=A0 =A0 =A0do_set(minio_rq, mp->hwe, mp->minio, "(setting: array
>      > configuration)");
>      > +=A0 =A0 =A0do_set(minio_rq, conf, mp->minio, "(setting: multipath=
.conf
>      > defaults/devices section)");
>      > =A0=A0 =A0 =A0do_default(mp->minio, DEFAULT_MINIO_RQ);
>      > =A0out:
>      > =A0=A0 =A0 =A0condlog(3, "%s: minio =3D %i %s", mp->alias, mp->min=
io,
>      > origin);
> =

>      --
>      Dr. Martin Wilck <[7]mwilck@suse.com>, Tel.=A0[8]+49 (0)911 74053 21=
07
>      SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Nort=
on
>      HRB 21284 (AG N=FCrnberg)
> =

>      --
>      dm-devel mailing list
>      [9]dm-devel@redhat.com
>      [10]https://www.redhat.com/mailman/listinfo/dm-devel
> =

> References
> =

>    Visible links
>    1. mailto:mwilck@suse.com
>    2. mailto:bmarzins@redhat.com
>    3. mailto:hare@suse.de
>    4. mailto:christophe.varoqui@opensvc.com
>    5. mailto:dm-devel@redhat.com
>    6. mailto:xose.vazquez@gmail.com
>    7. mailto:mwilck@suse.com
>    8. file:///tmp/tel:%2B49%20%280%29911%2074053%202107
>    9. mailto:dm-devel@redhat.com
>   10. https://www.redhat.com/mailman/listinfo/dm-devel

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
