Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA8EC64E8A
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 14:48:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A0D7F207FF
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 14:48:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0D7F207FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-izr7cL69O3mrY_UYZp4nFg-1; Mon, 30 Nov 2020 09:48:43 -0500
X-MC-Unique: izr7cL69O3mrY_UYZp4nFg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D6A5612AA;
	Mon, 30 Nov 2020 14:48:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 443235C1A1;
	Mon, 30 Nov 2020 14:48:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 37945180954D;
	Mon, 30 Nov 2020 14:48:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUEmXg3018801 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 09:48:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 09B322166B2D; Mon, 30 Nov 2020 14:48:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0537E2166B2C
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:48:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96FC01875045
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 14:48:30 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-593-kf1Eh7a1NYyXvxDzY5QhZQ-1; Mon, 30 Nov 2020 09:48:28 -0500
X-MC-Unique: kf1Eh7a1NYyXvxDzY5QhZQ-1
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red
	Hat Linux)) id 1kjkTa-0002M9-6L
	for dm-devel@redhat.com; Mon, 30 Nov 2020 14:48:26 +0000
Date: Mon, 30 Nov 2020 14:48:26 +0000
From: Matthew Wilcox <willy@infradead.org>
To: dm-devel@redhat.com
Message-ID: <20201130144826.GC4327@casper.infradead.org>
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
X-loop: dm-devel@redhat.com
Subject: [dm-devel] Slow write speeds on new laptop
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I just got a Tiger Lake based laptop and installed Debian on it with
dm-crypt.  The installer attempts to write zeroes to the encrypted partition
in order to prevent various metadata attacks (using blockdev-wipe [1])

After about eight hours with it not even halfway, I aborted this attempt.
The drive is about a terabyte in size, so that's around 15MB/s.  This
is atrocious!  cryptsetup benchmark says the CPU is capable of doing
4GB/s with aes-xts and a 512b key.  The cipher in use is reported as
aes-xts-plain64.

dd iflag=direct of=/dev/null bs=64k count=100000 gives some pretty poor
results.  with if=/dev/nvme0n1p3, I get 1.2GB/s.  with if=/dev/dm-0,
I get 600MB/s.

I found this critique of the dm-crypt architecture:
https://blog.cloudflare.com/speeding-up-linux-disk-encryption/
I'm using Linux 5.9, and I'm not sure how much of this has been incorporated.

[1] https://salsa.debian.org/installer-team/partman-crypto/-/blob/master/blockdev-wipe/blockdev-wipe.c

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

