Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E5F4C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  9 Mar 2022 06:57:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-jlgf1EJfMi22jwoQtSTbyA-1; Wed, 09 Mar 2022 01:57:03 -0500
X-MC-Unique: jlgf1EJfMi22jwoQtSTbyA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 102CA1C05EB8;
	Wed,  9 Mar 2022 06:57:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 43304C080A9;
	Wed,  9 Mar 2022 06:57:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 27E0B1966371;
	Wed,  9 Mar 2022 06:57:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F3A6E194F4AE
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Mar 2022 22:07:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C4CBA1121339; Tue,  8 Mar 2022 22:07:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF2931121331
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 22:07:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D300529AA2F6
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 22:07:43 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-5dnbQU-yMqum15LOPqFNAg-1; Tue, 08 Mar 2022 17:07:42 -0500
X-MC-Unique: 5dnbQU-yMqum15LOPqFNAg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1446.namprd12.prod.outlook.com (2603:10b6:910:10::19)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Tue, 8 Mar
 2022 22:07:38 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 22:07:38 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 1/5] btrfs: simplify ->flush_bio handling
Thread-Index: AQHYMrQJiBMQoCadmk6WQuobhVgjTay2DG6A
Date: Tue, 8 Mar 2022 22:07:38 +0000
Message-ID: <9a62e88b-89dd-2420-2551-6f587afd5db2@nvidia.com>
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-2-hch@lst.de>
In-Reply-To: <20220308061551.737853-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a364bdd-af96-4363-cd32-08da01500ec7
x-ms-traffictypediagnostic: CY4PR12MB1446:EE_
x-microsoft-antispam-prvs: <CY4PR12MB1446E6354A2539FF367E1ADFA3099@CY4PR12MB1446.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 2lKyoMo36d9UhgqgpuVXXX/jUxoDVDAjyAsUq6dxBCgFyU/CrASs90weMJSi8mTkLxEUEStzIjOvY5OR/unUtMNSMUMtE2RM8BuhDyy1QXqlCSv4JBwbdzeL6k7okaHzljj8ZVGrfU70oBh8L0D8IMGUqHsB9vrCQZ9Qu62gcJHQBmvWJ0f7l8WAP7/7QNe3BKysjuc0n6JcT3+mX3mBINzRVkB5IQzXoJGNEp/FPGwhjds9ctUQtqAgwS8bcEIOs0SbuZxGzns8L5ODfvWFXz88Rst771SWrAQIh6Tx64t0Hra9UvVyXn5shfEn0mbjC9fEP1x2sfxyrqMnrmiLkq/CpOjM6e9cHMp1N84AmIrxYwgbZ9bHFyZwkHJRj6rwK+5mgLZ7M+/6RsvmQy2nNRZf6j0v4x5BIR4eIVY94kTkVowWFqAOGHs6TR3zSfFpeoUsVAydMxMx3rAGFX3OytLxYGyHRP5v3CsQpf/4dHG5GlqDWxDueKuHzc5ADQRtAd4r0BEoO7XfKVK64RHsJaRbGW/gCQIGX8MJYV9/OpKAjgSQBnIYgkUmR2V+JfR0mkctr8HDkl0Iq3Di7xYJVPW1qNncT2euNMh7O6ozArBsfjlFaeVYHLOw1tFZv4UirM4ROI8Wk6mW4Q4PLTalvYRRNo15SKi6Yj0/BHcz6c94X3+zz9Q7VMMfSVdIl8qOOmhO9KWaXD8yjbyd4qNNO1Ty77akBd5kCmv5fSKUSyAxnV7pKIk36+AWIn/gqvt7uv1+TKZrSh2zakQ6fTo8jQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(186003)(5660300002)(91956017)(8676002)(66446008)(66476007)(66556008)(66946007)(64756008)(76116006)(4326008)(558084003)(316002)(36756003)(2906002)(8936002)(7416002)(110136005)(54906003)(38100700002)(31686004)(122000001)(508600001)(38070700005)(6486002)(86362001)(31696002)(71200400001)(6512007)(53546011)(6506007)(2616005)(43740500002)(45980500001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmdoK0RkVUJWMDk2QnFpSGRHNHJQY29wWDFFakVMZlZiem5WZ0doNStrWmND?=
 =?utf-8?B?RHFMbENxRTlpV1FxRzV3QTR0R2UvVncwcWtoQ2VucmdxZExoUGdlajNtRkJ0?=
 =?utf-8?B?bThaaDNWdi92MXNwNVBmaVFIWEtPMDN2K3Y2Z0RESnRkaWIrdHowSjVpdEVy?=
 =?utf-8?B?YlZTajZrL0U2d1lGNlNOQ2dROUl4c0kzNzJWRythOEpoQ1ErUGF6bjlCRHdr?=
 =?utf-8?B?K0o3OE1HWlBybUwzKzJHWGZxOXBUelVCVTB6ZmVZbHpSbHJyamZPVFlZNDdq?=
 =?utf-8?B?VDkxbnRySUpLTUE4K0g0TEI0RzdHTUlpeHlPOUhQQWJVMnlTSnhidzZYMDBH?=
 =?utf-8?B?Snc5TTk1ZFFSN3dxK1dyWjRNeVBaQ0NFWmpndHU3bVcrV21nM0lPWVByakhW?=
 =?utf-8?B?T3F5S2tLRUI1ZmZiSWZhdE9OU3NMNHp2STBKeE1UNmpOaUY1QytpNXFUUEVa?=
 =?utf-8?B?NFk5czlBUE03bXlVMk5OUmxYaXBLZm8zRUp2eWQxZDRmc1RQY0QzLzFWN1hH?=
 =?utf-8?B?NFFDT2c5eWV5VlV0cGppYTl3c0N6L3BmQWZjOVdvY2ZWRFZlNXorUHhZcXdO?=
 =?utf-8?B?ZUh5L2lLdWhodm9lTDhFU1lWT2tVL0lDMS9ZRW9ycmJHMW92MmFvNlVMNTVm?=
 =?utf-8?B?VTYwZlVBY3hXcTdjTnNTd3lMTmhKU2E5aDU0OENub0MyUmFSOXVmSTZJbFdl?=
 =?utf-8?B?ZGQwQ3VVR2dycGg1Y2pSMkd6NndLMk10c3FIczBxRFpUZ1V4ZG9GYkZHZkoy?=
 =?utf-8?B?WGhIOXdCSW9DSUIwSVlpVWZNYUN2NE9nckxSWUg4TGgzcDdidTkyV1Bjc1ZI?=
 =?utf-8?B?TTdzYU04SHR5eVlDdTBhVTlpd3VGbkNUNnJLTkl2aFMydno1UWtWRzIxMFlj?=
 =?utf-8?B?aXk1MWNiZ0NQSXVZdHk5T1RlZGFiMmNYVnlOZU5xTThIck5MbHVXbXJmOEEz?=
 =?utf-8?B?MlFndzRSa1hPUTFiY0xYQS8waWZrNVVUL1pFbmh5cXVkV3NCYzIwaUsvb284?=
 =?utf-8?B?aEJOU3lzY1NNc1NmWmh3dlhoTGk2VnZwcW9PbklDdTZUKzk2ek1adVNaRTg1?=
 =?utf-8?B?WEZFSUdWU3U5c3JzYVd0YXlvQnZuVTBZYTNQY0dPYnBHQVhtK2N1ZjRoa3pW?=
 =?utf-8?B?M0FDWENrdWZjV01kSjA4MUpJUVhYZGprcmtPYVorV3FQUnZqb0FiZW8xelFZ?=
 =?utf-8?B?MW4xODJiZUpkNjZyWk11UTNMMjNITERVdFlKWTc1bmVyOXZha1Zwa1NONGdR?=
 =?utf-8?B?VnZsWE5INDFyb0NGTmtabWpBNloyaTJmUWM0YUpmZ25scXNwUG9CU0FiZVI0?=
 =?utf-8?B?ckt5QmNzRy9oMVRHcE93ajhPMmE1VHZwbEVKQWlocGJ5ejg2V1ZyU3h4Skxq?=
 =?utf-8?B?d0RTSURTVko0Vkgvc1dlV2R6dGxsbEdNQTltSFZSOUpDK2MxMUVERGpKUkdj?=
 =?utf-8?B?Sm9mK0JmYytjMW0xQS8wYVA5TDJOeHFnVCtTTmo0OXFyQkdld2JuZHVTczdj?=
 =?utf-8?B?ZEViY0JBVEViZXVucklhQUVFVW56Zjk5TVZmdmRhQjkvbFhpaGIyZW9hSHlU?=
 =?utf-8?B?UGcrY0RKK1NWa2RVS2hpK3RXK1pEQ0xVQ08vMmlnTUtLaGdSRmg1YllnSTNH?=
 =?utf-8?B?a0VEV0NaK21wYW4xS0c0Z0ZzNWlkQU5vSUU1YWhjeW81OUhmRWhCalJiWkxi?=
 =?utf-8?B?OS9LV01EOVZWQWdOQ3BBZnVIakw3cXhkL3hzY1Zka1dOdCtjTi82M3Y0b2M4?=
 =?utf-8?B?Qk1DTGxKV0lIejdRejArVHBwcDF2VnN3T0ozZlN0RWZKNnU5UytRaGc1QnJL?=
 =?utf-8?B?OXpyeXROd0IrRXp3WWpTN1kyUmNrU2tvMHRXOGdZbktNY3N1SEZmRy9PbjVh?=
 =?utf-8?B?blhWWkc5V01PU05Heis2RGd2U2dSVVVKWi81WGMzWnN6N21YY3E5bmxqL2ph?=
 =?utf-8?B?S2VpWm5OeVJNbUpXdUFST0VxaUpQUzdqWk9WSWpwMmc1cUFSV2Vvd1d6SHMv?=
 =?utf-8?B?U05LZkxDSHVJS1NJeFQxQU5TbzQ0TGFsNXBBQ0t4SHZxNEkxVHQ0ckw4QjYy?=
 =?utf-8?B?Q2dRcVRTUVRFZ3F4Z1h3NXZFRG1TQk94NGdiOEZpZEhMei9rM2hrVTBRT2Y3?=
 =?utf-8?B?MzlWS3JPSndna01SZUNIVDBBUlgybnRYaWFnd3FoS2FKcG0wc25JNmJXR0lM?=
 =?utf-8?B?NFNuOVRFS1JGeEV5dW9QSlhnRlZWQ1dFbWN5NUNsY1dwNHYyd2Y1L0xBVEhk?=
 =?utf-8?B?UDdTd0tyWlJWYkpPQ0pUandwOEJBPT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a364bdd-af96-4363-cd32-08da01500ec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 22:07:38.2395 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUM0prCgr7LXXJ5ffJ+YbwKYq3VQH+1X7BNC5Sl2UQvZRoVVe8ZuGiXfTl/uGw1tEVrfPGD0gmwjdUGDN19FFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1446
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 09 Mar 2022 06:56:58 +0000
Subject: Re: [dm-devel] [PATCH 1/5] btrfs: simplify ->flush_bio handling
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
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Mike Snitzer <snitzer@redhat.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
 David Sterba <dsterba@suse.com>, Phillip Lougher <phillip@squashfs.org.uk>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A1D4ED73BE2BD1418E9C638FB9C1AB95@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/7/22 22:15, Christoph Hellwig wrote:
> Use and embedded bios that is initialized when used instead of
> bio_kmalloc plus bio_reset.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Sterba <dsterba@suse.com>
> ---



Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

