Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFB7C4708C
	for <dm-devel@archiver.kernel.org>; Mon,  5 Dec 2022 23:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670281773;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=skTIHSRpue8WF/AkISBaDads0yLwyrPe/8C4KaHzaa4=;
	b=Bn2FuRI72mtLeHTqCzzWyqAMwLecsbEzi3R9BHg3iben4PeaDrNM8QTPBY+6POBK3Xe6KM
	NeDAveM58VLRmQ6WK4qQK26WewbeBnufTr14YmlPx/OWyte7Xgp9Wwt315AlwyKROF/agA
	1Rxgxf3yhLxfq5eobJdrmC/Eg5ZV5/w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-OZcH_S8INxiaTguP-J3yJw-1; Mon, 05 Dec 2022 18:09:29 -0500
X-MC-Unique: OZcH_S8INxiaTguP-J3yJw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EB8886EB30;
	Mon,  5 Dec 2022 23:09:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 787E56D663;
	Mon,  5 Dec 2022 23:09:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3BDF21946589;
	Mon,  5 Dec 2022 23:09:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A23EE1946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 23:09:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95163492CA4; Mon,  5 Dec 2022 23:09:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D240492CA2
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 23:09:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DA8E185A794
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 23:09:24 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam04on2044.outbound.protection.outlook.com [40.107.100.44]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-UwT1WogAMnOqOIrAezpZOg-1; Mon, 05 Dec 2022 18:09:18 -0500
X-MC-Unique: UwT1WogAMnOqOIrAezpZOg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MN2PR12MB4333.namprd12.prod.outlook.com (2603:10b6:208:1d3::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 23:09:16 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::b84c:b6e:dc0:8d7%2]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 23:09:15 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Enrico Granata <egranata@google.com>, "Michael S. Tsirkin" <mst@redhat.com>
Thread-Topic: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
Thread-Index: AQHZCMWIE493Nhwph0Wuxc84G3ju4K5fm/IAgAADgoCAAATVgIAAGpgAgAABzACAACr4gA==
Date: Mon, 5 Dec 2022 23:09:15 +0000
Message-ID: <ec9ef065-253c-267c-8407-1ac6cbeeeb74@nvidia.com>
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk>
 <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
 <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk>
 <20221205152708-mutt-send-email-mst@kernel.org>
 <CAPR809siFTeKSVxGPmnWpbyKHKoiVY-YYVV+Wzv2bVtvc4XBfA@mail.gmail.com>
In-Reply-To: <CAPR809siFTeKSVxGPmnWpbyKHKoiVY-YYVV+Wzv2bVtvc4XBfA@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|MN2PR12MB4333:EE_
x-ms-office365-filtering-correlation-id: 1b27a293-d588-4175-9b59-08dad715bb01
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PDOHs9jMQL0LC79icT2/o6GAPMt+iO8HzDHroGRQ2WRdDx0ga9jepiaOQYID2Uq53xReGppjlZihpwuOXtJumf/9RNLYc2Ohf4n7Bbatt+nVFLQBpvFPmA23GsXmRb1QhZUtiaqvObE2Bvvdfysif8SnMh/KRQV00QyxxkehKo9hVQZ8rQoCdOVFNilsEhDpFusKcf7is/GYT3D/S+gMPBt6DWJfOGZSUCAXT1DM14g5MYZV9Q1XktJjbsnqX4QNtQaUuu3dD9y4RYVoegIXQHI5AIkQHlSJg7eGbufTYSTNBz9wuLC8NL9g4U/r19k3NSoQYpO6uOc0b9BCTXkvj93bAnIhEHvfpD2ixI7PnwStdDZuNBVdoZB/jBmSByv8Pg98NPU4tkKc+VQdjBB+ObDvMdC1oypmCIb1obELG7xFGr105QA6wbdGcoa9bA0bjigd8LkjhHzxrvhcJFJVbfssKrlHiyEwOJaSe1mXJnYgglISVFJiBUaoQUjaGpyHT4Awz+njFL87zC10WHJZygRYSNT5Mmvjlu6rOzjXdgcCO0rvs1dvkD9aCv+Bd8jcfbmTCp2aEGm4XGn1mXM8trMJaN8n2UDurLRz029g1H0es5MVXT2bEeXGygiARXf4vQcQ9tpxEzHthde6GnYcF1RP2f80kGpRUf3TPgsYSRh9TsU5aGL2Ot4FgzjadJYBIGCgzs2aMGXVzaMwWL5TqPMQn6DMZUfcHnbIdN7ufLL8Ot3PT1mkjRBVFYRku6x33p2NwD9MaqV95PMPy2giMw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(36756003)(86362001)(31696002)(8936002)(2906002)(4326008)(41300700001)(38070700005)(7416002)(122000001)(5660300002)(91956017)(66556008)(66476007)(76116006)(6486002)(66446008)(54906003)(316002)(66946007)(110136005)(2616005)(31686004)(71200400001)(38100700002)(478600001)(8676002)(186003)(53546011)(6512007)(6506007)(64756008)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NUdCR0Nra1g3ZHJrdjF1Wk1FcWN4WUVKZDFlMDBKNGtUbVlZc2tEbEJXcy9I?=
 =?utf-8?B?Z0tiZzdHaFFNUXpxWFJhWUlMVHhsMTFLREhqdVJhYjhNOEZISmZadnJ0WGt0?=
 =?utf-8?B?Sm5Rb3J0L3UvdElScXV2a29sVzNlVS84SGdyaGxBTVRQZ3BJa0lkUjdUa1FW?=
 =?utf-8?B?MEdZdzhBaUFJQTNlcHBNeEVNODNNbHROSEZwYkZVR3pLdGY2Tk1iRnhHQ285?=
 =?utf-8?B?RTRHZ3hFWlZnWGVNd21UdTJXdzNwWjlEeFZWMWN0RXBDaVlKSlIvMERSTWdX?=
 =?utf-8?B?UG9nZ29GTm1oVkpBRy9hU21xWXhhZTJhVzhhYVlUdWxyelVrQS94aWZqdTl2?=
 =?utf-8?B?eTVJTnhkT2x3NVZmcElrb0VzN0g5c2NyMDdTTkRRYUFsQTVyV2xiek5PMEJR?=
 =?utf-8?B?dE90Mm5qbitYTXdEeXczKzhtRVhiaERYcWRNa3hEaXgzeUJ6YWxyNHZMc2tO?=
 =?utf-8?B?S3pleHUrR2lORnU5REdtS2Q3ZnY4SVVDYXJLMGhESHByZFg2VnlzUlNmbTBR?=
 =?utf-8?B?RGNndTVLWDlrV1gvREZKMCtsQi9PVlZpbVk5ejJ5Y0RRRE9EVjkrSlZkREZu?=
 =?utf-8?B?TXdUcm9ldTJWZGRhb0tCSk9ybDViSVpYeVBEWi9tNnhZQndabnlheXloWEFH?=
 =?utf-8?B?YjZIOXArK09GUzQ3alRJeDI0TENMNUdsRk9pZmdTM1JzZnVjdVB1Rnk5WU13?=
 =?utf-8?B?eVBIZGNkRGwyR0ZRSmhGaHIxK0dZODdGSlpCYTJESGFkZDBkNW1jbGxtYUVu?=
 =?utf-8?B?T3ppTEVDMnhnWFBQbHdJVzNwY0lLVHlqWU1TT3N1bzE2b1llMzI2c1VVYmxJ?=
 =?utf-8?B?dHoxU3hsZENaTW1vT2Zwcm83aDFTRExVbUV6VTc2c1BaYVJJeTFSbFZOQVZN?=
 =?utf-8?B?OXBzUk1TNEVBSTI5M05kRUZ5cXkrOFUyOWR1L2VsclBmcmVsZXFFUHQyb05k?=
 =?utf-8?B?VGJwd282dzdwT2haR1FrWHppNCt2WXBTU25OcU81bWI3aHVuN1BWNnZQcUZw?=
 =?utf-8?B?elZMSHA5QUo0aFU1bXNYcExOQ0xSak9qS1J1dHFvUUpYRHhydjE1RVpyelhB?=
 =?utf-8?B?WjdiNDEwbEVPdXFudnJsbTZUVTFteExlRjBYSXNYWUVTdkZtRGJDbE9oTTlK?=
 =?utf-8?B?T3dsa3p6NXBkSlhzRUd2UHZsM1hpZ3luSm9VVkR6QmdZTjZ3YVpWdi8yUVNq?=
 =?utf-8?B?ZThKSXZhd3FZVkV1NGZmZEVBNkVMQTc5bGNzTHJ5M1pqWjRxVlAwaCsxM1Ny?=
 =?utf-8?B?UnRJVFloYnQrNStJWFQxT1F0N3pjUTJIbHZhY05kbUQwZVFrVTVuQWlMYWlS?=
 =?utf-8?B?Ym5zNmtnSGRyWlJlNVo4dEdNQ3llM0hlR1hhL1ljMjBqWXBPY1JYRnZVcWdS?=
 =?utf-8?B?WCtrWU9nNDUzbkhZVmFKVmJHTVVmZFBYTzBqWEM5QWlXdzkzTjc2eVhoMG5o?=
 =?utf-8?B?a3JaalBUZndqTHNGYVpCQ0FNcFIyZkdTaGEyUkRDQ3NqY2VnMnllejY3VVJ5?=
 =?utf-8?B?a1BjRFhMbk9IUUtMeDFsU3RBLzFrbmJXMTlLcTdMVU9Tb3p1WkFyN29PeXhQ?=
 =?utf-8?B?U1BQNXVKalVmOEpZcCtRdit3c1pRaEU5N0RWeUp1VEU4dmFtTTlzUHN5aThF?=
 =?utf-8?B?WDR4ZEdoQXRFK3FHVHJjVFFob3RnOEtqeGlrOVhvQWtXbEdzazBFMFZFRmll?=
 =?utf-8?B?SDlEaTN4UFlyNUg2bWsxREc3dkhlVENGb0xNTU1GcVRiWDRyZWdKQlM5ZkFv?=
 =?utf-8?B?UVI1a2FtbFNyWEswUS82Wjl2S0JXcm5iRWZxdE9JdEROYjB2cDV5Z016Nkdj?=
 =?utf-8?B?Q1hPUnhIdGFNMGZPcmtqMXdsdHlLNVVoUkg5b2V6WFJkbDF2N2NEbEpsQVpi?=
 =?utf-8?B?SFJyNzU0QjU1ZmVydmMvQ3hLczJYSldYdHhoTlRsb2xqb3hOcytTUlpSZjd3?=
 =?utf-8?B?WVJPcVhoSVFpM0FIMG5JK0h5UUozbG01ZmpYYm1uY0RUck5GK1dLODdRQWtG?=
 =?utf-8?B?TExJMWN4U1lzSjZXSlIreHRtTXowdWxWL2NPeTl0Y1RUQnVJZUN6dW5Dekx2?=
 =?utf-8?B?clZ0dkk1VjZxWllDT1FvOTUwN25BRTJYbnJCVTI5L2JJTTB3dUpTU20zTzhE?=
 =?utf-8?B?ZS9tZXhwaU1YTjhoSkZNVWM3RjVxdDZ1VDlhSlozQjFYS28xeVIxOUpVMjVl?=
 =?utf-8?B?WGc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b27a293-d588-4175-9b59-08dad715bb01
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2022 23:09:15.7920 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uysi3Rzimpawwzvli83Q6CpJtY7bCrmuFzBiMFFj+1s1ASLKLrDEaKTTqosC4/KPXXobvnL2l5clEM/0H4K5Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4333
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME
 feature support
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
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Alvaro Karsz <alvaro.karsz@solid-run.com>, Jason Wang <jasowang@redhat.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A5A05BA46B99B7468259A95FEF1269E6@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/5/22 12:35, Enrico Granata wrote:
> The original definitions for these fields come from JESD84-B50, which
> is what eMMC storage uses. It has been a while, but I recall UFS doing
> something pretty similar.
> Systems that don't have a well defined notion of durability would just
> not expose the flag (e.g. a spinning disk), and going for what
> eMMC/UFS expose already would make implementations fairly seamless for
> a lot of common embedded scenarios.
> 

Has it been considered there might be non-embeded deployments which
virtio-blk frontend can also benefit from this feature and they can
have more flash cell types than present in the approved spec ?

> Of course, if you see room for improvement to the spec, I'd be very
> interested in hearing your thoughts
> 
> Thanks,
> - Enrico
> 
> Thanks,
> - Enrico
> 

 From a quick look :-

The struct virtio_blk_lifetime is too narrow for sure only
supporting two types, it at least needs to support available flash
cell types to start with and the members needs to be renamed
to reflect the actual type for more clarity.

hope this helps ...

-ck

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

