Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14551C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 12:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685534810;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sXCWgkKdIM2J3y9QcVkZfRo6uknl2gqO9cG1w3LBNJs=;
	b=BT1PV8095pzHTJJfu/L4nKY9qKY0cXvDMS7Uz0OtQ/P6SXq+CpdHmXmKiuqW5kj3eJZmFh
	3BqVrRPs7rA7JMnVlqq0bpeYYRdELfr+JcWy9YE0sBngqdBb6udlibFc4d2dcRZY2rSk/u
	rk33hm6ElO+YJ6Hle6iw439tKx1pgJ8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-ir_FgDmHNJi4VH6OU0p6pg-1; Wed, 31 May 2023 08:06:46 -0400
X-MC-Unique: ir_FgDmHNJi4VH6OU0p6pg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE9EA185A792;
	Wed, 31 May 2023 12:06:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 97FA3140E962;
	Wed, 31 May 2023 12:06:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 766CD19451CE;
	Wed, 31 May 2023 12:06:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6BAC419451D0
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 11:50:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AD6742029F93; Wed, 31 May 2023 11:50:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A4997200AD6E
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:50:13 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84AA9101A52C
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:50:13 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-VIj8NEfsMc-wh9HaybICIA-1; Wed, 31 May 2023 07:50:11 -0400
X-MC-Unique: VIj8NEfsMc-wh9HaybICIA-1
X-IronPort-AV: E=Sophos;i="6.00,207,1681142400"; d="scan'208";a="231985020"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO
 NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
 by ob1.hgst.iphmx.com with ESMTP; 31 May 2023 19:50:08 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6396.namprd04.prod.outlook.com (2603:10b6:5:1f1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 11:50:06 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 11:50:06 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH v6 00/20] bio: check return values of bio_add_page
Thread-Index: AQHZkw5XPAsFmQY9Qk2RuFZbojEx7K90RfeA
Date: Wed, 31 May 2023 11:50:06 +0000
Message-ID: <ccdb68bd-59c2-8aa5-7411-3e73d776e3f4@wdc.com>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1685461490.git.johannes.thumshirn@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB6396:EE_
x-ms-office365-filtering-correlation-id: 9d79e7b1-8975-4adf-3222-08db61cd2da8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: qAUehjpdoQ1jtNMwmkQFoqVtf25pTSEilk/PdvnOM1gKkIrm3uqaQ2d+WIO3TEAGl8mv9UziEZyLPnHxnN7udomiiORiYLTYYL+4mur1KexY7S2/lnvNGIP/CROcfhcqweDaZpuqJs+EhuYmVV41BPQq/iDdbUibHvjaQrWhiDWlAXv/ggC4KZQ9n79vtibSjc+j0OlMtiMrv2rJQS+1YM0/pqMLPmeCeyr1s9L8pFKvsn2h4uclLI1Jsg0xW8KVTw4WjsHfyRLLwertLttU77H0sT4R+ZT9pmhPr9So8ChFH9SR2Ub8uiSbAjvGDV7tawWFnqqqRouq9baaDmuB3HEqqDf3lJDa4mJ9/Qy2HaCkx2rFu0chx6uQL0kaMqIbLm2NPkHjKLyugHfQQ7dMm3eAufXwsOGP0ADdBBh2rtLN2tNkWu0MdryAm34gmGneLUv1S77nJp9sIAACFTrI55HpCFkdIB05eA0lCKveAYlQRsj2heKNthOS+hVl48s8TJeAG14rA77itg6TfofuJ8A42fVU4fqNsE6/idQrNHGws+ofNy+BjnybuNBSnUc+ISRCZi86xM7lHz7XFNn4bYEUVZyT7W7DfCXyoNWpe3+vyQ1bwea1DlXmjzperT9VlhLH9VrVieqZ9ZCeucGeYsihmpVb/zZGajAp2FT+qJCFBHGM9jAvy2/+qNJVMnSY
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199021)(38070700005)(7416002)(41300700001)(6486002)(186003)(316002)(6506007)(6512007)(31696002)(86362001)(2616005)(5660300002)(8936002)(8676002)(558084003)(36756003)(2906002)(82960400001)(122000001)(38100700002)(31686004)(54906003)(478600001)(6916009)(4326008)(71200400001)(66946007)(76116006)(91956017)(64756008)(66446008)(66556008)(66476007)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MmF2S1BkQWN4UFVKNUtsbiswZERtUHVjMVNlNThGYkxMblA5cFVMMjU3dEpW?=
 =?utf-8?B?R0kraGI5Mmo2V2U1MS9JTTk5amJrS1hnWlhiOHN0ZG9rdWM5cUJ6YitaOVln?=
 =?utf-8?B?TlAzQlM1MDRUY1BKaWYvS2lkVWlvOWhxWEVkTldyR3VKQ09oREZoZmlLQlMv?=
 =?utf-8?B?VUhiNFl5TFB6cUhRaERvSVoxaWhnSzVyRDVvcEw2dlVjQzN2TlFleklNUUcy?=
 =?utf-8?B?TGJXUHdVQjdwdXhrb1VqMmR1dlIzMnc0RmZjdStUTVhPaGFFeDYwTmhVRDN2?=
 =?utf-8?B?Nkw3Q2g4VU5Xdko1MzRoSkYzSmNUR05VY200S1ZwVWJUY0FJNVN0Ukp0eU9D?=
 =?utf-8?B?UkswTDhHZjJJRGtYU25KQW9GQVY4ZGs3VXNLN2xKQ0w3YnVMYjdsaCtZVDdt?=
 =?utf-8?B?ZGY5QmNubHArL2dRemx1M05mNzZKMFUwYmZtK2FmV1Z3Nm9wNlcvamx1N1Na?=
 =?utf-8?B?bkljbTd4TFFUKzdHSGY4MS9zZG54bndPeVpRTjh6c0hrSmlkQjZ2SXo4QlhH?=
 =?utf-8?B?Sk84d0twNFp3MHFxV2ZwUWlqZThxVnRjUm5tWC94enFqb2JrQlNxaFQ1U24y?=
 =?utf-8?B?UXd6QTZZd2M0cU1JVE5WNU5RM1dXdGptNk9EK28vbitYVStBRWZaTUtSdGc0?=
 =?utf-8?B?ZXZEdnR4NkNYNGUxdlhlTFlzUDBTZDl6UjJONWdwZ1BVMkFoU09BbGYxdmNq?=
 =?utf-8?B?U0wzcU5BSTRadWtrYnA0RVNsVHZYYlFiZk8xaG9VR3UzWnExSmdDcmZwZmw5?=
 =?utf-8?B?blYvSGpDMVhHcGxrakN3OFBtUHBjZnBXMXE2b3RjL1YyRFhIYUJwSmVCbGNu?=
 =?utf-8?B?NmNMUkhXR1Q3UzR1R01adHVUdWQwQmQ4UHNPekZkQVdmbDhYb0x3TmtGMkxn?=
 =?utf-8?B?cE12OENZb05QVTF3TGpQYjhlZWladUtyNmFxbWRBdXkxVGR2bWxwbnZIbHd4?=
 =?utf-8?B?V0VCNGZVaHp2NmMwOTJnUkF2U2hNbzhDRzE2NGR0cjlrLzJtOEhMUW9La1lk?=
 =?utf-8?B?Z3M2Q3BMNUwvN09tMGhuOFpwZzFGVkZUbXl0Y0s1andyK1ZoeVBiNGsxSisz?=
 =?utf-8?B?WHE4RjhTaFNDck5mU05CbXNRdkU5c2E1bERSTjVBVkp1cUJ2MXowZm1rZzBI?=
 =?utf-8?B?ZzhmcmdmWjVmc1JPT0VPMXZXUVQ1V0VtYVhiRzRCemYvLzNKNGt3SnAxbnhV?=
 =?utf-8?B?Vi9rRk9oNFV2RU4vZW92czEyZmhleG5xa1VTNkV1dUt0UHhxdkpVUWVVb1NU?=
 =?utf-8?B?WDJtYlBpR0dKYjdWVFJQREMxRTN2NXJEU09OdzJiT2lad1N0SUN4aEVkQ29v?=
 =?utf-8?B?TEc2Nzh0eHRwR0tJcU5wUHJiZVRDYSs1Q2JVSklkU3NVTjg2T1RxSkQ0Q05n?=
 =?utf-8?B?Q0QyaENYSFZINTBIdDhqdWFueUdxcmE1dXgvWGlBN3JlNjNkNEpYWU92WTgy?=
 =?utf-8?B?RGhYZCtmNjlsNjFXdUpBM2thWEoxcm9JTnROWldsUkQrSWdXUG9HUWU5YkpF?=
 =?utf-8?B?TTliK2RzZm4yTTlHQkRNeVNxcmJEbm5zZ081SllMb0NtYTBraDlFNmg5RHVN?=
 =?utf-8?B?eFlSQXpxaFRINklGZFJMYVVLK2RTTFUzdDRZdERsWlJJbWxEOG9MOHQvSmE3?=
 =?utf-8?B?cDByV3dwMmdGMXNHSGViWlIwZkRqbjNCbityRVlBQlhmUmtaM29MVFV5ajBF?=
 =?utf-8?B?eUFPbis4Z2lSa1laMk94RHJ5K1k1UDFFL1JDZG9wRDdQazJFQ1RHMzlpUUlq?=
 =?utf-8?B?dk9tZDJ5VHpuNDNiVFIwNUZ1a0hwUE91dU0xREtYb1paQkpqQjM0MFlHZlFC?=
 =?utf-8?B?U05INTNMZkVVTW50c0dwU2lqVGxWckhkSyt3OElCNnY0Vk9hTml0Y1hNYURO?=
 =?utf-8?B?UkV0Q0cwc200VG5PR1VLRWJZOU9yZzBsVnF0YWdUa0FKSjdWTkJraVFaOVVt?=
 =?utf-8?B?bmNRdWR5ekdmcGtCZEpzY3YyVytaL3orV29UMEJOUHhhMnZJdHJXM1p3K3cx?=
 =?utf-8?B?Y05nRDJFZDF0ODZLd1oxNmxib0E4ZHNrTTdBWWh4d0xYRE9OVDZ2Z3JBRm80?=
 =?utf-8?B?cVY2UkFVRW1EbEQ5UFVwU3V2TGNuVzI4TDk5NDFpalNMdGlXeFdHYzczRzFF?=
 =?utf-8?B?dk5JWmQ5N0trY2VBUzU2K1JKd1ZUZXRZZHFpRkRTYXNma1RTN1hWYmhYdUsv?=
 =?utf-8?B?cDYyRjl1MDdMT0dLSzV4c0Z2SE5uYnA0YWRrVnVwWXltdmFxYW1lWjIrUGxl?=
 =?utf-8?B?SkMwSndRM0R0QzVrUG9QUm90aGNBPT0=?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RXZwZHdIdXh5K3pnODU2SitPUTBrY29zdW1GRTFIWlFEbWk2eGNvY1JHTEx2?=
 =?utf-8?B?aHc3dWhOeDAyaGtwMzI1L1lvYlNsWGRMYWxOSWFVTXZhNmREUkhRMmVuQ25E?=
 =?utf-8?B?d2pMRDZzbG0zemxNYVVjbFZ5eS9WRVpQem04djNrTDJ1eVEzSlBRRjJpam1Z?=
 =?utf-8?B?MzRtYkNlVG0rampuWDdXN281WEVvSnp3c3lFbTd2d0c4VUtOMXFLR1p0Zmcw?=
 =?utf-8?B?N202bWRsa1UvTXYrdHB3cHVJSWUvbmZvektaQmZGbWRUVkNvSFNsWU1TNW4y?=
 =?utf-8?B?ZjBrSUI1WEVkUTRRYXJSZTNtMWhKeDhLaTRNclFxNW5uRnJBYnBzd25pZzhJ?=
 =?utf-8?B?RFhHd0RtSEtnWWJPdDB0TDBOVWxZaGd1ZnJPblNtVm9TZ2RLMTBVR3VYcE9F?=
 =?utf-8?B?ZENkaThGRnI1K2ptVzdHakJwc3V3SHVlTDNscVZ2eW8xRE5wLytDZi9zZTl6?=
 =?utf-8?B?OTMxMWxRSUZnMm9QdXdNV1pxdUFmSHBwVGNaVUQ2Mkp5KzVSOGdrY2h5YmUv?=
 =?utf-8?B?VEQ2cGNRMTdianZGWFE3bWNqZXdkR2tDNjNRZlBUUnZYaTNvakxjL1ZRdGlr?=
 =?utf-8?B?Z0ljV05nWTlGeDBISVY0ajdoNDQzeVl6VWVZY291NWN2L3dqM2VwTzZnbjFT?=
 =?utf-8?B?cEJxVGFVR2U3bnpFWFZzendjLzdsb0NNS0VPQktLbk93eVd4OFhtdmhmWDYz?=
 =?utf-8?B?YndKNlV2TTYyaVNEdWpMcE8rMjRpeDJFbXcra1hTSkkrS0NrcWppS2J1KzI3?=
 =?utf-8?B?S2FOKzdheGxlMlhRUHlFL0oybzZydkNlbklLL1JkRlV2Z21Uc2Myc3BhdTBU?=
 =?utf-8?B?Q1ZFQmRlRU4zcXliWmI4ZEFFNkNQOTc4OW41RnNLQTFENTFCVWY0QU9VTCtS?=
 =?utf-8?B?Tm1NVVJwRGxweUZxYzZuR1hobzlIZzAvMGNhN2orMzJRM2dyb2V3a3ZIajVD?=
 =?utf-8?B?MmtnUC9DYzNIemRFN0QwYlBYbngwYVR5dHAxOS9aNlp5K083LzNyS3RXWWVW?=
 =?utf-8?B?N284N1FzVUNTV1NCeFNzY1R2Zjc4Uis4N0psRFlJTW50QURJT3dORG1Kbi9z?=
 =?utf-8?B?bW1FZVV1SVU0aXBpYXFwUjV6d1ZwRk1BSDRCSjBLTmtaeDNOSExhK1VIbWZV?=
 =?utf-8?B?RTVQa1B0dktPWGdkMUxPK04wMFFhWkVBYmdRc0NOLzZIcnJWbll0V3RWc2RS?=
 =?utf-8?B?K0xHRmVSa29nRjRUMEZVNU5DSGdvWlZQWEtLWmpPRG1mUmxMN1I2aXNncWlu?=
 =?utf-8?B?RGhJZmhpNkZGL3pQcy9SNlJVODJaTkZiU0kxa21CbEpDc28xSzFlSWltVUtt?=
 =?utf-8?B?bnpsOW9aTDJDaVRHNTZCZlE4ci9McFhybFIxT21qUGNJSXFLKzlOb2hlbElF?=
 =?utf-8?B?NFJRY1kyRWJtbTVpd0tXKzFqWDhGY05SZ0IrK21vend3VFRIbGxybEpQdjF1?=
 =?utf-8?B?ZnZBUWFVU1hiMEtjSXdxSkIzQ1BpMWMyRnpRSlZBPT0=?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d79e7b1-8975-4adf-3222-08db61cd2da8
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 11:50:06.4693 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gAn4mLPpBAKvrEnewlmyS/MyKWmi8vo2MWokqft23ZuNiKcmdgJhW50vkgMIVw93LaetuXQ1Hxt0Z8BRie3J4mFbc9diJY1gNXSDX7m0/os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6396
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v6 00/20] bio: check return values of
 bio_add_page
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
 Damien Le Moal <Damien.LeMoal@wdc.com>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Song Liu <song@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
 "gouhao@uniontech.com" <gouhao@uniontech.com>,
 Mike Snitzer <snitzer@kernel.org>,
 "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>, Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <BB220C41396EA7429B54963D883A2DA8@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Oops I've accidentally re-send v6 instead of v7.

My apologies.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

