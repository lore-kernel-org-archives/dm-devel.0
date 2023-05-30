Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C14CC7EE24
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 19:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685475822;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EYWMegiRydxsNbPE+xsMW/OfNqxP55bw/bH84BrrxF0=;
	b=eUZpu9bdnwIYlpuFhy9WW3lmHgKSz9wBdCLcq8ye5ApacLxmqgsT4k2oAob1ftNlJcg5az
	jHDbrgi2DFjxEU7307hjDHDScxuIRQ6I5g7A3tttLDm02ygWyOW1A/CP1lsdYf4ou/82P4
	EyT3OYo97V+A46FJ6lAhs4G3aNNyBzk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-5C34Wx5fPq6JHkmNfHzt7w-1; Tue, 30 May 2023 15:43:39 -0400
X-MC-Unique: 5C34Wx5fPq6JHkmNfHzt7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC44B811E88;
	Tue, 30 May 2023 19:43:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 08674112132C;
	Tue, 30 May 2023 19:43:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF32A19465A0;
	Tue, 30 May 2023 19:43:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AC28A1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 19:43:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 933C72166B29; Tue, 30 May 2023 19:43:34 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5346B2166B25;
 Tue, 30 May 2023 19:43:34 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 34UJhY4b022142; Tue, 30 May 2023 15:43:34 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 34UJhXMb022117; Tue, 30 May 2023 15:43:33 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 30 May 2023 15:43:33 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@kernel.org>
In-Reply-To: <ZHYbIYxGbcXbpvIK@redhat.com>
Message-ID: <alpine.LRH.2.21.2305301527410.18906@file01.intranet.prod.int.rdu2.redhat.com>
References: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
 <20230502101934.24901-17-johannes.thumshirn@wdc.com>
 <alpine.LRH.2.21.2305301045220.3943@file01.intranet.prod.int.rdu2.redhat.com>
 <ZHYbIYxGbcXbpvIK@redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v5 16/20] dm-crypt: check if adding pages to
 clone bio fails
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "axboe @ kernel . dk" <axboe@kernel.dk>, shaggy@kernel.org,
 damien.lemoal@wdc.com, kch@nvidia.com, agruenba@redhat.com, song@kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-raid@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, willy@infradead.org, ming.lei@redhat.com,
 cluster-devel@redhat.com, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-block@vger.kernel.org, rpeterso@redhat.com,
 linux-fsdevel@vger.kernel.org, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Tue, 30 May 2023, Mike Snitzer wrote:

> On Tue, May 30 2023 at 11:13P -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > I nack this. This just adds code that can't ever be executed.
> > 
> > dm-crypt already allocates enough entries in the vector (see "unsigned int 
> > nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;"), so bio_add_page can't 
> > fail.
> > 
> > If you want to add __must_check to bio_add_page, you should change the 
> > dm-crypt code to:
> > if (!bio_add_page(clone, page, len, 0)) {
> > 	WARN(1, "this can't happen");
> > 	return NULL;
> > }
> > and not write recovery code for a can't-happen case.
> 
> Thanks for the review Mikulas. But the proper way forward, in the
> context of this patchset, is to simply change bio_add_page() to
> __bio_add_page()
> 
> Subject becomes: "dm crypt: use __bio_add_page to add single page to clone bio"
> 
> And header can explain that "crypt_alloc_buffer() already allocates
> enough entries in the clone bio's vector, so bio_add_page can't fail".
> 
> Mike

Yes, __bio_add_page would look nicer. But bio_add_page can merge adjacent 
pages into a single bvec entry and __bio_add_page can't (I don't know how 
often the merging happens or what is the performance implication of 
non-merging).

I think that for the next merge window, we can apply this patch: 
https://listman.redhat.com/archives/dm-devel/2023-May/054046.html
which makes this discussion irrelevant. (you can change bio_add_page to 
__bio_add_page in it)

Mikukas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

