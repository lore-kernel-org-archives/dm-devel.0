Return-Path: <SRS0=SJ91=MM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1BDC07E95
	for <dm-devel@archiver.kernel.org>; Tue, 20 Jul 2021 11:44:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 062A46101E
	for <dm-devel@archiver.kernel.org>; Tue, 20 Jul 2021 11:44:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 062A46101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1626781465;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=wAX1UKc7GWlUaof7lDF9zLN6DF6J61Rcnjd8zMkhtfM=;
	b=TyZvF8sXyvxxMBsJk+NRLhaCVUWe10NywHOBF2rylyLwDRbHxu7l3Fm4wcCfWaEJ+Vlesf
	6WXYTMriuFza9aDQZ9lwcMgELFBGFR273r5eX7f1k3Rb3A/ooZslvsawK+avvPOUQGzlys
	asESEpd1zQxcoSwnlKJEowjrk/hWCsQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-FjBpP-AqOxisfovKbuydsA-1; Tue, 20 Jul 2021 07:44:24 -0400
X-MC-Unique: FjBpP-AqOxisfovKbuydsA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6601981C860;
	Tue, 20 Jul 2021 11:44:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBC9260BD8;
	Tue, 20 Jul 2021 11:44:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B00F14EA29;
	Tue, 20 Jul 2021 11:44:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16KBg0bY022526 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Jul 2021 07:42:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DBE4260CC9; Tue, 20 Jul 2021 11:42:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3C81784C9;
	Tue, 20 Jul 2021 11:41:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 16KBfwba021967; Tue, 20 Jul 2021 07:41:58 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 16KBfvNm021963; Tue, 20 Jul 2021 07:41:57 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Tue, 20 Jul 2021 07:41:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Pintu Agarwal <pintu.ping@gmail.com>
In-Reply-To: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
References: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: snitzer@redhat.com, Kernelnewbies <kernelnewbies@kernelnewbies.org>,
	open list <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	linux-mtd <linux-mtd@lists.infradead.org>, samitolvanen@google.com,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>, shli@kernel.org, agk@redhat.com
Subject: Re: [dm-devel] Kernel 4.14: Using dm-verity with squashfs rootfs -
 mounting issue
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
Content-Type: MULTIPART/MIXED;
	BOUNDARY="185206533-1311100962-1626781318=:19984"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
--185206533-1311100962-1626781318=:19984
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi

Try to set up dm-verity with block size 512 bytes.

I don't know what block size does squashfs use, but if the filesystem 
block size is smaller than dm-verity block size, it doesn't work.

Mikulas



On Tue, 20 Jul 2021, Pintu Agarwal wrote:

> Hi,
> 
> Our ARM32 Linux embedded system consists of these:
> * Linux Kernel: 4.14
> * Processor: Qualcomm Arm32 Cortex-A7
> * Storage: NAND 512MB
> * Platform: Simple busybox
> * Filesystem: UBIFS, Squashfs
> * Consists of nand raw partitions, squashfs ubi volumes.
> 
> My requirement:
> We wanted to use dm-verity at boot time to check the integrity of
> squashfs-rootfs before mounting.
> 
> Problem:
> dm-0 is not able to locate and mount the squash fs rootfs block.
> The same approach is working when emulating with ext4 but fails with squashfs.
> 
> Logs:
> [....]
> [    0.000000] Kernel command line: [...] verity="96160 12020
> d7b8a7d0c01b9aec888930841313a81603a50a2a7be44631c4c813197a50d681 0 "
> rootfstype=squashfs root=/dev/mtdblock34 ubi.mtd=30,0,30 [...]
> root=/dev/dm-0 dm="system none ro,0 96160 verity 1 /dev/mtdblock34
> /dev/mtdblock39 4096 4096 12020 8 sha256
> d7b8a7d0c01b9aec888930841313a81603a50a2a7be44631c4c813197a50d681
> aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7"
> [....]
> [    4.693620] vreg_conn_pa: disa▒[    4.700662] md: Skipping
> autodetection of RAID arrays. (raid=autodetect will force)
> [    4.700713] device-mapper: init: attempting early device configuration.
> [    4.708224] device-mapper: init: adding target '0 96160 verity 1
> /dev/mtdblock34 /dev/mtdblock39 4096 4096 12020 8 sha256
> d7b8a7d0c01b9aec888930841313a81603a50a2a7be44631c4c813197a50d681
> aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7'
> [    4.714979] device-mapper: verity: sha256 using implementation
> "sha256-generic"
> [    4.737808] device-mapper: init: dm-0 is ready
> [....]
> [    5.278103] No filesystem could mount root, tried:
> [    5.278107]  squashfs
> [    5.280477]
> [    5.287627] Kernel panic - not syncing: VFS: Unable to mount root
> fs on unknown-block(253,0)
> [...]
> 
> Not sure, why is it still locating block "253" here which seems like a
> MAJOR number ?
> 
> Working logs on ext4:
> [....]
> [    4.529822] v▒[    4.534035] md: Skipping autodetection of RAID
> arrays. (raid=autodetect will force)
> [    4.534087] device-mapper: init: attempting early device configuration.
> [    4.550316] device-mapper: init: adding target '0 384440 verity 1
> /dev/ubiblock0_0 /dev/ubiblock0_0 4096 4096 48055 48063 sha256
> a02e0c13afb31e99b999c64aae6f4644c24addbc58db5689902cc5ba0be2d15b
> aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7 10
> restart_on_corruption ignore_zero_blocks use_fec_from_device
> /dev/ubiblock0_0 fec_roots 2 fec_blocks 48443 fec_start 48443'
> [    4.572215] device-mapper: verity: sha256 using implementation
> "sha256-generic"
> [    4.610692] device-mapper: init: dm-0 is ready
> [    4.720174] EXT4-fs (dm-0): mounted filesystem with ordered data
> mode. Opts: (null)
> [    4.720438] VFS: Mounted root (ext4 filesystem) readonly on device 253:0.
> [    4.737256] devtmpfs: mounted
> [....]
> 
> Questions:
> a) Is dm-verity supposed to work on squashfs block devices ?
> b) Are there any known issues with dm-verity on Kernel 4.14 ?
> c) Are there any patches that we are missing ?
> 
> 
> Thanks,
> Pintu
> 
--185206533-1311100962-1626781318=:19984
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--185206533-1311100962-1626781318=:19984--

