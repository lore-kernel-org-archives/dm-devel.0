From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH 1/3] multipath: add libmpathvalid library
Date: Wed, 16 Sep 2020 14:18:49 +0000
Message-ID: <940b5f7e1202f27a55f58417314c45e441679535.camel@suse.com>
References: <1600206312-6497-1-git-send-email-bmarzins@redhat.com>
	<1600206312-6497-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1600206312-6497-2-git-send-email-bmarzins@redhat.com>
Content-ID: <E5EC8554B565D349939EF34577062C70@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, 2020-09-15 at 16:45 -0500, Benjamin Marzinski wrote:
> This library allows other programs to check if a path should be
> claimed
> by multipath. It exports an init and exit function, a pointer to a
> struct config, that stores the configuration which is dealt with in
> the
> init and exit functions, and two more functions.
> 
> mpath_get_mode() get the configured find_multipaths mode.
> mpath_is_path() returns whether the device is claimed by multipath,
> and
> optionally returns the wwid.  This code works slightly different than
> the multipath -c/u code for SMART mode.  Instead of checking all the
> existing paths to see if another has the same wwid, it expects the
> caller to pass in an array of the already known path wwids, and
> checks
> if the current path matches any of those.
> 
> The library also doesn't set up the device-mapper log fuctions. It
> leaves this up to the caller.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  Makefile                            |   3 +-
>  libmpathvalid/Makefile              |  38 +++++++
>  libmpathvalid/libmpathvalid.version |  10 ++
>  libmpathvalid/mpath_valid.c         | 168
> ++++++++++++++++++++++++++++
>  libmpathvalid/mpath_valid.h         |  57 ++++++++++
>  5 files changed, 275 insertions(+), 1 deletion(-)
>  create mode 100644 libmpathvalid/Makefile
>  create mode 100644 libmpathvalid/libmpathvalid.version
>  create mode 100644 libmpathvalid/mpath_valid.c
>  create mode 100644 libmpathvalid/mpath_valid.h
> 
> diff --git a/Makefile b/Makefile
> index 4a3491da..f127ff91 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -9,6 +9,7 @@ BUILDDIRS := \
>  	libmultipath/checkers \
>  	libmultipath/foreign \
>  	libmpathpersist \
> +	libmpathvalid \
>  	multipath \
>  	multipathd \
>  	mpathpersist \
> @@ -29,7 +30,7 @@ $(BUILDDIRS):
>  	$(MAKE) -C $@
>  
>  libmultipath libdmmp: libmpathcmd
> -libmpathpersist multipath multipathd: libmultipath
> +libmpathpersist libmpathvalid multipath multipathd: libmultipath
>  mpathpersist multipathd:  libmpathpersist
>  
>  libmultipath/checkers.install \
> diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
> new file mode 100644
> index 00000000..70b97eca
> --- /dev/null
> +++ b/libmpathvalid/Makefile
> @@ -0,0 +1,38 @@
> +include ../Makefile.inc
> +
> +SONAME = 0
> +DEVLIB = libmpathvalid.so
> +LIBS = $(DEVLIB).$(SONAME)
> +
> +CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
> +
> +LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) \
> +	   -lmultipath -L$(mpathcmddir) -lmpathcmd -ludev
> +
> +OBJS = mpath_valid.o
> +
> +all: $(LIBS)
> +
> +$(LIBS): $(OBJS)
> +	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS)
> $(LIBDEPS) -Wl,--version-script=libmpathvalid.version
> +	$(LN) $(LIBS) $(DEVLIB)
> +
> +install: $(LIBS)
> +	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
> +	$(INSTALL_PROGRAM) -m 755 $(LIBS)
> $(DESTDIR)$(syslibdir)/$(LIBS)
> +	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
> +	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(includedir)
> +	$(INSTALL_PROGRAM) -m 644 mpath_valid.h $(DESTDIR)$(includedir)
> +
> +uninstall:
> +	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
> +	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
> +	$(RM) $(DESTDIR)$(includedir)/mpath_valid.h
> +
> +clean: dep_clean
> +	$(RM) core *.a *.o *.so *.so.* *.gz
> +
> +include $(wildcard $(OBJS:.o=.d))
> +
> +dep_clean:
> +	$(RM) $(OBJS:.o=.d)
> diff --git a/libmpathvalid/libmpathvalid.version
> b/libmpathvalid/libmpathvalid.version
> new file mode 100644
> index 00000000..4d8a8ba4
> --- /dev/null
> +++ b/libmpathvalid/libmpathvalid.version
> @@ -0,0 +1,10 @@
> +MPATH_1.0 {
> +	global:
> +		mpathvalid_conf;
> +		mpathvalid_init;
> +		mpathvalid_exit;
> +		mpathvalid_is_path;
> +		mpathvalid_get_mode;
> +	local:
> +		*;
> +};
> diff --git a/libmpathvalid/mpath_valid.c
> b/libmpathvalid/mpath_valid.c
> new file mode 100644
> index 00000000..6153e8b7
> --- /dev/null
> +++ b/libmpathvalid/mpath_valid.c
> @@ -0,0 +1,168 @@
> +#include <stdlib.h>
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
> +#include "valid.h"
> +#include "mpath_valid.h"
> +
> +static struct config default_config = { .verbosity = -1 };
> +struct config *mpathvalid_conf = &default_config;
> +
> +static unsigned int get_conf_mode(struct config *conf)
> +{
> +	if (conf->find_multipaths == FIND_MULTIPATHS_SMART)
> +		return MPATH_SMART;
> +	if (conf->find_multipaths == FIND_MULTIPATHS_GREEDY)
> +		return MPATH_GREEDY;
> +	return MPATH_STRICT;
> +}
> +
> +static void set_conf_mode(struct config *conf, unsigned int mode)
> +{
> +	if (mode == MPATH_SMART)
> +		conf->find_multipaths = FIND_MULTIPATHS_SMART;
> +	else if (mode == MPATH_GREEDY)
> +		conf->find_multipaths = FIND_MULTIPATHS_GREEDY;
> +	else
> +		conf->find_multipaths = FIND_MULTIPATHS_STRICT;
> +}
> +
> +unsigned int mpathvalid_get_mode(void)
> +{
> +	int mode;
> +	struct config *conf;
> +
> +	conf = get_multipath_config();
> +	if (!conf)
> +		return -1;
> +	mode = get_conf_mode(conf);
> +	put_multipath_config(conf);
> +	return mode;
> +}
> +
> +static int convert_result(int result) {
> +	switch (result) {
> +	case PATH_IS_ERROR:
> +		return MPATH_IS_ERROR;
> +	case PATH_IS_NOT_VALID:
> +		return MPATH_IS_NOT_VALID;
> +	case PATH_IS_VALID:
> +		return MPATH_IS_VALID;
> +	case PATH_IS_VALID_NO_CHECK:
> +		return MPATH_IS_VALID_NO_CHECK;
> +	case PATH_IS_MAYBE_VALID:
> +		return MPATH_IS_MAYBE_VALID;
> +	}
> +	return MPATH_IS_ERROR;
> +}
> +
> +int
> +mpathvalid_init(int verbosity)
> +{
> +	unsigned int version[3];
> +	struct config *conf;
> +
> +	default_config.verbosity = verbosity;
> +	skip_libmp_dm_init();
> +	conf = load_config(DEFAULT_CONFIGFILE);
> +	if (!conf)
> +		return -1;
> +	conf->verbosity = verbosity;
> +	if (dm_prereq(version))
> +		goto fail;
> +	memcpy(conf->version, version, sizeof(version));
> +
> +	mpathvalid_conf = conf;
> +	return 0;
> +fail:
> +	free_config(conf);
> +	return -1;
> +}
> +
> +int
> +mpathvalid_exit(void)
> +{
> +	struct config *conf = mpathvalid_conf;
> +
> +	default_config.verbosity = -1;
> +	if (mpathvalid_conf == &default_config)
> +		return 0;
> +	mpathvalid_conf = &default_config;
> +	free_config(conf);
> +	return 0;
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
> +mpathvalid_is_path(const char *name, unsigned int mode, char **wwid,
> +	           const char **path_wwids, unsigned int nr_paths)
> +{
> +	struct config *conf;
> +	int r = MPATH_IS_ERROR;
> +	unsigned int i;
> +	struct path *pp;
> +
> +	if (!name || mode >= MPATH_MAX_MODE)
> +		return r;
> +
> +	if (nr_paths > 0 && !path_wwids)
> +		return r;
> +
> +	pp = alloc_path();
> +	if (!pp)
> +		return r;
> +
> +	if (wwid) {
> +		*wwid = (char *)malloc(WWID_SIZE);
> +		if (!*wwid)
> +			goto out;
> +	}
> +
> +	conf = get_multipath_config();
> +	if (!conf || conf == &default_config)
> +		goto out_wwid;
> +	if (mode != MPATH_DEFAULT)
> +		set_conf_mode(conf, mode);
> +	r = convert_result(is_path_valid(name, conf, pp, true));
> +	put_multipath_config(conf);
> +
> +	if (r == MPATH_IS_MAYBE_VALID) {
> +		for (i = 0; i < nr_paths; i++) {
> +			if (strncmp(path_wwids[i], pp->wwid, WWID_SIZE)
> == 0) {
> +				r = MPATH_IS_VALID;
> +				break;
> +			}
> +		}
> +	}
> +
> +out_wwid:
> +	if (wwid) {
> +		if (r == MPATH_IS_VALID || r == MPATH_IS_VALID_NO_CHECK
> ||
> +		    r == MPATH_IS_MAYBE_VALID)
> +			strlcpy(*wwid, pp->wwid, WWID_SIZE);
> +		else {
> +			free(*wwid);
> +			*wwid = NULL;
> +		}
> +	}
> +out:
> +	free_path(pp);
> +	return r;
> +}
> diff --git a/libmpathvalid/mpath_valid.h
> b/libmpathvalid/mpath_valid.h
> new file mode 100644
> index 00000000..7fd8aa47
> --- /dev/null
> +++ b/libmpathvalid/mpath_valid.h
> @@ -0,0 +1,57 @@
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
> +	MPATH_DEFAULT,
> +	MPATH_STRICT,
> +	MPATH_SMART,
> +	MPATH_GREEDY,
> +	MPATH_MAX_MODE,  /* used only for bounds checking */
> +};
> +
> +/* MPATH_IS_VALID_NO_CHECK is used to skip checks to see if the
> device
> + * has already been unclaimed by multipath in the past */
> +enum mpath_valid_result {
> +	MPATH_IS_ERROR = -1,
> +	MPATH_IS_NOT_VALID,
> +	MPATH_IS_VALID,
> +	MPATH_IS_VALID_NO_CHECK,
> +	MPATH_IS_MAYBE_VALID,
> +};
> +
> +struct config;
> +extern struct config *mpathvalid_conf;

What do you need this for?

This looks good to me. It would be even better with a few unit
tests...

Anyway, I've been working on a patch set to spare callers to define
the symbols {get,put}_multipath_config, udev, and logsink (we've been
discussing that in the past). I'm going to submit it soon. I think you
might be interested in that for this new library.

Regards
Martin
