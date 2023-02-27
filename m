Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E88C64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Feb 2023 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677510338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y3jbJaGj/34JpcFq5TYP3AAW4ol/fgwwfXhCtKqpEW4=;
	b=ftDAeuWy899jvBy0fluHQKaoUWXc4BvoJH59SzbD3R70985XGosv3nMU1uJWGh8Q0E5/co
	lbVwMdFhxmGPR1lNb2cAzdmEv/++zhUcsuXAH7aOWtYdNQDqN/i5buPLEZaXvx4k+fA0jn
	1qVJx8DisLc/ENOIK6msby3rJsvAh/U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-6DCQNRiaNy-_uLcII2dxVQ-1; Mon, 27 Feb 2023 10:05:34 -0500
X-MC-Unique: 6DCQNRiaNy-_uLcII2dxVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0FAA81D9EB;
	Mon, 27 Feb 2023 15:05:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4387A2026D76;
	Mon, 27 Feb 2023 15:05:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E21E9194658D;
	Mon, 27 Feb 2023 15:05:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3B0DC1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Feb 2023 15:05:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 13DBA1121314; Mon, 27 Feb 2023 15:05:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C64F1121315
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 15:05:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43B051991C6D
 for <dm-devel@redhat.com>; Mon, 27 Feb 2023 15:04:36 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-418-WcWQb6bHMcOwbCUr-Rb_FA-1; Mon, 27 Feb 2023 10:04:24 -0500
X-MC-Unique: WcWQb6bHMcOwbCUr-Rb_FA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1pWegM-00A1Fj-Kn; Mon, 27 Feb 2023 14:40:50 +0000
Date: Mon, 27 Feb 2023 06:40:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Uday Shankar <ushankar@purestorage.com>
Message-ID: <Y/zA8v/xUYtC6Iu0@infradead.org>
References: <20230222185224.2484590-1-ushankar@purestorage.com>
 <Y/Zp8lb3yUiPUNBv@kbusch-mbp.dhcp.thefacebook.com>
 <20230223193446.GA2719882@dev-ushankar.dev.purestorage.com>
MIME-Version: 1.0
In-Reply-To: <20230223193446.GA2719882@dev-ushankar.dev.purestorage.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2] blk-mq: enforce op-specific segment
 limits in blk_insert_cloned_request
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
 kernel test robot <lkp@intel.com>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Keith Busch <kbusch@kernel.org>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 23, 2023 at 12:34:46PM -0700, Uday Shankar wrote:
> I chose to add blk_queue_get_max_segments as a public function because
> it parallels blk_queue_get_max_sectors. If you don't want two functions,
> I could manually inline the (2) uses of blk_rq_get_max_segments(rq),
> converting them to blk_queue_get_max_segments(rq->q, req_op(rq)).

I'd be much happier with a single function that takes a request instead
of two decoded arguments.  This should not be a public API in any form.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

