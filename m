Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7FDEC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 07:34:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-AxRdFwgOMaiJNII7EpsklQ-1; Mon, 02 May 2022 03:34:33 -0400
X-MC-Unique: AxRdFwgOMaiJNII7EpsklQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AEA828015BA;
	Mon,  2 May 2022 07:34:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 992B47ADB;
	Mon,  2 May 2022 07:34:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 71807194705F;
	Mon,  2 May 2022 07:34:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C37F1194704B
 for <dm-devel@listman.corp.redhat.com>; Fri, 29 Apr 2022 17:23:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9EEF7415F50; Fri, 29 Apr 2022 17:23:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 99F0E415F2E
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 17:23:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CEB2811E80
 for <dm-devel@redhat.com>; Fri, 29 Apr 2022 17:23:59 +0000 (UTC)
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-1HiGFEciPgSVOgVbRqyXqA-1; Fri, 29 Apr 2022 13:23:57 -0400
X-MC-Unique: 1HiGFEciPgSVOgVbRqyXqA-1
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
 by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id
 20220429172356usoutp0242676b86c3c639e383c7b829b91b1a80~qbeNobwUC3254732547usoutp02I;
 Fri, 29 Apr 2022 17:23:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com
 20220429172356usoutp0242676b86c3c639e383c7b829b91b1a80~qbeNobwUC3254732547usoutp02I
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
 [203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220429172356uscas1p1802f8556352f80b43292a97d1692d426~qbeNXtUlU0334603346uscas1p1d;
 Fri, 29 Apr 2022 17:23:56 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
 ussmges2new.samsung.com (USCPEMTA) with SMTP id 32.01.09642.C2F1C626; Fri,
 29 Apr 2022 13:23:56 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
 [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220429172356uscas1p240abbeaccf4d0771ef01c5ada56a19e3~qbeM3iOF-0529505295uscas1p2J;
 Fri, 29 Apr 2022 17:23:56 +0000 (GMT)
X-AuditID: cbfec36f-c15ff700000025aa-51-626c1f2c1d50
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
 ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 27.63.09672.B2F1C626; Fri,
 29 Apr 2022 13:23:55 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
 SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.2375.7; Fri, 29 Apr 2022 10:23:54 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
 SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.007; Fri,
 29 Apr 2022 10:23:54 -0700
From: Adam Manzanares <a.manzanares@samsung.com>
To: Pankaj Raghav <p.raghav@samsung.com>
Thread-Topic: [PATCH 05/16] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
Thread-Index: AQHYWlBIk1palC1aiUOJGb6L5A1HwK0HnIUA
Date: Fri, 29 Apr 2022 17:23:54 +0000
Message-ID: <20220429172354.GB174938@bgt-140510-bm01>
In-Reply-To: <20220427160255.300418-6-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTZxTGfe+9vS2V4qWivILZYiPGDIeAEN9MZYYZdydZZtTFOWewzisQ
 vlxLlZFtwpQJFaVlIlpIgMqKIIzRGsYoX3ZRPhS7Wb7sKKwBtmlni3RMAamjvV3Cf7/znOc9
 5znJy8OFHWQQLyktg5GkiVNEJJ9oujtjfHPT6ynHwqub16KG3rs4umkpJNGVqVkc3Svuw1BR
 4VUumu8z4qjNXspBv7zIwVDNzTsYmmhQ4aigc4pAC/LRRe2cFUcvrRGoyDAI0OSACkNt5lD0
 cPwGFz1Uv4ta23oIZGopI1G5ZpKLFN/M4GhYMQmQskvHQd/bHATqNgfvDKZN/XG0q7uOpJVn
 7VzaONpI0KY+Ga2tzSfpyuxinNZVnaH1FU6M1j/KJumLZ+0k/VPuGId2tA+QdMOtAYJW6Bo5
 tFP72l7/j/nbjzMpSacYyeaYo/xEZ0cHeTJPmGn86xWWDRx+cuDDg1QULD+n5bhZSNUA2Fwf
 wXIuBkdf+MoBz+MZN8aycj2ATdUfygF/kZ8B+HLcQrCFBsCFHAfmdpFUOJzvasTdHEBthH/0
 6zw6TsmXQ0txlJtXUodhi7mHYD2fwDxjDpflSKh8YPcwQYXAttL7wM0CKhr+quvy6D7UNtjZ
 0+mZD6jV8HlvnXd+IDRPlGPsYf5QXdqKs7waulqsJMvr4Njzx1zWvwlW6KdJlmNgtfI375xQ
 qKm04exef9hzbYJg366Bt28Mew6GVCMf2ooM3sYuOPvdde+CYLhg0WCs6TyAU4p2DlsoABx5
 Out1bYOu/EGuAqxXLUmuWpJKtSSVakkq1ZJUFYBTCwJlUmlqAiONTGNOh0nFqVJZWkLYp+mp
 WrD4x++5fk5vBkPmZ2EGgPGAAUAeLgoQ/KNPPCYUHBd/nsVI0uMlshRGagDBPEIUKNAk/SAW
 UgniDCaZYU4ykv+7GM8nKBs7ku9fZ1hzpLL/In6BGJsUhx9cue9P9aPpkbnLm8Xvnfki85Lz
 zq5Dxq1rL+deubBqbzcMWRYz6LexfcQS/FXXzgb74+ZXJfv/7YrmqvNqtzTFzvU6f5+PW1FQ
 tX7+x/iS3lVYxvXobzWz04R1676ZHXtuJw9de7p96LDfnrxiq2C5LC5EWVQY8/bX8qNz99dZ
 dyyz5p7wDfItjyJLbOonOZlRfwuSw+yuA6ovq/TDNuKj/fHqwfoC26kM4XnqtCUyQKwNkF16
 cvAtOis20/SB6sFQbE2yZMv7xhPvrBB260yjCVeVDsvuuVtlWbk9fQma3Z9VNJiJ1mF+pCjU
 0XRoQ5lJNC4ipIniiDdwiVT8H0iZu1FSBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxjGd+69vb10Q6+1yBmYmTVpJDIYdjpOnLrG/bGbzMV9GON0hlW5
 ATIo2FrEuWwFBkHU0HaDaWVSEUsVsNK6OGwZteKgfFg+DWszGOPDARlQ0LmmiqPcLel/v+d9
 n/d5zh+HwoUjvBgqQ3GMVSrkmWJSQGRoMF1C/IbMw0nf9iQjS8cvOKr7rYxEFfMBHHWWd2NI
 X3aOj4LdHhw1z17goZ5/8jF0te4ehsYtBhydcc4T6Fnp8PLsm1EcPR3djPSuBwBNDBow1OyN
 R31jZj7qq34XOZrdBOq/XUmiKtMEH2mLH+NoSDsBkK7NxkPXZ+YI1O6NlcUy/QPvMUvt9SSj
 K5zlM57hRoLp71Yz1munSOaSphxnbDVfM3bjIsbYf9WQzNnCWZJpKhrhMXM/D5KM5eYgwWht
 jTxm0frKB2sOCLanspkZuazy9Z2fCdIXW1rInBJhnufP55gGzK0qBRQF6S1wzLOrFAgoIV0H
 oL7HQnLCvyymz/E4YQLQXF1ClIIIiqSTYLCtEQ+xiI6DkwM2LGTC6ZIX4eNADQgt1tIH4W2v
 m+BMn8Ibnoc8jqVQd3+WH2KClsDmC10r/kh6K+y1tfG5tpbl6uLnKw0R9FvQ6XauMKDXwScd
 9ViIcToaeserVhjSNKxxeHCOo+DU2BKP41fhyJMpPud/DRrtCyTHO2GtzvdfTjw0XZrBuUes
 ge7z4wR3+zK8Yx4itAAawuoMYVGGsChDWJQhLMoIeNdAtFqlykrLU0kV7PFElTxLpVakJR7J
 zrKC5T/YuXT34E/A5/UnugBGAReAFC4WRT6ypx8WRqbKT3zBKrNTlOpMVuUCsRQhjo6cOqBL
 EdJp8mPs5yybwyr/32JURIwG++SdbQ5qj3Ra/3G0uz4orZc5G4qijM/evjJwZc9RUtKVtdGY
 m2D66HhS9WiRSJLyZfDDk/slrdP915Mkf63vncw48sJWWtflo/7Ye2v13kczvt3Br6R5zD7g
 x8t/7zuvu7ixcr521TDG+MH3MaJJscKtudje2posAumOs7IbTZd9MvOmHdr3tQHBfV+cMqH7
 9Bm8trDgRKAkkP/U70yNKhPGqX+syH3z711rC6iF9SmHGnaYUzsocb7jbq3kh3UmfqDC+PCy
 +w19J7oH8dhTM7Imi73SYJVu0C4Ub7GuLtjGPkgbasP2C9tv9R6dCLqYqu2OnOzkk6e/M042
 vHRHTKjS5Zs34UqV/F9M6jft8gMAAA==
X-CMS-MailID: 20220429172356uscas1p240abbeaccf4d0771ef01c5ada56a19e3
CMS-TYPE: 301P
X-CMS-RootMailID: 20220427160301eucas1p147d0dced70946e20dd2dd046b94b8224
References: <20220427160255.300418-1-p.raghav@samsung.com>
 <CGME20220427160301eucas1p147d0dced70946e20dd2dd046b94b8224@eucas1p1.samsung.com>
 <20220427160255.300418-6-p.raghav@samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Mon, 02 May 2022 07:34:27 +0000
Subject: Re: [dm-devel] [PATCH 05/16] nvme: zns: Allow ZNS drives that have
 non-power_of_2 zone size
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <0AED4CE52B42814A9FAE9FC027D992A6@ssi.samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 27, 2022 at 06:02:44PM +0200, Pankaj Raghav wrote:
> Remove the condition which disallows non-power_of_2 zone size ZNS drive
> to be updated and use generic method to calculate number of zones
> instead of relying on log and shift based calculation on zone size.
> 
> The power_of_2 calculation has been replaced directly with generic
> calculation without special handling. Both modified functions are not
> used in hot paths, they are only used during initialization &
> revalidation of the ZNS device.
> 
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  drivers/nvme/host/zns.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
> index 9f81beb4df4e..2087de0768ee 100644
> --- a/drivers/nvme/host/zns.c
> +++ b/drivers/nvme/host/zns.c
> @@ -101,13 +101,6 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
>  	}
>  
>  	ns->zsze = nvme_lba_to_sect(ns, le64_to_cpu(id->lbafe[lbaf].zsze));
> -	if (!is_power_of_2(ns->zsze)) {
> -		dev_warn(ns->ctrl->device,
> -			"invalid zone size:%llu for namespace:%u\n",
> -			ns->zsze, ns->head->ns_id);
> -		status = -ENODEV;
> -		goto free_data;
> -	}
>  
>  	blk_queue_set_zoned(ns->disk, BLK_ZONED_HM);
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
> @@ -129,7 +122,7 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
>  				   sizeof(struct nvme_zone_descriptor);
>  
>  	nr_zones = min_t(unsigned int, nr_zones,
> -			 get_capacity(ns->disk) >> ilog2(ns->zsze));
> +			 div64_u64(get_capacity(ns->disk), ns->zsze));
>  
>  	bufsize = sizeof(struct nvme_zone_report) +
>  		nr_zones * sizeof(struct nvme_zone_descriptor);
> @@ -197,7 +190,7 @@ int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
>  	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
>  	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
>  
> -	sector &= ~(ns->zsze - 1);
> +	sector = rounddown(sector, ns->zsze);
>  	while (zone_idx < nr_zones && sector < get_capacity(ns->disk)) {
>  		memset(report, 0, buflen);
>  
> -- 
> 2.25.1
>


Looks good.

Reviewed by: Adam Manzanares <a.manzanares@samsung.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

