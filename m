Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7827ECAAD8
	for <dm-devel@archiver.kernel.org>; Wed, 21 Sep 2022 05:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663736611;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BeLWux9aIImi2mpjYLjjuXRCJHoqzrbJEfoqENdpDHA=;
	b=IYsvrQTOEU3poTkinvp5+Oa/rtcWcz4PXkVsA8PjhIM5c/klHItlRfCBzgQLGdVvesjFq9
	OYRekT9yNaHNBz2suwj1G6hbU4uzKoaNqf/NjfdjnZrsWu7RbTD6r5aHzlzVsGgphXqkRa
	OI5mfMKXTTVH2xTpzjI2qcqDJZqOIF0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-lEdVZ-61NPGVsnGHFsFN6A-1; Wed, 21 Sep 2022 01:03:26 -0400
X-MC-Unique: lEdVZ-61NPGVsnGHFsFN6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A8BE101CC6D;
	Wed, 21 Sep 2022 05:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1657740C2064;
	Wed, 21 Sep 2022 05:03:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E8C591946589;
	Wed, 21 Sep 2022 05:03:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBBBC1946588
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Sep 2022 05:03:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A324F40E42E3; Wed, 21 Sep 2022 05:03:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BB1D40C6EC6
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 05:03:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79DBA3C0F672
 for <dm-devel@redhat.com>; Wed, 21 Sep 2022 05:03:23 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-XbQrv9WOP_W6AM4MFMXiXQ-1; Wed, 21 Sep 2022 01:03:18 -0400
X-MC-Unique: XbQrv9WOP_W6AM4MFMXiXQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW4PR12MB7336.namprd12.prod.outlook.com (2603:10b6:303:21a::9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Wed, 21 Sep
 2022 05:03:15 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3d10:f869:d83:c266%4]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 05:03:15 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 Zdenek Kabelac <zkabelac@redhat.com>, Christoph Hellwig <hch@infradead.org>
Thread-Topic: [PATCH v2 4/4] brd: implement secure erase and write zeroes
Thread-Index: AQHYzRr3QXDUB7Sxgk2nkklKV2iRsa3pVLIA
Date: Wed, 21 Sep 2022 05:03:15 +0000
Message-ID: <8aa57d66-05d6-154e-445f-ee99ecf4ac5e@nvidia.com>
References: <alpine.LRH.2.02.2209201350470.26058@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2209201358580.26535@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.2209201358580.26535@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MW4PR12MB7336:EE_
x-ms-office365-filtering-correlation-id: 49ee7b78-c7c8-41ee-5a23-08da9b8e972d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uQCRB4mz8BzfbhbklMYo6yoZ0eEtQGyffhiqp+6baivQRsqa1CThhQJsxwZIm014ghSrk/zHFwjCyRsxzFCfxKJwFJ3vo4/ZYrVvgSsn82dGXqfXpe4WKh4kz0+IA8IX+7CW13FIDf45ASglJ1M2Hv0Mes1mkAWu0eYmqEldlrcqthbtl0vIFVswYlwiAFFs9tyPvbJ2F6o8BxpgGUj+t6lVD9M1RNRpCK5seYlPf8GOKhsfO5NBzz/REWA6jDq7njtnqe4ROe1hITFgdFbcDyEjeKV1rWZGRqsuX1xGymahwL3wTi7YUKtyRH02zu1oXsDYMvAXdmCrR8Sc8CEaqFATP2Dt8WbmxDcKGn2gcVktUX7g/l0h4Wu1byOl5UmgCV7yqidHriBjYd7MT5ckOauCmfkNBMAJ3cwKGirNl2Bw2EDuDJJUMHLS0dbmop0X3cfmwiZAsc0rbduyXcNX13EMIe8cyCdRHTJSQigtn+0xxLc5xsXQ0qA58j1TymL4PtRdnm6tOZTbZ2e0h8faoWXBo0JI25V+sUom0wIf5Tbe09G0tp7QuMprT+DXTq/YdPK90JvtmbexOfAz+gbgGXYAY0hAfP8wh9JlkGJj96Mi/FZsBYl/kxTcJuFMEnNibo90p1vrF0Ah+s2e0Lp/+uE22Dg6TPBnWGHU3JNEX/QFjIo/6gvp7kCWQMcWlOngz7dVYb2m+FBNORGOQF9RuZEQR3EtLwmMXR5ircl5N87gAxyOvFXWCkcCmSPWvWwwJ45oOxzSoScRc+n9QoEecfZatu3P3ETvRrTgi+5r980y6rLspvTwxnNz7Grzrzu9NSAMbbkIrLLgfr7yhE7mrA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199015)(86362001)(38070700005)(31696002)(122000001)(5660300002)(4326008)(76116006)(64756008)(110136005)(66476007)(66556008)(66446008)(8676002)(316002)(6486002)(54906003)(41300700001)(2906002)(478600001)(186003)(2616005)(6512007)(6506007)(91956017)(38100700002)(66946007)(71200400001)(31686004)(8936002)(36756003)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGxhaFVxdDR2K09SM0pDeUpDRk1ES0NVUW9EbW1za0lmYzRLdllQNm5sdFJl?=
 =?utf-8?B?QWorMHN3UjRjd21FdThyK3gva0huY2NDckxGcUVGaGxXckJEVGR6alpubzcz?=
 =?utf-8?B?cTBldWhIU1ExOVZoYkZuL1VCeVhxdzlYSk1NNWxpakZEYTdiRVpJRmdyUzVO?=
 =?utf-8?B?dG1VdVNIeHB3bFdkZ1RnUDN4ejFVRDNneHJleHdNUHk5Rm1pa0ZESzhCZUVx?=
 =?utf-8?B?RE5nTzk0WGJWZzh4ajhoTVVkQjN3RXlQemtxQzhtOThHOFQ1dzd2T0tYaTZD?=
 =?utf-8?B?RmIxUDY5bERlcUQyd2tmSUl4MWRvc25WZVE4cHBnb042ZlVvRXhrWkxUQ3Ar?=
 =?utf-8?B?R2paQUUvZnlNZGgyYnh6VUE4MkZSTzdjalNlZXJKTkoxZDArbG0wb1BZVndv?=
 =?utf-8?B?WVE4Z3d4WGVZRm40UXBlQTc1Rmw1T3J1SjQzbFpiOGpnR2htcnpTb0RJYTJi?=
 =?utf-8?B?UmxjUlJ4a0pGakM5UHVMdnlQWndUZkpKTURrWGRlUEF2TDdNaHpQczAra3dP?=
 =?utf-8?B?US9Rem0raVdtbjc2QkcwbW9vUlZBQ3pQVDZBaU9Od1Z2WGdGN1EvR1lSdDFy?=
 =?utf-8?B?b21DZjlaVG1DdytFZTErU1ZveWFTS21ZOG5SNzZOSU9JS2t5dHNsZWlRMENQ?=
 =?utf-8?B?SmVqU3hMU0dMMVZRaHozcjRGbTVPZTdRM0g4MG82RHdOa1puaWNkeno4T2FL?=
 =?utf-8?B?eHBEb2F3TGMrQ2ZRZkEybmRId25lMlN0SXZNckN5Vmp0b1FzOHRyL1h0blBJ?=
 =?utf-8?B?OU8yNXllSkR0TTUvdElHNHBrdG1GdENSaU1TNWJXN2dsYjAyK1BYUStaY0ow?=
 =?utf-8?B?U1lGaDVMVTk1SjdybTErUGNQRlJtN216Mk02bWtnNGp2U3JnNnZSN0VGWHRm?=
 =?utf-8?B?bDdRUnVUelFwQzNlb1l0b2hicitmdEVONktWOFpjSzNnYkJWeFVxbThTdVc1?=
 =?utf-8?B?YllaZW9tMC94c3VzUnUwQUM0eE1oYXNLNjZzamZFMUx5bFN2Yi9pV0pLTllt?=
 =?utf-8?B?SEc1ZEpEdHJHU09WUlliVkQ0N1FFSlVNNVN0amJ1WlNaRXIxZXNXM3crU3VI?=
 =?utf-8?B?c2VvNWtIQk40UDVwUWxmTGFOUk03dDFsTEJZVjZNRVQzWUdPVlc2VXBxTWZU?=
 =?utf-8?B?ZVJkaFlBTUtOd252d3gwQVFqYkk3RHptTGtXMXQ4V3RFL05GV1BYdzZ5K0NY?=
 =?utf-8?B?WFZhRU0rNmZaOG9WNXRwTktwYWswMzlKRjRKU2t4SG9ldGs0ejZhS0R0SkRS?=
 =?utf-8?B?TVV0ZlA2SlZEQks3QnB4SE9LbEloUGE1ZXJkakRiT0hYcWZtaXNWRVFhY25T?=
 =?utf-8?B?TTJhaFlXaDUvWXl3Z1pDMXVzbmxUNWppdEZIRDVjVmY0cmpPTUR4WlBPZURi?=
 =?utf-8?B?dktUWUFUZytZS0I4MXpSUDVrdUoreDgvdld5eHNEMjk1OXU1b2xnOUNWWHJE?=
 =?utf-8?B?a3hBdWZqYU5uYnZRc3dGM3ZYMy9xcmFFZVA1MjZsYysxNFFQb0hMZU8vMUJW?=
 =?utf-8?B?cWdMZXovaFVxbEhhRGQ3N05Ld1Z1RkorcSszL3ExSUhPcXo2THBvMVgvNkVt?=
 =?utf-8?B?MXgxR0lWMkMzb1oydlY2ZlM5SXhHaFZ4NnRhQ1lXbTRob0xzOG90ZHNpZFdU?=
 =?utf-8?B?T1hUditPNS9DKzBWYXEwVjdsN3NJazdwOEZJOFVtV3VhV2g1eDh0Zlp5VjVR?=
 =?utf-8?B?cFVRQjN6ZGkxVUU2M1FLZzJrSDUyU3lVbXY3em52NG44Y1hsbWZyZk9HbDBS?=
 =?utf-8?B?dG1VK2hya2I2cURqcTBsclVJb3JuTGFrb0pSNjNDZDRNU0d3TDlWZ2RoTjRh?=
 =?utf-8?B?dGtJbHZtZnlmUkN1TXRvYUQ1UG43S09rbkxJVXBRenlIVS82RUhmeDRYcmIz?=
 =?utf-8?B?U2dzeWI2Z3o3ekhjVTRsbkhxOVZnUVVFZ3M3NXJZTStraEVoL1NoV3lGemM3?=
 =?utf-8?B?aW8zRE5ZczlEc295ekxRM1J0QWRlSzg5TjZidTQrVDlSUHNIQStwQ1pGS2Jm?=
 =?utf-8?B?Vm5YOE1qYk5VYlVORWhqVkVvWGpTNG9yQVRtWXJzQUMwS0E0Nm9CUXFUMHhx?=
 =?utf-8?B?RFNkNTlXNW5RUEgzcWQwN3NLVjRLZmR1c0xJWUo5S1NUajVmVEdGSERLeFR6?=
 =?utf-8?B?eUlJN0hPam5pUjhZL2pVNmVHTWZRcHpIN1ZqOWEvT2NVQXB3aHlFSkl5YjdM?=
 =?utf-8?B?Umc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ee7b78-c7c8-41ee-5a23-08da9b8e972d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 05:03:15.0027 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Er93TbhcOXr94zRODFlK0LNnMXYq0Wf1sXzTTdEyFMxBuRAFbRhgVTFIKBtkOLzv+Eer9Q1y7dGf1dmPyIp0uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7336
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 4/4] brd: implement secure erase and write
 zeroes
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <74A07A6D3C837540BCF351867B5EAC71@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit


>   /*
> @@ -300,23 +303,34 @@ out:
>   
>   void brd_do_discard(struct brd_device *brd, struct bio *bio)
>   {
> -	sector_t sector, len, front_pad;
> +	bool zero_padding;
> +	sector_t sector, len, front_pad, end_pad;
>   
>   	if (unlikely(!discard)) {
>   		bio->bi_status = BLK_STS_NOTSUPP;
>   		return;
>   	}
>   
> +	zero_padding = bio_op(bio) == REQ_OP_SECURE_ERASE || bio_op(bio) == REQ_OP_WRITE_ZEROES;
>   	sector = bio->bi_iter.bi_sector;
>   	len = bio_sectors(bio);
>   	front_pad = -sector & (PAGE_SECTORS - 1);
> +
> +	if (zero_padding && unlikely(front_pad != 0))
> +		copy_to_brd(brd, page_address(ZERO_PAGE(0)), sector, min(len, front_pad) << SECTOR_SHIFT);
> +
>   	sector += front_pad;
>   	if (unlikely(len <= front_pad))
>   		return;
>   	len -= front_pad;
> -	len = round_down(len, PAGE_SECTORS);
> +
> +	end_pad = len & (PAGE_SECTORS - 1);
> +	if (zero_padding && unlikely(end_pad != 0))
> +		copy_to_brd(brd, page_address(ZERO_PAGE(0)), sector + len - end_pad, end_pad << SECTOR_SHIFT);
> +	len -= end_pad;
> +
>
Is it possible to avoid these long lines ?

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

