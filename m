Return-Path: <SRS0=ry1C=NA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B79D1C4338F
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 24F6660234
	for <dm-devel@archiver.kernel.org>; Mon,  9 Aug 2021 06:53:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 24F6660234
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-apNWcDoUO_m4kjDN72DKcQ-1; Mon, 09 Aug 2021 02:53:14 -0400
X-MC-Unique: apNWcDoUO_m4kjDN72DKcQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCBA6180FCCD;
	Mon,  9 Aug 2021 06:53:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F0A745D6CF;
	Mon,  9 Aug 2021 06:53:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EFD59180BAB1;
	Mon,  9 Aug 2021 06:53:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1756JqxX028692 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 02:19:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 22DC5103799; Thu,  5 Aug 2021 06:19:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D9A7103792
	for <dm-devel@redhat.com>; Thu,  5 Aug 2021 06:19:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 917CD101A529
	for <dm-devel@redhat.com>; Thu,  5 Aug 2021 06:19:49 +0000 (UTC)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com
	[209.85.216.47]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-576-pU8rxAFePrGq0Y6j6Dg2Pw-1; Thu, 05 Aug 2021 02:19:47 -0400
X-MC-Unique: pU8rxAFePrGq0Y6j6Dg2Pw-1
Received: by mail-pj1-f47.google.com with SMTP id
	dw2-20020a17090b0942b0290177cb475142so12547427pjb.2; 
	Wed, 04 Aug 2021 23:19:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=Us8M4Gz10TOU+v1I5NsNfx0zgCQlwHS7fXqY8nkODX4=;
	b=FjVQKCe0e+MAKxF3uVZZHcLGpI591MyLbisvhYxGo550rwRgMeAopd623p3HeQqnKs
	ozHg4qGc7wX4XCg5GoGtm8wi6of1RQJztjOf1FnzU/gTNZdM13C+uQ6Ukc9hjOqrXnH2
	3aosobZLjC2e+e97dHOMtTEvf7U+z1hzi+Gle0xAIyyUAZQb++Z2dy5j2uVGvbyWUlzE
	tvffgSy4ToRYrUsGp0j60sDppE4CZY8nta0b6gxWlR+X7MY6ft34a2OMP1z4cubdtp8n
	H1vBc3Jv5RB5p1VLlS82bFPtAHzKjHgRe2C8hmv2FtK1njrbMT8BElOY50Uza5KSyrVB
	hF2g==
X-Gm-Message-State: AOAM532osq2ei7GRwUsaEXPN22aacOaJ32bc+V/3WkKwYHSt7yGs2s3M
	zsnrEfjxovv3hbQFDVUOiwc=
X-Google-Smtp-Source: ABdhPJylCwEmCslg5aa1nc2EitMfnv0khm5CC20SSkcpOfTgA4if26raJjt9hmbh77ooLfOKEQ2BOg==
X-Received: by 2002:a17:90a:fef:: with SMTP id
	102mr13385008pjz.148.1628144385681; 
	Wed, 04 Aug 2021 23:19:45 -0700 (PDT)
Received: from [192.168.50.71] (ip70-175-137-120.oc.oc.cox.net.
	[70.175.137.120]) by smtp.gmail.com with ESMTPSA id
	l11sm5198375pfd.187.2021.08.04.23.19.43
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 04 Aug 2021 23:19:45 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210804095634.460779-1-hch@lst.de>
	<20210804095634.460779-3-hch@lst.de>
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Message-ID: <b1d05349-86d2-0334-436f-811600ee1578@gmail.com>
Date: Wed, 4 Aug 2021 23:19:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-3-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 02/15] block: use bvec_virt in
 bio_integrity_{process, free}
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 8/4/2021 2:56 AM, Christoph Hellwig wrote:
> Use the bvec_virt helper to clean up the bio integrity processing a
> little bit.
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

