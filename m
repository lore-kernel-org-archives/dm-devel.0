Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5D6C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 06:12:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-TleZBqz3OuW1xsOghTaB-A-1; Fri, 17 Jun 2022 02:12:17 -0400
X-MC-Unique: TleZBqz3OuW1xsOghTaB-A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9C4E3C0218E;
	Fri, 17 Jun 2022 06:12:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C1C2492C3B;
	Fri, 17 Jun 2022 06:12:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4716E194705F;
	Fri, 17 Jun 2022 06:12:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A542194705D
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 06:12:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 25C52415F5E; Fri, 17 Jun 2022 06:12:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 217DC40334D
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:12:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2258C101A56C
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:12:13 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-tdAg773COA2GPXX8UsZC0A-1; Fri, 17 Jun 2022 02:12:09 -0400
X-MC-Unique: tdAg773COA2GPXX8UsZC0A-1
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; d="scan'208";a="208257768"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2022 14:12:08 +0800
IronPort-SDR: 3hGkzVE9emUBOE5yxRZ2s9BTdgmE7w6nJPEDGEaPjKNdbFvFy/VhMxqway6r6GNoP8eczfF+Fo
 paG7/VgKhUfW73qZ/jXkjE60hJauUtjQe5PCNKJB4JoPpIzpPVQOHeXf1tdd4qG8BJ3wcn7mhh
 Ol0LGHC4an2v0YRs4aCoYFVA49Xccf8mK6lTYtPwPC60cu2u5oxRxmOz7HHROEt9CgzbXipl2F
 wcCszPB27yQvGf6pWm6mmYuSZ0Bb++f+g//xQd7LIhsj5zd67HTrqD9B5hAoMNlZn+kZ01U+uR
 v661ZoCBzckCzNkZRqODbj80
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 22:34:43 -0700
IronPort-SDR: 6KkASpfUulXmmuhXCWzWJ8SwtoIwCK1JiEx8EkLXlOSM0BB3V/yTZnv5kLuXZnVCawGd2zHZ4c
 I5hx0ftvXmpca7O+ZosCbUJds4WCPyfBjkB42iCGnRZVGdQM2ms0AnfIkoQX4a4H/K1SpIZP3o
 PWSsDNgH1bi42E9yWSg9QTHDtndi8EwNXCesZAqUITcNeOdBNJUj7uaeMb71+R5vgeliVQnWAo
 oUl/d+KVkHHqBIB7q+OxOTk5hjeOEr0EUKjFMuWQ09IjuB2kNZ8HMY+XhIsVcWaDiiUuA7VtFe
 Dxo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 23:12:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LPTGH6576z1SVp6
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:12:07 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id Krp5Q4BIXGnV for <dm-devel@redhat.com>;
 Thu, 16 Jun 2022 23:12:05 -0700 (PDT)
Received: from [10.225.163.84] (unknown [10.225.163.84])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LPTGB6TbPz1Rvlc;
 Thu, 16 Jun 2022 23:12:02 -0700 (PDT)
Message-ID: <e0dc08fd-cd00-240d-edc4-5799d51aa5a8@opensource.wdc.com>
Date: Fri, 17 Jun 2022 15:12:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
To: Pankaj Raghav <p.raghav@samsung.com>, hch@lst.de, snitzer@redhat.com,
 axboe@kernel.dk
References: <20220615101920.329421-1-p.raghav@samsung.com>
 <CGME20220615102011eucas1p220368db4a186181b1927dea50a79e5d4@eucas1p2.samsung.com>
 <20220615101920.329421-14-p.raghav@samsung.com>
 <63b0cfb6-eb24-f058-e502-2637039c5a98@opensource.wdc.com>
 <0b819562-8b16-37b6-9220-28bf1960bccb@samsung.com>
 <0c4f30f2-c206-0201-31e3-fbb9edbdf666@opensource.wdc.com>
 <4746a000-2220-211e-1bd6-79c15c18a85c@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <4746a000-2220-211e-1bd6-79c15c18a85c@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/17/22 14:45, Pankaj Raghav wrote:
> On 2022-06-17 01:49, Damien Le Moal wrote:
>>>> Why do you need to change dm_set_zones_restrictions() at all ?
>>>>
>>> When the device mapper is created, the q->limits gets inherited from the
>>> underlying device. The chunk sectors of the target and the device will
>>> be the same but we want the chunk sector of the target to be different
>>> (rounded to po2) compared to the underlying device's chunk sector. This
>>> needs to be done only for the dm-po2z target and not for other targets
>>> that uses npo2 zoned devices (like dm-linear). So to perform this
>>> operation in a target independent way in dm-zone.c, I chose to always
>>> revalidate npo2 zoned device and update the chunk sector and nr_zones in
>>> dm_zone_revalidate_cb based on the zone information from the target.
>>> This allows to set the limits correctly for dm-po2z target.
>>
>> But DM revalidate will be called for the target AFTER it is setup (after
>> its gendisk is added). So how can DM revalidate see the incorrect zone
>> size ? If that is the case, then the target constructor is broken or
>> missing something. DM revalidate zone is generic and only allocates the
>> zone bitmaps for the target device. There should be not need at all to
>> touch that function.
>>
> I think this is a cleaner approach using features flag and io_hints
> instead of messing with the revalidate zone function:
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 135c0cc190fb..c97a71e0473f 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1618,6 +1618,9 @@ static int device_not_matches_zone_sectors(struct
> dm_target *ti, struct dm_dev *
>  	if (!blk_queue_is_zoned(q))
>  		return 0;
> 
> +	if(dm_target_supports_emulated_zone_size(ti->type))
> +		return 0;
> +

This should be in validate_hardware_zoned_model(), not here.

>  	return blk_queue_zone_sectors(q) != *zone_sectors;
>  }
> 
> diff --git a/drivers/md/dm-zoned-npo2-target.c
> b/drivers/md/dm-zoned-npo2-target.c
> index dad135964e09..b203be808f09 100644
> --- a/drivers/md/dm-zoned-npo2-target.c
> +++ b/drivers/md/dm-zoned-npo2-target.c
> @@ -187,6 +187,12 @@ static int dmz_npo2_end_io(struct dm_target *ti,
> struct bio *bio,
>  	return DM_ENDIO_DONE;
>  }
> 
> +static void dmz_npo2_io_hints(struct dm_target *ti, struct queue_limits
> *limits)
> +{
> +	struct dmz_npo2_target *dmh = ti->private;
> +	limits->chunk_sectors = dmh->zsze_po2;
> +}
> +
>  static int dmz_npo2_map(struct dm_target *ti, struct bio *bio)
>  {
>  	struct dmz_npo2_target *dmh = ti->private;
> @@ -233,12 +239,13 @@ static int dmz_npo2_iterate_devices(struct
> dm_target *ti,
>  static struct target_type dmz_npo2_target = {
>  	.name = "zoned-npo2",
>  	.version = { 1, 0, 0 },
> -	.features = DM_TARGET_ZONED_HM,
> +	.features = DM_TARGET_ZONED_HM | DM_TARGET_EMULATED_ZONE_SIZE,
>  	.map = dmz_npo2_map,
>  	.end_io = dmz_npo2_end_io,
>  	.report_zones = dmz_npo2_report_zones,
>  	.iterate_devices = dmz_npo2_iterate_devices,
>  	.module = THIS_MODULE,
> +	.io_hints = dmz_npo2_io_hints,
>  	.ctr = dmz_npo2_ctr,
>  };
> 
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index c2a3758c4aaa..9f3a4d98a22a 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -283,6 +283,15 @@ struct target_type {
>  #define dm_target_supports_mixed_zoned_model(type) (false)
>  #endif
> 
> +#ifdef CONFIG_BLK_DEV_ZONED
> +#define DM_TARGET_EMULATED_ZONE_SIZE	0x00000400

Make it general: DM_TARGET_EMULATED_ZONES

> +#define dm_target_supports_emulated_zone_size(type) \
> +	((type)->features & DM_TARGET_EMULATED_ZONE_SIZE)
> +#else
> +#define DM_TARGET_EMULATED_ZONE_SIZE	0x00000000
> +#define dm_target_supports_emulated_zone_size(type) (false)
> +#endif
> +
>  struct dm_target {
>  	struct dm_table *table;
>  	struct target_type *type;
> 


-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

