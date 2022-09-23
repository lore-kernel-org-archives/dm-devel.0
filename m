Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AABECAAD8
	for <dm-devel@archiver.kernel.org>; Fri, 23 Sep 2022 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663946116;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BQs86e66usAKDkcjRHtyfundQhEH+w2h6NzVw5rAGbc=;
	b=AqJc8nRCIhVBg4zFLLhZC8pr0C07ZxKbMNVxPUi1N84zKxsk0JwPUq+9JbCybb9yf0uK/u
	x6uuYTvS7UcTxBcWSGd0deAClJZWqGHPuVpw49GAykfz06zcg+6uFjukqbk5n1Y+uI3L5K
	9eGUCjFKzdGyVN5iHbiAL/uuh5HrX2U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-LtAGg5gZP069U9U8l0rjzQ-1; Fri, 23 Sep 2022 11:15:14 -0400
X-MC-Unique: LtAGg5gZP069U9U8l0rjzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6B4F185A7AA;
	Fri, 23 Sep 2022 15:15:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E9C61415138;
	Fri, 23 Sep 2022 15:15:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D79CE19465B6;
	Fri, 23 Sep 2022 15:15:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 272AD19465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 23 Sep 2022 15:15:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 173D2492B13; Fri, 23 Sep 2022 15:15:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAE6F492B12
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 15:15:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDFF5801231
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 15:15:08 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-187-PehtI96oMKu3C5iR3Kx3ow-1; Fri, 23 Sep 2022 11:15:07 -0400
X-MC-Unique: PehtI96oMKu3C5iR3Kx3ow-1
Received: by mail-qk1-f197.google.com with SMTP id
 az15-20020a05620a170f00b006cece4cd0beso200583qkb.22
 for <dm-devel@redhat.com>; Fri, 23 Sep 2022 08:15:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=i/7qErjHQwpjdxeuxG56UOY53/Pb3ceXUixswzrpqTk=;
 b=7n0PQD2K5AUcHO1SQvyMXTnFb9rceVpBOeTSxvSzMiO98Dgz+ouEZZC0X64GNNVs92
 ESGtnPMKu7pNwsuYXB+VBdn9l9EhwjEH7LgZyHhZ+ouDj4cWgzzsFb/WGkMSjzBaMj0/
 b1LhYcRChoHddN+Bo3EVKii4LV2eS4sh3VWuvro+ahYxnE1IFqEriAO1OI64TPh13jDI
 gvKRn1xxF/2YDaLekbqN4Ahv82FXPg4fETLagABdYyaLpRh5/o4krg2NiCs5Ge4dA+S1
 UtKlMx/XStMibgPC5K6aCInoujyS87Russ55DmVLgLirDMJlrr+jefyucQFMoMRY2MH8
 5r6Q==
X-Gm-Message-State: ACrzQf3zfSoXl7C7KLd0KcYn+yjQ5RuvKGy2nWgWVifMcgPUudl1Q5jp
 HlxBLOZw5N2ZyyD5eT2ibA0qOVNJaYSGNrlWemMnNZJ8OGwPX+Lh+jcGIXrlmY2sNZ0RKo67izM
 I+jPQ8CPqxHWtxw==
X-Received: by 2002:a05:6214:76b:b0:4ac:be62:d2e5 with SMTP id
 f11-20020a056214076b00b004acbe62d2e5mr7176236qvz.91.1663946106769; 
 Fri, 23 Sep 2022 08:15:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Jg5JqThdy0P5kS2uSLUoQ3+kfdp9Ppg4QGXjxFRDk5XYyybGVmtH43Lh/lTr6N1EDYoCkpg==
X-Received: by 2002:a05:6214:76b:b0:4ac:be62:d2e5 with SMTP id
 f11-20020a056214076b00b004acbe62d2e5mr7176213qvz.91.1663946106592; 
 Fri, 23 Sep 2022 08:15:06 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 g12-20020ac8468c000000b0035cb9531851sm5432876qto.65.2022.09.23.08.15.06
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 23 Sep 2022 08:15:06 -0700 (PDT)
Date: Fri, 23 Sep 2022 11:15:05 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <Yy3NeY02zEMLTdsa@redhat.com>
References: <20220915164826.1396245-1-sarthakkukreti@google.com>
 <20220915164826.1396245-2-sarthakkukreti@google.com>
MIME-Version: 1.0
In-Reply-To: <20220915164826.1396245-2-sarthakkukreti@google.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH RFC 1/8] block: Introduce provisioning
 primitives
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
Cc: Jens Axboe <axboe@kernel.dk>, Gwendal Grignou <gwendal@google.com>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 virtualization@lists.linux-foundation.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Andreas Dilger <adilger.kernel@dilger.ca>,
 Daniil Lunev <dlunev@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-ext4@vger.kernel.org,
 Evan Green <evgreen@google.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Sep 15 2022 at 12:48P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> From: Sarthak Kukreti <sarthakkukreti@chromium.org>
> 
> Introduce block request REQ_OP_PROVISION. The intent of this request
> is to request underlying storage to preallocate disk space for the given
> block range. Block device that support this capability will export
> a provision limit within their request queues.
> 
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  block/blk-core.c          |  5 ++++
>  block/blk-lib.c           | 55 +++++++++++++++++++++++++++++++++++++++
>  block/blk-merge.c         | 17 ++++++++++++
>  block/blk-settings.c      | 19 ++++++++++++++
>  block/blk-sysfs.c         |  8 ++++++
>  block/bounce.c            |  1 +
>  include/linux/bio.h       |  6 +++--
>  include/linux/blk_types.h |  5 +++-
>  include/linux/blkdev.h    | 16 ++++++++++++
>  9 files changed, 129 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 8bb9eef5310e..be79ad68b330 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -57,6 +57,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->misaligned = 0;
>  	lim->zoned = BLK_ZONED_NONE;
>  	lim->zone_write_granularity = 0;
> +	lim->max_provision_sectors = 0;
>  }
>  EXPORT_SYMBOL(blk_set_default_limits);
>  
> @@ -81,6 +82,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
>  	lim->max_dev_sectors = UINT_MAX;
>  	lim->max_write_zeroes_sectors = UINT_MAX;
>  	lim->max_zone_append_sectors = UINT_MAX;
> +	lim->max_provision_sectors = UINT_MAX;
>  }
>  EXPORT_SYMBOL(blk_set_stacking_limits);
>  

Please work through the blk_stack_limits() implementation too (simple
min_not_zero?).

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

