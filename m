Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55898C433EF
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 07:34:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149--wL1HlD5OimFtEKTF3XjAg-1; Mon, 02 May 2022 03:34:33 -0400
X-MC-Unique: -wL1HlD5OimFtEKTF3XjAg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A709383219B;
	Mon,  2 May 2022 07:34:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0073F403D163;
	Mon,  2 May 2022 07:34:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A92D31947069;
	Mon,  2 May 2022 07:34:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D532B194704B
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Apr 2022 17:30:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C3165414A7EB; Fri, 29 Apr 2022 17:30:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BDBBE414A7EA
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 17:30:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F6FD2811826
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 17:30:11 +0000 (UTC)
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-ttJzpy24OFegaEhDyyCCeA-1; Fri, 29 Apr 2022 13:30:09 -0400
X-MC-Unique: ttJzpy24OFegaEhDyyCCeA-1
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
 by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id
 20220429173009usoutp015d3c871c6f8424aa3134d0e6d1a90bb4~qbjobwlQB2866728667usoutp01O;
 Fri, 29 Apr 2022 17:30:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com
 20220429173009usoutp015d3c871c6f8424aa3134d0e6d1a90bb4~qbjobwlQB2866728667usoutp01O
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
 [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220429173009uscas1p2bf30fcd81fced72f645adfac58e2a265~qbjoQPaI62475724757uscas1p23;
 Fri, 29 Apr 2022 17:30:09 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
 ussmges2new.samsung.com (USCPEMTA) with SMTP id 21.C1.09642.0A02C626; Fri,
 29 Apr 2022 13:30:08 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
 [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220429173008uscas1p1cde218cbcd1e37d4069cf9db33f82fbf~qbjnusC8M0356103561uscas1p1I;
 Fri, 29 Apr 2022 17:30:08 +0000 (GMT)
X-AuditID: cbfec36f-bfdff700000025aa-73-626c20a0d0f0
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
 ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 29.F1.09702.0A02C626; Fri,
 29 Apr 2022 13:30:08 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
 SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.2375.7; Fri, 29 Apr 2022 10:30:07 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
 SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.007; Fri,
 29 Apr 2022 10:30:07 -0700
From: Adam Manzanares <a.manzanares@samsung.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Thread-Topic: [PATCH 13/16] null_blk: allow non power of 2 zoned devices
Thread-Index: AQHYWlBN4zB7Wf7sW0aEyMwWol2CyK0HnkAA
Date: Fri, 29 Apr 2022 17:30:07 +0000
Message-ID: <20220429173006.GD174938@bgt-140510-bm01>
In-Reply-To: <20220427160255.300418-14-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTVxzHPffe3l46gdvOwJlsPghbCkwERHfMFIgz46pZ5hI1vqKr4/LY
 Sktai4OxiDBxMKWlG1PK29mO1wYUHUiBuYqCMGTjUVzDIwwwYSDgCnPiqKNcTPrf5/x+39/5
 fXJyKFzUTK6lYmWnWYVMIvUmBcRPd+fvbyreID0VeO1RMKpqv4ujikE1ib6dfYqjjpxODGnV
 V/joWWcXjpqm83jot3/PYais4g6Gxqp0OLp4a5ZAi5lDS7UvRnD030gQ0potAI336TDUZPVH
 3aOlfNR9NQI1Nt0jUE9DPomKDON8pEmfx9EDzThA2a21PPTj5AyB2qxe4V5MT+8+xt5WSTLZ
 adN8pmuohmB6OlWMsTyDZEpScnCm9tpZxlRswxjTHykkcyltmmRunh/mMTPNfSRTdb2PYDS1
 NTzGZly3X3hUsCOSlcYmsIrNoR8KYqYsZiI+P+jTUts5fgqofiMTuFCQDoE17TbgYBFdBmBZ
 XngmECzxeQwuZNXzX4QGU9NIrvEDgPcHFnBu4jGAXw77cg0DgDftU5ijQdKB8FlrzXJoDS2G
 D3trl+s4nfkSHMwJcfDLdAS8XbqwVKeWMgxse36Yw2B4ueeAI0HQr8MB29ekg13prXCy/wrP
 wS70DmipGlh2A7QHfNJeuXK7J7SOFWGcsxBezWvEOfaA9oYRkuONcPjJBJ/LvwmLTX+THIfC
 DmMFzrE/NJRM4txeIbyXO0Zws6/AX0ofrPANAexddON4N+zTm1d2ecG+/hzc8SSQvgDgrKaZ
 xx00AA48erpi8Ta0Z1j4GuCjcxLXOUnpnKR0TlI6J6liwCsHniqlMi6aVQbL2DMBSkmcUiWL
 DvhIHmcES1+8w35bXg/6rY8DzACjgBlACvde4zpnijklco2UJCaxCvlJhUrKKs3AiyK8PV0N
 sdUSER0tOc1+wrLxrOJFF6Nc1qZg7iyoGUz/Z2KgR7trMfDVM9XfFRaKk+Z6y96JSOkXrPIO
 9RPbdm9vPAA2t2pS7dmqeP2WFt2JW1T0w9+Nicc2hW/3Pxml37O1YXLIs7H7M3Vl7tmLJ9aX
 vE+ltsxNJhd1joaFMH89nzmU/I1vbqT1uIc0Pc/yc4cpsK4uebRjShz0rqxgw1uJ2nkGX63O
 rS84Fmr21b8m2uaTtTHssnaLzL5tKiEqy90tdvaDz4vELV/FT5XvdZdHCQvfW60X/7rzgtpw
 MPTQnwF762hl+Pf5ipCS68Iu/Ph+QrTKGn1nV4GpKF83HLa+fsLfbSzp46qjGY1+lgSjnDxy
 MH5uHf+Gz+EjO70JZYwkyA9XKCX/AwoKenNRBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTZxjG951zenro7Hbo1H6TZJslYwqO22D5zJgxu+hJdMDiZsREocoR
 OkshPXTCsmxVmCK62ULZsCOhLA0rFK1csiAFgmXcbLAqhUHDRQeYsE7AdYyLs47ubEn/+73v
 87zP+33JS+GSScEWSqHKZ9UquVJGigiFFtO/bnpFeSy2cngTst3sxZF14hKJvl1cxZGzYhBD
 ZZcqhejxoAtHHfPfC9DtldMYqrP2YGjGZsTRxa5FAj0pnVzvFd/H0d/341CZYwSg2WEjhjo8
 UejutEWI7v6wF7V3DBBoqK2KRNW1s0KkO7uEo1HdLED6vmYBuupdIFC/J2x3GDPk3sf4+xtI
 Rl80L2Rck40EMzSoYZrqz5NMjbYCZ5rNXzJ2kw9j7GNakvm6aJ5krn81JWAWOodJxtYyTDC6
 5kYB42t6KTX0sCgpk1UqPmXVMbsyRNm/jziIvKq4AovvtFALrkWUghAK0glw4kwRWQpElIS2
 Aui3WQi+eARgm/OygC9qAZxo1RGBEZKOhY/7GvEAb6S3wQfuZixgwumSZ+HSqhkEhBfovbDb
 srYuUOsmBvY/PcRjPPxu6KOAg6BfheO+cjLAYjoRen+p/G9XF4CdXbp/hRA6CY7YxoUBBvRm
 uHyzAQswTkuhZ6Ya479AQ3O7C+d5E5yb9gt43gqnlueEvH8HNNn/IHneBZ1NVpznKFhb48X5
 R4TCgcszBD/7IrxhGSV0ABqD1hmDooxBUcagKGNQlAkI6oFUw3E5WQVcnIo9Fc3JcziNKiv6
 eG5OE1g/Qae/O60V9HgeRTsARgEHgBQu2yj+0559TCLOlBd+xqpz09UaJcs5QBhFyKRiyfv6
 dAmdJc9nT7JsHqv+X8WokC1arCax/ojXTN0+H31FVFazZwe1sp1Qi2QPe35MRYkPimydMbeS
 u9sORqXYP9xwVKTv112cm9izcj3ljj/h1gqMdHe6R/dhXsmq8Z3yzRnVJ/uOHk6PuRBlvPaM
 2/CaqcSjGZsTd6gGpcXFFblrackHbyyWRLwRry1wnpk/Llj4pD0zUkzvfnNM4d7vipAuPZ88
 HrPhp61EleasobUwb5xLNRvCz4VTum8+PvDkDvHrgZfVSbY+j7L63hdYeJ7i88WcI6c+SIg9
 sXOgt+GvE/F1FVpZhqU+v8WQcq9l2tDb0/pu6HNpieVXGN/TC2+Vp005zr3d6wotrNr/2887
 15br3A/fs8oILlseF4mrOfk/Z5cgv/EDAAA=
X-CMS-MailID: 20220429173008uscas1p1cde218cbcd1e37d4069cf9db33f82fbf
CMS-TYPE: 301P
X-CMS-RootMailID: 20220427160310eucas1p28cd3c5ff4fb7a04bc77c4c0b9d96bb74
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160310eucas1p28cd3c5ff4fb7a04bc77c4c0b9d96bb74@eucas1p2.samsung.com>
 <20220427160255.300418-14-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 02 May 2022 07:34:27 +0000
Subject: Re: [dm-devel] [PATCH 13/16] null_blk: allow non power of 2 zoned
 devices
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
Cc: "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
 "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,
 "sagi@grimberg.me" <sagi@grimberg.me>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "jonathan.derrick@linux.dev" <jonathan.derrick@linux.dev>,
 "kch@nvidia.com" <kch@nvidia.com>, "chao@kernel.org" <chao@kernel.org>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>, "kbusch@kernel.org" <kbusch@kernel.org>,
 "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
 "matias.bjorling@wdc.com" <matias.bjorling@wdc.com>,
 "bvanassche@acm.org" <bvanassche@acm.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <B4D2F0A8C589E242945A08E1571AAD23@ssi.samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 27, 2022 at 06:02:52PM +0200, Pankaj Raghav wrote:
> Convert the power of 2 based calculation with zone size to be generic in
> null_zone_no with optimization for power of 2 based zone sizes.
> 
> The nr_zones calculation in null_init_zoned_dev has been replaced with a
> division without special handling for power of 2 based zone sizes as
> this function is called only during the initialization and will not
> invoked in the hot path.
> 
> Performance Measurement:
> 
> Device:
> zone size = 128M, blocksize=4k
> 
> FIO cmd:
> 
> fio --name=zbc --filename=/dev/nullb0 --direct=1 --zonemode=zbd  --size=23G
> --io_size=<iosize> --ioengine=io_uring --iodepth=<iod> --rw=<mode> --bs=4k
> --loops=4
> 
> The following results are an average of 4 runs on AMD Ryzen 5 5600X with
> 32GB of RAM:
> 
> Sequential Write:
> 
> x-----------------x---------------------------------x---------------------------------x
> |     IOdepth     |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  578     |  2257    |   12.80   |  576     |  2248    |   25.78   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  581     |  2268    |   12.74   |  576     |  2248    |   25.85   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Sequential read:
> 
> x-----------------x---------------------------------x---------------------------------x
> | IOdepth         |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  667     |  2605    |   11.79   |  675     |  2637    |   23.49   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  667     |  2605    |   11.79   |  675     |  2638    |   23.48   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Random read:
> 
> x-----------------x---------------------------------x---------------------------------x
> | IOdepth         |            8                    |            16                   |
> x-----------------x---------------------------------x---------------------------------x
> |                 |  KIOPS   |BW(MiB/s) | Lat(usec) |  KIOPS   |BW(MiB/s) | Lat(usec) |
> x-----------------x---------------------------------x---------------------------------x
> | Without patch   |  522     |  2038    |   15.05   |  514     |  2006    |   30.87   |
> x-----------------x---------------------------------x---------------------------------x
> |  With patch     |  522     |  2039    |   15.04   |  523     |  2042    |   30.33   |
> x-----------------x---------------------------------x---------------------------------x
> 
> Minor variations are noticed in Sequential write with io depth 8 and
> in random read with io depth 16. But overall no noticeable differences
> were noticed
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/block/null_blk/main.c  |  4 ++--
>  drivers/block/null_blk/zoned.c | 14 +++++++-------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
> index c441a4972064..82a62b543782 100644
> --- a/drivers/block/null_blk/main.c
> +++ b/drivers/block/null_blk/main.c
> @@ -1931,8 +1931,8 @@ static int null_validate_conf(struct nullb_device *dev)
>  		dev->mbps = 0;
>  
>  	if (dev->zoned &&
> -	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
> -		pr_err("zone_size must be power-of-two\n");
> +	    (!dev->zone_size)) {
> +		pr_err("zone_size must not be zero\n");
>  		return -EINVAL;
>  	}
>  
> diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
> index dae54dd1aeac..00c34e65ef0a 100644
> --- a/drivers/block/null_blk/zoned.c
> +++ b/drivers/block/null_blk/zoned.c
> @@ -13,7 +13,10 @@ static inline sector_t mb_to_sects(unsigned long mb)
>  
>  static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
>  {
> -	return sect >> ilog2(dev->zone_size_sects);
> +	if (is_power_of_2(dev->zone_size_sects))
> +		return sect >> ilog2(dev->zone_size_sects);
> +
> +	return div64_u64(sect, dev->zone_size_sects);
>  }
>  
>  static inline void null_lock_zone_res(struct nullb_device *dev)
> @@ -62,10 +65,6 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
>  	sector_t sector = 0;
>  	unsigned int i;
>  
> -	if (!is_power_of_2(dev->zone_size)) {
> -		pr_err("zone_size must be power-of-two\n");
> -		return -EINVAL;
> -	}
>  	if (dev->zone_size > dev->size) {
>  		pr_err("Zone size larger than device capacity\n");
>  		return -EINVAL;
> @@ -83,8 +82,9 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
>  	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
>  	dev_capacity_sects = mb_to_sects(dev->size);
>  	dev->zone_size_sects = mb_to_sects(dev->zone_size);
> -	dev->nr_zones = round_up(dev_capacity_sects, dev->zone_size_sects)
> -		>> ilog2(dev->zone_size_sects);
> +	dev->nr_zones =
> +		div64_u64(roundup(dev_capacity_sects, dev->zone_size_sects),
> +			  dev->zone_size_sects);
>  
>  	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct nullb_zone),
>  				    GFP_KERNEL | __GFP_ZERO);
> -- 
> 2.25.1
>


Looks good.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

