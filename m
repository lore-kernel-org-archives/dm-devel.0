Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F9E6C64EC7
	for <dm-devel@archiver.kernel.org>; Wed, 22 Feb 2023 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677093885;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kK9tPeH1pk0YwEHyOwdF1P08NYLxl3DRNLMhVGBlQOE=;
	b=OrxG1xYLI0mao0OksbxAWyUNgFkG9HGb3N4scj1OGxVlFNSIuFj3mCGDykvolypcNYiMxe
	rvufMyZ0vd473CDAEKrqyy4TFMjYiY3YC5d9PsAlezHiw2o+m5IqkGa1GkYeWqhU15UQUz
	l99ag6TVk+kmLGCsdgQK9Dz41YyS9To=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-66-QZzC31OEOJynlsp_mv-zTw-1; Wed, 22 Feb 2023 14:24:41 -0500
X-MC-Unique: QZzC31OEOJynlsp_mv-zTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 111C63C18351;
	Wed, 22 Feb 2023 19:24:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC2BEC15BA0;
	Wed, 22 Feb 2023 19:24:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90D1D19465A0;
	Wed, 22 Feb 2023 19:24:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 649EF194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Feb 2023 19:23:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B3961121315; Wed, 22 Feb 2023 19:23:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 036A01121314
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 19:23:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DD73785A5B1
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 19:23:39 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-wr_I5sHjMXevRNpL36m30Q-1; Wed, 22 Feb 2023 14:23:38 -0500
X-MC-Unique: wr_I5sHjMXevRNpL36m30Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 556EEB8136B;
 Wed, 22 Feb 2023 19:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2C4C433D2;
 Wed, 22 Feb 2023 19:16:05 +0000 (UTC)
Date: Wed, 22 Feb 2023 12:16:02 -0700
From: Keith Busch <kbusch@kernel.org>
To: Uday Shankar <ushankar@purestorage.com>
Message-ID: <Y/Zp8lb3yUiPUNBv@kbusch-mbp.dhcp.thefacebook.com>
References: <20230222185224.2484590-1-ushankar@purestorage.com>
MIME-Version: 1.0
In-Reply-To: <20230222185224.2484590-1-ushankar@purestorage.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 kernel test robot <lkp@intel.com>, Mike Snitzer <snitzer@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 22, 2023 at 11:52:25AM -0700, Uday Shankar wrote:
>  static inline unsigned int blk_rq_get_max_segments(struct request *rq)
>  {
> -	if (req_op(rq) == REQ_OP_DISCARD)
> -		return queue_max_discard_segments(rq->q);
> -	return queue_max_segments(rq->q);
> +	return blk_queue_get_max_segments(rq->q, req_op(rq));
>  }

I think you should just move this function to blk.h instead of
introducing a new one.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

