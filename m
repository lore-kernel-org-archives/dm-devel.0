Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9844C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3836560F55
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3836560F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-6Iy0VssHPSe9L0mmBvpVxA-1; Mon, 09 Aug 2021 02:53:38 -0400
X-MC-Unique: 6Iy0VssHPSe9L0mmBvpVxA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E6C6875057;
	Mon,  9 Aug 2021 06:53:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F3C060E3A;
	Mon,  9 Aug 2021 06:53:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 10D414A7CA;
	Mon,  9 Aug 2021 06:53:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1756JSmD028668 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 02:19:28 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A44F0208BDFB; Thu,  5 Aug 2021 06:19:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F63E208BDFA
	for <dm-devel@redhat.com>; Thu,  5 Aug 2021 06:19:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9752C8CA940
	for <dm-devel@redhat.com>; Thu,  5 Aug 2021 06:19:24 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-339-ZiZroQrmOGiw89Jqrge9UQ-1; Thu, 05 Aug 2021 02:19:21 -0400
X-MC-Unique: ZiZroQrmOGiw89Jqrge9UQ-1
Received: by mail-pj1-f46.google.com with SMTP id
	u13-20020a17090abb0db0290177e1d9b3f7so12546741pjr.1; 
	Wed, 04 Aug 2021 23:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=GPxSQQeg/1xiiyvVf6IgyfR1PvTtE3HCXKKlX2KChmc=;
	b=fNl9OdRlsPeKc+wchRCuVgNCWzVTeYIt8ZnrurSUMBegDkLfiNk1e4XGpAQBvYXP51
	abX4uLherHuMhmKsfrnR2aOzsZKaqzEXTeFiI1GcTzkYKOkwwbddOVxBsxSaBoFe4DC1
	ixZS2N141LBydVjY41HnvqiQJN3HVIAR+VuHtd/Xx//ettziPmNMqz+VZwSCrNe4SwUf
	nRVOcYw3RBpekRo4MIINCTYfYEviSMlhBGHtXsUTUXzBowXuQsxD/6VExmA3RBNv+TkM
	k/WGSKLB9UZPXaON4Ut+uUuWE6ru5r3yJ8r/3afZ4X6KsJy6dTR9cOml6tHoe968/1oG
	YV/A==
X-Gm-Message-State: AOAM532Qtb0G20QabOI7a96tTXJ8qy3yNmBJhshfSmzFhABwQT5wP3tY
	qC8YtbqLBFvgRqPehspriOc=
X-Google-Smtp-Source: ABdhPJzeskio9QxTfARCpVMY2gidZf6SLUjVWuxeo150xpv+qmxRaymRfQR/fNIHsIoETSfCeZLEfQ==
X-Received: by 2002:a17:90a:2c0c:: with SMTP id
	m12mr1622578pjd.107.1628144360352; 
	Wed, 04 Aug 2021 23:19:20 -0700 (PDT)
Received: from [192.168.50.71] (ip70-175-137-120.oc.oc.cox.net.
	[70.175.137.120]) by smtp.gmail.com with ESMTPSA id
	k8sm4815975pfu.116.2021.08.04.23.19.18
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 04 Aug 2021 23:19:20 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210804095634.460779-1-hch@lst.de>
	<20210804095634.460779-2-hch@lst.de>
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Message-ID: <77fc6660-9c6a-0810-d04f-b6661fa0621b@gmail.com>
Date: Wed, 4 Aug 2021 23:19:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-2-hch@lst.de>
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
X-Mailman-Approved-At: Mon, 09 Aug 2021 02:53:04 -0400
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
Subject: Re: [dm-devel] [PATCH 01/15] bvec: add a bvec_virt helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 8/4/2021 2:56 AM, Christoph Hellwig wrote:
> Add a helper to get the virtual address for a bvec.  This avoids that
> all callers need to know about the page + offset representation.
> 
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@kernel.org>

-- 
-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

