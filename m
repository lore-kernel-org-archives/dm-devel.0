From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/7] libmultipath: add detect_checker
	option
Date: Tue, 14 Feb 2017 16:40:44 +0100
Message-ID: <c498c93e-8b9e-4fa5-90d0-e3eba40d7ff7@suse.de>
References: <1487045213-15776-1-git-send-email-bmarzins@redhat.com>
	<1487045213-15776-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1487045213-15776-3-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 02/14/2017 05:06 AM, Benjamin Marzinski wrote:
> This patch adds a detect_checker option that works just like the
> detect_prio option.  It currently only detects ALUA devices, and
> if it finds ALUA support, it sets the priortizier to TUR. This is
> useful for devices like the VNX2, where it should be using the
> TUR checker when in ALUA mode (or so I have been told). It is set on by
> default just like detect_prio and retain_attached_hw_handler.
> =

> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |  3 +++
>  libmultipath/config.h      |  2 ++
>  libmultipath/defaults.h    |  1 +
>  libmultipath/dict.c        | 10 ++++++++++
>  libmultipath/discovery.c   | 29 +++++++++++++++++++++++++++--
>  libmultipath/hwtable.c     |  1 +
>  libmultipath/propsel.c     | 32 ++++++++++++++++++++++----------
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     | 14 ++++++++++++++
>  multipath/multipath.conf.5 | 18 ++++++++++++++++++
>  10 files changed, 99 insertions(+), 12 deletions(-)
> =

> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 15ddbd8..68a1692 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -343,6 +343,7 @@ merge_hwe (struct hwentry * dst, struct hwentry * src)
>  	merge_num(user_friendly_names);
>  	merge_num(retain_hwhandler);
>  	merge_num(detect_prio);
> +	merge_num(detect_checker);
>  	merge_num(deferred_remove);
>  	merge_num(delay_watch_checks);
>  	merge_num(delay_wait_checks);
> @@ -420,6 +421,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
>  	hwe->user_friendly_names =3D dhwe->user_friendly_names;
>  	hwe->retain_hwhandler =3D dhwe->retain_hwhandler;
>  	hwe->detect_prio =3D dhwe->detect_prio;
> +	hwe->detect_checker =3D dhwe->detect_checker;
>  =

>  	if (dhwe->bl_product && !(hwe->bl_product =3D set_param_str(dhwe->bl_pr=
oduct)))
>  		goto out;
> @@ -607,6 +609,7 @@ load_config (char * file)
>  	conf->fast_io_fail =3D DEFAULT_FAST_IO_FAIL;
>  	conf->retain_hwhandler =3D DEFAULT_RETAIN_HWHANDLER;
>  	conf->detect_prio =3D DEFAULT_DETECT_PRIO;
> +	conf->detect_checker =3D DEFAULT_DETECT_CHECKER;
>  	conf->force_sync =3D DEFAULT_FORCE_SYNC;
>  	conf->partition_delim =3D DEFAULT_PARTITION_DELIM;
>  	conf->processed_main_config =3D 0;
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 9670020..4a785ca 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -62,6 +62,7 @@ struct hwentry {
>  	int user_friendly_names;
>  	int retain_hwhandler;
>  	int detect_prio;
> +	int detect_checker;
>  	int deferred_remove;
>  	int delay_watch_checks;
>  	int delay_wait_checks;
> @@ -133,6 +134,7 @@ struct config {
>  	int reassign_maps;
>  	int retain_hwhandler;
>  	int detect_prio;
> +	int detect_checker;
>  	int force_sync;
>  	int deferred_remove;
>  	int processed_main_config;
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index b9b0a37..1e5a527 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -22,6 +22,7 @@
>  #define DEFAULT_DEV_LOSS_TMO	600
>  #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
>  #define DEFAULT_DETECT_PRIO	DETECT_PRIO_ON
> +#define DEFAULT_DETECT_CHECKER	DETECT_CHECKER_ON
>  #define DEFAULT_DEFERRED_REMOVE	DEFERRED_REMOVE_OFF
>  #define DEFAULT_DELAY_CHECKS	DELAY_CHECKS_OFF
>  #define DEFAULT_UEVENT_STACKSIZE 256
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index dc21846..53f78ea 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -379,6 +379,13 @@ declare_ovr_snprint(detect_prio, print_yes_no_undef)
>  declare_hw_handler(detect_prio, set_yes_no_undef)
>  declare_hw_snprint(detect_prio, print_yes_no_undef)
>  =

> +declare_def_handler(detect_checker, set_yes_no_undef)
> +declare_def_snprint_defint(detect_checker, print_yes_no_undef, YNU_NO)
> +declare_ovr_handler(detect_checker, set_yes_no_undef)
> +declare_ovr_snprint(detect_checker, print_yes_no_undef)
> +declare_hw_handler(detect_checker, set_yes_no_undef)
> +declare_hw_snprint(detect_checker, print_yes_no_undef)
> +
>  declare_def_handler(force_sync, set_yes_no)
>  declare_def_snprint(force_sync, print_yes_no)
>  =

> @@ -1397,6 +1404,7 @@ init_keywords(vector keywords)
>  	install_keyword("reservation_key", &def_reservation_key_handler, &snpri=
nt_def_reservation_key);
>  	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_han=
dler, &snprint_def_retain_hwhandler);
>  	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_d=
etect_prio);
> +	install_keyword("detect_checker", &def_detect_checker_handler, &snprint=
_def_detect_checker);
>  	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_for=
ce_sync);
>  	install_keyword("strict_timing", &def_strict_timing_handler, &snprint_d=
ef_strict_timing);
>  	install_keyword("deferred_remove", &def_deferred_remove_handler, &snpri=
nt_def_deferred_remove);
> @@ -1483,6 +1491,7 @@ init_keywords(vector keywords)
>  	install_keyword("user_friendly_names", &hw_user_friendly_names_handler,=
 &snprint_hw_user_friendly_names);
>  	install_keyword("retain_attached_hw_handler", &hw_retain_hwhandler_hand=
ler, &snprint_hw_retain_hwhandler);
>  	install_keyword("detect_prio", &hw_detect_prio_handler, &snprint_hw_det=
ect_prio);
> +	install_keyword("detect_checker", &hw_detect_checker_handler, &snprint_=
hw_detect_checker);
>  	install_keyword("deferred_remove", &hw_deferred_remove_handler, &snprin=
t_hw_deferred_remove);
>  	install_keyword("delay_watch_checks", &hw_delay_watch_checks_handler, &=
snprint_hw_delay_watch_checks);
>  	install_keyword("delay_wait_checks", &hw_delay_wait_checks_handler, &sn=
print_hw_delay_wait_checks);
> @@ -1512,6 +1521,7 @@ init_keywords(vector keywords)
>  	install_keyword("user_friendly_names", &ovr_user_friendly_names_handler=
, &snprint_ovr_user_friendly_names);
>  	install_keyword("retain_attached_hw_handler", &ovr_retain_hwhandler_han=
dler, &snprint_ovr_retain_hwhandler);
>  	install_keyword("detect_prio", &ovr_detect_prio_handler, &snprint_ovr_d=
etect_prio);
> +	install_keyword("detect_checker", &ovr_detect_checker_handler, &snprint=
_ovr_detect_checker);
>  	install_keyword("deferred_remove", &ovr_deferred_remove_handler, &snpri=
nt_ovr_deferred_remove);
>  	install_keyword("delay_watch_checks", &ovr_delay_watch_checks_handler, =
&snprint_ovr_delay_watch_checks);
>  	install_keyword("delay_wait_checks", &ovr_delay_wait_checks_handler, &s=
nprint_ovr_delay_wait_checks);
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index d1aec31..ed55545 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -30,6 +30,7 @@
>  #include "discovery.h"
>  #include "prio.h"
>  #include "defaults.h"
> +#include "prioritizers/alua_rtpg.h"
>  =

>  int
>  alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevi=
ce,
> @@ -829,6 +830,26 @@ get_serial (char * str, int maxlen, int fd)
>  	return 1;
>  }
>  =

> +static void
> +detect_alua(struct path * pp, struct config *conf)
> +{
> +	int ret;
> +	int tpgs =3D 0;
> +	unsigned int timeout =3D conf->checker_timeout;
> +
> +	if ((tpgs =3D get_target_port_group_support(pp->fd, timeout)) <=3D 0) {
> +		pp->is_alua =3D IS_ALUA_NO;
> +		return;
> +	}
> +	pp->tpgs =3D tpgs;
> +	ret =3D get_target_port_group(pp, timeout);
> +	if (ret < 0 || get_asymmetric_access_state(pp->fd, ret, timeout) < 0) {
> +		pp->is_alua =3D IS_ALUA_NO;
> +		return;
> +	}
> +	pp->is_alua =3D IS_ALUA_YES;
> +}
> +
>  #define DEFAULT_SGIO_LEN 254
>  =

>  static int
Why do you keep 'tgps' and 'is_alua' in two separate settings?
I was under the impression the 'tpgs' > 0 _always_ implies ALUA, no?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
