Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AE0C64E7B
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:37:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6E8C8221F7
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E8C8221F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-e8urnUd8Mmu9TZpAvGKNGw-1; Wed, 02 Dec 2020 17:37:44 -0500
X-MC-Unique: e8urnUd8Mmu9TZpAvGKNGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 427788042C5;
	Wed,  2 Dec 2020 22:37:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BEE460C17;
	Wed,  2 Dec 2020 22:37:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB704180954D;
	Wed,  2 Dec 2020 22:37:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2Mbb5U015145 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 17:37:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 167FF2166B2C; Wed,  2 Dec 2020 22:37:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11C352166B29
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:37:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 952A5858EEC
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:37:34 +0000 (UTC)
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com
	[209.85.160.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-129-cOXlP1wQNiSraEgur4V_aA-1; Wed, 02 Dec 2020 17:37:32 -0500
X-MC-Unique: cOXlP1wQNiSraEgur4V_aA-1
Received: by mail-qt1-f181.google.com with SMTP id v11so2338857qtq.12
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 14:37:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=HShAgJCUcps4N1A+2IklR049T/RPogDj41ruzx2BBDo=;
	b=CgUlyr/y4wj58wU6Z0dppu/bc6AaUlfuYIGJqAO7iU6wnlWGBq0Du/buHITpIA8uje
	HIJpIzUW4mKMrfJfhfmpDYBPKiD5FCk4+/pCVSz0DY4Ig2/70yljzCq8dgjfJUVEVl0b
	qcFNyk2Xxdx/RAA6xgy7qpp1FpUCPv0N4NSl5Orm4qRGaI3L05UXLeTQvb7TArDMhpBD
	GsQ9RX4BHa3JwtjyzoRdhFiZHaUiCNJeuLSPG1tBw0o43kEGlTY/2GWjr4HJWnz39oAI
	lBcdHWY8NzaytOzfKkKfJVBD7ecA7ebMYuL21tmDsSRr1aAQU047hxhjX6P+432R5pJt
	s13A==
X-Gm-Message-State: AOAM531+CDZ6lwaNCLAlU/2WzHRreC9s3bbU86RM58ukL1WK4PXfD0dG
	bXnbkUQUWMSkw3U2HeMVN4M=
X-Google-Smtp-Source: ABdhPJzLQDjBM2feXi0iRxAJyEtngQDMNkvdJGyaFvpaYJZxsZ3XDEBbF+Aj812h7lkT9BmeOE3RFw==
X-Received: by 2002:ac8:6bc6:: with SMTP id b6mr390050qtt.127.1606948651820;
	Wed, 02 Dec 2020 14:37:31 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id z20sm352334qtb.31.2020.12.02.14.37.30
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 14:37:31 -0800 (PST)
Date: Wed, 2 Dec 2020 17:37:03 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gXDx0DU+sqJoPc@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
	<X8gWqZ6li+CvgF4i@mtj.duckdns.org>
MIME-Version: 1.0
In-Reply-To: <X8gWqZ6li+CvgF4i@mtj.duckdns.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] store a pointer to the block_device in struct bio
	(again)
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 02, 2020 at 05:35:21PM -0500, Tejun Heo wrote:
> On Tue, Dec 01, 2020 at 05:54:15PM +0100, Christoph Hellwig wrote:
> > Hi Jens,
> > 
> > this series switches back from storing the gendisk + partno to storing
> > a block_device pointer in struct bio.  The reason is two fold:  for one
> > the new struct block_device actually is always available, removing the
> > need to avoid originally.  Second the merge struct block_device is much
> > more useful than the old one, as storing it avoids the need for looking
> > up what used to be hd_struct during partition remapping and I/O
> > accounting.
> > 
> > Note that this series depends on the posted but not merged
> > "block tracepoint cleanups" series.
> 
> I'm late but everything looks good to me. So much better than the mess we
> had before. Thank you.
> 
> The only thing I noticed is that blkdev_get_no_open() can now use
> kobject_get() instead of kobject_get_unless_zero() as bdev lookup is
> synchronously disabled before device_del().

Oops, sorry, this was supposed to be a reply to the earlier hd_struct
removal patchset. Reviewing this patchset now.

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

