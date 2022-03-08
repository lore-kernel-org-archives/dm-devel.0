Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB1C2C4332F
	for <dm-devel@archiver.kernel.org>; Wed,  9 Mar 2022 06:57:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-mYu5Emv_NouIPmyTjvS6yg-1; Wed, 09 Mar 2022 01:57:04 -0500
X-MC-Unique: mYu5Emv_NouIPmyTjvS6yg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3C823800E85;
	Wed,  9 Mar 2022 06:57:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A6EA5C080A9;
	Wed,  9 Mar 2022 06:57:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5EE921932105;
	Wed,  9 Mar 2022 06:57:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 54123194F4AE
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Mar 2022 22:10:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 31B43463ED4; Tue,  8 Mar 2022 22:10:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C8C7463EA2
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 22:10:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 138943C02B80
 for <dm-devel@redhat.com>; Tue,  8 Mar 2022 22:10:17 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-q0jfn6v4Me2zoDgiT299wg-1; Tue, 08 Mar 2022 17:10:13 -0500
X-MC-Unique: q0jfn6v4Me2zoDgiT299wg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MW3PR12MB4459.namprd12.prod.outlook.com (2603:10b6:303:56::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 22:10:08 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 22:10:08 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 5/5] pktcdvd: stop using bio_reset
Thread-Index: AQHYMrQYlKEyuRDbnkC2Ag8SGwunMay2DSIA
Date: Tue, 8 Mar 2022 22:10:08 +0000
Message-ID: <80cfcb91-6458-abd6-9f6b-b1bd7d7b7450@nvidia.com>
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-6-hch@lst.de>
In-Reply-To: <20220308061551.737853-6-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4223e0f-e720-4b76-d2e0-08da01506886
x-ms-traffictypediagnostic: MW3PR12MB4459:EE_
x-microsoft-antispam-prvs: <MW3PR12MB44590CA4E9DFE65B1B4A42AEA3099@MW3PR12MB4459.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: sp7MbifuXn0LBO6SsMMZmx8na1njCNLfNY7qWi09WW1YgNNW02UUFiPbvb+WEYf044Hjr014pWIb5HirXxUVbM9kc4JAQPJYQX7k0kiVaLXgiUSorHj7LwugzdxzugxtfNjfDGaHyaRFWiBpomtnCtszPmDXUPIAL16rX8tssIZzl0oxnmz75ojYVO3hBbJ+t8ml9OFnip8aTweMRaNzG1SP+rFh0zB+q8owv+IMlY+jcf+4hF+vP3VFAiGWR1EFR8ivHTLey7svZC/DzW1hhCn34Q7aO6Qgtqge+KqAtaXgeuKUBcKFaNH/RdkzC3HriEzunih5/SjqycJA5jE3i3I3U9c/cDG7ZaxWc2PJ2fjUsxY2r1uprywMDe50HHUG+NS9BgZdY0Iehizs/N9CV0k69ZDPKjQKfSc13cszxHeAYWZT2X1bHBGE1ekDzTVJV/2tdudY1N2UJxaw7om/LdoGfa8mihzKbsbuWnGvXy5BFMDamDuOVo9TAPZ+bdF72j+3JIGuPr5nLDqIynCQkH4h01h9NnZSxQa/QmZTUTfNgxIgcH5M2MDdpc9mvAlxbOUDQwrp3v36h5gnyLCFHEH73cXt3n1I6XS4uJ+NrYjooJJ04Vq45mI5NEOQBahmoWYt6FJYha1Urldq4xFfi3dMm+1dGsKjTJOp66gzn9sQgdnL10nrBQQ3aq55mTM9/BqzPfqVz/vxdIIelpVB/Aic6EDFieq0XvRXjrmqhJgCD4gkQpJXXL/EuJEbgPsDhuvtcaqRmbHNagVw7sU/Lu1alvrXEIdum9UELfqanl0=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(4326008)(66946007)(8936002)(26005)(53546011)(8676002)(64756008)(66446008)(66476007)(54906003)(7416002)(186003)(5660300002)(36756003)(31686004)(110136005)(31696002)(2616005)(6486002)(122000001)(71200400001)(86362001)(2906002)(6512007)(6506007)(558084003)(76116006)(508600001)(38070700005)(316002)(38100700002)(91956017)(133343001)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFBBYjR4Z0hKUjdnYVZDQzY0VEMwNVgzT1UvUDViMzZoRjZ6bXExTituRU5a?=
 =?utf-8?B?SGZjbnphenkrRjI1SFNoMW12U1cwTmRFdlhURUIwbVFWYmplYlFUS2FVUE11?=
 =?utf-8?B?VVZQMGE4WW5rUGh2c1R1QmJtNllobVN6cmgvR3lIMWxweEIzRnlacnlqa09X?=
 =?utf-8?B?VThQK0plczVmYWlrY08yLzlLUUpjdXVQdGxKem11eEhoaVJ0YWlaejFxRzFH?=
 =?utf-8?B?Z0NybEZiRGdJR0JiNjFJNHVoa0ZEeTJPUG1LOEhiZ1JRcEFyeXh4UTBieXNx?=
 =?utf-8?B?ZFlRK2V4Y2JRT20rUUxHY1VZRExjanMrSEo3R1J0d0hqM1I4SzAyMVVuaUlB?=
 =?utf-8?B?N2ZHcUJkV3pjS1lDanNlVFk1WGczaFlqbHloNVhkY1FJclZVd0hhWEIyMzN4?=
 =?utf-8?B?c1h6aUJiOVVicHhWa3prTHdsSjRjeXZjaXVqWDJqcHFkOTVLZXNuUUdlZCsr?=
 =?utf-8?B?ZW5xczBGSzQ4eEZSUlFZbzA0Z04vZWJubG82SHZUaVlZcnBucldPQTBOK21x?=
 =?utf-8?B?MTNteXZrNmhmS1BVU2EvVjFQS0FyOFNQU0NJeitsYWdHeGl3Z0NSekZvcEhM?=
 =?utf-8?B?MlM5aVJpMURnS0pmeWwrcGZNYWxsT3hLbWUxNkNtYXpzWUhLSG9yYUIyUW1n?=
 =?utf-8?B?RzIvTDMzYVVTRHBkZWtOY1FoUGZ1eEQ4d2VwbTdQeC9GQ3pvYUU3L0J6NEIw?=
 =?utf-8?B?T2RqeTFwQzlGN2l0bllGQVhHU2NVdDRUcFpuV3BUKzQvUlBMakJ2eXowc04v?=
 =?utf-8?B?ZkNEQXZpcGtwZFFoRVFERHJRWWllSW1BYmRWNVBIOWFwZHJEandUYzhMY1Qw?=
 =?utf-8?B?c2hHa01zUmdsa2YwaHo0OUFONXltb0psYytjQ0MzTlcvcU9ENTRtNkRvVWhR?=
 =?utf-8?B?Y0dPaUxVY1JJQndSMnpXWWlrWDdDYSsvLzl0Y1FXMFRadTJxSzF2VHBsMFdF?=
 =?utf-8?B?SXVORHJYbis0S0RTOTNIcGlEUW45VFhoNzNmdktBTmVsOEhIZWM2WGhacW9n?=
 =?utf-8?B?cjZDM0dkWW9UaFdwQzZEY21JYW40dkRVbW5kWlplWUp4aWkyVUg5U1NnMmtJ?=
 =?utf-8?B?ME5YV3lMK09jWFZpZE1HWDFEOS91ZEpSczI0b0s3YTZ2Qk0ydzczUG43N0Nq?=
 =?utf-8?B?VVVzeGRDa2VtNFh5S1JCVFoyKzhqdTV6ajNVNGZaN0dpK2N3c2pqL2tvSDg1?=
 =?utf-8?B?VW5Lc0pRZXFFZElMMlpTOW9kbkRZMFVCbEt0NUFWbUcwK09pd2lBUncvOHJT?=
 =?utf-8?B?S2k3a2FqS3ZaRnNxT2phSG8razhYN2gwbnh3eFZIUzFiTTVqQXllS21QOXhh?=
 =?utf-8?B?M0ErbGl6bTJUR0VtQ2lvckZFdWptWWhpN3pHZ3ZxWkNnMVoxRThsTGFVUzZu?=
 =?utf-8?B?S04xK0lZT2RySHA2UmQ3dldET3FPMkVIWWVWUUxVZXM3Y2JnYWlRR2x0akVP?=
 =?utf-8?B?TFowdXp1SlRXdDl4YXBHZUFOaU5ENVlWOSs0aHZ6UFZnT1U3VURwMVhZLys2?=
 =?utf-8?B?MzRGU0RBRndJdytqRk5lRjhJMnNnK0pwU2ZpRW5jNVZJejVTR0ZwK1Q5NDU5?=
 =?utf-8?B?cjU2d05WS1h6YklNRklIQjdtNC9zZTdSYzREamlML3ZaeDYxOTdLS1hSVjVJ?=
 =?utf-8?B?OERYa1BybE9yK0RPMWYvZnJSU3ltK1QrRktuMDRESlF5NW1BWEJpdXZ6T1Rw?=
 =?utf-8?B?QTMwT0MvWlVlTE1ueGhPcEx5Ymh6Z2dKWmpJT0hLd1haSzErWUkwem0vQmN0?=
 =?utf-8?B?Ym5GbmFDLzhvN0IvcStzeWlUbEhpREx3YllCWlljWUpCM1pjR3lYM2lzZnls?=
 =?utf-8?B?dTIwYlhkM2cxd1ozMmd3S1VWdzc5aHVqbkxIcDhIRkNOV3cybzVJaTl0S0k2?=
 =?utf-8?B?SnJtdklWSno4ZkFqTi8vd0RRdVEzNEN3cTJwdFdFZ0ZnNUEzWEwwZTNQV3Ro?=
 =?utf-8?B?b0xpU2NyWktobldZdlZsblVkdC9ub3NRc08yQ1JkVm5Benltd0N3REJXNS9K?=
 =?utf-8?B?TnZnZk8wQ2FPODQrTzZtQ0JpMC9yTVNaS0lHZXRnYkFzWkhIUE5UNm1hM1ZF?=
 =?utf-8?B?eG9CdEtRSVZXRDduRkFzNVJXQldxZFpuYkdnbW9EZCtYTVoweEhWc3RQUDBh?=
 =?utf-8?B?TFU5d3V0MDFvTk5INzJRdWZwK1NSVG1mU29zdW1xQ1dtVHhxUkJkVXFwWkFF?=
 =?utf-8?B?bXc9PQ==?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4223e0f-e720-4b76-d2e0-08da01506886
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 22:10:08.7930 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUZFs5fNpKB9gENcSJW2X9skMpBqv8bTMMQxfi4WPf5SnNn903a8PrhRF3Y2PYWo+ozfZxvDE68lIh3yzUMmqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4459
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 09 Mar 2022 06:56:59 +0000
Subject: Re: [dm-devel] [PATCH 5/5] pktcdvd: stop using bio_reset
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
Content-ID: <16BAB11772054540B9496D6EF52D820B@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/7/22 22:15, Christoph Hellwig wrote:
> Just initialize the bios on-demand.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>



Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

