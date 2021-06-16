Return-Path: <SRS0=Xutw=LK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE077C48BE8
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 16:54:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 58730613BF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Jun 2021 16:54:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58730613BF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-Sq14roL2O0mtfTvdffLgNA-1; Wed, 16 Jun 2021 12:53:05 -0400
X-MC-Unique: Sq14roL2O0mtfTvdffLgNA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FE6B8E6AE3;
	Wed, 16 Jun 2021 16:53:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B50F10023AB;
	Wed, 16 Jun 2021 16:53:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E6B4246F59;
	Wed, 16 Jun 2021 16:53:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15GGqwtX025937 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Jun 2021 12:52:58 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E6C8107113; Wed, 16 Jun 2021 16:52:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 09AF2106A54
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 16:52:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83F1080D101
	for <dm-devel@redhat.com>; Wed, 16 Jun 2021 16:52:54 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-44-_-aaJAuiP7q_UAnVhqFOpA-1; Wed, 16 Jun 2021 12:52:23 -0400
X-MC-Unique: _-aaJAuiP7q_UAnVhqFOpA-1
Received: by mail-pj1-f46.google.com with SMTP id g4so2106201pjk.0;
	Wed, 16 Jun 2021 09:52:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=8MKUHbuhcvvAbyVmhGO6tF9OydsRY8Yh0Heff4psMcU=;
	b=FkTqAtQ4SFFLxnamyNCYO6IUakmXoEM9eRhHK/D1jZOj52hETcE7GY8tXbOjRgF5nJ
	qcrVtcG+2BQbJKQ3OFR+8pI8NDRsLhIfkRWGS2rdseeYymXLLeR9m2cPOUQ8GmhnytkT
	a1TvQcseCznt8CNWdsyEqZ1j+nHAdTVt2gGzEOo1UAxQMgWA1IK5y4brTemmaR0eulBc
	4wpdDXYe1ZQoFgW+NctNYX0jimvXMucFkfIfGNraGUIJr5d3g8eWU0Q2BEiVk6xJw2am
	KU3H2nNquBiEH5fdGbvs/kvEtcsOHxKy6NOWRgFUkuj8CmNSqlHNdx0jNbvcdH7zxlDp
	tC0g==
X-Gm-Message-State: AOAM530UXZZKboOAFVp08zG3AcTMTzl1wui5DFZG7954eUnnqz4bN7Ww
	sW4SuMabIH/7RrE3ux8q8VU=
X-Google-Smtp-Source: ABdhPJyzx+UQa7eUy6fLX7IIzx1UxFuf2kpE8zutUL05jvc6Tbl3mGv+6//eteoO9Q90ulyVAqOUPQ==
X-Received: by 2002:a17:902:6a84:b029:f3:f285:7d8 with SMTP id
	n4-20020a1709026a84b02900f3f28507d8mr457172plk.57.1623862342073;
	Wed, 16 Jun 2021 09:52:22 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net.
	[73.241.217.19])
	by smtp.gmail.com with ESMTPSA id w7sm2574738pjy.11.2021.06.16.09.52.19
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 16 Jun 2021 09:52:21 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20210615132456.753241-1-hch@lst.de>
	<20210615132456.753241-7-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <244b92f2-7921-7f33-b83f-66f3fff57696@acm.org>
Date: Wed, 16 Jun 2021 09:52:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210615132456.753241-7-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-arch@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	Ira Weiny <ira.weiny@intel.com>, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 06/18] bvec: add a bvec_kmap_local helper
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/15/21 6:24 AM, Christoph Hellwig wrote:
> +/**
> + * bvec_kmap_local - map a bvec into the kernel virtual address space
> + * @bvec: bvec to map
> + *
> + * Must be called on single-page bvecs only.  Call kunmap_local on the returned
> + * address to unmap.
> + */
> +static inline void *bvec_kmap_local(struct bio_vec *bvec)
> +{
> +	return kmap_local_page(bvec->bv_page) + bvec->bv_offset;
> +}

Hi Christoph,

Would it be appropriate to add WARN_ON_ONCE(bvec->bv_offset >=
PAGE_SIZE) in this function?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

