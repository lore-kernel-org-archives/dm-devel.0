From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 3/6] multipath: centralize validation code
Date: Fri, 15 May 2020 20:37:16 +0000
Message-ID: <58562235f673975a254f3ee41e4548900158022b.camel@suse.com>
References: <1589507962-6895-1-git-send-email-bmarzins@redhat.com>
	<1589507962-6895-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1589507962-6895-4-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <62CAF7689F88B849AF2318B0D7131D99@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-05-14 at 20:59 -0500, Benjamin Marzinski wrote:
> This code pulls the multipath path validation code out of
> configure(),
> and puts it into its own function, check_path_valid(). This function
> calls a new libmultipath function, is_path_valid() to check just path
> requested. This seperation exists so that is_path_valid() can be
> reused
> by future code. This code will give almost the same answer as the
> existing code, with the exception that now, if a device is currently
> multipathed, it will always be a valid multipath path.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Great job getting the logic right! Readability massively improved.
Almost ack, a few comments and questions below.

Regards,
Martin


> ---
>  libmultipath/Makefile    |   2 +-
>  libmultipath/devmapper.c |  49 +++++++
>  libmultipath/devmapper.h |   1 +
>  libmultipath/structs.h   |  24 +---
>  libmultipath/valid.c     | 118 ++++++++++++++++
>  libmultipath/valid.h     |  32 +++++
>  libmultipath/wwids.c     |  10 +-
>  multipath/main.c         | 296 +++++++++++++++++------------------
> ----
>  8 files changed, 337 insertions(+), 195 deletions(-)
>  create mode 100644 libmultipath/valid.c
>  create mode 100644 libmultipath/valid.h
>=20
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index f19b7ad2..e5dac5ea 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -48,7 +48,7 @@ OBJS =3D memory.o parser.o vector.o devmapper.o
> callout.o \
>  =09log.o configure.o structs_vec.o sysfs.o prio.o checkers.o \
>  =09lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
>  =09io_err_stat.o dm-generic.o generic.o foreign.o nvme-lib.o \
> -=09libsg.o
> +=09libsg.o valid.o
> =20
>  all: $(LIBS)
> =20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 7ed494a1..92f61133 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -770,6 +770,55 @@ out:
>  =09return r;
>  }
> =20
> +/*
> + * Return
> + *   1 : map with uuid exists
> + *   0 : map with uuid doesn't exist
> + *  -1 : error
> + */
> +int
> +dm_map_present_by_uuid(const char *uuid)
> +{
> +=09struct dm_task *dmt;
> +=09struct dm_info info;
> +=09char prefixed_uuid[WWID_SIZE + UUID_PREFIX_LEN];
> +=09int r =3D -1;
> +
> +=09if (!uuid || uuid[0] =3D=3D '\0')
> +=09=09return 0;
> +
> +=09if (safe_sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid))
> +=09=09goto out;
> +
> +=09if (!(dmt =3D dm_task_create(DM_DEVICE_INFO)))
> +=09=09goto out;
> +
> +=09dm_task_no_open_count(dmt);
> +
> +=09if (!dm_task_set_uuid(dmt, prefixed_uuid))
> +=09=09goto out_task;
> +
> +=09if (!dm_task_run(dmt))
> +=09=09goto out_task;
> +
> +=09if (!dm_task_get_info(dmt, &info))
> +=09=09goto out_task;
> +
> +=09r =3D 0;
> +
> +=09if (!info.exists)
> +=09=09goto out_task;
> +
> +=09r =3D 1;

I have nothing against goto for error handling, but here I'd prefer=20

        r =3D !!info.exists;

> +out_task:
> +=09dm_task_destroy(dmt);
> +out:
> +=09if (r < 0)
> +=09=09condlog(3, "%s: dm command failed in %s: %s", uuid,
> +=09=09=09__FUNCTION__, strerror(errno));
> +=09return r;
> +}
> +
>  static int
>  dm_dev_t (const char * mapname, char * dev_t, int len)
>  {
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 17fc9faf..5ed7edc5 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -39,6 +39,7 @@ int dm_simplecmd_noflush (int, const char *,
> uint16_t);
>  int dm_addmap_create (struct multipath *mpp, char *params);
>  int dm_addmap_reload (struct multipath *mpp, char *params, int
> flush);
>  int dm_map_present (const char *);
> +int dm_map_present_by_uuid(const char *uuid);
>  int dm_get_map(const char *, unsigned long long *, char *);
>  int dm_get_status(const char *, char *);
>  int dm_type(const char *, char *);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 9bd39eb1..d69bc2e9 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -101,29 +101,13 @@ enum yes_no_undef_states {
>  =09YNU_YES,
>  };
> =20
> -#define _FIND_MULTIPATHS_F (1 << 1)
> -#define _FIND_MULTIPATHS_I (1 << 2)
> -#define _FIND_MULTIPATHS_N (1 << 3)
> -/*
> - * _FIND_MULTIPATHS_F must have the same value as YNU_YES.
> - * Generate a compile time error if that isn't the case.
> - */
> -extern char ___error1___[-(_FIND_MULTIPATHS_F !=3D YNU_YES)];
> -
> -#define find_multipaths_on(conf) \
> -=09(!!((conf)->find_multipaths & _FIND_MULTIPATHS_F))
> -#define ignore_wwids_on(conf) \
> -=09(!!((conf)->find_multipaths & _FIND_MULTIPATHS_I))
> -#define ignore_new_devs_on(conf) \
> -=09(!!((conf)->find_multipaths & _FIND_MULTIPATHS_N))
> -
>  enum find_multipaths_states {
>  =09FIND_MULTIPATHS_UNDEF =3D YNU_UNDEF,
>  =09FIND_MULTIPATHS_OFF =3D YNU_NO,
> -=09FIND_MULTIPATHS_ON =3D _FIND_MULTIPATHS_F,
> -=09FIND_MULTIPATHS_GREEDY =3D _FIND_MULTIPATHS_I,
> -=09FIND_MULTIPATHS_SMART =3D _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_I,
> -=09FIND_MULTIPATHS_STRICT =3D _FIND_MULTIPATHS_F|_FIND_MULTIPATHS_N,
> +=09FIND_MULTIPATHS_ON =3D YNU_YES,
> +=09FIND_MULTIPATHS_GREEDY,
> +=09FIND_MULTIPATHS_SMART,
> +=09FIND_MULTIPATHS_STRICT,
>  =09__FIND_MULTIPATHS_LAST,
>  };
> =20

What was the reason you changed these definitions? AFAICS you've got
the logic right, and I'm not saying it shouldn't be done, but I'd like
to see a rationale. Is it just simplification / readability?

(Note to self: _FIND_MULTIPATHS_F etc. were introduced to make it
obvious at the time that these flags had the same effect as the
previous "ignore_wwids", "ignore_new_devs", and "find_multipaths"
command line options).


> diff --git a/libmultipath/valid.c b/libmultipath/valid.c
> new file mode 100644
> index 00000000..456b1f6e
> --- /dev/null
> +++ b/libmultipath/valid.c
> @@ -0,0 +1,118 @@
> +/*
> +  Copyright (c) 2020 Benjamin Marzinski, IBM
> +
> +  This program is free software; you can redistribute it and/or
> +  modify it under the terms of the GNU General Public License
> +  as published by the Free Software Foundation; either version 2
> +  of the License, or (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful,
> +  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +  GNU General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program.  If not, see <
> https://www.gnu.org/licenses/>;.
> + */
> +#include <stddef.h>
> +#include <errno.h>
> +#include <libudev.h>
> +
> +#include "vector.h"
> +#include "config.h"
> +#include "debug.h"
> +#include "util.h"
> +#include "devmapper.h"
> +#include "discovery.h"
> +#include "wwids.h"
> +#include "sysfs.h"
> +#include "blacklist.h"
> +#include "mpath_cmd.h"
> +#include "valid.h"
> +
> +int
> +is_path_valid(const char *name, struct config *conf, struct path
> *pp,
> +=09      bool check_multipathd)
> +{
> +=09int r;
> +=09int fd;
> +
> +=09if (!pp || !name || !conf)
> +=09=09return PATH_IS_ERROR;
> +
> +=09if (conf->find_multipaths <=3D FIND_MULTIPATHS_UNDEF ||
> +=09    conf->find_multipaths >=3D __FIND_MULTIPATHS_LAST)
> +=09=09return PATH_IS_ERROR;
> +
> +=09if (safe_sprintf(pp->dev, "%s", name))
> +=09=09return PATH_IS_ERROR;
> +
> +=09if (sysfs_is_multipathed(pp, true)) {
> +=09=09if (pp->wwid[0] =3D=3D '\0')
> +=09=09=09return PATH_IS_ERROR;
> +=09=09return PATH_IS_VALID_NO_CHECK;
> +=09}
> +
> +=09/*
> +=09 * "multipath -u" may be run before the daemon is started. In
> this
> +=09 * case, systemd might own the socket but might delay
> multipathd
> +=09 * startup until some other unit (udev settle!)  has finished
> +=09 * starting. With many LUNs, the listen backlog may be
> exceeded, which
> +=09 * would cause connect() to block. This causes udev workers
> calling
> +=09 * "multipath -u" to hang, and thus creates a deadlock, until
> "udev
> +=09 * settle" times out.  To avoid this, call connect() in non-
> blocking
> +=09 * mode here, and take EAGAIN as indication for a filled-up
> systemd
> +=09 * backlog.
> +=09 */
> +
> +=09if (check_multipathd) {
> +=09=09fd =3D __mpath_connect(1);
> +=09=09if (fd < 0) {
> +=09=09=09if (errno !=3D EAGAIN &&
> !systemd_service_enabled(name)) {
> +=09=09=09=09condlog(3, "multipathd not running or
> enabled");
> +=09=09=09=09return PATH_IS_NOT_VALID;
> +=09=09=09}
> +=09=09} else
> +=09=09=09mpath_disconnect(fd);
> +=09}
> +
> +=09pp->udev =3D udev_device_new_from_subsystem_sysname(udev,
> "block", name);
> +=09if (!pp->udev)
> +=09=09return PATH_IS_ERROR;
> +
> +=09r =3D pathinfo(pp, conf, DI_SYSFS | DI_WWID | DI_BLACKLIST);
> +=09if (r =3D=3D PATHINFO_SKIPPED)
> +=09=09return PATH_IS_NOT_VALID;
> +=09else if (r)
> +=09=09return PATH_IS_ERROR;
> +
> +=09if (pp->wwid[0] =3D=3D '\0')
> +=09=09return PATH_IS_NOT_VALID;
> +
> +=09if (pp->udev && pp->uid_attribute &&
> +=09    filter_property(conf, pp->udev, 3, pp->uid_attribute) > 0)
> +=09=09return PATH_IS_NOT_VALID;
> +
> +=09r =3D is_failed_wwid(pp->wwid);
> +=09if (r !=3D WWID_IS_NOT_FAILED) {
> +=09=09if (r =3D=3D WWID_IS_FAILED)
> +=09=09=09return PATH_IS_NOT_VALID;
> +=09=09return PATH_IS_ERROR;
> +=09}
> +
> +=09if (conf->find_multipaths =3D=3D FIND_MULTIPATHS_GREEDY)
> +=09=09return PATH_IS_VALID;
> +
> +=09if (check_wwids_file(pp->wwid, 0) =3D=3D 0)
> +=09=09return PATH_IS_VALID_NO_CHECK;
> +
> +=09if (dm_map_present_by_uuid(pp->wwid) =3D=3D 1)
> +=09=09return PATH_IS_VALID;
> +
> +=09/* all these act like FIND_MULTIPATHS_STRICT for finding if a
> +=09 * path is valid */
> +=09if (conf->find_multipaths !=3D FIND_MULTIPATHS_SMART)
> +=09=09return PATH_IS_NOT_VALID;
> +
> +=09return PATH_IS_MAYBE_VALID;
> +}
> diff --git a/libmultipath/valid.h b/libmultipath/valid.h
> new file mode 100644
> index 00000000..778658ad
> --- /dev/null
> +++ b/libmultipath/valid.h
> @@ -0,0 +1,32 @@
> +/*
> +  Copyright (c) 2020 Benjamin Marzinski, IBM
> +
> +  This program is free software; you can redistribute it and/or
> +  modify it under the terms of the GNU General Public License
> +  as published by the Free Software Foundation; either version 2
> +  of the License, or (at your option) any later version.
> +
> +  This program is distributed in the hope that it will be useful,
> +  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +  GNU General Public License for more details.
> +
> +  You should have received a copy of the GNU General Public License
> +  along with this program.  If not, see <
> https://www.gnu.org/licenses/>;.
> + */
> +#ifndef _VALID_H
> +#define _VALID_H
> +
> +enum is_path_valid_result {
> +=09PATH_IS_ERROR =3D -1,
> +=09PATH_IS_NOT_VALID,
> +=09PATH_IS_VALID,
> +=09PATH_IS_VALID_NO_CHECK,

I'd like to see the comment explaining the difference between VALID
and VALID_NO_CHECK here, too.

> +=09PATH_IS_MAYBE_VALID,
> +=09PATH_MAX_VALID_RESULT, /* only for bounds checking */
> +};
> +
> +int is_path_valid(const char *name, struct config *conf, struct path
> *pp,
> +=09=09  bool check_multipathd);
> +
> +#endif /* _VALID_D */
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index 28a2150d..637cb0ab 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c
> @@ -289,19 +289,19 @@ out:
>  int
>  should_multipath(struct path *pp1, vector pathvec, vector mpvec)
>  {
> -=09int i, ignore_new_devs, find_multipaths;
> +=09int i, find_multipaths;
>  =09struct path *pp2;
>  =09struct config *conf;
> =20
>  =09conf =3D get_multipath_config();
> -=09ignore_new_devs =3D ignore_new_devs_on(conf);
> -=09find_multipaths =3D find_multipaths_on(conf);
> +=09find_multipaths =3D conf->find_multipaths;
>  =09put_multipath_config(conf);
> -=09if (!find_multipaths && !ignore_new_devs)
> +=09if (find_multipaths =3D=3D FIND_MULTIPATHS_OFF ||
> +=09    find_multipaths =3D=3D FIND_MULTIPATHS_GREEDY)
>  =09=09return 1;
> =20
>  =09condlog(4, "checking if %s should be multipathed", pp1->dev);
> -=09if (!ignore_new_devs) {
> +=09if (find_multipaths !=3D FIND_MULTIPATHS_STRICT) {
>  =09=09char tmp_wwid[WWID_SIZE];
>  =09=09struct multipath *mp =3D find_mp_by_wwid(mpvec, pp1-
> >wwid);

Noting explicitly here: you got the complex logic right. Kudos :-)

> =20
> diff --git a/multipath/main.c b/multipath/main.c
> index 545ead87..953fab27 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -63,21 +63,18 @@
>  #include "propsel.h"
>  #include "time-util.h"
>  #include "file.h"
> +#include "valid.h"
> =20
>  int logsink;
>  struct udev *udev;
>  struct config *multipath_conf;
> =20
>  /*
> - * Return values of configure(), print_cmd_valid(), and main().
> - * RTVL_{YES,NO} are synonyms for RTVL_{OK,FAIL} for the
> CMD_VALID_PATH case.
> + * Return values of configure(), check_path_valid(), and main().
>   */
>  enum {
>  =09RTVL_OK =3D 0,
> -=09RTVL_YES =3D RTVL_OK,
>  =09RTVL_FAIL =3D 1,
> -=09RTVL_NO =3D RTVL_FAIL,
> -=09RTVL_MAYBE, /* only used internally, never returned */
>  =09RTVL_RETRY, /* returned by configure(), not by main() */
>  };
> =20
> @@ -269,9 +266,6 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp,
> vector pathvec, char * refwwid)
>  =09=09=09continue;
>  =09=09}
> =20
> -=09=09if (cmd =3D=3D CMD_VALID_PATH)
> -=09=09=09continue;
> -
>  =09=09dm_get_map(mpp->alias, &mpp->size, params);
>  =09=09condlog(3, "params =3D %s", params);
>  =09=09dm_get_status(mpp->alias, status);
> @@ -491,10 +485,11 @@ static int print_cmd_valid(int k, const vector
> pathvec,
>  =09struct timespec until;
>  =09struct path *pp;
> =20
> -=09if (k !=3D RTVL_YES && k !=3D RTVL_NO && k !=3D RTVL_MAYBE)
> -=09=09return RTVL_NO;
> +=09if (k !=3D PATH_IS_VALID && k !=3D PATH_IS_NOT_VALID &&
> +=09    k !=3D PATH_IS_MAYBE_VALID)
> +=09=09return PATH_IS_NOT_VALID;
> =20
> -=09if (k =3D=3D RTVL_MAYBE) {
> +=09if (k =3D=3D PATH_IS_MAYBE_VALID) {
>  =09=09/*
>  =09=09 * Caller ensures that pathvec[0] is the path to
>  =09=09 * examine.
> @@ -504,7 +499,7 @@ static int print_cmd_valid(int k, const vector
> pathvec,
>  =09=09wait =3D find_multipaths_check_timeout(
>  =09=09=09pp, pp->find_multipaths_timeout, &until);
>  =09=09if (wait !=3D FIND_MULTIPATHS_WAITING)
> -=09=09=09k =3D RTVL_NO;
> +=09=09=09k =3D PATH_IS_NOT_VALID;
>  =09} else if (pathvec !=3D NULL && (pp =3D VECTOR_SLOT(pathvec, 0)))
>  =09=09wait =3D find_multipaths_check_timeout(pp, 0, &until);
>  =09if (wait =3D=3D FIND_MULTIPATHS_WAITING)
> @@ -513,9 +508,9 @@ static int print_cmd_valid(int k, const vector
> pathvec,
>  =09else if (wait =3D=3D FIND_MULTIPATHS_WAIT_DONE)
>  =09=09printf("FIND_MULTIPATHS_WAIT_UNTIL=3D\"0\"\n");
>  =09printf("DM_MULTIPATH_DEVICE_PATH=3D\"%d\"\n",
> -=09       k =3D=3D RTVL_MAYBE ? 2 : k =3D=3D RTVL_YES ? 1 : 0);
> +=09       k =3D=3D PATH_IS_MAYBE_VALID ? 2 : k =3D=3D PATH_IS_VALID ? 1 =
:
> 0);
>  =09/* Never return RTVL_MAYBE */
> -=09return k =3D=3D RTVL_NO ? RTVL_NO : RTVL_YES;
> +=09return k =3D=3D PATH_IS_NOT_VALID ? PATH_IS_NOT_VALID :
> PATH_IS_VALID;
>  }
> =20
>  /*
> @@ -548,7 +543,6 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
>  =09int di_flag =3D 0;
>  =09char * refwwid =3D NULL;
>  =09char * dev =3D NULL;
> -=09bool released =3D released_to_systemd();
> =20
>  =09/*
>  =09 * allocate core vectors to store paths and multipaths
> @@ -573,7 +567,7 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
>  =09    cmd !=3D CMD_REMOVE_WWID &&
>  =09    (filter_devnode(conf->blist_devnode,
>  =09=09=09    conf->elist_devnode, dev) > 0)) {
> -=09=09goto print_valid;
> +=09=09goto out;
>  =09}
> =20
>  =09/*
> @@ -581,14 +575,10 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
>  =09 * failing the translation is fatal (by policy)
>  =09 */
>  =09if (devpath) {
> -=09=09int failed =3D get_refwwid(cmd, devpath, dev_type,
> -=09=09=09=09=09 pathvec, &refwwid);
> +=09=09get_refwwid(cmd, devpath, dev_type, pathvec, &refwwid);
>  =09=09if (!refwwid) {
>  =09=09=09condlog(4, "%s: failed to get wwid", devpath);
> -=09=09=09if (failed =3D=3D 2 && cmd =3D=3D CMD_VALID_PATH)
> -=09=09=09=09goto print_valid;
> -=09=09=09else
> -=09=09=09=09condlog(3, "scope is null");
> +=09=09=09condlog(3, "scope is null");
>  =09=09=09goto out;
>  =09=09}
>  =09=09if (cmd =3D=3D CMD_REMOVE_WWID) {
> @@ -614,53 +604,6 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
>  =09=09=09goto out;
>  =09=09}
>  =09=09condlog(3, "scope limited to %s", refwwid);
> -=09=09/* If you are ignoring the wwids file and
> find_multipaths is
> -=09=09 * set, you need to actually check if there are two
> available
> -=09=09 * paths to determine if this path should be
> multipathed. To
> -=09=09 * do this, we put off the check until after
> discovering all
> -=09=09 * the paths.
> -=09=09 * Paths listed in the wwids file are always considered
> valid.
> -=09=09 */
> -=09=09if (cmd =3D=3D CMD_VALID_PATH) {
> -=09=09=09if (is_failed_wwid(refwwid) =3D=3D WWID_IS_FAILED)
> {
> -=09=09=09=09r =3D RTVL_NO;
> -=09=09=09=09goto print_valid;
> -=09=09=09}
> -=09=09=09if ((!find_multipaths_on(conf) &&
> -=09=09=09=09    ignore_wwids_on(conf)) ||
> -=09=09=09=09   check_wwids_file(refwwid, 0) =3D=3D 0)
> -=09=09=09=09r =3D RTVL_YES;
> -=09=09=09if (!ignore_wwids_on(conf))
> -=09=09=09=09goto print_valid;PATH_IS_VALID_NO_CHECK
>=20
> -=09=09=09/* At this point, either r=3D=3D0 or
> find_multipaths_on. */
> -
> -=09=09=09/*
> -=09=09=09 * Shortcut for find_multipaths smart:
> -=09=09=09 * Quick check if path is already multipathed.
> -=09=09=09 */
> -=09=09=09if (sysfs_is_multipathed(VECTOR_SLOT(pathvec,
> 0),
> -=09=09=09=09=09=09 false)) {
> -=09=09=09=09r =3D RTVL_YES;
> -=09=09=09=09goto print_valid;
> -=09=09=09}
> -
> -=09=09=09/*
> -=09=09=09 * DM_MULTIPATH_DEVICE_PATH=3D=3D"0" means that we
> have
> -=09=09=09 * been called for this device already, and
> have
> -=09=09=09 * released it to systemd. Unless the device is
> now
> -=09=09=09 * already multipathed (see above), we can't
> try to
> -=09=09=09 * grab it, because setting SYSTEMD_READY=3D0
> would
> -=09=09=09 * cause file systems to be unmounted.
> -=09=09=09 * Leave DM_MULTIPATH_DEVICE_PATH=3D"0".
> -=09=09=09 */
> -=09=09=09if (released) {
> -=09=09=09=09r =3D RTVL_NO;
> -=09=09=09=09goto print_valid;
> -=09=09=09}
> -=09=09=09if (r =3D=3D RTVL_YES)
> -=09=09=09=09goto print_valid;
> -=09=09=09/* find_multipaths_on: Fall through to path
> detection */
> -=09=09}
>  =09}
> =20
>  =09/*
> @@ -701,59 +644,6 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
>  =09=09goto out;
>  =09}
> =20
> -=09if (cmd =3D=3D CMD_VALID_PATH) {
> -=09=09struct path *pp;
> -=09=09int fd;
> -
> -=09=09/* This only happens if find_multipaths and
> -=09=09 * ignore_wwids is set, and the path is not in WWIDs
> -=09=09 * file, not currently multipathed, and has
> -=09=09 * never been released to systemd.
> -=09=09 * If there is currently a multipath device matching
> -=09=09 * the refwwid, or there is more than one path matching
> -=09=09 * the refwwid, then the path is valid */
> -=09=09if (VECTOR_SIZE(curmp) !=3D 0) {
> -=09=09=09r =3D RTVL_YES;
> -=09=09=09goto print_valid;
> -=09=09} else if (VECTOR_SIZE(pathvec) > 1)
> -=09=09=09r =3D RTVL_YES;
> -=09=09else
> -=09=09=09r =3D RTVL_MAYBE;
> -
> -=09=09/*
> -=09=09 * If opening the path with O_EXCL fails, the path
> -=09=09 * is in use (e.g. mounted during initramfs
> processing).
> -=09=09 * We know that it's not used by dm-multipath.
> -=09=09 * We may not set SYSTEMD_READY=3D0 on such devices, it
> -=09=09 * might cause systemd to umount the device.
> -=09=09 * Use O_RDONLY, because udevd would trigger another
> -=09=09 * uevent for close-after-write.
> -=09=09 *
> -=09=09 * The O_EXCL check is potentially dangerous, because
> it may
> -=09=09 * race with other tasks trying to access the device.
> Therefore
> -=09=09 * this code is only executed if the path hasn't been
> released
> -=09=09 * to systemd earlier (see above).
> -=09=09 *
> -=09=09 * get_refwwid() above stores the path we examine in
> slot 0.
> -=09=09 */
> -=09=09pp =3D VECTOR_SLOT(pathvec, 0);
> -=09=09fd =3D open(udev_device_get_devnode(pp->udev),
> -=09=09=09  O_RDONLY|O_EXCL);
> -=09=09if (fd >=3D 0)
> -=09=09=09close(fd);
> -=09=09else {
> -=09=09=09condlog(3, "%s: path %s is in use: %s",
> -=09=09=09=09__func__, pp->dev,
> -=09=09=09=09strerror(errno));
> -=09=09=09/*
> -=09=09=09 * Check if we raced with multipathd
> -=09=09=09 */
> -=09=09=09r =3D sysfs_is_multipathed(VECTOR_SLOT(pathvec,
> 0),
> -=09=09=09=09=09=09 false) ? RTVL_YES :
> RTVL_NO;
> -=09=09}
> -=09=09goto print_valid;
> -=09}
> -
>  =09if (cmd !=3D CMD_CREATE && cmd !=3D CMD_DRY_RUN) {
>  =09=09r =3D RTVL_OK;
>  =09=09goto out;
> @@ -766,10 +656,6 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
>  =09=09=09   conf->force_reload, cmd);
>  =09r =3D rc =3D=3D CP_RETRY ? RTVL_RETRY : rc =3D=3D CP_OK ? RTVL_OK :
> RTVL_FAIL;
> =20
> -print_valid:
> -=09if (cmd =3D=3D CMD_VALID_PATH)
> -=09=09r =3D print_cmd_valid(r, pathvec, conf);
> -
>  out:
>  =09if (refwwid)
>  =09=09FREE(refwwid);
> @@ -780,6 +666,112 @@ out:
>  =09return r;
>  }
> =20
> +static int
> +check_path_valid(const char *name, struct config *conf, bool
> is_uevent)
> +{
> +=09int fd, r =3D PATH_IS_ERROR;
> +=09struct path *pp =3D NULL;
> +=09vector pathvec =3D NULL;
> +
> +=09pp =3D alloc_path();
> +=09if (!pp)
> +=09=09return RTVL_FAIL;
> +
> +=09r =3D is_path_valid(name, conf, pp, is_uevent);
> +=09if (r <=3D PATH_IS_ERROR || r >=3D PATH_MAX_VALID_RESULT)
> +=09=09goto fail;
> +

About the following block ...

> +=09/* set path values if is_path_valid() didn't */
> +=09if (!pp->udev)
> +=09=09pp->udev =3D udev_device_new_from_subsystem_sysname(udev,
> "block",
> +=09=09=09=09=09=09=09=09  name)
> ;
> +=09if (!pp->udev)
> +=09=09goto fail;
> +
> +=09if (!strlen(pp->dev_t)) {
> +=09=09dev_t devt =3D udev_device_get_devnum(pp->udev);
> +=09=09if (major(devt) =3D=3D 0 && minor(devt) =3D=3D 0)
> +=09=09=09goto fail;
> +=09=09snprintf(pp->dev_t, BLK_DEV_SIZE, "%d:%d", major(devt),
> +=09=09=09 minor(devt));
> +=09}
> +
> +=09pathvec =3D vector_alloc();
> +=09if (!pathvec)
> +=09=09goto fail;
> +
> +=09if (store_path(pathvec, pp) !=3D 0) {
> +=09=09free_path(pp);
> +=09=09goto fail;
> +=09}

... why do you do this here, rather than after the (r !=3D
PATH_IS_MAYBE_VALID) clause below? AFAICS you don't need pathvec until
you run path_discovery().


> +
> +=09if ((r =3D=3D PATH_IS_VALID || r =3D=3D PATH_IS_MAYBE_VALID) &&
> +=09    released_to_systemd())
> +=09=09r =3D PATH_IS_NOT_VALID;
> +
> +=09/* This state is only used to skip the released_to_systemd()
> check */
> +=09if (r =3D=3D PATH_IS_VALID_NO_CHECK)
> +=09=09r =3D PATH_IS_VALID;
> +
> +=09if (r !=3D PATH_IS_MAYBE_VALID)
> +=09=09goto out;
> +
> +=09/*
> +=09 * If opening the path with O_EXCL fails, the path
> +=09 * is in use (e.g. mounted during initramfs processing).
> +=09 * We know that it's not used by dm-multipath.
> +=09 * We may not set SYSTEMD_READY=3D0 on such devices, it
> +=09 * might cause systemd to umount the device.
> +=09 * Use O_RDONLY, because udevd would trigger another
> +=09 * uevent for close-after-write.
> +=09 *
> +=09 * The O_EXCL check is potentially dangerous, because it may
> +=09 * race with other tasks trying to access the device. Therefore
> +=09 * this code is only executed if the path hasn't been released
> +=09 * to systemd earlier (see above).
> +=09 */
> +=09fd =3D open(udev_device_get_devnode(pp->udev), O_RDONLY|O_EXCL);
> +=09if (fd >=3D 0)
> +=09=09close(fd);
> +=09else {
> +=09=09condlog(3, "%s: path %s is in use: %m", __func__, pp-
> >dev);
> +=09=09/* Check if we raced with multipathd */
> +=09=09if (sysfs_is_multipathed(pp, false))
> +=09=09=09r =3D PATH_IS_VALID;
> +=09=09else
> +=09=09=09r =3D PATH_IS_NOT_VALID;
> +=09=09goto out;
> +=09}
> +
> +=09/* For find_multipaths =3D SMART, if there is more than one path
> +=09 * matching the refwwid, then the path is valid */
> +=09if (path_discovery(pathvec, DI_SYSFS | DI_WWID) < 0)
> +=09=09goto fail;
> +=09filter_pathvec(pathvec, pp->wwid);
> +=09if (VECTOR_SIZE(pathvec) > 1)
> +=09=09r =3D PATH_IS_VALID;
> +=09else
> +=09=09r =3D PATH_IS_MAYBE_VALID;
> +
> +out:
> +=09r =3D print_cmd_valid(r, pathvec, conf);
> +=09free_pathvec(pathvec, FREE_PATHS);
> +=09/*
> +=09 * multipath -u must exit with status 0, otherwise udev won't
> +=09 * import its output.
> +=09 */
> +=09if (!is_uevent && r =3D=3D PATH_IS_NOT_VALID)
> +=09=09return RTVL_FAIL;
> +=09return RTVL_OK;
> +
> +fail:
> +=09if (pathvec)
> +=09=09free_pathvec(pathvec, FREE_PATHS);
> +=09else
> +=09=09free_path(pp);
> +=09return RTVL_FAIL;
> +}
> +
>  static int
>  get_dev_type(char *dev) {
>  =09struct stat buf;
> @@ -861,32 +853,6 @@ out:
>  =09return r;
>  }
> =20
> -static int test_multipathd_socket(void)
> -{
> -=09int fd;
> -=09/*
> -=09 * "multipath -u" may be run before the daemon is started. In
> this
> -=09 * case, systemd might own the socket but might delay
> multipathd
> -=09 * startup until some other unit (udev settle!)  has finished
> -=09 * starting. With many LUNs, the listen backlog may be
> exceeded, which
> -=09 * would cause connect() to block. This causes udev workers
> calling
> -=09 * "multipath -u" to hang, and thus creates a deadlock, until
> "udev
> -=09 * settle" times out.  To avoid this, call connect() in non-
> blocking
> -=09 * mode here, and take EAGAIN as indication for a filled-up
> systemd
> -=09 * backlog.
> -=09 */
> -
> -=09fd =3D __mpath_connect(1);
> -=09if (fd =3D=3D -1) {
> -=09=09if (errno =3D=3D EAGAIN)
> -=09=09=09condlog(3, "daemon backlog exceeded");
> -=09=09else
> -=09=09=09return 0;
> -=09} else
> -=09=09close(fd);
> -=09return 1;
> -}
> -
>  int
>  main (int argc, char *argv[])
>  {
> @@ -970,7 +936,11 @@ main (int argc, char *argv[])
>  =09=09=09conf->force_reload =3D FORCE_RELOAD_YES;
>  =09=09=09break;
>  =09=09case 'i':
> -=09=09=09conf->find_multipaths |=3D _FIND_MULTIPATHS_I;
> +=09=09=09if (conf->find_multipaths =3D=3D FIND_MULTIPATHS_ON
> ||
> +=09=09=09    conf->find_multipaths =3D=3D
> FIND_MULTIPATHS_STRICT)
> +=09=09=09=09conf->find_multipaths =3D
> FIND_MULTIPATHS_SMART;
> +=09=09=09else if (conf->find_multipaths =3D=3D
> FIND_MULTIPATHS_OFF)
> +=09=09=09=09conf->find_multipaths =3D
> FIND_MULTIPATHS_GREEDY;

Ok. Previously FIND_MULTIPATHS_SMART was not the same value as
FIND_MULTIPATHS_STRICT + _FIND_MULTIPATHS_I. Effectively, this doesn't
change logic, but only because the check for ignore_new_devs_on() in
should_multipath() is actually redundant. (IIRC in the past we'd
determined that "strict" + "ignore_wwids" makes no sense).


>  =09=09=09break;
>  =09=09case 't':
>  =09=09=09r =3D dump_config(conf, NULL, NULL) ? RTVL_FAIL :
> RTVL_OK;
> @@ -1064,15 +1034,10 @@ main (int argc, char *argv[])
>  =09=09condlog(0, "the -c option requires a path to check");
>  =09=09goto out;
>  =09}
> -=09if (cmd =3D=3D CMD_VALID_PATH &&
> -=09    dev_type =3D=3D DEV_UEVENT) {
> -=09=09if (!test_multipathd_socket()) {
> -=09=09=09condlog(3, "%s: daemon is not running", dev);
> -=09=09=09if (!systemd_service_enabled(dev)) {
> -=09=09=09=09r =3D print_cmd_valid(RTVL_NO, NULL,
> conf);
> -=09=09=09=09goto out;
> -=09=09=09}
> -=09=09}
> +=09if (cmd =3D=3D CMD_VALID_PATH) {
> +=09=09char * name =3D convert_dev(dev, (dev_type =3D=3D
> DEV_DEVNODE));
> +=09=09r =3D check_path_valid(name, conf, dev_type =3D=3D
> DEV_UEVENT);
> +=09=09goto out;
>  =09}
> =20
>  =09if (cmd =3D=3D CMD_REMOVE_WWID && !dev) {
> @@ -1136,13 +1101,6 @@ out:
>  =09cleanup_prio();
>  =09cleanup_checkers();
> =20
> -=09/*
> -=09 * multipath -u must exit with status 0, otherwise udev won't
> -=09 * import its output.
> -=09 */
> -=09if (cmd =3D=3D CMD_VALID_PATH && dev_type =3D=3D DEV_UEVENT && r =3D=
=3D
> RTVL_NO)
> -=09=09r =3D RTVL_OK;
> -
>  =09if (dev_type =3D=3D DEV_UEVENT)
>  =09=09closelog();
> =20

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
