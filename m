Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDDEDC43219
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 05:51:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-1DMfTs9AMVGzVQ2lFHsOyw-1; Mon, 07 Mar 2022 00:51:49 -0500
X-MC-Unique: 1DMfTs9AMVGzVQ2lFHsOyw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C35C3899ECF;
	Mon,  7 Mar 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AD34D4B613B;
	Mon,  7 Mar 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 550FA1954D53;
	Mon,  7 Mar 2022 05:51:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13685194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 03:07:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E77312166B3F; Mon,  7 Mar 2022 03:07:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E17112166B2D
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:07:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DD5285A5A8
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:07:16 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-CXTEFi7ENt2IA7KVk_VvdQ-1; Sun, 06 Mar 2022 22:07:14 -0500
X-MC-Unique: CXTEFi7ENt2IA7KVk_VvdQ-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:07:12 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:07:12 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 04/10] dm-crypt: stop using bio_devname
Thread-Index: AQHYL/Hg7vmeF37UxkSFxnATAL00G6yzQP0A
Date: Mon, 7 Mar 2022 03:07:12 +0000
Message-ID: <34c280c3-6597-721c-5e12-a1f55cab121d@nvidia.com>
References: <20220304180105.409765-1-hch@lst.de>
 <20220304180105.409765-5-hch@lst.de>
In-Reply-To: <20220304180105.409765-5-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9974429e-a261-439a-dabc-08d9ffe7936c
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB18536C072C094E7BC8BDF9ACA3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: RistBQz4QDikRY5anYkn/Wmuxyjx9SPg1mN+WSXqzsKswApcUmhsux9VS7zpenhBCJvM0jVSsSHSQKP2qnzVMmpLOFU4aDKiGg1qC93EfnGh0MlkogGu3hVUFVrfFD+lgdr1k0MddeXqdMtOx0zhG3kmdyAUnOrEVPAjRZTEwumTOlN6wuKhsa3d9Rt/vNRfpOSj7mlrLGzUB5gebsAMN3IoJWzNJKzOWr/+beUeIWtP8SDXIupEieKyadXV3Uc0o2QF7aJKsohqIrBK4vb5FdBmZcU5OWi1W0x21dt3KdAnjD7HiFhMa06NnHyka34/UQ6391a3PcVc7dpPzjcaKY3za4asZJPnkiBDjp/ct8F2sIM6rFOZKdyV7S5gMJJ8T1710ibpjR48Zla56XTeLLAeO5rEghlknR/4z1O37XoVWahx/iNj0JZkt7vXCocgcRS5CnQAHcpmv9pYDvTjUVwJGtuNC9EEQRzMgLId7pGNd8We48413RbcaXPzfgwyGmCGTQ4z6nPdDxgSQh3/8EtVS125DFmVMSOQE6CE2w8aixANbE0GBmnrRvpOsIPNb5mFGsHSTPI+YLi0nZbbQdkjQ2LWlR/CHYWmpD9mFVyp88JPRT7RM1dyzVX8wIxvwvD5njgwE946dPPeapHrn6Mla5L7rOFr1drV2JD5Khs2xoeP6GHsJtvFy2G111uJzDIc6oJ0gvJVcz/qq4hpcwhTOwY3Xk0/XYfgp3e/dc1mnxaJeH/wHXDB7HhW/1tq6cHdF76coZTnNMx46b7OSw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(186003)(5660300002)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(558084003)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjNlUVFKaTVQbkJrOWdHK1NDVmJFSDNOc0JHK1c1T2dZZXJNZnliNGQ4OFVJ?=
 =?utf-8?B?b1RtNitGTGlWZXJJZkFWYVdvOG5wVTF2WktoYlJBMEN4aUl3YWV5NUlZdFZD?=
 =?utf-8?B?eUc0M29tdWUwdlp5QU9uQTgxVDk1UXV1TzJURmdkLzRqUUxXWUk3Y1R0NnQr?=
 =?utf-8?B?blVsU2xBZ1NBTG1BNDAyVVFBelV3WGF1Z0xrVk0rMVdxdlB1b2JLOXR3Wmc3?=
 =?utf-8?B?R3c4SHRuS2JUbDBod1BBM3dsb3NOTFAwZGVHcmR5UXVNaC93eVltaDQrVE9n?=
 =?utf-8?B?UjUzUTlmMUc0ZUNnZndXRC8vUWVHVkdQNnhqTnlSWHExZGtzR3VTWUFsZ1FZ?=
 =?utf-8?B?aW4vN2J0Sk1RbDZwVGsyVEIwOEJ0ODFEVXJXVFJIcE92R2xodDB0OGtEL2Yy?=
 =?utf-8?B?R1NqTUhkMlA4TEJ1M0ZhMTBFaS82TU4rSFpjM3lpcCtwNzM0cFVGWFcrWDdU?=
 =?utf-8?B?Zmo1VEpGR0JGMS9QckJnaE84N0ttTzRLL3krcytCbk5qTU15cmd0VmllV29T?=
 =?utf-8?B?MnJvTTNNM3dPTTlRTXBLQ01PUzVUNk53TjRPbk5RRUwrVGtWSFhxV3dVZzFO?=
 =?utf-8?B?SUVXcUNoSytURlNwVlFWYVh5ZFFnVXpuc0U2ZzVqMjhGdzQ2bmN0Z080dUdZ?=
 =?utf-8?B?SGQvYlRIY1BsbnZmYlVHWEF6NERUTVpELzF1QTc4aGE5cWNiUjREREVYYkxM?=
 =?utf-8?B?RHdLK2E2Z25WSHBDbURQaXdBVUpLK3F6aU1DcEgzZmZZWmNpNGsreDNsa0Nu?=
 =?utf-8?B?TDY0ajhTTWR6SUFtQkxvV1RKQllVVGtLUVZaQS8yZmRQazZwN05oNWdmSy91?=
 =?utf-8?B?Q0F2SFNKb0puQW50K0M1aHoyMTgrV1VYcllRZWpybTd1WGZkeXp0MTF2Nk5R?=
 =?utf-8?B?Um9xN2MrbzNveGd0WncyK2MydTVrSTU4bWNld0YzSHJ2U01TcnNocWQ3OW9h?=
 =?utf-8?B?UnVGZkRjN0FSbE1NbmlLV3lPTFQ1c2dnYjRtTlJvTG82VUVZQlJGbjZGdGpD?=
 =?utf-8?B?OWJVenFueGk4TlIzTEhHVGtHY2UrZXlCY3owYWdVTm11YWtOVmNnOEx6MTdY?=
 =?utf-8?B?TWxPUXN5dmJ5UExYdXh4USsyRkNxVE9XUFJYQklaQWI2YjNZM3NrZERMM0Fv?=
 =?utf-8?B?d2NhS2N3L1A2ZGhScWZzNk9GMmx0S1JrZ2lHdXd6YjZBTTRyUHN2OC9Kall6?=
 =?utf-8?B?RjByY05aazd3bWlLeDl5WDdQNkF3VmhYZFRnc1I4bDZnQ3R1aEg1Nzg3bHFN?=
 =?utf-8?B?eWVLUjBva0x6WU5zWkNRMEtIRG4wQnBIU2k5ZGJKQ283cy9DaHljdzRCNURL?=
 =?utf-8?B?SGQxTlZMMzI2dkRHN0dKM0xKQmY1QlF5MnI1V3cvczREVWFsOHg1SFNERXBN?=
 =?utf-8?B?RThpekZxcEtwamNjRWkxcE9ERXpNTkQvSGpuMy92RUhDRFpRWldXcGtSLytQ?=
 =?utf-8?B?MVBDZS9KbnNhR3FpSE5OaHpOL0VsZTd0bXVMdUY3dWJwMFE2WGhmRUdYcVNh?=
 =?utf-8?B?TU91Q0VoVnZhNTZxRkd6QlZHOWVZMVE0cXYzMDlMcTl6NjhrVXRuVHh3WkV2?=
 =?utf-8?B?NnRsS01KZlA0OGdjK0ZwdDlBRXFnd2VjeVdmeTFFT2pYQ2w1QXpXaWFOdXNh?=
 =?utf-8?B?K0FCZE9WYnk0Y0JHMm9DMWFibkwyd29YVnlqSldmSERmUUsyR3lwM2NOU3Zx?=
 =?utf-8?B?MEtNWis3SWVHMFFXbDFEcjRiTk1YMjJpWXV4dXJUNG9ORU94VFovcUN6b3BB?=
 =?utf-8?B?TUF0a0JsVnZ2N1ljRXJrRnpHT2ZueFN5QlFEbVovZ1p1UEtmVXp0Wk1oY3No?=
 =?utf-8?B?eG9DSStDaUtlT3ZvcFV5b2lMQWI2Rm9SaDh5R1MxbW5jSkNXbE1Nbk9JUDVj?=
 =?utf-8?B?ZXU3MFpVWXNGcnJuMjgwSkJaTVZPbEpMUGN0ZzNGR3BTM29yOHlXUjlSWnQ3?=
 =?utf-8?B?YndnUWJsU3JPbW56WFZYMG5IaFZQZzdWWDhWUVN0clRHT1dUT1lkMDBKWTdl?=
 =?utf-8?B?ZGp6SllMTzNZL0hvMFZGRHZSQ3k5UXRrNndtK0h4QzVDWVVTS2w4cjh0am5z?=
 =?utf-8?B?eGF0aUFXT1dMUFc5a0poenorQXhhMWNQZHJyVHBvWnZWTG14aVh0WXBvUm1t?=
 =?utf-8?B?OEJQMnA2MERJUGVIL28rMnIwYUpEUkdGaTU3dDVFUWZLL1NCWVE1bmsyRVFr?=
 =?utf-8?B?TnJzYWpjRTkrd3RXdjBaUG0xYmNGSUl3Q0pCUFNaUHNZZU5qN3ZMRUJsdWV2?=
 =?utf-8?B?bU12K1U0VlFsaUR6Q0hYUXFVOE5RPT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9974429e-a261-439a-dabc-08d9ffe7936c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:07:12.4142 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZfXPpKpkAVbsgmI03HAMQgQcsdUrkWtL084egDW/HmIx/FshVtqF+r6mpfUy8aBc1kPAbsJc2yca/R24GtgeQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Mon, 07 Mar 2022 05:51:41 +0000
Subject: Re: [dm-devel] [PATCH 04/10] dm-crypt: stop using bio_devname
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
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 Theodore Ts'o <tytso@mit.edu>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Song Liu <song@kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2B724D51AB11E94B985D3DC338073B51@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/22 10:00, Christoph Hellwig wrote:
> Use the %pg format specifier to save on stack consuption and code size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

