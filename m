Return-Path: <SRS0=BcWr=G4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689C4C433E6
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 16:27:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 890DB22D04
	for <dm-devel@archiver.kernel.org>; Mon, 25 Jan 2021 16:27:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 890DB22D04
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-4b1-RLgOPICGyv4XUbby7A-1; Mon, 25 Jan 2021 11:27:54 -0500
X-MC-Unique: 4b1-RLgOPICGyv4XUbby7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FD9719611A0;
	Mon, 25 Jan 2021 16:27:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3DEF19C47;
	Mon, 25 Jan 2021 16:27:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B08C1809CA0;
	Mon, 25 Jan 2021 16:27:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10PGOCw7021445 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 25 Jan 2021 11:24:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B819F2026D3A; Mon, 25 Jan 2021 16:24:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B35D92026D37
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 16:24:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4198E82DFE0
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 16:24:10 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
	[209.85.216.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-534-JDM-y8hoMf2q6gjQndbK5A-1; Mon, 25 Jan 2021 11:24:07 -0500
X-MC-Unique: JDM-y8hoMf2q6gjQndbK5A-1
Received: by mail-pj1-f53.google.com with SMTP id gx1so3361996pjb.1
	for <dm-devel@redhat.com>; Mon, 25 Jan 2021 08:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=fXfkMAEQ+Munc2QVdjGnmLY18me6kBjN2JpuXybmej8=;
	b=rFxuoahQEu6tlY74lxLP6QQs/4txPEpFF0up10LA2s9UkEr8LEX7r3ortz6YFiYNCa
	QqNEOtvdVpRcWmVc1RKyMK/ghc5s31/AMS1sZzfwilUJelqr2hWj656eQU/0wLwJRkGj
	9AhG+DlFMecYB1tAtzulAbGC9FmJUtUQGRp2kR7TboTrdULy7t9lDzf5NMd/+tW+NbOa
	t1lCH5zdsDxkwSWGC/ib78TlHedI7duRqY2FYot+QnY8PVFQq44WQdyemZ95GdzDEaZr
	qv+Vxg3z7HWsr9y0ZEU4InhB/eGNqYSJLYSi6TjdnLUvKZveCH9D+WtEM411uDOKbYUQ
	D/uw==
X-Gm-Message-State: AOAM532llnLx3UpoCnrNCPA5CYBGqaNTbThICtG4i0BC9mB7ozy/ja9C
	JdzxUicE2ZbyFQ5BVLXz/qQRTJcZoxDlIA==
X-Google-Smtp-Source: ABdhPJyZ7TqSW5vYzS6sR2enGCQzoNcpXGNgER6vx3ER9uTn7PeFaeI8bJWpz6MeQxBxo7yasuILmQ==
X-Received: by 2002:a17:90b:908:: with SMTP id
	bo8mr987716pjb.206.1611591845774; 
	Mon, 25 Jan 2021 08:24:05 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
	by smtp.gmail.com with ESMTPSA id
	gd11sm19028097pjb.16.2021.01.25.08.24.04
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 25 Jan 2021 08:24:05 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>
References: <20210124100241.1167849-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <86dd18e9-43e9-efe5-8445-88952a95b5d8@kernel.dk>
Date: Mon, 25 Jan 2021 09:24:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210124100241.1167849-1-hch@lst.de>
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
Cc: linux-s390@vger.kernel.org, linux-bcache@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	linux-block@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] store a pointer to the block_device in struct bio
	(again) v2
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/24/21 3:02 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series switches back from storing the gendisk + partno to storing
> a block_device pointer in struct bio.  The reason is two fold:  for one
> the new struct block_device actually is always available, removing the
> need to avoid originally.  Second the merge struct block_device is much
> more useful than the old one, as storing it avoids the need for looking
> up what used to be hd_struct during partition remapping and I/O
> accounting.

Applied for 5.12, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

