From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Remove superfluous instances of the "extern"
	keyword
Date: Sun, 20 Nov 2016 14:35:52 +0100
Message-ID: <CABr-GneYzWdJQ3oTKTH25ZwUJbbgekALedCVZ7oVvf7mm-UMUw@mail.gmail.com>
References: <3f706543-7b03-cab2-c6b3-bc8f7d72d029@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6298950291831947140=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3f706543-7b03-cab2-c6b3-bc8f7d72d029@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6298950291831947140==
Content-Type: multipart/alternative; boundary=001a1142a8de39eba40541bb9e09

--001a1142a8de39eba40541bb9e09
Content-Type: text/plain; charset=UTF-8

Merged as commit b573878f76a893cece197b5969e54099a5fac905.
Merge rejects committed as 9c4be4c0d1b06c066098dafb5aeb914bae1f110b.

Thanks.

On Fri, Nov 18, 2016 at 9:50 PM, Bart Van Assche <bart.vanassche@sandisk.com
> wrote:

> This avoids that the sparse static analyzer complains about
> the "extern" keyword.
>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  kpartx/devmapper.c                   | 18 ++++-----
>  kpartx/lopart.c                      | 15 +++-----
>  libmpathpersist/mpath_pr_ioctl.c     |  2 +-
>  libmultipath/blacklist.c             |  9 ++---
>  libmultipath/callout.c               |  3 +-
>  libmultipath/checkers/cciss_tur.c    |  3 +-
>  libmultipath/checkers/emc_clariion.c |  3 +-
>  libmultipath/checkers/hp_sw.c        |  3 +-
>  libmultipath/checkers/rdac.c         |  3 +-
>  libmultipath/checkers/tur.c          |  3 +-
>  libmultipath/config.c                |  6 +--
>  libmultipath/configure.c             | 21 +++++-----
>  libmultipath/devmapper.c             | 49 +++++++++--------------
>  libmultipath/discovery.c             |  5 +--
>  libmultipath/dmparser.c              |  8 ++--
>  libmultipath/hwtable.c               |  3 +-
>  libmultipath/pgpolicies.c            | 23 +++++------
>  libmultipath/print.c                 | 55 ++++++++++----------------
>  libmultipath/propsel.c               | 75 ++++++++++++------------------
> ------
>  libmultipath/structs.c               | 21 ++++------
>  libmultipath/structs_vec.c           | 49 +++++++++--------------
>  libmultipath/switchgroup.c           |  6 +--
>  libmultipath/uevent.c                | 12 ++----
>  libmultipath/util.c                  |  3 +-
>  24 files changed, 145 insertions(+), 253 deletions(-)
>
> diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
> index 474d879..2acae25 100644
> --- a/kpartx/devmapper.c
> +++ b/kpartx/devmapper.c
> @@ -14,8 +14,7 @@
>  #define MAX_PREFIX_LEN 8
>  #define PARAMS_SIZE 1024
>
> -extern int
> -dm_prereq (char * str, int x, int y, int z)
> +int dm_prereq(char * str, int x, int y, int z)
>  {
>         int r = 1;
>         struct dm_task *dmt;
> @@ -52,8 +51,8 @@ out:
>         return r;
>  }
>
> -extern int
> -dm_simplecmd (int task, const char *name, int no_flush, uint16_t
> udev_flags) {
> +int dm_simplecmd(int task, const char *name, int no_flush, uint16_t
> udev_flags)
> +{
>         int r = 0;
>         int udev_wait_flag = (task == DM_DEVICE_RESUME ||
>                               task == DM_DEVICE_REMOVE);
> @@ -90,10 +89,10 @@ out:
>         return r;
>  }
>
> -extern int
> -dm_addmap (int task, const char *name, const char *target,
> -          const char *params, uint64_t size, int ro, const char *uuid,
> int part,
> -          mode_t mode, uid_t uid, gid_t gid) {
> +int dm_addmap(int task, const char *name, const char *target,
> +             const char *params, uint64_t size, int ro, const char *uuid,
> +             int part, mode_t mode, uid_t uid, gid_t gid)
> +{
>         int r = 0;
>         struct dm_task *dmt;
>         char *prefixed_uuid = NULL;
> @@ -154,8 +153,7 @@ addout:
>         return r;
>  }
>
> -extern int
> -dm_map_present (char * str, char **uuid)
> +int dm_map_present(char * str, char **uuid)
>  {
>         int r = 0;
>         struct dm_task *dmt;
> diff --git a/kpartx/lopart.c b/kpartx/lopart.c
> index 14af34f..2eb3f63 100644
> --- a/kpartx/lopart.c
> +++ b/kpartx/lopart.c
> @@ -62,8 +62,7 @@ xstrdup (const char *s)
>         return t;
>  }
>
> -extern int
> -is_loop_device (const char *device)
> +int is_loop_device(const char *device)
>  {
>         struct stat statbuf;
>         int loopmajor;
> @@ -96,8 +95,7 @@ is_loop_device (const char *device)
>
>  #define SIZE(a) (sizeof(a)/sizeof(a[0]))
>
> -extern char *
> -find_loop_by_file (const char * filename)
> +char *find_loop_by_file(const char *filename)
>  {
>         DIR *dir;
>         struct dirent *dent;
> @@ -144,8 +142,7 @@ find_loop_by_file (const char * filename)
>         return found;
>  }
>
> -extern char *
> -find_unused_loop_device (void)
> +char *find_unused_loop_device(void)
>  {
>         char dev[20], *next_loop_dev = NULL;
>         int fd, next_loop = 0, somedev = 0, someloop = 0, loop_known = 0;
> @@ -231,8 +228,7 @@ find_unused_loop_device (void)
>         return NULL;
>  }
>
> -extern int
> -set_loop (const char *device, const char *file, int offset, int *loopro)
> +int set_loop(const char *device, const char *file, int offset, int
> *loopro)
>  {
>         struct loop_info loopinfo;
>         int fd, ffd, mode;
> @@ -284,8 +280,7 @@ set_loop (const char *device, const char *file, int
> offset, int *loopro)
>         return 0;
>  }
>
> -extern int
> -del_loop (const char *device)
> +int del_loop(const char *device)
>  {
>         int retries = 5;
>         int fd;
> diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_
> ioctl.c
> index 8b9ac3d..31b2fe6 100644
> --- a/libmpathpersist/mpath_pr_ioctl.c
> +++ b/libmpathpersist/mpath_pr_ioctl.c
> @@ -36,7 +36,7 @@ void decode_transport_id(struct prin_fulldescr *fdesc,
> unsigned char * p, int le
>  int get_prin_length(int rq_servact);
>  int mpath_isLittleEndian(void);
>
> -extern unsigned int mpath_mx_alloc_len;
> +unsigned int mpath_mx_alloc_len;
>
>  int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,
>                 unsigned int rq_type, struct prout_param_descriptor
> *paramp, int noisy)
> diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> index f6c4506..d59d37e 100644
> --- a/libmultipath/blacklist.c
> +++ b/libmultipath/blacklist.c
> @@ -13,8 +13,7 @@
>  #include "config.h"
>  #include "blacklist.h"
>
> -extern int
> -store_ble (vector blist, char * str, int origin)
> +int store_ble(vector blist, char * str, int origin)
>  {
>         struct blentry * ble;
>
> @@ -47,8 +46,7 @@ out:
>  }
>
>
> -extern int
> -alloc_ble_device (vector blist)
> +int alloc_ble_device(vector blist)
>  {
>         struct blentry_device * ble = MALLOC(sizeof(struct
> blentry_device));
>
> @@ -63,8 +61,7 @@ alloc_ble_device (vector blist)
>         return 0;
>  }
>
> -extern int
> -set_ble_device (vector blist, char * vendor, char * product, int origin)
> +int set_ble_device(vector blist, char * vendor, char * product, int
> origin)
>  {
>         struct blentry_device * ble;
>
> diff --git a/libmultipath/callout.c b/libmultipath/callout.c
> index 4d1b067..dc18e02 100644
> --- a/libmultipath/callout.c
> +++ b/libmultipath/callout.c
> @@ -137,8 +137,7 @@ int execute_program(char *path, char *value, int len)
>         return retval;
>  }
>
> -extern int
> -apply_format (char * string, char * cmd, struct path * pp)
> +int apply_format(char * string, char * cmd, struct path * pp)
>  {
>         char * pos;
>         char * dst;
> diff --git a/libmultipath/checkers/cciss_tur.c
> b/libmultipath/checkers/cciss_tur.c
> index a0ffffe..9d79f96 100644
> --- a/libmultipath/checkers/cciss_tur.c
> +++ b/libmultipath/checkers/cciss_tur.c
> @@ -64,8 +64,7 @@ void libcheck_repair (struct checker * c)
>         return;
>  }
>
> -extern int
> -libcheck_check (struct checker * c)
> +int libcheck_check(struct checker * c)
>  {
>         int rc;
>         int ret;
> diff --git a/libmultipath/checkers/emc_clariion.c
> b/libmultipath/checkers/emc_clariion.c
> index a7b9f86..9c1ffed 100644
> --- a/libmultipath/checkers/emc_clariion.c
> +++ b/libmultipath/checkers/emc_clariion.c
> @@ -50,8 +50,7 @@ struct emc_clariion_checker_LU_context {
>         int inactive_snap;
>  };
>
> -extern void
> -hexadecimal_to_ascii(char * wwn, char *wwnstr)
> +void hexadecimal_to_ascii(char * wwn, char *wwnstr)
>  {
>         int i,j, nbl;
>
> diff --git a/libmultipath/checkers/hp_sw.c b/libmultipath/checkers/hp_sw.c
> index 0cc1111..6019c9d 100644
> --- a/libmultipath/checkers/hp_sw.c
> +++ b/libmultipath/checkers/hp_sw.c
> @@ -128,8 +128,7 @@ do_tur (int fd, unsigned int timeout)
>         return 0;
>  }
>
> -extern int
> -libcheck_check (struct checker * c)
> +int libcheck_check(struct checker * c)
>  {
>         char buff[MX_ALLOC_LEN];
>
> diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c
> index 68682c8..a643a4a 100644
> --- a/libmultipath/checkers/rdac.c
> +++ b/libmultipath/checkers/rdac.c
> @@ -262,8 +262,7 @@ const char
>         }
>  }
>
> -extern int
> -libcheck_check (struct checker * c)
> +int libcheck_check(struct checker * c)
>  {
>         struct volume_access_inq inq;
>         int ret, inqfail;
> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index 92200aa..4d6c3c2 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -314,8 +314,7 @@ static void copy_msg_to_checker(void *c_p, const char
> *msg)
>         strlcpy(c->message, msg, sizeof(c->message));
>  }
>
> -extern int
> -libcheck_check (struct checker * c)
> +int libcheck_check(struct checker * c)
>  {
>         struct tur_checker_context *ct = c->context;
>         struct timespec tsp;
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 2d629ef..32b41a2 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -125,8 +125,7 @@ find_hwe (vector hwtable, char * vendor, char *
> product, char * revision)
>         return ret;
>  }
>
> -extern struct mpentry *
> -find_mpe (vector mptable, char * wwid)
> +struct mpentry *find_mpe(vector mptable, char *wwid)
>  {
>         int i;
>         struct mpentry * mpe;
> @@ -141,8 +140,7 @@ find_mpe (vector mptable, char * wwid)
>         return NULL;
>  }
>
> -extern char *
> -get_mpe_wwid (vector mptable, char * alias)
> +char *get_mpe_wwid(vector mptable, char *alias)
>  {
>         int i;
>         struct mpentry * mpe;
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index d428099..e5cc5f1 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -253,8 +253,7 @@ int rr_optimize_path_order(struct pathgroup *pgp)
>         return 0;
>  }
>
> -extern int
> -setup_map (struct multipath * mpp, char * params, int params_size)
> +int setup_map(struct multipath *mpp, char *params, int params_size)
>  {
>         struct pathgroup * pgp;
>         struct config *conf;
> @@ -505,8 +504,7 @@ select_action (struct multipath * mpp, vector curmp,
> int force_reload)
>         return;
>  }
>
> -extern int
> -reinstate_paths (struct multipath * mpp)
> +int reinstate_paths(struct multipath *mpp)
>  {
>         int i, j;
>         struct pathgroup * pgp;
> @@ -582,8 +580,7 @@ fail:
>  #define DOMAP_EXIST    2
>  #define DOMAP_DRY      3
>
> -extern int
> -domap (struct multipath * mpp, char * params, int is_daemon)
> +int domap(struct multipath *mpp, char *params, int is_daemon)
>  {
>         int r = DOMAP_FAIL;
>         struct config *conf;
> @@ -748,8 +745,8 @@ out:
>         return ret;
>  }
>
> -extern int
> -coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int
> force_reload, enum mpath_cmds cmd)
> +int coalesce_paths(struct vectors *vecs, vector newmp, char *refwwid,
> +                  int force_reload, enum mpath_cmds cmd)
>  {
>         int r = 1;
>         int k, i;
> @@ -953,9 +950,8 @@ coalesce_paths (struct vectors * vecs, vector newmp,
> char * refwwid, int force_r
>   * 1 - failure
>   * 2 - blacklist
>   */
> -extern int
> -get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
> -            vector pathvec, char **wwid)
> +int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,
> +               vector pathvec, char **wwid)
>  {
>         int ret = 1;
>         struct path * pp;
> @@ -1126,7 +1122,8 @@ out:
>         return 1;
>  }
>
> -extern int reload_map(struct vectors *vecs, struct multipath *mpp, int
> refresh, int is_daemon)
> +int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
> +              int is_daemon)
>  {
>         char params[PARAMS_SIZE] = {0};
>         struct path *pp;
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 5aea5b6..868d2c0 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -94,8 +94,8 @@ dm_write_log (int level, const char *file, int line,
> const char *f, ...)
>         return;
>  }
>
> -extern void
> -dm_init(int v) {
> +void dm_init(int v)
> +{
>         dm_log_init(&dm_write_log);
>         dm_log_init_verbose(v + 3);
>  }
> @@ -200,8 +200,7 @@ dm_drv_prereq (void)
>         return 1;
>  }
>
> -extern int
> -dm_prereq (void)
> +int dm_prereq(void)
>  {
>         if (dm_lib_prereq())
>                 return 1;
> @@ -249,13 +248,13 @@ out:
>         return r;
>  }
>
> -extern int
> -dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags) {
> +int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags)
> +{
>         return dm_simplecmd(task, name, 0, 1, udev_flags, 0);
>  }
>
> -extern int
> -dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags) {
> +int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags)
> +{
>         return dm_simplecmd(task, name, 1, 1, udev_flags, 0);
>  }
>
> @@ -338,8 +337,8 @@ addout:
>         return r;
>  }
>
> -extern int
> -dm_addmap_create (struct multipath *mpp, char * params) {
> +int dm_addmap_create (struct multipath *mpp, char * params)
> +{
>         int ro;
>
>         for (ro = 0; ro <= 1; ro++) {
> @@ -369,8 +368,7 @@ dm_addmap_create (struct multipath *mpp, char *
> params) {
>  #define ADDMAP_RW 0
>  #define ADDMAP_RO 1
>
> -extern int
> -dm_addmap_reload (struct multipath *mpp, char *params, int flush)
> +int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  {
>         int r;
>         uint16_t udev_flags = (flush ? 0 : MPATH_UDEV_RELOAD_FLAG) |
> @@ -397,8 +395,7 @@ dm_addmap_reload (struct multipath *mpp, char *params,
> int flush)
>         return r;
>  }
>
> -extern int
> -dm_map_present (const char * str)
> +int dm_map_present(const char * str)
>  {
>         int r = 0;
>         struct dm_task *dmt;
> @@ -425,8 +422,7 @@ out:
>         return r;
>  }
>
> -extern int
> -dm_get_map(const char * name, unsigned long long * size, char * outparams)
> +int dm_get_map(const char *name, unsigned long long *size, char
> *outparams)
>  {
>         int r = 1;
>         struct dm_task *dmt;
> @@ -492,8 +488,7 @@ uuidout:
>         return r;
>  }
>
> -extern int
> -dm_get_uuid(char *name, char *uuid)
> +int dm_get_uuid(char *name, char *uuid)
>  {
>         char uuidtmp[WWID_SIZE];
>
> @@ -533,8 +528,7 @@ dm_compare_uuid(const char* mapname1, const char*
> mapname2)
>         return 1;
>  }
>
> -extern int
> -dm_get_status(char * name, char * outstatus)
> +int dm_get_status(char *name, char *outstatus)
>  {
>         int r = 1;
>         struct dm_task *dmt;
> @@ -577,8 +571,7 @@ out:
>   *    0 : no match
>   *   -1 : empty map
>   */
> -extern int
> -dm_type(const char * name, char * type)
> +int dm_type(const char *name, char *type)
>  {
>         int r = 0;
>         struct dm_task *dmt;
> @@ -611,8 +604,7 @@ out:
>         return r;
>  }
>
> -extern int
> -dm_is_mpath(const char * name)
> +int dm_is_mpath(const char *name)
>  {
>         int r = 0;
>         struct dm_task *dmt;
> @@ -791,8 +783,7 @@ partmap_in_use(const char *name, void *data)
>         return 0;
>  }
>
> -extern int
> -_dm_flush_map (const char * mapname, int need_sync, int deferred_remove)
> +int _dm_flush_map(const char *mapname, int need_sync, int deferred_remove)
>  {
>         int r;
>
> @@ -844,8 +835,7 @@ dm_flush_map_nopaths(const char * mapname, int
> deferred_remove)
>
>  #endif
>
> -extern int
> -dm_suspend_and_flush_map (const char * mapname)
> +int dm_suspend_and_flush_map(const char *mapname)
>  {
>         int s = 0, queue_if_no_path = 0;
>         unsigned long long mapsize;
> @@ -884,8 +874,7 @@ dm_suspend_and_flush_map (const char * mapname)
>         return 1;
>  }
>
> -extern int
> -dm_flush_maps (void)
> +int dm_flush_maps(void)
>  {
>         int r = 0;
>         struct dm_task *dmt;
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 756344f..786a7c0 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -177,7 +177,7 @@ path_discovery (vector pathvec, int flag)
>  }
>
>  #define declare_sysfs_get_str(fname)                                   \
> -extern ssize_t                                                         \
> +ssize_t
>       \
>  sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len) \
>  {                                                                      \
>         int l;                                                  \
> @@ -1714,8 +1714,7 @@ get_uid (struct path * pp, int path_state, struct
> udev_device *udev)
>         return 0;
>  }
>
> -extern int
> -pathinfo (struct path *pp, struct config *conf, int mask)
> +int pathinfo(struct path *pp, struct config *conf, int mask)
>  {
>         int path_state;
>
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 87e8398..b504961 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -140,9 +140,8 @@ assemble_map (struct multipath * mp, char * params,
> int len)
>         return 0;
>  }
>
> -extern int
> -disassemble_map (vector pathvec, char * params, struct multipath * mpp,
> -                int is_daemon)
> +int disassemble_map(vector pathvec, char *params, struct multipath *mpp,
> +                   int is_daemon)
>  {
>         char * word;
>         char * p;
> @@ -425,8 +424,7 @@ out:
>         return 1;
>  }
>
> -extern int
> -disassemble_status (char * params, struct multipath * mpp)
> +int disassemble_status(char *params, struct multipath *mpp)
>  {
>         char * word;
>         char * p;
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 340035e..afe6c13 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -1106,8 +1106,7 @@ static struct hwentry default_hw[] = {
>         },
>  };
>
> -extern int
> -setup_default_hwtable (vector hw)
> +int setup_default_hwtable(vector hw)
>  {
>         int r = 0;
>         struct hwentry * hwe = default_hw;
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index 3064aab..4ae4afb 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -13,8 +13,7 @@
>  #include "pgpolicies.h"
>  #include "switchgroup.h"
>
> -extern int
> -get_pgpolicy_id (char * str)
> +int get_pgpolicy_id(char * str)
>  {
>         if (0 == strncmp(str, "failover", 8))
>                 return FAILOVER;
> @@ -30,8 +29,7 @@ get_pgpolicy_id (char * str)
>         return IOPOLICY_UNDEF;
>  }
>
> -extern int
> -get_pgpolicy_name (char * buff, int len, int id)
> +int get_pgpolicy_name(char * buff, int len, int id)
>  {
>         char * s;
>
> @@ -89,8 +87,8 @@ sort_pathgroups (struct multipath *mp) {
>  /*
>   * One path group per unique tgt_node_name present in the path vector
>   */
> -extern int
> -group_by_node_name (struct multipath * mp) {
> +int group_by_node_name(struct multipath * mp)
> +{
>         int i, j;
>         int * bitmap;
>         struct path * pp;
> @@ -165,8 +163,8 @@ out:
>  /*
>   * One path group per unique serial number present in the path vector
>   */
> -extern int
> -group_by_serial (struct multipath * mp) {
> +int group_by_serial(struct multipath * mp)
> +{
>         int i, j;
>         int * bitmap;
>         struct path * pp;
> @@ -237,8 +235,7 @@ out:
>         return 1;
>  }
>
> -extern int
> -one_path_per_group (struct multipath * mp)
> +int one_path_per_group(struct multipath *mp)
>  {
>         int i;
>         struct path * pp;
> @@ -275,8 +272,7 @@ out:
>         return 1;
>  }
>
> -extern int
> -one_group (struct multipath * mp)      /* aka multibus */
> +int one_group(struct multipath *mp)    /* aka multibus */
>  {
>         struct pathgroup * pgp;
>
> @@ -313,8 +309,7 @@ out:
>         return 1;
>  }
>
> -extern int
> -group_by_prio (struct multipath * mp)
> +int group_by_prio(struct multipath *mp)
>  {
>         int i;
>         unsigned int prio;
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 865562b..5b03383 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -942,8 +942,7 @@ snprint_pathgroup (char * line, int len, char * format,
>         return (c - line);
>  }
>
> -extern void
> -print_multipath_topology (struct multipath * mpp, int verbosity)
> +void print_multipath_topology(struct multipath *mpp, int verbosity)
>  {
>         int resize;
>         char *buff = NULL;
> @@ -973,9 +972,8 @@ print_multipath_topology (struct multipath * mpp, int
> verbosity)
>         FREE(buff);
>  }
>
> -extern int
> -snprint_multipath_topology (char * buff, int len, struct multipath * mpp,
> -                           int verbosity)
> +int snprint_multipath_topology(char *buff, int len, struct multipath
> *mpp,
> +                              int verbosity)
>  {
>         int j, i, fwd = 0;
>         struct path * pp = NULL;
> @@ -1247,8 +1245,7 @@ snprint_hwentry (struct config *conf, char * buff,
> int len, struct hwentry * hwe
>         return fwd;
>  }
>
> -extern int
> -snprint_hwtable (struct config *conf, char * buff, int len, vector
> hwtable)
> +int snprint_hwtable(struct config *conf, char *buff, int len, vector
> hwtable)
>  {
>         int fwd = 0;
>         int i;
> @@ -1300,8 +1297,7 @@ snprint_mpentry (struct config *conf, char * buff,
> int len, struct mpentry * mpe
>         return fwd;
>  }
>
> -extern int
> -snprint_mptable (struct config *conf, char * buff, int len, vector
> mptable)
> +int snprint_mptable(struct config *conf, char *buff, int len, vector
> mptable)
>  {
>         int fwd = 0;
>         int i;
> @@ -1326,8 +1322,8 @@ snprint_mptable (struct config *conf, char * buff,
> int len, vector mptable)
>         return fwd;
>  }
>
> -extern int
> -snprint_overrides (struct config *conf, char * buff, int len, struct
> hwentry *overrides)
> +int snprint_overrides(struct config *conf, char * buff, int len,
> +                     struct hwentry *overrides)
>  {
>         int fwd = 0;
>         int i;
> @@ -1356,8 +1352,7 @@ out:
>         return fwd;
>  }
>
> -extern int
> -snprint_defaults (struct config *conf, char * buff, int len)
> +int snprint_defaults(struct config *conf, char *buff, int len)
>  {
>         int fwd = 0;
>         int i;
> @@ -1438,8 +1433,7 @@ snprint_blacklist_devgroup (char *buff, int len, int
> *fwd, vector *vec)
>         return pos;
>  }
>
> -extern int
> -snprint_blacklist_report (struct config *conf, char * buff, int len)
> +int snprint_blacklist_report(struct config *conf, char *buff, int len)
>  {
>         int threshold = MAX_LINE_LEN;
>         int fwd = 0;
> @@ -1501,8 +1495,7 @@ snprint_blacklist_report (struct config *conf, char
> * buff, int len)
>         return fwd;
>  }
>
> -extern int
> -snprint_blacklist (struct config *conf, char * buff, int len)
> +int snprint_blacklist(struct config *conf, char *buff, int len)
>  {
>         int i;
>         struct blentry * ble;
> @@ -1578,8 +1571,7 @@ snprint_blacklist (struct config *conf, char * buff,
> int len)
>         return fwd;
>  }
>
> -extern int
> -snprint_blacklist_except (struct config *conf, char * buff, int len)
> +int snprint_blacklist_except(struct config *conf, char *buff, int len)
>  {
>         int i;
>         struct blentry * ele;
> @@ -1655,8 +1647,7 @@ snprint_blacklist_except (struct config *conf, char
> * buff, int len)
>         return fwd;
>  }
>
> -extern int
> -snprint_status (char * buff, int len, struct vectors *vecs)
> +int snprint_status(char *buff, int len, struct vectors *vecs)
>  {
>         int fwd = 0;
>         int i;
> @@ -1687,8 +1678,8 @@ snprint_status (char * buff, int len, struct vectors
> *vecs)
>         return fwd;
>  }
>
> -extern int
> -snprint_devices (struct config *conf, char * buff, int len, struct
> vectors *vecs)
> +int snprint_devices(struct config *conf, char * buff, int len,
> +                   struct vectors *vecs)
>  {
>         DIR *blkdir;
>         struct dirent *blkdev;
> @@ -1756,8 +1747,7 @@ snprint_devices (struct config *conf, char * buff,
> int len, struct vectors *vecs
>  /*
>   * stdout printing helpers
>   */
> -extern void
> -print_path (struct path * pp, char * style)
> +void print_path(struct path *pp, char *style)
>  {
>         char line[MAX_LINE_LEN];
>
> @@ -1766,8 +1756,7 @@ print_path (struct path * pp, char * style)
>         printf("%s", line);
>  }
>
> -extern void
> -print_multipath (struct multipath * mpp, char * style)
> +void print_multipath(struct multipath *mpp, char *style)
>  {
>         char line[MAX_LINE_LEN];
>
> @@ -1776,8 +1765,7 @@ print_multipath (struct multipath * mpp, char *
> style)
>         printf("%s", line);
>  }
>
> -extern void
> -print_pathgroup (struct pathgroup * pgp, char * style)
> +void print_pathgroup(struct pathgroup *pgp, char *style)
>  {
>         char line[MAX_LINE_LEN];
>
> @@ -1786,8 +1774,7 @@ print_pathgroup (struct pathgroup * pgp, char *
> style)
>         printf("%s", line);
>  }
>
> -extern void
> -print_map (struct multipath * mpp, char * params)
> +void print_map(struct multipath *mpp, char *params)
>  {
>         if (mpp->size && params)
>                 printf("0 %llu %s %s\n",
> @@ -1795,14 +1782,12 @@ print_map (struct multipath * mpp, char * params)
>         return;
>  }
>
> -extern void
> -print_all_paths (vector pathvec, int banner)
> +void print_all_paths(vector pathvec, int banner)
>  {
>         print_all_paths_custo(pathvec, banner, PRINT_PATH_LONG);
>  }
>
> -extern void
> -print_all_paths_custo (vector pathvec, int banner, char *fmt)
> +void print_all_paths_custo(vector pathvec, int banner, char *fmt)
>  {
>         int i;
>         struct path * pp;
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index ec1fd92..aa7352f 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -81,8 +81,7 @@ do_attr_set(var, mp->mpe, shift, "(LUN setting)")
>  #define set_attr_conf(var, shift)                                      \
>  do_attr_set(var, conf, shift, "(config file default)")
>
> -extern int
> -select_mode (struct config *conf, struct multipath *mp)
> +int select_mode(struct config *conf, struct multipath *mp)
>  {
>         char *origin;
>
> @@ -95,8 +94,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_uid (struct config *conf, struct multipath *mp)
> +int select_uid(struct config *conf, struct multipath *mp)
>  {
>         char *origin;
>
> @@ -109,8 +107,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_gid (struct config *conf, struct multipath *mp)
> +int select_gid(struct config *conf, struct multipath *mp)
>  {
>         char *origin;
>
> @@ -128,8 +125,7 @@ out:
>   * traverse the configuration layers from most specific to most generic
>   * stop at first explicit setting found
>   */
> -extern int
> -select_rr_weight (struct config *conf, struct multipath * mp)
> +int select_rr_weight(struct config *conf, struct multipath * mp)
>  {
>         char *origin, buff[13];
>
> @@ -144,8 +140,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_pgfailback (struct config *conf, struct multipath * mp)
> +int select_pgfailback(struct config *conf, struct multipath * mp)
>  {
>         char *origin, buff[13];
>
> @@ -160,8 +155,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_pgpolicy (struct config *conf, struct multipath * mp)
> +int select_pgpolicy(struct config *conf, struct multipath * mp)
>  {
>         char *origin, buff[POLICY_NAME_SIZE];
>
> @@ -182,8 +176,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_selector (struct config *conf, struct multipath * mp)
> +int select_selector(struct config *conf, struct multipath * mp)
>  {
>         char *origin;
>
> @@ -236,8 +229,7 @@ out:
>         return (user_friendly_names == USER_FRIENDLY_NAMES_ON);
>  }
>
> -extern int
> -select_alias (struct config *conf, struct multipath * mp)
> +int select_alias(struct config *conf, struct multipath * mp)
>  {
>         char *origin = NULL;
>
> @@ -276,8 +268,7 @@ out:
>         return mp->alias ? 0 : 1;
>  }
>
> -extern int
> -select_features (struct config *conf, struct multipath * mp)
> +int select_features(struct config *conf, struct multipath *mp)
>  {
>         char *origin;
>
> @@ -302,8 +293,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_hwhandler (struct config *conf, struct multipath * mp)
> +int select_hwhandler(struct config *conf, struct multipath *mp)
>  {
>         char *origin;
>
> @@ -317,8 +307,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_checker(struct config *conf, struct path *pp)
> +int select_checker(struct config *conf, struct path *pp)
>  {
>         char *origin, *checker_name;
>         struct checker * c = &pp->checker;
> @@ -346,8 +335,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_getuid (struct config *conf, struct path * pp)
> +int select_getuid(struct config *conf, struct path *pp)
>  {
>         char *origin;
>
> @@ -400,8 +388,7 @@ do {
>                       \
>         }                                                               \
>  } while(0)
>
> -extern int
> -select_prio (struct config *conf, struct path * pp)
> +int select_prio(struct config *conf, struct path *pp)
>  {
>         char *origin;
>         struct mpentry * mpe;
> @@ -438,8 +425,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_no_path_retry(struct config *conf, struct multipath *mp)
> +int select_no_path_retry(struct config *conf, struct multipath *mp)
>  {
>         char *origin = NULL;
>         char buff[12];
> @@ -497,8 +483,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_minio (struct config *conf, struct multipath * mp)
> +int select_minio(struct config *conf, struct multipath *mp)
>  {
>         unsigned int minv_dmrq[3] = {1, 1, 0};
>
> @@ -508,8 +493,7 @@ select_minio (struct config *conf, struct multipath *
> mp)
>                 return select_minio_bio(conf, mp);
>  }
>
> -extern int
> -select_fast_io_fail(struct config *conf, struct multipath *mp)
> +int select_fast_io_fail(struct config *conf, struct multipath *mp)
>  {
>         char *origin, buff[12];
>
> @@ -523,8 +507,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_dev_loss(struct config *conf, struct multipath *mp)
> +int select_dev_loss(struct config *conf, struct multipath *mp)
>  {
>         char *origin, buff[12];
>
> @@ -539,8 +522,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_flush_on_last_del(struct config *conf, struct multipath *mp)
> +int select_flush_on_last_del(struct config *conf, struct multipath *mp)
>  {
>         char *origin;
>
> @@ -557,8 +539,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_reservation_key (struct config *conf, struct multipath * mp)
> +int select_reservation_key(struct config *conf, struct multipath *mp)
>  {
>         char *origin, buff[12];
>
> @@ -572,8 +553,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_retain_hwhandler (struct config *conf, struct multipath * mp)
> +int select_retain_hwhandler(struct config *conf, struct multipath *mp)
>  {
>         char *origin;
>         unsigned int minv_dm_retain[3] = {1, 5, 0};
> @@ -594,8 +574,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_detect_prio (struct config *conf, struct path * pp)
> +int select_detect_prio(struct config *conf, struct path *pp)
>  {
>         char *origin;
>
> @@ -609,8 +588,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_deferred_remove (struct config *conf, struct multipath *mp)
> +int select_deferred_remove(struct config *conf, struct multipath *mp)
>  {
>         char *origin;
>
> @@ -635,8 +613,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_delay_watch_checks(struct config *conf, struct multipath *mp)
> +int select_delay_watch_checks(struct config *conf, struct multipath *mp)
>  {
>         char *origin, buff[12];
>
> @@ -651,8 +628,7 @@ out:
>         return 0;
>  }
>
> -extern int
> -select_delay_wait_checks(struct config *conf, struct multipath *mp)
> +int select_delay_wait_checks(struct config *conf, struct multipath *mp)
>  {
>         char *origin, buff[12];
>
> @@ -668,8 +644,7 @@ out:
>
>  }
>
> -extern int
> -select_skip_kpartx (struct config *conf, struct multipath * mp)
> +int select_skip_kpartx (struct config *conf, struct multipath * mp)
>  {
>         char *origin;
>
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index e4bf4c6..ba9edf9 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -201,8 +201,7 @@ alloc_multipath (void)
>         return mpp;
>  }
>
> -extern void
> -free_multipath_attributes (struct multipath * mpp)
> +void free_multipath_attributes(struct multipath *mpp)
>  {
>         if (!mpp)
>                 return;
> @@ -439,8 +438,7 @@ find_path_by_devt (vector pathvec, char * dev_t)
>         return NULL;
>  }
>
> -extern int
> -pathcountgr (struct pathgroup * pgp, int state)
> +int pathcountgr(struct pathgroup *pgp, int state)
>  {
>         struct path *pp;
>         int count = 0;
> @@ -453,8 +451,7 @@ pathcountgr (struct pathgroup * pgp, int state)
>         return count;
>  }
>
> -extern int
> -pathcount (struct multipath * mpp, int state)
> +int pathcount(struct multipath *mpp, int state)
>  {
>         struct pathgroup *pgp;
>         int count = 0;
> @@ -467,8 +464,7 @@ pathcount (struct multipath * mpp, int state)
>         return count;
>  }
>
> -extern int
> -pathcmp (struct pathgroup *pgp, struct pathgroup *cpgp)
> +int pathcmp(struct pathgroup *pgp, struct pathgroup *cpgp)
>  {
>         int i, j;
>         struct path *pp, *cpp;
> @@ -498,8 +494,7 @@ first_path (struct multipath * mpp)
>         return pgp?VECTOR_SLOT(pgp->paths, 0):NULL;
>  }
>
> -extern void
> -setup_feature(struct multipath * mpp, char *feature)
> +void setup_feature(struct multipath *mpp, char *feature)
>  {
>         if (!strncmp(feature, "queue_if_no_path", 16)) {
>                 if (mpp->no_path_retry <= NO_PATH_RETRY_UNDEF)
> @@ -507,8 +502,7 @@ setup_feature(struct multipath * mpp, char *feature)
>         }
>  }
>
> -extern int
> -add_feature (char **f, char *n)
> +int add_feature(char **f, char *n)
>  {
>         int c = 0, d, l;
>         char *e, *p, *t;
> @@ -592,8 +586,7 @@ add_feature (char **f, char *n)
>         return 0;
>  }
>
> -extern int
> -remove_feature(char **f, char *o)
> +int remove_feature(char **f, char *o)
>  {
>         int c = 0, d, l;
>         char *e, *p, *n;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index e898528..22be8e0 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -20,8 +20,7 @@
>  /*
>   * creates or updates mpp->paths reading mpp->pg
>   */
> -extern int
> -update_mpp_paths(struct multipath * mpp, vector pathvec)
> +int update_mpp_paths(struct multipath *mpp, vector pathvec)
>  {
>         struct pathgroup * pgp;
>         struct path * pp;
> @@ -45,8 +44,7 @@ update_mpp_paths(struct multipath * mpp, vector pathvec)
>         return 0;
>  }
>
> -extern int
> -adopt_paths (vector pathvec, struct multipath * mpp)
> +int adopt_paths(vector pathvec, struct multipath *mpp)
>  {
>         int i, ret;
>         struct path * pp;
> @@ -81,8 +79,7 @@ adopt_paths (vector pathvec, struct multipath * mpp)
>         return 0;
>  }
>
> -extern void
> -orphan_path (struct path * pp, const char *reason)
> +void orphan_path(struct path *pp, const char *reason)
>  {
>         condlog(3, "%s: orphan path, %s", pp->dev, reason);
>         pp->mpp = NULL;
> @@ -96,8 +93,7 @@ orphan_path (struct path * pp, const char *reason)
>         pp->fd = -1;
>  }
>
> -extern void
> -orphan_paths (vector pathvec, struct multipath * mpp)
> +void orphan_paths(vector pathvec, struct multipath *mpp)
>  {
>         int i;
>         struct path * pp;
> @@ -151,15 +147,13 @@ _remove_map (struct multipath * mpp, struct vectors
> * vecs,
>         free_multipath(mpp, KEEP_PATHS);
>  }
>
> -extern void
> -remove_map (struct multipath * mpp, struct vectors * vecs, int purge_vec)
> +void remove_map(struct multipath *mpp, struct vectors *vecs, int
> purge_vec)
>  {
>         _remove_map(mpp, vecs, KEEP_WAITER, purge_vec);
>  }
>
> -extern void
> -remove_map_and_stop_waiter (struct multipath * mpp, struct vectors * vecs,
> -                           int purge_vec)
> +void remove_map_and_stop_waiter(struct multipath *mpp, struct vectors
> *vecs,
> +                               int purge_vec)
>  {
>         _remove_map(mpp, vecs, STOP_WAITER, purge_vec);
>  }
> @@ -182,14 +176,12 @@ _remove_maps (struct vectors * vecs, int stop_waiter)
>         vecs->mpvec = NULL;
>  }
>
> -extern void
> -remove_maps (struct vectors * vecs)
> +void remove_maps(struct vectors *vecs)
>  {
>         _remove_maps(vecs, KEEP_WAITER);
>  }
>
> -extern void
> -remove_maps_and_stop_waiters (struct vectors * vecs)
> +void remove_maps_and_stop_waiters(struct vectors *vecs)
>  {
>         _remove_maps(vecs, STOP_WAITER);
>  }
> @@ -320,8 +312,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)
>                 pp->mpp = mpp;
>  }
>
> -extern int
> -update_multipath_strings (struct multipath *mpp, vector pathvec, int
> is_daemon)
> +int
> +update_multipath_strings(struct multipath *mpp, vector pathvec, int
> is_daemon)
>  {
>         if (!mpp)
>                 return 1;
> @@ -343,8 +335,7 @@ update_multipath_strings (struct multipath *mpp,
> vector pathvec, int is_daemon)
>         return 0;
>  }
>
> -extern void
> -set_no_path_retry(struct config *conf, struct multipath *mpp)
> +void set_no_path_retry(struct config *conf, struct multipath *mpp)
>  {
>         mpp->retry_tick = 0;
>         mpp->nr_active = pathcount(mpp, PATH_UP) + pathcount(mpp,
> PATH_GHOST);
> @@ -373,9 +364,8 @@ set_no_path_retry(struct config *conf, struct
> multipath *mpp)
>         }
>  }
>
> -extern int
> -__setup_multipath (struct vectors * vecs, struct multipath * mpp,
> -                  int reset, int is_daemon)
> +int __setup_multipath(struct vectors *vecs, struct multipath *mpp,
> +                     int reset, int is_daemon)
>  {
>         struct config *conf;
>
> @@ -425,8 +415,7 @@ out:
>         return 1;
>  }
>
> -extern struct multipath *
> -add_map_without_path (struct vectors * vecs, char * alias)
> +struct multipath *add_map_without_path (struct vectors *vecs, char *alias)
>  {
>         struct multipath * mpp = alloc_multipath();
>
> @@ -473,9 +462,8 @@ find_existing_alias (struct multipath * mpp,
>                 }
>  }
>
> -extern struct multipath *
> -add_map_with_path (struct vectors * vecs,
> -                  struct path * pp, int add_vec)
> +struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
> +                                   int add_vec)
>  {
>         struct multipath * mpp;
>         struct config *conf = NULL;
> @@ -514,8 +502,7 @@ out:
>         return NULL;
>  }
>
> -extern int
> -verify_paths(struct multipath * mpp, struct vectors * vecs)
> +int verify_paths(struct multipath *mpp, struct vectors *vecs)
>  {
>         struct path * pp;
>         int count = 0;
> diff --git a/libmultipath/switchgroup.c b/libmultipath/switchgroup.c
> index 031c3d7..9632ce2 100644
> --- a/libmultipath/switchgroup.c
> +++ b/libmultipath/switchgroup.c
> @@ -7,8 +7,7 @@
>  #include "structs.h"
>  #include "switchgroup.h"
>
> -extern void
> -path_group_prio_update (struct pathgroup * pgp)
> +void path_group_prio_update(struct pathgroup *pgp)
>  {
>         int i;
>         int priority = 0;
> @@ -32,8 +31,7 @@ path_group_prio_update (struct pathgroup * pgp)
>                 pgp->priority = 0;
>  }
>
> -extern int
> -select_path_group (struct multipath * mpp)
> +int select_path_group(struct multipath *mpp)
>  {
>         int i;
>         int max_priority = 0;
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index 19b910f..7edcce1 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -559,8 +559,7 @@ out:
>         return err;
>  }
>
> -extern int
> -uevent_get_major(struct uevent *uev)
> +int uevent_get_major(struct uevent *uev)
>  {
>         char *p, *q;
>         int i, major = -1;
> @@ -579,8 +578,7 @@ uevent_get_major(struct uevent *uev)
>         return major;
>  }
>
> -extern int
> -uevent_get_minor(struct uevent *uev)
> +int uevent_get_minor(struct uevent *uev)
>  {
>         char *p, *q;
>         int i, minor = -1;
> @@ -599,8 +597,7 @@ uevent_get_minor(struct uevent *uev)
>         return minor;
>  }
>
> -extern int
> -uevent_get_disk_ro(struct uevent *uev)
> +int uevent_get_disk_ro(struct uevent *uev)
>  {
>         char *p, *q;
>         int i, ro = -1;
> @@ -619,8 +616,7 @@ uevent_get_disk_ro(struct uevent *uev)
>         return ro;
>  }
>
> -extern char *
> -uevent_get_dm_name(struct uevent *uev)
> +char *uevent_get_dm_name(struct uevent *uev)
>  {
>         char *p = NULL;
>         int i;
> diff --git a/libmultipath/util.c b/libmultipath/util.c
> index 0a136b4..03a5738 100644
> --- a/libmultipath/util.c
> +++ b/libmultipath/util.c
> @@ -145,8 +145,7 @@ size_t strlcat(char *dst, const char *src, size_t size)
>         return bytes;
>  }
>
> -extern int
> -devt2devname (char *devname, int devname_len, char *devt)
> +int devt2devname(char *devname, int devname_len, char *devt)
>  {
>         FILE *fd;
>         unsigned int tmpmaj, tmpmin, major, minor;
> --
> 2.10.1
>
>

--001a1142a8de39eba40541bb9e09
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged as commit b573878f76a893cece197b5969e54099a5fac905.=
<div>Merge rejects committed as=C2=A09c4be4c0d1b06c066098dafb5aeb914bae1f11=
0b.</div><div><br></div><div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Fri, Nov 18, 2016 at 9:50 PM, Bart Van As=
sche <span dir=3D"ltr">&lt;<a href=3D"mailto:bart.vanassche@sandisk.com" ta=
rget=3D"_blank">bart.vanassche@sandisk.com</a>&gt;</span> wrote:<br><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex">This avoids that the sparse static analyzer complai=
ns about<br>
the &quot;extern&quot; keyword.<br>
<br>
Signed-off-by: Bart Van Assche &lt;<a href=3D"mailto:bart.vanassche@sandisk=
.com">bart.vanassche@sandisk.com</a>&gt;<br>
---<br>
=C2=A0kpartx/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0| 18 ++++-----<br>
=C2=A0kpartx/lopart.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 | 15 +++-----<br>
=C2=A0libmpathpersist/mpath_pr_<wbr>ioctl.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 2 +-=
<br>
=C2=A0libmultipath/blacklist.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 9 ++---<br>
=C2=A0libmultipath/callout.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 3 +-<br>
=C2=A0libmultipath/checkers/cciss_<wbr>tur.c=C2=A0 =C2=A0 |=C2=A0 3 +-<br>
=C2=A0libmultipath/checkers/emc_<wbr>clariion.c |=C2=A0 3 +-<br>
=C2=A0libmultipath/checkers/hp_sw.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 3 +-=
<br>
=C2=A0libmultipath/checkers/rdac.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0=
 3 +-<br>
=C2=A0libmultipath/checkers/tur.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0=
 3 +-<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 |=C2=A0 6 +--<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 21 +++++-----<br>
=C2=A0libmultipath/devmapper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0| 49 +++++++++--------------<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0|=C2=A0 5 +--<br>
=C2=A0libmultipath/dmparser.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 |=C2=A0 8 ++--<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 3 +-<br>
=C2=A0libmultipath/pgpolicies.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =
23 +++++------<br>
=C2=A0libmultipath/print.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0| 55 ++++++++++----------------<br>
=C2=A0libmultipath/propsel.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0| 75 ++++++++++++------------------<wbr>------<br>
=C2=A0libmultipath/structs.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0| 21 ++++------<br>
=C2=A0libmultipath/structs_vec.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| =
49 +++++++++--------------<br>
=C2=A0libmultipath/switchgroup.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
=C2=A0 6 +--<br>
=C2=A0libmultipath/uevent.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 | 12 ++----<br>
=C2=A0libmultipath/util.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 |=C2=A0 3 +-<br>
=C2=A024 files changed, 145 insertions(+), 253 deletions(-)<br>
<br>
diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c<br>
index 474d879..2acae25 100644<br>
--- a/kpartx/devmapper.c<br>
+++ b/kpartx/devmapper.c<br>
@@ -14,8 +14,7 @@<br>
=C2=A0#define MAX_PREFIX_LEN 8<br>
=C2=A0#define PARAMS_SIZE 1024<br>
<br>
-extern int<br>
-dm_prereq (char * str, int x, int y, int z)<br>
+int dm_prereq(char * str, int x, int y, int z)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
@@ -52,8 +51,8 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_simplecmd (int task, const char *name, int no_flush, uint16_t udev_flag=
s) {<br>
+int dm_simplecmd(int task, const char *name, int no_flush, uint16_t udev_f=
lags)<br>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int udev_wait_flag =3D (task =3D=3D DM_DEVICE_R=
ESUME ||<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 task =3D=3D DM_DEVICE_REMOVE);<br>
@@ -90,10 +89,10 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_addmap (int task, const char *name, const char *target,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const char *params, uint64_t size, int =
ro, const char *uuid, int part,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mode_t mode, uid_t uid, gid_t gid) {<br=
>
+int dm_addmap(int task, const char *name, const char *target,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const char *params, uint64=
_t size, int ro, const char *uuid,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int part, mode_t mode, uid=
_t uid, gid_t gid)<br>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *prefixed_uuid =3D NULL;<br>
@@ -154,8 +153,7 @@ addout:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_map_present (char * str, char **uuid)<br>
+int dm_map_present(char * str, char **uuid)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
diff --git a/kpartx/lopart.c b/kpartx/lopart.c<br>
index 14af34f..2eb3f63 100644<br>
--- a/kpartx/lopart.c<br>
+++ b/kpartx/lopart.c<br>
@@ -62,8 +62,7 @@ xstrdup (const char *s)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return t;<br>
=C2=A0}<br>
<br>
-extern int<br>
-is_loop_device (const char *device)<br>
+int is_loop_device(const char *device)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct stat statbuf;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int loopmajor;<br>
@@ -96,8 +95,7 @@ is_loop_device (const char *device)<br>
<br>
=C2=A0#define SIZE(a) (sizeof(a)/sizeof(a[0]))<br>
<br>
-extern char *<br>
-find_loop_by_file (const char * filename)<br>
+char *find_loop_by_file(const char *filename)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 DIR *dir;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dirent *dent;<br>
@@ -144,8 +142,7 @@ find_loop_by_file (const char * filename)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return found;<br>
=C2=A0}<br>
<br>
-extern char *<br>
-find_unused_loop_device (void)<br>
+char *find_unused_loop_device(void)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char dev[20], *next_loop_dev =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fd, next_loop =3D 0, somedev =3D 0, someloo=
p =3D 0, loop_known =3D 0;<br>
@@ -231,8 +228,7 @@ find_unused_loop_device (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
=C2=A0}<br>
<br>
-extern int<br>
-set_loop (const char *device, const char *file, int offset, int *loopro)<b=
r>
+int set_loop(const char *device, const char *file, int offset, int *loopro=
)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct loop_info loopinfo;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fd, ffd, mode;<br>
@@ -284,8 +280,7 @@ set_loop (const char *device, const char *file, int off=
set, int *loopro)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-del_loop (const char *device)<br>
+int del_loop(const char *device)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int retries =3D 5;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fd;<br>
diff --git a/libmpathpersist/mpath_pr_<wbr>ioctl.c b/libmpathpersist/mpath_=
pr_<wbr>ioctl.c<br>
index 8b9ac3d..31b2fe6 100644<br>
--- a/libmpathpersist/mpath_pr_<wbr>ioctl.c<br>
+++ b/libmpathpersist/mpath_pr_<wbr>ioctl.c<br>
@@ -36,7 +36,7 @@ void decode_transport_id(struct prin_fulldescr *fdesc, un=
signed char * p, int le<br>
=C2=A0int get_prin_length(int rq_servact);<br>
=C2=A0int mpath_isLittleEndian(void);<br>
<br>
-extern unsigned int mpath_mx_alloc_len;<br>
+unsigned int mpath_mx_alloc_len;<br>
<br>
=C2=A0int prout_do_scsi_ioctl(char * dev, int rq_servact, int rq_scope,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int rq_typ=
e, struct prout_param_descriptor *paramp, int noisy)<br>
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c<br>
index f6c4506..d59d37e 100644<br>
--- a/libmultipath/blacklist.c<br>
+++ b/libmultipath/blacklist.c<br>
@@ -13,8 +13,7 @@<br>
=C2=A0#include &quot;config.h&quot;<br>
=C2=A0#include &quot;blacklist.h&quot;<br>
<br>
-extern int<br>
-store_ble (vector blist, char * str, int origin)<br>
+int store_ble(vector blist, char * str, int origin)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct blentry * ble;<br>
<br>
@@ -47,8 +46,7 @@ out:<br>
=C2=A0}<br>
<br>
<br>
-extern int<br>
-alloc_ble_device (vector blist)<br>
+int alloc_ble_device(vector blist)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct blentry_device * ble =3D MALLOC(sizeof(s=
truct blentry_device));<br>
<br>
@@ -63,8 +61,7 @@ alloc_ble_device (vector blist)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-set_ble_device (vector blist, char * vendor, char * product, int origin)<b=
r>
+int set_ble_device(vector blist, char * vendor, char * product, int origin=
)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct blentry_device * ble;<br>
<br>
diff --git a/libmultipath/callout.c b/libmultipath/callout.c<br>
index 4d1b067..dc18e02 100644<br>
--- a/libmultipath/callout.c<br>
+++ b/libmultipath/callout.c<br>
@@ -137,8 +137,7 @@ int execute_program(char *path, char *value, int len)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return retval;<br>
=C2=A0}<br>
<br>
-extern int<br>
-apply_format (char * string, char * cmd, struct path * pp)<br>
+int apply_format(char * string, char * cmd, struct path * pp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * pos;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * dst;<br>
diff --git a/libmultipath/checkers/cciss_<wbr>tur.c b/libmultipath/checkers=
/cciss_<wbr>tur.c<br>
index a0ffffe..9d79f96 100644<br>
--- a/libmultipath/checkers/cciss_<wbr>tur.c<br>
+++ b/libmultipath/checkers/cciss_<wbr>tur.c<br>
@@ -64,8 +64,7 @@ void libcheck_repair (struct checker * c)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
=C2=A0}<br>
<br>
-extern int<br>
-libcheck_check (struct checker * c)<br>
+int libcheck_check(struct checker * c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int rc;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret;<br>
diff --git a/libmultipath/checkers/emc_<wbr>clariion.c b/libmultipath/check=
ers/emc_<wbr>clariion.c<br>
index a7b9f86..9c1ffed 100644<br>
--- a/libmultipath/checkers/emc_<wbr>clariion.c<br>
+++ b/libmultipath/checkers/emc_<wbr>clariion.c<br>
@@ -50,8 +50,7 @@ struct emc_clariion_checker_LU_<wbr>context {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int inactive_snap;<br>
=C2=A0};<br>
<br>
-extern void<br>
-hexadecimal_to_ascii(char * wwn, char *wwnstr)<br>
+void hexadecimal_to_ascii(char * wwn, char *wwnstr)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i,j, nbl;<br>
<br>
diff --git a/libmultipath/checkers/hp_sw.<wbr>c b/libmultipath/checkers/hp_=
sw.<wbr>c<br>
index 0cc1111..6019c9d 100644<br>
--- a/libmultipath/checkers/hp_sw.<wbr>c<br>
+++ b/libmultipath/checkers/hp_sw.<wbr>c<br>
@@ -128,8 +128,7 @@ do_tur (int fd, unsigned int timeout)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-libcheck_check (struct checker * c)<br>
+int libcheck_check(struct checker * c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char buff[MX_ALLOC_LEN];<br>
<br>
diff --git a/libmultipath/checkers/rdac.c b/libmultipath/checkers/rdac.c<br=
>
index 68682c8..a643a4a 100644<br>
--- a/libmultipath/checkers/rdac.c<br>
+++ b/libmultipath/checkers/rdac.c<br>
@@ -262,8 +262,7 @@ const char<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
-extern int<br>
-libcheck_check (struct checker * c)<br>
+int libcheck_check(struct checker * c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct volume_access_inq inq;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret, inqfail;<br>
diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c<br>
index 92200aa..4d6c3c2 100644<br>
--- a/libmultipath/checkers/tur.c<br>
+++ b/libmultipath/checkers/tur.c<br>
@@ -314,8 +314,7 @@ static void copy_msg_to_checker(void *c_p, const char *=
msg)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 strlcpy(c-&gt;message, msg, sizeof(c-&gt;messag=
e));<br>
=C2=A0}<br>
<br>
-extern int<br>
-libcheck_check (struct checker * c)<br>
+int libcheck_check(struct checker * c)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct tur_checker_context *ct =3D c-&gt;contex=
t;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct timespec tsp;<br>
diff --git a/libmultipath/config.c b/libmultipath/config.c<br>
index 2d629ef..32b41a2 100644<br>
--- a/libmultipath/config.c<br>
+++ b/libmultipath/config.c<br>
@@ -125,8 +125,7 @@ find_hwe (vector hwtable, char * vendor, char * product=
, char * revision)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;<br>
=C2=A0}<br>
<br>
-extern struct mpentry *<br>
-find_mpe (vector mptable, char * wwid)<br>
+struct mpentry *find_mpe(vector mptable, char *wwid)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mpentry * mpe;<br>
@@ -141,8 +140,7 @@ find_mpe (vector mptable, char * wwid)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
=C2=A0}<br>
<br>
-extern char *<br>
-get_mpe_wwid (vector mptable, char * alias)<br>
+char *get_mpe_wwid(vector mptable, char *alias)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mpentry * mpe;<br>
diff --git a/libmultipath/configure.c b/libmultipath/configure.c<br>
index d428099..e5cc5f1 100644<br>
--- a/libmultipath/configure.c<br>
+++ b/libmultipath/configure.c<br>
@@ -253,8 +253,7 @@ int rr_optimize_path_order(struct pathgroup *pgp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-setup_map (struct multipath * mpp, char * params, int params_size)<br>
+int setup_map(struct multipath *mpp, char *params, int params_size)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pathgroup * pgp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct config *conf;<br>
@@ -505,8 +504,7 @@ select_action (struct multipath * mpp, vector curmp, in=
t force_reload)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
=C2=A0}<br>
<br>
-extern int<br>
-reinstate_paths (struct multipath * mpp)<br>
+int reinstate_paths(struct multipath *mpp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, j;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pathgroup * pgp;<br>
@@ -582,8 +580,7 @@ fail:<br>
=C2=A0#define DOMAP_EXIST=C2=A0 =C2=A0 2<br>
=C2=A0#define DOMAP_DRY=C2=A0 =C2=A0 =C2=A0 3<br>
<br>
-extern int<br>
-domap (struct multipath * mpp, char * params, int is_daemon)<br>
+int domap(struct multipath *mpp, char *params, int is_daemon)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D DOMAP_FAIL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct config *conf;<br>
@@ -748,8 +745,8 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;<br>
=C2=A0}<br>
<br>
-extern int<br>
-coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int f=
orce_reload, enum mpath_cmds cmd)<br>
+int coalesce_paths(struct vectors *vecs, vector newmp, char *refwwid,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int force_r=
eload, enum mpath_cmds cmd)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int k, i;<br>
@@ -953,9 +950,8 @@ coalesce_paths (struct vectors * vecs, vector newmp, ch=
ar * refwwid, int force_r<br>
=C2=A0 * 1 - failure<br>
=C2=A0 * 2 - blacklist<br>
=C2=A0 */<br>
-extern int<br>
-get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vector pathvec, char **wwid)<br>
+int get_refwwid(enum mpath_cmds cmd, char *dev, enum devtypes dev_type,<br=
>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vector pathvec, cha=
r **wwid)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
@@ -1126,7 +1122,8 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern int reload_map(struct vectors *vecs, struct multipath *mpp, int ref=
resh, int is_daemon)<br>
+int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int is_daemon)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char params[PARAMS_SIZE] =3D {0};<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path *pp;<br>
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c<br>
index 5aea5b6..868d2c0 100644<br>
--- a/libmultipath/devmapper.c<br>
+++ b/libmultipath/devmapper.c<br>
@@ -94,8 +94,8 @@ dm_write_log (int level, const char *file, int line, cons=
t char *f, ...)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
=C2=A0}<br>
<br>
-extern void<br>
-dm_init(int v) {<br>
+void dm_init(int v)<br>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_log_init(&amp;dm_write_log);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 dm_log_init_verbose(v + 3);<br>
=C2=A0}<br>
@@ -200,8 +200,7 @@ dm_drv_prereq (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_prereq (void)<br>
+int dm_prereq(void)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (dm_lib_prereq())<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
@@ -249,13 +248,13 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags) {<br>
+int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags)<b=
r>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return dm_simplecmd(task, name, 0, 1, udev_flag=
s, 0);<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags) {<b=
r>
+int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags)=
<br>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return dm_simplecmd(task, name, 1, 1, udev_flag=
s, 0);<br>
=C2=A0}<br>
<br>
@@ -338,8 +337,8 @@ addout:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_addmap_create (struct multipath *mpp, char * params) {<br>
+int dm_addmap_create (struct multipath *mpp, char * params)<br>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int ro;<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 for (ro =3D 0; ro &lt;=3D 1; ro++) {<br>
@@ -369,8 +368,7 @@ dm_addmap_create (struct multipath *mpp, char * params)=
 {<br>
=C2=A0#define ADDMAP_RW 0<br>
=C2=A0#define ADDMAP_RO 1<br>
<br>
-extern int<br>
-dm_addmap_reload (struct multipath *mpp, char *params, int flush)<br>
+int dm_addmap_reload(struct multipath *mpp, char *params, int flush)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 uint16_t udev_flags =3D (flush ? 0 : MPATH_UDEV=
_RELOAD_FLAG) |<br>
@@ -397,8 +395,7 @@ dm_addmap_reload (struct multipath *mpp, char *params, =
int flush)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_map_present (const char * str)<br>
+int dm_map_present(const char * str)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
@@ -425,8 +422,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_get_map(const char * name, unsigned long long * size, char * outparams)=
<br>
+int dm_get_map(const char *name, unsigned long long *size, char *outparams=
)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
@@ -492,8 +488,7 @@ uuidout:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_get_uuid(char *name, char *uuid)<br>
+int dm_get_uuid(char *name, char *uuid)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char uuidtmp[WWID_SIZE];<br>
<br>
@@ -533,8 +528,7 @@ dm_compare_uuid(const char* mapname1, const char* mapna=
me2)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_get_status(char * name, char * outstatus)<br>
+int dm_get_status(char *name, char *outstatus)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
@@ -577,8 +571,7 @@ out:<br>
=C2=A0 *=C2=A0 =C2=A0 0 : no match<br>
=C2=A0 *=C2=A0 =C2=A0-1 : empty map<br>
=C2=A0 */<br>
-extern int<br>
-dm_type(const char * name, char * type)<br>
+int dm_type(const char *name, char *type)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
@@ -611,8 +604,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return r;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_is_mpath(const char * name)<br>
+int dm_is_mpath(const char *name)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
@@ -791,8 +783,7 @@ partmap_in_use(const char *name, void *data)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-_dm_flush_map (const char * mapname, int need_sync, int deferred_remove)<b=
r>
+int _dm_flush_map(const char *mapname, int need_sync, int deferred_remove)=
<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r;<br>
<br>
@@ -844,8 +835,7 @@ dm_flush_map_nopaths(const char * mapname, int deferred=
_remove)<br>
<br>
=C2=A0#endif<br>
<br>
-extern int<br>
-dm_suspend_and_flush_map (const char * mapname)<br>
+int dm_suspend_and_flush_map(const char *mapname)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int s =3D 0, queue_if_no_path =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long long mapsize;<br>
@@ -884,8 +874,7 @@ dm_suspend_and_flush_map (const char * mapname)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern int<br>
-dm_flush_maps (void)<br>
+int dm_flush_maps(void)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dm_task *dmt;<br>
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c<br>
index 756344f..786a7c0 100644<br>
--- a/libmultipath/discovery.c<br>
+++ b/libmultipath/discovery.c<br>
@@ -177,7 +177,7 @@ path_discovery (vector pathvec, int flag)<br>
=C2=A0}<br>
<br>
=C2=A0#define declare_sysfs_get_str(fname)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0\<br>
-extern ssize_t=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
+ssize_t=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0sysfs_get_##fname (struct udev_device * udev, char * buff, size_t len=
) \<br>
=C2=A0{=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int l;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
@@ -1714,8 +1714,7 @@ get_uid (struct path * pp, int path_state, struct ude=
v_device *udev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-pathinfo (struct path *pp, struct config *conf, int mask)<br>
+int pathinfo(struct path *pp, struct config *conf, int mask)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int path_state;<br>
<br>
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c<br>
index 87e8398..b504961 100644<br>
--- a/libmultipath/dmparser.c<br>
+++ b/libmultipath/dmparser.c<br>
@@ -140,9 +140,8 @@ assemble_map (struct multipath * mp, char * params, int=
 len)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-disassemble_map (vector pathvec, char * params, struct multipath * mpp,<br=
>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int is_daemon)<br>
+int disassemble_map(vector pathvec, char *params, struct multipath *mpp,<b=
r>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int i=
s_daemon)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * word;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * p;<br>
@@ -425,8 +424,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern int<br>
-disassemble_status (char * params, struct multipath * mpp)<br>
+int disassemble_status(char *params, struct multipath *mpp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * word;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * p;<br>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c<br>
index 340035e..afe6c13 100644<br>
--- a/libmultipath/hwtable.c<br>
+++ b/libmultipath/hwtable.c<br>
@@ -1106,8 +1106,7 @@ static struct hwentry default_hw[] =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 },<br>
=C2=A0};<br>
<br>
-extern int<br>
-setup_default_hwtable (vector hw)<br>
+int setup_default_hwtable(vector hw)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct hwentry * hwe =3D default_hw;<br>
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c<br>
index 3064aab..4ae4afb 100644<br>
--- a/libmultipath/pgpolicies.c<br>
+++ b/libmultipath/pgpolicies.c<br>
@@ -13,8 +13,7 @@<br>
=C2=A0#include &quot;pgpolicies.h&quot;<br>
=C2=A0#include &quot;switchgroup.h&quot;<br>
<br>
-extern int<br>
-get_pgpolicy_id (char * str)<br>
+int get_pgpolicy_id(char * str)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (0 =3D=3D strncmp(str, &quot;failover&quot;,=
 8))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return FAILOVER;<br=
>
@@ -30,8 +29,7 @@ get_pgpolicy_id (char * str)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return IOPOLICY_UNDEF;<br>
=C2=A0}<br>
<br>
-extern int<br>
-get_pgpolicy_name (char * buff, int len, int id)<br>
+int get_pgpolicy_name(char * buff, int len, int id)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char * s;<br>
<br>
@@ -89,8 +87,8 @@ sort_pathgroups (struct multipath *mp) {<br>
=C2=A0/*<br>
=C2=A0 * One path group per unique tgt_node_name present in the path vector=
<br>
=C2=A0 */<br>
-extern int<br>
-group_by_node_name (struct multipath * mp) {<br>
+int group_by_node_name(struct multipath * mp)<br>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, j;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int * bitmap;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
@@ -165,8 +163,8 @@ out:<br>
=C2=A0/*<br>
=C2=A0 * One path group per unique serial number present in the path vector=
<br>
=C2=A0 */<br>
-extern int<br>
-group_by_serial (struct multipath * mp) {<br>
+int group_by_serial(struct multipath * mp)<br>
+{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, j;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int * bitmap;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
@@ -237,8 +235,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern int<br>
-one_path_per_group (struct multipath * mp)<br>
+int one_path_per_group(struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
@@ -275,8 +272,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern int<br>
-one_group (struct multipath * mp)=C2=A0 =C2=A0 =C2=A0 /* aka multibus */<b=
r>
+int one_group(struct multipath *mp)=C2=A0 =C2=A0 /* aka multibus */<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pathgroup * pgp;<br>
<br>
@@ -313,8 +309,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern int<br>
-group_by_prio (struct multipath * mp)<br>
+int group_by_prio(struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int prio;<br>
diff --git a/libmultipath/print.c b/libmultipath/print.c<br>
index 865562b..5b03383 100644<br>
--- a/libmultipath/print.c<br>
+++ b/libmultipath/print.c<br>
@@ -942,8 +942,7 @@ snprint_pathgroup (char * line, int len, char * format,=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (c - line);<br>
=C2=A0}<br>
<br>
-extern void<br>
-print_multipath_topology (struct multipath * mpp, int verbosity)<br>
+void print_multipath_topology(<wbr>struct multipath *mpp, int verbosity)<b=
r>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int resize;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *buff =3D NULL;<br>
@@ -973,9 +972,8 @@ print_multipath_topology (struct multipath * mpp, int v=
erbosity)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FREE(buff);<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_multipath_topology (char * buff, int len, struct multipath * mpp,<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0int verbosity)<br>
+int snprint_multipath_topology(<wbr>char *buff, int len, struct multipath =
*mpp,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int verbosity)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int j, i, fwd =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp =3D NULL;<br>
@@ -1247,8 +1245,7 @@ snprint_hwentry (struct config *conf, char * buff, in=
t len, struct hwentry * hwe<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return fwd;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_hwtable (struct config *conf, char * buff, int len, vector hwtable=
)<br>
+int snprint_hwtable(struct config *conf, char *buff, int len, vector hwtab=
le)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fwd =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
@@ -1300,8 +1297,7 @@ snprint_mpentry (struct config *conf, char * buff, in=
t len, struct mpentry * mpe<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return fwd;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_mptable (struct config *conf, char * buff, int len, vector mptable=
)<br>
+int snprint_mptable(struct config *conf, char *buff, int len, vector mptab=
le)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fwd =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
@@ -1326,8 +1322,8 @@ snprint_mptable (struct config *conf, char * buff, in=
t len, vector mptable)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return fwd;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_overrides (struct config *conf, char * buff, int len, struct hwent=
ry *overrides)<br>
+int snprint_overrides(struct config *conf, char * buff, int len,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0struct hwentry *overrides)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fwd =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
@@ -1356,8 +1352,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return fwd;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_defaults (struct config *conf, char * buff, int len)<br>
+int snprint_defaults(struct config *conf, char *buff, int len)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fwd =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
@@ -1438,8 +1433,7 @@ snprint_blacklist_devgroup (char *buff, int len, int =
*fwd, vector *vec)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return pos;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_blacklist_report (struct config *conf, char * buff, int len)<br>
+int snprint_blacklist_report(<wbr>struct config *conf, char *buff, int len=
)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int threshold =3D MAX_LINE_LEN;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fwd =3D 0;<br>
@@ -1501,8 +1495,7 @@ snprint_blacklist_report (struct config *conf, char *=
 buff, int len)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return fwd;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_blacklist (struct config *conf, char * buff, int len)<br>
+int snprint_blacklist(struct config *conf, char *buff, int len)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct blentry * ble;<br>
@@ -1578,8 +1571,7 @@ snprint_blacklist (struct config *conf, char * buff, =
int len)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return fwd;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_blacklist_except (struct config *conf, char * buff, int len)<br>
+int snprint_blacklist_except(<wbr>struct config *conf, char *buff, int len=
)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct blentry * ele;<br>
@@ -1655,8 +1647,7 @@ snprint_blacklist_except (struct config *conf, char *=
 buff, int len)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return fwd;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_status (char * buff, int len, struct vectors *vecs)<br>
+int snprint_status(char *buff, int len, struct vectors *vecs)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int fwd =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
@@ -1687,8 +1678,8 @@ snprint_status (char * buff, int len, struct vectors =
*vecs)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return fwd;<br>
=C2=A0}<br>
<br>
-extern int<br>
-snprint_devices (struct config *conf, char * buff, int len, struct vectors=
 *vecs)<br>
+int snprint_devices(struct config *conf, char * buff, int len,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struc=
t vectors *vecs)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 DIR *blkdir;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct dirent *blkdev;<br>
@@ -1756,8 +1747,7 @@ snprint_devices (struct config *conf, char * buff, in=
t len, struct vectors *vecs<br>
=C2=A0/*<br>
=C2=A0 * stdout printing helpers<br>
=C2=A0 */<br>
-extern void<br>
-print_path (struct path * pp, char * style)<br>
+void print_path(struct path *pp, char *style)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char line[MAX_LINE_LEN];<br>
<br>
@@ -1766,8 +1756,7 @@ print_path (struct path * pp, char * style)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;%s&quot;, line);<br>
=C2=A0}<br>
<br>
-extern void<br>
-print_multipath (struct multipath * mpp, char * style)<br>
+void print_multipath(struct multipath *mpp, char *style)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char line[MAX_LINE_LEN];<br>
<br>
@@ -1776,8 +1765,7 @@ print_multipath (struct multipath * mpp, char * style=
)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;%s&quot;, line);<br>
=C2=A0}<br>
<br>
-extern void<br>
-print_pathgroup (struct pathgroup * pgp, char * style)<br>
+void print_pathgroup(struct pathgroup *pgp, char *style)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char line[MAX_LINE_LEN];<br>
<br>
@@ -1786,8 +1774,7 @@ print_pathgroup (struct pathgroup * pgp, char * style=
)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;%s&quot;, line);<br>
=C2=A0}<br>
<br>
-extern void<br>
-print_map (struct multipath * mpp, char * params)<br>
+void print_map(struct multipath *mpp, char *params)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mpp-&gt;size &amp;&amp; params)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf(&quot;0 %llu=
 %s %s\n&quot;,<br>
@@ -1795,14 +1782,12 @@ print_map (struct multipath * mpp, char * params)<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
=C2=A0}<br>
<br>
-extern void<br>
-print_all_paths (vector pathvec, int banner)<br>
+void print_all_paths(vector pathvec, int banner)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 print_all_paths_custo(pathvec, banner, PRINT_PA=
TH_LONG);<br>
=C2=A0}<br>
<br>
-extern void<br>
-print_all_paths_custo (vector pathvec, int banner, char *fmt)<br>
+void print_all_paths_custo(vector pathvec, int banner, char *fmt)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c<br>
index ec1fd92..aa7352f 100644<br>
--- a/libmultipath/propsel.c<br>
+++ b/libmultipath/propsel.c<br>
@@ -81,8 +81,7 @@ do_attr_set(var, mp-&gt;mpe, shift, &quot;(LUN setting)&q=
uot;)<br>
=C2=A0#define set_attr_conf(var, shift)=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0do_attr_set(var, conf, shift, &quot;(config file default)&quot;)<br>
<br>
-extern int<br>
-select_mode (struct config *conf, struct multipath *mp)<br>
+int select_mode(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -95,8 +94,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_uid (struct config *conf, struct multipath *mp)<br>
+int select_uid(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -109,8 +107,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_gid (struct config *conf, struct multipath *mp)<br>
+int select_gid(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -128,8 +125,7 @@ out:<br>
=C2=A0 * traverse the configuration layers from most specific to most gener=
ic<br>
=C2=A0 * stop at first explicit setting found<br>
=C2=A0 */<br>
-extern int<br>
-select_rr_weight (struct config *conf, struct multipath * mp)<br>
+int select_rr_weight(struct config *conf, struct multipath * mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[13];<br>
<br>
@@ -144,8 +140,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_pgfailback (struct config *conf, struct multipath * mp)<br>
+int select_pgfailback(struct config *conf, struct multipath * mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[13];<br>
<br>
@@ -160,8 +155,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_pgpolicy (struct config *conf, struct multipath * mp)<br>
+int select_pgpolicy(struct config *conf, struct multipath * mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[POLICY_NAME_SIZE];<br>
<br>
@@ -182,8 +176,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_selector (struct config *conf, struct multipath * mp)<br>
+int select_selector(struct config *conf, struct multipath * mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -236,8 +229,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return (user_friendly_names =3D=3D USER_FRIENDL=
Y_NAMES_ON);<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_alias (struct config *conf, struct multipath * mp)<br>
+int select_alias(struct config *conf, struct multipath * mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin =3D NULL;<br>
<br>
@@ -276,8 +268,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return mp-&gt;alias ? 0 : 1;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_features (struct config *conf, struct multipath * mp)<br>
+int select_features(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -302,8 +293,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_hwhandler (struct config *conf, struct multipath * mp)<br>
+int select_hwhandler(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -317,8 +307,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_checker(struct config *conf, struct path *pp)<br>
+int select_checker(struct config *conf, struct path *pp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, *checker_name;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct checker * c =3D &amp;pp-&gt;checker;<br>
@@ -346,8 +335,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_getuid (struct config *conf, struct path * pp)<br>
+int select_getuid(struct config *conf, struct path *pp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -400,8 +388,7 @@ do {=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 \<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>
=C2=A0} while(0)<br>
<br>
-extern int<br>
-select_prio (struct config *conf, struct path * pp)<br>
+int select_prio(struct config *conf, struct path *pp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct mpentry * mpe;<br>
@@ -438,8 +425,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_no_path_retry(struct config *conf, struct multipath *mp)<br>
+int select_no_path_retry(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char buff[12];<br>
@@ -497,8 +483,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_minio (struct config *conf, struct multipath * mp)<br>
+int select_minio(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int minv_dmrq[3] =3D {1, 1, 0};<br>
<br>
@@ -508,8 +493,7 @@ select_minio (struct config *conf, struct multipath * m=
p)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return select_minio=
_bio(conf, mp);<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_fast_io_fail(struct config *conf, struct multipath *mp)<br>
+int select_fast_io_fail(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
<br>
@@ -523,8 +507,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_dev_loss(struct config *conf, struct multipath *mp)<br>
+int select_dev_loss(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
<br>
@@ -539,8 +522,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_flush_on_last_del(<wbr>struct config *conf, struct multipath *mp)<b=
r>
+int select_flush_on_last_del(<wbr>struct config *conf, struct multipath *m=
p)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -557,8 +539,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_reservation_key (struct config *conf, struct multipath * mp)<br>
+int select_reservation_key(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
<br>
@@ -572,8 +553,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_retain_hwhandler (struct config *conf, struct multipath * mp)<br>
+int select_retain_hwhandler(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int minv_dm_retain[3] =3D {1, 5, 0};<b=
r>
@@ -594,8 +574,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_detect_prio (struct config *conf, struct path * pp)<br>
+int select_detect_prio(struct config *conf, struct path *pp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -609,8 +588,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_deferred_remove (struct config *conf, struct multipath *mp)<br>
+int select_deferred_remove(struct config *conf, struct multipath *mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
@@ -635,8 +613,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_delay_watch_checks(<wbr>struct config *conf, struct multipath *mp)<=
br>
+int select_delay_watch_checks(<wbr>struct config *conf, struct multipath *=
mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
<br>
@@ -651,8 +628,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_delay_wait_checks(<wbr>struct config *conf, struct multipath *mp)<b=
r>
+int select_delay_wait_checks(<wbr>struct config *conf, struct multipath *m=
p)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin, buff[12];<br>
<br>
@@ -668,8 +644,7 @@ out:<br>
<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_skip_kpartx (struct config *conf, struct multipath * mp)<br>
+int select_skip_kpartx (struct config *conf, struct multipath * mp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *origin;<br>
<br>
diff --git a/libmultipath/structs.c b/libmultipath/structs.c<br>
index e4bf4c6..ba9edf9 100644<br>
--- a/libmultipath/structs.c<br>
+++ b/libmultipath/structs.c<br>
@@ -201,8 +201,7 @@ alloc_multipath (void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return mpp;<br>
=C2=A0}<br>
<br>
-extern void<br>
-free_multipath_attributes (struct multipath * mpp)<br>
+void free_multipath_attributes(<wbr>struct multipath *mpp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;<br>
@@ -439,8 +438,7 @@ find_path_by_devt (vector pathvec, char * dev_t)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
=C2=A0}<br>
<br>
-extern int<br>
-pathcountgr (struct pathgroup * pgp, int state)<br>
+int pathcountgr(struct pathgroup *pgp, int state)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path *pp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int count =3D 0;<br>
@@ -453,8 +451,7 @@ pathcountgr (struct pathgroup * pgp, int state)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return count;<br>
=C2=A0}<br>
<br>
-extern int<br>
-pathcount (struct multipath * mpp, int state)<br>
+int pathcount(struct multipath *mpp, int state)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pathgroup *pgp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int count =3D 0;<br>
@@ -467,8 +464,7 @@ pathcount (struct multipath * mpp, int state)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return count;<br>
=C2=A0}<br>
<br>
-extern int<br>
-pathcmp (struct pathgroup *pgp, struct pathgroup *cpgp)<br>
+int pathcmp(struct pathgroup *pgp, struct pathgroup *cpgp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, j;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path *pp, *cpp;<br>
@@ -498,8 +494,7 @@ first_path (struct multipath * mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return pgp?VECTOR_SLOT(pgp-&gt;paths, 0):NULL;<=
br>
=C2=A0}<br>
<br>
-extern void<br>
-setup_feature(struct multipath * mpp, char *feature)<br>
+void setup_feature(struct multipath *mpp, char *feature)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!strncmp(feature, &quot;queue_if_no_path&qu=
ot;, 16)) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mpp-&gt;no_path=
_retry &lt;=3D NO_PATH_RETRY_UNDEF)<br>
@@ -507,8 +502,7 @@ setup_feature(struct multipath * mpp, char *feature)<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
-extern int<br>
-add_feature (char **f, char *n)<br>
+int add_feature(char **f, char *n)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int c =3D 0, d, l;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *e, *p, *t;<br>
@@ -592,8 +586,7 @@ add_feature (char **f, char *n)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-remove_feature(char **f, char *o)<br>
+int remove_feature(char **f, char *o)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int c =3D 0, d, l;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *e, *p, *n;<br>
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c<br>
index e898528..22be8e0 100644<br>
--- a/libmultipath/structs_vec.c<br>
+++ b/libmultipath/structs_vec.c<br>
@@ -20,8 +20,7 @@<br>
=C2=A0/*<br>
=C2=A0 * creates or updates mpp-&gt;paths reading mpp-&gt;pg<br>
=C2=A0 */<br>
-extern int<br>
-update_mpp_paths(struct multipath * mpp, vector pathvec)<br>
+int update_mpp_paths(struct multipath *mpp, vector pathvec)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct pathgroup * pgp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
@@ -45,8 +44,7 @@ update_mpp_paths(struct multipath * mpp, vector pathvec)<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-adopt_paths (vector pathvec, struct multipath * mpp)<br>
+int adopt_paths(vector pathvec, struct multipath *mpp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, ret;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
@@ -81,8 +79,7 @@ adopt_paths (vector pathvec, struct multipath * mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern void<br>
-orphan_path (struct path * pp, const char *reason)<br>
+void orphan_path(struct path *pp, const char *reason)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 condlog(3, &quot;%s: orphan path, %s&quot;, pp-=
&gt;dev, reason);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;mpp =3D NULL;<br>
@@ -96,8 +93,7 @@ orphan_path (struct path * pp, const char *reason)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;fd =3D -1;<br>
=C2=A0}<br>
<br>
-extern void<br>
-orphan_paths (vector pathvec, struct multipath * mpp)<br>
+void orphan_paths(vector pathvec, struct multipath *mpp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
@@ -151,15 +147,13 @@ _remove_map (struct multipath * mpp, struct vectors *=
 vecs,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 free_multipath(mpp, KEEP_PATHS);<br>
=C2=A0}<br>
<br>
-extern void<br>
-remove_map (struct multipath * mpp, struct vectors * vecs, int purge_vec)<=
br>
+void remove_map(struct multipath *mpp, struct vectors *vecs, int purge_vec=
)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 _remove_map(mpp, vecs, KEEP_WAITER, purge_vec);=
<br>
=C2=A0}<br>
<br>
-extern void<br>
-remove_map_and_stop_waiter (struct multipath * mpp, struct vectors * vecs,=
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0int purge_vec)<br>
+void remove_map_and_stop_waiter(<wbr>struct multipath *mpp, struct vectors=
 *vecs,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int purge_vec)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 _remove_map(mpp, vecs, STOP_WAITER, purge_vec);=
<br>
=C2=A0}<br>
@@ -182,14 +176,12 @@ _remove_maps (struct vectors * vecs, int stop_waiter)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 vecs-&gt;mpvec =3D NULL;<br>
=C2=A0}<br>
<br>
-extern void<br>
-remove_maps (struct vectors * vecs)<br>
+void remove_maps(struct vectors *vecs)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 _remove_maps(vecs, KEEP_WAITER);<br>
=C2=A0}<br>
<br>
-extern void<br>
-remove_maps_and_stop_waiters (struct vectors * vecs)<br>
+void remove_maps_and_stop_waiters(<wbr>struct vectors *vecs)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 _remove_maps(vecs, STOP_WAITER);<br>
=C2=A0}<br>
@@ -320,8 +312,8 @@ void sync_paths(struct multipath *mpp, vector pathvec)<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pp-&gt;mpp =3D mpp;=
<br>
=C2=A0}<br>
<br>
-extern int<br>
-update_multipath_strings (struct multipath *mpp, vector pathvec, int is_da=
emon)<br>
+int<br>
+update_multipath_strings(<wbr>struct multipath *mpp, vector pathvec, int i=
s_daemon)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
@@ -343,8 +335,7 @@ update_multipath_strings (struct multipath *mpp, vector=
 pathvec, int is_daemon)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0}<br>
<br>
-extern void<br>
-set_no_path_retry(struct config *conf, struct multipath *mpp)<br>
+void set_no_path_retry(struct config *conf, struct multipath *mpp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp-&gt;retry_tick =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 mpp-&gt;nr_active =3D pathcount(mpp, PATH_UP) +=
 pathcount(mpp, PATH_GHOST);<br>
@@ -373,9 +364,8 @@ set_no_path_retry(struct config *conf, struct multipath=
 *mpp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
-extern int<br>
-__setup_multipath (struct vectors * vecs, struct multipath * mpp,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int reset, =
int is_daemon)<br>
+int __setup_multipath(struct vectors *vecs, struct multipath *mpp,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0int reset, int is_daemon)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct config *conf;<br>
<br>
@@ -425,8 +415,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0}<br>
<br>
-extern struct multipath *<br>
-add_map_without_path (struct vectors * vecs, char * alias)<br>
+struct multipath *add_map_without_path (struct vectors *vecs, char *alias)=
<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct multipath * mpp =3D alloc_multipath();<b=
r>
<br>
@@ -473,9 +462,8 @@ find_existing_alias (struct multipath * mpp,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0}<br>
<br>
-extern struct multipath *<br>
-add_map_with_path (struct vectors * vecs,<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path=
 * pp, int add_vec)<br>
+struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,=
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int add_vec)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct multipath * mpp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct config *conf =3D NULL;<br>
@@ -514,8 +502,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;<br>
=C2=A0}<br>
<br>
-extern int<br>
-verify_paths(struct multipath * mpp, struct vectors * vecs)<br>
+int verify_paths(struct multipath *mpp, struct vectors *vecs)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct path * pp;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int count =3D 0;<br>
diff --git a/libmultipath/switchgroup.c b/libmultipath/switchgroup.c<br>
index 031c3d7..9632ce2 100644<br>
--- a/libmultipath/switchgroup.c<br>
+++ b/libmultipath/switchgroup.c<br>
@@ -7,8 +7,7 @@<br>
=C2=A0#include &quot;structs.h&quot;<br>
=C2=A0#include &quot;switchgroup.h&quot;<br>
<br>
-extern void<br>
-path_group_prio_update (struct pathgroup * pgp)<br>
+void path_group_prio_update(struct pathgroup *pgp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int priority =3D 0;<br>
@@ -32,8 +31,7 @@ path_group_prio_update (struct pathgroup * pgp)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pgp-&gt;priority =
=3D 0;<br>
=C2=A0}<br>
<br>
-extern int<br>
-select_path_group (struct multipath * mpp)<br>
+int select_path_group(struct multipath *mpp)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int max_priority =3D 0;<br>
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c<br>
index 19b910f..7edcce1 100644<br>
--- a/libmultipath/uevent.c<br>
+++ b/libmultipath/uevent.c<br>
@@ -559,8 +559,7 @@ out:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return err;<br>
=C2=A0}<br>
<br>
-extern int<br>
-uevent_get_major(struct uevent *uev)<br>
+int uevent_get_major(struct uevent *uev)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *p, *q;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, major =3D -1;<br>
@@ -579,8 +578,7 @@ uevent_get_major(struct uevent *uev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return major;<br>
=C2=A0}<br>
<br>
-extern int<br>
-uevent_get_minor(struct uevent *uev)<br>
+int uevent_get_minor(struct uevent *uev)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *p, *q;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, minor =3D -1;<br>
@@ -599,8 +597,7 @@ uevent_get_minor(struct uevent *uev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return minor;<br>
=C2=A0}<br>
<br>
-extern int<br>
-uevent_get_disk_ro(struct uevent *uev)<br>
+int uevent_get_disk_ro(struct uevent *uev)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *p, *q;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i, ro =3D -1;<br>
@@ -619,8 +616,7 @@ uevent_get_disk_ro(struct uevent *uev)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return ro;<br>
=C2=A0}<br>
<br>
-extern char *<br>
-uevent_get_dm_name(struct uevent *uev)<br>
+char *uevent_get_dm_name(struct uevent *uev)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *p =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int i;<br>
diff --git a/libmultipath/util.c b/libmultipath/util.c<br>
index 0a136b4..03a5738 100644<br>
--- a/libmultipath/util.c<br>
+++ b/libmultipath/util.c<br>
@@ -145,8 +145,7 @@ size_t strlcat(char *dst, const char *src, size_t size)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return bytes;<br>
=C2=A0}<br>
<br>
-extern int<br>
-devt2devname (char *devname, int devname_len, char *devt)<br>
+int devt2devname(char *devname, int devname_len, char *devt)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 FILE *fd;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int tmpmaj, tmpmin, major, minor;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.10.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142a8de39eba40541bb9e09--


--===============6298950291831947140==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6298950291831947140==--
