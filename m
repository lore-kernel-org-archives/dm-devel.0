Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B49EBC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 08:49:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-432-NxzsUtPuOw-pfYUXwG0cIQ-1; Tue, 23 Nov 2021 03:49:16 -0500
X-MC-Unique: NxzsUtPuOw-pfYUXwG0cIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C78C183DD0F;
	Tue, 23 Nov 2021 08:49:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40A9560862;
	Tue, 23 Nov 2021 08:49:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8EEA14A703;
	Tue, 23 Nov 2021 08:49:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN8n6W0001526 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 03:49:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CDB354047279; Tue, 23 Nov 2021 08:49:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9EFA4047272
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 08:49:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B16B3808784
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 08:49:06 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-584-KjbHnNp0PNyvO5SMXqRU5A-1; Tue, 23 Nov 2021 03:49:04 -0500
X-MC-Unique: KjbHnNp0PNyvO5SMXqRU5A-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1mpQT8-0015cU-Fv; Tue, 23 Nov 2021 07:43:58 +0000
Date: Mon, 22 Nov 2021 23:43:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <YZybvlheyLGAadFF@infradead.org>
References: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
MIME-Version: 1.0
In-Reply-To: <5d8351f1-1b09-bff0-02f2-a417c1669607@gmx.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, dm-devel@redhat.com,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] Any bio_clone_slow() implementation which doesn't
 share bi_io_vec?
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 23, 2021 at 02:44:32PM +0800, Qu Wenruo wrote:
> Hi,
> 
> Although there are some out-of-date comments mentions other
> bio_clone_*() variants, but there isn't really any other bio clone
> variants other than __bio_clone_fast(), which shares bi_io_vec with the
> source bio.
> 
> This limits means we can't free the source bio before the cloned one.
> 
> Is there any bio_clone variant which do a deep clone, including bi_io_vec?

There is no use case for that, unless the actual data changes like in
the bounce buffering code.

> That's why the bio_clone thing is involved, there is still some corner
> cases that we don't want to fail the whole large bio if there is only
> one stripe failed (mostly for read bio, that we want to salvage as much
> data as possible)
> 
> Thus regular bio_split() + bio_chain() solution is not that good here.
> 
> Any idea why no such bio_clone_slow() or bio_split_slow() provided in
> block layer?
> 
> Or really bio_split() + bio_chain() is the only recommended solution?

You can use bio_split witout bio_chain.  You just need your own
bi_end_io handler that first performs the action you want and then
contains code equivalent to __bio_chain_endio.  As a bonus you can
pint bi_private to whatever you want, it does not have to be the parent
bio, just something that allows you to find it.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

