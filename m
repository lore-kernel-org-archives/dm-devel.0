Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8347C5479D
	for <dm-devel@archiver.kernel.org>; Mon,  9 Jan 2023 07:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673250150;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2O722GOWIByNGVjjDzQEdCpbe86jRm7c+Fg7nGH45IU=;
	b=N5/KGov1EQ2oKr5B8CEYHTml4nirh5DIA0sZ/f8Hek12wiRT7rR7XgGbIKj32BNZg2sRwE
	iJf77MpqBxAU6kw6AYas8ACEk+lAxBTRp4llYuDMOnf1wKnxy/AHg59yraA9jPlJlDNR4V
	qFwoeVFbS6LdBtgj/eSWWFS1EHPIl4g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-rrIVC5uSOcqAuLPzuH9KEw-1; Mon, 09 Jan 2023 02:42:27 -0500
X-MC-Unique: rrIVC5uSOcqAuLPzuH9KEw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 168FB18F0244;
	Mon,  9 Jan 2023 07:42:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66776492B00;
	Mon,  9 Jan 2023 07:42:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4F04F1947B84;
	Mon,  9 Jan 2023 07:42:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 90D971946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 Jan 2023 07:42:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 754682026D76; Mon,  9 Jan 2023 07:42:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D3CD2026D68
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 07:42:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DE20380610F
 for <dm-devel@redhat.com>; Mon,  9 Jan 2023 07:42:21 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-39FhgecqPWKVM0LO6Ih8jg-1; Mon, 09 Jan 2023 02:42:19 -0500
X-MC-Unique: 39FhgecqPWKVM0LO6Ih8jg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN7PR12MB7250.namprd12.prod.outlook.com (2603:10b6:806:2aa::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 07:42:17 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 07:42:17 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Thread-Topic: [PATCH 2/7] block: add a new helper bdev_{is_zone_start,
 offset_from_zone_start}
Thread-Index: AQHZIammHlUuXw16qk6y2urp6p07Jq6VuHYA
Date: Mon, 9 Jan 2023 07:42:17 +0000
Message-ID: <085ac6a6-201e-92d1-a72f-d34da0315fb9@nvidia.com>
References: <20230106083317.93938-1-p.raghav@samsung.com>
 <CGME20230106083320eucas1p1f8de0c6ecf351738e8f0ee5f3390d94f@eucas1p1.samsung.com>
 <20230106083317.93938-3-p.raghav@samsung.com>
In-Reply-To: <20230106083317.93938-3-p.raghav@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SN7PR12MB7250:EE_
x-ms-office365-filtering-correlation-id: 42af7fcc-6840-4e80-b348-08daf2150831
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AjGWZGISR1EuxSUHEbDnE+3Qkpv+bnYH9Q87rZsz8R4370kmDuPHmhQ4fSz9gB2LXPYtg7SJzGyZIiyVCN4r4eHl0kmtB/b1XRjXEAtOEI46wHVOmDQt44kSzRwMWLJWRjEMMDrl1GvUCbgYA6iri0DlLt+HmCGEcNYDmCAM/9xeVW1dq2rTZnqqvS4Ct16NRMkd1ior/uzn4wduGJGZNtyapG9B2W10wz66rhHXEZ0mgGkwzyZpnyLGB0yb+93SwHIaog8aQfGswDUCvnrOeFA+3BXJC+d1jWIatKofMahVMNXZb5NmzFGPpczkBZ5FvgXD4E8UqXRDGD2jiiVMDvXjol+6Prt5W0r8NVYY3jSD9Ks6x0cS1qzQ0h3HlKshWGj0V4YYlOQ6FTzpG9wavuhUBw7nf0SU+L/HD2pepsl0jZhI8cmOzkLofyx2AyMQIilED0jbIQU5MIQ8a0i67Cqz9ewanR2cYjlxErL8zXdoiVg/DTW+ipHKOq9Qw9z5qVaJMtO6QlLw8vBGPfcKQkh9ekY5oSm9Q1J3zzi/DzlGek2t+6YQkec/JWjif8sw5hbx7FHO+1PHJaGPlS+Sih9NHvGH0k9I/uzhCYygg7lanfl6qxr55PvlIuRomFzZfrDhTWmbNoTX8h4CcLRHMnvdfhGGkAOyt6bbQ3TpF/kHTEAb4hHr6RYw6lbyLj8NZXs/SobQ71nIun9UzXU0i7MM2/Zu8nEcPz55VYZZyrHVen3I47gArDt1Gb1M55YZM+u5/Xwt+DBydKCg7ekHtg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(6506007)(38100700002)(122000001)(53546011)(31686004)(2906002)(6486002)(478600001)(2616005)(4744005)(186003)(6512007)(5660300002)(316002)(71200400001)(7416002)(8936002)(36756003)(38070700005)(86362001)(31696002)(41300700001)(110136005)(76116006)(66476007)(8676002)(91956017)(66946007)(64756008)(4326008)(66556008)(54906003)(66446008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3hNdHNmN1c1UGNVZ3RHemllSU5pZEVCNmZ4dmluYU9UZ2NHUDB6QWxEczFa?=
 =?utf-8?B?QUJSN0hxT0NneUtDSzMrS2JKZkRxaGFLdmVkTHFvOWNnU2lQMEhDenJ3c3Iw?=
 =?utf-8?B?b1VuS3hvUjcrOTN2SUJVRTdmdmNyalp1YzRiRnhBWjU2TFdJelhhaVFBSGxr?=
 =?utf-8?B?TWFJdmRyMVZBNE5QdEl5OGFIdlVIdTNSdEFMd1pJVlFuKzFuZTV5ekswUWRy?=
 =?utf-8?B?R1ZlY0lySVdLVk43ZEVUdlNWa3BOMmM2WGVyV0pvMjAyQ2REMjFlUWxjZXow?=
 =?utf-8?B?TUYwMzBkMWdLdjNaUXBVMFY1dUhYc1NrcFVJRjMwemFXYjk4Q2ZURFpnV1hz?=
 =?utf-8?B?Q0dUMnd5cUNkcTFWaGJ0ejNDOUh4VExDUi9jSUtNdTV6TnA0WDZJUVk1Ump0?=
 =?utf-8?B?ejNVM2RRYi84cEQrb3N0YmFvUWdxcEwyWjRZdk5CRTFPT3A4ZDlqdXhGZjRn?=
 =?utf-8?B?cWN3c1QvYm02ZGcvaW1xaWdWYjVYZXUzOE5ZSmVwVm05WlpleUhYWUZ1UTVI?=
 =?utf-8?B?bHA0a21NWnlWZEpRdHBpVjRXa285dlFLRWo4ZWZiWmV5dEsvUGNBdkxxYXU5?=
 =?utf-8?B?OHcwWW5iRDl3ZXJLRGZDV1ZZOWJjTXNadW9nbWNrQStlQkdJMU5McUZCMndG?=
 =?utf-8?B?Tk54MGdjOHp4dWg3eEFRUnExdWpDZEF5MElyN3JZaHhPeUNXSzFuSVQ3b1Rr?=
 =?utf-8?B?Y1hOajNaMjBWQ2JDNmRYSFhkUldCZ0FZZW5BOHNHbGtoWXRUdSszYXRGdVJX?=
 =?utf-8?B?MjNEaEVjR2Fpb3pDYkdGekZURHJ5eElZMXdIQ09WakUxVEJSVXZ3Tjl6eFRY?=
 =?utf-8?B?WlpXekh5TU8xYlYxTjVOSFhPM2hvSmV5WVpFUG9KOXhDZjQ1OHhkY3d3bFN4?=
 =?utf-8?B?OE1hazFGZXhvWWJTRFZUc2ZGTkVCMi81VHpTNEQycjNLU09VZFdPRFBnWEVK?=
 =?utf-8?B?U0EvdzFuSDJzZTVDb3BqT0xtamdZS0xUdGFhTjY5R3hveGRjK1VaZEZmd3dz?=
 =?utf-8?B?MklXOUlCRitIY2pSS2Jtd0hzZWRkN0ZFSmZncjFrY0JzSldLRmM3clNrZmVL?=
 =?utf-8?B?SStFNnNhTHhWckYrSU0wNXRsTld1WnNoaVk5bGd3ZVVhbVk2MUg5aVpUV0cw?=
 =?utf-8?B?cTAvc2dBektyNnpjZkpQMlUvVnc1ZDFVdTZ6ZENFaFlDamdTdEdrbTJtOU9Z?=
 =?utf-8?B?bUpOU3FGVGFIeXdTb0lRMFJieDNqMmxXb2RsdGxCZ1FVWVJ4UHNSM0NoaHpQ?=
 =?utf-8?B?UkorNjNVSGR3K1BaK2ErZE4xS3IzdmQvbHFYVm9lUDBNSUFuZVQrckRMSTZp?=
 =?utf-8?B?MTUwdDhWdUZLZktxSTVIZWZTWTQyK3BFYWtkc05wVmt4NFdPb2pnb0xBYWJH?=
 =?utf-8?B?M2llc09aQ0FDQUJXSURORHhkMThDNG9ubHliNU5YeEpXNXNaRk1od1p5VW9J?=
 =?utf-8?B?MWlRM01lcWpnanlBaFR3d3lhN2lIMFBnblc1N0JhZmdDYWFWVm9aN1NlNzM3?=
 =?utf-8?B?QzFLK3lSTHNmN3ZSMkpxYVJaS2FnK2NuUFk2TWV0MGNTMm1qYWZvRGc2d1ps?=
 =?utf-8?B?VXgwSEtQcS9KbkxJT2Zsa1hDMXJad3B3OWRxZituTThKeFhVVzE1V1JBdms2?=
 =?utf-8?B?NTBDZllVM1N2L21tOFBmUW82WG9iZktGVWtPZVozN0tCSCs3WFNFM3lzWTlQ?=
 =?utf-8?B?NFJMa1pKNjhaTFpBdnVaWTVCRGpFUEx3aG9RUXZIOGU0TDQ4bithSG53T1B5?=
 =?utf-8?B?bDM4d2N2aXB0azlTRkNMWDVXdGgrYng4YmpsU1VRbnRYR0xRTGJpZEFpcHh4?=
 =?utf-8?B?NjVTQUcvVnByWUxvUnVhdFIxRUYzcnZ4N0pwZFZBUXhscXllY2pZdHlmOHhp?=
 =?utf-8?B?dEUzOUJZWjl5K29QTXZpbTUrSk14TTNHbG5qSjk3UmViUW9nTnloM0RsWE9u?=
 =?utf-8?B?N0ZIblJtNTl1aWxhdVNUbS8yMEJxUFhDVlVsYnI1UDUxQlk4R1BIRWJ1YWVN?=
 =?utf-8?B?UWFXdjhWa01LbFE4ZTJOZ0VqR1dGUGNiNTIxdDhIMmd3ZTlpMTJEbytyeEFY?=
 =?utf-8?B?OVcxaVA0RXJlM3hELzRNMjRRTU9LbWtoRDZpOFdFS25DUzNqTnMyOVg2TUhr?=
 =?utf-8?B?elpMVWN6OTdNUDNvNGpLWkN0eWNNSWFXOUQ5bGp0Ym9Ubm10dzU2blBXTnpZ?=
 =?utf-8?B?WEE9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42af7fcc-6840-4e80-b348-08daf2150831
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 07:42:17.1900 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqxPMiqWsLVNu8/r3Dh1WfXh1ZoiLqY9HEy4XKJnuYkEPuwjPhemw/q/Ipe7NEV6kqGAiIhtpcyvdXGlVTpcjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7250
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 2/7] block: add a new helper
 bdev_{is_zone_start, offset_from_zone_start}
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
Cc: "bvanassche@acm.org" <bvanassche@acm.org>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "kernel@pankajraghav.com" <kernel@pankajraghav.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D18CE73439D8D04A9D6C8EE0623BAF09@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/6/23 00:33, Pankaj Raghav wrote:
> Instead of open coding to check for zone start, add a helper to improve
> readability and store the logic in one place.
> 
> bdev_offset_from_zone_start() will be used later in the series.
> 
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

