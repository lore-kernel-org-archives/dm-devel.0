Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1E4C433E7
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 21:06:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 93B1E21655
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 21:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="epM0QYMB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93B1E21655
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1602882385;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JA4B/IxHXjMnpt/JBWMtfiwpy1RbJyRzQZFUyUc20Q0=;
	b=epM0QYMBwOFRPun67VHKXrM+PzuUMJITqDG9fxA6kxyC2HAwZe2PvhNE8qStlkE/PfqgdN
	IllGo0c5uHKIY18dhrf/QcOHbKmluxugOgRydKgWmOV5SnYkU07IF7ohf30i7GSw9lmGep
	78xo9nXrwPrhHfPfebQs+OaOx+2lU8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-K1rvgkVXNo6Vb0CL7033gw-1; Fri, 16 Oct 2020 17:06:22 -0400
X-MC-Unique: K1rvgkVXNo6Vb0CL7033gw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83DBC107AFB2;
	Fri, 16 Oct 2020 21:06:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C0B35D9CC;
	Fri, 16 Oct 2020 21:06:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 16BD258131;
	Fri, 16 Oct 2020 21:06:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GL4Xd9003472 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 17:04:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0D39155781; Fri, 16 Oct 2020 21:04:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2465B55775;
	Fri, 16 Oct 2020 21:04:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09GL4S7o027162; 
	Fri, 16 Oct 2020 16:04:28 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09GL4R59027161;
	Fri, 16 Oct 2020 16:04:27 -0500
Date: Fri, 16 Oct 2020 16:04:27 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201016210427.GW3384@octiron.msp.redhat.com>
References: <20201016104239.8217-1-mwilck@suse.com>
	<20201016104239.8217-9-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201016104239.8217-9-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 08/12] libmultipath: create separate .so
	for unit tests
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Fri, Oct 16, 2020 at 12:42:35PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The unit tests use a lot of internal symbols that we don't want
> to add to the ABI if we don't have to. As long as we don't
> have to make incompatible changes to functions, we can work around
> that by simply using a non-versioned library for the unit tests.
> Therefore we add a seperate rule here. Do this before actually
> adding a version script, to avoid breakage during bisection.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
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
> index 502377f..f6ef16a 100644
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
> +	$(RM) $(TESTS:%=%.out) $(TESTS:%=%.vgr) *.so*
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

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

