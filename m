Return-Path: <SRS0=txmc=K3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9EEC4708F
	for <dm-devel@archiver.kernel.org>; Tue,  1 Jun 2021 13:48:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 26D586008E
	for <dm-devel@archiver.kernel.org>; Tue,  1 Jun 2021 13:48:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26D586008E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-YsDAtJ4CNXWjN_q-q5lltQ-1; Tue, 01 Jun 2021 09:48:34 -0400
X-MC-Unique: YsDAtJ4CNXWjN_q-q5lltQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7AD29180FD64;
	Tue,  1 Jun 2021 13:48:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C7905946A;
	Tue,  1 Jun 2021 13:48:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7A4B61800BB8;
	Tue,  1 Jun 2021 13:48:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 151DmH3V029438 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Jun 2021 09:48:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 879191686D; Tue,  1 Jun 2021 13:48:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8289862181
	for <dm-devel@redhat.com>; Tue,  1 Jun 2021 13:48:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0F4F101A531
	for <dm-devel@redhat.com>; Tue,  1 Jun 2021 13:48:14 +0000 (UTC)
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com
	[209.85.167.181]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-578-ei4LRjueOYCFr72PzJlTNA-1; Tue, 01 Jun 2021 09:48:11 -0400
X-MC-Unique: ei4LRjueOYCFr72PzJlTNA-1
Received: by mail-oi1-f181.google.com with SMTP id x15so15521329oic.13
	for <dm-devel@redhat.com>; Tue, 01 Jun 2021 06:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=QlGkt7fWsHM9mcKdq1bDx/YwBl/iUUk0WEjc5rg04fY=;
	b=f4K81B8uwIGRuP5g2XC0od70LdBFNx+9TVFMiIozzs5ezCPKwYiTjLqCTof2BekF7h
	5gTWa1Fjo1gOXm3nGudUISIyHQcwSQYAKQzKeapPFuKqI3/XDiU1q3FBmWbg40lBJM7R
	5wP8mefZWH1I3x+4XHMxk28A/Mytm3nYXZOGdq81AfDsgxSuM1wZ0gYhfiF3AR2pz8+c
	gGwUrVi2leoasei/GiMjkC0mWGpYXwACDnCthgwJ++DKa2uG4+nxUITaRQPh/x0z1Fez
	SUSkLObfIOdHTjKM5OzFPyKB5gya7YTKOF560leGjc8FqKY/qjKjFzvWZ/34AVdprZkO
	O/cQ==
X-Gm-Message-State: AOAM53086fIKbPS6QDeOxnfMcIWOLy1d8x5kQrxMdUA2Uqed7Csmbhc/
	+pkXySO7WbK5fMrbqEBybsTr9w==
X-Google-Smtp-Source: ABdhPJyRtEOQYxSXItYfv2Xv0el0nwhIYWVK6zfd5YIEz7fo5+/L3t2bxzT7qaz6PyG5RR7CPJmZJA==
X-Received: by 2002:a05:6808:245:: with SMTP id
	m5mr18302900oie.6.1622555290008; 
	Tue, 01 Jun 2021 06:48:10 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
	by smtp.gmail.com with ESMTPSA id i4sm3456045oih.13.2021.06.01.06.48.07
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 01 Jun 2021 06:48:09 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>, Jim Paris <jim@jtan.com>,
	Joshua Morris <josh.h.morris@us.ibm.com>,
	Philip Kelleher <pjk1939@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Matias Bjorling <mb@lightnvm.io>, Coly Li <colyli@suse.de>,
	Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>
References: <20210521055116.1053587-1-hch@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a5d7127f-b422-5556-6810-cf4c98c038ac@kernel.dk>
Date: Tue, 1 Jun 2021 07:48:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210521055116.1053587-1-hch@lst.de>
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
Cc: linux-xtensa@linux-xtensa.org, linux-m68k@vger.kernel.org,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	drbd-dev@tron.linbit.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [dm-devel] simplify gendisk and request_queue allocation for
 bio based drivers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 5/20/21 11:50 PM, Christoph Hellwig wrote:
> Hi all,
> 
> this series is the first part of cleaning up lifetimes and allocation of
> the gendisk and request_queue structure.  It adds a new interface to
> allocate the disk and queue together for bio based drivers, and a helper
> for cleanup/free them when a driver is unloaded or a device is removed.
> 
> Together this removes the need to treat the gendisk and request_queue
> as separate entities for bio based drivers.

Applied, thanks.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

