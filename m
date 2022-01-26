Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417FBC28CF5
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 16:30:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-iO-VXDg7Pc2rkTEy6tzYTg-1; Wed, 26 Jan 2022 11:30:49 -0500
X-MC-Unique: iO-VXDg7Pc2rkTEy6tzYTg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A278F1083F62;
	Wed, 26 Jan 2022 16:30:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 42F515E484;
	Wed, 26 Jan 2022 16:30:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE6634BB7C;
	Wed, 26 Jan 2022 16:30:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20QGUf1H024167 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 11:30:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 95A0E40CFD04; Wed, 26 Jan 2022 16:30:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EC8440CFD34
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 16:30:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7511B2B16862
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 16:30:41 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-204-t_4gTG4dNKWwl9Xn33ME5A-1; Wed, 26 Jan 2022 11:30:39 -0500
X-MC-Unique: t_4gTG4dNKWwl9Xn33ME5A-1
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur02lp2053.outbound.protection.outlook.com [104.47.6.53]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-40-G58uosqHPGqFFw-4O-h-jA-2; Wed, 26 Jan 2022 17:30:36 +0100
X-MC-Unique: G58uosqHPGqFFw-4O-h-jA-2
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM0PR04MB4691.eurprd04.prod.outlook.com (2603:10a6:208:c1::20)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15;
	Wed, 26 Jan 2022 16:30:33 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4909.017;
	Wed, 26 Jan 2022 16:30:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH v2 0/9] multipathd: remove udev settle dependency
Thread-Index: AQHX2/kcqYz9XADO80u4JTNgHS2rlax14Ul6gAAK2YA=
Date: Wed, 26 Jan 2022 16:30:33 +0000
Message-ID: <500c110d44a5712c7a5cc2280ea8af80fa2ec285.camel@suse.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
	<2d4c46dcaee54eb39e96831c0ee9bf88204cc819.camel@suse.com>
	<20220126155106.GL24684@octiron.msp.redhat.com>
In-Reply-To: <20220126155106.GL24684@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a8784ef-f486-429b-5394-08d9e0e92d22
x-ms-traffictypediagnostic: AM0PR04MB4691:EE_
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-microsoft-antispam-prvs: <AM0PR04MB4691A233D1855677D58DC92FFC209@AM0PR04MB4691.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VQY9ZLxDooBMswCMxFEo+yZ/ZFnnoTICQso5Cm5gEeRDfAWhqAJ4h5YoCs/8cRJywM3W/1ZbZDrfcdds2ZOoHMJiHUNFXusmJr1DYRqaURJpnvrPm/X7R09FJZqGsDSD2han7GQoVdujqFnl+sw+gVlYE8snp1lkLuUcZI/owTuQvCA6lapfR/iqV7FoDR9ym56cRi01IJfIZMAy7VskN/86/RXSrEWkZdC89AXLW2oPyEO73GYoDfNB5BEExjfwIadANY5FaCuxswSyBUTdw4I6IHLFxSshGxH3Svzoe/VigOYQQeaOZ/kb5AjsM8ImrhaP8/rFxuD0Zzw2wtTuHe1M6dXa7I2n2LlPFTC+mJCVD/dEbXk2VFHHhBse0IFkFlroCBPfYqYEX3BJ/uftAfpWooZa/INtrLjXwe1Dbdk8LoD8RBnVKOrk+K4vW9HULzEVZw0zCCORKLm4O2KpCBdEgaFXy1FEYmGEhu3K9vGE/KHBOY0GaoPWNAhaja9a38pVtXELyvFd9/JTO4ADoJn0smT875RcDLhUig1kbk137aSrVoArRHI4/swbOlXAe5MvKb+LJPsOUm23YnLDa3yyB/YJmHBCNN3+tsa8CGiTtRrJ9G+g2gbl8JUWa+pBWPJDuuJvF+qoxdibQFy9t6yoKx/asE3Zp4Fsqt4OINaBaxp6lmqpMCvA31WPF4cK6EtTl2GrVvUFx0GY1xpbcg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(38070700005)(6506007)(6512007)(54906003)(508600001)(86362001)(6486002)(122000001)(316002)(71200400001)(6916009)(64756008)(66476007)(66946007)(66556008)(2906002)(2616005)(186003)(38100700002)(26005)(8936002)(5660300002)(8676002)(76116006)(4744005)(91956017)(66446008)(36756003)(4326008)(44832011)(20210929001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?d9hOdPlqujxzsDYuWULjRTV5f2zVpSCQIxy0Fs1jCJipZqUjaXMNAImX3?=
	=?iso-8859-15?Q?1DtU6ALuIh6xU74XJMQJxmmZsvan2ZJTSgOk/sPIj3/uN1ZusfRT1oODg?=
	=?iso-8859-15?Q?BzSMCXr6isgCDfO9V6aELnUiSbCCttrX6afFsRqcserrXy0Ey4JXUBIDJ?=
	=?iso-8859-15?Q?AOFYpQHyu1XWoXVqUGD3oZuNCf22mLhOavjDBsSSKDdvxzxf/9lCu9k6d?=
	=?iso-8859-15?Q?nmyFopzSJVc2Z7YkWPrS/8Vjer5vgvEy7L7XZ735DC1VibdmyX7YWxwKq?=
	=?iso-8859-15?Q?YejMPFITHjRYyCNPAiWNb/tiY3LxRNOrcjkhs0xLHcRLhhFVmH1GBd7qS?=
	=?iso-8859-15?Q?RrCSX7JS1wYnAJz6ty37DcikYneZUM3ORCi9MxExlNnxOA8PF2AO7SfNp?=
	=?iso-8859-15?Q?JKWJl6EjHrrfYBiLpET9b+0y0X7tl/MCMp4GtTJ6wrqVoFJeOqTqjCXX8?=
	=?iso-8859-15?Q?uFjhr32fXOSQU4a63WOyMZD6WRsvnjU1L/sakNvWlsK4+jD53hesSBHz6?=
	=?iso-8859-15?Q?LShelGjAnne1QQKqsMUHrBcToDgs/yS+AEY8JAFttS+/p++XngOL34cpJ?=
	=?iso-8859-15?Q?g02fiKXp/uaHtJFSnP9AKcTC05ea+Lx6Oa+Q4tIaJKGYKCs3ZKbcA3bC1?=
	=?iso-8859-15?Q?GhSCb8wqri1ZRm7+bVn/U54+mV8i+qhu66TZZmf1wFuEYnNqzW68mx9Lu?=
	=?iso-8859-15?Q?WRmMmA0OSRKW8PcCkOQHTWwP0KIwLPUmK5M1Atl/LzXRoyxtEYUHUOBic?=
	=?iso-8859-15?Q?s8eF9GjC5kg573Fwq+NBznXFeag/T95KG6mV+QjQ5g8H6mmij2F1PKU9r?=
	=?iso-8859-15?Q?zruV+Qwui7nxQWxEKsO/azwOnKTSmVZzyuAFZ1bpFopXJq02phk6kuzTa?=
	=?iso-8859-15?Q?ZRvgLY+zVpz/DlL1yuqF163RwjlnTNcaVK9LaSPsWRBwcn6uvTUnitai8?=
	=?iso-8859-15?Q?UH4HlRUJ/vJcnStFVs8OYlMp4QhQvVXOmJI0hr01gZnYLZUTQmiw5BhPR?=
	=?iso-8859-15?Q?s4HrhDEorsXjLZ5Cz5Pgf6rb+PjkJHAp6eax1fw3HxHzH6nMB8i/I+67S?=
	=?iso-8859-15?Q?Cvd9Se3v4hYXKg1RJaBT8St/jBDJmJw89zWwueXuOjBSn4Xiob1eWpmDo?=
	=?iso-8859-15?Q?Zvni2Crb56Ha3B3+Jy0mmpVCKftukQSu4ZBSCdNpYrvN1DX/KZlyZnEA5?=
	=?iso-8859-15?Q?iaOiMDNN5ULYukIOHExHbMyRJZhvxiH574l+6VYh1vcLcFgkP5QWCXWAy?=
	=?iso-8859-15?Q?HcGTiW5b1VTeAO6YnRM5jSwdQt9RSs5RaqyMQIasa6c8arWSrjq0iIQpW?=
	=?iso-8859-15?Q?w+iS30FuQE9RtTvQQiqGedQDG6TUCuyJIzr/8N3Mclazo+kah1D46POq7?=
	=?iso-8859-15?Q?owy4b8RiitmSOq4cL2ot1fZrPt1lwrzP0S551y+eQs03iEZqBOxf7xuO9?=
	=?iso-8859-15?Q?bvys7M08nyclw/OJ0C78SiNQRDB9D85bpsuK/m0g+Zf+otZoYEGnArXeT?=
	=?iso-8859-15?Q?KeuhlrMEiU5vXXx4ZXCYVcYOnSx3P6xQrRGIGjsWXibbE+izC/F7nXgrN?=
	=?iso-8859-15?Q?0rC9/l6YFVDkAN3oamEUfY8mNpEmf7rV8WDlSnW9OfMRaHxmgfPcbugby?=
	=?iso-8859-15?Q?Be/icy7uTb3Upnwm75cBOI103uGGrWSLSSOpw8jsF4/ALGjQZI8FXzlLD?=
	=?iso-8859-15?Q?R1V8CFav+kuK9dqCJSxPyJTMz2WMYZ0l4320fkH+pdMT5Sc=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8784ef-f486-429b-5394-08d9e0e92d22
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 16:30:33.8342 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wxmpm22S04FYUdwooxKSuKqL+gT508C2oEP9jF5dWHLt47bof7JoTjklDyTmYgVthS3ROYDN1qaF3SW8Kt2W1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4691
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20QGUf1H024167
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Hannes Reinecke <hare@suse.com>
Subject: Re: [dm-devel] [PATCH v2 0/9] multipathd: remove udev settle
	dependency
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <7005040262805744AD743E41B03D4E86@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2022-01-26 at 09:51 -0600, Benjamin Marzinski wrote:
> 
> Just to clarify things, is there a difference between this and the
> case
> that has always existed, where multipathd is up and running and a new
> storage array gets discovered? The active/optimized paths aren't
> always
> discovered first.

No, that's the same thing. Just that now, multipathd is always up
before the paths show up.

As I said in my other post, I don't think it's a big issue. But it's a
significant change in how booting with multipath works.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

