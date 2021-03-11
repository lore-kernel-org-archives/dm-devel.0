Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25391C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 20:00:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 615D064F84
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 20:00:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 615D064F84
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-_kvWBK_GMmGKNx0_WbOfwg-1; Thu, 11 Mar 2021 15:00:29 -0500
X-MC-Unique: _kvWBK_GMmGKNx0_WbOfwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1294892504;
	Thu, 11 Mar 2021 20:00:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E04C55D6D7;
	Thu, 11 Mar 2021 20:00:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 274B818155DE;
	Thu, 11 Mar 2021 20:00:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BK0K0x006130 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 15:00:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3D24810CD773; Thu, 11 Mar 2021 20:00:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 37C04104946E
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 20:00:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13746801E8D
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 20:00:17 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-123-WuU3m7nbOV-uS7q3phwuZQ-1;
	Thu, 11 Mar 2021 15:00:14 -0500
X-MC-Unique: WuU3m7nbOV-uS7q3phwuZQ-1
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur02lp2053.outbound.protection.outlook.com [104.47.5.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-18-PjZtxEnrNQCL7SqhzEcIXA-1; Thu, 11 Mar 2021 21:00:12 +0100
X-MC-Unique: PjZtxEnrNQCL7SqhzEcIXA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB6154.eurprd04.prod.outlook.com (2603:10a6:10:c8::14) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17;
	Thu, 11 Mar 2021 20:00:09 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3912.029;
	Thu, 11 Mar 2021 20:00:09 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 1/3] libmultipath: cleanup code to strip wwid trailing
	spaces
Thread-Index: AQHXCnb/D4kZyQiXZki4h0KyKH+FO6p/TVcA
Date: Thu, 11 Mar 2021 20:00:09 +0000
Message-ID: <c602b05558850decf3a2f7a9378d055a82750249.camel@suse.com>
References: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
	<1614148402-19847-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1614148402-19847-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0fc29ee8-684f-4536-33bd-08d8e4c8463a
x-ms-traffictypediagnostic: DBBPR04MB6154:
x-microsoft-antispam-prvs: <DBBPR04MB61547C582B78CE452FB5476DFC909@DBBPR04MB6154.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:626
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XjMDqaDGjwLVpj0jsrY4MV8aJW4SfoYDEYS8oZSKX41ULk3GLjQOKkyIpvWlAPXhDs/BJ/5WQ9aRO4JKlPAUOQgFG1r32VAUcZuqLL2ESxUPbtqVS+VMb+3kmxoOmlK0WclWHGc24NOJqlBBIVr8H29B9CzOI1jBX1i+4G3Hq6nBDu0/eIFK7p3WIjL/Qxbwr6biNxehIabSv1unxYj7G13xpJ25rZcDn33htPIQ1HV0xEZ7JcOIBimfyJGSpIKLNkx1Q0nXSLLGpox5gICEYOmCh27a/U11TQpJ9qbS6XSh+MeVodYI1vqpm7oYHiWXCIJKtOGPT9CXZxT6v182dsg33PHJJbtQcETnsT3rYWi1LrHcob9QL0e/Q7pz9q12YGRa7DXrWPpwEuYs5FCblSk1FZxsspOI8fNRyq0ilepN/U8pz5s0rsX58oLGo6MPNMDjlpcgHUhiA0s9+9OGwJy3sdCwqeTi4/oZ6qPfFboqYlrBzro8bw9Zu6lZra0E83eQht5/zjz3dp5MGum/Iw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39850400004)(396003)(376002)(136003)(346002)(366004)(66556008)(91956017)(66476007)(558084003)(186003)(6486002)(44832011)(2906002)(26005)(6506007)(6512007)(36756003)(2616005)(8676002)(71200400001)(64756008)(66946007)(8936002)(66446008)(86362001)(5660300002)(110136005)(316002)(4326008)(478600001)(54906003)(76116006);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?Pvx9v2UqHsJWkq20USV1pf/Pz0LpvIpC3bl6QRmPqLNH1sqv4XwYkmvfG?=
	=?iso-8859-15?Q?4RPnikxeODQTVcinUHSeeN7vE3ApNVCj30f4RghPWJA50vu8ltnUtxKAC?=
	=?iso-8859-15?Q?udmqkfiPttirOjvWlR8aepMCLXQTpi6lVKYeYp+R/tF9OprExej1JzZGp?=
	=?iso-8859-15?Q?b7hQPe3pbtEPWXTElIWjYD0ef8qGJ/FE6TRZ28cwubTfh3BGx+c1JkAGJ?=
	=?iso-8859-15?Q?+7Cgi1sAG4ZUF3gWhSj1fr1j0FujfdB2CijeBroUaPt4WhEuPhPJXbuOV?=
	=?iso-8859-15?Q?A6FQiWm6Q5Fn0T08Xz/rju2crPzcSyTwY6lesw9vLSN3hMhDuqzrCTqZb?=
	=?iso-8859-15?Q?x8979kS1FPkZ/I0YPHWXq5w2eFcMWqGl8outENLEa7kIXCgnPOIJfpubI?=
	=?iso-8859-15?Q?3qg+oRyno3IEeuvGXKaONm7Jl8Aq5BKi3HfsZFCmZPOMFxOzO4kQU5zK4?=
	=?iso-8859-15?Q?jmJpPA2vLbcZDGNYUIk6amCpoYVEFhnLH2OQXCEPDXZ/9LeZVJwyc8kum?=
	=?iso-8859-15?Q?kLI4cXWSz7g6EzJppHDNqKqgPgxyYJITTReT8fLQkJZEgf09oOWHOrLWX?=
	=?iso-8859-15?Q?44f0KJkCnQkm3/WERAUbVqSwtz6vFpWr0hdbO3QBNr/ZyAcGXbx0FQ/0x?=
	=?iso-8859-15?Q?dDtP++KYzqyYgksG4imJSX9r06899ZF+Lcy849sATbm0a0+fdvNItXXnY?=
	=?iso-8859-15?Q?dcrjzGqo0W9IXv4Go0k6gFREBnPtNaMuKqrQZF3r77VscEeMKfgiMO1sw?=
	=?iso-8859-15?Q?0XzEx/n44YpRp5bRONT3cBVrydZqxaFtHZ9TQeLw5z/jwq2H6rPHliIFy?=
	=?iso-8859-15?Q?bf9xV1LbTAMGgpq+6m68N0f09OextTLGefVO9cOJJr75HlO0XsYRnqwrp?=
	=?iso-8859-15?Q?V3uQ8HbkS4lCAvnYDjaV/SxdVRFWsYSo37GVonV554X/LA9O2496jLgM9?=
	=?iso-8859-15?Q?/gk8GJR7jkg1Z3PPX+nkM5eJ/Wb8a/uvshLbcA3cKo5ee3MoW/6wsJOo+?=
	=?iso-8859-15?Q?zgyvigImMU1+wkNO5YcTrL0n0RGpkhoa75ZPOne7a/kKZAEkp/jW+OSPv?=
	=?iso-8859-15?Q?qe/IAUZG2Bb8c2fLSkY1Mx9rDC7Lelj0HYubKsdtdWkVn0+OmxoIO7tl0?=
	=?iso-8859-15?Q?N1V2aFu6kPIbEJNriLT5TpSJPdm1rP4hhlv1RsjiSa2kROmEUW9R9/52z?=
	=?iso-8859-15?Q?JuDukx6Y6c+rLIiok3vmsuNNtkOmqEQdRO4qyD5WsHdvYprcInUSWtJF6?=
	=?iso-8859-15?Q?HeFLdQ/YwnCyu4jlaVRy736m5LHvwGOtIuNMjNbsWQi9evnuWTv7QqtBz?=
	=?iso-8859-15?Q?8w/KRr2LB10ZMhpY12IIdTMWhvnivvs6gUuRWWuZKHw4iih2MUKVSgsjz?=
	=?iso-8859-15?Q?+bIrlpveGINCCzb1M1S4kh+8kwU9xyTbx?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc29ee8-684f-4536-33bd-08d8e4c8463a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 20:00:09.4547 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XJrLJaoh3xnX1a8QubTJbJPUsuDM5qbQfV2cAt3cEOJwnHIu8pKWYoGF5vth2yBZzZ/QhgKNY0wg2KGmIzpB3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6154
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12BK0K0x006130
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"wucy11@chinatelecom.cn" <wucy11@chinatelecom.cn>
Subject: Re: [dm-devel] [PATCH v2 1/3] libmultipath: cleanup code to strip
 wwid trailing spaces
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
Content-ID: <A2816894C300C046AB52617F33953E75@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-02-24 at 00:33 -0600, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

