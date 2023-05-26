Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D993C77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 09:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685093072;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TL8j5xdolojjNSBGKmRgHUzKDX/lwwftJo9UCHu5U5U=;
	b=FmlEXBxFToTNLQIzqJpx1Bp+9NSBuYkt+LhUGtia9IFJwMIwnSuoukAwvbWzO0xIxMpTEN
	ekNeQAwhgiQwweDIhuysElMlCpc1vTV2vRw/MEHQ6JgexiKEvYR3mag4pfUXinkoQ98u32
	V9NuOxmrGVqD8KXf3NWypi2W/mSVEVk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-jCFVrExzN_OugmAb4Z67Iw-1; Fri, 26 May 2023 05:24:29 -0400
X-MC-Unique: jCFVrExzN_OugmAb4Z67Iw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EF2285A5AA;
	Fri, 26 May 2023 09:24:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68B94140E95D;
	Fri, 26 May 2023 09:24:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 34E2D19465A4;
	Fri, 26 May 2023 09:24:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A0A4119465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 09:24:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2DF8B1121315; Fri, 26 May 2023 09:24:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2462E1121314
 for <dm-devel@redhat.com>; Fri, 26 May 2023 09:24:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC872800B2A
 for <dm-devel@redhat.com>; Fri, 26 May 2023 09:24:25 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-448-I1GE97g9NXGfD_uxZqaXtg-1; Fri, 26 May 2023 05:24:23 -0400
X-MC-Unique: I1GE97g9NXGfD_uxZqaXtg-1
X-IronPort-AV: E=Sophos;i="6.00,193,1681142400"; d="scan'208";a="231721682"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO
 NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
 by ob1.hgst.iphmx.com with ESMTP; 26 May 2023 17:24:16 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7389.namprd04.prod.outlook.com (2603:10b6:a03:29e::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 09:24:15 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6433.018; Fri, 26 May 2023
 09:24:15 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Luis Chamberlain <mcgrof@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, 
 "agk@redhat.com" <agk@redhat.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>, 
 "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
 "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
 "christoph.boehmwalder@linbit.com" <christoph.boehmwalder@linbit.com>,
 "hch@infradead.org" <hch@infradead.org>, "djwong@kernel.org"
 <djwong@kernel.org>, "minchan@kernel.org" <minchan@kernel.org>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>
Thread-Topic: [PATCH v2 5/5] zram: use generic PAGE_SECTORS and
 PAGE_SECTORS_SHIFT
Thread-Index: AQHZj6R27EIx0gGFaki5/atffHiMOK9sSGMA
Date: Fri, 26 May 2023 09:24:14 +0000
Message-ID: <597dab55-737f-73f1-3505-1e0c59d52d80@wdc.com>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-6-mcgrof@kernel.org>
In-Reply-To: <20230526073336.344543-6-mcgrof@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7389:EE_
x-ms-office365-filtering-correlation-id: 2a58e130-6d7c-47dc-2dce-08db5dcaf944
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: f7ZgRwgp6IHp33pX5qr3ouekACz9b4viMB+SI1f6SRFIM+0b/RmRJIHt9xxxNyhzEfEJt6JNYsI1lauEBAqJUreYel2rSs3I5VpimgEAMMOqBkBHiZAoGz+GUPlQ/k4Kr1MLhyJa6KljWU7KInXKDqrFp+CADr3hMtttorbAJqZpn6wXarMViKHNHcAK8brDWUuY5hT9D579fNgfAsl5mEpw0rCC+/BmruzYn2NYyddYLAXSvupZGm0pFVcALrL7twIHPZQXV+NuwMe1lvb5/5MIhJFcaaP8p5cvpVjgf8iRLj+wDONEfuYgvpc69PD84YsW1udok2qXi4j/O3aHaOyoN+bm8fyZtU5kKJhzM23wqQ3O28sCOZcCdwyBZXVinGuJFLSqqw/A0kRXsxrF7/D0SBR1owLE6+NGwkxKTcLOGNGIVeSedoiJDph1FYUmCulTl3V0ThzMOrqxueZ/5hCaACpF/48t9qgZdElAuTTK75UaK0ceVQ2FStj8kO1rurQXXVFHJN4dT5+Jo53yVSoMVuqfo3EZER1QlFmWDXaIBgyu2hw4WeH9cWnBXfkqyHyXdXmbjdqtJmv8ymvRghTjt8OrTM8sXeYIp01aXB66w4yv/A94SX15C+stmumOmZFGKSQLaH+ERr2qIv4lwsFEjtffxNWPK8d3UJZFbSxG9Ruzud2rb8IoWZ/WcRWAnpkiuY2J7qp9OTJ5WnE4nMJSqyvlQd2U9BaH4XRSEEmsxBUlNmdH+ZT5DdGpidSNzgHYcBnom8qfUdg6t8t+/A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(31686004)(6506007)(186003)(41300700001)(2616005)(6512007)(8676002)(8936002)(7416002)(26005)(53546011)(86362001)(38100700002)(4326008)(558084003)(36756003)(2906002)(110136005)(66446008)(66476007)(66556008)(64756008)(478600001)(5660300002)(66946007)(76116006)(316002)(54906003)(31696002)(38070700005)(91956017)(71200400001)(6486002)(82960400001)(122000001)(921005)(41533002)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzV3eTRGM1N6cG9zZmZJdEVWcnAvRTdYM2xUSkNIdC9HeUJSZy9Rd0JkNDZm?=
 =?utf-8?B?VTRFV1lkSVZwYk9kclBrd0pWOUU5L2h3aUdXWk1SdW5GUmZSaEZCNlB6L01T?=
 =?utf-8?B?Ti9CYjdUK0tBaTNmaTJlTXRrQzZBMnByZE1oOVJnMWhVaWY5dHFLZWRaSDZz?=
 =?utf-8?B?bERtaEVwR1U4eEcwSE42TUFEL1JDQlBya3VNNFAwalI0MmFjTVYvbm9UNzQx?=
 =?utf-8?B?Z0syNmNXVTZaWURUZEt1WUNabEhKUi8rdVdwdU9kVjVHNm5wUUF0Q0FYUnFt?=
 =?utf-8?B?SGhPMmh4QXhrU0JqMTl6R1FhOTc0TUtkcXFNZHpDRVlPcW1VOUVndm5rQjI2?=
 =?utf-8?B?eDBNd0MzRm04d0VQV3VsQ2p3TXpDb1dIL0k5TVNNVnFRZlM2Y0RlK0k5cUs3?=
 =?utf-8?B?OW5vR2MxUUtpNFJpN3ZlOHpCdEVpbmtMbzlVOXRVenV0bktnZjVDcEJCUFUv?=
 =?utf-8?B?TlVwdzB4ODZlMThLNFBlamFid1Qrb3hNeXQ5dWtiYVVLRG9vQzVSSEtyMWNa?=
 =?utf-8?B?azN6Yng2TmlFOVhUM0xMOC9IR1pTVEhyMWh4OHZZRUdITDFxRWh2YTl4Q2dw?=
 =?utf-8?B?a3NKUlFKcVR1alNKUUgrT05WSVl6Vm85b05YUWl5TWN1SjlMREdkOWk4REFs?=
 =?utf-8?B?a0tWKzFiam1xNGY5ZUIxQ2hONGd5ZEZGOWFUZFhseDR1WGxKeVZ1VGRXTmlO?=
 =?utf-8?B?V1dOazM0R1lrZTlncUxzZ2hMR2ZMejhFTmd4VG1VRmtVQkNyYjV3dUFiL2J0?=
 =?utf-8?B?dTlZZWFpNG9QSzhmU0F0dU81N1VSallZUmJBMllBb0JPcFlnbjh0eWRKcS9R?=
 =?utf-8?B?ME5HRkxiTlJtWUc5VnpmQU5wVzVrZFE4Ym41ekJneGNFd0Nib1M1VDZaUHpw?=
 =?utf-8?B?TFhNVlJPdmMxcXQrWlJETmNmQlNIMnIrQ0QxWTVzVmx5S0dCTlJLZ0lsSmdN?=
 =?utf-8?B?UlgyL3puV3k1bmk2Qm1pdjUzRUQzNTlNclp3L2pPY3NGdnd4WTdpWlhTZUNJ?=
 =?utf-8?B?bjdvbzNxU1B2ZnRHdlFMVW9vTko4emtpamhLWnBnRW5oVTJpbTN4bm9LdU1B?=
 =?utf-8?B?d3hzZ1BJeTg2QmRHUG5aMno1TGxyalZPQ3Z5SmQzelFoTm42SnhMTWYwRDAw?=
 =?utf-8?B?OStyS3RxWHZqRW9HTlpjNkF3c0FKREgrekExbDZ2Wkx0Y0M5b1hZeGkwVWZD?=
 =?utf-8?B?amF1bERIN21PcDdIcmpHMkRPWFZDb2NzQmY2enVFeG9ONGRKb0ViQzh0TzYw?=
 =?utf-8?B?ay9IMVNSY2NoSHhScWg1V3NXc3lEQjFNWVNXekdxSFkxbzQ4eFhmUjJNV0pn?=
 =?utf-8?B?dmt4Rm1ERFJlei9XNE4wYXMrWlhwLzBCKzQ5Nmo4M0ZPVmQvRlN6Yk1md1dQ?=
 =?utf-8?B?U1E0Z3JCNk5DaFNGd2FLWm4zYlBRQ2EwbU4zY29hMzlwREpKVEc1RzNId1VW?=
 =?utf-8?B?WUJHaG5GN0FzL2ZQS1JsVzd5UHg0TTJHMG1hcUdaV0hyWVZrNlFIRVJHd0hU?=
 =?utf-8?B?ZXM1YkFUeVM5c2pLanozNzB4cGIyNG1wLzBSUG5NdTk4eG1xZEVOT1VGaHR1?=
 =?utf-8?B?WEMvN1kyTWd6ZUdselo5S2VVaXpRU3ZZUEMraFAyR2FkUWNqQ1JIT2VnMmg5?=
 =?utf-8?B?V3B5RDViZXUrMXphTWRLZ2E3SlVoYXd3V0tQYlJFRWdPWEN6aGord0JaNDcr?=
 =?utf-8?B?eE81dG9QVW9EQkFqK0lDL1Fnd0VFUW9PdmdLRW5td2FBaW80Ymw0bjQvSjl0?=
 =?utf-8?B?SXg2eTBHcmFaaDhWTktzbUhKOGhjeXdXMloyRXpBdXRHakZMNVc2SXhJcTZ0?=
 =?utf-8?B?S1JwaktWaXlzdEhlbHUxWUpYcjBRNGVmWkg2V01GVmdwWURRYU1LZ0szRk1K?=
 =?utf-8?B?RE5Zd0EwZy9KVjRQWjlTVUlNSHdnT3YwSEZ1eGlEL1FhQWY3bDF1WDNaanJj?=
 =?utf-8?B?Z1B4ak5lYmVuaWhzcHNBRGhzYTFmanJEWU1lanJUS0cyQndaUEt3RG1vcWxI?=
 =?utf-8?B?WTFjZ0ZFRlNZcU1DRkJNYkloL2xWRlREWE5qT0o2anVDSTNKb2dpRHBnUXNE?=
 =?utf-8?B?dE5iSUEyQjM0UWJmS0FQbmxqTDZXWFNDN0xuZlpmWDRvK1g5aXlkQnlaRUZL?=
 =?utf-8?B?TG4rZGVwLzdpRE1VeWUxNVZReG43ODBmKzlHeXlFVDR1d0ZEZXJjSmErUFFy?=
 =?utf-8?Q?Oe2c4/n6ppRGgQNSnlO0ljg=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aENpNHNIMHRRbjY4MGVYNnBTR2hmVXA5QWpob0xvR2pWVEI2RDRNSFN1dFhO?=
 =?utf-8?B?TEdobjlreHpYM0xLZzloazZuMlZZTFlTRHdKeGsyYWM1eG4yRDB3RVdlQzdk?=
 =?utf-8?B?dTRGNytRVlA2UFA3N2NUOE9qcjYweExQUk1MREZmTXZPMEk4TVNjUmltZ3A3?=
 =?utf-8?B?TGo0aWtjZ1FoSUlLaWhDSE5VRFJSb05IaGEzRjBWTkJ5c216aHZ2R1NCandt?=
 =?utf-8?B?VlhiZkZuMjZjdFM2bmREK3d1VVFHeXY0L2dSQXlQQ05MaTcxVm1UMzNibnJC?=
 =?utf-8?B?RzE5d0RxdFNOWTRXNEZRdUdCUTFYZGpRdjdDMkdVNnNYMS9vbVpOeHVlcHpQ?=
 =?utf-8?B?Y0NRclVIQ2UzeldRbWQ5NmRvQkdJM3VXa25ENzVscHJGTFhKNGpSQmJUVTVJ?=
 =?utf-8?B?YmZ3anQ3QnNxS1QybVpIdUJRTktxeHJFZ3krZE01MnFYQ1hnZWdhalJQWkxY?=
 =?utf-8?B?L2UrVThhTUlMc1lLc1Y5UWxQbFNSUmhXblB2RWhtTmg0RzFkeDBKVktERS9I?=
 =?utf-8?B?elZNWHRVV20vVm1jcHc5SVRUdGFTOUlUZklzQWJ5ei9YWTBNWTlOODZuQjBG?=
 =?utf-8?B?NHRSd1ZXYWtJMlA0US9LV3J4S1YxUFhnaGI5VFByV0cySjlXRlJMRnNDY1Yw?=
 =?utf-8?B?em5MWUtobXRQNzdXcmljVzFLdWVIdmhhaDBvdEVJZW1RMWQ1V0RLa205NWdW?=
 =?utf-8?B?SmpWVUFtc1M0UlBhQnRKeWNiM1gyZjJlT2ZwRUdYQ2x2cEQvS05IVmRqVW9R?=
 =?utf-8?B?d2RTUml6Q2x1M2R2RGl1dUZWcG4yRzJlUmtTNVZZVnZvQmxIdlpscUk2ckpY?=
 =?utf-8?B?OFpNZjUwNVZRZUlJNzRhN2ZtUnpaZWR5Ym83ZVNlN2Z5WXcxRmJ0STcxNU1k?=
 =?utf-8?B?R2dFZzJiVVVHZkZnc3dISTl4d3pmbGRUQk1JamJaQXFqbWlVUnQ3Z1FHaVB0?=
 =?utf-8?B?U3hGUkdNRDhRMHkzZ3RUMy9VeGJYZE1mQUhRQnZLNE9GSHRzRGJFcHp1OXA2?=
 =?utf-8?B?WjRwd2E1RndiekJCbGw3a1hTM1FUVEtuOWl6N1pGL2Nud1Bvbzl1bTcwNFpv?=
 =?utf-8?B?NVlQVXBzcFdmT2ovL0cxd0k2NFRGcTh6QlJTTDhKeFZjRWVzclkxQ0Vsa3kz?=
 =?utf-8?B?QkdBQlQ3NkVxd2FWWTRPY09uNXBnMzRXMnQ3LzhyQW9MeGs1MmRTeWF6Tmhu?=
 =?utf-8?B?R2x2VS80MCt1OVRHdVFsTWZOdXpSSGJwcjY4WTZjVGdlYW94MHNwSzBMdWlJ?=
 =?utf-8?B?WVFtMUFreXYxY1JYWDYxTUNRa1ZMMDBqQk85aGFCZ2ZjL1puTFlUSmt2TGRD?=
 =?utf-8?B?L0RhV1F1VmYwVURtU1dtS0ZnZVpsTERRdjJzWXRkZ1lHN1NBV2c0d1orckJL?=
 =?utf-8?B?T05LK1J1aExDM3NFT2k1QytBNkNMVitzNit6RlNWY004eFVScFFZelE1MW5D?=
 =?utf-8?B?aWtTM2VTc1drVWtDWHFIUG00NEdsWmZlUE1jRnFsVFNRa2lKV1pxM25iSFBM?=
 =?utf-8?B?WFc0RHVOMFBXVGgxN0cwSXZTcS9mQkdKeFpIVlNISThPQnRBd1VTNW1iVytY?=
 =?utf-8?B?QVdPUT09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a58e130-6d7c-47dc-2dce-08db5dcaf944
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 09:24:14.9591 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nDkTjkKvQkbps7QRGHDIPlxCXCEeWpk4M5m6Aabvi/l4EkIW/bQ748yZMEOpUI2j9QlFZXN7r5QDvBI+SkdAhYGLSSJ1SgCv6x1ge0A2nhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7389
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2 5/5] zram: use generic PAGE_SECTORS and
 PAGE_SECTORS_SHIFT
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
Cc: "p.raghav@samsung.com" <p.raghav@samsung.com>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "rohan.puri@samsung.com" <rohan.puri@samsung.com>,
 "da.gomez@samsung.com" <da.gomez@samsung.com>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "willy@infradead.org" <willy@infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "rpuri.linux@gmail.com" <rpuri.linux@gmail.com>,
 "kbusch@kernel.org" <kbusch@kernel.org>,
 "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <86E8AD8D2F16CF4483A7DC09EEFBDFCF@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 26.05.23 09:34, Luis Chamberlain wrote:
> +	u32 index = bio->bi_iter.bi_sector >> PAGE_SECTORS_SHIFT;
> +	u32 offset = (bio->bi_iter.bi_sector & (PAGE_SECTORS - 1)) <<
>  			SECTOR_SHIFT;

(PAGE_SECTORS - 1) is SECTOR_MASK, please use this.

Thanks,
	Johannes
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

