Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46868C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:38:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 90DD3206C0
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:38:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90DD3206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-Mssomvm4M027-utEv6fvcg-1; Tue, 24 Nov 2020 12:38:40 -0500
X-MC-Unique: Mssomvm4M027-utEv6fvcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE66E805EF2;
	Tue, 24 Nov 2020 17:38:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFA544D;
	Tue, 24 Nov 2020 17:38:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 80EBC5002C;
	Tue, 24 Nov 2020 17:38:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOHc1HB021895 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 12:38:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E93DA2166B2C; Tue, 24 Nov 2020 17:38:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E1F9F2166B27
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:37:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 88283186E121
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:37:57 +0000 (UTC)
Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com
	[209.85.160.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-233-RRxT8jDWPVCA6vyjEQD3iA-1; Tue, 24 Nov 2020 12:37:10 -0500
X-MC-Unique: RRxT8jDWPVCA6vyjEQD3iA-1
Received: by mail-qt1-f194.google.com with SMTP id e60so7448000qtd.3;
	Tue, 24 Nov 2020 09:37:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=RUiSFwuqBx5Z5RkIMV/LAo3IZ2wMWa1pe8Bi01kcv9s=;
	b=HA43KtlNt6IDLd0ZKyVJTrNWWPxi//8SFjmCipoVcLGZN5z4iivyTnj6GG1HLQNEON
	OlucBTCxlkeBBg0Z/pYSqSbnE8WyWpLA3K6Yb10Ax2Msa2PY/mY/zrfj/xcl/TCzdxP7
	/FYNbGZHqJkzin60Jxa0gV3lt7lk6iu3GU1L+7jkqsqz4PuFkG6yu/kTE+cmUNRRWkMa
	GRGSPmKRpxxQVW/G11C9rtEOVAomMmfTrDI8qfVjbj6azjFrfZQMeFMyVqQZMO5PEg2R
	GZrclVXXFPNjdlcY0krJt2K/BkQmjPY6xGdqqybq+pm6RqasnlHP67i/H9yuDt/tBNXi
	ej/w==
X-Gm-Message-State: AOAM532wtGiGGcpKcPxeaFDTXTfYzXkfnOqzs1kKIGqDyzfUsivW/9nf
	iwjMcGys5OMHgNHzhsxidik=
X-Google-Smtp-Source: ABdhPJzns9py3D52IrNBrxEn0rk+MGg8bhauWe2r/6sVRsp+lUoI9EtR7DOBSR7jcCHuxmdt3gs4iQ==
X-Received: by 2002:ac8:4802:: with SMTP id g2mr5435506qtq.235.1606239429633; 
	Tue, 24 Nov 2020 09:37:09 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	137sm13319731qkj.109.2020.11.24.09.37.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 09:37:08 -0800 (PST)
Date: Tue, 24 Nov 2020 12:36:46 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71ErqPWQu+CvXRI@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-12-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-12-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 11/45] block: remove a duplicate
	__disk_get_part prototype
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:17PM +0100, Christoph Hellwig wrote:
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

