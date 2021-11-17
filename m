Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7692C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:21:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 695E061BC1
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:21:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 695E061BC1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637173262;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xmB9XTKIZzqemhkj+uk+JzC8eA7OvTSRZe1SFFWQN5E=;
	b=iXTEcDlGBdGMe/ZUEpD+znYbcAlAYtwrblmRq69/fCTjXkSU6kJquCl4bebnMrBTxwcDLt
	MuLGGRAjC3njaOE6UzOLx9XjaEAPHLMdBNHeeut0Q9f6pTnb7POUlmbWEh1fFhI3Nag3Ud
	5GE2uHclS/NOqqcul7KTCnnMsgv3eAw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-rf0o1Or6M_mQfqsFdTe-xw-1; Wed, 17 Nov 2021 13:21:01 -0500
X-MC-Unique: rf0o1Or6M_mQfqsFdTe-xw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75E861808304;
	Wed, 17 Nov 2021 18:20:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58BE1ADCD;
	Wed, 17 Nov 2021 18:20:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 345681832DD2;
	Wed, 17 Nov 2021 18:20:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHIKcGD005919 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 13:20:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 96EFD5F4EE; Wed, 17 Nov 2021 18:20:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C9E25F4ED;
	Wed, 17 Nov 2021 18:20:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHIKH1n003768; 
	Wed, 17 Nov 2021 12:20:17 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHIKH59003767;
	Wed, 17 Nov 2021 12:20:17 -0600
Date: Wed, 17 Nov 2021 12:20:17 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211117182016.GY19591@octiron.msp.redhat.com>
References: <20211112210551.12744-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211112210551.12744-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/3] multipath-tools: support ABI testing
	with libabigail
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 12, 2021 at 10:05:49PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Use abidw and abidiff (https://sourceware.org/libabigail/) to
> generate a formal representation of our ABI, and check for changes.
> This will reduce the amount of attention required to detect and
> track library version changes.
> 
> To check for differences, run "make abi" on some branch, rename the
> "abi" directory to "reference-abi", checkout a different branch,
> and run "make abi-test".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  .gitignore               |  4 +++
>  Makefile                 | 55 ++++++++++++++++++++++++++++++++++------
>  Makefile.inc             |  6 +++++
>  libdmmp/Makefile         |  8 ++++--
>  libmpathcmd/Makefile     |  4 ++-
>  libmpathpersist/Makefile |  4 ++-
>  libmpathvalid/Makefile   |  4 ++-
>  libmultipath/Makefile    |  4 ++-
>  8 files changed, 75 insertions(+), 14 deletions(-)
> 
> diff --git a/.gitignore b/.gitignore
> index 087dffc..5dbac39 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -3,6 +3,7 @@
>  *~
>  *.so
>  *.so.0
> +*.abi
>  *.a
>  *.gz
>  *.d
> @@ -13,6 +14,9 @@ kpartx/kpartx
>  multipath/multipath
>  multipathd/multipathd
>  mpathpersist/mpathpersist
> +abi.tar.gz
> +abi
> +abi-test
>  .nfs*
>  *.swp
>  *.patch
> diff --git a/Makefile b/Makefile
> index 7f21db8..1cec777 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -2,33 +2,70 @@
>  # Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
>  #
>  
> -BUILDDIRS := \
> +LIB_BUILDDIRS := \
>  	libmpathcmd \
>  	libmultipath \
> +	libmpathpersist \
> +	libmpathvalid
> +
> +ifneq ($(ENABLE_LIBDMMP),0)
> +LIB_BUILDDIRS += \
> +	libdmmp
> +endif
> +
> +BUILDDIRS := $(LIB_BUILDDIRS) \
>  	libmultipath/prioritizers \
>  	libmultipath/checkers \
>  	libmultipath/foreign \
> -	libmpathpersist \
> -	libmpathvalid \
>  	multipath \
>  	multipathd \
>  	mpathpersist \
>  	kpartx
>  
> -ifneq ($(ENABLE_LIBDMMP),0)
> -BUILDDIRS += \
> -	libdmmp
> -endif
>  
>  BUILDDIRS.clean := $(BUILDDIRS:=.clean) tests.clean
>  
> -.PHONY:	$(BUILDDIRS) $(BUILDDIRS:=.uninstall) $(BUILDDIRS:=.install) $(BUILDDIRS.clean)
> +.PHONY:	$(BUILDDIRS) $(BUILDDIRS:=.uninstall) $(BUILDDIRS:=.install) $(BUILDDIRS:=.clean) $(LIB_BUILDDIRS:=.abi)
>  
>  all:	$(BUILDDIRS)
>  
>  $(BUILDDIRS):
>  	$(MAKE) -C $@
>  
> +$(LIB_BUILDDIRS:=.abi): $(LIB_BUILDDIRS)
> +	$(MAKE) -C ${@:.abi=} abi
> +
> +# Create formal representation of the ABI
> +# Useful for verifying ABI compatibility
> +# Requires abidw from the abigail suite (https://sourceware.org/libabigail/)
> +.PHONY: abi
> +abi:	$(LIB_BUILDDIRS:=.abi)
> +	mkdir -p $@
> +	ln -ft $@ $(LIB_BUILDDIRS:=/*.abi)
> +
> +abi.tar.gz:	abi
> +	tar cfz $@ abi
> +
> +# Check the ABI against a reference.
> +# This requires the ABI from a previous run to be present
> +# in the directory "reference-abi"
> +# Requires abidiff from the abigail suite
> +abi-test:	abi reference-abi $(wildcard abi/*.abi)
> +	@err=0; \
> +	for lib in abi/*.abi; do \
> +	    diff=$$(abidiff "reference-$$lib" "$$lib") || { \
> +	        err=1; \
> +		echo "==== ABI differences in for $$lib ===="; \
> +		echo "$$diff"; \
> +	    }; \
> +	done >$@; \
> +	if [ $$err -eq 0 ]; then \
> +	    echo "*** OK, ABI unchanged ***"; \
> +	else \
> +	    echo "*** WARNING: ABI has changed, see file $@ ***"; \
> +	fi; \
> +	[ $$err -eq 0 ]
> +
>  libmultipath libdmmp: libmpathcmd
>  libmpathpersist libmpathvalid multipath multipathd: libmultipath
>  libmultipath/prioritizers libmultipath/checkers libmultipath/foreign: libmultipath
> @@ -48,6 +85,8 @@ $(BUILDDIRS:=.uninstall):
>  	$(MAKE) -C ${@:.uninstall=} uninstall
>  
>  clean: $(BUILDDIRS.clean)
> +	rm -rf abi abi.tar.gz abi-test compile_commands.json
> +
>  install: all $(BUILDDIRS:=.install)
>  uninstall: $(BUILDDIRS:=.uninstall)
>  
> diff --git a/Makefile.inc b/Makefile.inc
> index d0ec9b4..17071ef 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -140,3 +140,9 @@ check_file = $(shell \
>  %.o:	%.c
>  	@echo building $@ because of $?
>  	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
> +
> +%.abi:  %.so.0
> +	abidw $< >$@
> +
> +%.abi:  %.so
> +	abidw $< >$@
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 79b92fb..c91f0c3 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -25,7 +25,11 @@ all: $(LIBS) doc
>  
>  $(LIBS): $(OBJS)
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
> -	$(LN) $@ $(DEVLIB)
> +
> +$(DEVLIB): $(LIBS)
> +	$(LN) $(LIBS) $@
> +
> +abi:    $(DEVLIB:%.so=%.abi)
>  
>  install:	doc.gz
>  	mkdir -p $(DESTDIR)$(usrlibdir)
> @@ -54,7 +58,7 @@ uninstall:
>  	$(RM) $(DESTDIR)$(pkgconfdir)/$(PKGFILE)
>  
>  clean: dep_clean
> -	$(RM) core *.a *.o *.gz *.so *.so.*
> +	$(RM) core *.a *.o *.gz *.so *.so.* *.abi
>  	$(RM) docs/man/*.gz
>  	$(MAKE) -C test clean
>  
> diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
> index 2591019..5a7a6e9 100644
> --- a/libmpathcmd/Makefile
> +++ b/libmpathcmd/Makefile
> @@ -15,6 +15,8 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
>  		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
>  
> +abi:    $(LIBS:%.so.0=%.abi)
> +
>  $(DEVLIB): $(LIBS)
>  	$(LN) $(LIBS) $@
>  
> @@ -31,7 +33,7 @@ uninstall:
>  	$(RM) $(DESTDIR)$(includedir)/mpath_cmd.h
>  
>  clean: dep_clean
> -	$(RM) core *.a *.o *.so *.so.* *.gz
> +	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
>  
>  include $(wildcard $(OBJS:.o=.d))
>  
> diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
> index 57103e5..d76918f 100644
> --- a/libmpathpersist/Makefile
> +++ b/libmpathpersist/Makefile
> @@ -18,6 +18,8 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
>  		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
>  
> +abi:    $(LIBS:%.so.0=%.abi)
> +
>  $(DEVLIB): $(LIBS)
>  	$(LN) $(LIBS) $@
>  
> @@ -44,7 +46,7 @@ uninstall:
>  	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
>  
>  clean: dep_clean
> -	$(RM) core *.a *.o *.so *.so.* *.gz
> +	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
>  
>  include $(wildcard $(OBJS:.o=.d))
>  
> diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
> index 6bea4bc..b579535 100644
> --- a/libmpathvalid/Makefile
> +++ b/libmpathvalid/Makefile
> @@ -18,6 +18,8 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS) -Wl,--version-script=libmpathvalid.version
>  	$(LN) $(LIBS) $(DEVLIB)
>  
> +abi:    $(LIBS:%.so.0=%.abi)
> +
>  install: $(LIBS)
>  	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
>  	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
> @@ -31,7 +33,7 @@ uninstall:
>  	$(RM) $(DESTDIR)$(includedir)/mpath_valid.h
>  
>  clean: dep_clean
> -	$(RM) core *.a *.o *.so *.so.* *.gz
> +	$(RM) core *.a *.o *.so *.so.* *.gz *.abi
>  
>  include $(wildcard $(OBJS:.o=.d))
>  
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 7f3921c..42692b3 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -81,6 +81,8 @@ $(LIBS): $(OBJS) $(VERSION_SCRIPT)
>  $(DEVLIB): $(LIBS)
>  	$(LN) $(LIBS) $@
>  
> +abi:    $(LIBS:%.so.0=%.abi)
> +
>  ../tests/$(LIBS): $(OBJS) $(VERSION_SCRIPT)
>  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=`basename $@` \
>  		-o $@ $(OBJS) $(LIBDEPS)
> @@ -99,7 +101,7 @@ uninstall:
>  	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
>  
>  clean: dep_clean
> -	$(RM) core *.a *.o *.so *.so.* *.gz nvme-ioctl.c nvme-ioctl.h
> +	$(RM) core *.a *.o *.so *.so.* *.gz *.abi nvme-ioctl.c nvme-ioctl.h
>  
>  include $(wildcard $(OBJS:.o=.d))
>  
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

