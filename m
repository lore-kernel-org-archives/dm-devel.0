Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A32C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 16:48:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 81D9B64F07
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 16:48:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 81D9B64F07
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-9yzbhet1NG2Ta4yB8mfhmQ-1; Wed, 24 Feb 2021 11:48:47 -0500
X-MC-Unique: 9yzbhet1NG2Ta4yB8mfhmQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3CBA803F47;
	Wed, 24 Feb 2021 16:48:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 78AF35D9DC;
	Wed, 24 Feb 2021 16:48:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 924644EE4D;
	Wed, 24 Feb 2021 16:48:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11OGmS39022665 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 11:48:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A1F2710EB2AB; Wed, 24 Feb 2021 16:48:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D04E10EB2AA
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 16:48:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70D02100AFE2
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 16:48:26 +0000 (UTC)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
	[209.85.166.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-94-bUAMYEEcNb6V5J4uIxSAlg-1; Wed, 24 Feb 2021 11:48:24 -0500
X-MC-Unique: bUAMYEEcNb6V5J4uIxSAlg-1
Received: by mail-io1-f53.google.com with SMTP id p16so2687103ioj.4
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 08:48:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=1+mpX7zx0n4pKPlEw3hBAnsSTnEgaecbMXBQXh8Z37U=;
	b=ToB65O16hq6Qa5F2XN5HCj6QqMinqFzEbtZFPWq0oKZoc9pVEaBEiPzGiMzIfINobX
	uoC6dRqm6yi7JncJ6mloliFJQMkk0Mqxci9HZcMugopwZ9S90gvYCDseRDv6mGN/le7q
	qTXsdvEX1ESYUSNhdVJSDSR/QYYU7xdr8PloEmgTXUlghtwx3j8o5+aOfvDm4xIoPzyQ
	RferRJ5p4pU+gjJBwIanaTYuNWgVC7XMUoz9vSjVgNkxXtHSh70ZZZYfyEtL3txs/2EX
	PoggUhm3Gkh4jN7YPN1cbfoOWzQbyd4Zk8hz94nXYPQ3hHLkQtH/yWzuJTm3nuq0UOdJ
	pc2g==
X-Gm-Message-State: AOAM531C7HbKsKRKh0qIxLSE8S14DN3mgDseS+2js4v8MEyl4UwpAoIX
	0D532F7cR0j6LGK5EKszfGBptg==
X-Google-Smtp-Source: ABdhPJwss97019ILy/7qQcv1GNjekopW38KQaiSTkiRj6pTu3XozM6UbMn7yxILO9vbNkFv7yo9ZjA==
X-Received: by 2002:a02:1c49:: with SMTP id c70mr34122809jac.136.1614185303233;
	Wed, 24 Feb 2021 08:48:23 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
	by smtp.gmail.com with ESMTPSA id m15sm1760501ilh.6.2021.02.24.08.48.21
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 24 Feb 2021 08:48:22 -0800 (PST)
To: Stefan Hajnoczi <stefanha@redhat.com>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
References: <20210222211115.30416-1-chaitanya.kulkarni@wdc.com>
	<YDY+ObNNiBMMuSEt@stefanha-x1.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f3141eb3-9938-a216-a9f8-cb193589a657@kernel.dk>
Date: Wed, 24 Feb 2021 09:48:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YDY+ObNNiBMMuSEt@stefanha-x1.localdomain>
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
Cc: ulf.hansson@linaro.org, snitzer@redhat.com, mst@redhat.com,
	jasowang@redhat.com, virtualization@lists.linux-foundation.org,
	bfields@fieldses.org, linux-ide@vger.kernel.org,
	dm-devel@redhat.com, target-devel@vger.kernel.org,
	alim.akhtar@samsung.com, agk@redhat.com, beanhuo@micron.com,
	stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
	cang@codeaurora.org, tim@cyberelk.net, dgilbert@interlog.com,
	vbadigan@codeaurora.org, richard.peng@oppo.com,
	jejb@linux.ibm.com, guoqing.jiang@cloud.ionos.com,
	linux-block@vger.kernel.org, avri.altman@wdc.com, bp@alien8.de,
	jaegeuk@kernel.org, Kai.Makisara@kolumbus.fi,
	linux-nfs@vger.kernel.org, martin.petersen@oracle.com,
	baolin.wang@linaro.org, linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
	chuck.lever@oracle.com, zliua@micron.com, pbonzini@redhat.com,
	davem@davemloft.net, asutoshd@codeaurora.org
Subject: Re: [dm-devel] [RFC PATCH] blk-core: remove blk_put_request()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2/24/21 4:53 AM, Stefan Hajnoczi wrote:
> On Mon, Feb 22, 2021 at 01:11:15PM -0800, Chaitanya Kulkarni wrote:
>> The function blk_put_request() is just a wrapper to
>> blk_mq_free_request(), remove the unnecessary wrapper.
>>
>> Any feedback is welcome on this RFC.
>>
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>> ---
>>  block/blk-core.c                   |  6 ------
>>  block/blk-merge.c                  |  2 +-
>>  block/bsg-lib.c                    |  4 ++--
>>  block/bsg.c                        |  4 ++--
>>  block/scsi_ioctl.c                 |  6 +++---
>>  drivers/block/paride/pd.c          |  2 +-
>>  drivers/block/pktcdvd.c            |  2 +-
>>  drivers/block/virtio_blk.c         |  2 +-
>>  drivers/cdrom/cdrom.c              |  4 ++--
>>  drivers/ide/ide-atapi.c            |  2 +-
>>  drivers/ide/ide-cd.c               |  4 ++--
>>  drivers/ide/ide-cd_ioctl.c         |  2 +-
>>  drivers/ide/ide-devsets.c          |  2 +-
>>  drivers/ide/ide-disk.c             |  2 +-
>>  drivers/ide/ide-ioctls.c           |  4 ++--
>>  drivers/ide/ide-park.c             |  2 +-
>>  drivers/ide/ide-pm.c               |  4 ++--
>>  drivers/ide/ide-tape.c             |  2 +-
>>  drivers/ide/ide-taskfile.c         |  2 +-
>>  drivers/md/dm-mpath.c              |  2 +-
>>  drivers/mmc/core/block.c           | 10 +++++-----
>>  drivers/scsi/scsi_error.c          |  2 +-
>>  drivers/scsi/scsi_lib.c            |  2 +-
>>  drivers/scsi/sg.c                  |  6 +++---
>>  drivers/scsi/st.c                  |  4 ++--
>>  drivers/scsi/ufs/ufshcd.c          |  6 +++---
>>  drivers/target/target_core_pscsi.c |  4 ++--
>>  fs/nfsd/blocklayout.c              |  4 ++--
>>  include/linux/blkdev.h             |  1 -
>>  29 files changed, 46 insertions(+), 53 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index fc60ff208497..1754f5e7cc80 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -642,12 +642,6 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
>>  }
>>  EXPORT_SYMBOL(blk_get_request);
>>  
>> -void blk_put_request(struct request *req)
>> -{
>> -	blk_mq_free_request(req);
>> -}
>> -EXPORT_SYMBOL(blk_put_request);
> 
> blk_get_request() still exists after this patch. A "get" API usually has
> a corresponding "put" API. I'm not sure this patch helps the consistency
> and clarity of the code.
> 
> If you do go ahead, please update the blk_get_request() doc comment
> explicitly mentioning that blk_mq_free_request() needs to be called.

Would make sense to rename blk_get_request() to blk_mq_alloc_request()
and then we have API symmetry. The get/put don't make sense when there
are no references involved.

But it's a lot of churn for very little reward, which is always kind
of annoying. Especially for the person that has to carry the patches.

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

