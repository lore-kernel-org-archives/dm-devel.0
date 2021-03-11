Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9296C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:33:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 53A4D64EBB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:33:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53A4D64EBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-vtfdwIWXOh-js58OKou0Ag-1; Thu, 11 Mar 2021 16:33:51 -0500
X-MC-Unique: vtfdwIWXOh-js58OKou0Ag-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF57C817468;
	Thu, 11 Mar 2021 21:33:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CBA819704;
	Thu, 11 Mar 2021 21:33:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B5AF218155DE;
	Thu, 11 Mar 2021 21:33:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BLXiE3013872 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 16:33:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 41CC7FED47; Thu, 11 Mar 2021 21:33:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 353B8FED46
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 21:33:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C108E857AA1
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 21:33:40 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-594-eeo5zCu6McaIRBnxGCPYJg-1;
	Thu, 11 Mar 2021 16:33:38 -0500
X-MC-Unique: eeo5zCu6McaIRBnxGCPYJg-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-31-TsRZJke4MNWbGH89frVA7Q-1; Thu, 11 Mar 2021 22:33:36 +0100
X-MC-Unique: TsRZJke4MNWbGH89frVA7Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7351.eurprd04.prod.outlook.com (2603:10a6:10:1b2::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27;
	Thu, 11 Mar 2021 21:33:35 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3912.029;
	Thu, 11 Mar 2021 21:33:35 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/2] tests: add tests for checking if alias is in use
Thread-Index: AQHXFfKFOQCqPfZLjkO8jcApFJHsd6p/UHsA
Date: Thu, 11 Mar 2021 21:33:35 +0000
Message-ID: <092a945926de8bd51f6c80088a7cdf14c6ba46e5.camel@suse.com>
References: <1615410915-12555-1-git-send-email-bmarzins@redhat.com>
	<1615410915-12555-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1615410915-12555-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50098e62-375a-49e2-279d-08d8e4d55376
x-ms-traffictypediagnostic: DBAPR04MB7351:
x-microsoft-antispam-prvs: <DBAPR04MB7351B4AC12802E2594217D34FC909@DBAPR04MB7351.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:644
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Jo8bkf1hoUMiQP2J/0SlJQXKh4nx5x/mfu28uVZ8xuNUWx/m2P93mLbfwJdh1e1TZSUHtLxNBoMpl4WZS6XJtvQ03klRkJn/W1CqpAndZuxYpNUYPDkmObAegN8hSUvssyvArpSEqtzSjyzRp3e6JSGH47kXXxdiGhu4dyWK4cW0+mMwobEStLtZMcXGTBFmMCcLvU2+MFh7E4EOWA58sfmKxW9Q/PrssfRR0LeYGMaP0eASgRJtPtErwhjD+8vj9eBvl5GPVgr3clvIrw1NVxBnb5JHEVH1+TNVxqpJ/x3y4cTale6l6fQiEv6jXV24vpDzeVgkID80BhPBl3ZKN3tA5hsc9+okR989HsFFGIFXUJH2MuHmkiFs9sVuVwZTNSG502SXSVEE/iD1ZVQZmy5dhYp31wUUb0ZwrHnpksAVd1iK3G0yf9Ph5MkmIjSlzcNXFRgpecPu94NTUGcT4xui9C3YHMP4cDh9ngAYSpny3ozCZbAWfqSBik5HLKuRV7bw92UQYJrS81x1N1Fbfw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(366004)(376002)(39850400004)(396003)(136003)(66476007)(8936002)(66556008)(91956017)(76116006)(66946007)(6512007)(86362001)(71200400001)(110136005)(6486002)(6506007)(316002)(36756003)(8676002)(2616005)(44832011)(26005)(5660300002)(186003)(2906002)(64756008)(478600001)(66446008)(558084003)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?T5NPBgrup8dbok3kGZtNcgSnBhj/DDxfTs3GLnTxcKFvfxfNI+8x3NSx7?=
	=?iso-8859-15?Q?FgEHoZkJsJCMSEcCkS4OpaNo0soqb8b4DOwoyefCP70wxSKVq/QJh82JI?=
	=?iso-8859-15?Q?X2SVVxgdJ/T78zkYyzMdwH65B2EG6DZV8FZmN4e7jro70u5Eyakm2ZZtt?=
	=?iso-8859-15?Q?DdbtoeVhjGOJFpS1PJ15HlSY45bAKmWKeWQwRI6VpWTy1mHrfY2HKw1py?=
	=?iso-8859-15?Q?PsYdzJX7GA6CuarISmvvB5GbgiFsrVYxNs4Q+orWFEnd06Jpswvr7gqHE?=
	=?iso-8859-15?Q?pwCqkImBAFlpCQFytBT9mHMsZUP7msOmDj3GPYvqWKovLQcjX/V0pmwKq?=
	=?iso-8859-15?Q?ETEUY9xbDVDqoDEtOCnK9RW/zJNbHqIG78gGrS8NaCaor1LRCSg/+iOJt?=
	=?iso-8859-15?Q?Ujo4bDMWaJfzoM9UaW9Ziemh5xPylGlQr7dl/tRovYUQtETbkr24frtZ/?=
	=?iso-8859-15?Q?yzxg1guJwtIQAp7zyAs2VL0Pgd+0z/gYbqLlFTDt7QbtD1niu0XmjLk88?=
	=?iso-8859-15?Q?Q9KEtCu4MO6daFlk5y1mEdalgWrkkCqRbSeYz8nv/cEPkfdv1dowSQge/?=
	=?iso-8859-15?Q?dLUcaIprR8A3cnrFwAcWnXxQGxtAYPmCERRwhGrIW/vFiS/Jp8AfO/lzO?=
	=?iso-8859-15?Q?vsLZiuuDq2LWFctETUnTkQW7JI0yrPOjovL04GtMmlR//Tfqo8kaJzskh?=
	=?iso-8859-15?Q?9ZXex4YCvBo9cHiVoUhFGRDU/z2bkEXivWB200g+x7FGPJJOqMzcszHfw?=
	=?iso-8859-15?Q?KWykWReosspt/M0HxSjzQGJe4JHnPOPEXb/ldJXvF/dZH75DUig2jweBQ?=
	=?iso-8859-15?Q?g3cWrJMR4qXgJrnWttl6ZQx0iLd3M/aEqNC9s/Wcwlc5pQKd1DQ9Mf8zv?=
	=?iso-8859-15?Q?fIxLMbxfpbiojf1BglHpllyVfhi0cAN1diUIiGZdEGSoDRgepm7U9KE/X?=
	=?iso-8859-15?Q?fPiC7rbgwzLgSMe2JFiZLM3PWFOj2E5FtQ1HFo1UYVQsBuWwMQwmfhL/2?=
	=?iso-8859-15?Q?RM5Ye5ZGkVNgJFnXtj5K1Kh/khR9/oY7CkDYByRBWJ43IpNTFKEPEddEm?=
	=?iso-8859-15?Q?NYLSQxo94md6NTGHlYk3r0jvC7RGLFYo9U+twnGsmp6cSIoIJiho1xF2N?=
	=?iso-8859-15?Q?uV+8qgwlebkWMJi6iAZl6dvsItuX2HntZv0Qr3StdF6eZxLHB/Z6HybI5?=
	=?iso-8859-15?Q?3VjYuuITx73DlInenDBP/oIm2MuQOkedk6xSF9IfBFVJed4+fDxVsJfP8?=
	=?iso-8859-15?Q?1SCIZIDItNIQGvSdCGIqG6pbmKiZgy1ktfhjaBPIxuALZgIOMdtR2OAPz?=
	=?iso-8859-15?Q?S2AiU5wSaMlMoV3YWLk5rUK4x8oJpz61o1gQ0z6Y71FBbTGs1/BqZdycE?=
	=?iso-8859-15?Q?gs8kIC5LfuMqHisZ/MZHnl3i//KnFJyz0?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50098e62-375a-49e2-279d-08d8e4d55376
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 21:33:35.1135 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XjQC6NBf/LxBTn52DBCqXabhKhJmOmgf+iKngty1rvln/s4cyCyQObYiVyA2P6Mb/F3Zj08EAHOGG9tSdsiKpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7351
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12BLXiE3013872
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] tests: add tests for checking if alias
	is in use
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <5B31C77E45011F4C8FC3C3C2F83E90A1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-03-10 at 15:15 -0600, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Added this and your other series to my "queue" branch.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

