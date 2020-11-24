Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF77C63777
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 19:47:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 50B46206C0
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 19:47:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50B46206C0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-u3Z55X9YMZ2beoW7wBgu2w-1; Tue, 24 Nov 2020 14:47:25 -0500
X-MC-Unique: u3Z55X9YMZ2beoW7wBgu2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A101E8042A2;
	Tue, 24 Nov 2020 19:47:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F6F01F0;
	Tue, 24 Nov 2020 19:47:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3C08F4BB7B;
	Tue, 24 Nov 2020 19:47:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOJlG9v008857 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 14:47:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CF8E2945DD; Tue, 24 Nov 2020 19:47:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C8A6E945D9
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 19:47:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54479186E122
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 19:47:14 +0000 (UTC)
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com
	[209.85.222.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-63-Z0tiPOC7PX6jAco4q_F3ig-1; Tue, 24 Nov 2020 14:47:11 -0500
X-MC-Unique: Z0tiPOC7PX6jAco4q_F3ig-1
Received: by mail-qk1-f193.google.com with SMTP id u184so40758qkf.3;
	Tue, 24 Nov 2020 11:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=V2TOjLdoUaYrySYqHg0oeA6ickZUCz64YonJi1MX7zw=;
	b=W8FUR5CD9Oy24uKnpBy+c+MfNPvC4CzduYNVSRM8yBQkL2TRGuHHExfCviBsnRPL1f
	VD6AUbqxtJVMMJfY5U/JI7AYMmpyFHPlI5zygXtCgAdEKBT7DJGzk197b8gpOA6qguxS
	O3CaweR3BBU0tOHfxxr9gL2QrtL+pcprFWY7aq0jWw4ZzT0H/FldFz1FBH79mfTr1GlM
	z5FDsxr5XO0Bu6xAFJqkyZ+vSVW9BM0m6rwqoTAAJMViaPD27WbyT4rRi1ONGszJYyrz
	ip1N7gRIomyx0WYL0C1GLnyHyXtG8Nr9Upj3FfNwtdIbW6wtK+SLefrlN+1c542DMJmj
	FQ6w==
X-Gm-Message-State: AOAM530wbKIuCFtTmrSV1QHwSlnCL6Ac10fuyU01MUbA8ZJDjD9bwjpy
	LEax+BXoIMP03FpOXOM4uhM=
X-Google-Smtp-Source: ABdhPJzCbEzsnsSHZbAP8aBMoagyKuXkYbNxYHgU470rrYkN9D5aTPe0QJyzDBb8iwv2DZpxdq68Ww==
X-Received: by 2002:a37:6cd:: with SMTP id 196mr3775536qkg.96.1606247231211;
	Tue, 24 Nov 2020 11:47:11 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
	by smtp.gmail.com with ESMTPSA id
	137sm123792qkj.109.2020.11.24.11.47.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 11:47:10 -0800 (PST)
Date: Tue, 24 Nov 2020 14:46:47 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X71jJywIZTSxLoqQ@mtj.duckdns.org>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-25-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-25-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 24/45] blk-cgroup: stop abusing get_gendisk
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

On Tue, Nov 24, 2020 at 02:27:30PM +0100, Christoph Hellwig wrote:
> Properly open the device instead of relying on deep internals by
> using get_gendisk.  Note that this uses FMODE_NDELAY without either
> FMODE_READ or FMODE_WRITE, which is a special open mode to allow
> for opening without media access, thus avoiding unexpexted interactions
> especially on removable media.

I'm not sure FMODE_NDELAY does that. e.g. sd_open() does media change check
and full revalidation including disk spin up regadless of NDELAY and it's
odd and can lead to nasty surprises to require cgroup configuration updates
to wait for SCSI EH.

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

