Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D402C6FA90
	for <dm-devel@archiver.kernel.org>; Thu, 29 Sep 2022 07:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664435224;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iHcYXkVkg3H0PuedEdWw+zbO3tkjGQkZDtkKM+Z+2qc=;
	b=NT0tZBUnrfovD5x+0S3qVAzhD8TJuaOJt3rtx8E42v93OwuuN+Xj94Hr02WeDShptA2yJY
	48q9Wnyv1R/xk/2K1qMSP4AtHFCOdtcZKqFyXrcxyPTMn4BR0/TEInBb58WvdA9JgGuGtJ
	OkXnVOSyrzihsipXf1Z3JAVssYBRiuc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-4QqeH-FZMQ6-VjPnacsxWg-1; Thu, 29 Sep 2022 03:07:00 -0400
X-MC-Unique: 4QqeH-FZMQ6-VjPnacsxWg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7553D800B30;
	Thu, 29 Sep 2022 07:06:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 638844A9257;
	Thu, 29 Sep 2022 07:06:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C6C9A1946A5A;
	Thu, 29 Sep 2022 07:06:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D988F1946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 28 Sep 2022 07:34:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD7A54A9265; Wed, 28 Sep 2022 07:34:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B574B4A9254
 for <dm-devel@redhat.com>; Wed, 28 Sep 2022 07:34:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 94B0980A0AE
 for <dm-devel@redhat.com>; Wed, 28 Sep 2022 07:34:50 +0000 (UTC)
Received: from esa10.fujitsucc.c3s2.iphmx.com
 (esa10.fujitsucc.c3s2.iphmx.com [68.232.159.247]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-H5MxCtV8MWiyqNn1WW63yw-1; Wed, 28 Sep 2022 03:34:48 -0400
X-MC-Unique: H5MxCtV8MWiyqNn1WW63yw-1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="66319839"
X-IronPort-AV: E=Sophos;i="5.93,351,1654527600"; d="scan'208";a="66319839"
Received: from mail-os0jpn01lp2110.outbound.protection.outlook.com (HELO
 JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.110])
 by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 28 Sep 2022 16:33:40 +0900
Received: from TYWPR01MB10082.jpnprd01.prod.outlook.com (2603:1096:400:1e3::8)
 by TYCPR01MB10527.jpnprd01.prod.outlook.com (2603:1096:400:302::8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 07:33:38 +0000
Received: from TYWPR01MB10082.jpnprd01.prod.outlook.com
 ([fe80::9286:7cff:c119:cbce]) by TYWPR01MB10082.jpnprd01.prod.outlook.com
 ([fe80::9286:7cff:c119:cbce%7]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 07:33:38 +0000
From: "y-goto@fujitsu.com" <y-goto@fujitsu.com>
To: 'Jeff Moyer' <jmoyer@redhat.com>
Thread-Topic: Question about which types of dm need to support DAX
Thread-Index: AQHYyZmSEdOf4g6tS0+IDu58NikMFq3yLttUgAEbMQCAAB9gf4AA9KuQ
Date: Wed, 28 Sep 2022 07:33:38 +0000
Message-ID: <TYWPR01MB1008258F474CA2295B4CD3D9B90549@TYWPR01MB10082.jpnprd01.prod.outlook.com>
References: <e0cce6af-fd55-a582-194e-7f8a3aced6b0@fujitsu.com>
 <x49y1u5lxpt.fsf@segfault.boston.devel.redhat.com>
 <a04a8253-44af-11d6-f2ab-6421fe5110a8@fujitsu.com>
 <x49tu4sc26t.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49tu4sc26t.fsf@segfault.boston.devel.redhat.com>
Accept-Language: ja-JP, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: dc83b8b342664f7d9cc51c5486a42f05
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
msip_labels: =?utf-8?B?TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2Uw?=
 =?utf-8?B?NTBfQWN0aW9uSWQ9NjE4NzQ1YzAtZWU5ZC00NDVkLTllMWQtNzgyNTY1MTgx?=
 =?utf-8?B?YjBlO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF9hNzI5NWNjMS1kMjc5?=
 =?utf-8?B?LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRmZWNlMDUwX01ldGhv?=
 =?utf-8?B?ZD1TdGFuZGFyZDtNU0lQX0xhYmVsX2E3Mjk1Y2MxLWQyNzktNDJhYy1hYjRk?=
 =?utf-8?B?LTNiMGY0ZmVjZTA1MF9OYW1lPUZVSklUU1UtUkVTVFJJQ1RFRO+/ou++gA==?=
 =?utf-8?B?776LO01TSVBfTGFiZWxfYTcyOTVjYzEtZDI3OS00MmFjLWFiNGQtM2IwZjRm?=
 =?utf-8?B?ZWNlMDUwX1NldERhdGU9MjAyMi0wOS0yOFQwNToxMDozN1o7TVNJUF9MYWJl?=
 =?utf-8?B?bF9hNzI5NWNjMS1kMjc5LTQyYWMtYWI0ZC0zYjBmNGZlY2UwNTBfU2l0ZUlk?=
 =?utf-8?Q?=3Da19f121d-81e1-4858-a9d8-736e267fd4c7;?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYWPR01MB10082:EE_|TYCPR01MB10527:EE_
x-ms-office365-filtering-correlation-id: b1ee90eb-49b0-43d5-863b-08daa123c279
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: O2P/nRskXD6+C9T4+RGMjTP34wwAAwJP8YBhTebtlUUgsVQ8zHPC6e/hjm4URx7biSJpWfSVpVIrFrtzRIgNs6ZSn+ohCKVyTRxQVcXqGnV2A1IE1cs5JMCjUVPNWtKSb5Xu6RDgtvMOJWS8R2ij0Xff9oHysneE70DHnAHnpJVzEC76diCLYtU0MJbkfYFIqqy83ZjCo7yeRtpVksSHtHcr9Q5P1UL4KJxazEYvuFXdCcbmkBZ/fneMRapjNrdJ37DcTHYnP1Qc04kUIaGynEsyBxtIkGBxIK13ze/dumSS9AUdU6mjfg3T0DlegB90DK+GUZIexM1bpzC6LbKp7eoq82FCZVTNqvgstM35hOEEfevya1vvmpO/iGj71rlJVydnqS472VLm71p1Wb1DYe5IVsSPeqnz5DLg7C+MCMh1RqcVH2ewY9oPOQpwXp5Eip/ngDezBgOszFQv7aPyC+M3ON/9YGrfVSF37aCJ04uAu44I8bgRqbEX4gdqRPmJAOSrjWXJqDQHN1isW4HF1E3wULwRPyvP7/kIy9UYGn4JfMl9ux7+ZO/5bZ4bshlJsDbo8g7tZZAdJxt2qp3vTtrWtDmEBo5YbPJ33rEJUma30XZcyCcRmkHqznxlql3LMFOwMu2bbp7huy9KCgjr42FIPD65cU7eCdgVnEPOQWwmwdF0/jIXX3aYPVxC79+pTbjlFS1LqK4loZKg2pGy+6IY304/jdpWCHiFIE9jPNw9S0d1jyUETe5aQB5eXIEDHh/r2hUJW6mwP9rDERY5Sz06b1I4D5nXVx4ucwyzFQw=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:TYWPR01MB10082.jpnprd01.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(1590799012)(451199015)(2906002)(122000001)(38070700005)(66446008)(66556008)(41300700001)(66946007)(4326008)(66476007)(8676002)(8936002)(85182001)(5660300002)(76116006)(33656002)(52536014)(64756008)(38100700002)(54906003)(1580799009)(86362001)(82960400001)(316002)(478600001)(6916009)(71200400001)(26005)(55016003)(53546011)(9686003)(7696005)(6506007)(107886003)(186003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnJxVUJKbkJwd3d6WWQwWGNuS094OEFGN0RuTGptNnVMY2hUK0hSR1RLMFdv?=
 =?utf-8?B?N3F4VjR2bVc2ZTNrUXBOeXZZcWpOM1hRQnJ3N3RLc1BSMXlyRkFhYVNWNU1j?=
 =?utf-8?B?NDN2Y3VVcHRYNmU5Mnllb0svb1FNU1pKWjI1MzBSQitZZzFKa2ovWnZUemZY?=
 =?utf-8?B?Rlkwa0VNQVd1MWw4NFE3NVM1QWdsWHU0M1U5Sk5uYnpxTWVsZDRuOUFpaktk?=
 =?utf-8?B?TDdjck9DYjdua2tyeEszZGtIUFVSVVNEMHVEQ29tUXhBY3g3cm82OTFDVm4w?=
 =?utf-8?B?QVJyNWN2bjJDODVxRm4xVmhDVU8vc3N0UTZRSFFRY0JsWlBpSTlJUDRQVU9W?=
 =?utf-8?B?Mm84ODYvRDI5ZXhXMm13UFliUDNjMS82dE1IS0ZNZ3NiV1Y5V1VPVUUzY2U4?=
 =?utf-8?B?cGRRVmFHcmxycjNHRThkcnRPQTk0cFhJWm01Z2w0MVcyVm5INlFmdHFCblRw?=
 =?utf-8?B?WWxhOHU4YUdISGd1d2l3N3VYZ3NiRHZsajZTaFYydTNBWHBqTFJXK0FPN3BZ?=
 =?utf-8?B?cWt4VE1FbGd1R2JXc3VHU0hTNXhYMnRZRHY0ZEEzRHVoUUVYdys1WFJpVmxk?=
 =?utf-8?B?S2NiUi9hc0FhWG1RVVNycGdKRnl4cG51dlJFMm9rcWlWaDJDYmJaT2gyaUd1?=
 =?utf-8?B?T21DbFBpQ0xBanp4d0tvb2xyM3J6RCt3NW9OSSszeSs5c3ZCSmlTeFhKR2tM?=
 =?utf-8?B?ckNaajFaNm16L0JLYWpMd3hySFNJQkFnYXNFMnBHQ21iVm9XK3lnVzROMkNs?=
 =?utf-8?B?eWkrSms3enNKNlNJMHlVR3M5SllWMCtuQ0c0a1JOa0I5eVErSnliTENhV21i?=
 =?utf-8?B?Tm16R2diVkZDNUluUStZclFEeVZWSTNFd1RWWHZqS25GY0N6bExHTHZWUTR6?=
 =?utf-8?B?UHpHN3lncmU0dXlTaUp6clNlczhqMlJNNFF0RFBpbFIyNllJN2MzTDFib3Rj?=
 =?utf-8?B?VlpxbUNtM05wZTNuTG1QRzk0c21hV3l4NkRUc0xUbmx5UlMwRVFYOVNvTWxo?=
 =?utf-8?B?b24wMnRmWlFWNktQVHRCWUZ6TW1iSElLOHFKc0VWTzZkTDN2M3d3YlJNVkxr?=
 =?utf-8?B?b1gyb3p4M3lRWFoxNHZ4WjFrcjFDRE4ySWVlOWt4M00xLzVnc3NselVNcHFq?=
 =?utf-8?B?bXlBa2pFaENPK3FrbWhHZGVieUx0VHB4WDNWSDkvZWdITmgzd1NHdUp3SUhz?=
 =?utf-8?B?dDYySUUzcTV3RVpOVjdWU2JjcXBJbUdxbmRkTWg3RnIzdlJVNitHSk1yZ0pE?=
 =?utf-8?B?K3dZQnJnRVJsZHF2WDg4WFVGSmF3UTJsSjdGTjJnNmQveXp3TndSdTUraThZ?=
 =?utf-8?B?RGUyRWwxdmpPb3J1enpTYlRlNXBXbnJvVWcrUjB1RGN4Zm9admxkaG9ka0xV?=
 =?utf-8?B?aXNKVFRoWHJLZEVGU1ZZdUljT3NqUGJDOGtacFE3YUE1d2hIczFlTUtIOVIx?=
 =?utf-8?B?Z2V2ajhzSjVYOFVBOXpMbDYxcW1UYjZsUkFOTDA0Mmd2dGV6NjVwK0hsc2kw?=
 =?utf-8?B?OGV4VHJOWEdPRnZmanlJei9oUnBpQjFaSFcvOEdKMUgxanhjODZjc0J1MFRz?=
 =?utf-8?B?T05ZNjVUUDFHYjZNZjJCL1lxOHRXWHVKeFRqcGgza0RjcUh6aS9GbGw2bzIz?=
 =?utf-8?B?NUFtMnlpci9BaGdtTzJmaFhBc29HanBxak5TQktGS3NwemhPTksyNFhwcXZE?=
 =?utf-8?B?azMvRzltQjdkSGFDcEZpS3dmWGoyREJjM2x3cDc4YlZEb1IzWUx2L2VSMWU5?=
 =?utf-8?B?T3BjVDMyMWhGeHBGNS8zbWZNV0diLzZoTlBvR1Ixcy9JWUF1YVFOYWJTZC83?=
 =?utf-8?B?ODY4QnQ5YXlUTEpTOEcwMjQ3M0p0a010aHZaRzY5dXl0ZUpRZU9SRFF2SkRC?=
 =?utf-8?B?TkROQkZLMUNHVEZySm1FTURwWVZUREU3amkwMFZBK0FuVURUY2xPbnNSTExx?=
 =?utf-8?B?S1ZMQ0dGWVR0anJnSmtEak1iR05XaGh2VlBXc016b2w4WjMzQXFpcEh1aDlh?=
 =?utf-8?B?Z2UwN1ZBa2dNYTNJRkhhZWE0V01JV2JnTlllTG5QOHJYSDlzYTJaTXNFK3Bs?=
 =?utf-8?B?elcza0w3OXBhczgxcTZKbVJyVERLd0c0ZmlidmZZQU4vMnlkOWZlaTAwby84?=
 =?utf-8?Q?IWgZEFNM/vZq6gSYcO380y/1E?=
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB10082.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1ee90eb-49b0-43d5-863b-08daa123c279
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 07:33:38.4705 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DwsbASfAXIMplVo0vn840GU7bnca9zj/zqbYwo0/wTJNFP8C/WVRkyF9+HTqfnUBGKkYh4OBQkonLr3cTmT7zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB10527
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 29 Sep 2022 07:06:56 +0000
Subject: Re: [dm-devel] Question about which types of dm need to support DAX
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
Cc: "toshi.kani@hpe.com" <toshi.kani@hpe.com>,
 "snitzer@redhat.com" <snitzer@redhat.com>,
 "yangx.jy@fujitsu.com" <yangx.jy@fujitsu.com>,
 "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "gujx@fujitsu.com" <gujx@fujitsu.com>,
 "zwisler@kernel.org" <zwisler@kernel.org>, "agk@redhat.com" <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: ja-JP
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGVsbG8gSmVmZi1zYW4sDQoNCj4gIllhbmcsIFhpYW8v5p2oIOaZkyIgPHlhbmd4Lmp5QGZ1aml0
c3UuY29tPiB3cml0ZXM6DQo+IA0KPiA+IEhpIEplZmYsDQo+ID4NCj4gPiBUaGFua3MgYSBsb3Qg
Zm9yIHlvdXIgcmVwbHkuDQo+ID4NCj4gPiBPbiAyMDIyLzkvMjcgMzo1MiwgSmVmZiBNb3llciB3
cm90ZToNCj4gPj4gIllhbmcsIFhpYW8v5p2oIOaZkyIgPHlhbmd4Lmp5QGZ1aml0c3UuY29tPiB3
cml0ZXM6DQo+ID4+DQo+ID4+PiBIaSBSb3NzLCBUb3NoaSwgSmVmZiBhbmQgb3RoZXJzDQo+ID4+
Pg0KPiA+Pj4gQWZ0ZXIgcmVhZGluZyB0aGUga2VybmVsIHBhdGNoZXNbMV1bMl1bM10gYWJvdXQg
ZG0sIEkgdGhpbmsgb25seQ0KPiA+Pj4gdGhyZWUgdHlwZXMobGluZWFyLCBzdHJpcGUgYW5kIGxv
Zy13cml0ZXMpIG9mIGRtIGNhbiBzdXBwb3J0IERBWCBub3csDQo+IHJpZ2h0Pw0KPiA+Pg0KPiA+
PiBSaWdodC4NCj4gPj4NCj4gPj4+IEkgd29uZGVyIHdoeSBvbmx5IHRocmVlIHR5cGVzIG9mIGRt
IG5lZWQgdG8gc3VwcG9ydCBEQVg/IElzIHRoZXJlDQo+ID4+PiBhbnkgcmVhc29uL2hpc3Rvcnkg
YW5kIHVzZSBjYXNlPw0KPiA+Pg0KPiA+PiBJdCB3YXMgZWFzeSB0byBhZGQgREFYIHN1cHBvcnQg
dG8gdGhvc2UgdGFyZ2V0cy4gIE5vdGUgdGhhdCBpZiBhDQo+ID4+IHRhcmdldCBuZWVkcyB0byBp
bnRlcmNlcHQgSS9PLCB0aGVuIGl0IGlzIGZ1bmRhbWVudGFsbHkgaW5jb21wYXRpYmxlIHdpdGgN
Cj4gREFYLg0KDQpJIHdvdWxkIGxpa2UgdG8ga25vdyBpdHMgdXNlIGNhc2UuDQpUaG91Z2ggbXkg
dGVhbSBoYXMgYmVlbiBtYWRlIGVmZm9ydCBmb3IgYSBsb25nIHRpbWUgdG8gcmVtb3ZlIGV4cGVy
aW1lbnRhbCBvZiBGUy1EQVgsDQp3ZSBzdGlsbCBuZWVkIG9uZSBtb3JlIHRpbWUgdG8gc29sdmUg
dGhpbi1wb29sIChvciBvdGhlciBETSBmZWF0dXJlKSB2LnMuIERBWCBwcm9ibGVtIGV2ZW4gaWYg
aXQgaXMgZWFzeS4NCg0KVG8gYmUgaG9uZXN0LCBJJ20gdW5kZXIgY3JpdGljaXNtIGZvciB0YWtp
bmcgc3VjaCBhIGxvbmcgdGltZSBhbmQgc3RpbGwgbm90IGJlIGFibGUgdG8gcmVtb3ZlIGV4cGVy
aW1lbnRhbC4NCkluIGFkZGl0aW9uLCB0aGVyZSBhcmUgYSBmZXcgcGVyc29ucyB3aG8gaW5zaXN0
IEZ1aml0c3Ugc2hvdWxkIHN0b3AgZGV2ZWxvcG1lbnQgb2YgRlMtREFYIGR1ZSB0bw0KdG9vIG11
Y2ggdGltZSBmb3IgZGV2ZWxvcG1lbnQNCg0KSSBob3BlIHRoYXQgbXkgdGVhbSBjYW4gY29udGlu
dWUgdG8gbWFrZSBlZmZvcnQgZm9yIEZTLURBWC4NCklmIHRoZXJlIGlzIGEgdXNlLWNhc2Ugb2Yg
dGhpbi1wb29sLCB0aGVuIEknbGwgYmUgYWJsZSB0byBwZXJzdWFkZSBzdWNoIHBlcnNvbnMgYnkg
aXQuIA0KU28gSSB3b3VsZCBhcHByZWNpYXRlIGl0IGlmIHlvdSBjb3VsZCB0ZWxsIG1lIGFib3V0
IHRoZSB1c2UgY2FzZS4NCg0KVGhhbmtzLA0KLS0tDQpZYXN1bm9yaSBHb3RvDQoNCg0KLS0KZG0t
ZGV2ZWwgbWFpbGluZyBsaXN0CmRtLWRldmVsQHJlZGhhdC5jb20KaHR0cHM6Ly9saXN0bWFuLnJl
ZGhhdC5jb20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbAo=

