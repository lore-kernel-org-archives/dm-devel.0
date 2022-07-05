Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F356CCA47F
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119239;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bJ3+REXXTvBNcBglWEJ4baGIobCrw1ajgY32+JOYzeQ=;
	b=gtm+Alcop/sDeCz8Wv6V1d3JbwB5CyAevXoQu0uo4mbCpEwU4jsUgqCZW4nk/fSU6kAOHl
	Q8eYZ+HbikikH2Wku70nw3ZZTQyI7rqx6U6MPhmlM7MPEleQ9XaNI++bB/HsHL8JoOJSw5
	YgCCavkRZyBv8nGYT2B8pLK801VEqVY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-EePqLmAxNKC9sA2hkYZ6Tg-1; Wed, 06 Jul 2022 10:53:58 -0400
X-MC-Unique: EePqLmAxNKC9sA2hkYZ6Tg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10CF43C2F76F;
	Wed,  6 Jul 2022 14:53:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EFEC62166B29;
	Wed,  6 Jul 2022 14:53:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8152A194706D;
	Wed,  6 Jul 2022 14:53:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 058C6194704D
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Jul 2022 06:43:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DE2591415309; Tue,  5 Jul 2022 06:43:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D8C821402406
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:43:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0B9C185A7B2
 for <dm-devel@redhat.com>; Tue,  5 Jul 2022 06:43:09 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-9UMUwa1PMcGyd-rkP3y1Hw-1; Tue, 05 Jul 2022 02:43:06 -0400
X-MC-Unique: 9UMUwa1PMcGyd-rkP3y1Hw-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH2PR12MB4837.namprd12.prod.outlook.com (2603:10b6:610:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Tue, 5 Jul
 2022 06:43:04 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 06:43:04 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 14/17] block: use bdev based helpers in blkdev_zone_mgmt
 / blkdev_zone_mgmt_all
Thread-Index: AQHYj6QIAfI6Iq3OEEOykZ9+r9Gqw61vVa2A
Date: Tue, 5 Jul 2022 06:43:04 +0000
Message-ID: <d2e677f9-6e36-f963-b58f-7477a47f774f@nvidia.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-15-hch@lst.de>
In-Reply-To: <20220704124500.155247-15-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15863d64-207c-4e58-c4b3-08da5e519cf3
x-ms-traffictypediagnostic: CH2PR12MB4837:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 29G0MNeSfK+UENckNR9EAKZjPwgXj1CEHDNeq0oN2e+FfrmWNnJ8LxOlFAofW4xFDpXFmL8MoWv9AhPDGasCicVOivYFa6UahZa4iwq05xU1TgQrg44XTd+I3gK0thAQEXyA7jwn4mMmPBW3bs/vNehajcuUzV0zWoGnccXOhqlRvzrmepZj0zadxmXD/ceXP4zILb1+zXWENOin2TVYBJWk9GfTGG+33ZKhfzaFoQ36S7YVvsH2i5dytoeqan8AbcjsH3gDhzdgxuXJtkx3UHhyRpC0/7oH39j0hoATT98cT6CR4Fn2WrlR7bqssT1jkcbMNyD7knAPNHAJXRU3Sf7bN7RDj7hISUs/Q33NcZcBJLwAQcVC3T7eJjGpEXvoE1cuya8lGGg5dhE00y6l3Uh/+DNY0DQALzxgFmYQXHNIALa3rY1SjD6yt3wLjTm6eu8qmFkgZ+ctYB9ZAGzMbghsWGip0yMhXQSqnOCdGgORFvzmmaz8BD1IQX8ujD8alDGVyU9wk4dQGCUzQkgebkUT3orEWB9JvO85cT3PCBEY7cpKcwrW5Kj28evXKhrWN1mlLhE6dONBDgjxffO0vwpVAiX9zu2OiFkd+7eZxJBOuO2HrAqzqFMLPoGAF8/mnOz3Gf4tJS1pV88jipFPSxlYh2tiNMMvqpIOWaFrvJbdI2za5eoluDojGideak5LRe8eglPH4T0FXnvc8OBGNnv9uws8dm4r3dFTQd10gIO0bSXKevX4p+7iQvQBdiGBoKU+2ToRO/bKkP8WeQvTiU38s0Dp2hb+izGcTizbyfkcd4SpTZFHAXlV023ljMSlRLFaZTQVvgToemfmuXXduyFDJ/+rcU9VhvgvgRdsz3NdRGBsZXZ+3fHVB9JkYXo3
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(8936002)(31696002)(86362001)(478600001)(6486002)(5660300002)(558084003)(2616005)(36756003)(186003)(31686004)(316002)(54906003)(110136005)(38070700005)(2906002)(6506007)(6512007)(38100700002)(122000001)(41300700001)(91956017)(53546011)(76116006)(66946007)(8676002)(4326008)(66446008)(66556008)(66476007)(64756008)(71200400001)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXBielkrS09PU2k3TElyMWc4TlEzTVJ3WDFiaVptZFVNL01uYjZpWExwWkZR?=
 =?utf-8?B?VUxaNVRvY3dERW85Q2NnTWlHYjdiMnNya2oybGhKaWFGOHVvRyt0UWowRy9r?=
 =?utf-8?B?Z0JMQmQ5WTU4S2l6NktGaDFFYUFlQ084bEY5WHVWQ2xPUzNvVlBqSzI4VUxz?=
 =?utf-8?B?aGlPa0pacG9DVXA0NVBPaXBTZjBmSllnMTQvMVlxalAycUh6bVo4elZqTnNQ?=
 =?utf-8?B?eEZoSUtsM0h1Tm5USDJlYllJeHE0cTVRd3B1Y3FJMFIvVWt0dWF0MlBRRW9z?=
 =?utf-8?B?WFBFMlI3cTFENWMxSWw2VnFsMU04NjhML3d6ZkUxMUo4VkFaUTVUcENNZUxr?=
 =?utf-8?B?a3VTckpWY2JOQXRac0lmcTFuTzNCZGhsOGFsUGtydHFQZDlKTkc3SnhSOWZi?=
 =?utf-8?B?ajN3VDg1cWhKOGJpOFlYa0hNVklja1gwejZ5Qm1FVkZUY3BnRFI2eHUzWXpT?=
 =?utf-8?B?VVZxWDRKZC9US2JaajZBMWVCdXdjZUhkbDMyOFBSd2RPbURodWloYVRXTDAz?=
 =?utf-8?B?K1RScTJJVTRDamN6WmRTdUw2VGhTbUVZMnRLWXBZM2NVMWFRRy9oSVlwLzIx?=
 =?utf-8?B?TnJzMjJRYUw5dnEyQWYrQnFHMWlKb0t5TUcvd25vVkZFZDZCYitkdGhMTy9n?=
 =?utf-8?B?OVVrSDFBeHEwdkhXWUJaZTFudC92MDlyazRLdm13Y3VmMUdKeG12RjVJeWM4?=
 =?utf-8?B?OGpDNFROWDFuNnhFQVVDeEMrY2krYzllSjFLbjhWOFczdUwrMXo5dnEyUUIz?=
 =?utf-8?B?SXB2NmoxWWI4WkdwbitJZmdPWE9NSnNwbVFXNzdrTVUraVN3V29LSWVOMGVQ?=
 =?utf-8?B?UG1BTm12OWFUS0pIeWlsRVkzTTE3TzFlUm04cDhtUVNTRVBzK3pjS1Vnc0g0?=
 =?utf-8?B?REJyMGdmS204WjN0VTdUclhsU3JJYzRFdlk5azFzUTdJSWRRcStZbHhtMkdK?=
 =?utf-8?B?d0l0bE5pVklBNnd4eEMrdzJhOU9DQkgrTGpER3JBcFZ1cDgxWGgzd1AxU2Fi?=
 =?utf-8?B?alRWY0pCRFpYeUpLdWF0YUY3dENkd0pJdjF3VDk2MkZpN0dpVXBGOGtLc0tt?=
 =?utf-8?B?QWZwY0NRMGFsaERyNml5a25FR240N01OYzE4b2hwWk5VMTZ2SDlSZkVrK3RX?=
 =?utf-8?B?aHhaNzQwOXo3QkRnaVppUmhmU1RPcnNTOVBoNDZudW8vS3IwL1N5amxTcW5B?=
 =?utf-8?B?Um9KSTdHNm93SlZ2VlJHNWZSZVhYYVAvb2xWVjdiOGIvb2FSdmx0QjJ0RHRn?=
 =?utf-8?B?UUhTTHhlb0hBemswaDVvNmhHdVpDMitwaWdJQ3U4M3pkcW9NRUEvVE1jQU5G?=
 =?utf-8?B?SFgvak5wc0hTN09HS1V1Tnhyd085R1pLWjl4OXFuRUV1a1liMDl3SURTOTZp?=
 =?utf-8?B?aTE1WVJsTFkzYUVNaWtyblQyZE1tQUxBa0xRUUh3UmRsOFMwNTVoNXpDWi81?=
 =?utf-8?B?WVM1VUlxWW9YeE9vbkRMWlIxY09tbnU0R09YZm11bW1aYXVOK3BrV3g0WWJM?=
 =?utf-8?B?YXBRNkF5cmRMSitMTnJ5ME9USEJlbVFLME00M3ZrRzNFTTZadEZSUXVLTktV?=
 =?utf-8?B?cGpmYW4zblBFZWdrK2NudVVyK1lSS0pYMFdkNEdwVVRiUWF0SVNQNC83UHln?=
 =?utf-8?B?SGN0bFljTEtrZ0piQXZEMFl2UFRYM3NZcC8wZDBDSUZ4TFl0bGcvVTkrUlpL?=
 =?utf-8?B?OVZ0ZWJkY1ZxQ1ZydXY1cVNwZUR1TlFqWlZJTzFLcEV6b0dtOE9kKzVhMURO?=
 =?utf-8?B?cUR4VE4vNWtpYkYvZXhtZkREYnNGa2xTTmUwbEV1MEViQ3FYdytMSUJlZWtu?=
 =?utf-8?B?cU5FWlJ4UlR6QVdvNzVRaDFNV0tEUzR3amZZeFFvUEd5R1Y0N3libkJnT1lu?=
 =?utf-8?B?ais1cGcyaGZZOHB2R1k0U0hEOENsK1JGc0laMWRPZU0xNE1BYVZNZ0tBMzlt?=
 =?utf-8?B?WEdPQndONG5keEptbEV2VG1lWFV5ZnlxWTFOWkt6SGJLSDZCdHNMbTVEdW5W?=
 =?utf-8?B?ZFBwN21WS0lKaHRnTHVXVGdLMVMrNGFkU2pRbjZNSE1lcGQxMEl0QTgybjhj?=
 =?utf-8?B?RkplcU5SUXhIVmlCNEZVZ2lwaDlKVjNHR2NFcUMzT0h4aWw5eWFGb0kvS1hh?=
 =?utf-8?B?T05WMnlRQm1kRmFaeVd6UHdRS0JZb3ZYdVBDdGZQZ0dmTUNYMXl5ekIwVWZ1?=
 =?utf-8?Q?FfUG+Ky7s0BSOctkhry/yVxSisdtWDcSrVwfPlkMeVB1?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15863d64-207c-4e58-c4b3-08da5e519cf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 06:43:04.4460 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T/g8frVEBJdLwZksnNdEbevuaG/+y/pNXgvv4GSMADU+Fe2JhfLQW1PBUAvw3VgiW5qvYKyoZoN0L2qZmUQ7Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4837
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: Re: [dm-devel] [PATCH 14/17] block: use bdev based helpers in
 blkdev_zone_mgmt / blkdev_zone_mgmt_all
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
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <AD47E84BDA41E845BB99711858B02D37@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 7/4/2022 5:44 AM, Christoph Hellwig wrote:
> Use the bdev based helpers instead of the queue based ones to clean up
> the code a bit and prepare for storing all zone related fields in
> struct gendisk.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by : Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

