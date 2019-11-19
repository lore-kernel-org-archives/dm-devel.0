From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 4/5] libmultipath: fix (max_)polling_interval
 setting logic
Date: Tue, 19 Nov 2019 16:31:08 -0600
Message-ID: <20191119223108.GP30153@octiron.msp.redhat.com>
References: <20191115143403.31692-1-martin.wilck@suse.com>
	<20191115143403.31692-5-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191115143403.31692-5-martin.wilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Chongyun Wu <wu.chongyun@h3c.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>
List-Id: dm-devel.ids

On Fri, Nov 15, 2019 at 02:41:52PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> checkint should never be larger than max_checkint. The WATCHDOG_USEC
> setting should be honored on "reconfigure", too, not only on startup.
> Pathological values for checkint and integer overflows should be avoided.
> The logic should work reasonably well if both polling_interval and
> max_polling_interval, just one of them, or neither is set.
>=20
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c   | 40 +++++++++++++++++++++++++++++++++++++---
>  libmultipath/config.h   |  1 +
>  libmultipath/defaults.h |  3 +--
>  multipathd/main.c       | 26 ++++++--------------------
>  4 files changed, 45 insertions(+), 25 deletions(-)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 49723add..0bf7bb40 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -683,6 +683,27 @@ process_config_dir(struct config *conf, char *dir)
>  =09pthread_cleanup_pop(1);
>  }
> =20
> +static void set_max_checkint_from_watchdog(struct config *conf)
> +{
> +#ifdef USE_SYSTEMD
> +=09char *envp =3D getenv("WATCHDOG_USEC");
> +=09unsigned long checkint;
> +
> +=09if (envp && sscanf(envp, "%lu", &checkint) =3D=3D 1) {
> +=09=09/* Value is in microseconds */
> +=09=09checkint /=3D 1000000;
> +=09=09if (checkint < 1 || checkint > UINT_MAX) {
> +=09=09=09condlog(1, "invalid value for WatchdogSec: \"%s\"", envp);
> +=09=09=09return;
> +=09=09}
> +=09=09if (conf->max_checkint =3D=3D 0 || conf->max_checkint > checkint)
> +=09=09=09conf->max_checkint =3D checkint;
> +=09=09condlog(3, "enabling watchdog, interval %ld", checkint);
> +=09=09conf->use_watchdog =3D true;
> +=09}
> +#endif
> +}
> +
>  struct config *
>  load_config (char * file)
>  {
> @@ -703,7 +724,8 @@ load_config (char * file)
>  =09conf->multipath_dir =3D set_default(DEFAULT_MULTIPATHDIR);
>  =09conf->attribute_flags =3D 0;
>  =09conf->reassign_maps =3D DEFAULT_REASSIGN_MAPS;
> -=09conf->checkint =3D DEFAULT_CHECKINT;
> +=09conf->checkint =3D CHECKINT_UNDEF;
> +=09conf->use_watchdog =3D false;
>  =09conf->max_checkint =3D 0;
>  =09conf->force_sync =3D DEFAULT_FORCE_SYNC;
>  =09conf->partition_delim =3D (default_partition_delim !=3D NULL ?
> @@ -754,8 +776,20 @@ load_config (char * file)
>  =09/*
>  =09 * fill the voids left in the config file
>  =09 */
> -=09if (conf->max_checkint =3D=3D 0)
> -=09=09conf->max_checkint =3D MAX_CHECKINT(conf->checkint);
> +=09set_max_checkint_from_watchdog(conf);
> +=09if (conf->max_checkint =3D=3D 0) {
> +=09=09if (conf->checkint =3D=3D CHECKINT_UNDEF)
> +=09=09=09conf->checkint =3D DEFAULT_CHECKINT;
> +=09=09conf->max_checkint =3D (conf->checkint < UINT_MAX / 4 ?
> +=09=09=09=09      conf->checkint * 4 : UINT_MAX);
> +=09} else if (conf->checkint =3D=3D CHECKINT_UNDEF)
> +=09=09conf->checkint =3D (conf->max_checkint >=3D 4 ?
> +=09=09=09=09  conf->max_checkint / 4 : 1);
> +=09else if (conf->checkint > conf->max_checkint)
> +=09=09conf->checkint =3D conf->max_checkint;
> +=09condlog(3, "polling interval: %d, max: %d",
> +=09=09conf->checkint, conf->max_checkint);
> +
>  =09if (conf->blist_devnode =3D=3D NULL) {
>  =09=09conf->blist_devnode =3D vector_alloc();
> =20
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 2ab7b42c..a078947c 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -139,6 +139,7 @@ struct config {
>  =09int minio_rq;
>  =09unsigned int checkint;
>  =09unsigned int max_checkint;
> +=09bool use_watchdog;
>  =09int pgfailback;
>  =09int remove;
>  =09int rr_weight;
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index d7034655..e5ee6afe 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -53,9 +53,8 @@
>  /* Enable all foreign libraries by default */
>  #define DEFAULT_ENABLE_FOREIGN ""
> =20
> -#define CHECKINT_UNDEF=09=09(~0U)
> +#define CHECKINT_UNDEF=09=09UINT_MAX
>  #define DEFAULT_CHECKINT=095
> -#define MAX_CHECKINT(a)=09=09(a << 2)
> =20
>  #define MAX_DEV_LOSS_TMO=09UINT_MAX
>  #define DEFAULT_PIDFILE=09=09"/" RUN_DIR "/multipathd.pid"
> diff --git a/multipathd/main.c b/multipathd/main.c
> index c0423602..95426d3d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -33,10 +33,6 @@
>   */
>  #include "checkers.h"
> =20
> -#ifdef USE_SYSTEMD
> -static int use_watchdog;
> -#endif
> -
>  /*
>   * libmultipath
>   */
> @@ -2284,6 +2280,7 @@ checkerloop (void *ap)
>  =09struct timespec last_time;
>  =09struct config *conf;
>  =09int foreign_tick =3D 0;
> +=09bool use_watchdog;
> =20
>  =09pthread_cleanup_push(rcu_unregister, NULL);
>  =09rcu_register_thread();
> @@ -2295,6 +2292,11 @@ checkerloop (void *ap)
>  =09get_monotonic_time(&last_time);
>  =09last_time.tv_sec -=3D 1;
> =20
> +=09/* use_watchdog is set from process environment and never changes */
> +=09conf =3D get_multipath_config();
> +=09use_watchdog =3D conf->use_watchdog;
> +=09put_multipath_config(conf);
> +
>  =09while (1) {
>  =09=09struct timespec diff_time, start_time, end_time;
>  =09=09int num_paths =3D 0, strict_timing, rc =3D 0;
> @@ -2766,7 +2768,6 @@ child (__attribute__((unused)) void *param)
>  =09struct multipath * mpp;
>  =09int i;
>  #ifdef USE_SYSTEMD
> -=09unsigned long checkint;
>  =09int startup_done =3D 0;
>  #endif
>  =09int rc;
> @@ -2843,21 +2844,6 @@ child (__attribute__((unused)) void *param)
>  =09setscheduler();
>  =09set_oom_adj();
> =20
> -#ifdef USE_SYSTEMD
> -=09envp =3D getenv("WATCHDOG_USEC");
> -=09if (envp && sscanf(envp, "%lu", &checkint) =3D=3D 1) {
> -=09=09/* Value is in microseconds */
> -=09=09conf->max_checkint =3D checkint / 1000000;
> -=09=09/* Rescale checkint */
> -=09=09if (conf->checkint > conf->max_checkint)
> -=09=09=09conf->checkint =3D conf->max_checkint;
> -=09=09else
> -=09=09=09conf->checkint =3D conf->max_checkint / 4;
> -=09=09condlog(3, "enabling watchdog, interval %d max %d",
> -=09=09=09conf->checkint, conf->max_checkint);
> -=09=09use_watchdog =3D conf->checkint;
> -=09}
> -#endif
>  =09/*
>  =09 * Startup done, invalidate configuration
>  =09 */
> --=20
> 2.24.0
