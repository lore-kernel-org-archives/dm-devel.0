Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395CEC56201
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 12:26:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6A4C1206B5
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 12:26:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A4C1206B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-Oh2VJMbAOT2nAop0S6UUTw-1; Tue, 24 Nov 2020 07:26:44 -0500
X-MC-Unique: Oh2VJMbAOT2nAop0S6UUTw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82DB41006C81;
	Tue, 24 Nov 2020 12:26:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1EF91F0;
	Tue, 24 Nov 2020 12:26:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 47CB44BB40;
	Tue, 24 Nov 2020 12:26:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOCQYDb008489 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 07:26:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3CF7A2166B27; Tue, 24 Nov 2020 12:26:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 371B82166B2B
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 12:26:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC6C4803C9F
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 12:26:29 +0000 (UTC)
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com
	[209.85.160.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-313-IcfXPfUYMX64rG49TSuGfA-1; Tue, 24 Nov 2020 07:26:27 -0500
X-MC-Unique: IcfXPfUYMX64rG49TSuGfA-1
Received: by mail-qt1-f195.google.com with SMTP id m65so15818044qte.11;
	Tue, 24 Nov 2020 04:26:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=3VmFnou2nD4lcYGUPrMqThXCue7L4UhclP4oij42Kbk=;
	b=FMIbJag5KKYjep2vHhauWFvQPttBp308sm+0rrW+jHax1yjqVJGG5MfD+pqX4gJ3tu
	nsczQj7Fs650WZkCL2cfnlw6wERpsUQO8GJMWHSdmbS4qJMgsZVmmLKlavrbecOdON8/
	5luKswWX4JcoFtSlJIBq6C0B9CgnlPLt44FuGm8UAbALFPH/NyIEx+Nzamb+pjaCPFob
	ViTdacNI8yoo/Qo0SY9jNFyrFhitPsh7t3ZdGxulcBwWYPqUZroC7khd9qUZa2tEdvlp
	xsbIwjcQ60CSc/6fSxduERT+5fuojSFsaeItHy50ThuMsEziV/lwkJVLn+B7kcW9DVKD
	Vvig==
X-Gm-Message-State: AOAM530KWWrXtyFqD//lZ3ToKpJqsfm9UrP3Ggo5b3cZoPmM/f0aBWGx
	9+uGrOZcZSKLUsbYYTGF5Lk=
X-Google-Smtp-Source: ABdhPJzEc+iLQWYgDMndDYVqthGkMbJAnqvSsODxlzYXE5vX4s2url7RgqZoX9eivJ6nNv6zlRow0w==
X-Received: by 2002:aed:3c42:: with SMTP id u2mr4081287qte.159.1606220786736; 
	Tue, 24 Nov 2020 04:26:26 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id t2sm8643187qkb.2.2020.11.24.04.26.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 04:26:25 -0800 (PST)
Date: Tue, 24 Nov 2020 07:26:03 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X7z7215hVXzg3FGA@mtj.duckdns.org>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-2-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 01/20] blk-cgroup: fix a hd_struct leak in
 blkcg_fill_root_iostats
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

On Wed, Nov 18, 2020 at 09:47:41AM +0100, Christoph Hellwig wrote:
> disk_get_part needs to be paired with a disk_put_part.
> 
> Fixes: ef45fe470e1 ("blk-cgroup: show global disk stats in root cgroup io.stat")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

