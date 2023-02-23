Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A39C61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 23 Feb 2023 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677180899;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jbX8Ro+o6BSUyGCj3jyy0V6HOv/TAokdr0Y2BgT9uLk=;
	b=VuOiZyBNZ6pvskQdRBli6cXRZppNUZGGYFTmYv7Q5a5R3r0zPY57wNmNJkR4QNSo7T5Dfk
	QUYNodR7QHKJPf11wzGhubKnTBosLqqws0L1N4B4kAmaIcOskqJ2XqyH6u49lipKIUnsFi
	ATHgFCC3N/QuwsWjSXzKCTnBCjI+Aiw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-M5wPdv3ZOoKyt2wK4dpnZA-1; Thu, 23 Feb 2023 14:34:55 -0500
X-MC-Unique: M5wPdv3ZOoKyt2wK4dpnZA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98E222A59544;
	Thu, 23 Feb 2023 19:34:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 65956492C3E;
	Thu, 23 Feb 2023 19:34:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4160419465B1;
	Thu, 23 Feb 2023 19:34:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 936CE19465A0
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Feb 2023 19:34:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 74304492B01; Thu, 23 Feb 2023 19:34:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CC60492C3E
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 19:34:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D74C1C05140
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 19:34:50 +0000 (UTC)
Received: from mail-oa1-f98.google.com (mail-oa1-f98.google.com
 [209.85.160.98]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-631-5c0MLNJ3NnSw3ktGgJsiag-1; Thu, 23 Feb 2023 14:34:48 -0500
X-MC-Unique: 5c0MLNJ3NnSw3ktGgJsiag-1
Received: by mail-oa1-f98.google.com with SMTP id
 586e51a60fabf-172094e10e3so16766105fac.10
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 11:34:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=b+c2IfHe67RI0XefnY3u42o+VPQ002zoityzko4BWLI=;
 b=W9tCdEbOYcIqAOyqt5PKwWq0auiz/jCyB9B5zZNQE2tFUEwhrBWnGT9rrdSuWLJtFl
 YdQlcwkRt5VS5lWPkObWV5WiwNuc3awQtD0INQ/PYqzmox89/Pca4n1EAMqs8DaOlUxs
 T8tV3VVqj4D555rfDrEmFmvCk1WhFYxVFIOe1U7kI3QTqB3aoF40xBvnrFSOqjNUPtka
 HtwvMQqO3u4i1sHXWxxZwkgsrnfbRavfLHfq1TujQe2/QGEFKjbVfIHkLE6mXKmYioYC
 eWdXr6NzCgcvKDW9CB+aXX+hPgj8r2MxJmKOHZsoWaqa2hQMcXYhrC3Ztx09Tw0OdD5H
 P0wg==
X-Gm-Message-State: AO0yUKV+1zH0EGgPvgfKVlz6ygFdMCrFJaPE83D2+CODq8AaBbUQ2rGg
 lTfVJqIE7e6PJM65c/lwvzMkMctfgDw0sievDShyeW+mLov7HKUie5aUZXJQHyK74A==
X-Google-Smtp-Source: AK7set9PnjCf3GmfWDCQz9R/1hGHmAu9w8Sm4q1irgE0/9e5vH/L0rOTLxgVJMt8XfRFT85U1rogPS2Hiyi7
X-Received: by 2002:a05:6871:10f:b0:169:bcbb:77b0 with SMTP id
 y15-20020a056871010f00b00169bcbb77b0mr9828238oab.25.1677180887488; 
 Thu, 23 Feb 2023 11:34:47 -0800 (PST)
Received: from c7-smtp.dev.purestorage.com ([2620:125:9007:320:7:32:106:0])
 by smtp-relay.gmail.com with ESMTPS id
 w21-20020a056870a2d500b0017280f7d61asm253278oak.18.2023.02.23.11.34.47
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Thu, 23 Feb 2023 11:34:47 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com
 (dev-ushankar.dev.purestorage.com [IPv6:2620:125:9007:640:7:70:36:0])
 by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id CF3F020B59;
 Thu, 23 Feb 2023 12:34:46 -0700 (MST)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
 id CB2FCE41429; Thu, 23 Feb 2023 12:34:46 -0700 (MST)
Date: Thu, 23 Feb 2023 12:34:46 -0700
From: Uday Shankar <ushankar@purestorage.com>
To: Keith Busch <kbusch@kernel.org>
Message-ID: <20230223193446.GA2719882@dev-ushankar.dev.purestorage.com>
References: <20230222185224.2484590-1-ushankar@purestorage.com>
 <Y/Zp8lb3yUiPUNBv@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
In-Reply-To: <Y/Zp8lb3yUiPUNBv@kbusch-mbp.dhcp.thefacebook.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 kernel test robot <lkp@intel.com>, Mike Snitzer <snitzer@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 22, 2023 at 12:16:02PM -0700, Keith Busch wrote:
> On Wed, Feb 22, 2023 at 11:52:25AM -0700, Uday Shankar wrote:
> >  static inline unsigned int blk_rq_get_max_segments(struct request *rq)
> >  {
> > -	if (req_op(rq) == REQ_OP_DISCARD)
> > -		return queue_max_discard_segments(rq->q);
> > -	return queue_max_segments(rq->q);
> > +	return blk_queue_get_max_segments(rq->q, req_op(rq));
> >  }
> 
> I think you should just move this function to blk.h instead of
> introducing a new one.

I chose to add blk_queue_get_max_segments as a public function because
it parallels blk_queue_get_max_sectors. If you don't want two functions,
I could manually inline the (2) uses of blk_rq_get_max_segments(rq),
converting them to blk_queue_get_max_segments(rq->q, req_op(rq)).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

