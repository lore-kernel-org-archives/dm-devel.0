From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH V5 3/3] Introducing multipath C API
Date: Sun, 10 Jul 2016 18:23:39 +0200
Message-ID: <46d2a8c7-0a33-54fb-9952-c2805816f5c8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Gris Ge wrote:

> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> new file mode 100644
> index 0000000..ce7ca3f
> --- /dev/null
> +++ b/libdmmp/Makefile
> @@ -0,0 +1,78 @@
> +# Makefile
> +#
> +# Copyright (C) 2015 - 2016 Red Hat, Inc.
> +# Gris Ge <fge@redhat.com>
> +#
> +include ../Makefile.inc
> +
> +LIBDMMP_VERSION=0.1.0
> +SONAME=$(LIBDMMP_VERSION)
> +DEVLIB = libdmmp.so
> +LIBS = $(DEVLIB).$(SONAME)
> +LIBDEPS = -pthread
> +PKGFILE = libdmmp.pc
> +EXTRA_MAN_FILES = libdmmp.h.3
> +HEADERS = libdmmp/libdmmp.h
> +OBJS = libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_misc.o
> +
> +CFLAGS += -fvisibility=hidden -I$(libdmmpdir) -I$(mpathcmddir) \
> +	  $(shell pkg-config --cflags json-c)
> +LDFLAGS += $(shell pkg-config --libs json-c) -L$(mpathcmddir) -lmpathcmd
> +
> +all: $(LIBS) doc
> +
> +$(LIBS): $(OBJS)
> +	$(CC) $(LDFLAGS) $(SHARED_FLAGS) \
> +	-Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)
> +	ln -sf $@ $(DEVLIB)

In Makefile(s), replace "ln -arguments" and "rm -arguments" with $(LN) $(RM).
