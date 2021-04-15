Return-Path: <SRS0=YP8V=JM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC36C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 19:51:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E982B60FF0
	for <dm-devel@archiver.kernel.org>; Thu, 15 Apr 2021 19:51:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E982B60FF0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-D_YSux9DMHGBMo0N21VC0g-1; Thu, 15 Apr 2021 15:51:09 -0400
X-MC-Unique: D_YSux9DMHGBMo0N21VC0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3F711008061;
	Thu, 15 Apr 2021 19:51:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18C345C3FD;
	Thu, 15 Apr 2021 19:51:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0F1E91C98;
	Thu, 15 Apr 2021 19:50:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13FJosHX025803 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Apr 2021 15:50:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A84A020BB91A; Thu, 15 Apr 2021 19:50:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A303A20BB917
	for <dm-devel@redhat.com>; Thu, 15 Apr 2021 19:50:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0652685A5A8
	for <dm-devel@redhat.com>; Thu, 15 Apr 2021 19:50:52 +0000 (UTC)
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com
	[209.85.216.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-401-B8E-aQfQNme3Rs2M2-Bvyg-1; Thu, 15 Apr 2021 15:50:47 -0400
X-MC-Unique: B8E-aQfQNme3Rs2M2-Bvyg-1
Received: by mail-pj1-f52.google.com with SMTP id
	ot17-20020a17090b3b51b0290109c9ac3c34so15011371pjb.4; 
	Thu, 15 Apr 2021 12:50:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=jzSTR4S/XfBfmHFocbuUnh6F7IZZt8GfGeTP4lw6/K4=;
	b=mIONbAjmQzzq6RXNqt4QpSfm8ppRUL6mz4mrXvg/S8VE1e6PiRQrFKnwLVH9tnE9EW
	KTvLfn3VA5XSOM+8HDWSmJDVx1Px3Pc9ZCcGOzTlkYi2dKkb9g5HndeaHBaKHn0/KNlc
	MVMB/y48t4M6g67QdXd3tuhqloaqK7I+5pqRALTGa42fL44YeCZobZY+aKyUrpkLkG2Y
	VZx4NDRxgTTZRWXubJzqk5gPTafIzt9/6Q6dTtfYBE6h8Y/+ha+M4TF0pArK8Vh3D3y3
	0dqduWlEoGrsR9KE4RgzjE1gxKRiEQ/e+3hYN4bXmlzuv+UXzLKKrTC4rmRfgsYSuPHm
	QZxw==
X-Gm-Message-State: AOAM530uO4XmbMYF75tfyK++PdkdhNMBko41U8tec9qAwxxCjnXaE00c
	8UL1uEjVBnu3+TrAWSPhoBHvy/InIxk=
X-Google-Smtp-Source: ABdhPJxePiKeGIZglO2VnENKO4CmWRNHyXXkuqGu0pEa2yWYv+nCrnpvMLLjycBthAhK0BSdfce1dg==
X-Received: by 2002:a17:902:7689:b029:eb:3d5f:ae58 with SMTP id
	m9-20020a1709027689b02900eb3d5fae58mr5532107pll.39.1618516245716;
	Thu, 15 Apr 2021 12:50:45 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f031:1d3a:7e95:2876?
	([2601:647:4000:d7:f031:1d3a:7e95:2876])
	by smtp.gmail.com with ESMTPSA id e9sm2997293pgk.69.2021.04.15.12.50.44
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 15 Apr 2021 12:50:44 -0700 (PDT)
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
	<20210415103310.1513841-2-ming.lei@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <dcdc3233-b4a6-24b2-85dd-78ed9e70fef1@acm.org>
Date: Thu, 15 Apr 2021 12:50:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210415103310.1513841-2-ming.lei@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH 1/2] percpu_ref: add
	percpu_ref_tryget_many_live
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/15/21 3:33 AM, Ming Lei wrote:
>  /**
> - * percpu_ref_tryget_live - try to increment a live percpu refcount
> + * percpu_ref_tryget_many_live - try to increment a live percpu refcount
>   * @ref: percpu_ref to try-get
> + * @nr: number of references to get

You may want to change "increment" into "increase" to make it more clear
that this function may increase the percpu refcount by more than one.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

