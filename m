Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0848DC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:58:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6CE46613CD
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 19:58:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CE46613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-v2OdJhX2MF-Hqq7KKwZPEw-1; Thu, 13 May 2021 15:58:40 -0400
X-MC-Unique: v2OdJhX2MF-Hqq7KKwZPEw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40E921020C33;
	Thu, 13 May 2021 19:58:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 056A63807;
	Thu, 13 May 2021 19:58:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A22F555343;
	Thu, 13 May 2021 19:58:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DJuuAR019917 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 15:56:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7E52F2063575; Thu, 13 May 2021 19:56:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 781D72077FBA
	for <dm-devel@redhat.com>; Thu, 13 May 2021 19:56:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31A5F800B29
	for <dm-devel@redhat.com>; Thu, 13 May 2021 19:56:53 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-496-tdn0yGfdM-CYiFCQr2eqfA-1;
	Thu, 13 May 2021 15:56:50 -0400
X-MC-Unique: tdn0yGfdM-CYiFCQr2eqfA-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-23-M0uoOALvN02pTqxa8rVuxQ-1; Thu, 13 May 2021 21:56:47 +0200
X-MC-Unique: M0uoOALvN02pTqxa8rVuxQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB8026.eurprd04.prod.outlook.com (2603:10a6:10:1ed::6) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Thu, 13 May 2021 19:56:46 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Thu, 13 May 2021 19:56:46 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 4/6] multipath: free vectors in configure
Thread-Index: AQHXSBy/eOZuXIV9j0mTFe4bxJCJLqrh0/sA
Date: Thu, 13 May 2021 19:56:46 +0000
Message-ID: <e47c0f8d98814756a64489a1393f2dd789e7fb9c.camel@suse.com>
References: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
	<1620926595-12029-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620926595-12029-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99c1a5f7-723d-43fb-e3d4-08d916493d68
x-ms-traffictypediagnostic: DBBPR04MB8026:
x-microsoft-antispam-prvs: <DBBPR04MB8026CACBFDD762C82D568D39FC519@DBBPR04MB8026.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: odpxhggHc25PLccWuJeRWBB+NiG9KvHXtYR7M+cQ35bEmCZ51c0CSVvzHUrbeDk5KtrzLIFqcSmZ3qWd5d0TKLJJ27Nnm+qM0gHzQvg1uLQsi6SiLRdSBmBaEHDCyR78sHuKJSUdM1Sg+YVQqViIfn2K0PDQPUEKr0W7x6f3EOAi4Z6hfJNL5UsifFoZu4m5X+N/2abo5DIpoEooaRaaRLke3h7WLR3mUSyQglGrsEQhWA1HoBIVcYlV5nsA6Vgf9Oasz2p3H+GRyyCs3rq030VmAbXxJqQaKF819hWol4ukMnzCsh3C+2kAe8Hy6sGUdbN1bkow6aTXJs9WlWsvKqASjKDYrIRiFuaolH7gf11AZX5pHTQFlLKW7zs8CUrlLt5yjnSriWmTtxWfxEoG3rJPgJy78n3Vtlzv+dirNYaGnSXoyqhfEqxlkSLwrOP3T5XfZ8vLDmgO0xrYI7z8Om3PXYjcYpBDbelx/k2rS8ZiWnv6V1QIkSU8X6/n/9+M9dyBRV/WMUEYMFFyHS58fzggYF2qgVcLX7tgJtTfOoAIFY60HdS0p8EworxAYlz4vHmB+QegtnNSzyAB7TzqmOeqyiL5tZL9kt9i1BxOmvQ=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(366004)(39850400004)(346002)(136003)(396003)(86362001)(316002)(26005)(38100700002)(66556008)(186003)(2616005)(66476007)(44832011)(64756008)(4744005)(66446008)(6512007)(8936002)(4326008)(6506007)(6486002)(110136005)(2906002)(76116006)(8676002)(5660300002)(478600001)(71200400001)(91956017)(36756003)(66946007)(122000001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?T9HaL/7QZxi1+PJ7T3dJEeA1QViwh+vHOki8j1nlZQsc5Lx0irnApi9l9?=
	=?iso-8859-15?Q?ZOmgVRZ09Ru/VUw1uu2i+NEpSH/c5QtNKrxS1Rl8v+SNbLDBrO2ILyfCB?=
	=?iso-8859-15?Q?vtoZ8HmZe/+m/Tka0vPCgPER7zlEReeotilMB1qDIZ8feYb7F2FuRhvNe?=
	=?iso-8859-15?Q?5uM2m2WMOC7maqnVq7TJDGV9YzzMdrpIL6SAr98O+ZsCbIOBEot2kJZsQ?=
	=?iso-8859-15?Q?VONIq1xnbgHxRASzYNO7Su6fhCdnKdyIcj7TH03+5WNb2ft4GfRnkpak6?=
	=?iso-8859-15?Q?DNdIXQTK9H7ihX7Ovw7awGhp6f6CzusXE/XmWERkbEY/CHus1vkPFUagE?=
	=?iso-8859-15?Q?dcMtDg8XsjDyA2J2QE+LEQ+fpLU1jnOGWku3/EX+KB5sfJUguYPS1EvPU?=
	=?iso-8859-15?Q?6KGPNIQlyiWp3cSu6l3xVVzE9FodNBrEO9qs0xli19KudR5z7QFuTqezb?=
	=?iso-8859-15?Q?qEs1HrAka1BBZXMBs2iIy3AgW8iQLPcxc/DjTC88pD2QZytOR2KEpQi7Q?=
	=?iso-8859-15?Q?N0GvWJ1s3tRpdBClKOUR1vhDHQ1pQxaHHeeg1+zBE2snairLmHth4yhPL?=
	=?iso-8859-15?Q?Yjqs8pFZaYvfJGUfwobOW+WOom6muJIRHwuTZOWsHqtqqCmwhdB20ypUr?=
	=?iso-8859-15?Q?o5z9MOqZF10Vprr13yTfVv9FhrxrHHf+z7YSuZprLGZnYIu1PPghucqNO?=
	=?iso-8859-15?Q?WICrLWOUAzVgxz/ZFSoqlXA1lqVYCridxa2MOkdTng42OROIAvWkf6w+/?=
	=?iso-8859-15?Q?r4p9iHFczJOUpBeK2Z5MPRwXe28JwkK3iFKAMtD/6j44WFJZ1dxF+0NGK?=
	=?iso-8859-15?Q?WRLfo4w/shsRndhkvRizik0k5aCUvvYRnyq7iDANxrkvf0oQLXSsZA8KN?=
	=?iso-8859-15?Q?5jFtV6rePFnorqY1jAE5+ztUjMFKCOz96L3uImNduodGHLk3aFts//Elm?=
	=?iso-8859-15?Q?Dw6g7TvcqHuEk2KOAz562e+2ERA3cBVUQOH/UB2jt3Y+jZ1/kTarscNMr?=
	=?iso-8859-15?Q?i4RL22vj4PYkES5/zofGd4HDOa0ZtDHMu0glOLbJnxmnX5mbcZnSMYEG+?=
	=?iso-8859-15?Q?k/64kvTKxsTCnHnbKfmRrjWSEuVjNy1ce8KlgloyCznw/FW0WDbbehh+O?=
	=?iso-8859-15?Q?lM7aenSVEr93x+mwlSbIEjxA9yUZVK3osjeUNct+AqlnzLrg6KKvQpIyi?=
	=?iso-8859-15?Q?FHiBAs5c7uTdDxBNLZ+BNyqTzOuZWxYh8LdF4T9h3JpRw72+693Rj5Aly?=
	=?iso-8859-15?Q?XZxvwinub/aUvliuzYxC8TeCrBdXAQlnZ8U/yHILiBbrI0VhdwLXbHKDG?=
	=?iso-8859-15?Q?mSoaVX8GFYNzlAdQI7KnipaMa7TRevNEDPWpyNnop9v5yp3AEaihubuKm?=
	=?iso-8859-15?Q?5N1ErD2osG8Yu0q/WxBX+3iTZtK/PIWwc?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c1a5f7-723d-43fb-e3d4-08d916493d68
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 19:56:46.7074 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JE3Wqz1xj/njb73tBf6sZ4q4hlir6/9WPk4dI6L4aOCqz4ln/Sng3zMsh8MdDC47pM+/diwsK6RZ3vtuU3MCcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8026
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14DJuuAR019917
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 4/6] multipath: free vectors in configure
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
Content-ID: <8D83F2C5F3549F4D984A905AFA5A5D3B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, 2021-05-13 at 12:23 -0500, Benjamin Marzinski wrote:
> configure() can retry multiple times, each time reallocing a maps and
> paths vector, and leaking the previous ones. Fix this by always
> freeing
> the vectors before configure() exits. Found by coverity.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

