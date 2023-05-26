Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0B8C77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 09:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685092932;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=byM85aF5ZS9Z6s9m2HFAGqwDdr1+pMNPQswqY60ZAQU=;
	b=fsmOTwJoJFLxXG5dys5lNydSMnv26JtxnmvdSaF2LFv8p3W7jfplk5CItnkFL7OLs5iHHP
	d15n/4Ns7Rsl0xeSej/h6oMuDNmqfqiL1E8SOxBL/V3uXlQgCdd20Jarr05PHNq1h8yMwD
	aJ0S1N81AP7vdpZf7ogYZq/3zVzAt2k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-Vi9oHU-KPeeEREdSDWnOlw-1; Fri, 26 May 2023 05:22:09 -0400
X-MC-Unique: Vi9oHU-KPeeEREdSDWnOlw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73DF01019C87;
	Fri, 26 May 2023 09:22:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5DA97140E95D;
	Fri, 26 May 2023 09:22:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2FF3719465A8;
	Fri, 26 May 2023 09:22:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4800C19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 09:22:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC994492B0B; Fri, 26 May 2023 09:22:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E3ECB492B0A
 for <dm-devel@redhat.com>; Fri, 26 May 2023 09:22:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF8B6101A53B
 for <dm-devel@redhat.com>; Fri, 26 May 2023 09:22:05 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-153-xO8QcOBMN3iscEce4ES84Q-2; Fri, 26 May 2023 05:22:03 -0400
X-MC-Unique: xO8QcOBMN3iscEce4ES84Q-2
X-IronPort-AV: E=Sophos;i="6.00,193,1681142400"; d="scan'208";a="236654011"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO
 NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
 by ob1.hgst.iphmx.com with ESMTP; 26 May 2023 17:22:00 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7389.namprd04.prod.outlook.com (2603:10b6:a03:29e::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 09:21:58 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6433.018; Fri, 26 May 2023
 09:21:58 +0000
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
Thread-Topic: [PATCH v2 4/5] dm bufio: simplify by using PAGE_SECTORS_SHIFT
Thread-Index: AQHZj6Rul4Ow8+5BaUGwBzjjGuDKSa9sR8CA
Date: Fri, 26 May 2023 09:21:58 +0000
Message-ID: <ad5c229c-4c7f-e9ff-3326-477aad226388@wdc.com>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-5-mcgrof@kernel.org>
In-Reply-To: <20230526073336.344543-5-mcgrof@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7389:EE_
x-ms-office365-filtering-correlation-id: 7eb253cf-89f1-4cf9-c630-08db5dcaa7e9
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: rAzbl8KQHcQwHjxphEOc08bcio1znsj0ngnCovdluHghc7St3pifZFm7zC81TeZ2kBHPJKBBZSntczzwa2ESlDypfezMuNqHWK9rK5td7xWRwFlUnF7dxsteKBHy3wGQglfQ/6VSNwGofwx1WlBnTxmrrzWUUVLx3fypaHQTY0w83xTtCRK4gvB94vSwaJTDUJ2l2+lNneG3RdueXSOEnADB8osnNPyeaCJFqYFsKG7ZiIJvQUJn+hjjYNTF94gqzaDArIcrTGwirwbi4eX4pvE/yLRbRTe7LoGnXOJAwpYZvVE1sZsrQAuEtlTXt73GP/d5IBZzhGQPjVNrOuvg6lKZexCpX69k+vfdD04RPsbdASp4a+FIOt+tyoYmRjKZRIQKsZjzJA1Rs4NfITCv1PjEkitS+GOxRC4jzam8OfIbtHvT2RglgIiriXyveLSpwYt/LemfCDbCYfmHchwjijyHrrfShjL4RS3Tmn6oMHiYgaBL7cHPUGjYWOzx6g3r/RH1o9tLyF6Jg2//Yejadhas2U+Qa0fXE2/LuTnp4Z9QoBGOHIfYsqmBuj02A9Yr0LRMx+D2gI2LQdzcMPR03uQ53gq2itmGwi7/Qhy2VaBDgfiO3oTszBe4fmJxK9YrynQx0rFfnUNSktfnKX2ASu6l8UjzdRnBSYCMyPdRu9HX28tPEcbwluTGFF6FOixn1veTzUHeynFsEQaIbaNNrFVDC72cGO+aT2pDTgq9HQuw3T6S6MtUD2Wy6hEVzdmX
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(31686004)(6506007)(186003)(41300700001)(2616005)(6512007)(8676002)(8936002)(7416002)(26005)(53546011)(86362001)(38100700002)(4326008)(36756003)(4744005)(2906002)(110136005)(66446008)(66476007)(66556008)(64756008)(478600001)(5660300002)(66946007)(83380400001)(76116006)(316002)(54906003)(31696002)(38070700005)(91956017)(71200400001)(6486002)(82960400001)(122000001)(921005)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d25mcnhyKzYvRE5uK2FxSkVQWWR4MnV0WklTYW1JU0ZQNjRRZ1dNUDJwZVdX?=
 =?utf-8?B?MVVaZUNpVnFCOUN3OU9XZDFQT2NJVWpSRXNtRVAzTUNKRGxRUW4yeGVmUEM2?=
 =?utf-8?B?WWVJWXFDZG1pZmdyeWg0TThKMnl0RzlpRFJmdDQ0TU41cm9CWkRGZU9QT0hu?=
 =?utf-8?B?SGQzVE1hZWR6QWQ2VStyZVJWR1hRc0p5US9WeFRMa1pNR2QzaDBpZTI0TTRR?=
 =?utf-8?B?TkNOUjFUeitZOXlyV0ZJaFQyMXVSUDErWUxVUWh3L1hsUGZNTVBjRk1zTkdt?=
 =?utf-8?B?SkVOWXRFZUpiSlpVbzRJWkFZazAzeERhd29XYUdmY1ZubjFqeWtzTlJPTEJN?=
 =?utf-8?B?OXNqcnRMKzlhcWZFZTA2NnFjTFAzYVlFQmlGQktDRlhhbkM4TUFBdVBCUmIz?=
 =?utf-8?B?c050K25hZGkxTC9DZnRTb2RObWpyVFdHQjVGU1pxcDVkL2NlUDArVmZSbUh1?=
 =?utf-8?B?QjhFL1JQWjdpem1VMDhZOGd6RGFpMkk1UE5LMUlpb0hRYXBCVFdQOTdEUndD?=
 =?utf-8?B?VmlrYklmVDhNOFBlZy9nQTVwSnMxUjhseEFJNmJxWndnS0pZMVhQWEdvM2pD?=
 =?utf-8?B?eFZsM09XSDRsMjVvZFYyV014dDRqTktxYm8zT2p3Uk5hTHg3a21vcXJyOXlG?=
 =?utf-8?B?a0QrUEtwcThpekwrcjY1bEhPbVdUN1NYL2RiQ3JLbHpXYUlIMHNWS3hlTXl2?=
 =?utf-8?B?MTdUK1BCT201c1FwUmFzU2JUNkxZSlZLTzk5Y0IvZTRKTThGOVoyQ1kwa3dM?=
 =?utf-8?B?OG14TEJHdzhxUW9pUnlJNGV3WFhwNnZnRkhQbTVSaTRPZ3VMWmk2NzlWNEg5?=
 =?utf-8?B?Q1ZNTzdCOUprallBUm9pdTR2UGR0QXc1UTlCWTNNV3NXeFo2UWtvcWZJbWhy?=
 =?utf-8?B?Slh1K0hFdE52bjRJcHBYZEIvWWlDNkhrN3ZZcmxaM2UzckpvMzVYZWtuczh0?=
 =?utf-8?B?S1ZUcVlUTWpvTWEybXlXeC8zTlp0VmVRZm93b1pkTituaENPUm0xR2FubFNr?=
 =?utf-8?B?RGF6c3FGOEFlaTlyaTFQcVpFT3pwYnJVc0pwSDZ1cEJ5RlkrRDJOaEF3UUlh?=
 =?utf-8?B?eTdsSzVPSkRlL29jbFU3N2ZJZFhwNnEvMWt0YUI1T1dHeGpVZ1FCZ3BRc2Nr?=
 =?utf-8?B?VGtmNUJkcXpUYUlvdGFXYVpYa0R4WjF4UkNaUGxzUmNINmhmZzZ3Q1BFYldh?=
 =?utf-8?B?UGcrQUkyV2k0NUVvSy9pN0srR0E4SitEZnhuelVxSFhGNGpOY1daTXRyOG9s?=
 =?utf-8?B?ZG43VUxDVk9wVGowZzU5U3R0c3JSbnZlWm1lM2l2a25Qc2QyQ2d5bnFUQ0tr?=
 =?utf-8?B?bWE1UzVkczNzUGMvRGpmV3dxcElMNFFPOVAvRDA0SzJwUDJuUFlGbU9KZ01a?=
 =?utf-8?B?cktjOUExdk1hUW5lTXlCYTJsS0tlakRoNHVxRGpqOTExZ044NWg0S0haRVZI?=
 =?utf-8?B?QWFvSGs4K3FHTWI1NjFnYU1URDVtWjRjdHd0U09IS0svQzBDRFNEc1BYUU9Z?=
 =?utf-8?B?WGxCWnhYbkVGK2JLWjhxOGhxYWhmYkVZZzFFYitzSkVHbStRYkZPb2doUnZJ?=
 =?utf-8?B?eU5vMklnRTlmQy83QXFTZk8rSWt2bjF0V2lISlhGYmNkbEJsdUdSRFlndmtw?=
 =?utf-8?B?ajkyQlZ5ZEZiUXB2K2IzakFmTFRHNUNlZ0pkWVdMUlBRblkzWVZkVkJrUmdy?=
 =?utf-8?B?aG9lZWV6SUNjYnkxRCt5MnJNc1gwWitEWGVOOXNGM0dJUlR4N21wdFh3MFgy?=
 =?utf-8?B?RUdRMkhHdHUxZHFlVUgvNHltU2Q0b0N3MWcrQXNUdHo1bS80YkEvU3VvMjFt?=
 =?utf-8?B?VkJKenNNVGlPZU9UME9YaFRUTWZBOFk0cGZzK2VnTUtHcnRNeVl6VVBtai81?=
 =?utf-8?B?aEpwZG13WVUzRkQ5S1h0SWxtTUNNMkwxSFlvbFZ4RFlVOVB1N25yUVZqbkdE?=
 =?utf-8?B?UEtyUVVlQjZjdHFCdFJGdGlQQ1M0dVZncEFuQURxbC9hcnlwNjk3V1JqOXBQ?=
 =?utf-8?B?RkFQV3V5TW0rYlk1RVBQTlhOdkk5MENEYUd1dWp2a3hJcnBpaVI4Z2w1WGgx?=
 =?utf-8?B?eDFWV0JQQ1pKOVdKVjNwL3cycmUyRzVyQTZ5LzZ2THl0ZmdXMkptRU8wREtZ?=
 =?utf-8?B?bjJFODNMU05pMVpyWTFuWFUveVFQQVhxb3dZYjlkY1Nld0tKWklXemRWY3Jk?=
 =?utf-8?Q?U3DM0gbAA+zNAbTwMZeNhHI=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aUpNb2h2alVHZmFScTFYeWVNUnRYcExiLzFRWXNZOXA3UitCVUNBVTlQTUF6?=
 =?utf-8?B?cVlHSEF4VmIxak9oeW9xRGdnODZjRlFBd0psTFh1UzlEMTNBODd3K0V4ay8y?=
 =?utf-8?B?NkxKVzJqOWFkZmtKY0lPMWdzOUlGZ1FuY1pCclBIdTBPRXJ1bUM0bGs0WjRh?=
 =?utf-8?B?cDA4RDMvNnVrSG5FaEVZT1JOUmN3SjRXY2phL3AvbVVOaDBoblIvdGtOZGRY?=
 =?utf-8?B?RHpKY2d0ODBHVFBnVHpkYkd1b1hQTjNIeUtkYnhZU1pVRG5xdkF1QlFCWDVG?=
 =?utf-8?B?dTFQWkxjYk1xOU44em81QnFOcFV3UHp3QUJpL25OTlpTcEY5bmE1UjVpMFZX?=
 =?utf-8?B?aGdLRVRVbGYrWHRHUEtTV3hFQnhRR2NNNkxLZkxpM1ZZMVgyQjI1OTkzS21a?=
 =?utf-8?B?MjZwcy9OY1Qzck5lNmRIZGJuaEZBWXJPWllFeGMxR2dvaTdxaFRHdVkwNkQw?=
 =?utf-8?B?MmFnZlNqcHRSNU1MWSs4Y2M0dVMwbmJpSFgzMEJmTFBkeTgvTUo1RFFRcnM0?=
 =?utf-8?B?enhNaE9UZjNmTE96RXgweXAvaW05Q080eVo1YUhBTUtUdlBuL2poS0hoOXBi?=
 =?utf-8?B?SC90Nk11MWhud1l4cHdvNkRLeTgyam1UNzVkMDlQTU5EUU5kSnlIMVF5YWVP?=
 =?utf-8?B?YW53bmU2V1hzOGxab2QzR1lnQmxiWTRuSXNOZjFyN09ObExranZ3Q1B2RXNW?=
 =?utf-8?B?SjJBUUY5TkpRSFYwckwrMmwwaGpRRVkrQlh2YUtMTnlBTlBldTlzZk5OSmo5?=
 =?utf-8?B?QTZvRFg2VUMyeDJ1WU5RUGdnNnZveldWRTliQ1crR2RsUkowUWh0Z1kzUURh?=
 =?utf-8?B?S2pRaHJKZjExQU5QQ2lVV2xuTkZPcnZoN2FzMmszK3o0alJrUHE2dm1FV3NH?=
 =?utf-8?B?QWE1WjF2ODVPVXYyS2RzcElxclozOXMxWkY1a0hlSjIvNVVmUys2OHNrbEsr?=
 =?utf-8?B?eXJpYUc3YU0ySWR1ak83UXpuUXkzTml3QlZoektiQlYyanZSWWVGL2VaMlQ2?=
 =?utf-8?B?ZmVZMng2R09vMVBDVjVNS3NjbnhyRjM3blRhTTB5Vm04WXB0eHZ5L004WE5E?=
 =?utf-8?B?d0RYcEcyeDdYYXoyR0VlVmp1alhBUmEyd1JZTnhzS0hSN3RWaEtkYWFDRDgy?=
 =?utf-8?B?cDYxSGYyaGVFdDBQcjI2OEZscWhMSllCeHRKWE1GSWNRcFlnZklsYmlJY2hJ?=
 =?utf-8?B?cWMzN3E4dnBCZUYyclR4bnZ3aEdKNU1vTnEwWTk4cDdVcFpiaUhNTEZEOWh3?=
 =?utf-8?B?Wi82aXRnbVZKZmxqeU1ISFBPOTJsNm1sUllGbmRQcDE1aStYOTVzd2pGV2Jv?=
 =?utf-8?B?YUgyemw0R1lEZVZ2WHgvVS9XNTE4ZjlBbGxYMzRVb0JpQVlUdDNWSXFoMXVn?=
 =?utf-8?B?cEdZcisxeWZseXZnQzUxajNyV1ZLc0xhSWpWVDFWZE43NVd0VWM2N0hMb0xx?=
 =?utf-8?B?dUszWjU3L3RiZXVnK3RLdEJNSVVnUmxzaW9qaFU1UWdsZzFraFVML2pmaCsy?=
 =?utf-8?B?OURwOGwyMnQ4dk8wNEVPR0VaVmNGa1I5TFB0MXFVOTVmMmNPWjc5UVViSmlR?=
 =?utf-8?B?cWhnUT09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb253cf-89f1-4cf9-c630-08db5dcaa7e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 09:21:58.4472 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kjt4T8/YTfcgInHz/Y8mn1o6Lc6eVP55pPToVq3yHLJVVb4hhL6QjjRYpzqPvDp9zr6akUvDQ5DL+hxGgUD3P+ApNG6jqGKlHOV1igCMbGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7389
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 4/5] dm bufio: simplify by using
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
Content-ID: <45758A4BDB7BB34A90732E4D3D171535@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 26.05.23 09:33, Luis Chamberlain wrote:
>  		*data_mode = DATA_MODE_GET_FREE_PAGES;
>  		return (void *)__get_free_pages(gfp_mask,
> -						c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
> +						c->sectors_per_block_bits - (PAGE_SECTORS_SHIFT));


>  	case DATA_MODE_GET_FREE_PAGES:
>  		free_pages((unsigned long)data,
> -			   c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
> +			   c->sectors_per_block_bits - (PAGE_SECTORS_SHIFT));


The parenthesis are completely unneeded in the new version,
please remove them.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

