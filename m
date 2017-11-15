From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 6/6] multipath: add "ghost_delay" parameter
Date: Wed, 15 Nov 2017 23:41:48 +0100
Message-ID: <CABr-GncA4F7rufn851tM6naZx1sWbNCSjpy-Qfjj==akAr9kJA@mail.gmail.com>
References: <1510100116-6206-1-git-send-email-bmarzins@redhat.com>
	<1510100116-6206-7-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0130205918940929459=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1510100116-6206-7-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

--===============0130205918940929459==
Content-Type: multipart/alternative; boundary="001a11402ada886c98055e0d356e"

--001a11402ada886c98055e0d356e
Content-Type: text/plain; charset="UTF-8"

Hi Ben,

the patchset is merged until this patch.
Can you consider rebasing it ?

Thanks,
Christophe.

On Wed, Nov 8, 2017 at 1:15 AM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> If the lower-priority passive paths for a multipath device appear first,
> IO can go to them and cause the hardware handler to activate them,
> before the higher priority paths appear, causing the devices to
> failback. Setting the "ghost_delay" parameter to a value greater than
> 0 can avoid this ping-ponging by causing udev to not mark the device as
> Ready after its initial creation until either an active path appears,
> or ghost_delay seconds have passed. Multipathd does this by setting
> the MPATH_UDEV_NO_PATHS_FLAG.
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |  3 +++
>  libmultipath/config.h      |  3 +++
>  libmultipath/configure.c   | 11 +++++++++++
>  libmultipath/defaults.h    |  1 +
>  libmultipath/devmapper.c   |  2 +-
>  libmultipath/dict.c        | 14 ++++++++++++++
>  libmultipath/hwtable.c     |  1 +
>  libmultipath/propsel.c     | 15 +++++++++++++++
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     |  7 +++++++
>  multipath/multipath.conf.5 | 19 +++++++++++++++++++
>  multipathd/main.c          | 28 +++++++++++++++++++++++++++-
>  12 files changed, 103 insertions(+), 2 deletions(-)
>
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index ea2359a..9486116 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -351,6 +351,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
>         merge_num(delay_wait_checks);
>         merge_num(skip_kpartx);
>         merge_num(max_sectors_kb);
> +       merge_num(ghost_delay);
>         merge_num(san_path_err_threshold);
>         merge_num(san_path_err_forget_rate);
>         merge_num(san_path_err_recovery_time);
> @@ -422,6 +423,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
>         hwe->retain_hwhandler = dhwe->retain_hwhandler;
>         hwe->detect_prio = dhwe->detect_prio;
>         hwe->detect_checker = dhwe->detect_checker;
> +       hwe->ghost_delay = dhwe->ghost_delay;
>
>         if (dhwe->bl_product && !(hwe->bl_product = set_param_str(dhwe->bl_
> product)))
>                 goto out;
> @@ -622,6 +624,7 @@ load_config (char * file)
>         conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
>         conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
>         conf->remove_retries = 0;
> +       conf->ghost_delay = DEFAULT_GHOST_DELAY;
>
>         /*
>          * preload default hwtable
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 240730b..67ff983 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -80,6 +80,7 @@ struct hwentry {
>         int san_path_err_recovery_time;
>         int skip_kpartx;
>         int max_sectors_kb;
> +       int ghost_delay;
>         char * bl_product;
>  };
>
> @@ -112,6 +113,7 @@ struct mpentry {
>         int san_path_err_recovery_time;
>         int skip_kpartx;
>         int max_sectors_kb;
> +       int ghost_delay;
>         uid_t uid;
>         gid_t gid;
>         mode_t mode;
> @@ -170,6 +172,7 @@ struct config {
>         int disable_changed_wwids;
>         int remove_retries;
>         int max_sectors_kb;
> +       int ghost_delay;
>         unsigned int version[3];
>
>         char * multipath_dir;
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 7a3db31..e2f393f 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -300,6 +300,7 @@ int setup_map(struct multipath *mpp, char *params, int
> params_size)
>         select_san_path_err_recovery_time(conf, mpp);
>         select_skip_kpartx(conf, mpp);
>         select_max_sectors_kb(conf, mpp);
> +       select_ghost_delay(conf, mpp);
>
>         sysfs_set_scsi_tmo(mpp, conf->checkint);
>         put_multipath_config(conf);
> @@ -760,6 +761,9 @@ int domap(struct multipath *mpp, char *params, int
> is_daemon)
>                 }
>
>                 sysfs_set_max_sectors_kb(mpp, 0);
> +               if (is_daemon && mpp->ghost_delay > 0 && mpp->nr_active &&
> +                   pathcount(mpp, PATH_GHOST) == mpp->nr_active)
> +                       mpp->ghost_delay_tick = mpp->ghost_delay;
>                 r = dm_addmap_create(mpp, params);
>
>                 lock_multipath(mpp, 0);
> @@ -767,11 +771,15 @@ int domap(struct multipath *mpp, char *params, int
> is_daemon)
>
>         case ACT_RELOAD:
>                 sysfs_set_max_sectors_kb(mpp, 1);
> +               if (mpp->ghost_delay_tick > 0 && pathcount(mpp, PATH_UP))
> +                       mpp->ghost_delay_tick = 0;
>                 r = dm_addmap_reload(mpp, params, 0);
>                 break;
>
>         case ACT_RESIZE:
>                 sysfs_set_max_sectors_kb(mpp, 1);
> +               if (mpp->ghost_delay_tick > 0 && pathcount(mpp, PATH_UP))
> +                       mpp->ghost_delay_tick = 0;
>                 r = dm_addmap_reload(mpp, params, 1);
>                 break;
>
> @@ -789,6 +797,9 @@ int domap(struct multipath *mpp, char *params, int
> is_daemon)
>                 put_multipath_config(conf);
>                 if (r) {
>                         sysfs_set_max_sectors_kb(mpp, 1);
> +                       if (mpp->ghost_delay_tick > 0 &&
> +                           pathcount(mpp, PATH_UP))
> +                               mpp->ghost_delay_tick = 0;
>                         r = dm_addmap_reload(mpp, params, 0);
>                 }
>                 break;
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 740ccf4..c9e3411 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -40,6 +40,7 @@
>  #define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF
>  #define DEFAULT_DISABLE_CHANGED_WWIDS 0
>  #define DEFAULT_MAX_SECTORS_KB MAX_SECTORS_KB_UNDEF
> +#define DEFAULT_GHOST_DELAY GHOST_DELAY_OFF
>
>  #define DEFAULT_CHECKINT       5
>  #define MAX_CHECKINT(a)                (a << 2)
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index fcac6bc..573fc75 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -378,7 +378,7 @@ static uint16_t build_udev_flags(const struct
> multipath *mpp, int reload)
>         /* DM_UDEV_DISABLE_LIBRARY_FALLBACK is added in dm_addmap */
>         return  (mpp->skip_kpartx == SKIP_KPARTX_ON ?
>                  MPATH_UDEV_NO_KPARTX_FLAG : 0) |
> -               (mpp->nr_active == 0 ?
> +               ((mpp->nr_active == 0 || mpp->ghost_delay_tick > 0)?
>                  MPATH_UDEV_NO_PATHS_FLAG : 0) |
>                 (reload && !mpp->force_udev_reload ?
>                  MPATH_UDEV_RELOAD_FLAG : 0);
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 36cccc9..54652d4 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -1110,6 +1110,16 @@ declare_hw_handler(san_path_err_recovery_time,
> set_off_int_undef)
>  declare_hw_snprint(san_path_err_recovery_time, print_off_int_undef)
>  declare_mp_handler(san_path_err_recovery_time, set_off_int_undef)
>  declare_mp_snprint(san_path_err_recovery_time, print_off_int_undef)
> +
> +declare_def_handler(ghost_delay, set_off_int_undef)
> +declare_def_snprint(ghost_delay, print_off_int_undef)
> +declare_ovr_handler(ghost_delay, set_off_int_undef)
> +declare_ovr_snprint(ghost_delay, print_off_int_undef)
> +declare_hw_handler(ghost_delay, set_off_int_undef)
> +declare_hw_snprint(ghost_delay, print_off_int_undef)
> +declare_mp_handler(ghost_delay, set_off_int_undef)
> +declare_mp_snprint(ghost_delay, print_off_int_undef)
> +
>  static int
>  def_uxsock_timeout_handler(struct config *conf, vector strvec)
>  {
> @@ -1456,6 +1466,7 @@ init_keywords(vector keywords)
>         install_keyword("disable_changed_wwids",
> &def_disable_changed_wwids_handler, &snprint_def_disable_changed_wwids);
>         install_keyword("remove_retries", &def_remove_retries_handler,
> &snprint_def_remove_retries);
>         install_keyword("max_sectors_kb", &def_max_sectors_kb_handler,
> &snprint_def_max_sectors_kb);
> +       install_keyword("ghost_delay", &def_ghost_delay_handler,
> &snprint_def_ghost_delay);
>         __deprecated install_keyword("default_selector",
> &def_selector_handler, NULL);
>         __deprecated install_keyword("default_path_grouping_policy",
> &def_pgpolicy_handler, NULL);
>         __deprecated install_keyword("default_uid_attribute",
> &def_uid_attribute_handler, NULL);
> @@ -1535,6 +1546,7 @@ init_keywords(vector keywords)
>         install_keyword("san_path_err_recovery_time",
> &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_
> recovery_time);
>         install_keyword("skip_kpartx", &hw_skip_kpartx_handler,
> &snprint_hw_skip_kpartx);
>         install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler,
> &snprint_hw_max_sectors_kb);
> +       install_keyword("ghost_delay", &hw_ghost_delay_handler,
> &snprint_hw_ghost_delay);
>         install_sublevel_end();
>
>         install_keyword_root("overrides", &overrides_handler);
> @@ -1569,6 +1581,7 @@ init_keywords(vector keywords)
>
>         install_keyword("skip_kpartx", &ovr_skip_kpartx_handler,
> &snprint_ovr_skip_kpartx);
>         install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler,
> &snprint_ovr_max_sectors_kb);
> +       install_keyword("ghost_delay", &ovr_ghost_delay_handler,
> &snprint_ovr_ghost_delay);
>
>         install_keyword_root("multipaths", &multipaths_handler);
>         install_keyword_multi("multipath", &multipath_handler, NULL);
> @@ -1600,5 +1613,6 @@ init_keywords(vector keywords)
>         install_keyword("san_path_err_recovery_time",
> &mp_san_path_err_recovery_time_handler, &snprint_mp_san_path_err_
> recovery_time);
>         install_keyword("skip_kpartx", &mp_skip_kpartx_handler,
> &snprint_mp_skip_kpartx);
>         install_keyword("max_sectors_kb", &mp_max_sectors_kb_handler,
> &snprint_mp_max_sectors_kb);
> +       install_keyword("ghost_delay", &mp_ghost_delay_handler,
> &snprint_mp_ghost_delay);
>         install_sublevel_end();
>  }
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 78de1fa..7226fb1 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -72,6 +72,7 @@
>                 .delay_wait_checks = DELAY_CHECKS_OFF,
>                 .skip_kpartx   = SKIP_KPARTX_OFF,
>                 .max_sectors_kb = MAX_SECTORS_KB_UNDEF,
> +               .ghost_delay = GHOST_DELAY_OFF
>         },
>  #endif
>
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 00adc0d..6721cc6 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -835,3 +835,18 @@ out:
>                 origin);
>         return 0;
>  }
> +
> +int select_ghost_delay (struct config *conf, struct multipath * mp)
> +{
> +       char *origin, buff[12];
> +
> +       mp_set_mpe(ghost_delay);
> +       mp_set_ovr(ghost_delay);
> +       mp_set_hwe(ghost_delay);
> +       mp_set_conf(ghost_delay);
> +       mp_set_default(ghost_delay, DEFAULT_GHOST_DELAY);
> +out:
> +       print_off_int_undef(buff, 12, &mp->ghost_delay);
> +       condlog(3, "%s: ghost_delay = %s %s", mp->alias, buff, origin);
> +       return 0;
> +}
> diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> index f8e96d8..494fb10 100644
> --- a/libmultipath/propsel.h
> +++ b/libmultipath/propsel.h
> @@ -25,6 +25,7 @@ int select_delay_watch_checks (struct config *conf,
> struct multipath * mp);
>  int select_delay_wait_checks (struct config *conf, struct multipath * mp);
>  int select_skip_kpartx (struct config *conf, struct multipath * mp);
>  int select_max_sectors_kb (struct config *conf, struct multipath * mp);
> +int select_ghost_delay(struct config *conf, struct multipath * mp);
>  int select_san_path_err_forget_rate(struct config *conf, struct
> multipath *mp);
>  int select_san_path_err_threshold(struct config *conf, struct multipath
> *mp);
>  int select_san_path_err_recovery_time(struct config *conf, struct
> multipath *mp);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index f06824a..d2d7701 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -167,6 +167,11 @@ enum no_undef_states {
>         NU_UNDEF = 0,
>  };
>
> +enum ghost_delay_states {
> +       GHOST_DELAY_OFF = NU_NO,
> +       GHOST_DELAY_UNDEF = NU_UNDEF,
> +};
> +
>  enum initialized_states {
>         INIT_FAILED,
>         INIT_MISSING_UDEV,
> @@ -282,6 +287,8 @@ struct multipath {
>         int max_sectors_kb;
>         int force_readonly;
>         int force_udev_reload;
> +       int ghost_delay;
> +       int ghost_delay_tick;
>         unsigned int dev_loss;
>         uid_t uid;
>         gid_t gid;
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 4bd1a8d..8783124 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -1017,6 +1017,19 @@ The default is: \fB<device dependent>\fR
>  .RE
>  .
>  .
> +.TP
> +.B ghost_delay
> +Sets the number of seconds that multipath will wait after creating a
> device
> +with only ghost paths before marking it ready for use in systemd. This
> gives
> +the active paths time to appear before the multipath runs the hardware
> handler
> +to switch the ghost paths to active ones. Setting this to \fI0\fR or
> \fIon\fR
> +makes multipath immediately mark a device with only ghost paths as ready.
> +.RS
> +.TP
> +The default is \fBno\fR
> +.RE
> +.
> +.
>  .\" ------------------------------------------------------------
> ----------------
>  .SH "blacklist section"
>  .\" ------------------------------------------------------------
> ----------------
> @@ -1157,6 +1170,8 @@ are taken from the \fIdefaults\fR or \fIdevices\fR
> section:
>  .B skip_kpartx
>  .TP
>  .B max_sectors_kb
> +.TP
> +.B ghost_delay
>  .RE
>  .PD
>  .LP
> @@ -1284,6 +1299,8 @@ section:
>  .B skip_kpartx
>  .TP
>  .B max_sectors_kb
> +.TP
> +.B ghost_delay
>  .RE
>  .PD
>  .LP
> @@ -1354,6 +1371,8 @@ the values are taken from the \fIdevices\fR or
> \fIdefaults\fR sections:
>  .B delay_wait_checks
>  .TP
>  .B skip_kpartx
> +.TP
> +.B ghost_delay
>  .RE
>  .PD
>  .LP
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 8049da2..c475fcd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -351,6 +351,8 @@ sync_map_state(struct multipath *mpp)
>                             pp->state == PATH_WILD ||
>                             pp->state == PATH_DELAYED)
>                                 continue;
> +                       if (mpp->ghost_delay_tick > 0)
> +                               continue;
>                         if ((pp->dmstate == PSTATE_FAILED ||
>                              pp->dmstate == PSTATE_UNDEF) &&
>                             (pp->state == PATH_UP || pp->state ==
> PATH_GHOST))
> @@ -735,7 +737,8 @@ ev_add_path (struct path * pp, struct vectors * vecs,
> int need_do_map)
>         mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
>         if (mpp && mpp->wait_for_udev &&
>             (pathcount(mpp, PATH_UP) > 0 ||
> -            (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs !=
> TPGS_IMPLICIT))) {
> +            (pathcount(mpp, PATH_GHOST) > 0 && pp->tpgs != TPGS_IMPLICIT
> &&
> +             mpp->ghost_delay_tick <= 0))) {
>                 /* if wait_for_udev is set and valid paths exist */
>                 condlog(2, "%s: delaying path addition until %s is fully
> initialized", pp->dev, mpp->alias);
>                 mpp->wait_for_udev = 2;
> @@ -1416,6 +1419,28 @@ missing_uev_wait_tick(struct vectors *vecs)
>  }
>
>  static void
> +ghost_delay_tick(struct vectors *vecs)
> +{
> +       struct multipath * mpp;
> +       unsigned int i;
> +
> +       vector_foreach_slot (vecs->mpvec, mpp, i) {
> +               if (mpp->ghost_delay_tick <= 0)
> +                       continue;
> +               if (--mpp->ghost_delay_tick <= 0) {
> +                       condlog(0, "%s: timed out waiting for active path",
> +                               mpp->alias);
> +                       mpp->force_udev_reload = 1;
> +                       if (update_map(mpp, vecs) != 0) {
> +                               /* update_map removed map */
> +                               i--;
> +                               continue;
> +                       }
> +               }
> +       }
> +}
> +
> +static void
>  defered_failback_tick (vector mpvec)
>  {
>         struct multipath * mpp;
> @@ -1961,6 +1986,7 @@ checkerloop (void *ap)
>                 defered_failback_tick(vecs->mpvec);
>                 retry_count_tick(vecs->mpvec);
>                 missing_uev_wait_tick(vecs);
> +               ghost_delay_tick(vecs);
>                 lock_cleanup_pop(vecs->lock);
>
>                 if (count)
> --
> 2.7.4
>
>

--001a11402ada886c98055e0d356e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Ben,<div><br></div><div>the patchset is merged until th=
is patch.</div><div>Can you consider rebasing it ?</div><div><br></div><div=
>Thanks,</div><div>Christophe.</div></div><div class=3D"gmail_extra"><br><d=
iv class=3D"gmail_quote">On Wed, Nov 8, 2017 at 1:15 AM, Benjamin Marzinski=
 <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat.com" target=3D"_bl=
ank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex">If the lower-priority passive paths for a multipath device appear fir=
st,<br>
IO can go to them and cause the hardware handler to activate them,<br>
before the higher priority paths appear, causing the devices to<br>
failback. Setting the &quot;ghost_delay&quot; parameter to a value greater =
than<br>
0 can avoid this ping-ponging by causing udev to not mark the device as<br>
Ready after its initial creation until either an active path appears,<br>
or ghost_delay seconds have passed. Multipathd does this by setting<br>
the MPATH_UDEV_NO_PATHS_FLAG.<br>
<br>
Signed-off-by: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com=
">bmarzins@redhat.com</a>&gt;<br>
---<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 3 +++<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 3 +++<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0| 11 +++++++++++<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0|=C2=A0 2 +-<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 14 ++++++++++++++<br=
>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0| 15 +++++++++++++++<br>
=C2=A0libmultipath/propsel.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 7 +++++++<br>
=C2=A0multipath/multipath.conf.5 | 19 +++++++++++++++++++<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 28 ++++++++++++=
+++++++++++++++-<br>
=C2=A012 files changed, 103 insertions(+), 2 deletions(-)<br>
<br>
diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
index ea2359a..9486116 100644<br>
--- a/libmultipath/config.c<br>
+++ b/libmultipath/config.c<br>
@@ -351,6 +351,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 merge_num(delay_wait_checks);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 merge_num(skip_kpartx);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 merge_num(max_sectors_kb);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0merge_num(ghost_delay);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 merge_num(san_path_err_<wbr>threshold);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 merge_num(san_path_err_forget_<wbr>rate);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 merge_num(san_path_err_<wbr>recovery_time);<br>
@@ -422,6 +423,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hwe-&gt;retain_hwhandler =3D dhwe-&gt;retain_hw=
handler;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hwe-&gt;detect_prio =3D dhwe-&gt;detect_prio;<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hwe-&gt;detect_checker =3D dhwe-&gt;detect_chec=
ker;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0hwe-&gt;ghost_delay =3D dhwe-&gt;ghost_delay;<b=
r>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dhwe-&gt;bl_product &amp;&amp; !(hwe-&gt;bl=
_product =3D set_param_str(dhwe-&gt;bl_<wbr>product)))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;<br>
@@ -622,6 +624,7 @@ load_config (char * file)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;uev_wait_timeout =3D DEFAULT_UEV_WAIT_=
TIMEOUT;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;disable_changed_wwids =3D DEFAULT_DISA=
BLE_CHANGED_WWIDS;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf-&gt;remove_retries =3D 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0conf-&gt;ghost_delay =3D DEFAULT_GHOST_DELAY;<b=
r>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /*<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* preload default hwtable<br>
diff --git a/libmultipath/config.h b/libmultipath/config.h<br>
index 240730b..67ff983 100644<br>
--- a/libmultipath/config.h<br>
+++ b/libmultipath/config.h<br>
@@ -80,6 +80,7 @@ struct hwentry {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int san_path_err_recovery_time;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int skip_kpartx;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int max_sectors_kb;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int ghost_delay;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * bl_product;<br>
=C2=A0};<br>
<br>
@@ -112,6 +113,7 @@ struct mpentry {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int san_path_err_recovery_time;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int skip_kpartx;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int max_sectors_kb;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int ghost_delay;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uid_t uid;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 gid_t gid;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mode_t mode;<br>
@@ -170,6 +172,7 @@ struct config {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int disable_changed_wwids;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int remove_retries;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int max_sectors_kb;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int ghost_delay;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int version[3];<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * multipath_dir;<br>
diff --git a/libmultipath/configure.c b/libmultipath/configure.c<br>
index 7a3db31..e2f393f 100644<br>
--- a/libmultipath/configure.c<br>
+++ b/libmultipath/configure.c<br>
@@ -300,6 +300,7 @@ int setup_map(struct multipath *mpp, char *params, int =
params_size)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 select_san_path_err_recovery_<wbr>time(conf, mp=
p);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 select_skip_kpartx(conf, mpp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 select_max_sectors_kb(conf, mpp);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0select_ghost_delay(conf, mpp);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sysfs_set_scsi_tmo(mpp, conf-&gt;checkint);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 put_multipath_config(conf);<br>
@@ -760,6 +761,9 @@ int domap(struct multipath *mpp, char *params, int is_d=
aemon)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sysfs_set_max_secto=
rs_kb(mpp, 0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_daemon &amp;=
&amp; mpp-&gt;ghost_delay &gt; 0 &amp;&amp; mpp-&gt;nr_active &amp;&amp;<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pathc=
ount(mpp, PATH_GHOST) =3D=3D mpp-&gt;nr_active)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mpp-&gt;ghost_delay_tick =3D mpp-&gt;ghost_delay;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D dm_addmap_cre=
ate(mpp, params);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lock_multipath(mpp,=
 0);<br>
@@ -767,11 +771,15 @@ int domap(struct multipath *mpp, char *params, int is=
_daemon)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case ACT_RELOAD:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sysfs_set_max_secto=
rs_kb(mpp, 1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;ghost_d=
elay_tick &gt; 0 &amp;&amp; pathcount(mpp, PATH_UP))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mpp-&gt;ghost_delay_tick =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D dm_addmap_rel=
oad(mpp, params, 0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case ACT_RESIZE:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sysfs_set_max_secto=
rs_kb(mpp, 1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;ghost_d=
elay_tick &gt; 0 &amp;&amp; pathcount(mpp, PATH_UP))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mpp-&gt;ghost_delay_tick =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 r =3D dm_addmap_rel=
oad(mpp, params, 1);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
<br>
@@ -789,6 +797,9 @@ int domap(struct multipath *mpp, char *params, int is_d=
aemon)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 put_multipath_confi=
g(conf);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (r) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 sysfs_set_max_sectors_kb(mpp, 1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (mpp-&gt;ghost_delay_tick &gt; 0 &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0pathcount(mpp, PATH_UP))<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;ghost_delay_tick =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 r =3D dm_addmap_reload(mpp, params, 0);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;<br>
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h<br>
index 740ccf4..c9e3411 100644<br>
--- a/libmultipath/defaults.h<br>
+++ b/libmultipath/defaults.h<br>
@@ -40,6 +40,7 @@<br>
=C2=A0#define DEFAULT_SKIP_KPARTX SKIP_KPARTX_OFF<br>
=C2=A0#define DEFAULT_DISABLE_CHANGED_WWIDS 0<br>
=C2=A0#define DEFAULT_MAX_SECTORS_KB MAX_SECTORS_KB_UNDEF<br>
+#define DEFAULT_GHOST_DELAY GHOST_DELAY_OFF<br>
<br>
=C2=A0#define DEFAULT_CHECKINT=C2=A0 =C2=A0 =C2=A0 =C2=A05<br>
=C2=A0#define MAX_CHECKINT(a)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (a &lt;&lt; 2)<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index fcac6bc..573fc75 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -378,7 +378,7 @@ static uint16_t build_udev_flags(const struct multipath=
 *mpp, int reload)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* DM_UDEV_DISABLE_LIBRARY_<wbr>FALLBACK is add=
ed in dm_addmap */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return=C2=A0 (mpp-&gt;skip_kpartx =3D=3D SKIP_K=
PARTX_ON ?<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MPATH_UDEV_NO=
_KPARTX_FLAG : 0) |<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(mpp-&gt;nr_active =
=3D=3D 0 ?<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0((mpp-&gt;nr_active=
 =3D=3D 0 || mpp-&gt;ghost_delay_tick &gt; 0)?<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MPATH_UDEV_NO=
_PATHS_FLAG : 0) |<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (reload &amp;&amp; =
!mpp-&gt;force_udev_reload ?<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0MPATH_UDEV_RE=
LOAD_FLAG : 0);<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index 36cccc9..54652d4 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -1110,6 +1110,16 @@ declare_hw_handler(san_path_<wbr>err_recovery_time, =
set_off_int_undef)<br>
=C2=A0declare_hw_snprint(san_path_<wbr>err_recovery_time, print_off_int_und=
ef)<br>
=C2=A0declare_mp_handler(san_path_<wbr>err_recovery_time, set_off_int_undef=
)<br>
=C2=A0declare_mp_snprint(san_path_<wbr>err_recovery_time, print_off_int_und=
ef)<br>
+<br>
+declare_def_handler(ghost_<wbr>delay, set_off_int_undef)<br>
+declare_def_snprint(ghost_<wbr>delay, print_off_int_undef)<br>
+declare_ovr_handler(ghost_<wbr>delay, set_off_int_undef)<br>
+declare_ovr_snprint(ghost_<wbr>delay, print_off_int_undef)<br>
+declare_hw_handler(ghost_<wbr>delay, set_off_int_undef)<br>
+declare_hw_snprint(ghost_<wbr>delay, print_off_int_undef)<br>
+declare_mp_handler(ghost_<wbr>delay, set_off_int_undef)<br>
+declare_mp_snprint(ghost_<wbr>delay, print_off_int_undef)<br>
+<br>
=C2=A0static int<br>
=C2=A0def_uxsock_timeout_handler(<wbr>struct config *conf, vector strvec)<b=
r>
=C2=A0{<br>
@@ -1456,6 +1466,7 @@ init_keywords(vector keywords)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;disable_<wbr>changed_wwid=
s&quot;, &amp;def_disable_changed_wwids_<wbr>handler, &amp;snprint_def_disa=
ble_changed_<wbr>wwids);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;remove_<wbr>retries&quot;=
, &amp;def_remove_retries_handler, &amp;snprint_def_remove_retries);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;max_sectors_<wbr>kb&quot;=
, &amp;def_max_sectors_kb_handler, &amp;snprint_def_max_sectors_kb);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;ghost_delay&quot;, &amp;d=
ef_ghost_delay_handler, &amp;snprint_def_ghost_delay);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_<wbr=
>selector&quot;, &amp;def_selector_handler, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_path=
_<wbr>grouping_policy&quot;, &amp;def_pgpolicy_handler, NULL);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 __deprecated install_keyword(&quot;default_uid_=
<wbr>attribute&quot;, &amp;def_uid_attribute_handler, NULL);<br>
@@ -1535,6 +1546,7 @@ init_keywords(vector keywords)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>recover=
y_time&quot;, &amp;hw_san_path_err_recovery_<wbr>time_handler, &amp;snprint=
_hw_san_path_err_<wbr>recovery_time);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;skip_kpartx&quot;, &amp;h=
w_skip_kpartx_handler, &amp;snprint_hw_skip_kpartx);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;max_sectors_<wbr>kb&quot;=
, &amp;hw_max_sectors_kb_handler, &amp;snprint_hw_max_sectors_kb);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;ghost_delay&quot;, &amp;h=
w_ghost_delay_handler, &amp;snprint_hw_ghost_delay);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_sublevel_end();<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword_root(&quot;<wbr>overrides&quot;=
, &amp;overrides_handler);<br>
@@ -1569,6 +1581,7 @@ init_keywords(vector keywords)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;skip_kpartx&quot;, &amp;o=
vr_skip_kpartx_handler, &amp;snprint_ovr_skip_kpartx);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;max_sectors_<wbr>kb&quot;=
, &amp;ovr_max_sectors_kb_handler, &amp;snprint_ovr_max_sectors_kb);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;ghost_delay&quot;, &amp;o=
vr_ghost_delay_handler, &amp;snprint_ovr_ghost_delay);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword_root(&quot;<wbr>multipaths&quot=
;, &amp;multipaths_handler);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword_multi(&quot;<wbr>multipath&quot=
;, &amp;multipath_handler, NULL);<br>
@@ -1600,5 +1613,6 @@ init_keywords(vector keywords)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>recover=
y_time&quot;, &amp;mp_san_path_err_recovery_<wbr>time_handler, &amp;snprint=
_mp_san_path_err_<wbr>recovery_time);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;skip_kpartx&quot;, &amp;m=
p_skip_kpartx_handler, &amp;snprint_mp_skip_kpartx);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;max_sectors_<wbr>kb&quot;=
, &amp;mp_max_sectors_kb_handler, &amp;snprint_mp_max_sectors_kb);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;ghost_delay&quot;, &amp;m=
p_ghost_delay_handler, &amp;snprint_mp_ghost_delay);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_sublevel_end();<br>
=C2=A0}<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 78de1fa..7226fb1 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -72,6 +72,7 @@<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .delay_wait_checks =
=3D DELAY_CHECKS_OFF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .skip_kpartx=C2=A0 =
=C2=A0=3D SKIP_KPARTX_OFF,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .max_sectors_kb =3D=
 MAX_SECTORS_KB_UNDEF,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.ghost_delay =3D GH=
OST_DELAY_OFF<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0#endif<br>
<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index 00adc0d..6721cc6 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -835,3 +835,18 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 origin);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
+<br>
+int select_ghost_delay (struct config *conf, struct multipath * mp)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *origin, buff[12];<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_mpe(ghost_delay);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(ghost_delay);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_hwe(ghost_delay);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_conf(ghost_delay);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(ghost_delay, DEFAULT_GHOST_DELAY=
);<br>
+out:<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0print_off_int_undef(buff, 12, &amp;mp-&gt;ghost=
_delay);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: ghost_delay =3D %s %s&quot=
;, mp-&gt;alias, buff, origin);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
+}<br>
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h<br>
index f8e96d8..494fb10 100644<br>
--- a/libmultipath/propsel.h<br>
+++ b/libmultipath/propsel.h<br>
@@ -25,6 +25,7 @@ int select_delay_watch_checks (struct config *conf, struc=
t multipath * mp);<br>
=C2=A0int select_delay_wait_checks (struct config *conf, struct multipath *=
 mp);<br>
=C2=A0int select_skip_kpartx (struct config *conf, struct multipath * mp);<=
br>
=C2=A0int select_max_sectors_kb (struct config *conf, struct multipath * mp=
);<br>
+int select_ghost_delay(struct config *conf, struct multipath * mp);<br>
=C2=A0int select_san_path_err_forget_<wbr>rate(struct config *conf, struct =
multipath *mp);<br>
=C2=A0int select_san_path_err_threshold(<wbr>struct config *conf, struct mu=
ltipath *mp);<br>
=C2=A0int select_san_path_err_recovery_<wbr>time(struct config *conf, struc=
t multipath *mp);<br>
diff --git a/libmultipath/structs.h b/libmultipath/structs.h<br>
index f06824a..d2d7701 100644<br>
--- a/libmultipath/structs.h<br>
+++ b/libmultipath/structs.h<br>
@@ -167,6 +167,11 @@ enum no_undef_states {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 NU_UNDEF =3D 0,<br>
=C2=A0};<br>
<br>
+enum ghost_delay_states {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0GHOST_DELAY_OFF =3D NU_NO,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0GHOST_DELAY_UNDEF =3D NU_UNDEF,<br>
+};<br>
+<br>
=C2=A0enum initialized_states {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_FAILED,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 INIT_MISSING_UDEV,<br>
@@ -282,6 +287,8 @@ struct multipath {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int max_sectors_kb;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int force_readonly;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int force_udev_reload;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int ghost_delay;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0int ghost_delay_tick;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int dev_loss;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uid_t uid;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 gid_t gid;<br>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 4bd1a8d..8783124 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -1017,6 +1017,19 @@ The default is: \fB&lt;device dependent&gt;\fR<br>
=C2=A0.RE<br>
=C2=A0.<br>
=C2=A0.<br>
+.TP<br>
+.B ghost_delay<br>
+Sets the number of seconds that multipath will wait after creating a devic=
e<br>
+with only ghost paths before marking it ready for use in systemd. This giv=
es<br>
+the active paths time to appear before the multipath runs the hardware han=
dler<br>
+to switch the ghost paths to active ones. Setting this to \fI0\fR or \fIon=
\fR<br>
+makes multipath immediately mark a device with only ghost paths as ready.<=
br>
+.RS<br>
+.TP<br>
+The default is \fBno\fR<br>
+.RE<br>
+.<br>
+.<br>
=C2=A0.\&quot; ------------------------------<wbr>-------------------------=
-----<wbr>----------------<br>
=C2=A0.SH &quot;blacklist section&quot;<br>
=C2=A0.\&quot; ------------------------------<wbr>-------------------------=
-----<wbr>----------------<br>
@@ -1157,6 +1170,8 @@ are taken from the \fIdefaults\fR or \fIdevices\fR se=
ction:<br>
=C2=A0.B skip_kpartx<br>
=C2=A0.TP<br>
=C2=A0.B max_sectors_kb<br>
+.TP<br>
+.B ghost_delay<br>
=C2=A0.RE<br>
=C2=A0.PD<br>
=C2=A0.LP<br>
@@ -1284,6 +1299,8 @@ section:<br>
=C2=A0.B skip_kpartx<br>
=C2=A0.TP<br>
=C2=A0.B max_sectors_kb<br>
+.TP<br>
+.B ghost_delay<br>
=C2=A0.RE<br>
=C2=A0.PD<br>
=C2=A0.LP<br>
@@ -1354,6 +1371,8 @@ the values are taken from the \fIdevices\fR or \fIdef=
aults\fR sections:<br>
=C2=A0.B delay_wait_checks<br>
=C2=A0.TP<br>
=C2=A0.B skip_kpartx<br>
+.TP<br>
+.B ghost_delay<br>
=C2=A0.RE<br>
=C2=A0.PD<br>
=C2=A0.LP<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 8049da2..c475fcd 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -351,6 +351,8 @@ sync_map_state(struct multipath *mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;state =3D=3D PATH_WILD ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;state =3D=3D PATH_DELAYED)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (mpp-&gt;ghost_delay_tick &gt; 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ((pp-&gt;dmstate =3D=3D PSTATE_FAILED ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pp-&gt;dmstate =3D=3D PSTATE_UNDEF) &amp;&am=
p;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 (pp-&gt;state =3D=3D PATH_UP || pp-&gt;state =3D=
=3D PATH_GHOST))<br>
@@ -735,7 +737,8 @@ ev_add_path (struct path * pp, struct vectors * vecs, i=
nt need_do_map)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp =3D find_mp_by_wwid(vecs-&gt;mpvec, pp-&gt;=
wwid);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mpp &amp;&amp; mpp-&gt;wait_for_udev &amp;&=
amp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (pathcount(mpp, PATH_UP) &gt; 0 |=
|<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (pathcount(mpp, PATH_GHOST) &gt;=
 0 &amp;&amp; pp-&gt;tpgs !=3D TPGS_IMPLICIT))) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (pathcount(mpp, PATH_GHOST) &gt;=
 0 &amp;&amp; pp-&gt;tpgs !=3D TPGS_IMPLICIT &amp;&amp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;ghost_delay_tick &=
lt;=3D 0))) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* if wait_for_udev=
 is set and valid paths exist */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(2, &quot;%s=
: delaying path addition until %s is fully initialized&quot;, pp-&gt;dev, m=
pp-&gt;alias);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp-&gt;wait_for_ud=
ev =3D 2;<br>
@@ -1416,6 +1419,28 @@ missing_uev_wait_tick(struct vectors *vecs)<br>
=C2=A0}<br>
<br>
=C2=A0static void<br>
+ghost_delay_tick(struct vectors *vecs)<br>
+{<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0struct multipath * mpp;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int i;<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0vector_foreach_slot (vecs-&gt;mpvec, mpp, i) {<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mpp-&gt;ghost_d=
elay_tick &lt;=3D 0)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (--mpp-&gt;ghost=
_delay_tick &lt;=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0condlog(0, &quot;%s: timed out waiting for active path&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mpp-&gt;alias);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mpp-&gt;force_udev_reload =3D 1;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0if (update_map(mpp, vecs) !=3D 0) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* update_map removed map */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i--;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+}<br>
+<br>
+static void<br>
=C2=A0defered_failback_tick (vector mpvec)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct multipath * mpp;<br>
@@ -1961,6 +1986,7 @@ checkerloop (void *ap)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defered_failback_ti=
ck(vecs-&gt;<wbr>mpvec);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 retry_count_tick(ve=
cs-&gt;mpvec);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 missing_uev_wait_ti=
ck(vecs);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ghost_delay_tick(ve=
cs);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lock_cleanup_pop(ve=
cs-&gt;lock);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (count)<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.7.4<br>
<br>
</font></span></blockquote></div><br></div>

--001a11402ada886c98055e0d356e--


--===============0130205918940929459==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0130205918940929459==--
