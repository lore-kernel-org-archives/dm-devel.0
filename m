Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B85CEB64DC
	for <dm-devel@archiver.kernel.org>; Fri, 21 Jul 2023 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689947232;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LDb3mwfpuhTOfnvs94Vpv3QUsS3GIpy3ckrYt9EmX+Y=;
	b=gc9WcHagEHs3Rlgba4Cv3QxLz5w1RWOikKORt2XIhYP5frQPIZsyB+TcVKzrHYBdnR5lOC
	esR5dNf0jfLG/kxaowLylceLDACJ+r/uQh4BLWt0wGu90RAeikff8zOuDC7yecZRynEzOG
	fzSTMx2iM0T3aCEFiIV7C7S6ecS1Zxs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-3kQAeCCQPd26YkqUt2ZzjQ-1; Fri, 21 Jul 2023 09:47:09 -0400
X-MC-Unique: 3kQAeCCQPd26YkqUt2ZzjQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DB62936D25;
	Fri, 21 Jul 2023 13:47:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D4512492C13;
	Fri, 21 Jul 2023 13:47:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6A0431946A43;
	Fri, 21 Jul 2023 13:46:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C540D1946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Jul 2023 13:46:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 779681121315; Fri, 21 Jul 2023 13:46:43 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60B141121314;
 Fri, 21 Jul 2023 13:46:43 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 6773930C0457; Fri, 21 Jul 2023 13:46:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 659EC3FB76; Fri, 21 Jul 2023 15:46:36 +0200 (CEST)
Date: Fri, 21 Jul 2023 15:46:36 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
In-Reply-To: <ZLjJ6nU1YjlLD+Ay@infradead.org>
Message-ID: <e2277e5d-c9fe-b4a6-14fa-25926846aa4e@redhat.com>
References: <3fcf222-4894-992-ae81-c72ca983d82@redhat.com>
 <ZLjJ6nU1YjlLD+Ay@infradead.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 2/3] brd: enable discard
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
Cc: Jens Axboe <axboe@kernel.dk>, Li Nan <linan666@huaweicloud.com>,
 dm-devel@redhat.com, linux-block@vger.kernel.org,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Wed, 19 Jul 2023, Christoph Hellwig wrote:

> > +static void brd_free_page_rcu(struct rcu_head *head)
> > +{
> > +	struct page *page = container_of(head, struct page, rcu_head);
> > +	__free_page(page);
> 
> Nit: missing empty line here.  Although I see no point in the local
> variable anyay.
> 
> > +}
> > +
> > +static void brd_free_page(struct brd_device *brd, sector_t sector)
> > +{
> > +	struct page *page;
> > +	pgoff_t idx;
> > +
> > +	idx = sector >> PAGE_SECTORS_SHIFT;
> > +	page = xa_erase(&brd->brd_pages, idx);
> > +
> > +	if (page) {
> > +		BUG_ON(page->index != idx);
> > +		call_rcu(&page->rcu_head, brd_free_page_rcu);
> > +	}
> 
> Doing one call_rcu per page is horribly inefficient.  Please look into
> batching this up.
> 
> > +static bool discard = false;
> > +module_param(discard, bool, 0444);
> > +MODULE_PARM_DESC(discard, "Support discard");
> 
> Doing this as a global paramter that can't even be changed at run time
> does not feel very user friendly.

Hi

I addressed these issues and I'll send a new version.

Mikulas
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

