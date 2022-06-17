Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160F1C43334
	for <dm-devel@archiver.kernel.org>; Fri, 17 Jun 2022 06:56:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-2JABFZEHMhq4XfDOi4D_nQ-1; Fri, 17 Jun 2022 02:56:16 -0400
X-MC-Unique: 2JABFZEHMhq4XfDOi4D_nQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBA4080B70E;
	Fri, 17 Jun 2022 06:56:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BEDA404E4C8;
	Fri, 17 Jun 2022 06:56:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 23C65194705F;
	Fri, 17 Jun 2022 06:56:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E460C194705D
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Jun 2022 06:56:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2780C2810D; Fri, 17 Jun 2022 06:56:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE384C23DBF
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:56:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 965A71C04B44
 for <dm-devel@redhat.com>; Fri, 17 Jun 2022 06:56:12 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-zdL1DKs-PnOdpNUmT8s84A-1; Fri, 17 Jun 2022 02:56:10 -0400
X-MC-Unique: zdL1DKs-PnOdpNUmT8s84A-1
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; d="scan'208";a="208260468"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2022 14:56:08 +0800
IronPort-SDR: 7A4ElWpfinPlabl7e4vA33oIDIcQI+KoT9/1FtWeKa82hh0rnpc/ve7VqXFy8FzG1fInYaPyR3
 tLSLChiMeG9DtLQqsh/X9yEaGXFQ4OgSMrrYe8qW+GIZ6bIPbOC/CIH6djtmmnoxZgnGTMKvQq
 Lz+pRxViIQ4XEHabzLowoSujV1d0DSsj9gMm+5jq0H+rtk/ruLnkRf83BTc1SDPC75urHSDvbR
 1VnIozKvIDv5w63lMRqxjQxiqIbJ9kyGxXJNYcMuPFwKwC5R6Kr56Kvj/fKgZo0afU+zuLOmeM
 +xysji+Hzng8Hpi2Rp3Aj88Y
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 23:14:21 -0700
IronPort-SDR: Ww8t7azHQ2WQe4KWXyYgXEHpcrAcmGIdi+O6TPUpJGEYUhZ+Na29PALVX4gh5Wakoq+0RE5FCU
 vm0LxPImYcGxFCiCiGI2r5KkGrIYZNb9ysyFbJzOKuBUgLuzQT3BKy/GfXqhBkJlAAPP3YHxYS
 U6tRQ/pQugGPFRjjo2wK0W/uu7eK89D6waAe2bU6QhdeVjyHTybWm/V3x6gwTRvigdK/lN6wPN
 zmrpOHX/6wnLkOw2GC6A79WQ8uug4+QXL7C4G7c8u5P92i+MfxaowPpxYafLR+krjP03JV0QAi
 IJM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 16 Jun 2022 23:56:10 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LPVF43rP1z1SVnx
 for <dm-devel@redhat.com>; Thu, 16 Jun 2022 23:56:08 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id dKe8lLStmr9H for <dm-devel@redhat.com>;
 Thu, 16 Jun 2022 23:56:07 -0700 (PDT)
Received: from [10.225.163.84] (unknown [10.225.163.84])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LPVF05H8mz1Rvlc;
 Thu, 16 Jun 2022 23:56:04 -0700 (PDT)
Message-ID: <f4cf6348-dd94-aa82-7519-318248c51151@opensource.wdc.com>
Date: Fri, 17 Jun 2022 15:56:03 +0900
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
 <e0dc08fd-cd00-240d-edc4-5799d51aa5a8@opensource.wdc.com>
 <a945def3-ba5a-7539-e96a-43ade0ae674a@samsung.com>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <a945def3-ba5a-7539-e96a-43ade0ae674a@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
Cc: bvanassche@acm.org, pankydev8@gmail.com, gost.dev@samsung.com,
 jiangbo.365@bytedance.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 jonathan.derrick@linux.dev, Johannes.Thumshirn@wdc.com, dsterba@suse.com,
 jaegeuk@kernel.org
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

On 6/17/22 15:40, Pankaj Raghav wrote:
> On 2022-06-17 08:12, Damien Le Moal wrote:
>>> I think this is a cleaner approach using features flag and io_hints
>>> instead of messing with the revalidate zone function:
>>>
>>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>>> index 135c0cc190fb..c97a71e0473f 100644
>>> --- a/drivers/md/dm-table.c
>>> +++ b/drivers/md/dm-table.c
>>> @@ -1618,6 +1618,9 @@ static int device_not_matches_zone_sectors(struct
>>> dm_target *ti, struct dm_dev *
>>>  	if (!blk_queue_is_zoned(q))
>>>  		return 0;
>>>
>>> +	if(dm_target_supports_emulated_zone_size(ti->type))
>>> +		return 0;
>>> +
>>
>> This should be in validate_hardware_zoned_model(), not here.
>>
> I am not sure about this comment. We need to peek into the individual
> target from the table to check for this feature right?
> 
> if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors,
> &zone_sectors)) {
> 	DMERR("%s: zone sectors is not consistent across all zoned devices",
>         dm_device_name(table->md));
> 	return -EINVAL;
> 	}
> 
> So we call this function device_not_matches_zone_sectors() from
> validate_hardware_zoned_model() for each target and we let the validate
> succeed even if the target's zone size is different from the underlying
> device zone size if this feature flag is set. Let me know if I am
> missing something and how this can be moved to
> validate_hardware_zoned_model().

Your change does not match the function name
device_not_matches_zone_sectors(), at all. So I think this is wrong.

The fact is that zone support in DM has been built under the following
assumptions:
1) A zoned device can be used to create a *zoned* target (e.g. dm-linear,
dm-flakey, dm-crypt). For this case, the target *must* use the same zone
size as the underlying devices and all devices used for the target must
have the same zone size.
2) A zoned device can be used to create a *regular* device target (e.g.
dm-zoned). All zoned devices used for the target must have the same zone size.

This new target driver completely breaks (1) and does not fit with (2). I
suspect this is why you are seeing problems with dm_revalidate_zones() as
that one uses the underlying device instead of the target report zones.

Based on this analysis, validate_hardware_zoned_model() definitely needs
to be changed. But device_not_matches_zone_sectors() is to check the
assumptions (1) and (2) so changing it for your new case is wrong in my
opinion. You need another set of assumptions (3) (define that well please)
and modify validate_hardware_zoned_model() so that the defined constraints
are checked. Using a target flag to indicate the type of zoned target is
fine by me.

-- 
Damien Le Moal
Western Digital Research

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

