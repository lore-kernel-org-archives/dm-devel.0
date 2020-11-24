Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBDCC2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 53446206C0
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53446206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-S-vJIM7MPP6_otC04rp1Ag-1; Tue, 24 Nov 2020 12:39:54 -0500
X-MC-Unique: S-vJIM7MPP6_otC04rp1Ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DC8B81C9ED;
	Tue, 24 Nov 2020 17:39:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCA25100AE3C;
	Tue, 24 Nov 2020 17:39:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 992C11809CA1;
	Tue, 24 Nov 2020 17:39:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOHdfn4022181 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 12:39:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5B7B986D7D; Tue, 24 Nov 2020 17:39:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55D719E8F
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:39:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E06710580D7
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:39:38 +0000 (UTC)
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com
	[209.85.222.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-154-5xXCSKnKPFKRXg98NfrRsg-1; Tue, 24 Nov 2020 12:39:33 -0500
X-MC-Unique: 5xXCSKnKPFKRXg98NfrRsg-1
Received: by mail-qk1-f196.google.com with SMTP id n132so21542490qke.1;
	Tue, 24 Nov 2020 09:39:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=gccbgbDD7s/mdcXht2fL6iBUT8Prx6ozPAIi1oy24XY=;
	b=tQrB5NRBiPW/C+FQiM9BuR3xj9dwlqRvZPBOqufaIFHW+rPAnOOdnGDaAo9PbtVF5V
	X1N+LJyFwK3Tfz3nELYtQS036eO4MclBVvjVqmlimweLtB2mnH7Z92f3SHbP5CAaqirZ
	Tyd+f5XiCCf7Qx3EOppa1uS3UvzPvbrZPT5KFP1c9c25X65DsRt+KsDUt70ZTKIsX8t7
	hbIx1X940fdaR1K8EHWBuO1zghHoqGsqLau3axZbvcPsXt2nfeMSPOeM0YE38DrFSF7w
	PvfTqa2Zf/w++uzv1RG8Z+TRUrB3e0qym9sEwhnNJsPc1Ni42OVn0Rhu8kDRHoWG48L9
	Ia8Q==
X-Gm-Message-State: AOAM5318ETnioCb2XOfcbJaLHBcboKOJnb2PStHEhpjUk9kFDAfN432x
	Q1IhyOV0o4WTkCBnKezJ/tNFe0jUkUzckA==
X-Google-Smtp-Source: ABdhPJxIyQph6LZGahQWIRSjw01El8frTqGQNdMpj1StAekmqcFeaj8JjyjEpK9CN9Iflo08fhI4fA==
X-Received: by 2002:a05:620a:a1d:: with SMTP id
	i29mr5820661qka.466.1606239572817; 
	Tue, 24 Nov 2020 09:39:32 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	e10sm13416860qkn.126.2020.11.24.09.39.31
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 09:39:32 -0800 (PST)
Date: Tue, 24 Nov 2020 12:39:10 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71FPpCgw9t3JfIr@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-20-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-20-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 19/45] init: cleanup match_dev_by_uuid and
 match_dev_by_label
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:25PM +0100, Christoph Hellwig wrote:
> Avoid a totally pointless goto label, and use the same style of
> comparism for both helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

