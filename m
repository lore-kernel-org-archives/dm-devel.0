From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH] libmultipath: drop mpp->nr_active field
Date: Thu, 14 Nov 2019 13:20:29 -0600
Message-ID: <20191114192029.GI30153@octiron.msp.redhat.com>
References: <20191113222304.14385-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191113222304.14385-1-martin.wilck@suse.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

On Wed, Nov 13, 2019 at 10:23:16PM +0000, Martin Wilck wrote:
> From: Martin Wilck <mwilck@suse.com>
>=20
> The tracking of nr_active has turned out to be error prone and hard
> to verify. Calculating it on the fly is a quick operation, so
> do this rather than trying to track nr_active. Use a boolean
> field instead to track whether a map is currently in recovery mode.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c   |  5 ++---
>  libmultipath/devmapper.c   |  2 +-
>  libmultipath/io_err_stat.c |  4 ++--
>  libmultipath/print.c       |  5 +++--
>  libmultipath/structs.c     | 19 +++++++++++++++++++
>  libmultipath/structs.h     |  3 ++-
>  libmultipath/structs_vec.c | 14 ++++++++++----
>  multipathd/cli_handlers.c  |  8 ++++----
>  multipathd/main.c          | 24 ++++++++----------------
>  9 files changed, 51 insertions(+), 33 deletions(-)
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
> index 0f0c3a34..641dc9b6 100644
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
> index 554b7778..7d662f1a 100644
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
> index 907469ad..05e8f385 100644
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
> index bf7fdd73..f63bae53 100644
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
> index a3adf906..3a4d8f46 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -309,7 +309,6 @@ struct multipath {
>  =09int pgfailback;
>  =09int failback_tick;
>  =09int rr_weight;
> -=09int nr_active;     /* current available(=3D not known as failed) path=
s */
>  =09int no_path_retry; /* number of retries after all paths are down */
>  =09int retry_tick;    /* remaining times for retries */
>  =09int disable_queueing;
> @@ -319,6 +318,7 @@ struct multipath {
>  =09int fast_io_fail;
>  =09int retain_hwhandler;
>  =09int deferred_remove;
> +=09int in_recovery;
>  =09int san_path_err_threshold;
>  =09int san_path_err_forget_rate;
>  =09int san_path_err_recovery_time;
> @@ -448,6 +448,7 @@ struct path * first_path (const struct multipath *mpp=
);
> =20
>  int pathcountgr (const struct pathgroup *, int);
>  int pathcount (const struct multipath *, int);
> +int count_active_paths(const struct multipath *);
>  int pathcmp (const struct pathgroup *, const struct pathgroup *);
>  int add_feature (char **, const char *);
>  int remove_feature (char **, const char *);
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index c43b58fb..ff124e10 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -302,6 +302,7 @@ void enter_recovery_mode(struct multipath *mpp)
>  =09 * meaning of +1: retry_tick may be decremented in checkerloop before
>  =09 * starting retry.
>  =09 */
> +=09mpp->in_recovery =3D 1;
>  =09mpp->stat_queueing_timeouts++;
>  =09mpp->retry_tick =3D mpp->no_path_retry * checkint + 1;
>  =09condlog(1, "%s: Entering recovery mode: max_retries=3D%d",
> @@ -450,25 +451,30 @@ int verify_paths(struct multipath *mpp, struct vect=
ors *vecs)
>   */
>  void update_queue_mode_del_path(struct multipath *mpp)
>  {
> -=09if (--mpp->nr_active =3D=3D 0) {
> +=09int active =3D count_active_paths(mpp);
> +
> +=09if (!mpp->in_recovery && active =3D=3D 0) {
>  =09=09if (mpp->no_path_retry > 0)
>  =09=09=09enter_recovery_mode(mpp);
>  =09=09else if (mpp->no_path_retry !=3D NO_PATH_RETRY_QUEUE)
>  =09=09=09mpp->stat_map_failures++;
>  =09}
> -=09condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_acti=
ve);
> +=09condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
>  }

I think that this patch will end up having cases where multipathd leaves
recovery mode twice, which isn't a big deal, but can be avoided. The
issue is that before this patch, we exit recovery mode by setting
mpp->retry_tick to zero, when an active path exists and no_path_retry is
something other than NO_PATH_RETRY_FAIL. With this patch
update_queue_mode_add_path() also sets in_recovery to 0 when we exit
recovery mode, but we don't clear in_recovery in set_no_path_retry(). We
could possibly have an exit_recovery_mode() function that clears both of
these and sets queue_if_no_path, and use that just like we do with
enter_recovery_mode().

>  void update_queue_mode_add_path(struct multipath *mpp)
>  {
> -=09if (mpp->nr_active++ =3D=3D 0 && mpp->no_path_retry > 0) {
> +=09int active =3D count_active_paths(mpp);
> +
> +=09if (mpp->in_recovery && active > 0 && mpp->no_path_retry > 0) {
>  =09=09/* come back to normal mode from retry mode */
> +=09=09mpp->in_recovery =3D 0;
>  =09=09mpp->retry_tick =3D 0;
>  =09=09dm_queue_if_no_path(mpp->alias, 1);
>  =09=09condlog(2, "%s: queue_if_no_path enabled", mpp->alias);
>  =09=09condlog(1, "%s: Recovered to normal mode", mpp->alias);
>  =09}
> -=09condlog(2, "%s: remaining active paths: %d", mpp->alias, mpp->nr_acti=
ve);
> +=09condlog(2, "%s: remaining active paths: %d", mpp->alias, active);
>  }
> =20
>  vector get_used_hwes(const struct _vector *pathvec)
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 8a899049..06f32e30 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1028,7 +1028,7 @@ cli_restore_queueing(void *v, char **reply, int *le=
n, void *data)
>  =09=09=09mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL) {
>  =09=09dm_queue_if_no_path(mpp->alias, 1);
>  =09=09if (mpp->no_path_retry > 0) {
> -=09=09=09if (mpp->nr_active > 0)
> +=09=09=09if (count_active_paths(mpp) > 0)

I don't think we should get here when we're in recovery mode, since
there are active paths.  However, it certainly wouldn't hurt to clear
in_recovery, since we've enabled queue_if_no_path, and cleared
retry_tick. Obviously, it would take some refactoring to use an
exit_recovery_mode function here while avoiding calling
dm_queue_if_no_path(mpp->alias, 1) twice.

>  =09=09=09=09mpp->retry_tick =3D 0;
>  =09=09=09else
>  =09=09=09=09enter_recovery_mode(mpp);
> @@ -1055,7 +1055,7 @@ cli_restore_all_queueing(void *v, char **reply, int=
 *len, void *data)
>  =09=09    mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL) {
>  =09=09=09dm_queue_if_no_path(mpp->alias, 1);
>  =09=09=09if (mpp->no_path_retry > 0) {
> -=09=09=09=09if (mpp->nr_active > 0)
> +=09=09=09=09if (count_active_paths(mpp) > 0)

Same here.

>  =09=09=09=09=09mpp->retry_tick =3D 0;
>  =09=09=09=09else
>  =09=09=09=09=09enter_recovery_mode(mpp);
> @@ -1085,7 +1085,7 @@ cli_disable_queueing(void *v, char **reply, int *le=
n, void *data)
>  =09=09return 1;
>  =09}
> =20
> -=09if (mpp->nr_active =3D=3D 0)
> +=09if (count_active_paths(mpp) =3D=3D 0)
>  =09=09mpp->stat_map_failures++;
>  =09mpp->retry_tick =3D 0;
>  =09mpp->no_path_retry =3D NO_PATH_RETRY_FAIL;
> @@ -1103,7 +1103,7 @@ cli_disable_all_queueing(void *v, char **reply, int=
 *len, void *data)
> =20
>  =09condlog(2, "disable queueing (operator)");
>  =09vector_foreach_slot(vecs->mpvec, mpp, i) {
> -=09=09if (mpp->nr_active =3D=3D 0)
> +=09=09if (count_active_paths(mpp) =3D=3D 0)
>  =09=09=09mpp->stat_map_failures++;
>  =09=09mpp->retry_tick =3D 0;
>  =09=09mpp->no_path_retry =3D NO_PATH_RETRY_FAIL;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 34a57689..540fe5f3 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -413,7 +413,6 @@ static void set_no_path_retry(struct multipath *mpp)
>  {
>  =09char is_queueing =3D 0;
> =20
> -=09mpp->nr_active =3D pathcount(mpp, PATH_UP) + pathcount(mpp, PATH_GHOS=
T);
>  =09if (mpp->features && strstr(mpp->features, "queue_if_no_path"))
>  =09=09is_queueing =3D 1;
> =20
> @@ -429,11 +428,11 @@ static void set_no_path_retry(struct multipath *mpp=
)
>  =09=09=09dm_queue_if_no_path(mpp->alias, 1);
>  =09=09break;
>  =09default:
> -=09=09if (mpp->nr_active > 0) {
> +=09=09if (count_active_paths(mpp) > 0) {

It is possible to be in recovery mode here.  If we got here from

ev_add_path -> __setup_multipath -> set_no_path_retry

Then the active path is a new active path, that is just getting added
now, so in_recovery may be set, and we should clear it.

>  =09=09=09mpp->retry_tick =3D 0;
>  =09=09=09if (!is_queueing)
>  =09=09=09=09dm_queue_if_no_path(mpp->alias, 1);
> -=09=09} else if (is_queueing && mpp->retry_tick =3D=3D 0)
> +=09=09} else if (is_queueing && !mpp->in_recovery)
>  =09=09=09enter_recovery_mode(mpp);
>  =09=09break;
>  =09}
> @@ -1646,7 +1645,7 @@ fail_path (struct path * pp, int del_active)
>   * caller must have locked the path list before calling that function
>   */
>  static int
> -reinstate_path (struct path * pp, int add_active)
> +reinstate_path (struct path * pp)
>  {
>  =09int ret =3D 0;
> =20
> @@ -1658,8 +1657,7 @@ reinstate_path (struct path * pp, int add_active)
>  =09=09ret =3D 1;
>  =09} else {
>  =09=09condlog(2, "%s: reinstated", pp->dev_t);
> -=09=09if (add_active)
> -=09=09=09update_queue_mode_add_path(pp->mpp);
> +=09=09update_queue_mode_add_path(pp->mpp);
>  =09}
>  =09return ret;
>  }
> @@ -1891,7 +1889,7 @@ static int check_path_reinstate_state(struct path *=
 pp) {
> =20
>  =09if (pp->disable_reinstate) {
>  =09=09/* If there are no other usable paths, reinstate the path */
> -=09=09if (pp->mpp->nr_active =3D=3D 0) {
> +=09=09if (count_active_paths(pp->mpp) =3D=3D 0) {
>  =09=09=09condlog(2, "%s : reinstating path early", pp->dev);
>  =09=09=09goto reinstate_path;
>  =09=09}
> @@ -1989,7 +1987,6 @@ check_path (struct vectors * vecs, struct path * pp=
, int ticks)
>  =09int newstate;
>  =09int new_path_up =3D 0;
>  =09int chkr_new_path_up =3D 0;
> -=09int add_active;
>  =09int disable_reinstate =3D 0;
>  =09int oldchkrstate =3D pp->chkrstate;
>  =09int retrigger_tries, checkint, max_checkint, verbosity;
> @@ -2162,7 +2159,7 @@ check_path (struct vectors * vecs, struct path * pp=
, int ticks)
>  =09 * paths if there are no other active paths in map.
>  =09 */
>  =09disable_reinstate =3D (newstate =3D=3D PATH_GHOST &&
> -=09=09=09     pp->mpp->nr_active =3D=3D 0 &&
> +=09=09=09     count_active_paths(pp->mpp) =3D=3D 0 &&
>  =09=09=09     path_get_tpgs(pp) =3D=3D TPGS_IMPLICIT) ? 1 : 0;
> =20
>  =09pp->chkrstate =3D newstate;
> @@ -2213,12 +2210,7 @@ check_path (struct vectors * vecs, struct path * p=
p, int ticks)
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
> @@ -2241,7 +2233,7 @@ check_path (struct vectors * vecs, struct path * pp=
, int ticks)
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
