Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8A2C433E6
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 68423206A4
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:04:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68423206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609787043;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/SpIhlmb83gG+pEIJoHLvXS5iQQki6CjlDuEnKXKXao=;
	b=DNvr02CkphO3FUfkd6Wq06WsMEdYgk26iGedqGbDK99Lf7KMUWltHPBorsMzC1A9nBVjzq
	KzSMtxzbuOgGL+VAS9bMzn0+qaVmdgWaGHzgqYmRlu3umYRF3lDqWr3tId2SQT8aeZXaqZ
	tOxQmebwxARmXdI5Tt9I0FV423ZEoMs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-DVDLDWDBPU2SwKwfaI64qQ-1; Mon, 04 Jan 2021 14:03:39 -0500
X-MC-Unique: DVDLDWDBPU2SwKwfaI64qQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C26781842156;
	Mon,  4 Jan 2021 19:03:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A37EF100239A;
	Mon,  4 Jan 2021 19:03:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 797A31809CA7;
	Mon,  4 Jan 2021 19:03:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BLFns5j007028 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 21 Dec 2020 10:49:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 446ED5B697; Mon, 21 Dec 2020 15:49:54 +0000 (UTC)
Received: from pick.fieldses.org (ovpn-112-93.phx2.redhat.com [10.3.112.93])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 145245B695
	for <dm-devel@redhat.com>; Mon, 21 Dec 2020 15:49:50 +0000 (UTC)
Received: by pick.fieldses.org (Postfix, from userid 2815)
	id 85CA31218D4; Mon, 21 Dec 2020 10:49:49 -0500 (EST)
Date: Mon, 21 Dec 2020 10:49:49 -0500
From: "J. Bruce Fields" <bfields@redhat.com>
To: dm-devel@redhat.com
Message-ID: <20201221154949.GA305202@pick.fieldses.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 04 Jan 2021 14:03:12 -0500
Subject: [dm-devel] writecache performance, nfs export, optane
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I'm experimenting with dm-writecache with one of the little 16G optane
SSDs as the cache device in front of a couple hard drives and it's not
helping, and I'm curious why not.

My test is just to NFS-export the hard drive and the run

	time tar -xzvf ~/linux-5.9.tar.gz

from an NFS client.  (So it's reading from local disk and writing to
NFS.)

NFS servers aren't allowed to reply to clients until operations reach
stable storage, for metadata operations like create, unlink, rename, or
setattr, so this is kind of a worst case: untar of a kernel tree to
local filesystem takes me 12 seconds, but nearly 2 hours to exported
hard drives, as that untar is a single thread that ends up waiting for
hundreds of thousands of seeks.

If I just export the optane, total time is about 4 minutes.  If I export
a dm-writecache device using the optane, it's back to 2 hours.

For now I'm using an xfs filesystem with external journal on the optane,
which is sort of OK (about 15 minutes on this test), but I'm curious why
dm-writecache is acting like this.

Is this expected?  Are there any statistics I should be watching to
understand what's going on?

I'm pretty ignorant here, so it's also possible I just misconfigured
something somehow.  I set it up with just "lvconvert --type writecache
--cachevol optane export", and haven't tried tweaking any options.  I'm
on recent Fedora (with kernel-5.9.14-200.fc33.x86_64).

--b.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

