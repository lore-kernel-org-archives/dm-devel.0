Return-Path: <SRS0=tZY5=M4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AD1C4338F
	for <dm-devel@archiver.kernel.org>; Thu,  5 Aug 2021 16:31:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6502F6113B
	for <dm-devel@archiver.kernel.org>; Thu,  5 Aug 2021 16:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6502F6113B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-guPa7TV6ORCb5oBVlsjr2A-1; Thu, 05 Aug 2021 12:31:39 -0400
X-MC-Unique: guPa7TV6ORCb5oBVlsjr2A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DAC2C7441;
	Thu,  5 Aug 2021 16:31:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73BD65C1A1;
	Thu,  5 Aug 2021 16:31:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 81B26181A863;
	Thu,  5 Aug 2021 16:31:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 175GVIb5002125 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 5 Aug 2021 12:31:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C5F9A209A50C; Thu,  5 Aug 2021 16:31:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C1F40209A515
	for <dm-devel@redhat.com>; Thu,  5 Aug 2021 16:31:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC934101A52C
	for <dm-devel@redhat.com>; Thu,  5 Aug 2021 16:31:15 +0000 (UTC)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
	[209.85.216.42]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-414-d37pevEMO0KTOkFXOkYJTQ-1; Thu, 05 Aug 2021 12:31:13 -0400
X-MC-Unique: d37pevEMO0KTOkFXOkYJTQ-1
Received: by mail-pj1-f42.google.com with SMTP id a8so10145190pjk.4;
	Thu, 05 Aug 2021 09:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=hHUTsKDnxap0EiJI1vbHiNIpoH+R0H2TboThtqpCWSc=;
	b=WQQLfkuydEhzkREF09KcwOR2AqXWcAko4yaDUEnWFof1tFFLkRwh76qSmhXmX6JGFW
	jpBQ+juf95iRIcSs3N+sCWKOmVs8nwccY/l9kwj2MsnLRy8LA9x/+X6pLvViyp9ZJGkv
	fZkeajcV8WzF3ZGyUpddPOScr0Vkccqn+5MnKHl0rL5avbPNg7BZb+cVbOLsVk86U6NH
	8NFIuUcqQ7/zGf6p7JJ0L+XgxbjbCnJCLbXov8zV2Fdd/1hmnoc55WyFOt8OofoeYT6f
	hIwwDGiBVHiSVIBhWUcWZrORJuWbTCv4ZhOnRfCpJwoPG8g0uy8TBgUfXRoSVAONk3eo
	yScQ==
X-Gm-Message-State: AOAM531bg1REl6Nz0ntoMXfWojZIagoFluU39fky2mqDmKJ3XD643pb5
	QBYXiCxbtlKs/3TGi+XRHbY=
X-Google-Smtp-Source: ABdhPJyCuisk5RzZy6da7AsZoR/DaZLZHn4oZn9ITXuwK2Rjv1pBKXahTV8aXSruiOZbF6hVQSA8vQ==
X-Received: by 2002:a17:90a:9f91:: with SMTP id
	o17mr15924247pjp.29.1628181071870; 
	Thu, 05 Aug 2021 09:31:11 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com
	([2620:15c:211:1:93c2:eaf5:530d:627d])
	by smtp.gmail.com with ESMTPSA id r4sm6334361pjo.46.2021.08.05.09.31.09
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 05 Aug 2021 09:31:10 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20210804095634.460779-1-hch@lst.de>
	<20210804095634.460779-11-hch@lst.de>
From: Bart Van Assche <bvanassche@acm.org>
Message-ID: <8b487c0f-71be-19d6-249c-9cd1ba228548@acm.org>
Date: Thu, 5 Aug 2021 09:31:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-11-hch@lst.de>
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
	Phillip Lougher <phillip@squashfs.org.uk>,
	ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Geoff Levand <geoff@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [dm-devel] [PATCH 10/15] sd: use bvec_virt
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/4/21 2:56 AM, Christoph Hellwig wrote:
> Use bvec_virt instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/sd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index b8d55af763f9..5b5b8266e142 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -886,7 +886,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
>   	cmd->cmnd[0] = UNMAP;
>   	cmd->cmnd[8] = 24;
>   
> -	buf = page_address(rq->special_vec.bv_page);
> +	buf = bvec_virt(&rq->special_vec);
>   	put_unaligned_be16(6 + 16, &buf[0]);
>   	put_unaligned_be16(16, &buf[2]);
>   	put_unaligned_be64(lba, &buf[8]);

The patch description is not correct. The above patch involves a 
functional change while the patch description suggests that no 
functionality has been changed.

Although the above patch looks fine to me, why has page_address() been 
changed into bvec_virt() in the sd driver? My understanding is that the 
sd driver always sets bv_offset to zero.

Thanks,

Bart.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

