Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E289C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 08:01:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-8_ee_WasOZqhGLRLC_aWgw-1; Mon, 18 Apr 2022 04:01:14 -0400
X-MC-Unique: 8_ee_WasOZqhGLRLC_aWgw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CD2D1800756;
	Mon, 18 Apr 2022 08:01:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7867B200C0DE;
	Mon, 18 Apr 2022 08:01:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 30C051947BBE;
	Mon, 18 Apr 2022 08:01:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 883C219451F3
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 08:01:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6B959C5094E; Mon, 18 Apr 2022 08:01:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67756C15D76
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 08:01:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EDC11C05AFA
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 08:01:10 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-jl99vMT2MtmGRYOFkBST2w-1; Mon, 18 Apr 2022 04:01:07 -0400
X-MC-Unique: jl99vMT2MtmGRYOFkBST2w-1
X-IronPort-AV: E=Sophos;i="5.90,269,1643644800"; d="scan'208";a="203014379"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 16:01:05 +0800
IronPort-SDR: wLu/7P4cceIb4DCY1oKdhoS0j9P3s4btYkk4rj9gBULYf7Ded9Rr0yL6cJed0XzK1Obp+N31ir
 aNlFMP1egcp8j2PJGObTQNWolVhQkr16183wDwNy+xUhfFnxQmXOEyO+yJ8MjwPM0aDQ0BjLB8
 YHQBV1koz+XOgdXpxm81mBs+vnTRdaG0+nebLH7mUAEhlUEgntFHhiN+RJSrsTkXTTzazvqg9o
 8td5rZwB3bLL31ujbDGxMpYSgVlkDQM/uiU1qVjHjffe1SXYEGtMsDV12xbMmPkApIEuMzUKGU
 E7gM2WfGiRUAcBzPr4Eg/f2X
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 18 Apr 2022 00:32:13 -0700
IronPort-SDR: rq+iTha3wz5ILkrh4/61BCnLXcejw2RdNNiaMCCzaMasWLLW0rRNnO3DjFLgRNW3L+QWuqyQ4o
 rTVIbZXeZIyf2nhJh9uy3WXzMBthEB+7mxzLRdZcrHHFY6A/E0JfAnglRJjEQKDoeT/JE2+QZ+
 QRRjcxgDKz/uXcndOxQTcrFjWdJRROtSqPNUkQBaI3qJ0n6uBVZ5R5sJfsL5DBOiksggzV8b39
 GHFmgheZY2zXf+Drb3kBYuYIzhpzCyQbxav76L6ohfl0NMc11TBI/4WJ6+q+sC349yxZAJ3Q0i
 Qrc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 18 Apr 2022 01:01:06 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhfWj3q0yz1SVp1
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 01:01:05 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id JXSl29sqRZkn for <dm-devel@redhat.com>;
 Mon, 18 Apr 2022 01:01:04 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhfWd1wHlz1Rvlx;
 Mon, 18 Apr 2022 01:01:01 -0700 (PDT)
Message-ID: <fb5baf81-fa19-bb48-865c-e13277a0952a@opensource.wdc.com>
Date: Mon, 18 Apr 2022 17:01:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-4-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220418045314.360785-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 03/11] null_blk: don't set the
 discard_alignment queue limit
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-nvme@lists.infradead.org, virtualization@lists.linux-foundation.org,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 "Md. Haris Iqbal" <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 linux-s390@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 xen-devel@lists.xenproject.org, Mike Snitzer <snitzer@kernel.org>,
 linux-um@lists.infradead.org, Josef Bacik <josef@toxicpanda.com>,
 nbd@other.debian.org, linux-raid@vger.kernel.org,
 Stefan Haberland <sth@linux.ibm.com>, linux-block@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/18/22 13:53, Christoph Hellwig wrote:
> The discard_alignment queue limit is named a bit misleading means the
> offset into the block device at which the discard granularity starts.
> Setting it to the discard granularity as done by null_blk is mostly
> harmless but also useless.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/null_blk/main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index 5cb4c92cdffea..a521e914a9843 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1765,7 +1765,6 @@ static void null_config_discard(struct nullb *nullb)
>  	}
>  
>  	nullb->q->limits.discard_granularity = nullb->dev->blocksize;
> -	nullb->q->limits.discard_alignment = nullb->dev->blocksize;
>  	blk_queue_max_discard_sectors(nullb->q, UINT_MAX >> 9);
>  }
>  

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

