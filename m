Return-Path: <SRS0=qn2S=JC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 338FCC433ED
	for <dm-devel@archiver.kernel.org>; Mon,  5 Apr 2021 21:48:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 440D7611EE
	for <dm-devel@archiver.kernel.org>; Mon,  5 Apr 2021 21:48:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 440D7611EE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=stevenwalter.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-FSa59yB4POabpHt9dl-d9A-1; Mon, 05 Apr 2021 17:48:46 -0400
X-MC-Unique: FSa59yB4POabpHt9dl-d9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE7A6107ACCA;
	Mon,  5 Apr 2021 21:48:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF2802B1AB;
	Mon,  5 Apr 2021 21:48:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 844FF4A7C8;
	Mon,  5 Apr 2021 21:48:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 135LmWOn018502 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 5 Apr 2021 17:48:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BB7B82166BB3; Mon,  5 Apr 2021 21:48:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B50C12166BA4
	for <dm-devel@redhat.com>; Mon,  5 Apr 2021 21:48:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D8F585A5A8
	for <dm-devel@redhat.com>; Mon,  5 Apr 2021 21:48:30 +0000 (UTC)
Received: from mail-41103.protonmail.ch (mail-41103.protonmail.ch
	[185.70.41.103]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-447-DqGtH5SUMDWgsJhguOelHg-1; Mon, 05 Apr 2021 17:48:27 -0400
X-MC-Unique: DqGtH5SUMDWgsJhguOelHg-1
Received: from mail-03.mail-europe.com (mail-03.mail-europe.com
	[91.134.188.129])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	by mail-41103.protonmail.ch (Postfix) with ESMTPS id 4FDkYR62hnz4x1d5
	for <dm-devel@redhat.com>; Mon,  5 Apr 2021 21:38:35 +0000 (UTC)
Date: Mon, 05 Apr 2021 21:38:15 +0000
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
From: Steven Walter <steven@stevenwalter.org>
Message-ID: <qht-GXTFAoALDkOdy7P1N_r7btdiZCXcMViG6BJemvQosZP-eMW7rUNTO4D4dDWb8fGe416U2PUYTvdFNftD2J2bcsiaiWZXVZnQxdTnzXo=@stevenwalter.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 135LmWOn018502
X-loop: dm-devel@redhat.com
Subject: [dm-devel] dm-init.c: boot up race with partitions
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
Reply-To: Steven Walter <steven@stevenwalter.org>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I am using the dm-mod.create kernel command line parameter to create a verity device at boot.  Both the data device and hash device are partitions on an eMMC device.  Seemingly at random, the verity device fails to be created at boot because dm_init_init() (and wait_for_device_probe()) returned before the partitions had been scanned:

mmc1: new high speed MMC card at address 0001
device-mapper: table: 253:0: verity: Data device lookup failed
device-mapper: ioctl: error adding target to table
mmcblk1: mmc1:0001 064G30 58.2 GiB
mmcblk1boot0: mmc1:0001 064G30 partition 1 4.00 MiB
mmcblk1boot1: mmc1:0001 064G30 partition 2 4.00 MiB
mmcblk1rpmb: mmc1:0001 064G30 partition 3 4.00 MiB, chardev (247:0)
 mmcblk1: p1 p2 p3 p4 p5 p6 p7

I don't see how wait_for_device_probe() knows when partition scanning has been completed.  Is this a race or am I missing something?
--
- Steven Walter <steven@stevenwalter.org>
Sent from ProtonMail, encrypted email based in Switzerland.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

