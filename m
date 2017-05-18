From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH] multipath-tools: enable libdmmp installation
 in alternative directory
Date: Thu, 18 May 2017 12:05:15 -0500
Message-ID: <20170518170515.GR22856@octiron.msp.redhat.com>
References: <20170515203325.22170-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170515203325.22170-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, May 15, 2017 at 10:33:25PM +0200, Martin Wilck wrote:

Fine by me.

-Ben

> Introduce a new Makefile variable, usr_prefix, to be used for
> libdmmp and the associated pkgconfig file.
> 
> Some distributions install those libraries which are  necessary
> for booting (and mounting /usr) in a different location (/lib or
> /lib64) than other libraries (/usr/lib or /usr/lib64). On such
> distributions, installation to the different paths can be achieved
> by setting "usr_prefix=/usr". This will affect only libdmmp at this
> time, as all other libaries in the multipath-tools package may be
> relevant for booting.
> 
> For distributions on which /lib and /lib64 are just symlinks to their
> /usr counterparts, nothing changes.
> 
> Comments are welcome.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc     |  4 +++-
>  libdmmp/Makefile | 11 ++++++-----
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index ad55aa10..ad08f307 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -47,6 +47,7 @@ endif
>  
>  prefix		=
>  exec_prefix	= $(prefix)
> +usr_prefix	= $(prefix)
>  bindir		= $(exec_prefix)/sbin
>  libudevdir	= $(prefix)/$(SYSTEMDPATH)/udev
>  udevrulesdir	= $(libudevdir)/rules.d
> @@ -55,6 +56,7 @@ man8dir		= $(prefix)/usr/share/man/man8
>  man5dir		= $(prefix)/usr/share/man/man5
>  man3dir		= $(prefix)/usr/share/man/man3
>  syslibdir	= $(prefix)/$(LIB)
> +usrlibdir	= $(usr_prefix)/$(LIB)
>  libdir		= $(prefix)/$(LIB)/multipath
>  unitdir		= $(prefix)/$(SYSTEMDPATH)/systemd/system
>  mpathpersistdir	= $(TOPDIR)/libmpathpersist
> @@ -62,7 +64,7 @@ mpathcmddir	= $(TOPDIR)/libmpathcmd
>  thirdpartydir	= $(TOPDIR)/third-party
>  libdmmpdir	= $(TOPDIR)/libdmmp
>  includedir	= $(prefix)/usr/include
> -pkgconfdir	= $(prefix)/$(LIB)/pkgconfig
> +pkgconfdir	= $(usrlibdir)/pkgconfig
>  
>  GZIP		= gzip -9 -c
>  RM		= rm -f
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 1c5329aa..908e294b 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -27,15 +27,16 @@ $(LIBS): $(OBJS)
>  	$(LN) $@ $(DEVLIB)
>  
>  install:
> -	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
> +	mkdir -p $(DESTDIR)$(usrlibdir)
> +	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(usrlibdir)/$(LIBS)
>  	$(INSTALL_PROGRAM) -m 644 -D \
>  		$(HEADERS) $(DESTDIR)$(includedir)/$(HEADERS)
> -	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
> +	$(LN) $(LIBS) $(DESTDIR)$(usrlibdir)/$(DEVLIB)
>  	$(INSTALL_PROGRAM) -m 644 -D \
>  		$(PKGFILE).in $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
>  	perl -i -pe 's|__VERSION__|$(LIBDMMP_VERSION)|g' \
>  		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
> -	perl -i -pe 's|__LIBDIR__|$(syslibdir)|g' \
> +	perl -i -pe 's|__LIBDIR__|$(usrlibdir)|g' \
>  		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
>  	perl -i -pe 's|__INCLUDEDIR__|$(includedir)|g' \
>  		$(DESTDIR)$(pkgconfdir)/$(PKGFILE)
> @@ -46,9 +47,9 @@ install:
>  	done
>  
>  uninstall:
> -	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
> +	$(RM) $(DESTDIR)$(usrlibdir)/$(LIBS)
>  	$(RM) $(DESTDIR)$(includedir)/$(HEADERS)
> -	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
> +	$(RM) $(DESTDIR)$(usrlibdir)/$(DEVLIB)
>  	@for file in $(DESTDIR)$(man3dir)/dmmp_*; do \
>  		$(RM) $$file; \
>  	done
> -- 
> 2.12.2
