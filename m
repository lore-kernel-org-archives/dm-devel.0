Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E15FC77B7A
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685462344;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=l/ha+hS2/XbpJ1K6sDYxpc/VI8GAaTwwH/w6f0993aE=;
	b=eqW9+deVFp54qWIY+KPEOx3eaHtI4BXILiRb0HWz2jVU0Okxk99cThpg5YJGBuztexiZs1
	sBNcjOo7dqKv5HTwFckci4O3mq2mDoNtBCfWywsyfcbZSaI7ZMim5mQNWPNoRtESQ9unBL
	SOlIoy59ut2SdhfQtvyBnvLQNJ4gfl8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-JqYZ75-VOp6aB9BiZFrWVQ-1; Tue, 30 May 2023 11:59:02 -0400
X-MC-Unique: JqYZ75-VOp6aB9BiZFrWVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBDBB3825BA5;
	Tue, 30 May 2023 15:58:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D752240C6EC4;
	Tue, 30 May 2023 15:58:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0BAFB19465A0;
	Tue, 30 May 2023 15:58:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2FEF61946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 15:58:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 14889140EBD7; Tue, 30 May 2023 15:58:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D195140EBB8
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:58:40 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E693B185A7B6
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:58:39 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-218-bAPUZVrIOr6lRfyCfpI3gA-1; Tue,
 30 May 2023 11:58:38 -0400
X-MC-Unique: bAPUZVrIOr6lRfyCfpI3gA-1
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1q41jm-006QJo-VH; Tue, 30 May 2023 15:58:19 +0000
Date: Tue, 30 May 2023 16:58:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Message-ID: <ZHYdGlqnl922CDe0@casper.infradead.org>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <e809b83d60d9fb0f65a8116b3e50f1432f594725.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
In-Reply-To: <e809b83d60d9fb0f65a8116b3e50f1432f594725.1685461490.git.johannes.thumshirn@wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v6 19/20] fs: iomap: use __bio_add_folio
 where possible
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Song Liu <song@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
 gouhao@uniontech.com, Mike Snitzer <snitzer@kernel.org>,
 jfs-discussion@lists.sourceforge.net, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: infradead.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, May 30, 2023 at 08:49:22AM -0700, Johannes Thumshirn wrote:
> When the iomap buffered-io code can't add a folio to a bio, it allocates a
> new bio and adds the folio to that one. This is done using bio_add_folio(),
> but doesn't check for errors.
> 
> As adding a folio to a newly created bio can't fail, use the newly
> introduced __bio_add_folio() function.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

