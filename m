Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B25CC63777
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:38:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 60822206C0
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:38:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60822206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-UvA_XsNfNFuYglZ1DlIMwg-1; Tue, 24 Nov 2020 12:38:44 -0500
X-MC-Unique: UvA_XsNfNFuYglZ1DlIMwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB22219611CC;
	Tue, 24 Nov 2020 17:37:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BB815D9C0;
	Tue, 24 Nov 2020 17:37:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2FF7B5002C;
	Tue, 24 Nov 2020 17:37:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOHbqlw021855 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 12:37:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A58561016D9A; Tue, 24 Nov 2020 17:37:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1CFF1018CBF
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:37:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FCE6800296
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:37:52 +0000 (UTC)
Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com
	[209.85.222.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-264-E0DcJK2GMMCZU8Y7Sy_TAg-1; Tue, 24 Nov 2020 12:37:48 -0500
X-MC-Unique: E0DcJK2GMMCZU8Y7Sy_TAg-1
Received: by mail-qk1-f195.google.com with SMTP id u184so6899309qkf.3;
	Tue, 24 Nov 2020 09:37:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=wOTAYzxGcPu7PN/+w1SzvPIVnfCkyOLysxq7PCKNFLc=;
	b=rVRLbSp+lfq7K0gIp4LIYqVrw+KZOP767q93nC9A3C0FcA9b3ZeMRuZwSQGrWdb07M
	MrtNmZ+J4Qb3laOoInd4JntIq6aLjjm14MTEGmQEMZbutPGxHMeGnTm92A/gJ6yw0SLw
	XByg3ShZJm2oxnOM2pDNvOQ/6Hd55MP+c1Upb3DiVMGZzxdIJ6MRYbtTvYp57sYbiEGR
	vXn+N5phI5mPu8w/xVm8oEkVtaxXps5sGbziQfUcDOIxDwe6OMXp5nHnbwghcLyz6xFI
	qNmRLBft1o1YE3T5JRqA+lfyJPyOqSeSYz2SlFvftvG81YWZlbp6xBRihLkvtfI9eijJ
	vj7A==
X-Gm-Message-State: AOAM531t8bREl3YfMRLOy2HcXbztb0/eNq+QOa6eXgy3BpNNkPe/WWfq
	KWdwQaBBzXJdaQwOSkHQnxQ=
X-Google-Smtp-Source: ABdhPJyBD8adSd77vYvAq958zJMB+ltr44tGztKokoaCAzhoNqA4YXMUBiY2USQm4Mo3NyM012Iq6w==
X-Received: by 2002:a05:620a:11a4:: with SMTP id
	c4mr6030355qkk.8.1606239467443; 
	Tue, 24 Nov 2020 09:37:47 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	s3sm13993894qtd.49.2020.11.24.09.37.46
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 09:37:46 -0800 (PST)
Date: Tue, 24 Nov 2020 12:37:23 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71E05jyb3JdxRti@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-14-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-14-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Subject: Re: [dm-devel] [PATCH 13/45] block: add a bdev_kobj helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:19PM +0100, Christoph Hellwig wrote:
> Add a little helper to find the kobject for a struct block_device.

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

