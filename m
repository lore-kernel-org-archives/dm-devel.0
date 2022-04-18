Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77631C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 08:04:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-HZJvkNFCM_q3QP5qWpt8CQ-1; Mon, 18 Apr 2022 04:04:25 -0400
X-MC-Unique: HZJvkNFCM_q3QP5qWpt8CQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3ED91857F07;
	Mon, 18 Apr 2022 08:04:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B1AD840D2827;
	Mon, 18 Apr 2022 08:04:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 522641947BBC;
	Mon, 18 Apr 2022 08:04:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E63B1947BBB
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 08:04:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C4FED57C932; Mon, 18 Apr 2022 08:04:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C0C6E57C929
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 08:04:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A96FF833964
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 08:04:21 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-h7jgWfYDMWCj_QDTYGuJDw-2; Mon, 18 Apr 2022 04:04:20 -0400
X-MC-Unique: h7jgWfYDMWCj_QDTYGuJDw-2
X-IronPort-AV: E=Sophos;i="5.90,269,1643644800"; d="scan'208";a="203014700"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 16:04:17 +0800
IronPort-SDR: dO3DdyTeGpOJfrXNE+oS0lq/Y8kP1bUaCm67GfoVy1UF5G6Tw4HeRwtqImKoyWYaxqIN1Eikyv
 f4AH9HR9RX9le4z1VIx8h1JZJAe0PHj5+Le2EBJtPa5W3T5dFcykoI7nlwW2lEymlxo0rAYqxE
 1EOBZMUz++MyQoi5/lx8OymuFgdnzFiikRGNtrrLlN3OwU2qSrtVcQKhRm4czsckgxkJNaq68L
 /yXIWvwJHLm//Emk5wRKLlnv8PQQQCuLqi89TzJmSi1+EM5NNr4aFLgAMNGNo7mneHKKjqW/5A
 ACpWqHJq9cRjG0j+D4Z7lnaY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 18 Apr 2022 00:34:38 -0700
IronPort-SDR: a1c/wAqv1y+2irgfACvZQhNMAC4m+iXMKvniOH2q4tRj9YfXjckxJnh61L3TeSLhixnXGILRcI
 P4MBOMi164b1YEo5Ps8jDE0TnuK3OCywd2cMpDAspKLd4eFjJKG5Higz4BEHFeOxdm2YVKZtgE
 349+6JY/OUDflK1TQAuqMTyIifxeReiFjtPfAcfo1MF6VQ4Nvad7DChCI3uJlwKh3gQr90PulJ
 p5e8LevRFvR9VwhqwqTgjCk8TvJMQAc0c+NMW4+k2U/f5Qzg7gX72/N1oiz0xJl9wPlCeBtLKp
 4/8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 18 Apr 2022 01:04:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhfbP1SZqz1SVnx
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 01:04:17 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id IvdJxoQsA0YL for <dm-devel@redhat.com>;
 Mon, 18 Apr 2022 01:04:16 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhfbJ6g7Wz1Rwrw;
 Mon, 18 Apr 2022 01:04:12 -0700 (PDT)
Message-ID: <18032025-f1aa-2daa-d012-8996590ada6a@opensource.wdc.com>
Date: Mon, 18 Apr 2022 17:04:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-9-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220418045314.360785-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH 08/11] loop: remove a spurious clear of
 discard_alignment
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/18/22 13:53, Christoph Hellwig wrote:
> The loop driver never sets a discard_alignment, so it also doens't need
> to clear it to zero.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/loop.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 976cf987b3920..61b642b966a08 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -789,7 +789,6 @@ static void loop_config_discard(struct loop_device *lo)
>  		blk_queue_max_discard_sectors(q, 0);
>  		blk_queue_max_write_zeroes_sectors(q, 0);
>  	}
> -	q->limits.discard_alignment = 0;
>  }
>  
>  struct loop_worker {

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

