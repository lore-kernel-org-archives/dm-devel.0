Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7689DC433EF
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 00:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643849069;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SdYqsp8+IZ94pqjWwl1WC/kyTJuqnlroh+Zxez0wNa0=;
	b=CTPyRO/eGJrTZl15AOnuQ8GGmAav9JlrzjFXKwxnJLA9ZHEHJmwv/outOsGTNVHV4fyXsi
	77ljjvcAuQgcAIf6EEetDWtSITSkqidaqpyZVrlL+E1VBzhwUHOyZgFT2vs9+cxF5n1iS9
	yOJmdCNVQdf/9RQDnX5T4J+Fb8Qlcws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-kTWnK7PcN2uo4w_0D8Lp4g-1; Wed, 02 Feb 2022 19:44:27 -0500
X-MC-Unique: kTWnK7PcN2uo4w_0D8Lp4g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 737EA100CCC2;
	Thu,  3 Feb 2022 00:44:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E0E985E4A6;
	Thu,  3 Feb 2022 00:44:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 570361806D03;
	Thu,  3 Feb 2022 00:44:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2130eVJs003679 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 19:40:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 269604EC7E; Thu,  3 Feb 2022 00:40:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8B264EC82;
	Thu,  3 Feb 2022 00:40:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2130e1Fn027430; 
	Wed, 2 Feb 2022 18:40:01 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2130e0i2027429;
	Wed, 2 Feb 2022 18:40:00 -0600
Date: Wed, 2 Feb 2022 18:40:00 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220203004000.GS24684@octiron.msp.redhat.com>
References: <20220201234024.27675-1-mwilck@suse.com>
	<20220201234024.27675-4-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220201234024.27675-4-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 3/6] multipath-tools: install
 modules-load.d/multipath.conf
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 02, 2022 at 12:40:21AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If multipath-tools is installed, we want to load the dm-multipath
> module early on, because multipath -u might spit out irritating
> error messages in syslog otherwise.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  Makefile.inc                | 1 +
>  multipath/Makefile          | 3 +++
>  multipath/modules-load.conf | 3 +++
>  3 files changed, 7 insertions(+)
>  create mode 100644 multipath/modules-load.conf
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index c5f1fa5..5223c96 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -73,6 +73,7 @@ usr_prefix	= $(prefix)
>  bindir		= $(exec_prefix)/sbin
>  libudevdir	= $(prefix)/$(SYSTEMDPATH)/udev
>  udevrulesdir	= $(libudevdir)/rules.d
> +modulesloaddir  = $(prefix)/$(SYSTEMDPATH)/modules-load.d
>  multipathdir	= $(TOPDIR)/libmultipath
>  man8dir		= $(prefix)/usr/share/man/man8
>  man5dir		= $(prefix)/usr/share/man/man5
> diff --git a/multipath/Makefile b/multipath/Makefile
> index c690368..015f73c 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -23,6 +23,8 @@ install:
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
>  	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
>  	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
> +	$(INSTALL_PROGRAM) -d $(DESTDIR)$(modulesloaddir)
> +	$(INSTALL_PROGRAM) -m 644 modules-load.conf $(DESTDIR)$(modulesloaddir)/multipath.conf
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
>  	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
> @@ -31,6 +33,7 @@ install:
>  uninstall:
>  	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
>  	$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
> +	$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
>  	$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
>  	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
>  	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5
> diff --git a/multipath/modules-load.conf b/multipath/modules-load.conf
> new file mode 100644
> index 0000000..b517d32
> --- /dev/null
> +++ b/multipath/modules-load.conf
> @@ -0,0 +1,3 @@
> +# load dm-multipath early, both multipathd and multipath depend on it
> +# (note that multipath may be called from udev rules!)
> +dm-multipath
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

