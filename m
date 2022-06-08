Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D936DC43334
	for <dm-devel@archiver.kernel.org>; Thu,  9 Jun 2022 07:22:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-_Hw7s4eZONi9FknpdZXyxg-1; Thu, 09 Jun 2022 03:22:08 -0400
X-MC-Unique: _Hw7s4eZONi9FknpdZXyxg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41D9D808788;
	Thu,  9 Jun 2022 07:22:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E34B2492C3B;
	Thu,  9 Jun 2022 07:22:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AE2DE1947B92;
	Thu,  9 Jun 2022 07:22:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5FCEC1947042
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Jun 2022 10:00:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4E34C1415100; Wed,  8 Jun 2022 10:00:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 48E5B1410DDB
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 10:00:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DAFA101E985
 for <dm-devel@redhat.com>; Wed,  8 Jun 2022 10:00:16 +0000 (UTC)
Received: from mx0b-00154904.pphosted.com (mx0b-00154904.pphosted.com
 [148.163.137.20]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-7P4NpCObMm6y9D3sinjxWQ-1; Wed, 08 Jun 2022 06:00:12 -0400
X-MC-Unique: 7P4NpCObMm6y9D3sinjxWQ-1
Received: from pps.filterd (m0170398.ppops.net [127.0.0.1])
 by mx0b-00154904.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25823Evo003807;
 Wed, 8 Jun 2022 04:28:03 -0400
Received: from mx0b-00154901.pphosted.com (mx0a-00154901.pphosted.com
 [67.231.149.39])
 by mx0b-00154904.pphosted.com (PPS) with ESMTPS id 3gg2m97w3b-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
 Wed, 08 Jun 2022 04:28:03 -0400
Received: from pps.filterd (m0090350.ppops.net [127.0.0.1])
 by mx0b-00154901.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2587cXMK002749;
 Wed, 8 Jun 2022 04:28:02 -0400
Received: from nam11-bn8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
 by mx0b-00154901.pphosted.com (PPS) with ESMTPS id 3gjnyyt1yk-1
 (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
 Wed, 08 Jun 2022 04:28:02 -0400
Received: from BY5PR19MB4034.namprd19.prod.outlook.com (2603:10b6:a03:22b::23)
 by BL0PR1901MB2068.namprd19.prod.outlook.com (2603:10b6:207:39::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 08:28:00 +0000
Received: from BY5PR19MB4034.namprd19.prod.outlook.com
 ([fe80::e0c1:212d:2a4e:886]) by BY5PR19MB4034.namprd19.prod.outlook.com
 ([fe80::e0c1:212d:2a4e:886%4]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 08:27:59 +0000
From: "Chen, Yanfei" <Vincent.Chen1@dell.com>
To: Martin Wilck <martin.wilck@suse.com>, "bmarzins@redhat.com"
 <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com"
 <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: unset detect_checker for clariion / Unity
 arrays
Thread-Index: AQHYesA/kMKSs32GwkaXYPBYQsGG+q1FJQKAgAAH9TA=
Date: Wed, 8 Jun 2022 08:27:59 +0000
Message-ID: <BY5PR19MB40348F0CD05D24206D7D623FC6A49@BY5PR19MB4034.namprd19.prod.outlook.com>
References: <1654641901-12324-1-git-send-email-bmarzins@redhat.com>
 <1675cd007bfee3f944c986e7e8a9eec8969487cd.camel@suse.com>
In-Reply-To: <1675cd007bfee3f944c986e7e8a9eec8969487cd.camel@suse.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ActionId=0ecdc7e1-f71c-4476-8ee1-7e9fba2173bf;
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_ContentBits=0;
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Enabled=true;
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Method=Standard;
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_Name=No
 Protection (Label Only) - Internal Use;
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SetDate=2022-06-08T08:24:55Z;
 MSIP_Label_73dd1fcc-24d7-4f55-9dc2-c1518f171327_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad103366-f7c5-4792-a060-08da4928cc1f
x-ms-traffictypediagnostic: BL0PR1901MB2068:EE_
x-microsoft-antispam-prvs: <BL0PR1901MB20681BCBFDDA95D9EAC32EC2C6A49@BL0PR1901MB2068.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: zoTbsF5G0PwJSCJS4YjNM6xhvm2aHLvywedP8qznj8pHImuCq+fN7XdUnP3EbGSp7ICZfLe5SQl+1x9DNpfza52W7NsWq4p+JcfMYqsbBOZbI69YVVKVOsNRPhGouqmkVaqOYvEOa3Fsoga+aMAS2/JbpYSLpJ7E+gEtSvDxauZPQdsPGsHbZNVjM0KEOrKIDZoKMTQ5RgLCz2pFnQcoPE2U7ZLMsdzb0YQ6Zwjn5pNMLPnJpiK64mkgYGUu4yCL61HqbGPBrtjiWlphO80qkIIge4SuT912P+37fOypZwSqo/mMvGq6v9UCSy98bSICFtfmctp4lE1x/0yzpfVFSxTtVr4asWzGXpp7vaD62LRRiqhL53xmwgD1NhCd6uMWmtJI/fKrA4VnKFtS/sw/VklxU5TDUjIXnzf19KcFW5mi07oZ0MD6tixPDY/a/Cl4lU8YqeWKTTNIsFOrsxSF4VodSlI37acyyJ4WrDFg4NQh4TQoq2GASZY+ZrdLxzAx6HNZ2jbiuGrkg9yzDEnNxM8yfIlWqPe9zttxELwfYhE/Hy3+Ij2cmNhXR7hDcsPEuqTDIXooZi5xSsp1iBKZWTr2yl6WJd1adLmfjRJIeAGNGTkUgYzB7uIrIcKgJ0cCEk0TJcV590WzJ7C7YvDstbiBNW52ZQOe5WdCrHatCtN3uR2K1lNBTYJKEWSAQe94lToQLgxgOSisdIE8vHJIvg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:BY5PR19MB4034.namprd19.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(26005)(76116006)(786003)(38070700005)(82960400001)(316002)(83380400001)(122000001)(86362001)(9686003)(508600001)(71200400001)(55016003)(8936002)(5660300002)(186003)(66476007)(52536014)(66556008)(2906002)(66446008)(38100700002)(8676002)(4326008)(110136005)(6506007)(64756008)(7696005)(66946007)(33656002)(53546011);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?S055ls+oYdPvJ+trWB/dQ4mvD3+D67jE6lvD4lfZlJ1+cacFeFE3/IoBHi?=
 =?iso-8859-1?Q?ka1iyrzX+QhY6WMRyeu4hidgN4WQgduoZRZX9R8pcHY12rC2P60KHhSW4Q?=
 =?iso-8859-1?Q?i2QCa2g6CZ+FqDDVtbAliCcWYdbI4yK8xFPBAKa4oZJYTnLO2hOvrLgitq?=
 =?iso-8859-1?Q?/j5K5wfvYedQgZ1oue6E+Pj+kCA8O9i/TCvRyS0NRIbKQj7Yepy3ImipXc?=
 =?iso-8859-1?Q?0UPtGDF0/zdVJ1umRb2x1e5FwLeS9uMPwWe4SWTP+dOJRWOqNNtamEOqUx?=
 =?iso-8859-1?Q?VjOOUBxfe0fEG+t15e8T9vKWLz4bJ+Bu+lxP0TTFW1xa4PK4iY13pEFOMF?=
 =?iso-8859-1?Q?DXrLS25aJbNkVaTOKP/ZSJ76w1/bXICwL6L4/HYOi0eVeXrJZV015tFg06?=
 =?iso-8859-1?Q?9695ND58YSGnsCYG6u69DEenyhQNiizEI7RDkL0e1NDNkLwIeA9REcRaPm?=
 =?iso-8859-1?Q?9fk4Dne4T8aFrjDwHkO6Jgis5B2P4OA8EsF7tXz3PwfgraGZz+J51MAS0j?=
 =?iso-8859-1?Q?1wLE10jbpca3MlKjQa9n2mjsjahJget7YvsB1BpKoy7Tu3I2rK1GGBXXu1?=
 =?iso-8859-1?Q?MMNxDYHvTB5+TiKcvgWHR2VQucqXCXmClAYrWC2IrpEqkWPxkjniSiCMdZ?=
 =?iso-8859-1?Q?+nrNk6UyoGDK8BZSRLgxt/ax6KNkNfMuzfwSlH1qxOR1aN7RldPCZTQ/Zf?=
 =?iso-8859-1?Q?nZsXuEjIcjrCkw02oySXBu+QztMx1OV1yR+Xh9HVcegrnmoQQRvCphFxGo?=
 =?iso-8859-1?Q?xJkWA2Bx25chHJwx+B+HWyb0Z5/fnnhFhhdeeR1diWvn7Cn2Tr7ZAiUxJr?=
 =?iso-8859-1?Q?uXPbbdujzBlqsls6asvhqumcYJ0h5vyTlwl10X/1+dGcbMGO7Lu1P6h0h4?=
 =?iso-8859-1?Q?5gCHjEf0LPAzoK+oY0kFuu42vlPOE8TVdhASj/Hw1i6SQWffahLfHh7god?=
 =?iso-8859-1?Q?G2iG9i2VmpwTgJ73veNkKZSGhpX8Q4wGBEsgf26q0WN46dGKzB/t0IFckV?=
 =?iso-8859-1?Q?B427vQRqbdaPPRtI02QrXwD+vilh5TE4iRSX5Rb7EtSAPQupLOHwMoMw1N?=
 =?iso-8859-1?Q?HgZd8jxf+bH8Guz+ELy99ozHnpEfzxkPgdgdz+O5CrzI8necFU2XeWlVvy?=
 =?iso-8859-1?Q?a92tjY5rhiPG7xisoWgT+ZDs2y+uyj/tYhk64no5azpIjIAXS8eqIQtLyc?=
 =?iso-8859-1?Q?4TI/0U+g+S2PPc2uB4zH/yAFEEaDFLe8q3bVAm3ABfS1vIB/30J3jfAMXJ?=
 =?iso-8859-1?Q?W468BTOfsA/lXNX5KNo9QMINh5GiL6eQdFrNaCjl76JwNHXpZeo500ZdZ/?=
 =?iso-8859-1?Q?BdS3K95v3Cb87QfWaXAninu14Pf2jvW8GrfasXzLWUu3gR3PDmBZnGS4i6?=
 =?iso-8859-1?Q?rnRJvSb3UDQLjtysxV9+VAJbWiWu18De3dAWZOOjlcVQiAb5FTeFaCNdOc?=
 =?iso-8859-1?Q?zaC2gI+q76/t1IqdFsQyrM61Opve4qoFkLXmn+dhaeIjgQRPBsr+JPtY0m?=
 =?iso-8859-1?Q?upE/1F4UlyoL1w+haSI05GHq+rAa2HCWSLUuxkzEE9L/F1zrZ5x+veTePn?=
 =?iso-8859-1?Q?+DZ1WOx9i+fTyBPHEvNeMrS7ELTAn40eNHqUHZrMLY5zCFUzZQbIVRvq9w?=
 =?iso-8859-1?Q?mHQlp9kRzFADLR7NdvikTOwQD49HhHpTV6lopboCSkFUVKdHaI1BaRjeo5?=
 =?iso-8859-1?Q?ZQAU/1mthdPUO7Az/AQ7MTqsH5Vw5v+I9pl5mCmJz4mONh+4yF1aeFAtSi?=
 =?iso-8859-1?Q?+Aovehl4wJzhoqf4ErjZcFo1wrOpUm+ulrrbQwKQIk3Cc06V+eo048jvZT?=
 =?iso-8859-1?Q?kuffxHTeEQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR19MB4034.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad103366-f7c5-4792-a060-08da4928cc1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 08:27:59.8334 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZjCioEwAeslSQOUn0MB9BNhCDCOKvRV2vrzQi1jHAB2gUiF/a1xOcTFdEHNDGs9V3v2Q6rhidcabWxLXy/8gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1901MB2068
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_02,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 spamscore=0
 clxscore=1011 priorityscore=1501 lowpriorityscore=0 adultscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080037
X-Proofpoint-GUID: QEK7nzh1ikvINvFRRoug_C79jUBWVuMd
X-Proofpoint-ORIG-GUID: QEK7nzh1ikvINvFRRoug_C79jUBWVuMd
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 spamscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206080037
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 09 Jun 2022 07:22:03 +0000
Subject: Re: [dm-devel] [PATCH] libmultipath: unset detect_checker for
 clariion / Unity arrays
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I agree with thinking,   it's better to check if device has a specific checker in its stanza firstly.

-----Original Message-----
From: Martin Wilck <martin.wilck@suse.com>
Sent: Wednesday, June 8, 2022 3:56 PM
To: bmarzins@redhat.com; christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com; Chen, Yanfei
Subject: Re: [PATCH] libmultipath: unset detect_checker for clariion / Unity arrays


[EXTERNAL EMAIL]

On Tue, 2022-06-07 at 17:45 -0500, Benjamin Marzinski wrote:
> Dell EMC would like to always use the emc_clariion checker. Currently
> detect_checker will switch the checker to TUR for Unity arrays.
> This can cause problems on some setups with replicated Unity LUNs,
> which are handled correctly the the emc_checker, but not the TUR
> checker.
>
> Cc: vincent.chen1@dell.com
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This points us to a flaw in our logic.

It was wrong in the first place to have autodetection take precedence, even over "overrides". The effect for users is that whenever "path_checker" is set, "detect_checker no" must also be set, which is highly surprising and adds no benefit.

We should assume that if a device has an explicit checker configured either in the device configuration, overrides, or the hwtable, this checker must be used, and fall back to autodetection only if this is not the case.

So while this patch is alright, I'd prefer a patch that fixes the logic.

(The same could be said for detect_prio, but I don't want to make outrageous demands).

Martin





> ---
>  libmultipath/hwtable.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c index
> 39daadc2..415bf683 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -350,6 +350,7 @@ static struct hwentry default_hw[] = {
>                 .no_path_retry = (300 / DEFAULT_CHECKINT),
>                 .checker_name  = EMC_CLARIION,
>                 .prio_name     = PRIO_EMC,
> +               .detect_checker = DETECT_CHECKER_OFF,
>         },
>         {
>                 /* Invista / VPLEX */


Internal Use - Confidential

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

