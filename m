From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [RFC PATCH v2 3/3] multipath: add libmpathvalid
	library
Date: Tue, 28 Apr 2020 21:42:52 +0000
Message-ID: <6d02d82677fec4fd371bce97cd14bd720c115d48.camel@suse.com>
References: <1585896641-22896-1-git-send-email-bmarzins@redhat.com>
	<1585896641-22896-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585896641-22896-4-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <BC167C5286204947B8A947866AE38C91@namprd18.prod.outlook.com>
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

On Fri, 2020-04-03 at 01:50 -0500, Benjamin Marzinski wrote:
> This library allows other programs to check if a path should be
> claimed
> by multipath.  Currently, it only includes two functions.
> mpath_get_mode() get the configured find_multipaths mode.
> mpath_is_path() returns whether the device is claimed by multipath.
> It optionally also returns the wwid. The modes work
> mostly like they do for "multipath -c/-u", with a few exceptions.
>=20
> 1. If a device is currently multipathed, it is always VALID. This
> perhaps should be true for the existing path valid code.
>=20
> 2. If the mode is MPATH_FIND, and the device would be claimed if
> there
> was another path with the same wwid, but no matching wwid was passed
> in,
> mpath_is_path() will return MPATH_IS_MAYBE_VALID, just like if the
> find_multipaths mode was MPATH_SMART. This is so the caller knows to
> save this wwid to check against future paths.  It is the callers job
> to
> honor the difference between configurations with MPATH_FIND and
> MPATH_SMART.
>=20
> In order to act more library-like, libmpathvalid doesn't set its own
> device-mapper log functions. It leaves this to the caller. It
> currently
> keeps condlog() from printing anything, but should eventually include
> a
> function to allow the caller set the logging. It also uses a
> statically
> compiled version of libmultipath, both to keep that library from
> polluting the namespace of the caller, and to avoid the caller
> needing
> to set up the variables and functions (like logsink, and
> get_multipath_config) that it expects.

See my response to 0/3 wrt this approach.

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  Makefile                            |   1 +
>  Makefile.inc                        |   1 +
>  libmpathvalid/Makefile              |  38 ++++++
>  libmpathvalid/libmpathvalid.version |   7 +
>  libmpathvalid/mpath_valid.c         | 198
> ++++++++++++++++++++++++++++
>  libmpathvalid/mpath_valid.h         |  56 ++++++++
>  libmultipath/Makefile               |   1 +
>  libmultipath/devmapper.c            |  49 +++++++
>  libmultipath/devmapper.h            |   1 +
>  9 files changed, 352 insertions(+)
>  create mode 100644 libmpathvalid/Makefile
>  create mode 100644 libmpathvalid/libmpathvalid.version
>  create mode 100644 libmpathvalid/mpath_valid.c
>  create mode 100644 libmpathvalid/mpath_valid.h
>=20
> diff --git a/Makefile b/Makefile
> index 1dee3680..462d6655 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -9,6 +9,7 @@ BUILDDIRS :=3D \
>  =09libmultipath/checkers \
>  =09libmultipath/foreign \
>  =09libmpathpersist \
> +=09libmpathvalid \
>  =09multipath \
>  =09multipathd \
>  =09mpathpersist \
> diff --git a/Makefile.inc b/Makefile.inc
> index d4d1e0dd..7e0e8203 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -66,6 +66,7 @@ libdir=09=09=3D $(prefix)/$(LIB)/multipath
>  unitdir=09=09=3D $(prefix)/$(SYSTEMDPATH)/systemd/system
>  mpathpersistdir=09=3D $(TOPDIR)/libmpathpersist
>  mpathcmddir=09=3D $(TOPDIR)/libmpathcmd
> +mpathvaliddir=09=3D $(TOPDIR)/libmpathvalid
>  thirdpartydir=09=3D $(TOPDIR)/third-party
>  libdmmpdir=09=3D $(TOPDIR)/libdmmp
>  nvmedir=09=09=3D $(TOPDIR)/libmultipath/nvme
> diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
> new file mode 100644
> index 00000000..5fc97022
> --- /dev/null
> +++ b/libmpathvalid/Makefile
> @@ -0,0 +1,38 @@
> +include ../Makefile.inc
> +
> +SONAME =3D 0
> +DEVLIB =3D libmpathvalid.so
> +LIBS =3D $(DEVLIB).$(SONAME)
> +
> +CFLAGS +=3D $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
> +
> +LIBDEPS +=3D -lpthread -ldevmapper -ldl -L$(multipathdir) \
> +=09   -lmultipath_nonshared -L$(mpathcmddir) -lmpathcmd -ludev
> +
> +OBJS =3D mpath_valid.o
> +
> +all: $(LIBS)
> +
> +$(LIBS): $(OBJS)
> +=09$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=3D$@ -o $@ $(OBJS)
> $(LIBDEPS) -Wl,--version-script=3Dlibmpathvalid.version
> +=09$(LN) $(LIBS) $(DEVLIB)
> +
> +install: $(LIBS)
> +=09$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
> +=09$(INSTALL_PROGRAM) -m 755 $(LIBS)
> $(DESTDIR)$(syslibdir)/$(LIBS)
> +=09$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
> +=09$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(includedir)
> +=09$(INSTALL_PROGRAM) -m 644 mpath_valid.h $(DESTDIR)$(includedir)
> +
> +uninstall:
> +=09$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
> +=09$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
> +=09$(RM) $(DESTDIR)$(includedir)/mpath_valid.h
> +
> +clean: dep_clean
> +=09$(RM) core *.a *.o *.so *.so.* *.gz
> +
> +include $(wildcard $(OBJS:.o=3D.d))
> +
> +dep_clean:
> +=09$(RM) $(OBJS:.o=3D.d)
> diff --git a/libmpathvalid/libmpathvalid.version
> b/libmpathvalid/libmpathvalid.version
> new file mode 100644
> index 00000000..94a6f86f
> --- /dev/null
> +++ b/libmpathvalid/libmpathvalid.version
> @@ -0,0 +1,7 @@
> +MPATH_1.0 {
> +=09global:
> +=09=09mpath_is_path;
> +=09=09mpath_get_mode;
> +=09local:
> +=09=09*;
> +};
> diff --git a/libmpathvalid/mpath_valid.c
> b/libmpathvalid/mpath_valid.c
> new file mode 100644
> index 00000000..4a7c19e5
> --- /dev/null
> +++ b/libmpathvalid/mpath_valid.c
> @@ -0,0 +1,198 @@
> +#include <stdio.h>
> +#include <stdint.h>
> +#include <libdevmapper.h>
> +#include <libudev.h>
> +#include <errno.h>
> +
> +#include "devmapper.h"
> +#include "structs.h"
> +#include "util.h"
> +#include "config.h"
> +#include "discovery.h"
> +#include "wwids.h"
> +#include "sysfs.h"
> +#include "mpath_cmd.h"
> +#include "mpath_valid.h"
> +
> +struct udev *udev;
> +int logsink =3D -1;
> +static struct config default_config =3D { .verbosity =3D -1 };
> +static struct config *multipath_conf;
> +
> +struct config *get_multipath_config(void)
> +{
> +=09return (multipath_conf)? multipath_conf : &default_config;
> +}
> +
> +void put_multipath_config(__attribute__((unused))void *conf)
> +{
> +=09/* Noop */
> +}
> +
> +static int get_conf_mode(struct config *conf)
> +{
> +=09if (conf->find_multipaths =3D=3D FIND_MULTIPATHS_ON)
> +=09=09return MPATH_FIND;
> +=09if (conf->find_multipaths =3D=3D FIND_MULTIPATHS_SMART)
> +=09=09return MPATH_SMART;
> +=09if (conf->find_multipaths =3D=3D FIND_MULTIPATHS_GREEDY)
> +=09=09return MPATH_GREEDY;
> +=09return MPATH_STRICT;
> +}
> +
> +
> +int mpath_get_mode(void)
> +{
> +=09int mode;
> +=09struct config *conf;
> +
> +=09conf =3D load_config(DEFAULT_CONFIGFILE);

By using this, you'd pull in a substantial part of libmultipath.=20
Why don't you simply rely on the passed-in mode value?

Actually, I wonder if we could split libmultipath into a part "below"
libmpathvalid and a part "above" libmpathvalid. I wouldn't put
"load_config()" in the "below" part. The problematic part is
pathinfo(), which has to be "below" and which would pull in quite a bit
of libmultipath functionality.

> +=09if (!conf)
> +=09=09return -1;
> +=09mode =3D get_conf_mode(conf);
> +=09free_config(conf);
> +=09return mode;
> +}
> +
> +/*
> + * name: name of path to check
> + * mode: mode to use for determination. MPATH_DEFAULT uses
> configured mode
> + * info: on success, contains the path wwid
> + * paths: array of the returned mpath_info from other claimed paths
> + * nr_paths: the size of the paths array
> + */
> +int
> +mpath_is_path(const char *name, unsigned int mode, struct mpath_info
> *info,
> +=09      struct mpath_info **paths_arg, unsigned int nr_paths)

I wonder if you couldn't use a vector of "struct path*" instead
of "struct mpath_info*". But well, I the data structures can be=20
simply transformed into each other either way, so that's not a big
issue.

> +{
> +=09struct config *conf;
> +=09struct path * pp;
> +=09int r =3D MPATH_IS_ERROR;
> +=09int fd =3D -1;
> +=09unsigned int i, version[3];
> +=09bool already_multipathed =3D false;
> +=09/* stupid c implicit conversion rules fail */
> +=09const struct mpath_info * const *paths =3D (const struct
> mpath_info * const *)paths_arg;
> +
> +=09if (info)
> +=09=09memset(info, 0, sizeof(struct mpath_info));
> +
> +=09if (!name || mode >=3D MPATH_MAX_MODE)
> +=09=09return r;
> +
> +=09if (nr_paths > 0 && !paths)
> +=09=09return r;
> +
> +=09skip_libmp_dm_init();
> +=09udev =3D udev_new();
> +=09if (!udev)
> +=09=09goto out;
> +=09conf =3D load_config(DEFAULT_CONFIGFILE);
> +=09if (!conf)
> +=09=09goto out_udev;
> +=09conf->verbosity =3D -1;

Wouldn't this basically preclude calling the function from "multipath
-u", or any other place in multipath-tools assuming standard library
initialization? I'd like to split this off into some wrapper.

> +=09if (mode =3D=3D MPATH_DEFAULT)
> +=09=09mode =3D get_conf_mode(conf);
> +
> +=09if (dm_prereq(version))
> +=09=09goto out_config;
> +=09memcpy(conf->version, version, sizeof(version));
> +=09multipath_conf =3D conf;
> +
> +=09pp =3D alloc_path();
> +=09if (!pp)
> +=09=09goto out_config;
> +
> +=09if (safe_sprintf(pp->dev, "%s", name))
> +=09=09goto out_path;
> +
> +=09if (sysfs_is_multipathed(pp, true)) {
> +=09=09if (!info || pp->wwid[0] !=3D '\0') {
> +=09=09=09r =3D MPATH_IS_VALID;
> +=09=09=09goto out_path;
> +=09=09}
> +=09=09already_multipathed =3D true;

This is the "WWID overflow" case? I believe multipathd would never
create a map with an WWID longer than WWID_SIZE, and thus this
condition should be treated as an error.

Other than that, you've done a magnificent job in making the logic
of this function easy to understand. I'd love to replace the current
"multipath -u" logic with this.

> +=09}
> +
> +=09fd =3D __mpath_connect(1);
> +=09if (fd < 0) {
> +=09=09if (errno !=3D EAGAIN && !systemd_service_enabled(name))
> {
> +=09=09=09r =3D MPATH_IS_NOT_VALID;
> +=09=09=09goto out_path;
> +=09=09}
> +=09} else
> +=09=09mpath_disconnect(fd);
> +
> +=09pp->udev =3D udev_device_new_from_subsystem_sysname(udev,
> "block", name);
> +=09if (!pp->udev)
> +=09=09goto out_path;
> +
> +=09r =3D pathinfo(pp, conf, DI_SYSFS | DI_WWID | DI_BLACKLIST);
> +=09if (r) {
> +=09=09if (r =3D=3D PATHINFO_SKIPPED)
> +=09=09=09r =3D MPATH_IS_NOT_VALID;
> +=09=09else
> +=09=09=09r =3D MPATH_IS_ERROR;
> +=09=09goto out_path;
> +=09}
> +
> +=09if (pp->wwid[0] =3D=3D '\0') {
> +=09=09r =3D MPATH_IS_NOT_VALID;
> +=09=09goto out_path;
> +=09}
> +
> +=09if (already_multipathed)
> +=09=09goto out_path;
> +
> +=09if (dm_map_present_by_uuid(pp->wwid) =3D=3D 1) {
> +=09=09r =3D MPATH_IS_VALID;
> +=09=09goto out_path;
> +=09}
> +
> +=09r =3D is_failed_wwid(pp->wwid);
> +=09if (r !=3D WWID_IS_NOT_FAILED) {
> +=09=09if (r =3D=3D WWID_IS_FAILED)
> +=09=09=09r =3D MPATH_IS_NOT_VALID;
> +=09=09else
> +=09=09=09r =3D MPATH_IS_ERROR;
> +=09=09goto out_path;
> +=09}
> +
> +=09if (mode =3D=3D MPATH_GREEDY) {
> +=09=09r =3D MPATH_IS_VALID;
> +=09=09goto out_path;
> +=09}
> +
> +=09if (check_wwids_file(pp->wwid, 0) =3D=3D 0) {
> +=09=09r =3D MPATH_IS_VALID;
> +=09=09goto out_path;
> +=09}
> +
> +=09if (mode =3D=3D MPATH_STRICT) {
> +=09=09r =3D MPATH_IS_NOT_VALID;
> +=09=09goto out_path;
> +=09}

It seems I misunderstood you before. This MPATH_STRICT logic looks
fine.

> +
> +=09for (i =3D 0; i < nr_paths; i++) {
> +=09=09if (strncmp(paths[i]->wwid, pp->wwid, 128) =3D=3D 0) {
> +=09=09=09r =3D MPATH_IS_VALID;
> +=09=09=09goto out_path;
> +=09=09}
> +=09}
> +
> +=09/* mode =3D=3D MPATH_SMART || mode =3D=3D MPATH_FIND */
> +=09r =3D MPATH_IS_MAYBE_VALID;
> +
> +out_path:
> +=09if (already_multipathed)
> +=09=09r =3D MPATH_IS_VALID;
> +=09if (info && (r =3D=3D MPATH_IS_VALID || r =3D=3D MPATH_IS_MAYBE_VALID=
))
> +=09=09strlcpy(info->wwid, pp->wwid, 128);
> +=09free_path(pp);
> +out_config:
> +=09free_config(conf);
> +out_udev:
> +=09udev_unref(udev);
> +out:
> +=09return r;
> +}
> diff --git a/libmpathvalid/mpath_valid.h
> b/libmpathvalid/mpath_valid.h
> new file mode 100644
> index 00000000..f832beff
> --- /dev/null
> +++ b/libmpathvalid/mpath_valid.h
> @@ -0,0 +1,56 @@
> +/*
> + * Copyright (C) 2015 Red Hat, Inc.
> + *
> + * This file is part of the device-mapper multipath userspace tools.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> License
> + * along with this program.  If not, see <
> http://www.gnu.org/licenses/>;.
> + */
> +
> +#ifndef LIB_MPATH_VALID_H
> +#define LIB_MPATH_VALID_H
> +
> +#ifdef __cpluscplus
> +extern "C" {
> +#endif
> +
> +enum mpath_valid_mode {
> +=09MPATH_DEFAULT,
> +=09MPATH_STRICT,
> +=09MPATH_FIND,
> +=09MPATH_SMART,
> +=09MPATH_GREEDY,
> +=09MPATH_MAX_MODE,  /* used only for bounds checking */
> +};
> +
> +enum mpath_valid_result {
> +=09MPATH_IS_ERROR =3D -1,
> +=09MPATH_IS_NOT_VALID,
> +=09MPATH_IS_VALID,
> +=09MPATH_IS_MAYBE_VALID,
> +};
> +
> +struct mpath_info {
> +=09char wwid[128];
> +};
> +
> +int mpath_get_mode(void);
> +int mpath_is_path(const char *name, unsigned int mode, struct
> mpath_info *info,
> +=09=09  struct mpath_info **paths, unsigned int nr_paths);
> +
> +
> +#ifdef __cplusplus
> +}
> +#endif
> +#endif /* LIB_PATH_VALID_H */
> +
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index ad690a49..7e2c00cf 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -69,6 +69,7 @@ nvme-ioctl.h: nvme/nvme-ioctl.h
> =20
>  $(LIBS): $(OBJS)
>  =09$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=3D$@ -o $@ $(OBJS)
> $(LIBDEPS)
> +=09ar rcs libmultipath_nonshared.a $(OBJS)
>  =09$(LN) $@ $(DEVLIB)
> =20
>  install:
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

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
