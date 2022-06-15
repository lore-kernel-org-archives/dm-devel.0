Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08040C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 15 Jun 2022 20:40:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-2LyleuqgNcqykg0xHdL3NA-1; Wed, 15 Jun 2022 16:40:40 -0400
X-MC-Unique: 2LyleuqgNcqykg0xHdL3NA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4C10800971;
	Wed, 15 Jun 2022 20:40:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7A53C4011A3E;
	Wed, 15 Jun 2022 20:40:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B4611947040;
	Wed, 15 Jun 2022 20:40:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7ED911947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Jun 2022 20:40:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5D6092166B29; Wed, 15 Jun 2022 20:40:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 595772166B26
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 20:40:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E825800971
 for <dm-devel@redhat.com>; Wed, 15 Jun 2022 20:40:36 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-1C_BdkjDMbKytIwVMhBegQ-1; Wed, 15 Jun 2022 16:40:34 -0400
X-MC-Unique: 1C_BdkjDMbKytIwVMhBegQ-1
Received: from [2601:1c0:6280:3f0::aa0b]
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o1Z6S-008D8F-P3; Wed, 15 Jun 2022 19:55:03 +0000
Message-ID: <0480d917-94e5-20ab-514c-bb1374a8d9c4@infradead.org>
Date: Wed, 15 Jun 2022 12:54:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 damien.lemoal@opensource.wdc.com, axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102011eucas1p220368db4a186181b1927dea50a79e5d4@eucas1p2.samsung.com>
 <20220615101920.329421-14-p.raghav@samsung.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220615101920.329421-14-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v7 13/13] dm: add non power of 2 zoned target
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
Cc: Damien Le Moal <damien.lemoal@wdc.com>, bvanassche@acm.org,
 pankydev8@gmail.com, gost.dev@samsung.com, jiangbo.365@bytedance.com,
 linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com, jonathan.derrick@linux.dev,
 Johannes.Thumshirn@wdc.com, dsterba@suse.com, jaegeuk@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi--

On 6/15/22 03:19, Pankaj Raghav wrote:

> ---
>  drivers/md/Kconfig                |   9 +
>  drivers/md/Makefile               |   2 +
>  drivers/md/dm-zone.c              |   9 +
>  drivers/md/dm-zoned-npo2-target.c | 268 ++++++++++++++++++++++++++++++
>  4 files changed, 288 insertions(+)
>  create mode 100644 drivers/md/dm-zoned-npo2-target.c
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 998a5cfdb..773314536 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -518,6 +518,15 @@ config DM_FLAKEY
>  	help
>  	 A target that intermittently fails I/O for debugging purposes.
>  
> +config DM_ZONED_NPO2
> +	tristate "Zoned non power of 2 target"

	         "Zoned non-power-of-2 target"

> +	depends on BLK_DEV_DM
> +	depends on BLK_DEV_ZONED
> +	help
> +	A target that converts a zoned device with non power of 2 zone size to

	                                           non-power-of-2 zone size to

> +	be power of 2. This is done by introducing gaps in between the zone
> +	capacity and the power of 2 zone size.

All help text should be indented with one tab and 2 spaces
according to Documentation/process/coding-style.rst.

> +
>  config DM_VERITY
>  	tristate "Verity target support"
>  	depends on BLK_DEV_DM

[snip]

> +
> +MODULE_DESCRIPTION(DM_NAME " non power 2 zoned target");

                                non-power-of-2

> +MODULE_AUTHOR("Pankaj Raghav <p.raghav@samsung.com>");
> +MODULE_LICENSE("GPL");
> +

-- 
~Randy

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

