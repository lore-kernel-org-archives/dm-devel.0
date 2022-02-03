Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CF9FC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 00:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643848696;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oCRR3KFeimFKrOWWID8adSv1je/Tb5Pv2dAESC7y0wY=;
	b=CCOEgSHfPYPxZ6HpGDINreHrQ48BGjMkNjNUurenbEBmRZmCa+2r4NaMvwkR0xJuIlaRua
	H63r8kVgoqzltN8DtfZ+5vu9c/CQ7WKD93TW6NUJVv4CfHLzVcCJuTxbYTa8/nyrm2j53K
	QrhU9BoqmgpSUt1zD/HyIDDK2SCeJ5Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-fsGd1n9QNQeCDFN6ZbMZYg-1; Wed, 02 Feb 2022 19:38:14 -0500
X-MC-Unique: fsGd1n9QNQeCDFN6ZbMZYg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A49394686A;
	Thu,  3 Feb 2022 00:38:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D6A862D40;
	Thu,  3 Feb 2022 00:38:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 841111806D1C;
	Thu,  3 Feb 2022 00:38:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2130c3l3003513 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 19:38:03 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 228165DBB5; Thu,  3 Feb 2022 00:38:03 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E197E5DBB8;
	Thu,  3 Feb 2022 00:37:56 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2130bsD5027351; 
	Wed, 2 Feb 2022 18:37:54 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2130br1p027350;
	Wed, 2 Feb 2022 18:37:53 -0600
Date: Wed, 2 Feb 2022 18:37:53 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220203003753.GP24684@octiron.msp.redhat.com>
References: <20220201234024.27675-1-mwilck@suse.com>
	<20220201234024.27675-6-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220201234024.27675-6-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 5/6] multipath: Makefile: modules-load.d file
 for SCSI device handlers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 02, 2022 at 12:40:23AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The kernel's autoload mechanism for SCSI device handlers doesn't
> work during SCSI device probing. While it's possible to load and
> attach device handlers after probing, it has disadvantages: the
> handlers are useful for error handling even before multipathd has
> started, and at least up to kernel 5.17, the sysfs "access_state" attribute
> will remain invisible for already probed devices.
> 
> Distributions will therefore want to make sure the handlers are either
> built-in in the kernel, or loaded early. Add functionality to
> create and install a modules-load.d file with a list of handlers
> to load. By default, the list is empty, and no file will be generated.
> The list can be specified at install-time like this:
> 
>    make SCSI_DH_MODULES_PRELOAD="scsi_dh_rdac scsi_dh_emc" install
> 
> dracut automatically adds modules-load.d files and the modules they
> reference to the initramfs.
> 
> Note: distributions that compile scsi_mod as a module may rather want
> to use a modprobe.d file with a statement like this:
> 
> softdep scsi_mod post: scsi_dh_alua scsi_dh_rdac
> 

I think you might need a default scsi_dh.conf file with a comment header
or something. install won't install a file that doesn't exist. Or am I
missing something here?

-Ben

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc       | 5 +++++
>  multipath/Makefile | 6 ++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index 5223c96..3342af6 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -9,6 +9,11 @@
>  # Uncomment to disable dmevents polling support
>  # ENABLE_DMEVENTS_POLL = 0
>  
> +# List of scsi device handler modules to load on boot, e.g.
> +# SCSI_DH_MODULES_PRELOAD := scsi_dh_alua scsi_dh_rdac
> +SCSI_DH_MODULES_PRELOAD :=
> +
> +
>  PKGCONFIG	?= pkg-config
>  
>  ifeq ($(TOPDIR),)
> diff --git a/multipath/Makefile b/multipath/Makefile
> index 015f73c..c930499 100644
> --- a/multipath/Makefile
> +++ b/multipath/Makefile
> @@ -29,11 +29,17 @@ install:
>  	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
>  	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
>  	$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5 $(DESTDIR)$(man5dir)
> +ifneq ($(SCSI_DH_MODULES_PRELOAD),)
> +	$(INSTALL_PROGRAM) -m 644 scsi_dh.conf $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
> +	for _x in $(SCSI_DH_MODULES_PRELOAD); do echo "$$_x"; done \
> +	    >>$(DESTDIR)$(modulesloaddir)/scsi_dh.conf
> +endif
>  
>  uninstall:
>  	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
>  	$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
>  	$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
> +	$(RM) $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
>  	$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
>  	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
>  	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

