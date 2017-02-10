From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath-tools: Remove trailing and leading
	whitespaces
Date: Fri, 10 Feb 2017 14:49:07 +0100
Message-ID: <CABr-GncZt7BTKBe7mCXSfHFphi=5jegj8UgeTCxxFm6whwZLTQ@mail.gmail.com>
References: <20170210134359.6969-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3078003602946494180=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170210134359.6969-1-xose.vazquez@gmail.com>
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

--===============3078003602946494180==
Content-Type: multipart/alternative; boundary=94eb2c1247949822ba05482d5cca

--94eb2c1247949822ba05482d5cca
Content-Type: text/plain; charset=UTF-8

Applied.
Thanks.

On Fri, Feb 10, 2017 at 2:43 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  kpartx/kpartx_id           |  6 +++---
>  libmultipath/dict.c        | 18 ++++++++--------
>  libmultipath/propsel.c     | 54 +++++++++++++++++++++++-------
> ----------------
>  multipath/multipath.conf.5 |  4 ++--
>  multipathd/main.c          |  2 +-
>  5 files changed, 42 insertions(+), 42 deletions(-)
>
> diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
> index df0e6b9..b7f802d 100755
> --- a/kpartx/kpartx_id
> +++ b/kpartx/kpartx_id
> @@ -74,16 +74,16 @@ fi
>  if [ -n "$dmdeps" ] ; then
>      case "$dmdeps" in
>         *\(94,*)
> -            echo "DM_TYPE=ccw"
> +           echo "DM_TYPE=ccw"
>             ;;
>         *\(104,* | *\(105,* | *\(106,* | *\(107,* | *\(108,* | *\(109,* |
> *\(110,* | *\(112,*)
>             echo "DM_TYPE=cciss"
>             ;;
>         *\(9*)
> -            echo "DM_TYPE=raid"
> +           echo "DM_TYPE=raid"
>             ;;
>         *)
> -            echo "DM_TYPE=scsi"
> +           echo "DM_TYPE=scsi"
>             echo "DM_WWN=0x${dmname#?}"
>             ;;
>      esac
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index ae94c88..3521c78 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -1426,9 +1426,9 @@ init_keywords(vector keywords)
>         install_keyword("config_dir", &def_config_dir_handler,
> &snprint_def_config_dir);
>         install_keyword("delay_watch_checks", &def_delay_watch_checks_handler,
> &snprint_def_delay_watch_checks);
>         install_keyword("delay_wait_checks", &def_delay_wait_checks_handler,
> &snprint_def_delay_wait_checks);
> -        install_keyword("san_path_err_threshold",
> &def_san_path_err_threshold_handler, &snprint_def_san_path_err_threshold);
> -        install_keyword("san_path_err_forget_rate",
> &def_san_path_err_forget_rate_handler, &snprint_def_san_path_err_
> forget_rate);
> -        install_keyword("san_path_err_recovery_time",
> &def_san_path_err_recovery_time_handler, &snprint_def_san_path_err_
> recovery_time);
> +       install_keyword("san_path_err_threshold",
> &def_san_path_err_threshold_handler, &snprint_def_san_path_err_threshold);
> +       install_keyword("san_path_err_forget_rate",
> &def_san_path_err_forget_rate_handler, &snprint_def_san_path_err_
> forget_rate);
> +       install_keyword("san_path_err_recovery_time",
> &def_san_path_err_recovery_time_handler, &snprint_def_san_path_err_
> recovery_time);
>
>         install_keyword("find_multipaths", &def_find_multipaths_handler,
> &snprint_def_find_multipaths);
>         install_keyword("uxsock_timeout", &def_uxsock_timeout_handler,
> &snprint_def_uxsock_timeout);
> @@ -1512,9 +1512,9 @@ init_keywords(vector keywords)
>         install_keyword("deferred_remove", &hw_deferred_remove_handler,
> &snprint_hw_deferred_remove);
>         install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler,
> &snprint_hw_delay_watch_checks);
>         install_keyword("delay_wait_checks",
> &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
> -        install_keyword("san_path_err_threshold",
> &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
> -        install_keyword("san_path_err_forget_rate",
> &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_
> forget_rate);
> -        install_keyword("san_path_err_recovery_time",
> &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_
> recovery_time);
> +       install_keyword("san_path_err_threshold",
> &hw_san_path_err_threshold_handler, &snprint_hw_san_path_err_threshold);
> +       install_keyword("san_path_err_forget_rate",
> &hw_san_path_err_forget_rate_handler, &snprint_hw_san_path_err_
> forget_rate);
> +       install_keyword("san_path_err_recovery_time",
> &hw_san_path_err_recovery_time_handler, &snprint_hw_san_path_err_
> recovery_time);
>         install_keyword("skip_kpartx", &hw_skip_kpartx_handler,
> &snprint_hw_skip_kpartx);
>         install_keyword("max_sectors_kb", &hw_max_sectors_kb_handler,
> &snprint_hw_max_sectors_kb);
>         install_sublevel_end();
> @@ -1544,9 +1544,9 @@ init_keywords(vector keywords)
>         install_keyword("deferred_remove", &ovr_deferred_remove_handler,
> &snprint_ovr_deferred_remove);
>         install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler,
> &snprint_ovr_delay_watch_checks);
>         install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler,
> &snprint_ovr_delay_wait_checks);
> -        install_keyword("san_path_err_threshold",
> &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
> -        install_keyword("san_path_err_forget_rate",
> &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_
> forget_rate);
> -        install_keyword("san_path_err_recovery_time",
> &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_
> recovery_time);
> +       install_keyword("san_path_err_threshold",
> &ovr_san_path_err_threshold_handler, &snprint_ovr_san_path_err_threshold);
> +       install_keyword("san_path_err_forget_rate",
> &ovr_san_path_err_forget_rate_handler, &snprint_ovr_san_path_err_
> forget_rate);
> +       install_keyword("san_path_err_recovery_time",
> &ovr_san_path_err_recovery_time_handler, &snprint_ovr_san_path_err_
> recovery_time);
>
>         install_keyword("skip_kpartx", &ovr_skip_kpartx_handler,
> &snprint_ovr_skip_kpartx);
>         install_keyword("max_sectors_kb", &ovr_max_sectors_kb_handler,
> &snprint_ovr_max_sectors_kb);
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index e4afef7..1b27476 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -645,47 +645,47 @@ out:
>  }
>  int select_san_path_err_threshold(struct config *conf, struct multipath
> *mp)
>  {
> -        char *origin, buff[12];
> +       char *origin, buff[12];
>
> -        mp_set_mpe(san_path_err_threshold);
> -        mp_set_ovr(san_path_err_threshold);
> -        mp_set_hwe(san_path_err_threshold);
> -        mp_set_conf(san_path_err_threshold);
> -        mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
> +       mp_set_mpe(san_path_err_threshold);
> +       mp_set_ovr(san_path_err_threshold);
> +       mp_set_hwe(san_path_err_threshold);
> +       mp_set_conf(san_path_err_threshold);
> +       mp_set_default(san_path_err_threshold, DEFAULT_ERR_CHECKS);
>  out:
> -        print_off_int_undef(buff, 12, &mp->san_path_err_threshold);
> -        condlog(3, "%s: san_path_err_threshold = %s %s", mp->alias, buff,
> origin);
> -        return 0;
> +       print_off_int_undef(buff, 12, &mp->san_path_err_threshold);
> +       condlog(3, "%s: san_path_err_threshold = %s %s", mp->alias, buff,
> origin);
> +       return 0;
>  }
>
>  int select_san_path_err_forget_rate(struct config *conf, struct
> multipath *mp)
>  {
> -        char *origin, buff[12];
> +       char *origin, buff[12];
>
> -        mp_set_mpe(san_path_err_forget_rate);
> -        mp_set_ovr(san_path_err_forget_rate);
> -        mp_set_hwe(san_path_err_forget_rate);
> -        mp_set_conf(san_path_err_forget_rate);
> -        mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
> +       mp_set_mpe(san_path_err_forget_rate);
> +       mp_set_ovr(san_path_err_forget_rate);
> +       mp_set_hwe(san_path_err_forget_rate);
> +       mp_set_conf(san_path_err_forget_rate);
> +       mp_set_default(san_path_err_forget_rate, DEFAULT_ERR_CHECKS);
>  out:
> -        print_off_int_undef(buff, 12, &mp->san_path_err_forget_rate);
> -        condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias,
> buff, origin);
> -        return 0;
> +       print_off_int_undef(buff, 12, &mp->san_path_err_forget_rate);
> +       condlog(3, "%s: san_path_err_forget_rate = %s %s", mp->alias,
> buff, origin);
> +       return 0;
>
>  }
>  int select_san_path_err_recovery_time(struct config *conf, struct
> multipath *mp)
>  {
> -        char *origin, buff[12];
> +       char *origin, buff[12];
>
> -        mp_set_mpe(san_path_err_recovery_time);
> -        mp_set_ovr(san_path_err_recovery_time);
> -        mp_set_hwe(san_path_err_recovery_time);
> -        mp_set_conf(san_path_err_recovery_time);
> -        mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
> +       mp_set_mpe(san_path_err_recovery_time);
> +       mp_set_ovr(san_path_err_recovery_time);
> +       mp_set_hwe(san_path_err_recovery_time);
> +       mp_set_conf(san_path_err_recovery_time);
> +       mp_set_default(san_path_err_recovery_time, DEFAULT_ERR_CHECKS);
>  out:
> -        print_off_int_undef(buff, 12, &mp->san_path_err_recovery_time);
> -        condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias,
> buff, origin);
> -        return 0;
> +       print_off_int_undef(buff, 12, &mp->san_path_err_recovery_time);
> +       condlog(3, "%s: san_path_err_recovery_time = %s %s", mp->alias,
> buff, origin);
> +       return 0;
>
>  }
>  int select_skip_kpartx (struct config *conf, struct multipath * mp)
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 3c564ad..7de8bc7 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -755,7 +755,7 @@ The default is: \fB/etc/multipath/conf.d/\fR
>  If set to a value greater than 0, multipathd will watch paths and check
> how many
>  times a path has been failed due to errors.If the number of failures on a
> particular
>  path is greater then the san_path_err_threshold then the path will not
> reinstante
> -till san_path_err_recovery_time.These path failures should occur within a
> +till san_path_err_recovery_time.These path failures should occur within a
>  san_path_err_forget_rate checks, if not we will consider the path is good
> enough
>  to reinstantate.
>  .RS
> @@ -767,7 +767,7 @@ The default is: \fBno\fR
>  .TP
>  .B san_path_err_forget_rate
>  If set to a value greater than 0, multipathd will check whether the path
> failures
> -has exceeded  the san_path_err_threshold within this many checks i.e
> +has exceeded  the san_path_err_threshold within this many checks i.e
>  san_path_err_forget_rate . If so we will not reinstante the path till
>  san_path_err_recovery_time.
>  .RS
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1b44e4d..0f32b2c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1504,7 +1504,7 @@ static int check_path_reinstate_state(struct path *
> pp) {
>                                 (pp->mpp->san_path_err_recovery_time
> >0))) {
>                 return 0;
>         }
> -
> +
>         if (pp->disable_reinstate) {
>                 /* If we don't know how much time has passed, automatically
>                  * reinstate the path, just to be safe. Also, if there are
> --
> 2.11.1
>
>

--94eb2c1247949822ba05482d5cca
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied.<div>Thanks.</div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Fri, Feb 10, 2017 at 2:43 PM, Xose Vazqu=
ez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" ta=
rget=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe=
.varoqui@opensvc.com">christophe.varoqui@opensvc.<wbr>com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
---<br>
=C2=A0kpartx/kpartx_id=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 6 ++=
+---<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 18 ++++++++--------<=
br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0| 54 ++++++++++++++++++++++=
+-------<wbr>----------------<br>
=C2=A0multipath/multipath.conf.5 |=C2=A0 4 ++--<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 +-<br>
=C2=A05 files changed, 42 insertions(+), 42 deletions(-)<br>
<br>
diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id<br>
index df0e6b9..b7f802d 100755<br>
--- a/kpartx/kpartx_id<br>
+++ b/kpartx/kpartx_id<br>
@@ -74,16 +74,16 @@ fi<br>
=C2=A0if [ -n &quot;$dmdeps&quot; ] ; then<br>
=C2=A0 =C2=A0 =C2=A0case &quot;$dmdeps&quot; in<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *\(94,*)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo &quot;DM_TYPE=3Dccw&quot;<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;DM_TYPE=3Dccw&quot;<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *\(104,* | *\(105,* | *\(106,* | *\(107,* | *\(=
108,* | *\(109,* | *\(110,* | *\(112,*)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo &quot;DM_TYPE=3Dcciss&quot;<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *\(9*)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo &quot;DM_TYPE=3Draid&quot;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;DM_TYPE=3Draid&quot;<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ;;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 *)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo &quot;DM_TYPE=3Dscsi&quot;<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0echo &quot;DM_TYPE=3Dscsi&quot;<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo &quot;DM_WWN=3D0x${dmname#?}=
&quot;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ;;<br>
=C2=A0 =C2=A0 =C2=A0esac<br>
diff --git a/libmultipath/dict.c b/libmultipath/dict.c<br>
index ae94c88..3521c78 100644<br>
--- a/libmultipath/dict.c<br>
+++ b/libmultipath/dict.c<br>
@@ -1426,9 +1426,9 @@ init_keywords(vector keywords)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;config_dir&quot;, &amp;de=
f_config_dir_handler, &amp;snprint_def_config_dir);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;delay_watch_<wbr>checks&q=
uot;, &amp;def_delay_watch_checks_<wbr>handler, &amp;snprint_def_delay_watc=
h_<wbr>checks);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;delay_wait_<wbr>checks&qu=
ot;, &amp;def_delay_wait_checks_<wbr>handler, &amp;snprint_def_delay_wait_<=
wbr>checks);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>thresh=
old&quot;, &amp;def_san_path_err_threshold_<wbr>handler, &amp;snprint_def_s=
an_path_err_<wbr>threshold);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>forget=
_rate&quot;, &amp;def_san_path_err_forget_rate_<wbr>handler, &amp;snprint_d=
ef_san_path_err_<wbr>forget_rate);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>recove=
ry_time&quot;, &amp;def_san_path_err_recovery_<wbr>time_handler, &amp;snpri=
nt_def_san_path_err_<wbr>recovery_time);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>thresho=
ld&quot;, &amp;def_san_path_err_threshold_<wbr>handler, &amp;snprint_def_sa=
n_path_err_<wbr>threshold);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>forget_=
rate&quot;, &amp;def_san_path_err_forget_rate_<wbr>handler, &amp;snprint_de=
f_san_path_err_<wbr>forget_rate);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>recover=
y_time&quot;, &amp;def_san_path_err_recovery_<wbr>time_handler, &amp;snprin=
t_def_san_path_err_<wbr>recovery_time);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;find_<wbr>multipaths&quot=
;, &amp;def_find_multipaths_handler, &amp;snprint_def_find_multipaths);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;uxsock_<wbr>timeout&quot;=
, &amp;def_uxsock_timeout_handler, &amp;snprint_def_uxsock_timeout);<br>
@@ -1512,9 +1512,9 @@ init_keywords(vector keywords)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;deferred_<wbr>remove&quot=
;, &amp;hw_deferred_remove_handler, &amp;snprint_hw_deferred_remove);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;delay_watch_<wbr>checks&q=
uot;, &amp;hw_delay_watch_checks_<wbr>handler, &amp;snprint_hw_delay_watch_=
<wbr>checks);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;delay_wait_<wbr>checks&qu=
ot;, &amp;hw_delay_wait_checks_handler, &amp;snprint_hw_delay_wait_checks)<=
wbr>;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>thresh=
old&quot;, &amp;hw_san_path_err_threshold_<wbr>handler, &amp;snprint_hw_san=
_path_err_<wbr>threshold);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>forget=
_rate&quot;, &amp;hw_san_path_err_forget_rate_<wbr>handler, &amp;snprint_hw=
_san_path_err_<wbr>forget_rate);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>recove=
ry_time&quot;, &amp;hw_san_path_err_recovery_<wbr>time_handler, &amp;snprin=
t_hw_san_path_err_<wbr>recovery_time);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>thresho=
ld&quot;, &amp;hw_san_path_err_threshold_<wbr>handler, &amp;snprint_hw_san_=
path_err_<wbr>threshold);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>forget_=
rate&quot;, &amp;hw_san_path_err_forget_rate_<wbr>handler, &amp;snprint_hw_=
san_path_err_<wbr>forget_rate);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>recover=
y_time&quot;, &amp;hw_san_path_err_recovery_<wbr>time_handler, &amp;snprint=
_hw_san_path_err_<wbr>recovery_time);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;skip_kpartx&quot;, &amp;h=
w_skip_kpartx_handler, &amp;snprint_hw_skip_kpartx);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;max_sectors_<wbr>kb&quot;=
, &amp;hw_max_sectors_kb_handler, &amp;snprint_hw_max_sectors_kb);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_sublevel_end();<br>
@@ -1544,9 +1544,9 @@ init_keywords(vector keywords)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;deferred_<wbr>remove&quot=
;, &amp;ovr_deferred_remove_handler, &amp;snprint_ovr_deferred_remove);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;delay_watch_<wbr>checks&q=
uot;, &amp;ovr_delay_watch_checks_<wbr>handler, &amp;snprint_ovr_delay_watc=
h_<wbr>checks);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;delay_wait_<wbr>checks&qu=
ot;, &amp;ovr_delay_wait_checks_<wbr>handler, &amp;snprint_ovr_delay_wait_<=
wbr>checks);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>thresh=
old&quot;, &amp;ovr_san_path_err_threshold_<wbr>handler, &amp;snprint_ovr_s=
an_path_err_<wbr>threshold);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>forget=
_rate&quot;, &amp;ovr_san_path_err_forget_rate_<wbr>handler, &amp;snprint_o=
vr_san_path_err_<wbr>forget_rate);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;san_path_err_<wbr>recove=
ry_time&quot;, &amp;ovr_san_path_err_recovery_<wbr>time_handler, &amp;snpri=
nt_ovr_san_path_err_<wbr>recovery_time);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>thresho=
ld&quot;, &amp;ovr_san_path_err_threshold_<wbr>handler, &amp;snprint_ovr_sa=
n_path_err_<wbr>threshold);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>forget_=
rate&quot;, &amp;ovr_san_path_err_forget_rate_<wbr>handler, &amp;snprint_ov=
r_san_path_err_<wbr>forget_rate);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0install_keyword(&quot;san_path_err_<wbr>recover=
y_time&quot;, &amp;ovr_san_path_err_recovery_<wbr>time_handler, &amp;snprin=
t_ovr_san_path_err_<wbr>recovery_time);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;skip_kpartx&quot;, &amp;o=
vr_skip_kpartx_handler, &amp;snprint_ovr_skip_kpartx);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 install_keyword(&quot;max_sectors_<wbr>kb&quot;=
, &amp;ovr_max_sectors_kb_handler, &amp;snprint_ovr_max_sectors_kb);<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index e4afef7..1b27476 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -645,47 +645,47 @@ out:<br>
=C2=A0}<br>
=C2=A0int select_san_path_err_threshold(<wbr>struct config *conf, struct mu=
ltipath *mp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *origin, buff[12];<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(san_path_err_<wbr>threshold);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_ovr(san_path_err_<wbr>threshold);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(san_path_err_<wbr>threshold);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(san_path_err_<wbr>threshold);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(san_path_err_<wbr>threshold, DE=
FAULT_ERR_CHECKS);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_mpe(san_path_err_<wbr>threshold);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(san_path_err_<wbr>threshold);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_hwe(san_path_err_<wbr>threshold);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_conf(san_path_err_<wbr>threshold);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(san_path_err_<wbr>threshold, DEF=
AULT_ERR_CHECKS);<br>
=C2=A0out:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 print_off_int_undef(buff, 12, &amp;mp-&gt;san_=
path_err_threshold);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: san_path_err_threshold =
=3D %s %s&quot;, mp-&gt;alias, buff, origin);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0print_off_int_undef(buff, 12, &amp;mp-&gt;san_p=
ath_err_threshold);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: san_path_err_threshold =3D=
 %s %s&quot;, mp-&gt;alias, buff, origin);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
=C2=A0}<br>
<br>
=C2=A0int select_san_path_err_forget_<wbr>rate(struct config *conf, struct =
multipath *mp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *origin, buff[12];<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(san_path_err_<wbr>forget_rate);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_ovr(san_path_err_<wbr>forget_rate);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(san_path_err_<wbr>forget_rate);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(san_path_err_<wbr>forget_rate);<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(san_path_err_<wbr>forget_rate, =
DEFAULT_ERR_CHECKS);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_mpe(san_path_err_<wbr>forget_rate);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(san_path_err_<wbr>forget_rate);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_hwe(san_path_err_<wbr>forget_rate);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_conf(san_path_err_<wbr>forget_rate);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(san_path_err_<wbr>forget_rate, D=
EFAULT_ERR_CHECKS);<br>
=C2=A0out:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 print_off_int_undef(buff, 12, &amp;mp-&gt;san_=
path_err_forget_rate)<wbr>;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: san_path_err_forget_rate =
=3D %s %s&quot;, mp-&gt;alias, buff, origin);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0print_off_int_undef(buff, 12, &amp;mp-&gt;san_p=
ath_err_forget_rate)<wbr>;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: san_path_err_forget_rate =
=3D %s %s&quot;, mp-&gt;alias, buff, origin);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
<br>
=C2=A0}<br>
=C2=A0int select_san_path_err_recovery_<wbr>time(struct config *conf, struc=
t multipath *mp)<br>
=C2=A0{<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0char *origin, buff[12];<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_mpe(san_path_err_<wbr>recovery_time);<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_ovr(san_path_err_<wbr>recovery_time);<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_hwe(san_path_err_<wbr>recovery_time);<b=
r>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_conf(san_path_err_<wbr>recovery_time);<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 mp_set_default(san_path_err_<wbr>recovery_time=
, DEFAULT_ERR_CHECKS);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_mpe(san_path_err_<wbr>recovery_time);<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_ovr(san_path_err_<wbr>recovery_time);<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_hwe(san_path_err_<wbr>recovery_time);<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_conf(san_path_err_<wbr>recovery_time);<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0mp_set_default(san_path_err_<wbr>recovery_time,=
 DEFAULT_ERR_CHECKS);<br>
=C2=A0out:<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 print_off_int_undef(buff, 12, &amp;mp-&gt;san_=
path_err_recovery_<wbr>time);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: san_path_err_recovery_tim=
e =3D %s %s&quot;, mp-&gt;alias, buff, origin);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0print_off_int_undef(buff, 12, &amp;mp-&gt;san_p=
ath_err_recovery_<wbr>time);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0condlog(3, &quot;%s: san_path_err_recovery_time=
 =3D %s %s&quot;, mp-&gt;alias, buff, origin);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
<br>
=C2=A0}<br>
=C2=A0int select_skip_kpartx (struct config *conf, struct multipath * mp)<b=
r>
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5<br>
index 3c564ad..7de8bc7 100644<br>
--- a/multipath/multipath.conf.5<br>
+++ b/multipath/multipath.conf.5<br>
@@ -755,7 +755,7 @@ The default is: \fB/etc/multipath/conf.d/\fR<br>
=C2=A0If set to a value greater than 0, multipathd will watch paths and che=
ck how many<br>
=C2=A0times a path has been failed due to errors.If the number of failures =
on a particular<br>
=C2=A0path is greater then the san_path_err_threshold then the path will no=
t=C2=A0 reinstante<br>
-till san_path_err_recovery_time.<wbr>These path failures should occur with=
in a<br>
+till san_path_err_recovery_time.<wbr>These path failures should occur with=
in a<br>
=C2=A0san_path_err_forget_rate checks, if not we will consider the path is =
good enough<br>
=C2=A0to reinstantate.<br>
=C2=A0.RS<br>
@@ -767,7 +767,7 @@ The default is: \fBno\fR<br>
=C2=A0.TP<br>
=C2=A0.B san_path_err_forget_rate<br>
=C2=A0If set to a value greater than 0, multipathd will check whether the p=
ath failures<br>
-has exceeded=C2=A0 the san_path_err_threshold within this many checks i.e<=
br>
+has exceeded=C2=A0 the san_path_err_threshold within this many checks i.e<=
br>
=C2=A0san_path_err_forget_rate . If so we will not reinstante the path till=
<br>
=C2=A0san_path_err_recovery_time.<br>
=C2=A0.RS<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index 1b44e4d..0f32b2c 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -1504,7 +1504,7 @@ static int check_path_reinstate_state(<wbr>struct pat=
h * pp) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (pp-&gt;mpp-&gt;san_path_err_<wbr>re=
covery_time &gt;0))) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
-<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (pp-&gt;disable_reinstate) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* If we don&#39;t =
know how much time has passed, automatically<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* reinstate t=
he path, just to be safe. Also, if there are<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.11.1<br>
<br>
</font></span></blockquote></div><br></div>

--94eb2c1247949822ba05482d5cca--


--===============3078003602946494180==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3078003602946494180==--
