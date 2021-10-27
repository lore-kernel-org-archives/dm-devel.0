Return-Path: <SRS0=WDPk=PP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BC3C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 06:56:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C12A46109E
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 06:56:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C12A46109E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-YHLkjLTsNBqO4fqrewrILQ-1; Wed, 27 Oct 2021 02:56:02 -0400
X-MC-Unique: YHLkjLTsNBqO4fqrewrILQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65FA818125C1;
	Wed, 27 Oct 2021 06:55:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C462C57CAA;
	Wed, 27 Oct 2021 06:55:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12BDC1809C84;
	Wed, 27 Oct 2021 06:55:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19R6tqHe013988 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 02:55:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1B6E72026D46; Wed, 27 Oct 2021 06:55:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1754F2026D48
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 06:55:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D846801E8D
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 06:55:49 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-432-oIqJ9Z3qNHapir_UghnZdw-1; Wed, 27 Oct 2021 02:55:47 -0400
X-MC-Unique: oIqJ9Z3qNHapir_UghnZdw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mfcqd-0044Zu-OG; Wed, 27 Oct 2021 06:55:43 +0000
Date: Tue, 26 Oct 2021 23:55:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Message-ID: <YXj37wXtN0wQqwZx@infradead.org>
References: <20211022064748.30136-1-mark-pk.tsai@mediatek.com>
MIME-Version: 1.0
In-Reply-To: <20211022064748.30136-1-mark-pk.tsai@mediatek.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: tequila.yuang@mediatek.com, snitzer@redhat.com, yj.chiang@mediatek.com,
	linux-kernel@vger.kernel.org, dm-devel@redhat.com,
	linux-mediatek@lists.infradead.org, agk@redhat.com,
	matthias.bgg@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [dm-devel] [PATCH] dm: add module parameter bdev_wait
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

On Fri, Oct 22, 2021 at 02:47:47PM +0800, Mark-PK Tsai wrote:
> dm_early_create() fail if the target block device not found in
> the late init stage.
> The block device is created in mmc_rescan() which kernel do
> it async by queue it into system_freezable_wq.
> Add module param bdev_wait to support waiting the block device
> ready before dm_early_create() like prepare_namespace() does.

This adds a busy loop.  There is a reason why we usually set up
stacking drivers from userspace, in that we have a working event
system there.  So the answer is not to add further hacks to the
in-kernel DM setup hack, but to stop using it.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

