From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH V5 3/3] Introducing multipath C API
Date: Mon, 4 Jul 2016 18:32:56 +0200
Message-ID: <90c5e679-2942-12ce-4e77-9cc1f475ee45@gmail.com>
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
To: Gris Ge <fge@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper development <dm-devel@redhat.com>
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
> +

> +install:
> +	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
> +	$(INSTALL_PROGRAM) -m 644 -D \
> +		$(HEADERS) $(DESTDIR)/$(includedir)/$(HEADERS)
> +	ln -sf $(LIBS) $(DESTDIR)/$(syslibdir)/$(DEVLIB)
> +	$(INSTALL_PROGRAM) -m 644 -D \
> +		$(PKGFILE).in $(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
> +	perl -i -pe 's|__VERSION__|$(LIBDMMP_VERSION)|g' \
> +		$(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
> +	perl -i -pe 's|__LIBDIR__|$(syslibdir)|g' \
> +		$(DESTDIR)/$(pkgconfdir)/$(PKGFILE)
> +	perl -i -pe 's|__INCLUDEDIR__|$(includedir)|g' \
> +		$(DESTDIR)/$(pkgconfdir)/$(PKGFILE)

Please, replace perl with sed, awk or any other basic tool.

> +	@for file in docs/man/*.3.gz; do \
> +		$(INSTALL_PROGRAM) -m 644 -D \
> +			$$file \
> +			$(DESTDIR)/$(man3dir)/ || exit $?; \
> +	done
> +
> +uninstall:
> +	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
> +	rm -f $(DESTDIR)$(includedir)/$(HEADERS)
> +	rm -f $(DESTDIR)/$(syslibdir)/$(DEVLIB)
> +	@for file in $(DESTDIR)/$(man3dir)/dmmp_*; do \
> +		rm $$file; \
> +	done
> +	rm -f $(DESTDIR)$(man3dir)/libdmmp.h*
> +
> +clean:
> +	rm -f core *.a *.o *.gz *.so *.so.*
> +	rm -f docs/man/*.3.gz
> +	$(MAKE) -C test clean
> +
> +check: all
> +	$(MAKE) -C test check
> +
> +speed_test: all
> +	$(MAKE) -C test speed_test
> +
> +doc: docs/man/$(EXTRA_MAN_FILES).gz
> +
> +docs/man/$(EXTRA_MAN_FILES).gz: $(HEADERS)
> +	@for file in $(EXTRA_MAN_FILES); do \
> +		$(INSTALL_PROGRAM) -v -m 644 -D docs/$$file docs/man/$$file; \
> +	done
> +	perl docs/kernel-doc -man $(HEADERS) | perl docs/split-man.pl docs/man
> +	@for file in docs/man/*.3; do \
> +		gzip -f $$file; \
> +	done
> +	find docs/man -type f -name \*[0-9].gz
