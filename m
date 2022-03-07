Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A869C4321E
	for <dm-devel@archiver.kernel.org>; Mon,  7 Mar 2022 05:51:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-2aIW4NgEOR2VJBWOeKtPOw-1; Mon, 07 Mar 2022 00:51:50 -0500
X-MC-Unique: 2aIW4NgEOR2VJBWOeKtPOw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E0E143C17B4A;
	Mon,  7 Mar 2022 05:51:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CBAC3468A7B;
	Mon,  7 Mar 2022 05:51:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9E0211954D40;
	Mon,  7 Mar 2022 05:51:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EFC53194E021
 for <dm-devel@listman.corp.redhat.com>; Mon,  7 Mar 2022 03:05:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E179C07F5D; Mon,  7 Mar 2022 03:05:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 98AB4C07F42
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:05:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F11D80029D
 for <dm-devel@redhat.com>; Mon,  7 Mar 2022 03:05:53 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-EqC0qThdMBKiMlb0ZDu8Bg-1; Sun, 06 Mar 2022 22:05:51 -0500
X-MC-Unique: EqC0qThdMBKiMlb0ZDu8Bg-1
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1853.namprd12.prod.outlook.com (2603:10b6:300:113::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 03:05:49 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 03:05:49 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH 02/10] block: remove handle_bad_sector
Thread-Index: AQHYL/HgPlcxA3zDfkeXQzCsCptEfayzQJkA
Date: Mon, 7 Mar 2022 03:05:49 +0000
Message-ID: <5506e564-d76a-8600-cce6-4e1ac134be5d@nvidia.com>
References: <20220304180105.409765-1-hch@lst.de>
 <20220304180105.409765-3-hch@lst.de>
In-Reply-To: <20220304180105.409765-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8a33a6e-911a-404e-5b30-08d9ffe761c0
x-ms-traffictypediagnostic: MWHPR12MB1853:EE_
x-microsoft-antispam-prvs: <MWHPR12MB185370E74DA90C0F7EDE3B6FA3089@MWHPR12MB1853.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: O5HLv9Ln20fvI90fM8nFySU90/bHnxaWYskmhZbW6topCpn7cGcw0O0lnXUqddB/1XIq+j3UFk3cy3OY86sOlyzEZi6o6JtDZ3/OzE6WNH4eFvJcWVl98/36V+mcoPCa5hVnKJXdnet2j6SJ0TN0liJYo43x9ZmTpfvF8VTx2gMksaUESqUHccHNivrZsq7EeJ0yyyt7+n+GYN/dRKm687UHaKtqkP1idZUXQ3ljWVWQJalsuWihZMGIIOhcv8aBU9exyq+5AL1wTn63E5oLfWq8VpzwphAXB6Xf+RJ4Gy4jgws4TWBDCTmGEcmveF7SGlmFqi7EiBRoRRfcKieyhVAJ/f5zrRQFIxK+TunAKw0GhrhvARR9+0mZmNwAPJQ3otURBvfbq53E8KnEefyeZYFnvzh2H8+pShqhKWv+o/+xvg6qbAca49zkRWt3dPWGXDOwwFcP1FNhkO1egKxE3/5b7IuzyWqWnUsnKdBgfwBpioYVHDpoL3qHiMkw+hBwjkggS2L183mLZKbQwtqkmKOFQbTl6FlwK9iHvCdj612ihmCSusP4iqNWpnifwZms6xc8Sdz2hSDXAjyQEA5HvFMNAPk1Aq23NwwxlC049fv678us+iYl5GFmo6vox1dSMFEZ7Lnq7vY8faUGHvJAhup17t7GGYp29qhuRDynrCqXsUzDzl0hTMndPyOvGDBVMTpaxpIKa9arxs+2VeQ5tfM/VCJwH2Pzk6wD1a/2Ph0L9uhjawFkB4WifbDkSfwx0amhKVHXbQoGmJuww/GFkw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:MW2PR12MB4667.namprd12.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(31686004)(53546011)(66476007)(66946007)(64756008)(66446008)(8676002)(54906003)(6916009)(186003)(5660300002)(36756003)(31696002)(6486002)(86362001)(122000001)(2906002)(71200400001)(2616005)(6506007)(6512007)(508600001)(558084003)(76116006)(38070700005)(316002)(91956017)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWxhV0h3clRhaVMyRnJqQTVaUzV5eTlBSzhvbEZ1VkJub2hUazljY25UTWcz?=
 =?utf-8?B?MVdLR0pIUHNaMzloZkRRK0s1L1lPZU00Vm9rMDRKMW9iVlpXeFFBdDZaQUJ6?=
 =?utf-8?B?SjRtWkhuM2RtajJhN2ZzZ3QxWjlaN0FtWW9jd2tSNUQvTHkyeU5VWUNwakJK?=
 =?utf-8?B?YUI1VEVITzQ3bEJTZ0t1a2tZeEh5bDNNcFYycmhDV1hoMzFIVHpESXhmVFZs?=
 =?utf-8?B?WTFBRzZFQk1DM2pISTg1VVpWdElCT1V2d0UwRmozcEZERzhJSW9EZ09xV3lY?=
 =?utf-8?B?amhSazVEWnBhSk5nb29JSEJ1bVZ0ZFA2dCtYakpWYkN4QmI4UGJXYnZ1VGN3?=
 =?utf-8?B?TjFPOUhoYjU5M3QwMVFwdEZYOVA0eUFVVGJlNVkvTHl4aktHL3l1VDNlS1FW?=
 =?utf-8?B?TWxmTFRBMjAybk9HZFEyZ2dhSVBlU1RMQ2g2Mm9Fb0FuQXVlRkYwejc0T0dZ?=
 =?utf-8?B?UEU5dnYzTEtXTzlmOHpDampzWUs3MmJjREU1b2VhdGkwcmZnY0xUbjB4blA1?=
 =?utf-8?B?V3RjWkhuWmxSOWtrOWJNQktDNFJPRzRhdFhTNkd6NVduY0lLdFdVSUduRDRw?=
 =?utf-8?B?SzVXTnZNNjZ1M0tQNjA2RlB2QWhsWWdPZDVWNWZ2RGtRRXRIRWF2WDFnY1Bi?=
 =?utf-8?B?NnFxbDdtRWtSOTgrTWsvV3UzTGpwYk5ZTDhZVzdkSERPT3NDRFVrZnpHc24x?=
 =?utf-8?B?RkZEeVFxMlBaMDIvbHZsNlZ6OWptMDhVOVFZSDI3d2RHK1pOcTNkbUo1ZEFz?=
 =?utf-8?B?VW05Yk8reTRvT3M5WURKUy9aQThBTTA0SFYyQnprRCt5UWkwNFUvaE1FSzFV?=
 =?utf-8?B?SkNmSXE0QmJaR2Y4YlE0WE5rY2N2NjJGZURoWGZSM2xoc3dLQ0d6Ty9LNUh5?=
 =?utf-8?B?dzVtOSt0RS9pdTc3WXQvK2V3cWJ5OWcrbDN5eFl6bzRHbGtZOERJbEdGSVF0?=
 =?utf-8?B?bStLOGZiQ2JyZndUU0V6cXE1bzlsSy9GN1ZYdUowK2s0cE90M2RvRGg3YkIv?=
 =?utf-8?B?Um9aZDQ3VjI1aHhoYU0wZlNGdnFPR1ovVlcySE5vLzZhVStCNy9xQTlMWm5Q?=
 =?utf-8?B?QTBQVmNsbHdsZEpId09zZ3BLR2JPOVRwZ0t0RjI0NEY5ZWlaSHV4QmNUeDlD?=
 =?utf-8?B?b0NRNG82U1hPZHd3ZEZReCs2dzRUSEM1SVBqZ2I4czk0cFhlNDFPWW0weE5R?=
 =?utf-8?B?T1ArMk5xQ3p2OFQvdjd5NmRiM2doVE8zeHdpcEVQRTlVWG5aYlFFeGtHY3lR?=
 =?utf-8?B?dTRGRlVNVUZ2VzRqRUhBS2dRNFJDRjV3TWlZeXQ2YU12QjZuUUhhL0ZrRHNB?=
 =?utf-8?B?YjdpSkw2cS9NanBLM0cwZUZ5dVVFL2lUR3ZRZVluNXFSRDFoQjZPc3pHRVlh?=
 =?utf-8?B?aXZ6c0txNXhQWlIrZXREUVF1UXZCMThVZGpTZCtna21Xa1Y0SWt0Qnc2Q0hD?=
 =?utf-8?B?b3R5TmRFemV2UzhJK1dYM3NaclIxa041eVZKeEJ4MnVDbVVCV01MblhRZ1Rw?=
 =?utf-8?B?YXRkaGt3Y3VmMnJhaENHOWpEaFIxamtSL2x3Z1B6c1ZmYmlHSElNL2QxVGln?=
 =?utf-8?B?MUs3b1UxRjdUREgxQlpaQlBXUjdUdzZadWVCSUd4Z1FyVHpUeHNEV2hWaWF5?=
 =?utf-8?B?MzVISVB4ckVER2pRWGhNY3FpOEszS2hydWRwQUNGa090a05BNjluR3U3eTgx?=
 =?utf-8?B?Y1J2MGUwZmlYNGlNSDJZV2pWbGNLV2N5cUh6SWxFTlM2cUI5THNOdHpJUmZj?=
 =?utf-8?B?S0pYeTkvNVVyQ1NNYkx1d2x5eGhxZDBsQnptRHA5TXBpeWpDbjhDMHNZZFdw?=
 =?utf-8?B?akVpRXRJM3Y3ZWJ6MXR0aHR1MjBvTmlHdDNGeEVscnd6YVV3QWx4cE9ISmF4?=
 =?utf-8?B?emxmS0ZTSjBFdkErQWY2enU1M0NJVVJCMitoVm55clZmMHp2bmRSeTV4Y2Qr?=
 =?utf-8?B?MHp6QmFmZms2Q0NJdnQ4SEh0Wm11ZDJLWHJQeXAwK0xzdHdLVUpHZUtOdTFy?=
 =?utf-8?B?Mnl1ZmF1VUtuQTFPTHVJVnB2b3cvbVZocW9acExUVmxTNG9UcXc1ckhQODZ6?=
 =?utf-8?B?dlhscjQxb0I3cFdzTVU0VUNMWnRQSHFlWjdmNDU1bytMR3p2VnVXS2tMTDRv?=
 =?utf-8?B?L0JzRjZnbm50M09ZNVNPU2xUSkpjOGh6MlcxcXpoaTBTb3pVTmhwT2xDZ3JR?=
 =?utf-8?B?bDh5QmVmNGRCR05NbFpLNDM3UFl6TEV4U0F6ZGFjTEdFSjU5RDdabTlQaE5F?=
 =?utf-8?B?RUlWMEZwRndVM3laaTdXMDdyS2NRPT0=?=
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a33a6e-911a-404e-5b30-08d9ffe761c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2022 03:05:49.0910 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xUMxigpQb8tgK/iP3L+XINX0BvEtxX99fyJhz7IyZ4c9z5VvcdWdBad2egTBwILKkri9U0qzNPnaHO3uHBuXUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1853
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Mon, 07 Mar 2022 05:51:41 +0000
Subject: Re: [dm-devel] [PATCH 02/10] block: remove handle_bad_sector
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
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
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
Content-ID: <57EF8EF630B9AE4E8692AC6B46C73138@namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/4/22 10:00, Christoph Hellwig wrote:
> Use the %pg format specifier instead of the stack hungry bdevname
> function, and remove handle_bad_sector given that it is not pointless.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---


Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

