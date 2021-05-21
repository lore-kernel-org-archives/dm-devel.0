Return-Path: <SRS0=AQTU=KQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F7EC433ED
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:07:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9D04D6135C
	for <dm-devel@archiver.kernel.org>; Fri, 21 May 2021 05:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D04D6135C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-VkudBqRGOy6qPCMrFQ05hQ-1; Fri, 21 May 2021 01:06:59 -0400
X-MC-Unique: VkudBqRGOy6qPCMrFQ05hQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E0D4180FD6F;
	Fri, 21 May 2021 05:06:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 06D1D5D74D;
	Fri, 21 May 2021 05:06:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 610B6180B463;
	Fri, 21 May 2021 05:06:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L56mJH023541 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 01:06:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BA32E215AB04; Fri, 21 May 2021 05:06:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4F41215AB03
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:06:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5EB9185A79C
	for <dm-devel@redhat.com>; Fri, 21 May 2021 05:06:45 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-376-2jVen0O3OJSbUJnBoZ3pyg-1; Fri, 21 May 2021 01:06:41 -0400
X-MC-Unique: 2jVen0O3OJSbUJnBoZ3pyg-1
IronPort-SDR: 4sW6dz0AJT/wReDCL03kRYEKz/xJ5npKFF9GWglvDaA0MggBuddIMHetwylfUl1xfXEzFFbDWF
	qpa+yb5aObBhsj7Zk6vu9h8bheCLmuqqggRFpzLNZLGh94uiEgPKRMIlVlpJdOY9vXGPIGi4Ou
	lzajFaU3jw8ccCyKDX82Br1TTXx0PfLaohk5tHS1Z+Ih6FXuIhO74Qe78Iv3CE6m3lij9DfSud
	smclUv1dCnb+G1fjgmSKuooq+FizrBu0sbjHcQFJeiLx34DZ4FMnfO6u4xwEyAYLdVIn7s0Tut
	Bjw=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="168258917"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
	by ob1.hgst.iphmx.com with ESMTP; 21 May 2021 13:06:39 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7687.namprd04.prod.outlook.com (2603:10b6:510:56::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28;
	Fri, 21 May 2021 05:06:38 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Fri, 21 May 2021 05:06:38 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH v3 02/11] block: introduce bio zone helpers
Thread-Index: AQHXTe2Zybj5mOBA/02Mpzl7w42RBg==
Date: Fri, 21 May 2021 05:06:38 +0000
Message-ID: <PH0PR04MB7416AF88E7D7599E68EA73969B299@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210521030119.1209035-1-damien.lemoal@wdc.com>
	<20210521030119.1209035-3-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:f8bd:921e:9aa5:6d21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b8f2cd4-956a-4572-17c2-08d91c1636fb
x-ms-traffictypediagnostic: PH0PR04MB7687:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7687D8740F89102500AD7C379B299@PH0PR04MB7687.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: warfJgz+zTXv+KMgEBVU+xU58octuSMDn3fU9gHKzoroFC8YDnGDV1gnpprGSeIzjJ0mwawWjW+47rL61v1BNG8ka7gUrtCmnQFSN4BPZdZ+EEc0VU9AWGgap1xt1zqCEnx/vMqifMwb4nRiWAVhtBZ4QjisY0nJ164ZvPwZsFpuHWvkBSIT+UevI83sK4cYuGISyNIJZCXJ38ERvAJzU/O+GFI45Hdip+ucwHhwwKCPuWUxyJ2a70RdVsKXdYxQAh66cLxUACsvqFSJ9pP1cfcLUbJrg2vHLUPlMzmjxrFdYlyaAprcL1VQuM5kVeu00VoqhyqTXs9wv7T2Np5C3ZnWrC/cWtUOYydAfgCoP2E5mfxC/CNCC2jZsfIg8C5Mko51oBJ64h/Fc13WQxlVU+7G0C7/k5HZlOfnABjJB7ZkPnQ83Plfdf3mwRj0g5rEXtfrJJ1YYqe09/X0fhYhnY3987D6VPNcj3iwOjmIbDFVI/HkhBuCxrmL9aDGkAvrfVGA9iNu0XEkkiS4QyvG5EIUIShTiawHqyvPNbmVckTQhyD5vynN6Py4/7WhA9rWUA7M5uB3qZtgtmc+TVpkXiE5cC9TDM434r2eHN/utHA=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(52536014)(478600001)(86362001)(76116006)(33656002)(5660300002)(71200400001)(66556008)(66446008)(91956017)(66946007)(66476007)(64756008)(19618925003)(110136005)(38100700002)(558084003)(55016002)(4270600006)(316002)(7696005)(9686003)(2906002)(8676002)(186003)(8936002)(122000001)(6506007);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Zwr4eHGmcMqkURVex1ok11qncC7q4xJ/o9Q6ZefUtmFam2D4Bj1J8IV/GK1M?=
	=?us-ascii?Q?5mw8i1vUEk/Nc5tDUZb4bSNevl0BFpAcoKevQcg4LTi6s8jltfEHfnUvAbZv?=
	=?us-ascii?Q?hpwS/trD9mqd1K/ZB90AhwrH/bownqexi9gimwEAQwh3xvvcSgghPT4Xherc?=
	=?us-ascii?Q?gIKWmjrFfL7BpkyLvumxBO9g4LeIf/JENjLEUQTqnCm6zAzhOugtlqbxufBn?=
	=?us-ascii?Q?vPdhoVYTLdK6jgpk0fxFeNOlI2rgPQBwiR38qtoIp9VNRTKx9QAa0gZ5pUni?=
	=?us-ascii?Q?1huBMpSK6UbmFe4A1onLBcPwUZmd7VC01w54LlLk+ST6uZSP8QZiNFXqkQqZ?=
	=?us-ascii?Q?Fyhn33X0yJF2aZIwXRPCl2e8LnGIbfA7fqSglZ0JJFSoRWhDv7VmEoOVY6AR?=
	=?us-ascii?Q?sT4ZwXWo2ARgrMbdV61p6XupqMi183wx0pdB0fUkLXgCc3qp78NtxEikkbEz?=
	=?us-ascii?Q?yGgKCmWHvZCGxLsTjZ1p0VLYpowaRkinuYdWb7GOWvmo5xcdQTT0HJDPUrX4?=
	=?us-ascii?Q?j4YQhxTpWdb+442NzvYYroPgShoU9/2pva1P4CQ45tEK+1Sd+2bEjprgmxKH?=
	=?us-ascii?Q?DrUQ4VekbHo7SusRzbmigA4fZ5ueFAhwTg5rV9PqhTtewBjrU+1sygGi19QQ?=
	=?us-ascii?Q?yWndPem60RZbN9gW7O6VH2PF+hg486RGblTGJpjDAj1jLtPd7pZJ1kD018xg?=
	=?us-ascii?Q?pMkhFEAbht5gVec4WC2nM7GdhbM6v75nj8/jqsreezM/TcAYzECgHDiqTELb?=
	=?us-ascii?Q?fENfVbMXiDz8gVB5wxEIT94OyoCrB0cFKztHaMo+DGNY665rwd6TNXiHoJNK?=
	=?us-ascii?Q?xrndYBLL5baJnEzOMwGy6YC7OBlYieTfC9eeMYgdJfnVS5TyG9BaavoRKfwn?=
	=?us-ascii?Q?zbB3L8/Fq+bdZR1kRcnVISZiHL3gDqx+bdhk5FBAxxOanjoWHoWDo3Dl8h6Y?=
	=?us-ascii?Q?w7QAIza+IKg9Dhdd/hYhq9YqsvK37nZT5F0oYSL2AJ75y+rOI/LXXEqLVTsX?=
	=?us-ascii?Q?zYTXsDN5d5A5VVAgjlKYyMt5RJsWIyTU/GfhKZnGgLSGRumz3UtxZseHgBMK?=
	=?us-ascii?Q?vRfjae22rZqo4OzzfzHMSFm5UD2k5KDwYrMU5cHBNT21IZVpZfz9lolWglcP?=
	=?us-ascii?Q?MpyNEj9ikAH/nnTcVsWznNr/JtPz0dt5Yb/LL26az8SdD6/ClAyG0divsZtR?=
	=?us-ascii?Q?1s7aMvwCKXPEISvSjcC2Io4q4TvNbDR33y1BH7+NHmeX3g7IzFAvK9biQc+E?=
	=?us-ascii?Q?FUE1nmWRF8H523XQm2ZZ3AihfKIbyR/D3MmXF51BFKcu1IVGN0wxyZtjcHmd?=
	=?us-ascii?Q?INGIFfsfpsGLryCrGHyObUKbnJCI/EWVzhjpd80FP3I5bBm6qckYRMy4odFt?=
	=?us-ascii?Q?TWRJNlW69YQ7ww8PfTOXkcbJHXtAqIhZRWW5O2eCwojXSaUvCA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8f2cd4-956a-4572-17c2-08d91c1636fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 05:06:38.5386 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1OjvLkvgQ+iNqFLzAQQfIXyOZCV8RMwCSSGkXX+Bn3eDrmYnbbtEdL+9YC7qcBXvSYOQ7m25hBuhu82EKOL8u5ZQLOuk81ZyewH+dqF0TC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7687
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14L56mJH023541
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 02/11] block: introduce bio zone helpers
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

