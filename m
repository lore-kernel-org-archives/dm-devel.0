Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9648FC761A6
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 10:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680172771;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EjpAlJiJblggOxMQoxoh4SCynxUzOkhCed4haRKr7GQ=;
	b=YgRudsTUViUR+vEusabBWFmjoptVXaglOcEdMu3n9gwSThPhyaelTMUfoUbFtg1K12PpuW
	0RW/cO/m08UjAo4Nc6eiG8EImULM1neALYq9AXqp5bhsGVVYtcmHParbn0TcwPWL5YCSZ7
	IUdgZUQbiLN2gDmcODtDMB/Es1Eo+cg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-_RQ3QBypM96UbU9rw0KPoQ-1; Thu, 30 Mar 2023 06:39:27 -0400
X-MC-Unique: _RQ3QBypM96UbU9rw0KPoQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1306D889047;
	Thu, 30 Mar 2023 10:39:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F0C7A492B00;
	Thu, 30 Mar 2023 10:39:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B2C07194658F;
	Thu, 30 Mar 2023 10:39:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBC891946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 10:39:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C35914171BC; Thu, 30 Mar 2023 10:39:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 92E1114171BB
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 10:39:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7153E8028B3
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 10:39:23 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-dk3tIuM2MeOsqi2wSRUAIw-1; Thu, 30 Mar 2023 06:39:19 -0400
X-MC-Unique: dk3tIuM2MeOsqi2wSRUAIw-1
X-IronPort-AV: E=Sophos;i="5.98,303,1673884800"; d="scan'208";a="226872014"
Received: from mail-dm3nam02lp2046.outbound.protection.outlook.com (HELO
 NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.46])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 18:38:13 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB6363.namprd04.prod.outlook.com (2603:10b6:5:1f1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 10:38:09 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%6]) with mapi id 15.20.6254.020; Thu, 30 Mar 2023
 10:38:09 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>, Jens Axboe
 <axboe@kernel.dk>
Thread-Topic: [PATCH 17/19] md: raid1: check if adding pages to resync bio
 fails
Thread-Index: AQHZYmDr2VjhRrc+LkyM5ClXFQvgnq8SbCKAgAC2iwA=
Date: Thu, 30 Mar 2023 10:38:09 +0000
Message-ID: <f636e8cb-ce48-34ff-b60d-deed68cbb3c6@wdc.com>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <e2f96e539befa4f9d57f19ff1fc26cfc0d109435.1680108414.git.johannes.thumshirn@wdc.com>
 <7441afa8-3e60-79cf-66c7-4ddb692c1bcd@opensource.wdc.com>
In-Reply-To: <7441afa8-3e60-79cf-66c7-4ddb692c1bcd@opensource.wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM6PR04MB6363:EE_
x-ms-office365-filtering-correlation-id: 56edfb47-09f2-4d0e-056d-08db310adaf3
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: +C9QrX112ovcAntQrpq3RR46VokdCM71ViHZY9U+r4NgN2GCKC8AAUKF5DB3zToaLe1J5RBaserDbY/ct+Eu/FCyuJbqDfRLnNUCVeFLyeMhxIYS8NAdsuod8fgyJl/hIgyjfNXdYntdXNk3CfzyJOp8flEMRiUypwwXuMvQ0zo6w9tAj8SGlJD05mZKDkLa6K2Zy//PeKnn5xCj8PWX6QQQT1yyt7LbQq4jUyb90DACTYoUWS0NnWQZy2ZbBdkC6Cvcyz2n//ZoRHa5uLRJ8ja0y7P1+k7OZDBOpI24Fjs4gYBK7JPK8u48N4kSaBWXve83WdKIR9jfPPAM03F6hZQhi9nfVmeiPCI8g5QMfvwl9jSq5J9h42CrVUyutm7Y8xhbcSsxdYkytkg7VO7c5l9TohKTf9Up3+KKJ/UFfGCHzATplk9GrxXILO7CgoOxv3CPatPXTt7TIWEJzpOybg/c5Z6o9FFLYinmm4n7bPggEot+hI6HVvSGAoq1Fby6r6VR7GtRNoG4IOrp1l2QyB6qexjeOT+N8YhKfRiUG1DWos/uJIlGmwUxWA1iS7CO1CiQmURHS8/8aovCCLJ+A+V+yUjlOZbXKXfIspqFCDKzLBMae2EK41KZkQM2+xRqHNqYtJwkjSTRKpQHfwUAe1EY3ojbmqD8bo2Mie2h6iB15Q+RooRE4/oNQuiszeKf
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199021)(2616005)(2906002)(26005)(53546011)(6512007)(6506007)(478600001)(36756003)(186003)(38070700005)(71200400001)(110136005)(122000001)(8936002)(66556008)(66476007)(66946007)(4326008)(64756008)(66446008)(76116006)(91956017)(8676002)(31686004)(316002)(41300700001)(82960400001)(54906003)(31696002)(6486002)(5660300002)(86362001)(83380400001)(7416002)(38100700002)(45980500001)(43740500002);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEw1a09Ocm1BV3hmUFVwTFZUNXJVTW14cnJaK1V0N3hjc1ZQQy9oaEtCRTJI?=
 =?utf-8?B?TnJEdEZvL0hMMTUzejhaekxkOGhNVWpDK2RlTVdHU0Fxc1ZQb1J3YUtJM0tp?=
 =?utf-8?B?Z050SkZqNE1BTWVXTEpjbEhLek84c2FEYkRGVlAyc21Na2RET3hHVjcyaFQ5?=
 =?utf-8?B?YlB6WHRKTlV0ZXNhU282YUs0Qk53ZCtqZmpJMkNlOUtwZXdTZWJWOVJ1aUls?=
 =?utf-8?B?NWRiV21qTmlYNHJNUlpvKytCNVdudjJsM256eGNSQWtHWmp6ejk2Y3k0bW9P?=
 =?utf-8?B?aTZZbVNzeTF3UUFZN0Rhby91bEVpUkpQdmY1bXlMVmM4NXZ0Y2lSTXZtZExF?=
 =?utf-8?B?Tm1qRHovSnZJNG53S04zYWFvVEtQWWNOekxPQ0RLT0hGVDV1VjFobFRmNGUr?=
 =?utf-8?B?TWNYVmdZdFFZbWZWZzk1MEFMZUdiZllVSi9wa0FpdkJodlVlTnBkRkl4RDkx?=
 =?utf-8?B?eC82eTF1UGtnODlPaG1YUHA4ZEVXT0lnSFU0QjBzcEIwZ1N3Y3lvVHlxUVZs?=
 =?utf-8?B?aWNTMUVFaEM1NGxRWXJsc2VUNm9peFJubFVXWmxYSDdsMUcvdmZaQS9WcTNG?=
 =?utf-8?B?dHBpaXRwR2RIUitRV0NCUFZmYWVNZ2tUTkhmRmJQNFdxaEJQcnlOTFNHS0pn?=
 =?utf-8?B?SDJxSkwvVmpnU25wRGRBYzd1TXpnUHZqYW0yb25Gd3JpWW9DSHBTamFubEgz?=
 =?utf-8?B?Z29pVFRDQ3pPNExXanlVdXd3Y3VXWTJpdzRiT3lmZVlvcFh2dXNEOURKNGhT?=
 =?utf-8?B?bndSWEkrRFVCWnRGNHpnaHl5Z2ppQ2wrSGdWWnFQRjFKVnZmMm0wVDZWVURL?=
 =?utf-8?B?Vng3WkwvRnRNT3RrVzNDVlppbVRRYU5VWllkbURQbFpxa3A1WkZkWUVYbGht?=
 =?utf-8?B?UUxMWEt6cklUVG5ueS8rRStMaEtpTnF3Zklpc0dpMkpZQThJYnFvVTdZTXZp?=
 =?utf-8?B?RVVJRitsNG1zYjBBUFBES2ZkazRjeWZYNFVRbTk5eldnRmlLdW03M0lmaUVu?=
 =?utf-8?B?eWFpRkNtb0d4Uk5KWk9heFJXTFk1djZkZlJ5V3diZEhoR3BZOXhXQ2xsMGlG?=
 =?utf-8?B?Y1dpR3c4WExxQWFTQU5CaFg5aFFlY0R3eFdFaEcrQWRzQ0psUitDcjl4NG1R?=
 =?utf-8?B?RTk1MTVCNllzMzJsOWtKUzBXYk9zdjJ5VGgyUStWbUluNnFnbW1vSEJuamRF?=
 =?utf-8?B?R3VhZ3RndlFIOHdnS3J4SktNRzJBbGJkdm5YMVRKVys5QWozeCtqb0ZublRV?=
 =?utf-8?B?anpLdk1MRUdvNlNFaGw0cDJQZFN3OTM4SjB5UEgwbjdUb1JieDd1NTJuYWxD?=
 =?utf-8?B?ZmkvVjZISGZVWmhmL2NhU0VwRllpc1lBSnl5N3NLSFo0TmxhYWFoMTNadEZB?=
 =?utf-8?B?YzRKY1hsc1d5TERFQmlTZjB5NlFuZTNaRzY5VE5PNFdSdmo5WURmbUtHcjVs?=
 =?utf-8?B?bTRLSG5obHJSSG5XblNLbkR0Qm5CNEFoUVNKaGt2WnFFSHp1eU1pa2Y1WHRj?=
 =?utf-8?B?WmFrWnJ4elRMd0xyZnVGN1oyUW93eG84ZXVVOEpZQXpoQmlnVllHY21jLzdH?=
 =?utf-8?B?UXFCM050NjNCb2ErQU5PTFNNS3BvSnJ1Zk0xaEw0Vm1UaWxBWmJZQ1ZBeHAr?=
 =?utf-8?B?aUJDQ3l4bnBOU1RvU3BONmVRSkl2Y0ZlU011dGlhM0VWZ1c2THY3YmJyR1ZM?=
 =?utf-8?B?ak5hR0E3SGxXVjdweXUwL2c0bWsxSjJQeUJMTXREa2U0eGtNcTNNUzFWQWpx?=
 =?utf-8?B?V1NrZjdwTGs2RkNEaFJKUWRlRUw2M0cxVUZkdlQ1cEJGZnlBdG5tbzg5SGFO?=
 =?utf-8?B?a1Z6dzNnVlZ3UUdRem5MNXlWL09iZ0dVVkdTbXhINkFadEZ2WFVmYzM5NGlW?=
 =?utf-8?B?VEhBVzJod0paTm1haFJISUdCTnBkc2NhY0lnbXZ5VHRjN2xxd1cra2pvVmZy?=
 =?utf-8?B?aG1xQzdrSDZTdFcrNWpuLzdCV0w2Z1hTUmdIdGUzNlBMSVdnL3RqY1dhVGVN?=
 =?utf-8?B?TWFRNTRqOGxjRzM2d0J4Uy9oMDQyVHlVMFBVVzVMYVdVZEVpcUhSQURvYTBs?=
 =?utf-8?B?YmNaaCsxMFlkSzQ5M2RwU081WU9zVWRadVcweElZVWV4d0paRHdwY2YwM2dY?=
 =?utf-8?B?QWNoVUZQV1NqL1o4emtWc3VtSU9TcFNMRWVsRnB4L0pxMzZPNk9UNDQ1OTB1?=
 =?utf-8?B?ZWc9PQ==?=
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Wm84cm1HeTN1YS9sUStnaEFwL2hSaWp6WEl5L3kzSitTa3RoQ1QxQXM5Slhp?=
 =?utf-8?B?ODZCUnZ6Y1JQRlA3U1ZxTmphWEl2M3FQSGhOSzBDNkppaFEwenM1RHVxV2lI?=
 =?utf-8?B?alcrUjJtOUpZQ3JNNnN5RTFXUnBmbk1IRzdlb1lHSGtsZ2w4eFdJdU01Zk1I?=
 =?utf-8?B?bEp4ZS9EUjg0TjAxT0VnSjFJK2dYeE1NYVVPQWt3TXVURlhxWWIwZ1NtOHlW?=
 =?utf-8?B?WnJnWS9LTVBRcWx3eExYU0lRYzFLRzdod2JtS3BCUjdpUjVGd0Q4RTdMU0RY?=
 =?utf-8?B?UERrOVNScWpmanltRlBOTnN1N1I4aHVRWGVpRUY4T1ZEOUorU090MjJaSTJj?=
 =?utf-8?B?eU0yaGJFY3VQSmIwdHBOV0xMNUN0clZZNUphVFJocldoVjhlM3JLM2xLZW9x?=
 =?utf-8?B?bmFhZ3FWTkhSSkp2WVh0WkY2bmdWRldlL2R4aXR3QUtEdElQcktqS0JJSE9m?=
 =?utf-8?B?eU8zT2psM0ozRXRpN0NlUFlHaUNZNXQ5MUFJZXdPSUFIbW9CQ1dhTEYwZis4?=
 =?utf-8?B?b0xaUGVGMmQ0QkVFdWtGbEdHZHdLSzJlL3ZqUHdyaytEbCtqY3lZZnhkSlpr?=
 =?utf-8?B?V0ZRcWd5S1I3eWplK2RGdlI2b2ZpTmVtTVJMMmJPYnZ3MTJwcEswbG1VZkJj?=
 =?utf-8?B?VVNBQkpjOUVNelRNREFBb1E2WkkxMHdJcWhQeHpOcTF0US8wMmxwSEd5SjNT?=
 =?utf-8?B?M3EvMWdXSEhibjVnbkRKWkhEZ3FIek9ld25rSnNXOWUrbVJXQ0YzWEtYamFM?=
 =?utf-8?B?QUVXMlBBL0VXbnQ3NnRlT0dOTnMwU1k0ZndTeWl4Q1JWZEl6NXcrTXNFbU1u?=
 =?utf-8?B?Z1M0aHh5RWlBMXFMYmZmenc5Z0VKejcxUG1zL1BLRmtYODFkWWwxWXF3Yzl0?=
 =?utf-8?B?clpmd2c0WlNvNVdIa0J3VGFLaHd0V1lUdDBpK2g1VmE1RkNZUEkxME5qclBa?=
 =?utf-8?B?OHdvNllkTU1rWlEwWnA2MkpzcXhZRTljbEd3TFJtZGs3UlR0eWZObnBzU1pC?=
 =?utf-8?B?c2VaTVZsMWN0dUxhRXRyaDlYaUkyMmVaM0ZDT3BwMFVHV1pjb3BYVFBsL2hB?=
 =?utf-8?B?YlV0R0t2dXB2TlBXK0I2dFZLbC8vamZsKzBSWDRualQyK016aXhIclhSZXJD?=
 =?utf-8?B?OXZOMlFPaDZabElzekNZaDlGQjZVcjNmNDNVSlljeTk0V1FGdkVBV1NGUDlG?=
 =?utf-8?B?NFJmdEVkYmhROFVJMFVuNjExWkU4YnJKcEx3b1VYQy9qM01WaVkvTGZoSXRR?=
 =?utf-8?B?VjZiYjk5WEZKNXpINUdVcUdJMlQvemxTcnFmVTB3VXNON3JpTFQzT2ZTd2ov?=
 =?utf-8?B?Tm9GZ0UxOGw2aHZ0UzYxSEQ4bGRqM2RzZW5CRkFJQXh2am9jQVRtUkVNNEV1?=
 =?utf-8?B?dFRmR1JhZnc3ZXhUcGFPekdCdUZiWFlleklrWnBNYnJXeTBjVFc2MFRHdnZ0?=
 =?utf-8?B?MFdRemNqYW1DbHZidCtMeHYzKzhHemN6b0xlU2t3PT0=?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56edfb47-09f2-4d0e-056d-08db310adaf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 10:38:09.5572 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6qiJ9NY9ahPLhKugJnwOs29UsZiH3QjyzsWse5lDwVHnwPrM7vZcZcCBv/V2KRkP2aw7ctBP5Q7ijTEFvTG3A/XQM4KhhfPnTa5HweVGeNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6363
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 17/19] md: raid1: check if adding pages to
 resync bio fails
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
 "jfs-discussion@lists.sourceforge.net"
 <jfs-discussion@lists.sourceforge.net>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Song Liu <song@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
 Mike Snitzer <snitzer@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Ming Lei <ming.lei@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, David Sterba <dsterba@suse.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Christoph Hellwig <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Language: en-US
Content-ID: <9D17791D59AAD54D8EB13FD6F0697939@namprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 30.03.23 01:44, Damien Le Moal wrote:
> On 3/30/23 02:06, Johannes Thumshirn wrote:
>> Check if adding pages to resync bio fails and if bail out.
>>
>> As the comment above suggests this cannot happen, WARN if it actually
>> happens.
>>
>> This way we can mark bio_add_pages as __must_check.
>>
>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>>  drivers/md/raid1-10.c |  7 ++++++-
>>  drivers/md/raid10.c   | 12 ++++++++++--
>>  2 files changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
>> index e61f6cad4e08..c21b6c168751 100644
>> --- a/drivers/md/raid1-10.c
>> +++ b/drivers/md/raid1-10.c
>> @@ -105,7 +105,12 @@ static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pages *rp,
>>  		 * won't fail because the vec table is big
>>  		 * enough to hold all these pages
>>  		 */
>> -		bio_add_page(bio, page, len, 0);
>> +		if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
> Not sure we really need the WARN_ON here...
> Nevertheless,
> 

I see it as a kind of assert(). It shouldn't fail but in theory it can.

> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Thanks

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

