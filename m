Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBE9C433ED
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 21:18:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 86CD861352
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 21:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86CD861352
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-6j-B6okdOpaAABx4OS3H2A-1; Thu, 13 May 2021 17:18:36 -0400
X-MC-Unique: 6j-B6okdOpaAABx4OS3H2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4957107ACCD;
	Thu, 13 May 2021 21:18:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CF9B10013C1;
	Thu, 13 May 2021 21:18:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6B85955348;
	Thu, 13 May 2021 21:18:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DLIQs6029264 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 17:18:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F55410CD6D4; Thu, 13 May 2021 21:18:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A31610CD2DA
	for <dm-devel@redhat.com>; Thu, 13 May 2021 21:18:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8478858F0D
	for <dm-devel@redhat.com>; Thu, 13 May 2021 21:18:23 +0000 (UTC)
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com
	[209.85.216.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-149-GjpnLy9ZP-SrpBNPYqkYtw-1; Thu, 13 May 2021 17:18:19 -0400
X-MC-Unique: GjpnLy9ZP-SrpBNPYqkYtw-1
Received: by mail-pj1-f45.google.com with SMTP id
	b9-20020a17090a9909b029015cf9effaeaso248880pjp.5; 
	Thu, 13 May 2021 14:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=mvZf3JNCBPnJCp6W7ETlVadxetawitWuzaHn0wwc8uQ=;
	b=nAExbPuaInfu9jebZzcwBt08nUTaLdRdfcWvLxsGYgZ6IJnYNSpvtT1ABz392YJ9Qg
	WLQw9US8dE84gazr1Hvg0BATr2HVwrRQ7YjtCWTXiDwzWUx6wfNVSGGcfWpTln099sD8
	Fk9ZO7uRaNwwK2TbGRWr9d8/qglldM0HbQoRnELqn9O/wEOenPjwqNmFhKWnLyv/fwAV
	GcKDz/+eqi1g9aq9B2D7jtkgYlLXWzhTvTGzQJ/f1BBUvvEBiB4dp8z1zUWCvSxihMzi
	wRMr5EkCSAGOQaJYL7t4dVM8z2vQ1EB0GWMZ3XRq8ZnO/W+RE54B+vns2y1a0B042lKW
	Z1Ig==
X-Gm-Message-State: AOAM532dLGTJEIzvmgD+K6Y4RYWNpCm6SeKESuUU0Hm6Q9LrteXHT8ja
	WeTXNIklKAHJ6mD/Q12/Qx7K4B4UaG+Imw==
X-Google-Smtp-Source: ABdhPJwewpa0foiOfv5+uWT766FJFkGKaXiL58aPMNLdz8Z3MaXuEV5io4OkQpitS3h5OFIBnffzhg==
X-Received: by 2002:a17:90b:84:: with SMTP id bb4mr6992032pjb.60.1620940697238;
	Thu, 13 May 2021 14:18:17 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:54a8:4531:57a:cfd8?
	([2601:647:4000:d7:54a8:4531:57a:cfd8])
	by smtp.gmail.com with ESMTPSA id
	l35sm2809109pgm.10.2021.05.13.14.18.15
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 13 May 2021 14:18:16 -0700 (PDT)
To: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, Changheun Lee <nanich.lee@samsung.com>
References: <a01ab479-69e8-9395-7d24-9de1eec28aff@acm.org>
	<0e7b0b6e-e78c-f22d-af8d-d7bdcb597bea@gmail.com>
	<alpine.LRH.2.02.2105131510330.21927@file01.intranet.prod.int.rdu2.redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <fdee795d-7a4b-9506-b9ca-359b9bcbec34@acm.org>
Date: Thu, 13 May 2021 14:18:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2105131510330.21927@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: axboe@kernel.dk, yi.zhang@redhat.com, bgoncalv@redhat.com,
	dm-crypt@saout.de, linux-kernel@vger.kernel.org,
	alex_y_xu@yahoo.ca, ming.lei@redhat.com,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org, jaegeuk@kernel.org,
	linux-ext4@vger.kernel.org, hch@lst.de
Subject: Re: [dm-devel] regression: data corruption with ext4 on LUKS on
 nvme with torvalds master
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/13/21 12:22 PM, Mikulas Patocka wrote:
> We already had problems with too large bios in dm-crypt and we fixed it by 
> adding this piece of code:
> 
>         /*
>          * Check if bio is too large, split as needed.
>          */
>         if (unlikely(bio->bi_iter.bi_size > (BIO_MAX_VECS << PAGE_SHIFT)) &&
>             (bio_data_dir(bio) == WRITE || cc->on_disk_tag_size))
>                 dm_accept_partial_bio(bio, ((BIO_MAX_VECS << PAGE_SHIFT) >> SECTOR_SHIFT));
> 
> It will ask the device mapper to split the bio if it is too large. So, 
> crypt_alloc_buffer can't receive a bio that is larger than BIO_MAX_VECS << 
> PAGE_SHIFT.

Hi Mikulas,

Are you perhaps referring to commit 4e870e948fba ("dm crypt: fix error
with too large bios")? Did that commit go upstream before multi-page
bvec support? Can larger bios be supported in case of two or more
contiguous pages now that multi-page bvec support is upstream?

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

