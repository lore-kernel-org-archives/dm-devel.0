Return-Path: <SRS0=25Tj=P7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78329C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 20:22:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 15AF2610FC
	for <dm-devel@archiver.kernel.org>; Fri, 12 Nov 2021 20:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 15AF2610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-6SgXjF_-MUu8EnUhiX3jjg-1; Fri, 12 Nov 2021 15:22:35 -0500
X-MC-Unique: 6SgXjF_-MUu8EnUhiX3jjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CF84804140;
	Fri, 12 Nov 2021 20:22:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8437A5D9D3;
	Fri, 12 Nov 2021 20:22:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DB974E9F5;
	Fri, 12 Nov 2021 20:22:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ACKMOO5011740 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 12 Nov 2021 15:22:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AAE3E404727D; Fri, 12 Nov 2021 20:22:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A3D45404727C
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 20:22:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86514808784
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 20:22:24 +0000 (UTC)
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com
	[209.85.219.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-39-HvX70P_GNpyaP4eKeaMeqw-1; Fri, 12 Nov 2021 15:22:22 -0500
X-MC-Unique: HvX70P_GNpyaP4eKeaMeqw-1
Received: by mail-qv1-f51.google.com with SMTP id bu11so7114704qvb.0
	for <dm-devel@redhat.com>; Fri, 12 Nov 2021 12:22:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
	bh=w9eqrJ9pTzwfDDhXBL+mn2OBKCMAO1YmWc7f7WKQaPo=;
	b=UlqJIbg7kX4fsnBB5N2fgh9Rbq5lzl6E2crU4uE6VUTSwdfaqW3pnVqZzMp7j1hoRW
	xnVYiBsMAr/Xc9t/VBqrXq/k40GAzBvnWuDl2UOrkAUpS7nl2baA7hufjIWERvgrZlQu
	v56pWUDjxAdxKxaPWWVPwb9fJ6mEyDJsxY3axLLFEmqpc9OFR5Qxh28T7zLd575Rts1Y
	XmOKa2jMA9AkiBQGTs8zeYVfapT6WVEbGgGoGsjNJPA5B4wt29NIcet5qtk1LOl7tl5H
	+2fmzPdtdQVEFlbX5KKKtZqwxo/8P+5+uqVxjY8X5Aoe2qfsxvrq4Ac9E3KWC/JtQ7yq
	3CXQ==
X-Gm-Message-State: AOAM530pQnfpisFSn4Mb16XEoQkcNZJPWlv2CMQSo9qijFaWVfqhP1Xi
	8bFDVb4ZE5hdu07krO34AHRZKuATEpkVgnWmg+uJa7Rj
X-Google-Smtp-Source: ABdhPJxh18+qgzWJVBFCTbvOW95DJJ/2+1ZQGYMQsIS+aq9ZQHrw9YyHxkxePF6Dsilem7bRkTBZbjkYVltfp8ULa1A=
X-Received: by 2002:a05:6214:2427:: with SMTP id
	gy7mr17286969qvb.38.1636748542122; 
	Fri, 12 Nov 2021 12:22:22 -0800 (PST)
MIME-Version: 1.0
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 12 Nov 2021 14:22:11 -0600
Message-ID: <CAAMCDec=-Ypr6A+9jZCXXnkqAu07zh2LCRn7BQoCu4UgL8rH3Q@mail.gmail.com>
To: device-mapper development <dm-devel@redhat.com>
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
Subject: [dm-devel] Have tested dm-raid/lv mirroring with block guard on one
 leg but not the other, it fails to mirror the disk.
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I have tested dm-raid/lv mirroring and block guard on one leg but not
on the other and it initially seems to copy/mirror the device and then
random lv's start dropping the new block guard leg and set the refresh
attribute on the lv.   About this time we also start getting severe
filesystem corruption.  All that is being done is mirror the boot disk
to a SAN(block guard) lun and then split off that lun, and there is
breakage in the 10-30 minute window that takes.

I have tried on 2 vendor kernels and I have tried with fedora 35
(5.14.10-300) and all fail with similar overall results but slightly
different error messages in dmesg.

The redhat clone 7.9 kernel said this:  "tag#0 Add. Sense: Logical
block guard check failed", none of the other kernels had that good of
a message.   Fedora 35 got a DID_TRANSPORT_DISRUPTED and an io error
messages against a sector.    The other vendor kernel got basic IO
errors similar to what you get if you had a bad sector.

Any idea if it can be made to work?  Or made to refuse and error in lvm?

I have the commands used and /etc/lvm/archive/* entries for the device
and dmesg from the fedora kernel since it is almost a current
kernel.org kernel.   On  the vendor kernels we tried echo 0 to the
read_verify integrity entries on multipath and the underlying devices
and lvm seemed re-enable read_verify on the devices it built above the
devices it was disabled on when it was setting up/doing the mirroring,
we did not try that on the fedora kernel.

thoughts?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

