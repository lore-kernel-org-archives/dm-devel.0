Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A6BC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 08:02:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-Ix37JnDNOPuWM-AOWQfmmg-1; Mon, 18 Apr 2022 04:02:28 -0400
X-MC-Unique: Ix37JnDNOPuWM-AOWQfmmg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7AAD811E76;
	Mon, 18 Apr 2022 08:02:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A68007C28;
	Mon, 18 Apr 2022 08:02:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 791FA1947BBC;
	Mon, 18 Apr 2022 08:02:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C6D0C1947BBB
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 08:02:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5DBAC4C7D8; Mon, 18 Apr 2022 08:02:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF6E4C15D76
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 08:02:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91A7686B8A0
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 08:02:25 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-pTdyHJwDN6CRx7QaKVlYrg-1; Mon, 18 Apr 2022 04:02:20 -0400
X-MC-Unique: pTdyHJwDN6CRx7QaKVlYrg-1
X-IronPort-AV: E=Sophos;i="5.90,269,1643644800"; d="scan'208";a="197010250"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 16:02:19 +0800
IronPort-SDR: 2FS6WXg6v0PFHWuVASvbMbe6XuYHUr9z8WWxrjA1UUQ5XCos1XnJ7NF8NdoJm1/+v5AluNQwcf
 TBHAa/JXAVnSkUnRGdXe5VNEK1jkpU8T7A5mDjIDqkzkADDFFKAS/CF8bpnJf28FkksSbEahVJ
 4RAs8XphqJShyLjMRrEEClW9tyHUpl7R++Sz0QBOZETCRDN8uJc0GGPqNkodBDQxoqBYT9l4O7
 75I4GnLFLW/7h7rs/b6YdiKwHOYyZ4Huc0dTgE4SFE2Pe8AjCaqzIyBK5PIq8K0oKVlGgk/gj2
 ynR3vSkQydyWHu9oOtStzMeg
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 18 Apr 2022 00:32:40 -0700
IronPort-SDR: vz3ftqL/y8KyXZsjt8hPJpKl2b3k9BrhbAGVuuHp48P/W3xdU9uCSS+PipQphB/K70rmYo6NmZ
 yiijWxJDlh933QdJMNkl01+P2d8Nhdu/tKTrFvDT7SvY1frP0Crex6nHl+QGh1HYrWt39koFqy
 V/Qk7mintltxSjM33xNeS0KAOoi/Msa4vqiP5DMkX/j1LOd+tZNcmRK8ZVd5Yk9qu6KPTmApCe
 LFGVLOHh3pnYHAd8Tca04CpFFAkFpeycBoQqiZXbg+8vfw452ciwHYXIMnshOZxuu4jVQaQrK9
 Q/o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 18 Apr 2022 01:02:20 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhfY672Vzz1SVp4
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 01:02:18 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id ahAZYPejel9G for <dm-devel@redhat.com>;
 Mon, 18 Apr 2022 01:02:17 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhfY24GYPz1Rvlx;
 Mon, 18 Apr 2022 01:02:14 -0700 (PDT)
Message-ID: <cd77bfd9-e133-1929-2d61-73822ad95366@opensource.wdc.com>
Date: Mon, 18 Apr 2022 17:02:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20220418045314.360785-1-hch@lst.de>
 <20220418045314.360785-10-hch@lst.de>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220418045314.360785-10-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 09/11] nvme: remove a spurious clear of
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 4/18/22 13:53, Christoph Hellwig wrote:
> The nvme driver never sets a discard_alignment, so it also doens't need
> to clear it to zero.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvme/host/core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index b9b0fbde97c80..76a9ccd5d064a 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -1628,7 +1628,6 @@ static void nvme_config_discard(struct gendisk *disk, struct nvme_ns *ns)
>  	BUILD_BUG_ON(PAGE_SIZE / sizeof(struct nvme_dsm_range) <
>  			NVME_DSM_MAX_RANGES);
>  
> -	queue->limits.discard_alignment = 0;
>  	queue->limits.discard_granularity = size;
>  
>  	/* If discard is already enabled, don't reset queue limits */

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

