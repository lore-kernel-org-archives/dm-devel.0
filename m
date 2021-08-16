Return-Path: <SRS0=c4z+=NH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BB3EC432BE
	for <dm-devel@archiver.kernel.org>; Mon, 16 Aug 2021 16:52:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A943260F58
	for <dm-devel@archiver.kernel.org>; Mon, 16 Aug 2021 16:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A943260F58
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-KB9CbwzvMHKP-WH9BvJc7A-1; Mon, 16 Aug 2021 12:52:56 -0400
X-MC-Unique: KB9CbwzvMHKP-WH9BvJc7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE60A100806D;
	Mon, 16 Aug 2021 16:52:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D04D5C1D5;
	Mon, 16 Aug 2021 16:52:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0419A4BB7C;
	Mon, 16 Aug 2021 16:52:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17GGpLA0031171 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Aug 2021 12:51:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C37D1202DD7E; Mon, 16 Aug 2021 16:51:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF1C8200C0ED
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 16:51:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AA3F800159
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 16:51:19 +0000 (UTC)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com
	[209.85.167.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-425-_9RCTLxVOfuklt3jiFZP3A-1; Mon, 16 Aug 2021 12:51:16 -0400
X-MC-Unique: _9RCTLxVOfuklt3jiFZP3A-1
Received: by mail-oi1-f175.google.com with SMTP id u25so27596619oiv.5
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 09:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=lkHKKxx6E91blWpox1bXj/LIePIAFS6deUe/aal8ts0=;
	b=juqoCqu+s9MPCKYv4afQ4nm07AVbYnzAJC7IfduR+7RQO0jfZzqzmOorz18cfuiSe1
	bsuLOLkTMd7OuJ/Mf5/2TYmxGV3Z0/gCXny2W5B4/7pWg2pWVXtx6b8AbBpW87LcsLAd
	BjJzs4yol1E4r9xvHfy9f78+zbku8DyMBCn2kCCYSTtVoYF68NB0tdntmdB7CR8xiKe2
	d5NEO+jvHSFOLTf7dzCTiYY0PbCTS9BGvv+TWd3Ko/kor+Fb5Eg8SmBnCrFKMQVRjh/j
	yZy1FVPP9TaThETitNqoYN8F1iLTwnIjhdOve9X7RvfQgmuQVH7UHuaoD7zTH/D/pNYg
	/4Pw==
X-Gm-Message-State: AOAM530Knq+4YuR5WAnuV46Ujr1mwgWkYu8LciubpXnoenWCmwnK7kNp
	3UI9DG4x0HiucyM5jc97o6xOgA==
X-Google-Smtp-Source: ABdhPJwPiJZucbHV+gTb5R7I/kfPLblHKKXb+EIub7hcvBOP41sFKxi/Q6epHu0YRXyVvO62JSl/PA==
X-Received: by 2002:a54:4619:: with SMTP id p25mr42850oip.5.1629132675579;
	Mon, 16 Aug 2021 09:51:15 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
	by smtp.gmail.com with ESMTPSA id
	u18sm2018498ooi.40.2021.08.16.09.51.13
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 16 Aug 2021 09:51:15 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
References: <20210804095634.460779-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4e321dab-188d-ca0a-a98c-4a587e7b5f27@kernel.dk>
Date: Mon, 16 Aug 2021 10:51:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
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
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Ilya Dryomov <idryomov@gmail.com>, linux-um@lists.infradead.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, ceph-devel@vger.kernel.org,
	linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Geoff Levand <geoff@infradead.org>,
	Phillip Lougher <phillip@squashfs.org.uk>
Subject: Re: [dm-devel] add a bvec_virt helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 8/4/21 3:56 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series adds a bvec_virt helper to return the virtual address of the
> data in bvec to replace the open coded calculation, and as a reminder
> that generall bio/bvec data can be in high memory unless it is caller
> controller or in an architecture specific driver where highmem is
> impossible.

Applied, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

