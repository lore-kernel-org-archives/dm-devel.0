Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4638C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  8 Feb 2022 22:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644359783;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OVZrshln6Tvij79JXCy9HlSV83EoVEGmbALTyZG/4pY=;
	b=P11P/c98BUEttD9HsCIywtHJDI9a4euEExPkagFXXeYOqMesYaWMRJXoLOm8J94pGyE+Q6
	s62U2BydqeYFfvxukqoiu7JalGCHiJ0d32y5Z1b5zFQf2ZvJCzViF2a6DHsErztoKslQlC
	3sY4+uNTUgx1n3UHDec644cJIN3/yBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-oMOsc42uMe-cs00MGVi3Yw-1; Tue, 08 Feb 2022 17:34:52 -0500
X-MC-Unique: oMOsc42uMe-cs00MGVi3Yw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE243107B115;
	Tue,  8 Feb 2022 22:34:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4012610F3;
	Tue,  8 Feb 2022 22:34:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AC80F5E8B9;
	Tue,  8 Feb 2022 22:34:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 217LGsNE009126 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 7 Feb 2022 16:16:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C900C4BC52; Mon,  7 Feb 2022 21:16:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4371F6AB95;
	Mon,  7 Feb 2022 21:16:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 217LGgAn024980; 
	Mon, 7 Feb 2022 15:16:42 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 217LGgsZ024979;
	Mon, 7 Feb 2022 15:16:42 -0600
Date: Mon, 7 Feb 2022 15:16:41 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20220207211641.GA24684@octiron.msp.redhat.com>
References: <20220207171819.7091-1-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20220207171819.7091-1-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] kpartx.rules: skip MD devices
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 07, 2022 at 06:18:19PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> With the mdadm metadata format v1.0 (and DDF), the MD superblock is at the end
> of the device, keeping the partition table at the beginning. This may cause
> wrong partition mappings to be created by kpartx on RAID component devices.
> 
> So far I've only seen ugly error messages, but at least in principle it can
> happen that kpartx wins a race with MD, and prevents correct setup of the
> MD device.
> 
> Sample error messages:
> 
> [    4.029490] systemd-udevd[445]: dm-0: '/sbin/kpartx -un -p -part /dev/dm-0'(err) 'device-mapper: reload ioctl on 3600140508dbcf02acb448188d73ec97d-part1  failed: Device or resource busy'
> [    4.075666] kernel: device-mapper: table: 254:1: linear: Device lookup failed
> [    4.075945] kernel: device-mapper: ioctl: error adding target to table
> 
> Skip creating partition mappings on MD components.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/kpartx.rules | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
> index d7527d7..1969dee 100644
> --- a/kpartx/kpartx.rules
> +++ b/kpartx/kpartx.rules
> @@ -12,6 +12,9 @@ ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}=="1", GOTO="kpartx_end"
>  # Create dm tables for partitions on multipath devices.
>  ENV{DM_UUID}!="mpath-?*", GOTO="mpath_kpartx_end"
>  
> +# Ignore RAID members
> +ENV{ID_FS_TYPE}=="linux_raid_member|isw_raid_member|ddf_raid_member", GOTO="mpath_kpartx_end"
> +
>  # DM_SUBSYSTEM_UDEV_FLAG1 is the "skip_kpartx" flag.
>  # For events not generated by libdevmapper, we need to fetch it from db:
>  # - "change" events with DM_ACTIVATION!="1" (e.g. partition table changes)
> -- 
> 2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

