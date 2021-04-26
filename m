Return-Path: <SRS0=wTOt=JX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4201C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:33:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F3A126135D
	for <dm-devel@archiver.kernel.org>; Mon, 26 Apr 2021 15:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3A126135D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1619451229;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iT32Ff8tJNH4azoiq7IJy5+EX41hAxxXsMhx851N7Do=;
	b=d8Ctrtd2bpMvG2ZN1PSJ5DoHFFEzXuVaCqOL9joEPE9yEy1fvKSeBzCcBGykYlSaRBvXdf
	BIsKuzr8CBYvB6+LbWJ1nnO6slL+oIPt5WLn1h82uqI+PCJjbZ+6EWO0nzU5mXPYI7h2CJ
	B8YTVYkbRihGOqBOr5MBIniqqS2ce9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-Kr64y70SOMOCSc-xvpKgJQ-1; Mon, 26 Apr 2021 11:33:47 -0400
X-MC-Unique: Kr64y70SOMOCSc-xvpKgJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C9F8114;
	Mon, 26 Apr 2021 15:33:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C0EE45C1CF;
	Mon, 26 Apr 2021 15:33:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0985C1806D1A;
	Mon, 26 Apr 2021 15:33:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13QFXXek029224 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Apr 2021 11:33:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D5BC05D71F; Mon, 26 Apr 2021 15:33:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B384E5D6BA;
	Mon, 26 Apr 2021 15:33:33 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 13QFXXhr025108; Mon, 26 Apr 2021 11:33:33 -0400
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 13QFXW0h025104; Mon, 26 Apr 2021 11:33:33 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Mon, 26 Apr 2021 11:33:32 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Melvin Vermeeren <vermeeren@vermwa.re>
In-Reply-To: <4219669.2KqOsUsilv@verm-r4e>
Message-ID: <alpine.LRH.2.02.2104261124360.24039@file01.intranet.prod.int.rdu2.redhat.com>
References: <4219669.2KqOsUsilv@verm-r4e>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] Integrity discard/trim extremely slow on NVMe SSD
 storage (~10GiB/minute)
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Mon, 19 Apr 2021, Melvin Vermeeren wrote:

> Note: This was originally posted on cryptsetup GitLab.
> Note: Reposting here for better visibility as it appears to be a kernel bug.
> Ref: https://gitlab.com/cryptsetup/cryptsetup/-/issues/639
> 
> Issue description
> -----------------
> 
> With a Seagate FireCuda 520 2TB NVMe SSD running in PCIe 3.0 x4 mode (my 
> motherboard does not have PCIe 4.0), discards through `dm-integrity` 
> layer are extremely slow to the point of being almost unusable or in 
> some cases fully unusable.
> 
> This is so slow that having the `discard` option on swap in not 
> possible, as it takes around 3 minutes to complete for 32GiB swap 
> causing timeouts during boot which in turn causes various other services 
> to fail resulting in a drop to the emergency shell.
> 
> `blkdiscard` directly to NVMe device takes I think 10 sec or so for the 
> entire 2TB, but through `dm-integrity` the rate is approx 10GiB per 
> minute, meaning over 3 hours to discard the entire 2TB. Normal read and 
> write operations are not affected and are high performance, easily 
> reaching 2GiB/s through the entire layer: `disk dm-integrity mdadm luks 
> lvm ext4`.
> 
> Checking the kernel thread usage in htop quite some 
> `dm-integrity-offload` threads are in the `D` state with `0.0` CPU usage 
> when discarding, which is rather odd. No integrity threads are actually 
> working and read-write disk usage measured with `dstat` is not even 
> 1MiB/s.
> 
> To detail the above, `dstat` shows extremely clear timings: 2 seconds 0k 
> write, 1 second 512k write, repeat. Possible timeout in locks somewhere 
> or other problematic lock situation?
> 
> Steps for reproducing the issue
> -------------------------------
> 
> 1. Create two 10G partitions on SSD.
> 2. Setup `dm-integrity` on one of these and open the device with `--allow-
> discards`.
> 3. `blkdiscard` both partitions.
> 	* Raw partition is done instantly.
> 	* Integrity partition takes around a minute.
> 
> Additional info
> ---------------
> 
> The NVMe device is formatted to native 4096 byte sectors and the `dm-
> integrity` layer also uses 4096 byte sectors.
> 
> Debian bullseye (testing), kernel 5.10.0-6-rt-amd64 5.10.28-1. Same issue 
> occurred during testing with Arch Linux liveiso which is kernel 5.11.x. 
> Cryptsetup package version 2.3.5.
> 
> On another server system (IBM POWER9, ppc64le) with SAS 3.0 SSD discard is 
> working properly at more than acceptable speeds, showing significant CPU usage 
> while discarding. In this case it is a regular Intel amd64 desktop system.
> 
> Debug log
> ---------
> 
> Nothing really fails, dmesg and syslog show no issues/warnings at all, not 
> sure what to include.
> 
> Only appears to effect NVMe
> ---------------------------
> 
> Further tests on the same machine show that SATA SSD is not affected by this 
> issue and discards at high performance. Appears to be NVMe-specific bug:
> Ref: https://gitlab.com/cryptsetup/cryptsetup/-/issues/639#note_555208783

I tried it on my nvme device (Samsung SSD 960 EVO 500GB) and I could 
discard 32GB in 5 seconds.

I assume that it is specific to the nvme device you are using. The device 
is perhaps slow due to a mix of dicard+read+write requests that 
dm-integrity generates.

> If there is anything I can do to help feel free to let me know.
> Note that I am not subscribed to dm-level, please CC me directly.
> 
> Thanks,

Could you try it on other nvme disks?

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

