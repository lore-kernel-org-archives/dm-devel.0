Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B106BC5519F
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 12:37:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E9072206E5
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 12:37:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9072206E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-lc0ivjS3PZOkiSN_iow2_g-1; Wed, 25 Nov 2020 07:36:57 -0500
X-MC-Unique: lc0ivjS3PZOkiSN_iow2_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50D511DE1D;
	Wed, 25 Nov 2020 12:36:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20A1360BE5;
	Wed, 25 Nov 2020 12:36:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E3AD018095C9;
	Wed, 25 Nov 2020 12:36:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APCAG7U026110 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 07:10:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 84DF41134CBD; Wed, 25 Nov 2020 12:10:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8117C1004046
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 12:10:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 682C28007D9
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 12:10:13 +0000 (UTC)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
	[209.85.166.52]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-159-AsNNqANmOwKTZnP44mvq4A-1; Wed, 25 Nov 2020 07:10:10 -0500
X-MC-Unique: AsNNqANmOwKTZnP44mvq4A-1
Received: by mail-io1-f52.google.com with SMTP id r9so1900166ioo.7;
	Wed, 25 Nov 2020 04:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=7Gu8dfUtFbW1JkuoI0JsJxuRwdXnhq5kHzNpgpg59Vg=;
	b=BvV+1KV91tvMlnlZJfK35i7+KQOUx98WRJrZ6f9SJ/sPKKU5+TdMpVhnW07RROkBSs
	o3MdChhXKNi8pHm/e5wXQXfNBIOjnjfONV8W5GZluC+m9yLpewrw1Sy6+NDbVtpzBevH
	n+vOdkcWXo3gpMw/Ld6rQmO6XNMGiIVSXger/GAyZkT7c7jfVanfKWHVQLgR9JahJQIG
	0XGCfbb2VKM2oO/tuirsaLH/2uv4mK6/0aW1xmA9QUrHvmapPgBN3MwDu1U1lOmH79dA
	5xxkRnL5bO88gI7AtSQO7gh/qPNXXbr5e3rnY7BiEEQsOBz1AZNt0PMPTME8r0ymHy8A
	uEDw==
X-Gm-Message-State: AOAM533cpYYRl8FXyPK8nULlBafCN4Zb+RF9NinXXbDwRDisJFzfqWkl
	5Z+BIEWvVZ1xLPAH7pZLNxUHhZDobPNDeQ==
X-Google-Smtp-Source: ABdhPJzrP+6qlAsvVf6NJAz9IW3W/tDwuPyEzkZeYfjLrVcKdFZvzQhG4Xm+JItZe22HwNKBFUD46g==
X-Received: by 2002:a5e:8206:: with SMTP id l6mr2327550iom.126.1606306209079; 
	Wed, 25 Nov 2020 04:10:09 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	v85sm1343250ilk.50.2020.11.25.04.10.08
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 25 Nov 2020 04:10:08 -0800 (PST)
Date: Wed, 25 Nov 2020 07:09:46 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Message-ID: <X75JitlWvZieqIR3@mtj.duckdns.org>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-12-hch@lst.de>
	<X708BTJ5njtbC2z1@mtj.duckdns.org>
	<20201125114044.GC16944@quack2.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20201125114044.GC16944@quack2.suse.cz>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 11/20] block: reference struct block_device
 from struct hd_struct
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

Hey, Jan,

On Wed, Nov 25, 2020 at 12:40:44PM +0100, Jan Kara wrote:
> > I don't think this is necessary now that the bdev and inode lifetimes are
> > one. Before, punching out the association early was necessary because we
> > could be in a situation where we can successfully look up a part from idr
> > and then try to pin the associated disk which may already be freed. With the
> > new code, the lookup is through the inode whose lifetime is one and the same
> > with gendisk, so use-after-free isn't possible and __blkdev_get() will
> > reliably reject such open attempts.
> 
> I think the remove_inode_hash() call is actually still needed. Consider a
> situation when the disk is unplugged, gendisk gets destroyed, bdev still
> lives on (e.g. because it is still open). Device gets re-plugged, gendisk
> for the same device number gets created. But we really need new bdev for
> this because from higher level POV this is completely new device. And the
> old bdev needs to live on as long as it is open. So IMO we still need to
> just unhash the inode and leave it lingering in the background.

You're absolutely right. I was only thinking about the lifetime problem
described in the comment. So, it just needs an updated comment there, I
think.

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

