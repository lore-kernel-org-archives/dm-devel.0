From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 3/5] libmultipath: drop mpp->nr_active field
Date: Tue, 19 Nov 2019 16:22:03 -0600
Message-ID: <20191119222203.GL30153@octiron.msp.redhat.com>
References: <20191115143403.31692-1-martin.wilck@suse.com>
	<20191115143403.31692-4-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191115143403.31692-4-martin.wilck@suse.com>
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

On Fri, Nov 15, 2019 at 02:41:50PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> The tracking of nr_active has turned out to be error prone and hard
> to verify. Calculating it on the fly is a quick operation, so
> do this rather than trying to track nr_active. Use a boolean
> field instead to track whether a map is currently in recovery mode.
>=20
> Moreover, clean up the recovery logic by making set_no_path_retry()
> the place that checks the current configuration and state, sets
> "queue_if_no_path" if necessary, and enters or leaves recovery
> mode if necessary. This ensures that consistent logic is applied.

Thanks. This looks better. The only thing I'm am sorta worried about is
that when we call the cli_handler functions, we haven't called
update_multipath_strings() to sync the state with the kernel first. This
could mean that multipathd is wrong about what the queue_if_no_path state
is, which is possible since it doesn't update mpp->features whenever it
calls dm_queue_if_no_path(). However, in the worst case scenario, this
would only cause multipathd to need to wait for the next call to
check_path to fix this up. Alternatively, we might to call
update_multipath_strings() here, or even replace the calls to
set_no_path_retry() with something like setup_multipath() or
update_multipath().

Any thoughts? I might just be being overly paranoid here, since I can't
really come up with a good explanation for how this could even get to be
in a problem state, and like I said, even if it does occur, it will just
get resolved on the next call to check_path.

-Ben


> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c   |  5 ++-
>  libmultipath/devmapper.c   |  2 +-
>  libmultipath/io_err_stat.c |  4 +--
>  libmultipath/print.c       |  5 +--
>  libmultipath/structs.c     | 19 +++++++++++
>  libmultipath/structs.h     |  4 ++-
>  libmultipath/structs_vec.c | 69 ++++++++++++++++++++++++++------------
>  libmultipath/structs_vec.h |  1 -
>  multipathd/cli_handlers.c  | 39 ++++++++++-----------
>  multipathd/main.c          | 19 ++++-------
>  10 files changed, 101 insertions(+), 66 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 5ac7d903..c95848a0 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -401,7 +401,6 @@ int setup_map(struct multipath *mpp, char *params, in=
t params_size,
>  =09=09=09condlog(2, "%s: setting up map with %d/%d path checkers pending=
",
>  =09=09=09=09mpp->alias, n_pending, n_paths);
>  =09}
> -=09mpp->nr_active =3D pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOS=
T);
> =20
>  =09/*
>  =09 * ponders each path group and determine highest prio pg
> @@ -934,8 +933,8 @@ int domap(struct multipath *mpp, char *params, int is=
_daemon)
>  =09=09}
> =20
>  =09=09sysfs_set_max_sectors_kb(mpp, 0);
> -=09=09if (is_daemon && mpp->ghost_delay > 0 && mpp->nr_active &&
> -=09=09    pathcount(mpp, PATH_GHOST) =3D=3D mpp->nr_active)
> +=09=09if (is_daemon && mpp->ghost_delay > 0 && count_active_paths(mpp) &=
&
> +=09=09    pathcount(mpp, PATH_UP) =3D=3D 0)
>  =09=09=09mpp->ghost_delay_tick =3D mpp->ghost_delay;
>  =09=09r =3D dm_addmap_create(mpp, params);
> =20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index acf576aa..bed8ddc6 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -403,7 +403,7 @@ static uint16_t build_udev_flags(const struct multipa=
th *mpp, int reload)
>  =09/* DM_UDEV_DISABLE_LIBRARY_FALLBACK is added in dm_addmap */
>  =09return=09(mpp->skip_kpartx =3D=3D SKIP_KPARTX_ON ?
>  =09=09 MPATH_UDEV_NO_KPARTX_FLAG : 0) |
> -=09=09((mpp->nr_active =3D=3D 0 || mpp->ghost_delay_tick > 0)?
> +=09=09((count_active_paths(mpp) =3D=3D 0 || mpp->ghost_delay_tick > 0) ?
>  =09=09 MPATH_UDEV_NO_PATHS_FLAG : 0) |
>  =09=09(reload && !mpp->force_udev_reload ?
>  =09=09 MPATH_UDEV_RELOAD_FLAG : 0);
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index dcc8690d..1b9cd6c0 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -383,7 +383,7 @@ int need_io_err_check(struct path *pp)
> =20
>  =09if (uatomic_read(&io_err_thread_running) =3D=3D 0)
>  =09=09return 0;
> -=09if (pp->mpp->nr_active <=3D 0) {
> +=09if (count_active_paths(pp->mpp) <=3D 0) {
>  =09=09io_err_stat_log(2, "%s: recover path early", pp->dev);
>  =09=09goto recover;
>  =09}
> @@ -481,7 +481,7 @@ static int poll_io_err_stat(struct vectors *vecs, str=
uct io_err_stat_path *pp)
>  =09=09 */
>  =09=09path->tick =3D 1;
> =20
> -=09} else if (path->mpp && path->mpp->nr_active > 0) {
> +=09} else if (path->mpp && count_active_paths(path->mpp) > 0) {
>  =09=09io_err_stat_log(3, "%s: keep failing the dm path %s",
>  =09=09=09=09path->mpp->alias, path->dev);
>  =09=09path->io_err_pathfail_cnt =3D PATH_IO_ERR_WAITING_TO_CHECK;
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index b98e9bda..e1ef4d3f 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -181,9 +181,10 @@ snprint_queueing (char * buff, size_t len, const str=
uct multipath * mpp)
>  =09=09return snprintf(buff, len, "-");
>  =09else if (mpp->no_path_retry > 0) {
>  =09=09if (mpp->retry_tick > 0)
> +
>  =09=09=09return snprintf(buff, len, "%i sec",
>  =09=09=09=09=09mpp->retry_tick);
> -=09=09else if (mpp->retry_tick =3D=3D 0 && mpp->nr_active > 0)
> +=09=09else if (mpp->retry_tick =3D=3D 0 && count_active_paths(mpp) > 0)
>  =09=09=09return snprintf(buff, len, "%i chk",
>  =09=09=09=09=09mpp->no_path_retry);
>  =09=09else
> @@ -195,7 +196,7 @@ snprint_queueing (char * buff, size_t len, const stru=
ct multipath * mpp)
>  static int
>  snprint_nb_paths (char * buff, size_t len, const struct multipath * mpp)
>  {
> -=09return snprint_int(buff, len, mpp->nr_active);
> +=09return snprint_int(buff, len, count_active_paths(mpp));
>  }
> =20
>  static int
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index f420ee5c..cc931e4e 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -478,6 +478,25 @@ int pathcount(const struct multipath *mpp, int state=
)
>  =09return count;
>  }
> =20
> +int count_active_paths(const struct multipath *mpp)
> +{
> +=09struct pathgroup *pgp;
> +=09struct path *pp;
> +=09int count =3D 0;
> +=09int i, j;
> +
> +=09if (!mpp->pg)
> +=09=09return 0;
> +
> +=09vector_foreach_slot (mpp->pg, pgp, i) {
> +=09=09vector_foreach_slot (pgp->paths, pp, j) {
> +=09=09=09if (pp->state =3D=3D PATH_UP || pp->state =3D=3D PATH_GHOST)
> +=09=09=09=09count++;
> +=09=09}
> +=09}
> +=09return count;
> +}
> +
>  int pathcmp(const struct pathgroup *pgp, const struct pathgroup *cpgp)
>  {
>  =09int i, j;
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 3665b89a..da4b6ca0 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -3,6 +3,7 @@
> =20
>  #include <sys/types.h>
>  #include <inttypes.h>
> +#include <stdbool.h>
> =20
>  #include "prio.h"
>  #include "byteorder.h"
> @@ -309,7 +310,6 @@ struct multipath {
>  =09int pgfailback;
>  =09int failback_tick;
>  =09int rr_weight;
> -=09int nr_active;     /* current available(=3D not known as failed) path=
s */
>  =09int no_path_retry; /* number of retries after all paths are down */
>  =09int retry_tick;    /* remaining times for retries */
>  =09int disable_queueing;
> @@ -319,6 +319,7 @@ struct multipath {
>  =09int fast_io_fail;
>  =09int retain_hwhandler;
>  =09int deferred_remove;
> +=09bool in_recovery;
>  =09int san_path_err_threshold;
>  =09int san_path_err_forget_rate;
>  =09int san_path_err_recovery_time;
> @@ -449,6 +450,7 @@ struct path * first_path (const struct multipath *mpp=
);
> =20
>  int pathcountgr (const struct pathgroup *, int);
>  int pathcount (const struct multipath *, int);
> +int count_active_paths(const struct multipath *);
>  int pathcmp (const struct pathgroup *, const struct pathgroup *);
>  int add_feature (char **, const char *);
>  int remove_feature (char **, const char *);
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index fbe97662..0c5a3a81 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -290,10 +290,15 @@ update_multipath_strings(struct multipath *mpp, vec=
tor pathvec, int is_daemon)
>  =09return 0;
>  }
> =20
> -void enter_recovery_mode(struct multipath *mpp)
> +static void enter_recovery_mode(struct multipath *mpp)
>  {
>  =09unsigned int checkint;
> -=09struct config *conf =3D get_multipath_config();
> +=09struct config *conf;
> +
> +=09if (mpp->in_recovery || mpp->no_path_retry <=3D 0)
> +=09=09return;
> +
> +=09conf =3D get_multipath_config();
>  =09checkint =3D conf->checkint;
>  =09put_multipath_config(conf);
> =20
> @@ -302,17 +307,37 @@ void enter_recovery_mode(struct multipath *mpp)
>  =09 * meaning of +1: retry_tick may be decremented in checkerloop before
>  =09 * starting retry.
>  =09 */
> +=09mpp->in_recovery =3D true;
>  =09mpp->stat_queueing_timeouts++;
>  =09mpp->retry_tick =3D mpp->no_path_retry * checkint + 1;
>  =09condlog(1, "%s: Entering recovery mode: max_retries=3D%d",
>  =09=09mpp->alias, mpp->no_path_retry);
>  }
> =20
> +static void leave_recovery_mode(struct multipath *mpp)
> +{
> +=09bool recovery =3D mpp->in_recovery;
> +
> +=09mpp->in_recovery =3D false;
> +=09mpp->retry_tick =3D 0;
> +
> +=09/*
> +=09 * in_recovery is only ever set if mpp->no_path_retry > 0
> +=09 * (see enter_recovery_mode()). But no_path_retry may have been
> +=09 * changed while the map was recovering, so test it here again.
> +=09 */
> +=09if (recovery && (mpp->no_path_retry =3D=3D NO_PATH_RETRY_QUEUE ||
> +=09=09=09 mpp->no_path_retry > 0)) {
> +=09=09dm_queue_if_no_path(mpp->alias, 1);
> +=09=09condlog(2, "%s: queue_if_no_path enabled", mpp->alias);
> +=09=09condlog(1, "%s: Recovered to normal mode", mpp->alias);
> +=09}
> +}
> +
>  void set_no_path_retry(struct multipath *mpp)
>  {
> -=09char is_queueing =3D 0;
> +=09bool is_queueing =3D 0;
> =20
> -=09mpp->nr_active =3D pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOS=
T);
>  =09if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
>  =09=09is_queueing =3D 1;
> =20
> @@ -328,11 +353,15 @@ void set_no_path_retry(struct multipath *mpp)
>  =09=09=09dm_queue_if_no_path(mpp->alias, 1);
>  =09=09break;
>  =09default:
> -=09=09if (mpp->nr_active > 0) {
> -=09=09=09mpp->retry_tick =3D 0;
> -=09=09=09if (!is_queueing)
> +=09=09if (count_active_paths(mpp) > 0) {
> +=09=09=09/*
> +=09=09=09 * If in_recovery is set, leave_recovery_mode() takes
> +=09=09=09 * care of dm_queue_if_no_path. Otherwise, do it here.
> +=09=09=09 */
> +=09=09=09if (!is_queueing && !mpp->in_recovery)
>  =09=09=09=09dm_queue_if_no_path(mpp->alias, 1);
> -=09=09} else if (is_queueing && mpp->retry_tick =3D=3D 0)
> +=09=09=09leave_recovery_mode(mpp);
> +=09=09} else
>  =09=09=09enter_recovery_mode(mpp);
>  =09=09break;
>  =09}
> @@ -480,25 +509,23 @@ int verify_paths(struct multipath *mpp, struct vect=
ors *vecs)
>   */
>  void update_queue_mode_del_path(struct multipath *mpp)
>  {
> -=09if (--mpp->nr_active =3D=3D 0) {
> -=09=09if (mpp->no_path_retry > 0)
> -=09=09=09enter_recovery_mode(mpp);
> -=09=09else if (mpp->no_path_retry !=3D NO_PATH_RETRY_QUEUE)
> +=09int active =3D count_active_paths(mpp);
> +
> +=09if (active =3D=3D 0) {
> +=09=09enter_recovery_mode(mpp);
> +=09=09if (mpp->no_path_retry !=3D NO_PATH_RETRY_QUEUE)
>  =09=09=09mpp->stat_map_failures++;
>  =09}
> -=09condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_acti=
ve);
> +=09condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
>  }
> =20
>  void update_queue_mode_add_path(struct multipath *mpp)
>  {
> -=09if (mpp->nr_active++ =3D=3D 0 && mpp->no_path_retry > 0) {
> -=09=09/* come back to normal mode from retry mode */
> -=09=09mpp->retry_tick =3D 0;
> -=09=09dm_queue_if_no_path(mpp->alias, 1);
> -=09=09condlog(2, "%s: queue_if_no_path enabled", mpp->alias);
> -=09=09condlog(1, "%s: Recovered to normal mode", mpp->alias);
> -=09}
> -=09condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_acti=
ve);
> +=09int active =3D count_active_paths(mpp);
> +
> +=09if (active > 0)
> +=09=09leave_recovery_mode(mpp);
> +=09condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
>  }
> =20
>  vector get_used_hwes(const struct _vector *pathvec)
> diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
> index d3219278..678efe4d 100644
> --- a/libmultipath/structs_vec.h
> +++ b/libmultipath/structs_vec.h
> @@ -12,7 +12,6 @@ struct vectors {
>  };
> =20
>  void set_no_path_retry(struct multipath *mpp);
> -void enter_recovery_mode(struct multipath *mpp);
> =20
>  int adopt_paths (vector pathvec, struct multipath * mpp);
>  void orphan_paths(vector pathvec, struct multipath *mpp,
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 371b0a79..7d878c88 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1024,16 +1024,17 @@ cli_restore_queueing(void *v, char **reply, int *=
len, void *data)
>  =09select_no_path_retry(conf, mpp);
>  =09pthread_cleanup_pop(1);
> =20
> +=09/*
> +=09 * Don't call set_no_path_retry() for the NO_PATH_RETRY_FAIL case.
> +=09 * That would disable queueing when "restorequeueing" is called,
> +=09 * and the code never behaved that way. Users might not expect it.
> +=09 * In almost all cases, queueing will be disabled anyway when we
> +=09 * are here.
> +=09 */
>  =09if (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF &&
> -=09=09=09mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL) {
> -=09=09dm_queue_if_no_path(mpp->alias, 1);
> -=09=09if (mpp->no_path_retry > 0) {
> -=09=09=09if (mpp->nr_active > 0)
> -=09=09=09=09mpp->retry_tick =3D 0;
> -=09=09=09else
> -=09=09=09=09enter_recovery_mode(mpp);
> -=09=09}
> -=09}
> +=09    mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL)
> +=09=09set_no_path_retry(mpp);
> +
>  =09return 0;
>  }
> =20
> @@ -1051,16 +1052,10 @@ cli_restore_all_queueing(void *v, char **reply, i=
nt *len, void *data)
>  =09=09pthread_cleanup_push(put_multipath_config, conf);
>  =09=09select_no_path_retry(conf, mpp);
>  =09=09pthread_cleanup_pop(1);
> +=09=09/* See comment in cli_restore_queueing() */
>  =09=09if (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF &&
> -=09=09    mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL) {
> -=09=09=09dm_queue_if_no_path(mpp->alias, 1);
> -=09=09=09if (mpp->no_path_retry > 0) {
> -=09=09=09=09if (mpp->nr_active > 0)
> -=09=09=09=09=09mpp->retry_tick =3D 0;
> -=09=09=09=09else
> -=09=09=09=09=09enter_recovery_mode(mpp);
> -=09=09=09}
> -=09=09}
> +=09=09    mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL)
> +=09=09=09set_no_path_retry(mpp);
>  =09}
>  =09return 0;
>  }
> @@ -1085,12 +1080,12 @@ cli_disable_queueing(void *v, char **reply, int *=
len, void *data)
>  =09=09return 1;
>  =09}
> =20
> -=09if (mpp->nr_active =3D=3D 0)
> +=09if (count_active_paths(mpp) =3D=3D 0)
>  =09=09mpp->stat_map_failures++;
>  =09mpp->retry_tick =3D 0;
>  =09mpp->no_path_retry =3D NO_PATH_RETRY_FAIL;
>  =09mpp->disable_queueing =3D 1;
> -=09dm_queue_if_no_path(mpp->alias, 0);
> +=09set_no_path_retry(mpp);
>  =09return 0;
>  }
> =20
> @@ -1103,12 +1098,12 @@ cli_disable_all_queueing(void *v, char **reply, i=
nt *len, void *data)
> =20
>  =09condlog(2, "disable queueing (operator)");
>  =09vector_foreach_slot(vecs->mpvec, mpp, i) {
> -=09=09if (mpp->nr_active =3D=3D 0)
> +=09=09if (count_active_paths(mpp) =3D=3D 0)
>  =09=09=09mpp->stat_map_failures++;
>  =09=09mpp->retry_tick =3D 0;
>  =09=09mpp->no_path_retry =3D NO_PATH_RETRY_FAIL;
>  =09=09mpp->disable_queueing =3D 1;
> -=09=09dm_queue_if_no_path(mpp->alias, 0);
> +=09=09set_no_path_retry(mpp);
>  =09}
>  =09return 0;
>  }
> diff --git a/multipathd/main.c b/multipathd/main.c
> index a21d96e4..c0423602 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1616,7 +1616,7 @@ fail_path (struct path * pp, int del_active)
>   * caller must have locked the path list before calling that function
>   */
>  static int
> -reinstate_path (struct path * pp, int add_active)
> +reinstate_path (struct path * pp)
>  {
>  =09int ret =3D 0;
> =20
> @@ -1628,8 +1628,7 @@ reinstate_path (struct path * pp, int add_active)
>  =09=09ret =3D 1;
>  =09} else {
>  =09=09condlog(2, "%s: reinstated", pp->dev_t);
> -=09=09if (add_active)
> -=09=09=09update_queue_mode_add_path(pp->mpp);
> +=09=09update_queue_mode_add_path(pp->mpp);
>  =09}
>  =09return ret;
>  }
> @@ -1861,7 +1860,7 @@ static int check_path_reinstate_state(struct path *=
 pp) {
> =20
>  =09if (pp->disable_reinstate) {
>  =09=09/* If there are no other usable paths, reinstate the path */
> -=09=09if (pp->mpp->nr_active =3D=3D 0) {
> +=09=09if (count_active_paths(pp->mpp) =3D=3D 0) {
>  =09=09=09condlog(2, "%s : reinstating path early", pp->dev);
>  =09=09=09goto reinstate_path;
>  =09=09}
> @@ -1960,7 +1959,6 @@ check_path (struct vectors * vecs, struct path * pp=
, unsigned int ticks)
>  =09int newstate;
>  =09int new_path_up =3D 0;
>  =09int chkr_new_path_up =3D 0;
> -=09int add_active;
>  =09int disable_reinstate =3D 0;
>  =09int oldchkrstate =3D pp->chkrstate;
>  =09int retrigger_tries, verbosity;
> @@ -2134,7 +2132,7 @@ check_path (struct vectors * vecs, struct path * pp=
, unsigned int ticks)
>  =09 * paths if there are no other active paths in map.
>  =09 */
>  =09disable_reinstate =3D (newstate =3D=3D PATH_GHOST &&
> -=09=09=09     pp->mpp->nr_active =3D=3D 0 &&
> +=09=09=09     count_active_paths(pp->mpp) =3D=3D 0 &&
>  =09=09=09     path_get_tpgs(pp) =3D=3D TPGS_IMPLICIT) ? 1 : 0;
> =20
>  =09pp->chkrstate =3D newstate;
> @@ -2185,12 +2183,7 @@ check_path (struct vectors * vecs, struct path * p=
p, unsigned int ticks)
>  =09=09/*
>  =09=09 * reinstate this path
>  =09=09 */
> -=09=09if (oldstate !=3D PATH_UP &&
> -=09=09    oldstate !=3D PATH_GHOST)
> -=09=09=09add_active =3D 1;
> -=09=09else
> -=09=09=09add_active =3D 0;
> -=09=09if (!disable_reinstate && reinstate_path(pp, add_active)) {
> +=09=09if (!disable_reinstate && reinstate_path(pp)) {
>  =09=09=09condlog(3, "%s: reload map", pp->dev);
>  =09=09=09ev_add_path(pp, vecs, 1);
>  =09=09=09pp->tick =3D 1;
> @@ -2213,7 +2206,7 @@ check_path (struct vectors * vecs, struct path * pp=
, unsigned int ticks)
>  =09=09    pp->dmstate =3D=3D PSTATE_UNDEF) &&
>  =09=09    !disable_reinstate) {
>  =09=09=09/* Clear IO errors */
> -=09=09=09if (reinstate_path(pp, 0)) {
> +=09=09=09if (reinstate_path(pp)) {
>  =09=09=09=09condlog(3, "%s: reload map", pp->dev);
>  =09=09=09=09ev_add_path(pp, vecs, 1);
>  =09=09=09=09pp->tick =3D 1;
> --=20
> 2.24.0
