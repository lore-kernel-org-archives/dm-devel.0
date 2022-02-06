Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7F5C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  7 Feb 2022 09:34:14 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-ErK2MTmVPnurfwkh4eoHTw-1; Mon, 07 Feb 2022 04:34:11 -0500
X-MC-Unique: ErK2MTmVPnurfwkh4eoHTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 829371800D50;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6706078DD7;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3B87D4CA9B;
	Mon,  7 Feb 2022 09:34:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 216FGwGi015528 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 6 Feb 2022 10:16:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B6123400E116; Sun,  6 Feb 2022 15:16:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1F44400E42D
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 15:16:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 960881C04B6D
	for <dm-devel@redhat.com>; Sun,  6 Feb 2022 15:16:58 +0000 (UTC)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com
	[209.85.222.170]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-443-sB0I8gXEOciEKSOdb9J7pg-1; Sun, 06 Feb 2022 10:16:56 -0500
X-MC-Unique: sB0I8gXEOciEKSOdb9J7pg-1
Received: by mail-qk1-f170.google.com with SMTP id c189so8988592qkg.11
	for <dm-devel@redhat.com>; Sun, 06 Feb 2022 07:16:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
	bh=/7tFVCDtPUcRBivCA3mjRMw9Kt61zZCNuI6bNUgVmmM=;
	b=LiMHokR3G8+3m1LGrXUvDLKiqH2dwjhx9MNC39Q4otmYeyYsAL8WutgtIi4zEJum0m
	qRrda2TZ9VmxTchgetE3C7RSRTLbprKKlUmch4zlvdNrzLVkzRIgdU+rZ0yybmvsvHyy
	AKOvC/PzSZgJzDTxL07q3whUgDPmD6f2JkLdhMdciFiv2IRJoAhLG6emcoj0jcZNQ0hI
	yp3nTy52X4i0EPA984l7aykgn3HVdJ5e61yp/xiaCmdQJHdiHhlHadG4XAKDKIprBplz
	2Lpnq4pBDtA3fcVPppT8UqFCa2KcJ7qdNLwA3GQEM6hN3ilVhY4fWS9aefJb+jA9ynTJ
	xspw==
X-Gm-Message-State: AOAM530N/etromlmTegPu+9dFTsUvoJOYraiNf0lyKpMuM9Odj7OKoWu
	hrXHpPMYTpVJiizQ0jp61wSn+OGSb6KeyeTeZ93AO8nV52tKGQ==
X-Google-Smtp-Source: ABdhPJwHU9n8mrA3F2PKGABDb9pihcNFwXW5b21QLMuTN5ropcdkJaHh1sX2kx/1JrpHFyFeLvSp7kRlHAiE9EmA5WA=
X-Received: by 2002:a05:620a:298d:: with SMTP id
	r13mr4282372qkp.471.1644160615966; 
	Sun, 06 Feb 2022 07:16:55 -0800 (PST)
MIME-Version: 1.0
From: Aidan Walton <aidan.walton@gmail.com>
Date: Sun, 6 Feb 2022 16:16:20 +0100
Message-ID: <CAPx-8MP6zbPACu-HaYeBO8AqBwqxt4YQarSm6vaZHSApiQWX7Q@mail.gmail.com>
To: dm-devel@redhat.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 07 Feb 2022 04:33:18 -0500
Subject: [dm-devel] Can not remove device. No files open,
 no processes attached. Forced to reboot server.
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,
I've been chasing a problem now for a few weeks. I have a flaky SATA
controller that fails unpredictably and upon doing so all drives
attached are disconnected by the kernel. I have 2 discs on this
controller which are the components of a RAID1 array. mdraid fails the
disc (in its strange way) stating that one device is removed and the
other is active. Apparently this is the default mdraid approach. Even
though both devices are in fact failed. Regardless, the devmapper
device which is supporting an LVM logical volume on top of this raid
array, remains active. The logical volume is no longer listed by
lvdisplay, but dmsetup -c info shows:
Name                                Maj Min Stat Open Targ Event  UUID
storage.mx.vg2-shared_sun_NAS.lv1   253   2 L--w    1    1      0
LVM-Ud9pj6QE4hK1K3xiAFMVCnno3SrXaRyTXJLtTGDOPjBUppJgzr4t0jJowixEOtx7
storage.mx.vg1-shared_sun_users.lv1 253   1 L--w    1    1      0
LVM-ypcHlbNXu36FLRgU0EcUiXBSIvcOlHEP3MHkBKsBeHf6Q68TIuGA9hd5UfCpvOeo
ubuntu_server--vg-ubuntu_server--lv 253   0 L--w    1    1      0
LVM-eGBUJxP1vlW3MfNNeC2r5JfQUiKKWZ73t3U3Jji3lggXe8LPrUf0xRE0YyPzSorO

The device in question is 'storage.mx.vg2-shared_sun_NAS.lv1'

As can be seen is displays 'open'

however lsof /dev/mapper/storage.mx.vg2-shared_sun_NAS.lv1
<blank>

fuser -m /dev/storage.mx.vg1/shared_sun_users.lv1
<blank>

dmsetup status storage.mx.vg2-shared_sun_NAS.lv1
0 976502784 error

dmsetup remove storage.mx.vg2-shared_sun_NAS.lv1
device-mapper: remove ioctl on storage.mx.vg2-shared_sun_NAS.lv1
failed: Device or resource busy

dmsetup wipe_table storage.mx.vg2-shared_sun_NAS.lv1
device-mapper: resume ioctl on storage.mx.vg2-shared_sun_NAS.lv1
failed: Invalid argument


and so on. Nothing appears to be attached to this device but it
refuses to be removed. As a consequence I can not disable the mdraid
array and can not recover the controller. Which is possible by
resetting the pci slot.

Currently the only possible way I have to recover this problem is to
reboot the server.

Please see.
https://marc.info/?l=linux-raid&m=164159457011525&w=2

for the discussion regarding the same problem on the linux-raid mailing list.
No progress so far, help appreciated
Aidan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

