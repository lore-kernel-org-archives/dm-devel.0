Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A2D0C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 05:51:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-qWR5EjRuO3aEXka6dCVkeQ-1; Mon, 07 Mar 2022 00:51:49 -0500
X-MC-Unique: qWR5EjRuO3aEXka6dCVkeQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BD8A3803506;
	Mon,  7 Mar 2022 05:51:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D01134B6134;
	Mon,  7 Mar 2022 05:51:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 887501931BF7;
	Mon,  7 Mar 2022 05:51:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 57D57194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 03:06:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4889840D282B; Mon,  7 Mar 2022 03:06:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 437E240D2828
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:06:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1072080029D
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:06:21 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-ricy1QwwNqmRtU8jnl9rGg-1; Sun, 06 Mar 2022 22:06:19 -0500
X-MC-Unique: ricy1QwwNqmRtU8jnl9rGg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:06:16 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:06:16 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 07/10] raid1: stop using bio_devname
Thread-Index: AQHYL/HtKtbBwweIHEqS3x4/5TG2+KyzQLoA
Date: Mon, 7 Mar 2022 03:06:16 +0000
Message-ID: <6b21fd51-632b-3026-464a-9c0fd91c2bbb@nvidia.com>
References: <20220304180105.409765-1-hch@lst.de>
 <20220304180105.409765-8-hch@lst.de>
In-Reply-To: <20220304180105.409765-8-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cf33e3f-00b9-426f-e2a9-08d9ffe77240
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB18531256C15CBAE6B4EFFF5FA3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: TC+EMY6znUDU0omDhvUt7cdqBB5+bvSQH52jLGUwEp2HpAnA5GphtBJs08PWGc23HT4SDpowYEJtoKepuwRt7z39c5I9mBThsqwlos24LVd2ksFzQDNR0sxCBlIGyijLWZXFzMSAmbK0n8HwdTJ04sL6lTOLqAaaDMHbrX9R5aIlHwg0oxgOt+SVoKodTcEejCUyYFbYt64Tmvy2Q31Xj9384dBvYsQ5pny3Y/YOARsp4f9AUkEsLNTQ692EZc2WYcQWJyVCKME8eoWk/ze3Gau0Nv0f9Lajp+0wL4XspBUuIMyjIkzq+IL4wrFwT6JKNX15t9hHR5lsFx3CYJ4wSOMirCC0ppdi0dAK3/xBMro7OqBtc7IwSqId+9kaXMC/ZSPdXRRRoj3nfOleUMcX7gk6880xwmBTKlD9cKJm/0sPjTdVLOP5bCV9uRuo09tD+IPlCVKkz/7W7Qy4/TWrcQrgmEVDDuTvsvKc8KKm+MK9Mh+kHSqb0o5Ka8fPhkMqwmmTAu+DMnSVFn3CA4ScX2xjV2aPdd3WjfxkyeiGrGNafvEJ78ROxLl3gW3daZZS+p2UIm9i/J6eCTGTvqvXrrp919+u9b+iNjlZDAsEWi88ykD3/cS6CbYM3S7ZKOAtnRWUyQrBBi4G3PJyAKmeFdkb25/rOI6DAx71F6szDXlBJE9ImGE+/re5dd6lwxrAyOLV/fKbGjXO8em4G2UdqNNujCGkronEqRA7MmbJkE4kxGj4ZCNIunh6x3D+Gvk8LJlVhXCgJP6CQlF01fybDA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(186003)(5660300002)(36756003)(110136005)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(558084003)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFRvbUtzR0VMdnNZZDdaNG5kNWRmempzTU45d2g4cDZTazFSOWZPdEZrbEgr?=
 =?utf-8?B?YUwvdlhpQm4wWHF2aFhTYVVJYVEyaHdWME1JQVdJVUxpYnM1Q0Q0ajBCcEta?=
 =?utf-8?B?QTRHUjlFL2VaUFRYTEN0ZEVhVmQ3RHRpWWlqRlpvUDVzS2x6ZWhaSDh6czBC?=
 =?utf-8?B?ZXdvdElxaGJyRFhYa2d1Y01pOXdXeFhMTS9qSUNTc3MzUmdXa2EwMDArTFFl?=
 =?utf-8?B?aHdsMkxoN2pCbHBQOTBqVmdKeDZGTllvZktCM0dPei9kUk5vbFIxaUdZL21a?=
 =?utf-8?B?SHcxaGtvZFJoMmowUlRQWEV0S21yZCt2TGphMlVxb043QkhWbHZvY1FjdU9o?=
 =?utf-8?B?NDJzaXE3MVltL215Tjl6VDBWNnhRRWpUZVd3RjllWGp5QU5Bakg2ZHJ0NkV4?=
 =?utf-8?B?aGJtUFJrKzNiQ0ZicVYyQUMxUzJURHJEajlZc2g4ZWhNa1BvRU5HeHBvT2xp?=
 =?utf-8?B?OTlSSHlnaTlObzVjOEp3Q0RDZTJPOWRrMmZrVjhLNTNtRGl6aWQ1MUVUR2Vy?=
 =?utf-8?B?c2lZNTFNd2w0K2lGZlI0UmcwbEZ1QmVjNVpxdUZJdFVhdk5zVi9YQmdhT28w?=
 =?utf-8?B?YmhaRDZvdjRrN016Y1RxSE8wdjlDSHNKUlYrd0JkQ2JQSHd6Wit0cVBJNWtK?=
 =?utf-8?B?bGpaa2M5YTlRWFZLUVkzK3VDZytNajBhRElhd2l6ZDZsejFSMUcxS3hMYy9y?=
 =?utf-8?B?cmplOTNHT2c3b0ZQWW04SFFmMzdpOURRb3JnRC9tVHI2UGNydndKc0U4QStY?=
 =?utf-8?B?R3ZySGNVTkt5TDFqMlRUNy9DRmFlNUxYNUxCTEdVeURRMmN1cmFzUE1SMGdw?=
 =?utf-8?B?OFhETksyRGloVUdwTmk4eWI3cTlaa0c1YkhWelNYMDJlbXV3NzRxUzBjUUl6?=
 =?utf-8?B?SHU5a1gzZTI1cUE5QWd0SnpENnpyeWZwM1FVdGlmN1p5UWVybUJnYWtDOWdG?=
 =?utf-8?B?WDByS1pyUHd4ZFI1R21JcHFJS05Vc0krd2Y0dHcyV0VUSTBoeGdWN1paS215?=
 =?utf-8?B?bFRYNnloVzU5R0xrdkFpZ3NZMzdObXQybE9SWWxYbHVwekN5VXBrMXFwa0k2?=
 =?utf-8?B?SjVaeThJT2c1RWx3UE9yYSs4M3dmSHJSVlBHeEFBUk15ZCt1YWd5WmRZNTFu?=
 =?utf-8?B?dy8vUnhQZ1lURHRSdGhoZzRLQ3hMKzUra1VjWGRLK2tnOCtTdVU1SVQzLzFV?=
 =?utf-8?B?YjRMLzBvVXU1ZVM3WjQxU3FFT0Z2RkFOc3llbmhDOHR1MWJHbXY3MEFWMEZ0?=
 =?utf-8?B?MjU4dlpOMzhyVzhXdkN6Y3NBcHlCUkE2bHY0MHNBM21vaUo4bGRpdStzdWMr?=
 =?utf-8?B?T2J2VHliTFlnbVc3MVErKzFuMEdrWE8rdklFQTlkdXNRZjQzbzRNMGE0b0w5?=
 =?utf-8?B?ODY0N3U3VlRsS0o4NGNoc3J6aDJQbjIzVHVBQ1JTMTc3cm9NK2J2VGNLMTY5?=
 =?utf-8?B?eVFYa0lpbGNIRHRBY1FGbzZmcnBSaThzL2Fhd0ViTU8xZHRLaCthdUg5Yklm?=
 =?utf-8?B?b01DdmVZenBoMHpUR3dCMFFiS1Z3V29WRHRYRGZQNE4yOXg2ZC9ZUllLdjBJ?=
 =?utf-8?B?eHVtMmJOTksvb3kwMFd1SVZ6R2cvREFPekk3cUh4U1lNRzEzQ3k4ODcrZjJF?=
 =?utf-8?B?Yy8xdlJtTmR6U2VESjU4R3o2UDVNVDZ2VWVDY0t1a1djYnAwV2FiMllTV00r?=
 =?utf-8?B?TzBkd2dQelVicDdUenppaG1aTTVrbmF0VUpLQ1E5WXk1R2dRRklPWVlmSHBl?=
 =?utf-8?B?eXU5QlZacmZJRnN3eDNtQkU1V0Q2alc4MzJoVVA5UXE5UVBxQ3RZSjB1WDRX?=
 =?utf-8?B?NFFVejZFTnRiUEIvK1hqbjhMTGxUSHp6RU5GbnFDMXZEQytOYnB5UEc0S1NK?=
 =?utf-8?B?V0d6dVNvdEw2Tnk5QmxuMDN5L2xpZ1dyVkdaRVpjaUp5blV4Z2ZNRTRLTURh?=
 =?utf-8?B?ZTRiWUFYMFhXWjQ5NjErRmFvNU1wQS9sQzhkeHFMZXkvMWNjTUwrVStwaXNj?=
 =?utf-8?B?RWNIT0Z4UDJiQXpCWlJwNlBSYWFVSGMzSEh1SmFDV1NzZDZXL2p1RTZNVEpV?=
 =?utf-8?B?VHp5amhNVmZuNXlTdWZ0SEZtNk9kSGJ6T0NYY20xU0xmbkRtZDZSZjd6Mmg2?=
 =?utf-8?B?VldVbGk3SjVsS0c2akl0YUxSbUpUenY5U0FGTDdXSmdzMmh0cC9GdTNWWEEz?=
 =?utf-8?B?ekRheGFpM1J3QS9rbUNJUlJ1OXF5elUvMnZublJjVU5RS05Hek1nRms3Mjg5?=
 =?utf-8?B?NkVzMVJ5eHlVTEVKMnBxbk9mc1h3PT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf33e3f-00b9-426f-e2a9-08d9ffe77240
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:06:16.7769 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aBZN4LMp+GaEovagHOKEAu9yFu/i7HIdBWGKBZXtJLt2VV6WVeIEnFYz0vCeCL8uiQbixCe+zI8uf9b4b5lcdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mailman-Approved-At: Mon, 07 Mar 2022 05:51:41 +0000
Subject: Re: [dm-devel] [PATCH 07/10] raid1: stop using bio_devname
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
Content-ID: <FB0457C095F05A41961B52361F4EB1D1@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/22 10:01, Christoph Hellwig wrote:
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

