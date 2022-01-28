Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37617C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 28 Jan 2022 15:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643382990;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0thsGK+4IfcjVucwrgBg5deaBiuZwVNp/pSCOgXe3pA=;
	b=Hywboi+n66pudEQ2ZzyQJbHwxiLg74GZf2mqxbA6x+bOO3HAIxjpzGYaQtpULvzYWhd8ck
	GFUs2qoL23R+5eqk99JG1R5hrB/NYQsfpPsZCZdclVoEs+JW3Hhd7e1GNeAZ0Wt9sqjODi
	0zjOv2c9J059jSbSPZhfbHQThhlNu+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-UKe8goxgN2-agw2U3r7kxw-1; Fri, 28 Jan 2022 10:16:26 -0500
X-MC-Unique: UKe8goxgN2-agw2U3r7kxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F971363A8;
	Fri, 28 Jan 2022 15:16:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DFBB108C5;
	Fri, 28 Jan 2022 15:16:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6CEB01809CB8;
	Fri, 28 Jan 2022 15:16:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SFGFAS022465 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 10:16:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F8A740885C2; Fri, 28 Jan 2022 15:16:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B3B940885B2
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:16:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E602880B710
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 15:16:14 +0000 (UTC)
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
	[209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-643-xw89TiqFMYqN1C4bGzSydg-1; Fri, 28 Jan 2022 10:16:13 -0500
X-MC-Unique: xw89TiqFMYqN1C4bGzSydg-1
Received: by mail-qt1-f197.google.com with SMTP id
	g18-20020ac84b72000000b002cf274754c5so4728615qts.14
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 07:16:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Cp0i3c6pG+pEJXHv0A36Kn+qXCxSwpAB2eJIwbIKIC4=;
	b=Z77CEvlk9qI/7cE82pFJu8bfiq5+iwAfDRl/BqLAAkYGQ0vLxEyVUbwRp2NtrCEjVZ
	js1jOofnJKSO5YtioNPqLoH/1lWsUrChOfdF+97g3HP9S7519is6CVb4Ai1OCNhPYfqb
	UhXRe+3uZkDUs5l2j+40qIg0P90N2KzTrgcYgkQZE3mbjr3Jwl+XFDANtQupvEtn/HgN
	TjQWM8qSZh9rE6RRCfYvY7F6xljWsZX+slFesuMKVsHv5ZyZOjz1GLyZE9bW59sPe35X
	xtlEOIxq0V7BysnV5SRqDTL000K29HDclQLwkHnIZvKOBAeCkJicD38T76OELI6jyAdb
	tsCA==
X-Gm-Message-State: AOAM532PYqCb/WCLJeWgOZnWKPf0OdbXnJo5IUzBge3sNGa6d9gzEGQD
	gjBNGdQCGnsLo0XdBhKhtHbJnrisjCiyR9lIA8d6tunvZH/4tfqbm1ta3CxiKJ02mZtj4/m7Sku
	qM6uGMTsSf/0nxg==
X-Received: by 2002:a37:ab16:: with SMTP id u22mr5925826qke.785.1643382972434; 
	Fri, 28 Jan 2022 07:16:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxorxuH0ZTbxsfTu9vyCBb/9KxExCAwywc25dgZolCMmGt4Wh7UIiMndAOsMxO++QaFOONxkQ==
X-Received: by 2002:a37:ab16:: with SMTP id u22mr5925807qke.785.1643382972223; 
	Fri, 28 Jan 2022 07:16:12 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id 18sm3139119qty.36.2022.01.28.07.16.11
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 28 Jan 2022 07:16:11 -0800 (PST)
Date: Fri, 28 Jan 2022 10:16:10 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YfQIus452oB6/zqy@redhat.com>
References: <20220128041753.32195-1-snitzer@redhat.com>
	<20220128041753.32195-2-snitzer@redhat.com>
	<20220128061308.GA1477@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220128061308.GA1477@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 1/3] block: add bio_start_io_acct_time()
 to control start_time
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 28 2022 at  1:13P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Jan 27, 2022 at 11:17:51PM -0500, Mike Snitzer wrote:
> > +	__part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
> > +			     bio_op(bio), start_time);
> >  }
> > +EXPORT_SYMBOL_GPL(bio_start_io_acct_time);
> >  
> >  /**
> >   * bio_start_io_acct - start I/O accounting for bio based drivers
> > @@ -1084,14 +1096,15 @@ static unsigned long __part_start_io_acct(struct block_device *part,
> >   */
> >  unsigned long bio_start_io_acct(struct bio *bio)
> >  {
> > -	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio), bio_op(bio));
> > +	return __part_start_io_acct(bio->bi_bdev, bio_sectors(bio),
> > +				    bio_op(bio), jiffies);
> 
> Is droppingthe READ_ONCE safe here?  This is a honest question as these
> helpers still confuse me.

I'm not sure either, commit 956d510ee78ca ("block: add disk/bio-based
accounting helpers") doesn't offer any insight on the need.

Very little kernel code uses READ_ONCE(jiffies).

git diff 24d69293d9a561645e0b4d78c2fb179827e35f53^..e722fff238bbfe6308d7778a8c2163c181bf998a
shows that at the time the outgoing generic_{start,end}_io_acct didn't
use READ_ONCE (nor did any of the drivers that were updated to use the
new helpers).

ACCESS_ONCE() was used prior to READ_ONCE() -- see commit
cbbce82209490 and then 316c1608d15c7.

Anyway, looks to be cargo cult at this point right?
(if so, implies the use of READ_ONCE() in patch 3 isn't needed either)

> The rest looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

