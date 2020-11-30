Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7930EC5519F
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:03:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3566206CA
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3566206CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=ieee.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-2PSYMGDXPdejplvqSEEDKw-1; Mon, 30 Nov 2020 02:03:02 -0500
X-MC-Unique: 2PSYMGDXPdejplvqSEEDKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3614018C8C00;
	Mon, 30 Nov 2020 07:02:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A36860C64;
	Mon, 30 Nov 2020 07:02:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E07541809CA0;
	Mon, 30 Nov 2020 07:02:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU1Nbdd013169 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 29 Nov 2020 20:23:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 018C0112D433; Mon, 30 Nov 2020 01:23:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1C0510031EC
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 01:23:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67D07858284
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 01:23:34 +0000 (UTC)
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com
	[209.85.166.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-177-xjyZyd76MfKA2EdcDp91fw-1; Sun, 29 Nov 2020 20:23:31 -0500
X-MC-Unique: xjyZyd76MfKA2EdcDp91fw-1
Received: by mail-il1-f196.google.com with SMTP id x15so9810751ilq.1
	for <dm-devel@redhat.com>; Sun, 29 Nov 2020 17:23:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=BZmTZBqdpz8QAbNwD292cR5AKXCzTrvi1V4QZo4ASiQ=;
	b=ciUm+QzqBZvfgBDMfOJIEaeAIkce+RQw/2V47HyL6oGpCvx+0k2LTKJ80H1/ThT2ad
	5YCh+ltxBFJ1KNhz7JqGhNPOnfPhzBklL07HKYrc+LdcL6igpQWUUtFo7i4dhH/2hG3g
	/QLklzBJuGww52nFJiUi7RSLxaD9D9uNvJnqGGFwCvM0wfiOQSeiucVQ6m1dnINViZ6w
	kij9ki+tLPoftSA/M6HP7hZmGh1z6eqg5DQjD+pLrmjUVbm3fHBFzL6guI3K33m0h4x4
	PkEvbF7dFVRtRXzRivxDncoUDMggea4Cz3e2EO+9G1D2xcuGgJqhDKO6NrCjfP92WBlk
	NvAA==
X-Gm-Message-State: AOAM531Pk407VjDYgsJwgE5ZYzg/OCljWHo8pwwN1JUvq72WwqAKYpfu
	a/xTLRCdKpcmVsQkwZ5/SWzx8g==
X-Google-Smtp-Source: ABdhPJx6pfJfEezIuUrTQnLZt8wZNJbVHV799bmuRFAi7zQbwNigfx6jMUois48aZKI1igPQUl300Q==
X-Received: by 2002:a92:84c1:: with SMTP id y62mr16165882ilk.191.1606699411252;
	Sun, 29 Nov 2020 17:23:31 -0800 (PST)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net.
	[73.185.129.58]) by smtp.googlemail.com with ESMTPSA id
	n10sm7216731iom.36.2020.11.29.17.23.29
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sun, 29 Nov 2020 17:23:30 -0800 (PST)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201129181926.897775-1-hch@lst.de>
	<20201129181926.897775-2-hch@lst.de>
From: Alex Elder <elder@ieee.org>
Message-ID: <44c60506-059f-f272-208f-a39d94a8617d@ieee.org>
Date: Sun, 29 Nov 2020 19:23:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201129181926.897775-2-hch@lst.de>
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
X-Mailman-Approved-At: Mon, 30 Nov 2020 02:02:38 -0500
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/4] block: add a hard-readonly flag to
	struct gendisk
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/29/20 12:19 PM, Christoph Hellwig wrote:
> Commit 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading
> partition") addressed a long-standing problem with user read-only

Little nit I noticed below.	-Alex

. . .

> diff --git a/block/genhd.c b/block/genhd.c
> index 565cf36a5f1864..5e746223b6fa0f 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1625,31 +1625,35 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
>  	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
>  }
>  
> -void set_disk_ro(struct gendisk *disk, int flag)
> +/**
> + * set_disk_ro - set a gendisk read-only
> + * @disk:	The disk device
> + * @state:	true or false

s/state/read_only/

> + *
> + * This function is used to indicate whether a given disk device should have its
> + * read-only flag set. set_disk_ro() is typically used by device drivers to
> + * indicate whether the underlying physical device is write-protected.
> + */
> +void set_disk_ro(struct gendisk *disk, bool read_only)

. . .


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

