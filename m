Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93388ECAAD8
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663948477;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=G5cMqPo/nMcNsdthp4GqT8Fdv8g8Cq9Na6suuHNNVwI=;
	b=bR6Zi4CHrJXaMvwMUSN+Di5v22VEUesHx/+8AvgcJLdLUrOCSceQBjFONKD+FzH4AqgQVY
	8jskaXnWta2JTZNh8bfL50KxaC5tV11OS0ZdKHzl9w5ClFQtVG9Lx5q99SE2SWRzAGgDfo
	fQFuKE8pEbT5FWtb0M482BAvcuU4UWA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-uRvohUvaNUGA3Fh2tqeQNw-1; Fri, 23 Sep 2022 11:54:33 -0400
X-MC-Unique: uRvohUvaNUGA3Fh2tqeQNw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC551811728;
	Fri, 23 Sep 2022 15:54:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CB1CA492B04;
	Fri, 23 Sep 2022 15:54:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A510619465B6;
	Fri, 23 Sep 2022 15:54:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B1FD319465B6
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 15:54:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6DB19C15BA4; Fri, 23 Sep 2022 15:54:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 66964C15BA5
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 15:54:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26F3C811728
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 15:54:25 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-216-D9nTRa-0On6V8rSciKiIUw-1; Fri, 23 Sep 2022 11:54:21 -0400
X-MC-Unique: D9nTRa-0On6V8rSciKiIUw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1obl0N-004tsH-20; Fri, 23 Sep 2022 15:54:19 +0000
Date: Fri, 23 Sep 2022 08:54:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <Yy3Wq2Hnb8KEbyb3@infradead.org>
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209201358580.26535@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2209201358580.26535@file01.intranet.prod.int.rdu2.redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 4/4] brd: implement secure erase and write
 zeroes
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 dm-devel@redhat.com, linux-block@vger.kernel.org,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Sep 20, 2022 at 01:59:46PM -0400, Mikulas Patocka wrote:
> This patch implements REQ_OP_SECURE_ERASE and REQ_OP_WRITE_ZEROES on brd.
> Write zeroes will free the pages just like discard, but the difference is
> that it writes zeroes to the preceding and following page if the range is
> not aligned on page boundary. Secure erase is just like write zeroes,
> except that it clears the page content before freeing the page.

So while I can see the use case for the simple discard you mentioned,
and maybe even the WRITE_ZEROES, I'd rather have a really good
justification for REQ_OP_SECURE_ERASE.  It is a bad interface,
and there are alsmost no good reasons for ever using it.  So sprinkling
it in random drivers just we can is not helpful.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

