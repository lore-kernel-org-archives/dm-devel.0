From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 08/11] libmultipath: create separate .so for
	unit tests
Date: Thu, 24 Sep 2020 18:35:04 -0500
Message-ID: <20200924233504.GK11108@octiron.msp.redhat.com>
References: <20200924133644.14034-1-mwilck@suse.com>
	<20200924133644.14034-9-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133644.14034-9-mwilck@suse.com>
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
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 03:36:41PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The unit tests use a lot of internal symbols that we don't want
> to add to the ABI if we don't have to. As long as we don't
> have to make incompatible changes to functions, we can work around
> that by simply using a non-versioned library for the unit tests.
> Therefore we add a seperate rule here. Do this before actually
> adding a version script, to avoid breakage during bisection.
> ---
>  libmultipath/Makefile |  7 +++++++
>  tests/Makefile        | 10 ++++++----
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index af5bb77..cf13561 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -74,6 +74,13 @@ $(LIBS): $(OBJS)
>  $(DEVLIB): $(LIBS)
>  	$(LN) $(LIBS) $@
>  
> +../tests/$(LIBS): $(OBJS) $(VERSION_SCRIPT)
> +	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=`basename $@` \
> +		-o $@ $(OBJS) $(LIBDEPS)
> +	$(LN) $@ ${@:.so.0=.so}
> +
> +test-lib:	../tests/$(LIBS)
> +
>  install: all
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
>  	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
> diff --git a/tests/Makefile b/tests/Makefile
> index 502377f..47e6b86 100644
> --- a/tests/Makefile
> +++ b/tests/Makefile
> @@ -10,7 +10,7 @@ W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)
>  
>  CFLAGS += $(BIN_CFLAGS) -I$(multipathdir) -I$(mpathcmddir) \
>  	-Wno-unused-parameter $(W_MISSING_INITIALIZERS)
> -LIBDEPS += -L$(multipathdir) -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
> +LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
>  
>  TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
>  	 alias directio valid devt
> @@ -67,7 +67,7 @@ lib/libchecktur.so:
>  
>  %.out:	%-test lib/libchecktur.so
>  	@echo == running $< ==
> -	@LD_LIBRARY_PATH=$(multipathdir):$(mpathcmddir) ./$< >$@
> +	@LD_LIBRARY_PATH=.:$(mpathcmddir) ./$< >$@
>  
>  %.vgr:  %-test lib/libchecktur.so
>  	@echo == running valgrind for $< ==
> @@ -77,7 +77,7 @@ lib/libchecktur.so:
>  OBJS = $(TESTS:%=%.o) test-lib.o
>  
>  test_clean:
> -	$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr)
> +	$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr) *.so.*

Perhaps:
	$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr) *.so*

so you also remove libmultipath.so

-Ben

>  
>  valgrind_clean:
>  	$(RM) $(TESTS:%=%.vgr)
> @@ -97,12 +97,14 @@ dep_clean:
>  	@sed -n 's/^.*__wrap_\([a-zA-Z0-9_]*\).*$$/-Wl,--wrap=\1/p' $< | \
>  		sort -u | tr '\n' ' ' >$@
>  
> +libmultipath.so.0:
> +	$(MAKE) -C $(multipathdir) test-lib
>  
>  # COLON will get expanded during second expansion below
>  COLON:=:
>  .SECONDEXPANSION:
>  %-test:	%.o %.o.wrap $$($$@_OBJDEPS) $$($$@_TESTDEPS) $$($$@_TESTDEPS$$(COLON).o=.o.wrap) \
> -		$(multipathdir)/libmultipath.so Makefile
> +		libmultipath.so.0 Makefile
>  	$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $< $($@_TESTDEPS) $($@_OBJDEPS) \
>  		$(LIBDEPS) $($@_LIBDEPS) \
>  		$(shell cat $<.wrap) $(foreach dep,$($@_TESTDEPS),$(shell cat $(dep).wrap))
> -- 
> 2.28.0
