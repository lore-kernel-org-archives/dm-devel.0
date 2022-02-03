Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5289C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  3 Feb 2022 00:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643849145;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hJ9xf/Ht5Df0Qn7WFKURDql+zqMnEjAbAdYJC+VUa1Y=;
	b=Bc3yHDahTRjRVceWiar0NLm4VSuY2LqImos52SmLkpVHMEBzcalhxuKgd2N/bWO3Crv+9w
	oNxrAG8yFXuje+LeADBItVvHIb5rck7+m7EyCXK9IVv4HpOgGHurDUnCh2cv0BSvx+dd2h
	Lc8N2suc3RSNPonA64xjmy+8TDfrDMY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-PDrs-vAtMWO5rGxGGwmVdw-1; Wed, 02 Feb 2022 19:45:44 -0500
X-MC-Unique: PDrs-vAtMWO5rGxGGwmVdw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A694F1091DA1;
	Thu,  3 Feb 2022 00:45:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8789610495B0;
	Thu,  3 Feb 2022 00:45:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 62DF61806D2C;
	Thu,  3 Feb 2022 00:45:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2130el3X003703 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 19:40:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2925A5E4AC; Thu,  3 Feb 2022 00:40:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A3C95E4B0;
	Thu,  3 Feb 2022 00:40:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2130eahn027456; 
	Wed, 2 Feb 2022 18:40:36 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2130eabJ027455;
	Wed, 2 Feb 2022 18:40:36 -0600
Date: Wed, 2 Feb 2022 18:40:36 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220203004036.GU24684@octiron.msp.redhat.com>
References: <20220201234024.27675-1-mwilck@suse.com>
	<20220201234024.27675-7-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220201234024.27675-7-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 6/6] README.md: add basic information about
 building multipath-tools
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 02, 2022 at 12:40:24AM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  README.md | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
> 
> diff --git a/README.md b/README.md
> index b15c265..1547862 100644
> --- a/README.md
> +++ b/README.md
> @@ -52,6 +52,62 @@ To get latest devel code:
>  Github page: https://github.com/opensvc/multipath-tools
>  
>  
> +Building multipath-tools
> +========================
> +
> +Prerequisites: development packages of for `libdevmapper`, `libreadline`,
> +`libaio`, `libudev`, `libjson-c`, `liburcu`, and `libsystemd`.
> +
> +To build multipath-tools, type:
> +
> +    make
> +	make DESTDIR="/my/target/dir" install
> +
> +To uninstall, type:
> +
> +    make uninstall
> +
> +Customizing the build
> +---------------------
> +
> +The following variables can be passed to the `make` command line:
> +
> + * `ENABLE_LIBDMMP=0`: disable building libdmmp
> + * `ENABLE_DMEVENTS_POLL=0`: disable support for the device-mapper event
> +   polling API. For use with pre-5.0 kernels that don't supprt dmevent polling
> +   (but even if you don't use this option, multipath-tools will work with
> +   these kernels).
> + * `SCSI_DH_MODULES_PRELOAD="(list)"`: specify a space-separated list of SCSI
> +   device handler kernel modules to load early during boot. Some
> +   multipath-tools functionality depends on these modules being loaded
> +   early. This option causes a *modules-load.d(5)* configuration file to be
> +   created, thus it depends on functionality provided by *systemd*.
> +   This variable only matters for `make install`.
> +
> +Note: The usefulness of the preload list depends on the kernel configuration.
> +It's especially useful if `scsi_mod` is builtin but `scsi_dh_alua` and
> +other device handler modules are built as modules. If `scsi_mod` itself is compiled
> +as a module, it might make more sense to use a module softdep for the same
> +purpose.
> +
> +See `Makefile.inc` for additional variables to customize paths and compiler
> +flags.
> +
> +Special Makefile targets
> +------------------------
> +
> +The following targets are intended for developers only.
> +
> + * `make test` to build and run the unit tests
> + * `make valgrind-test` to run the unit tests under valgrind
> + * `make abi` to create an XML representation of the ABI of the libraries in
> +   the `abi/` subdirectory
> + * `make abi-test` to compare the ABI of a different multipath-tools version,
> +   which must be stored in the `reference-abi/` subdirectory. If this test
> +   fails, the ABI has changed wrt the reference.
> + * `make compile-commands.json` to create input for [clangd](https://clangd.llvm.org/).
> +
> +
>  Add storage devices
>  ===================
>  
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

