Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE275C7EE29
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686120550;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=VT9XsC2KtWknyL7QFhOjC6EsqnBZ9kZ6XtXAkU/kTSE=;
	b=CENS02PeEV3+Gybp5rchj5O6/+4iwh8/lOZoIafuq74U5gTpdkxLwlU3qym9yJrKELjvFK
	Z4556a6iHwts+mJeJXn02WwKtn5+kbrhxq2JEwYz9nmwSsKmPrXOysdd4uefY/3xJkAwuK
	QMS9SilWgcHuX30Qb4f0fBoFU7vyIck=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-juud5SBMOh6PJyAGgprVRA-1; Wed, 07 Jun 2023 02:48:57 -0400
X-MC-Unique: juud5SBMOh6PJyAGgprVRA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB108280D5AB;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A5C534021AC;
	Wed,  7 Jun 2023 06:48:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1D96719451D9;
	Wed,  7 Jun 2023 06:48:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CD6FA1946595
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 08:38:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D7CA140E955; Tue,  6 Jun 2023 08:38:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 93FB1140E954
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 08:38:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FFAA3C0C89C
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 08:38:03 +0000 (UTC)
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com
 [216.71.155.168]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-67-fQb3VdfiPYyVjeD4K2IJdA-1; Tue, 06 Jun 2023 04:38:01 -0400
X-MC-Unique: fQb3VdfiPYyVjeD4K2IJdA-1
X-IronPort-RemoteIP: 104.47.59.174
X-IronPort-MID: 110488757
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:U0VeX6uudYvvsIKg6EibXS7RyufnVBReMUV32f8akzHdYApBsoF/q
 tZmKWnVMvmKa2v3KYxza4nn9kJS7ZTQxoBnS1Bu+CE8Qi8X+JbJXdiXEBz9bniYRiHhoOCLz
 O1FM4Wdc5pkJpP4jk3wWlQ0hSAkjclkfpKlVKiffHg3HVQ+IMsYoUoLs/YjhYJ1isSODQqIu
 Nfjy+XSI1bg0DNvWo4uw/vrRChH4rKq4Fv0gnRkPaoQ5AGGySFMZH4iDfrZw0XQE9E88tGSH
 44v/JnhlkvF8hEkDM+Sk7qTWiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JFAatjsB2bnsgZ9
 Tl4ncfYpTHFnEH7sL91vxFwS0mSNEDdkVPNCSDXXce7lyUqf5ZwqhnH4Y5f0YAwo45K7W9yG
 fMwKS8sXhCBiMaP2K+dFOtKqON/HNPNBdZK0p1g5Wmx4fcOZ7nmGv+PyfoGmTA6i4ZJAOrUY
 NcfZXx3dhPcbhZTO1ARTpUjgOOvgXq5eDpdwL6XjfNvvy6Pk0osgf60b4a9lt+iHK25mm6Co
 W3L5SLhCwwyP92D0zuVtHmrg4cjmAuiAdpORO3nq6ECbFu7/VMfCxIvEnmAntLmjVbhZfx7d
 xE15X97xUQ13AnxJjXnZDW0rXuFlh8aRdtLEuc+5R2Ny6zb+AKQDC4PSTspQNU2vsg7bT8nz
 FmEm5XlBlRHubKWYWiQ+redsXW5Pi19BXQEZDMWQBEt4NT5pow3yBXVQb5LHKvwgtDrFDXY2
 T2GrCEiwb4UiKYj0qyh+FndjjGEp57XTxU07AHaQmKk6AxiYIevIYev7DDz6fdGMZbcRF2Gt
 3sshceT9qYNAIuLmSjLR/8CdJmt5vCYIHjfjERpEp0J6Tug4TigcJpW7TU4I11mWu4UdDmsb
 ELNtAd54J5IIGDsfaJxe5i2Cckh0e7nD9uNaxzPRt9HY5w0eArZ+ihrPBSUxzq0zxRqlrwjM
 5CGd8rqFWwdFals0DuxQaEazKMvwSc9g2jUQPgX0iia7FZXX1bNIZ9tDbdERrlRAH+syOkNz
 +tiCg==
IronPort-HdrOrdr: A9a23:Rni8VaGk7tZ61vHTpLqE5seALOsnbusQ8zAXPiFKJSC9F/byqy
 nAppsmPHPP5gr5OktBpTnwAsi9qBrnnPYejLX5Vo3SPzUO1lHYSb1K3M/PxCDhBj271sM179
 YFT0GmMqyTMWRH
X-Talos-CUID: 9a23:EGByWGARkXvMDqL6Eyh41X4UGM8BS2XA6inSBWGfVVZzboTAHA==
X-Talos-MUID: 9a23:05hwbAQhELPH2ubTRXTXuz1hO/4vwZ+RIx8Kico4le3YaA1vbmI=
X-IronPort-AV: E=Sophos;i="6.00,219,1681185600"; d="scan'208";a="110488757"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO
 NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
 by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 06 Jun 2023 04:36:57 -0400
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com (2603:10b6:a03:38d::21)
 by SJ0PR03MB5406.namprd03.prod.outlook.com (2603:10b6:a03:28e::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 08:36:53 +0000
Received: from SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd]) by SJ0PR03MB6423.namprd03.prod.outlook.com
 ([fe80::192:6bdf:b105:64dd%3]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 08:36:53 +0000
Date: Tue, 6 Jun 2023 10:36:46 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
Message-ID: <ZH7wHiiF/OVu1W8D@Air-de-Roger>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-16-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-16-demi@invisiblethingslab.com>
X-ClientProxiedBy: LO4P123CA0522.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::8) To SJ0PR03MB6423.namprd03.prod.outlook.com
 (2603:10b6:a03:38d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6423:EE_|SJ0PR03MB5406:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bc6cd94-e85a-4b89-e85d-08db66692da7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: KWIx7PcSlhZ1Tc77A7sOHXjFJZXa9ygsaQZOSahd/K2lU9zBigdk8+OiEnG2d2PRwEdYlGinWF2KdYCb2szuIqCN9pxJvb/RC3kNlgLe5uw7VfOBnFmXuPXA30yq4gQHvdZzpk60Tq3rpTd8E4LemnOqBmYNajGIf2ja/z31NLiArhgPKyTWXnZPwdfA8DMvHunyKpMAG6BewMqzzHcKgNTgbHUSIz4IZ5X7m/YVKwMvyZIFfCwKEaysNjxKfMJApq+/2FGGaOfHV5B2OifcDfFpT10H23cgPMuuKUma+q5JENkRjTcr//7lQb1Cz5g+y0Txt4jSXHA4uFNzbr+iMD8SPk8oUCQLPcslYoqbS+SVd2Sr4PU8gYvnFTVUrGREJayKFW55IUfRTDS1PDfP+1bWfptBQs4lXtyc5+1A6dKsKdDOtAUP1QXAIuSoPmkLqzDXh2EqamO668W505WBVGt1BngsvEVID1IXNlyeE9hPSnkjSX+ZdYWT8WG6oxQr7RkYo3YfIpCA0ywyM4ploKFc75U14Xh62Pjf8Arcc6KFaV5XdFfVbtE3cdiVGRuM
X-Forefront-Antispam-Report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SJ0PR03MB6423.namprd03.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(4636009)(7916004)(376002)(366004)(346002)(396003)(39860400002)(136003)(451199021)(6512007)(9686003)(38100700002)(6506007)(41300700001)(186003)(6486002)(6666004)(26005)(83380400001)(478600001)(54906003)(4326008)(66476007)(66556008)(6916009)(82960400001)(66946007)(316002)(5660300002)(8936002)(8676002)(2906002)(86362001)(33716001)(85182001);
 DIR:OUT; SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjF1cEN5YVFzWUVvSStoNVVOS1M3ZnRmeGhXVWtMUmNnRU1XYnVwRlNCV1VP?=
 =?utf-8?B?REg0QU5Rczd2TnE2RTRidWR5MWphenJLdzZpbm9CcWNxTWxqaUh2UE5ab0I3?=
 =?utf-8?B?RmpSWjA0QnA4RTc3VGlVZTR1N0t4TEhKaXBtdi9QQUU3M3h5K0VuR2FiY09X?=
 =?utf-8?B?Q203V0d4cVV0T1grU2Q0VWx3QW0zd0h1bzhzVEwzTDg2MXZRWjBmMEFCRWk4?=
 =?utf-8?B?K0FCMDRHOEJGK2RkQ0lPQWVBZUF1cThMYy9VVGpRUHpLMzZQOHZhU3ZUVG4z?=
 =?utf-8?B?cTJnazNpMUcreTkxRHlRM05PQlFpNDltUmJyTEVOWHI0czM5RTVNOG9mRXIz?=
 =?utf-8?B?VW05cCtHMVM4MGRxUWRKMERQdVF1QXZSUWJpUFV1T2h3Vi8xZ1pNOXVnc1FH?=
 =?utf-8?B?RWFoVTJ6M2s0MndOUmxXVGloYk51aC83YTVIRlEvM2tGNjdZZGN1RW9GVVBi?=
 =?utf-8?B?OHhnUitZdGJma0tXVGk1WUc5Z3kzMUI5SlM4UktaMVdiV0FpaGUxMHkxeHlV?=
 =?utf-8?B?a3ZMM1VJc0dKSE1aNkRtRVY2SGNXOHRIRnBVOG5TOE5kR1Jlb3loQ29wbUFx?=
 =?utf-8?B?d09VVjdkb1Q3UjB4OHl2K0x1dzJnZ2RGSVpQTUhuS2o4QzA0cWNLS3pHZ3hH?=
 =?utf-8?B?Q0QxWGw3K05qWGs3U2NpUlVVeWRyWE94eFJuejFpS0d2eThJK3c5SE9ZOUt3?=
 =?utf-8?B?UDNOSzFhT0diZ3VXODI1UU9XZ3VqUE03V1F6a2dvUG9iS2VoM2dTNW5YYk44?=
 =?utf-8?B?NS9Ob1ZQUFI3N25oUWRmMjdMTVh3NGs2YWFkRTB0N2ZBYnFudG1jSmxMVjNj?=
 =?utf-8?B?OHIyQjFzeHAxUmtwMHRTU1NvQ0t0T3YrdHVvSnFQQTNlZDd1T2FxTmFuSnlB?=
 =?utf-8?B?cmU3LzFJQmRaMzJoVHVUZXNyL1orY2o1RDlYMTdwVUxlUk42WTVrakdRU0xK?=
 =?utf-8?B?a3BJaW5xUTR2cnVpYnlOQ1pRZFExeG5rekNUdXZqNExwd3Jqc1dyWWtoejJH?=
 =?utf-8?B?dUdOQzd2bnBpSWRrMnovRmNDQWowM2R3eTlKSlJpaWRCbi93NG5KUmpzZENP?=
 =?utf-8?B?ZVVJTkV0SzNidElydUI3K1F3OVI1R3FoVFFEcEFGd0lGcHZNZjk5K1lXbkxY?=
 =?utf-8?B?MlM2RGdEVGlpak5OeExNRkdmc2xQY1NwKzZPOEtFZ05sMUk4RmttZVd1Wkkz?=
 =?utf-8?B?ai9sY05wV0g2UGJGVkFqRmplQmN1NlY4Yk1TbXlvQUpKQXl1b2pPZFd5czc0?=
 =?utf-8?B?RDRwSE1BU1p1UCsrMXJ4dWJ1OVBtSmRSam5ZVmJmMnVUamNUWGVDT2xkaS9H?=
 =?utf-8?B?Rm1ZS0lBVnVFWFJBWGRwTllOa3dSckljekRqeXdSM2wxSCtNWVB3NmVXWVFS?=
 =?utf-8?B?ZTl5RDc0aXNaNkIwMUNpakp2dFlkaUZ1QUNYek1uVHd4alpGUm5uVTl4dDdo?=
 =?utf-8?B?NkZLRDdxbkpnVDd6TS9XcHRTOWpwSzR5SVhNU093VWNQY3h1blBqbFZkVXJM?=
 =?utf-8?B?QWprWlp0cWJDU0VsVXhSZURUMWtCUjNPRFdWRXFaRVFEdnhBZ2QwOTF5Z0Z2?=
 =?utf-8?B?WDR6K20vdjN3OE0zZlFKNmhCbG9sNU1vdTZhc2ZuL3RSbXdaUXFDUHpIU3g2?=
 =?utf-8?B?eDVnMXRRMFdwZlJ5TXB4UG12N0E4SmpQUTJLZkUvSk1FQUZTV0ZBenZkakxP?=
 =?utf-8?B?enh2SzBwV3d6QlFjc1RCSU9ZVXBscm8rK3ZDVU5TREFwTThmMy9peWNGMExR?=
 =?utf-8?B?Ty9TLzZBc1FVRCtqcG5obDlDRTNWa1lrdjFlZnRqa3FSRUJOaGRXWk1FcDNx?=
 =?utf-8?B?ZEpDNzhwRDI3ZlRzRzduU3B2OVp5ZTdlQXBFVEZoc1drTVhQaHlManRjNWF6?=
 =?utf-8?B?VXJjZkR0ZHZRamhZZGt3QlZKMEsvQkdZczhRMVVHVDQ5Q2VkWXBWT3M4N0ZE?=
 =?utf-8?B?YzhNdVVPZmlaekZzTi95Z1FCWWhJSmVXdmd4M1d4WEsvUlNRbWJaazFMdTJC?=
 =?utf-8?B?TXV5cnpOYVhtamIzNWIrSEFCWmtaVTFJMXRUSXhFTXpaZkgyOHR0Y3Y0NWxH?=
 =?utf-8?B?bjFmTnRRVVJNQXA4WUVwZlg1STFjSCtLYzNUbFhmZm4wNGg3VUNpQXNRZ3pI?=
 =?utf-8?B?bFo5emM4b2pycFBLZnQzcVpRTndaWkZ5OFZmZVp3S09aT3FyOGFpdjBOVXU0?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dksvbVBhR0VKcjJ2RDBiRlQ4eWJacGtqcTlEWEJrT1FncTVPRmdTWjJidDhG?=
 =?utf-8?B?NXRSbVRDakRsTmxsd003eUViWWoyamxsUjB4QnBtTnkzeDVScVM3cVJnbE8y?=
 =?utf-8?B?MUhDa2pIRnc0dG8xd05ZYUJXcEc5WWZGRDZLSWNOak5hejNOdXJQT2FYOVFF?=
 =?utf-8?B?ajl4c0ZJUm1BRlovN25QQUlNQTFyeU9QUTQ4UGpmd1NudDBWdCtKa0VwcHlK?=
 =?utf-8?B?VVFDcmYwSGFvcFV0M0hpVUE5VGs2b1NyUXFBQ3QrWGNkcFRHQVZweG05Vklo?=
 =?utf-8?B?dVFCNDhtaFkrSVVWTTFwdk9OOTN3SFprV1dNSDlCZ0NUdklzQkVFVHR3RWZa?=
 =?utf-8?B?YlUvaEF1Y1V5bUN4OGEwQUNuV0RDdkN2cHY0TThjTFZvUzRaUlBTdGVhc2N3?=
 =?utf-8?B?MnIwa1I2RzJQUSs0c2lheTdtUW4zM2srU0tKWnBGRGhQRnhaQTczVitZbDVp?=
 =?utf-8?B?N2hFRWt2N0lPbEQ2elB0bjE0YnlrNGRtZENqMzA5NWVwajBiaU5EZnFJL1hy?=
 =?utf-8?B?UXNCRjFBUDJyUGc1WWw1dGhWZkxmVGJMSFVNYVhlUGZ1TEFVWmNaMC84Q3RH?=
 =?utf-8?B?MkJFelhibytMNHVBV1pqZlVSVWNoaWJ6RVh5K1JuVXZXcFFFWm5ZRU5Bbllu?=
 =?utf-8?B?TUN0VTZGTXJCYUpUaHlNbjhGakcwTUFUeTE3a2t5TnpsY2ZoZmczUmhrRW5N?=
 =?utf-8?B?enZqc0FvWXNGWVNpcy9LQlI2N2wvRlBzcTQrMU1zbzFYa2hROEZQcDJZendX?=
 =?utf-8?B?NnBuM2pWS09GMXNST2R5czZGV1o0anNZZ2c4VzdDeDZ5aTA3bXEzSm5ESFRY?=
 =?utf-8?B?WXAvMnI5Q3ZUdDRaUW9oZjArYXlVOVg3TFlUekRINm1NeGx6ZFNBbkg0TG85?=
 =?utf-8?B?OUVUeCtnclM4WTk1THVWbFhJZlRNSkFLWjVjdmVWNGVQZ2R1MzBYMDNMakFz?=
 =?utf-8?B?ZE01RURndnNpR21OTlZYUUpZcXBEMGtmV3EzN1RDRzhEelU5emNxdE9Sbzgx?=
 =?utf-8?B?Y2xIVWRGQ2hNZmNkWjhmckUwaFFKTUhjS2FjczhFdzlLVWdBaDdnT255ejlS?=
 =?utf-8?B?bGNEcWJjSDVCalZ2cC9CbnJQVW13dmNNZzIzUEJOL08yOEp3SXNYeHBjWWcx?=
 =?utf-8?B?ekppS3dzMlFTOVBBK3dndnRmdWZoMlFtUXhJQlRnVXYvcUFlY1V5b0doWXRv?=
 =?utf-8?B?V3YyRXFkK1dDYitYSUZRdXZoMGlzWWlORC9WZlYySEU1Wlk1d0duN2hhYlE4?=
 =?utf-8?B?TzVwcU9nWUlqc3djVzB5czdHQVpkbHlhc0F2UGNHR2Rhd0ttUT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bc6cd94-e85a-4b89-e85d-08db66692da7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6423.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 08:36:52.9148 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DyVMJCtU7OZNAhTR+UvMnmqJfQqyP/93b1czVQ/acE31VjZ/PEX8HqwcRkGnI2vd9A7ow8mhLw6oVElKGpmVyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5406
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Wed, 07 Jun 2023 06:48:52 +0000
Subject: Re: [dm-devel] [PATCH v2 15/16] xen-blkback: Minor cleanups
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: citrix.com
Content-Disposition: inline
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

T24gVHVlLCBNYXkgMzAsIDIwMjMgYXQgMDQ6MzE6MTVQTSAtMDQwMCwgRGVtaSBNYXJpZSBPYmVu
b3VyIHdyb3RlOgo+IFRoaXMgYWRkcyBhIGNvdXBsZSBvZiBCVUlMRF9CVUdfT04oKXMgYW5kIG1v
dmVzIHNvbWUgYXJpdGhtZXRpYyBhZnRlcgo+IHRoZSB2YWxpZGF0aW9uIGNvZGUgdGhhdCBjaGVj
a3MgdGhlIGFyaXRobWV0aWPigJlzIHByZWNvbmRpdGlvbnMuICBUaGUKPiBwcmV2aW91cyBjb2Rl
IHdhcyBjb3JyZWN0IGJ1dCBjb3VsZCBwb3RlbnRpYWxseSB0cmlwIHNhbml0aXplcnMgdGhhdAo+
IGNoZWNrIGZvciB1bnNpZ25lZCBpbnRlZ2VyIHdyYXBhcm91bmQuCj4gCj4gU2lnbmVkLW9mZi1i
eTogRGVtaSBNYXJpZSBPYmVub3VyIDxkZW1pQGludmlzaWJsZXRoaW5nc2xhYi5jb20+Cj4gLS0t
Cj4gIGRyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2svYmxrYmFjay5jIHwgOCArKysrKy0tLQo+ICAx
IGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2Jsa2JhY2suYyBiL2RyaXZlcnMvYmxv
Y2sveGVuLWJsa2JhY2svYmxrYmFjay5jCj4gaW5kZXggYzM2MmY0YWQ4MGFiMDdiZmI1OGNhZmYw
ZWQ3ZGEzN2RjMTQ4NGZjNS4uYWM3NjBhMDhkNTU5MDg1YWI4NzU3ODRmMWM1OGNkZjJlYWQ5NWE0
MyAxMDA2NDQKPiAtLS0gYS9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2Jsa2JhY2suYwo+ICsr
KyBiL2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2svYmxrYmFjay5jCj4gQEAgLTEzNDIsNiArMTM0
Miw4IEBAIHN0YXRpYyBpbnQgZGlzcGF0Y2hfcndfYmxvY2tfaW8oc3RydWN0IHhlbl9ibGtpZl9y
aW5nICpyaW5nLAo+ICAJbnNlZyA9IHJlcS0+b3BlcmF0aW9uID09IEJMS0lGX09QX0lORElSRUNU
ID8KPiAgCSAgICAgICByZXEtPnUuaW5kaXJlY3QubnJfc2VnbWVudHMgOiByZXEtPnUucncubnJf
c2VnbWVudHM7Cj4gIAo+ICsJQlVJTERfQlVHX09OKG9mZnNldG9mKHN0cnVjdCBibGtpZl9yZXF1
ZXN0LCB1LnJ3LmlkKSAhPSA4KTsKPiArCUJVSUxEX0JVR19PTihvZmZzZXRvZihzdHJ1Y3QgYmxr
aWZfcmVxdWVzdCwgdS5pbmRpcmVjdC5pZCkgIT0gOCk7CgpXb24ndCBpdCBiZSBjbGVhcmVyIGFz
OgoKb2Zmc2V0b2Yoc3RydWN0IGJsa2lmX3JlcXVlc3QsIHUucncuaWQpICE9IG9mZnNldG9mKHN0
cnVjdCBibGtpZl9yZXF1ZXN0LCB1LmluZGlyZWN0LmlkKQoKV2UgZG9uJ3QgcmVhbGx5IGNhcmUg
YWJvdXQgdGhlIHNwZWNpZmljIG9mZnNldCB2YWx1ZSwgYnV0IGJvdGggbGF5b3V0cwptdXN0IG1h
dGNoLgoKQWxzbywgeW91IGxpa2VseSB3YW50IHRvIGNoZWNrIGZvciBhbGwgcmVxdWVzdHMgdHlw
ZXMsIG5vdCBqdXN0IHJ3IGFuZAppbmRpcmVjdCAoZGlzY2FyZCBhbmQgb3RoZXIpLgoKPiAgCWlm
ICh1bmxpa2VseShuc2VnID09IDAgJiYgb3BlcmF0aW9uX2ZsYWdzICE9IFJFUV9QUkVGTFVTSCkg
fHwKPiAgCSAgICB1bmxpa2VseSgocmVxLT5vcGVyYXRpb24gIT0gQkxLSUZfT1BfSU5ESVJFQ1Qp
ICYmCj4gIAkJICAgICAobnNlZyA+IEJMS0lGX01BWF9TRUdNRU5UU19QRVJfUkVRVUVTVCkpIHx8
Cj4gQEAgLTEzNjUsMTMgKzEzNjcsMTMgQEAgc3RhdGljIGludCBkaXNwYXRjaF9yd19ibG9ja19p
byhzdHJ1Y3QgeGVuX2Jsa2lmX3JpbmcgKnJpbmcsCj4gIAkJcHJlcS5zZWN0b3JfbnVtYmVyICAg
ICA9IHJlcS0+dS5ydy5zZWN0b3JfbnVtYmVyOwo+ICAJCWZvciAoaSA9IDA7IGkgPCBuc2VnOyBp
KyspIHsKPiAgCQkJcGFnZXNbaV0tPmdyZWYgPSByZXEtPnUucncuc2VnW2ldLmdyZWY7Cj4gLQkJ
CXNlZ1tpXS5uc2VjID0gcmVxLT51LnJ3LnNlZ1tpXS5sYXN0X3NlY3QgLQo+IC0JCQkJcmVxLT51
LnJ3LnNlZ1tpXS5maXJzdF9zZWN0ICsgMTsKPiAtCQkJc2VnW2ldLm9mZnNldCA9IChyZXEtPnUu
cncuc2VnW2ldLmZpcnN0X3NlY3QgPDwgOSk7Cj4gIAkJCWlmICgocmVxLT51LnJ3LnNlZ1tpXS5s
YXN0X3NlY3QgPj0gKFhFTl9QQUdFX1NJWkUgPj4gOSkpIHx8Cj4gIAkJCSAgICAocmVxLT51LnJ3
LnNlZ1tpXS5sYXN0X3NlY3QgPAo+ICAJCQkgICAgIHJlcS0+dS5ydy5zZWdbaV0uZmlyc3Rfc2Vj
dCkpCj4gIAkJCQlnb3RvIGZhaWxfcmVzcG9uc2U7Cj4gKwkJCXNlZ1tpXS5uc2VjID0gcmVxLT51
LnJ3LnNlZ1tpXS5sYXN0X3NlY3QgLQo+ICsJCQkJcmVxLT51LnJ3LnNlZ1tpXS5maXJzdF9zZWN0
ICsgMTsKPiArCQkJc2VnW2ldLm9mZnNldCA9IChyZXEtPnUucncuc2VnW2ldLmZpcnN0X3NlY3Qg
PDwgOSk7CgpQYXJlbnRoZXNlcyBoZXJlIGFyZSB1bm5lZWRlZC4gIElmIHdlIGRvIHRoYXQgbW92
ZSwgd2UgbWlnaHQgYXMgd2VsbAptb3ZlIHRoZSBhc3NpZ25hdGlvbiBvZiBwYWdlc1tpXS0+Z3Jl
ZiBhcyB3ZWxsLCBqdXN0IHRvIGF2b2lkCmFzc2lnbmluZyB0byBncmVmIHRvIHRha2UgdGhlIGZh
aWx1cmUgcGF0aC4KCkkgZG8gdGhpbmsgaG93ZXZlciB3cmFwYXJvdW5kIGlzIG5vdCBhbiBpc3N1
ZSBoZXJlLCBhcyB3ZSB3aWxsIGRpc2NhcmQKdGhlIHJlc3VsdC4KClRoYW5rcywgUm9nZXIuCgot
LQpkbS1kZXZlbCBtYWlsaW5nIGxpc3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3Rt
YW4ucmVkaGF0LmNvbS9tYWlsbWFuL2xpc3RpbmZvL2RtLWRldmVsCg==

