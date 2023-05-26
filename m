Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F115FC77B7C
	for <dm-devel@archiver.kernel.org>; Fri, 26 May 2023 09:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685092869;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+vHEke65DTYApxuSLE1DOFG1ypzzvoCgWDLVmXk8/3s=;
	b=KK/GVvQYXpUXs5eGVp1F+rR/6RtC0CNTSbZsNsw2Ab3MwJxRnC9/E4XiaVBwdpevkKB3UZ
	3tFhnN9N8zvr4o73N2TQaTUPAkCy3i6VPAZ0S2BYVKtIUYiJUNWjsqbMqhjcVsDEyN1wqb
	1y5d1EbDkWn2eA9mhW15banHSZNeYpM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-Bd6tx9s7MwijOyJPaV4lSA-1; Fri, 26 May 2023 05:21:05 -0400
X-MC-Unique: Bd6tx9s7MwijOyJPaV4lSA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA7F729ABA1C;
	Fri, 26 May 2023 09:21:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95D69C154D1;
	Fri, 26 May 2023 09:21:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77C4D19465A4;
	Fri, 26 May 2023 09:21:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0BB3F19465A0
 for <dm-devel@listman.corp.redhat.com>; Fri, 26 May 2023 09:21:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DB536C154D3; Fri, 26 May 2023 09:21:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2514C154D1
 for <dm-devel@redhat.com>; Fri, 26 May 2023 09:21:01 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0662185A797
 for <dm-devel@redhat.com>; Fri, 26 May 2023 09:21:01 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-STLDiaz_PZyhr6qu-dZL3A-1; Fri, 26 May 2023 05:20:59 -0400
X-MC-Unique: STLDiaz_PZyhr6qu-dZL3A-1
X-IronPort-AV: E=Sophos;i="6.00,193,1681142400"; d="scan'208";a="236653929"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO
 NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
 by ob1.hgst.iphmx.com with ESMTP; 26 May 2023 17:20:54 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7389.namprd04.prod.outlook.com (2603:10b6:a03:29e::17)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 09:20:53 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6433.018; Fri, 26 May 2023
 09:20:53 +0000
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
Thread-Topic: [PATCH v2 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
Thread-Index: AQHZj6RuwnHylWlyDUyn2XCeeMR2S69sR3IA
Date: Fri, 26 May 2023 09:20:52 +0000
Message-ID: <e107c97a-c637-0b57-2591-24889a3cfc8a@wdc.com>
References: <20230526073336.344543-1-mcgrof@kernel.org>
 <20230526073336.344543-4-mcgrof@kernel.org>
In-Reply-To: <20230526073336.344543-4-mcgrof@kernel.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7389:EE_
x-ms-office365-filtering-correlation-id: 8f26921a-21bb-44e4-b98d-08db5dca80d9
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: iKqnHy1NXI/JsNwrRJti7vqcUbiu6ngostGQAT4wNZEOhAEQAI7B2wamJyNrfenVhlOf2XCxXBAt6mchSUjL2EycVVYCRhuvO04Bd3mKY/WEMqEz8sKMPeVyiFfDWtm8tBI5S3QeJANPngbrC27p1pEVCpVgVVH5Bw4LsbH9MKNDo/Cm0BjypH0erO/Wx/DFiF3clXgynB5iztJTwy/W3buzZQl8ByicsVaUBXMzp/kvzqjoACjYRmVEU0B2SgRVPebp2ZJfi71vuv4l6kXhcocZPKNT/islfTPYSGJH4ENAWHLJvIiVikDe2+ukl8Tu5+cMQ/35QfxK7812TdZftfx2INdN6Orxr5aUBQX0ErxTHDntJVXgxPGmZdqAYsesbwMW/xNU4B0X0dupwtHzG2H7YzRgQ4ssKRj4uaZtF5GY0Xkp9gXPcMMPdPeCSZAPAIM5owc0xQY1IgeozllbgHN0rc++DK5U06G9LVvLjfKmfR21IE0KJo5CzBDQuK/hW7E7iv5IVpBvlxtNtXjR4dBXQTR8o7lMLvFu8rOBC+Rkl2LMth+hxPvfsZoOy0OIzpGYKmMgg8jjjKSCYDLBzJ4FK4jC9W/PCHeyX0XWsgVjqqPkPKvRMIt0NxfAL31+B+yJQxkMfMftH/ffHV07AZRkO3+GQ+8mvrWStgQkAtcKB6S0ajmlCKlbGJqG0vUaPfBhCG/4xZzDm4IyW/Ths8wQpyxYXynIsXjsRijlu5Ik39vs/+JvEX/6n99PNzHa
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199021)(31686004)(6506007)(186003)(41300700001)(2616005)(6512007)(8676002)(8936002)(7416002)(26005)(86362001)(38100700002)(4326008)(558084003)(36756003)(2906002)(110136005)(66446008)(66476007)(66556008)(64756008)(478600001)(5660300002)(66946007)(4270600006)(76116006)(316002)(54906003)(31696002)(38070700005)(91956017)(71200400001)(19618925003)(6486002)(82960400001)(122000001)(921005)(43740500002)(45980500001);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGtEYm95TUxYSjJQMk9nY3huYnd0Q29LU0czOUU0T2xLREIvNzU4d0wrM3Y5?=
 =?utf-8?B?L3c1YVZXQlF4YlRiZW9Kbks3cXA0dE9KelhCME1DVG5vTDNLQlo3VmFDZTVD?=
 =?utf-8?B?VTVNUGw5V3Avc2RXVHJ6TXFDeXdGeWlVTENRNTUyeWV5MXBZQ1NGeU5nc3du?=
 =?utf-8?B?WldoYkl0SUpBTC9JMEErd0RYNlI1cVZSMkUvUnNvTXpaMlhkOTBTMnczaUVv?=
 =?utf-8?B?NUtIMWVNZEZkMkVHV2lMOTFURitxdHljSkI1ZWV3cktZQ3l3eC9YRmlIMVI2?=
 =?utf-8?B?OUVNUHVrS0NZN21YUWc4eWQxRjhXVkxxb1NDenRrc3pERnRtS2lMald3RURj?=
 =?utf-8?B?YW1ySFo5RjZCcnI2dmhQQWNQOHVybGhoZEdzZnFYVk0wcjYzQXlCRTk4dGI0?=
 =?utf-8?B?YTlJTG5JNDlGS2pnNkdNZ3NrM1NqeUhUQy9peHZNS2JrZzFRcWNKZ3R2V21V?=
 =?utf-8?B?clp0eitCTG81d093R0xIUWJublpzVmF2Y0pkWllkMzYyWDZZOEtYQnBOZ1ZF?=
 =?utf-8?B?SUZCZkJLaERTNERGdGNNQkZaWmpJbDZ5ZEJ5Z3Erb1I2dTk1QjZJREg5Ri85?=
 =?utf-8?B?SW5QNWpkellIbWxiN3JwQWdVL2cwTjZUb1BEaWhJaE9DUE0wOGNtS1NGb3Fz?=
 =?utf-8?B?NHA2R1M4d3FPRTdZbk5JbmFXNTFwRG05UEVLWTRSY1V2NkxZeWZLTWVNakNq?=
 =?utf-8?B?V3k0Vzl4ZXVkd2Vld29XOENyVEJZQmMzaVZ3RjlHNzlSKzB0WGdYejE0NmNU?=
 =?utf-8?B?c0RJOFFjZEQ0OXVrQkUvN1pkSmRRdzhGc3czbjhWNFNyVmVFUlZRQWJ6cmhj?=
 =?utf-8?B?OUFvSDYvY2pwSlM2V0J3c09reDlFZlIybm5qNWFKWXE0dW93NUMzdjZ6Q3RK?=
 =?utf-8?B?MWl2OUZRd3RDdmlXSTBPZS9HeHRCcDMvTW1mTUVUclAxbUZCaUM0VjhoU2Vq?=
 =?utf-8?B?VjA2QVFFeThXV0dPU1I1WWFRT3RVdUNtR2E0WWhqTG5CYnIybm1jUTgzdHow?=
 =?utf-8?B?cXRBZWlMV0V0VHhJZXhVYjVKUGxYQnhSeWM4dWh1a2RTM0Y2ZzdYeitLNkFU?=
 =?utf-8?B?cElwNXRZbE1CY3d2b0RxelNEdnh6MVBXZXYyOXNZNU5nZjJveU9CRUYvOFVX?=
 =?utf-8?B?VEErYVptek5MYU9PWXJXVThIQnpKTFRZSExvYktsTTVUQnB5WXV6cFFGc1B5?=
 =?utf-8?B?a1pFWm1YUWZnRFFRRjhMYWtRUFhHOGp1OXhjNVQ5cGhjbWpraGEvb1VlRTMy?=
 =?utf-8?B?bEl3TnVYZlY2KzFyenhvU3NYT3BZYy9Uc24zcUpOZldYYjhzeWVSMzVrUWMx?=
 =?utf-8?B?anZyV2U1MmFoekpBNHo1dzlRS0tvaHpBakVZVGtmcS8yaWwweEhDdWQ3VVdT?=
 =?utf-8?B?dlNkRTRxU2RYU1luc1ZnNFFkZ3MzeGxTeFYvVEx2RGRkQm9KZDI5R2UvVE9N?=
 =?utf-8?B?WE0yTW1Eb0xHdlh4djhDRG00Ukp2cUJxYTBFa1ZGWmlaUlNtSkRoaWFBQi9a?=
 =?utf-8?B?c0FkRldkb2thaWFBSTZ5SDBKVEw3dVgwNHVLMTNZSks4Sy9PR1Z4L3FabkFX?=
 =?utf-8?B?bXZ5em5WZGNGQmZIUStjZ3pPaUo4eUd6eVdHRWZJTEQ5VWJKSGZVZU95aVR1?=
 =?utf-8?B?K3Z0cHdyRjdvbUEvVTE0ZHczeDJWZ0czUlBobzg5Ri9DZUJ2bHI3T3JEbkFK?=
 =?utf-8?B?RVRJaVNkQndJZWFRODZlbjQ0Y0ExOGNpdGt4aG9MSnpvaU9aY3NXMHlkbmo0?=
 =?utf-8?B?TjJUUy9wVEUxUDFwRk9MblRZd0pVWnZuTU9LbkUyTlJqS1lGL0ZWaE41Wng5?=
 =?utf-8?B?RW5JVTJrZ0VHdU91Ym93WnZ1Q3ZhcE9za1U0Zk9MTTN3cTBZT0hOZE5kdk5j?=
 =?utf-8?B?MWVEZ2d0dUZxaHJLVFVwRy9wQnh3MWNsTDBWUU8ydnVJaGJPMG9SVk5jbHVh?=
 =?utf-8?B?OHpqM2MveDh6ZndXZnlXY09rc3NQU1JmY0svM0Y3eG1jZ0RFdCtKR3ppVDZ0?=
 =?utf-8?B?Uld0L3o1U0R1M3FhNjUzditkZkEvZTNHVDZzeWtQemgxVHVmdTNNL3FQS1BH?=
 =?utf-8?B?SUFuRzVveU5HN3VJK2JYL2Z6NTJ1SlBRQlhEVkNLUXdQMzdRQjh0R1NNYTNY?=
 =?utf-8?B?bnJJYW5mS0RxOEU3UGZnSE9zNEp0NDVWb0p1N1RCUWNCZDNiUzl1UlNZMWRm?=
 =?utf-8?Q?meDEyLKtnFDCecc7Tv3DlAo=3D?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VGFUeC9lU2JCNlJtSXFGSjk3MGR0SzBTRTFSbVU2MCsyTjFEZytiYkc4SXha?=
 =?utf-8?B?Y2k0d0ZzcnZrKzZCbS8zc1pTQS9rU1hwVFRKaTk3OVcwM1Bia0prM04zbDBP?=
 =?utf-8?B?UVh4aXV5OStOZFRXZXhGL2xFYjFCUGFQVXZmcXpGaU9ZV1hsaWpHRTdiNU9P?=
 =?utf-8?B?S1ZIZlV2ZDVWTlJaa0NtWGhwczVib0JZU3NwQ0FhWXAvM3lUNGhjd3FuQlNC?=
 =?utf-8?B?MEFLZDBXRmJMVFZ1Ky9tNGk2bk5Rd3B1WERLZ0pjdmoyd0tHWGdIZFpYYlg4?=
 =?utf-8?B?OG9ETlhmRlJ6ejJVRm1Eczg4ZHRMNWVJTXA0ajE4eGNoTHNZUWd6cEV2Y3ZD?=
 =?utf-8?B?TVRqUzVNcGovM0J3S1BlZHVQdXY2b0s1K3RaZG9YMGFXVHIvbUZKWlowb0Mx?=
 =?utf-8?B?UkZaaSs1VFVRd0tsWjhpZzJCdWhMZDFyWFNEWHJFL3ROMVBGcVNndUtnQnpX?=
 =?utf-8?B?czhrbHpnODB2cmZpQkx3M1luOG00K2lNcUZRM0dleTRycDdGblZ6blRGVUhS?=
 =?utf-8?B?cFFnTUpFOEhYcGRXcDczV0IyOVUyOFhaVHhpUHN4bUZMODF0KzdsSnRGbk9L?=
 =?utf-8?B?TmdidDRMSTdQbnZWRldXRmllejRFbnR3Zm1leHJKNUQxd3BHZUI3S1dNQmdM?=
 =?utf-8?B?RkpqWm1acG13RnkrdW1WUmlQbUE4QnJkOE82eVN0Nkw4em4wVFFITjIwM2Js?=
 =?utf-8?B?eHJEMVpuOFhEa1FtUVFqdTVhVmNkNDFWc2RnQ2pueXdpU2w3dWJtODNEbk5X?=
 =?utf-8?B?YnozU1Y5cUZycENhUjNraDVnQU96dnl6N1p1WVVMYXpxNjdVUmRlL2hoeGxT?=
 =?utf-8?B?Wis0V0tsZzNWalF2ZlB5eHVxYTBSajcwNFBBMlBML3l3SGI3U3g3RzR4WDcv?=
 =?utf-8?B?SlB6Qit2VGUxTXFsUlpIN3RNS3JKcnlJNUM3MjVJY1puLy8vakdWVm9qUWpw?=
 =?utf-8?B?Z29rVVpTcFBwN3FtR3ZLT3I3VS80Z05wbDJJcGwrY3ZvOUVuRC9jSXdVWXUz?=
 =?utf-8?B?b0p4SGZyZ1I0REhzbVlDNDFQV3IyMXhMVmVlazFEMFhOQ2dGZHhub3g5NkNm?=
 =?utf-8?B?TnFlL1pkckJYL0VSSXh3WTZvblZOTzBzTiswT3BuQ2pKeHR6SFFCWWlaWEZ4?=
 =?utf-8?B?c2tVQWdXSDBaeDU3RnovMmlQVEI3eUdGU3pNU2Q0SEVsM1VUbXBzY0ZJZ2Y3?=
 =?utf-8?B?cEJqaE9wYWczYnZvVWdaR3NtWEVvaUdaQzBlTzJ2SVZ6VmFpRUh4YUc3VDgw?=
 =?utf-8?B?NWd5THFvUGVMSS9XVmtIWHprUTNNWldKVWo3U1BqNHd3MHRhVU1ZeWlsSXRD?=
 =?utf-8?B?ZW1uQWFVcEl1cEdzV2lrSUZPclBjT2R1d3pyOTRkV0EwejZEZjc2S3RPenov?=
 =?utf-8?B?Rkg4aXNCblhRUE96RXFPT1V0R0RQYVBZZXZjME9hUUtmV3d5VHN0cFBMam4y?=
 =?utf-8?B?K0hxOEpoSVRyS0RoTGJ3eEI0Y2dXZXZuOGJueHh3VVVoSXNxbzhtVldndHYr?=
 =?utf-8?B?VmRzeU4xNHhMZEVES1JKMzFkOVl1aDlqYWJQaG5LV09PTnBDRUhJTkZmZzY1?=
 =?utf-8?B?V2N4UT09?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f26921a-21bb-44e4-b98d-08db5dca80d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 09:20:52.9161 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E0qPysAwkxFpqh0mbubr3FOnxdjhFiUILlTETfp8+QhC/gKEYhJKkAEujE7teuYbWBD4FIF2RrPl5uton9XR05lrE4F9QVtsEcJNIBGI7iA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7389
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v2 3/5] iomap: simplify iomap_init() with
 PAGE_SECTORS
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <A3C536AD89670C4588FAFD2BBD668825@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

