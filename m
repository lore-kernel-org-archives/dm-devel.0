Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC76C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:54:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 53B1A6124C
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:54:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 53B1A6124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-vT8coeCLO_-QPZtxKwZzmA-1; Thu, 11 Nov 2021 06:54:49 -0500
X-MC-Unique: vT8coeCLO_-QPZtxKwZzmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D38EE1006AA2;
	Thu, 11 Nov 2021 11:54:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A2ED35D6D7;
	Thu, 11 Nov 2021 11:54:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 565FE1800FDD;
	Thu, 11 Nov 2021 11:54:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABBshIw011226 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 06:54:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DDB33404727C; Thu, 11 Nov 2021 11:54:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D89B64047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:54:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C018E1066559
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:54:42 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-376-S208CffAOHivEnsLAEremg-1;
	Thu, 11 Nov 2021 06:54:41 -0500
X-MC-Unique: S208CffAOHivEnsLAEremg-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-19-Jc1GCLjNOhKjXWesX3qAqw-1; Thu, 11 Nov 2021 12:54:39 +0100
X-MC-Unique: Jc1GCLjNOhKjXWesX3qAqw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6844.eurprd04.prod.outlook.com (2603:10a6:10:112::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16;
	Thu, 11 Nov 2021 11:54:37 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 11:54:37 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 9/9] libmultipath: cleanup invalid config handling
Thread-Index: AQHX1php7V525kISIUqs/3oHtqBk26v+OJsA
Date: Thu, 11 Nov 2021 11:54:37 +0000
Message-ID: <94ba1b3498cbdeb4784677c3f7264cb26b9b8cc9.camel@suse.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
	<1636592780-20391-10-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636592780-20391-10-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55819d70-a1b4-4c73-8186-08d9a50a0960
x-ms-traffictypediagnostic: DB8PR04MB6844:
x-microsoft-antispam-prvs: <DB8PR04MB68444DCB41EB994A3CA3877EFC949@DB8PR04MB6844.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: j+o973gSmdEROkgZP8HAt/MAdGLIOSWuiTRUacl7zzHyuTJ9pWdw5DDC1kLMV9Cpd9hHa6LxH26SL5VubUSqU8Wf7P8rCjJz5ig/T3d3kG/7d4oZtHMwlOgsAtsmHGT3nvZc0/aeAsShZkYC7jROHMUDPsBtG+uMd3IaMUbXjHZlHt+DNnMq3j9PJQ4FYXG8Vl2xUD+T3xsUkrXmX1b8/uXtU1rOPIgVgzo/evbD0zyetL2Ea5m0mzM0X1pU/puXsuxG4QKS5f66ToPWfI/VYvxgSiq4skgx7XOi/4R7cF652VoSg5ZQ8/2A4Ip85EDhxxgk5Y/NFtxKi5b4BgnYaMDPU+5mQibAYQ3xPkWKWtIETMxAypcInLfnSjYbRsPFkx0r7emZggCuksuqs4UtPQqD1FtsL4nUEpgDygbrlZZ8Ic4UBzoG+zIT/RbFmS3Bn8xeCGAduH9zXnHx3+StJvnX7lhXii12qY7u1n1rkSWTMhNLqj2H59IGnu7/i/u5Ualzmg9QgNBm58451B6OMyKXw+BGJDaaniCeBOQLToUEEXXgoJXL66kAvDabldX29w4fIvvw1llBaKy92mOz5v7pzl7JTi2F2Kd7Axuucv++9M3Ta1yYVj9CHYTMkeEJpLJeAuFwevUJR9Dh0HYmKhZw+ASXC7qyN3xAxXlFIi+NwgBOH7jLq/uQl1b/zF6Mh8mdhq4JRTBOXZ2bXDsZ7w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(508600001)(186003)(316002)(5660300002)(44832011)(83380400001)(66446008)(8936002)(122000001)(66946007)(6486002)(64756008)(38100700002)(6506007)(26005)(66556008)(71200400001)(66476007)(38070700005)(4744005)(2616005)(36756003)(6512007)(2906002)(91956017)(76116006)(86362001)(4001150100001)(8676002)(110136005)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?lJ6OTWfxng+U0QRUJmYk1DPXQlvtOdTG8apI1LsdEnD7eC8nxx3nb/pwd?=
	=?iso-8859-15?Q?EpaoDW32wczAz5lf9K4DtIlSyKrw4R+vMW/cfQIt4Vh3s1mZavjg+q/xP?=
	=?iso-8859-15?Q?TM1CUMCyPyNaq8J/R05fGYLdeRPoGNIGN8Fz++0pb9a5x0p+a30UwDTBp?=
	=?iso-8859-15?Q?6OUFlsT2lu7z84eOJJyhS5my3EGCdzZj6gg2F4NF4lhb6dcN6Mu4uy5m0?=
	=?iso-8859-15?Q?8Fhn9Rlo/Hd0cQ86CmWbBJzQ5/Q2xwfkZlJOowh+b/IKQKVQ6ctyNW7dj?=
	=?iso-8859-15?Q?YDvcU5G+LuVcVw/06lj+4U0g0dr+I+XzQS7Dc2d/I3rNEjo4JDiPjQoNf?=
	=?iso-8859-15?Q?EP+s9uXsVO6UI/3xY8zNeN68JgK4i4daN7fPOot8KJppGH91dmaFI6L5i?=
	=?iso-8859-15?Q?rco5fh7VYrx0Ra1j7eFtkWHGhxrCAtz0Pj+hElGNtRWlCi1+xW1Vd5yZy?=
	=?iso-8859-15?Q?WqTx3sP41ddo8bxe6aqoviZIyZ9zGZ8InaCbpabtrccU1LPx27z5rJXjD?=
	=?iso-8859-15?Q?VSgtZelI2lfksKXfR+kK+MYzWY/UhGrMsBgY57Ln32gRCzD/Mj1dpTU6s?=
	=?iso-8859-15?Q?9sYZyFig1jJ6qK7ReM4FrcobefRtxx7Ktayb8KBN2AH1QwzvxFLhyNjPX?=
	=?iso-8859-15?Q?1OsJWEVrvrEomUaVcaIX9ueEWxS/HiT7fbuWlBhCAB0RlT/xNBz3SIH0w?=
	=?iso-8859-15?Q?rH97fkHpvX7Mx77ToGoP/U+hQwA3ASZEVvUFVmiSZ410OmJdqtCvDEel1?=
	=?iso-8859-15?Q?wBDDDK02YAFwWFy/BhcGplp4PEhdCNzXC80LISgJ3DTKPgknc3MvoIh7x?=
	=?iso-8859-15?Q?G8n/LXkBkAEyZVuMOfoc6Y3qHAtfi6Jq3UHAf2Vlfl6yEgFxKU/Jpl+MH?=
	=?iso-8859-15?Q?n0aS4s9lQx1EXtV8/1cJxdOw1T8gysByZd3c9C8uIsGR8oiCKV6Z2wbWH?=
	=?iso-8859-15?Q?g0PesYFOMDiEjgar+gm5DqpoDMHTHgrwncSn1ahHVnOuOvPnZWCHzNUDF?=
	=?iso-8859-15?Q?0N/plqJFZaqgVeAzVyV/ofJc3p4Y+XVdsBoEo9a0Hkm33zFMLCG9M8cq5?=
	=?iso-8859-15?Q?6JmCAF2/uwyeD4/x8lEil9z4LfX6OvYWom2cwMYlqUH6bERJ4z+wBvyXg?=
	=?iso-8859-15?Q?MGC0LTunaksOg9wDHjSFLplRo+46nJXgoRs2JrSPTUwynRHKCnyXesUmq?=
	=?iso-8859-15?Q?M5dmi6qqlzBdGco/swt4Uq8XCEWvjdH3NUeh1Di/681m/4R5d8aVldH1J?=
	=?iso-8859-15?Q?WnFF8fzg/Bi9bud7AxZ5QZpwRnN1E44sEMlD5kiMCKY7y7D2hwZdikz0M?=
	=?iso-8859-15?Q?5XLfq1agjRxGJwvQbtQ3paA1juTFLZebFEKcBWn4l/+Uspy4BJNi6c3MM?=
	=?iso-8859-15?Q?hE/ziEYu+UdL8d/LwILyqn2Fy48txBXXUzkpizhNfo1KANEFayP5DkfrE?=
	=?iso-8859-15?Q?zxl33nwfN6VrKPElrPX5tJQNsvmoxBECY8yJ0PGfP9Sl/Z9+Y1jMFoE6t?=
	=?iso-8859-15?Q?a6amZfOeaiCOMcCbLgIrwmtRl09aYdGWigFTanetRE6NcpsGtkNF0Fj4i?=
	=?iso-8859-15?Q?xQ5cgPLPHpje0wSW7AJTrPSI8ji56ohS+iHxzPHiYSgFg182wUqULNDmI?=
	=?iso-8859-15?Q?M0IAjeB7OP5kzmN4gAKOmNA8SFsXa/d7HoMjPsxbcxftDXcgiZobYzyyk?=
	=?iso-8859-15?Q?BiBRQBRPL5sdJho6s1hN0z0vdfoJH7pWMdjX9ulTLjp/4z8=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55819d70-a1b4-4c73-8186-08d9a50a0960
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 11:54:37.4341 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R2QOq4tgP+kJ0/19XQKhhkEN9FjS2z9dziLLHhxGGUQn/zlkPQQDFuS+35nv+aAB0k/wAIdQGSdjp+jutL5PEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6844
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ABBshIw011226
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 9/9] libmultipath: cleanup invalid config
	handling
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
Content-ID: <50E50BBC035B58498BAE22F57F3F4EC5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-11-10 at 19:06 -0600, Benjamin Marzinski wrote:
> Add error reporting to the remaining config handlers. If the value is
> invalid, do not change the existing config option's value. Also print
> an error whenever 0 is returned for an invalid value. When the
> handler
> returns 1, config processing already fails with an error message.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

