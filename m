Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E16C2D0E4
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EF353206C0
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF353206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-PX4N1UzFP8C02c0LcpiGww-1; Tue, 24 Nov 2020 12:39:15 -0500
X-MC-Unique: PX4N1UzFP8C02c0LcpiGww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8B40612BE;
	Tue, 24 Nov 2020 17:39:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B5E160873;
	Tue, 24 Nov 2020 17:39:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C55B5002E;
	Tue, 24 Nov 2020 17:39:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOHd2Bh022048 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 12:39:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 04FD01018CBF; Tue, 24 Nov 2020 17:39:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 015F3112D177
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:39:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2DD5805C3F
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:39:01 +0000 (UTC)
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com
	[209.85.222.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-279-ebSRLEfkMPO_Xv5ZukUPxg-1; Tue, 24 Nov 2020 12:38:22 -0500
X-MC-Unique: ebSRLEfkMPO_Xv5ZukUPxg-1
Received: by mail-qk1-f193.google.com with SMTP id y197so21482594qkb.7;
	Tue, 24 Nov 2020 09:38:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=m2ZvAloMQE/4x6qZGlu4klEd6I1OFmrdg9L02bbThZY=;
	b=pbxDS1leESm5eXgeLFXEPeb0u1VUf80azCwwDhhYL+ZVBSMV0VDI8lNV9sAQmUD/YP
	7UVPceVKNuNlKQ1fHwrWS7gyjbfs9TNRI/CtKuD8oUTQrcLwil4FgZEGzGp+KDPqjWWJ
	BCQjWJezYkSE24A1a19ujsZ6WPQA2sTx1vYMZKWoX3CPcCNvqWRGcqiEaCxxSmLUf0Oy
	HiTH8XeVf3/CkVvaOWGy5LZR01xBxyHvtR5rWh7J9IQJuN2xxyZaHNP5WJwX1gkDnBAh
	qRZQLZ53CaKv/ySHXVwJLNrA1BHuhoDP6p1iwUqXmkVD4yWzJlzPMngMRsaXyWfl7Qh2
	hLSA==
X-Gm-Message-State: AOAM530zrPwMmc2NhRPiB0BLh7E9KEwqNRrq1jNaHt+NA+gTNMb/2Dk+
	iJ00+bWvnuZLTYP82y6Hopk=
X-Google-Smtp-Source: ABdhPJydGVRMFQ1+r3+Z46PpDtXJ8+bSnv4nPK+7aFRRl1d4ZdhaX+JqGpjWBGRDvXsi5fkaK49s7A==
X-Received: by 2002:ae9:e80d:: with SMTP id a13mr6004436qkg.140.1606239502291; 
	Tue, 24 Nov 2020 09:38:22 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	x21sm13062842qkx.31.2020.11.24.09.38.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 09:38:21 -0800 (PST)
Date: Tue, 24 Nov 2020 12:37:58 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71E9mG4sw2WiIEj@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-16-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-16-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 15/45] block: use put_device in put_disk
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:21PM +0100, Christoph Hellwig wrote:
> Use put_device to put the device instead of poking into the internals
> and using kobject_put.
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

