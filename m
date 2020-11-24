Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C09C63777
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 805BD206F7
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 17:39:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 805BD206F7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-BkjjzTmHOa2XERjSFR3kqg-1; Tue, 24 Nov 2020 12:39:15 -0500
X-MC-Unique: BkjjzTmHOa2XERjSFR3kqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55890101AFA9;
	Tue, 24 Nov 2020 17:38:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 347A75D6AB;
	Tue, 24 Nov 2020 17:38:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 090145002D;
	Tue, 24 Nov 2020 17:38:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOHcTQX021966 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 12:38:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1E9DF2026D25; Tue, 24 Nov 2020 17:38:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 187302026D35
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:38:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7887811E8F
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 17:38:26 +0000 (UTC)
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com
	[209.85.222.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-342-naQy8QiaOkKwQGCLrViKpg-1; Tue, 24 Nov 2020 12:38:05 -0500
X-MC-Unique: naQy8QiaOkKwQGCLrViKpg-1
Received: by mail-qk1-f193.google.com with SMTP id v143so21508620qkb.2;
	Tue, 24 Nov 2020 09:38:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=E5yu6Z9CIGvjjdSWaM1JDiBNwd7R7l70HZvgJTMOMAo=;
	b=inPPqmYmr7nJCZBTSvWqDRn+5NuVd02FCbzAYoGGKMW8AQyVdZgkBkS9uhblk2L4XQ
	ObUvAG3rlGHGigxc2DujLMGCKOYvJxHgzlgjE7mzTIzSg9NC/pqqKX+uFYz5Q41hYwzf
	91o+7IthXAZM1YAQO7xL78Kb58mGg8em8jyBrclfQKNDdK0qomOwrN7oDYwJIAhg55bF
	KFiPLWZHCY/sMBohiWvoXXWGirJHsS7ZdSReIb0fj1HWlTzSEtleGOuSDLsMvWdqTWrx
	pJC6O/puaKf+FBHs8TK+hYvj8pF8kJ06Cz4yywWPmqktyas5mF/7/Q7bic66lMKHqe1X
	HBGA==
X-Gm-Message-State: AOAM530498TwX/tLBshli1r+DsPgyNma4rYsjTKi2wsdSOcGf/ZoZdKD
	cbvgHSZr6+vFzzRjo8ZTV5E=
X-Google-Smtp-Source: ABdhPJyi1T8dRX2wY3q65x2J+bQePuJjN+c8Pa1HrFeBbFFSDxXqbhzlU09MTDkUoIjmr+Nu4Id3fQ==
X-Received: by 2002:a37:7bc7:: with SMTP id w190mr5863735qkc.476.1606239484751;
	Tue, 24 Nov 2020 09:38:04 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	i4sm12549778qti.78.2020.11.24.09.38.03
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 09:38:04 -0800 (PST)
Date: Tue, 24 Nov 2020 12:37:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71E5ohZ7I/tDKWO@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-15-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-15-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Subject: Re: [dm-devel] [PATCH 14/45] block: use disk_part_iter_exit in
 disk_part_iter_next
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2020 at 02:27:20PM +0100, Christoph Hellwig wrote:
> Call disk_part_iter_exit in disk_part_iter_next instead of duplicating
> the functionality.

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

