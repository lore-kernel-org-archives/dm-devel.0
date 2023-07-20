Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29DABEB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 20 Jul 2023 05:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689831074;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E7Rz9ci8RWn4kapzDXKM7Y0AdfChmksrSCPU24d0uUc=;
	b=cPG4SLZHurDhASb36hjaoR7pVnu5585Wn1WNN23wfeBjY1+6et1QslDcpenmzfMlhYrflB
	WG96PlNjU/4hp0yXyWzs2eKk5Q1yH44odb134z3yNWYxZJu1gJ/791BSJqH67q8aaWbiWI
	G3yFT/Id25UfKjI/WolfjamVJBRGuYQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-4Hob8iLJP9a3oCjWHCof8Q-1; Thu, 20 Jul 2023 01:31:10 -0400
X-MC-Unique: 4Hob8iLJP9a3oCjWHCof8Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF0CA1C16604;
	Thu, 20 Jul 2023 05:31:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 23353492C13;
	Thu, 20 Jul 2023 05:31:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D348019465B9;
	Thu, 20 Jul 2023 05:31:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 062991946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Jul 2023 05:31:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DAC33207B2DA; Thu, 20 Jul 2023 05:31:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D18AA200B41D
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 05:31:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD8EC185A795
 for <dm-devel@redhat.com>; Thu, 20 Jul 2023 05:31:05 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-9l_Gk4hJNXqLgfUx_dPhYA-1; Thu, 20 Jul 2023 01:31:04 -0400
X-MC-Unique: 9l_Gk4hJNXqLgfUx_dPhYA-1
Received: from BL0PR12MB4659.namprd12.prod.outlook.com (2603:10b6:207:1d::33)
 by SJ0PR12MB7006.namprd12.prod.outlook.com (2603:10b6:a03:486::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Thu, 20 Jul
 2023 05:31:00 +0000
Received: from BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::5484:e893:c045:d3f4]) by BL0PR12MB4659.namprd12.prod.outlook.com
 ([fe80::5484:e893:c045:d3f4%6]) with mapi id 15.20.6588.028; Thu, 20 Jul 2023
 05:31:00 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Thread-Topic: [PATCH 3/3] brd: implement write zeroes
Thread-Index: AQHZun7OEB9FzcLPl06+3qRAEA19d6/CIb4A
Date: Thu, 20 Jul 2023 05:30:59 +0000
Message-ID: <a38eaa35-efc9-48e2-7aaf-9eed83589103@nvidia.com>
References: <73c46137-c06e-348f-3d37-8c305ad4c4f3@redhat.com>
In-Reply-To: <73c46137-c06e-348f-3d37-8c305ad4c4f3@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR12MB4659:EE_|SJ0PR12MB7006:EE_
x-ms-office365-filtering-correlation-id: 41cea78c-571f-45d9-a210-08db88e2804e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 4K1t3rmIAeB68JFOcWRFya6wYW4xnqYj6STS/jWGU9c8icq2+U8OAp5ZX+Kl7jjp8jAF892Yhpi9VQ82wZZZv4wIH1P5Nm5poRe1ytA69mw1J49QtqNuY5NrVLPj1yRPhrkZTZXoI1F+zXiKDnMP9bUZYb0aQbNTbw6eKbssj08tpkHZa8b+AL0qnU60FJcN6BMtcgKxYx/lA43EK91dR1s3hcIoXdUUhTpfVvheUsvRsyyxOaQUz1+7u2K6nFc8Yhr7dYjebYIYZrC7nia3rH2Nj/7MWLDp/GkTOy5PXDs/+wufeaNW6pmYPcBaLFQ5jLQgBctBk7yAFkra4GAIWBJkNKgtYc6Y7kr7eYRtaOyloRUeYMivsng3aJZE8pMQsgdSON7VaUd5U4pnSAGrg484/6IAv8pyRflFTVSH26ZjGqQasYnYXt7d7gNcXPCqtmskKpIu6FXUoSWPAOLlaNjbvQjSLCsul5RjCJY25mMfPDMqTo2X5DRzMLLEOSFXSEdX0VjqwnqIeyhHZmYDMzx23KiQicJRlTSvXPpgtLSAxkj2OYmhOurn/65/2YanL+EKX8+GtiFLNr6wpOgq9Ju5JlBqco1wb++4DS/T1qzWyUI+616yEo4LTw4fHE6NvYcMLrqD3hRPrTuG6ojNjYynZnXwAEpl0hGCgwjM8U57xg6N4V9hjmQ68f+uIYb+bBHSiYUNHq4CaOO69+F+BfQx+aCO7/nfEk3iuSHTQUs=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BL0PR12MB4659.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199021)(83380400001)(2906002)(2616005)(86362001)(36756003)(31696002)(122000001)(38070700005)(38100700002)(4326008)(316002)(66946007)(6916009)(64756008)(76116006)(66446008)(66556008)(66476007)(71200400001)(91956017)(84970400001)(41300700001)(53546011)(186003)(6506007)(478600001)(31686004)(6512007)(6486002)(54906003)(8676002)(8936002)(5660300002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVB4cUpMWlRNZWhQblRzdTMvK2VMak9uMmowenJvSDIrYUdPNGc5VHRwc3Vv?=
 =?utf-8?B?cWVDTFhWUGVYRjVpZHRablZlQXUwK3IxSlBkZW9haXMzUjEvZXByOFY2Rkk5?=
 =?utf-8?B?SXMwazNkdXppTWQ1ZTJVSUxyUHdJZHhacTB0NVQ5QUJHSk91aUlDZzRPa3M2?=
 =?utf-8?B?ak01TmF5MHBmbzZRME1vTkNEZjFOUlhwQWY1SFVScDdqd2JsNnhlQVVMVVJy?=
 =?utf-8?B?VUppRGxMVjl0K3I4U1pIT3B0M2FQOHpRSU1qTkJsUnFWeHZGUVVwb1N2UGt5?=
 =?utf-8?B?dzVmaDFtKzQybHRKMy9wSkthVGE1czExVVBZcXZFbTNFb1NvSkVxcmh5M2Fj?=
 =?utf-8?B?S01TOVVGYVBXVlhYQ1pXSUZDVHVvcDFLa0EwbVczWUsyR2ZCUW5YR2g3MEpE?=
 =?utf-8?B?cUk5a0RkZzhrVzVYc3Q4aGp6Snd6MncyYjBUeEUzK216bGJZZG5xekE1MjZK?=
 =?utf-8?B?TWUwdDFqSlFoYmlnQU5kTk5HTDRRa1VNdWxyanZMZEsrbFBOU3NtUWFsSWhm?=
 =?utf-8?B?UjZPc0lyZGVjRFllQlRORk5wYTBpU2hVYkI3czExRjZDd3g2ZUtZNWs2cCtV?=
 =?utf-8?B?L3JoejFOOVh2ZGFqM2R6RHgvdCtuL3VZSkgrZlJHNlZDODd6UUI5clVoV3VP?=
 =?utf-8?B?enlZa1NSYW9YN1NCeHczWlRmWUNLVlQwU3lDdmVkOW1OMHV6dE0rQlRLNDVs?=
 =?utf-8?B?RFFFaklmajdRYnNDYkQwbkU1RXZOZkVscllIZ2FPNEk4MEIremZ6TjhSVnU3?=
 =?utf-8?B?aCsrbnBRekMrYno5dEc0V1ZYUU5OczhVRFFwa3g5RnJpTnA0T05pZXMvZ2dx?=
 =?utf-8?B?V1ZrUHNnTEVnYU9DUlltem1ZdFdCT3JJN1VFdTR5Ry9HTUkvWDZYVnF2V1NQ?=
 =?utf-8?B?c3NwNWxyZmxPc0h4dmttSWRmc25HQnNCTW5ZSGc0TkkwWEZwM1ZvWnQvU21H?=
 =?utf-8?B?UWowU1I3dmRTUzhIWHJNd3U0SnpadWxXOFJDM05tRGI4a3VCTHBDdXpPZTdi?=
 =?utf-8?B?Si8vMGIxa1N1V1RkYlJwUlZwNlhKWWg4bjlUM1N1YnVOV2puT29WSUI5Y1Ra?=
 =?utf-8?B?d09XdklSWkxCK0RRNmdNSFZVQVdrTUdBSjF3SDZQK2RhR3l6Z3JaaVZOanVx?=
 =?utf-8?B?MHBTb0Q3aVlqYXJDaGxtWDN6ais2YUUxZjN1Z29VdVgxaWplMFkvQ0pRejB6?=
 =?utf-8?B?UnNYR1dCeS94NmVqc0RmdVJnQkYyYlQwVGdyaWZhWVpQRGxYVXVHWFJrNzRl?=
 =?utf-8?B?bkV3QkRYOGIxWmh5NFIyM0N5dSthZVA5ZlV5WU9EM3dnMmlMR0lEZjBWVHpn?=
 =?utf-8?B?enpRQTFrTjhHNDF4UjFZS3NkMVFsTEpNL2VQU0NBS2ZJUmo1NkU1NFVzSXdT?=
 =?utf-8?B?UFlRUzlxRlVtNldkQjhQcythaCt4WHBUWDVlenhaQ0NtMis2cllXNWV5dGpk?=
 =?utf-8?B?TXhmNkU3blpFM2hNcm1OT2gvVTc4ZHdyaEM0dnpSNFNMVGQ0N3gyTUs3TkQr?=
 =?utf-8?B?NEE4dk0xODREWUJjOWVEM3FvK3hqYUtyWHhzLzNZcmVIWGJhOThBM2pnSFo4?=
 =?utf-8?B?azFqQlhQSmZsTFJOL1dVT0pUNTNwKzdaQk9Icyt5Z0tVVStVUlQwd091YXls?=
 =?utf-8?B?Rm9KaXZobE5BcXRJUWhUSVMzRnpzYXlLenRIWDJkK3IyMlg3ck80QTdZVmtZ?=
 =?utf-8?B?eHlHb0ZjOFF0bnNSUE52Y2RMUlZlcWUxOG14a3p3eTBlcHAvYUhzR29aMUJm?=
 =?utf-8?B?dnZmUEV0QXNHdzhEaUVjSDkzSGQ3ZnQ5Sml1SC9md1BZcnRub2NPUWF2Tlk1?=
 =?utf-8?B?TmlVTXdoN01rUzU5UzBSWURGV0QvcDh0T2czNnVNZGxHYloyV2IyTDBJcElP?=
 =?utf-8?B?azl0UjUrZjlkWkUzUm9jQ3Nrb3BuVVlha3dzVWxhNFBBd05JWmxVcUFYZ3hp?=
 =?utf-8?B?ZGRxaW15WnRweERqRWFYS01qWTJwdzQ0NmdIZFNNdHlmeWFPVGVnUGpiR3gz?=
 =?utf-8?B?aC82TVY3UDZ0N1U2YnFIUnRSK1o2YlRXNDN2SVo4QlJtSHFUNEcvSjMxOU1C?=
 =?utf-8?B?dy9KWUJDa1FEOFdCY0lGc3ZyVXFGV0FGOXhCbHkyTk55Z0V4dCtpUzBWTGVG?=
 =?utf-8?B?cmhLMVQ5Y1cxMWRHaEIvTURpVXNhUUlHYkpTNnYyNGRzVzd2Um9Db3BubC9O?=
 =?utf-8?Q?F2swu4ZPtQJwQ1ScznEHQrL65lePl4L9D/Wu94Coynz/?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41cea78c-571f-45d9-a210-08db88e2804e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2023 05:30:59.9605 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Am1Gm4pmb+1pSWk0MooOEUduE56h3L4ImWMuucfKxRioAmhoaQTWSjvCpHi6aACuQ8RCp1ecWHmpZa3SYPCtLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7006
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 3/3] brd: implement write zeroes
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
Cc: Jens Axboe <axboe@kernel.dk>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Li Nan <linan666@huaweicloud.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Zdenek Kabelac <zkabelac@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: nvidia.com
Content-Language: en-US
Content-ID: <21AAFD1E3F92044F9D88A3BF9F8A7155@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/19/2023 1:21 PM, Mikulas Patocka wrote:
> This patch implements REQ_OP_WRITE_ZEROES on brd. Write zeroes will free
> the pages just like discard, but the difference is that it writes zeroes
> to the preceding and following page if the range is not aligned on page
> boundary.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>   drivers/block/brd.c |   22 ++++++++++++++++++----
>   1 file changed, 18 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/block/brd.c
> ===================================================================
> --- linux-2.6.orig/drivers/block/brd.c
> +++ linux-2.6/drivers/block/brd.c
> @@ -272,7 +272,8 @@ out:
>   
>   void brd_do_discard(struct brd_device *brd, struct bio *bio)
>   {
> -	sector_t sector, len, front_pad;
> +	bool zero_padding = bio_op(bio) == REQ_OP_WRITE_ZEROES;
> +	sector_t sector, len, front_pad, end_pad;
>   
>   	if (unlikely(!discard)) {
>   		bio->bi_status = BLK_STS_NOTSUPP;
> @@ -282,11 +283,22 @@ void brd_do_discard(struct brd_device *b
>   	sector = bio->bi_iter.bi_sector;
>   	len = bio_sectors(bio);
>   	front_pad = -sector & (PAGE_SECTORS - 1);
> +
> +	if (zero_padding && unlikely(front_pad != 0))
> +		copy_to_brd(brd, page_address(ZERO_PAGE(0)),
> +			    sector, min(len, front_pad) << SECTOR_SHIFT);
> +

Is it possible to create different interface for discard and write
zeroes ? I think it is a lot of logic adding on one function if everyone
else is okay please discard my comment ..

>   	sector += front_pad;
>   	if (unlikely(len <= front_pad))
>   		return;
>   	len -= front_pad;
> -	len = round_down(len, PAGE_SECTORS);
> +
> +	end_pad = len & (PAGE_SECTORS - 1);
> +	if (zero_padding && unlikely(end_pad != 0))
> +		copy_to_brd(brd, page_address(ZERO_PAGE(0)),
> +			    sector + len - end_pad, end_pad << SECTOR_SHIFT);
> +	len -= end_pad;
> +
>   	while (len) {
>   		brd_free_page(brd, sector);
>   		sector += PAGE_SECTORS;
> @@ -302,7 +314,8 @@ static void brd_submit_bio(struct bio *b
>   	struct bio_vec bvec;
>   	struct bvec_iter iter;
>   
> -	if (bio_op(bio) == REQ_OP_DISCARD) {
> +	if (bio_op(bio) == REQ_OP_DISCARD ||
> +	    bio_op(bio) == REQ_OP_WRITE_ZEROES) {
>   		brd_do_discard(brd, bio);
>   		goto endio;
>   	}

can we please use switch ? unless there is a strong need for if
which I failed to understand ...

> @@ -355,7 +368,7 @@ MODULE_PARM_DESC(max_part, "Num Minors t
>   
>   static bool discard = false;
>   module_param(discard, bool, 0444);
> -MODULE_PARM_DESC(discard, "Support discard");
> +MODULE_PARM_DESC(discard, "Support discard and write zeroes");
>  

write-zeroes and discards are both different req_op and they should have
a separate module parameter ...


>   MODULE_LICENSE("GPL");
>   MODULE_ALIAS_BLOCKDEV_MAJOR(RAMDISK_MAJOR);
> @@ -425,6 +438,7 @@ static int brd_alloc(int i)
>   	if (discard) {
>   		disk->queue->limits.discard_granularity = PAGE_SIZE;

>   		blk_queue_max_discard_sectors(disk->queue, round_down(UINT_MAX, PAGE_SECTORS));
> +		blk_queue_max_write_zeroes_sectors(disk->queue, round_down(UINT_MAX, PAGE_SECTORS));

above should be moved to new module parameter write_zeroes, unless there
is a reason to use one module parameter for both req_op...

>   	}
>   
>   	/* Tell the block layer that this is not a rotational device */
> 

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

