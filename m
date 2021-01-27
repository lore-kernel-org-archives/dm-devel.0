Return-Path: <SRS0=jLbn=G6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72057C433E6
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 09:41:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9888020758
	for <dm-devel@archiver.kernel.org>; Wed, 27 Jan 2021 09:41:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9888020758
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-565-QyBKnduFNDqe70KANktydA-1; Wed, 27 Jan 2021 04:41:45 -0500
X-MC-Unique: QyBKnduFNDqe70KANktydA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4726C190A7A0;
	Wed, 27 Jan 2021 09:41:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95E445D9D5;
	Wed, 27 Jan 2021 09:41:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 33B85180954D;
	Wed, 27 Jan 2021 09:41:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10R9fWtE020999 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Jan 2021 04:41:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7E8D81134CCC; Wed, 27 Jan 2021 09:41:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 799AC1134CCB
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 09:41:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17884811E76
	for <dm-devel@redhat.com>; Wed, 27 Jan 2021 09:41:30 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-395-w7EDHH2IOt-AK3GqjL8hIA-1;
	Wed, 27 Jan 2021 04:41:27 -0500
X-MC-Unique: w7EDHH2IOt-AK3GqjL8hIA-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-17-Yk9bwjwwOIGFCy6_fvEJow-1; Wed, 27 Jan 2021 10:41:25 +0100
X-MC-Unique: Yk9bwjwwOIGFCy6_fvEJow-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4473.eurprd04.prod.outlook.com (2603:10a6:5:34::26) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16;
	Wed, 27 Jan 2021 09:41:23 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3784.019;
	Wed, 27 Jan 2021 09:41:23 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH 5/6] multipathd: Fix multipathd stopping on shutdown
Thread-Index: AQHW1ZJ+SJOHFWrTD0++S0No5oFU9qn9gKcAgD1oYQCAAIz3AA==
Date: Wed, 27 Jan 2021 09:41:22 +0000
Message-ID: <98656b40618259b3fadd703742c0b98b0afc050c.camel@suse.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-6-git-send-email-bmarzins@redhat.com>
	<2bda2d5b184bf72cbd63ccdcd7d63404c5414ce5.camel@suse.com>
	<20210127011650.GH15006@octiron.msp.redhat.com>
In-Reply-To: <20210127011650.GH15006@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [84.58.19.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82ef22b7-ed5a-4b99-bb65-08d8c2a7b566
x-ms-traffictypediagnostic: DB7PR04MB4473:
x-microsoft-antispam-prvs: <DB7PR04MB447368D0D69DA3FBF175AEC2FCBB0@DB7PR04MB4473.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:240
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: u/sAiyPcmuoygvUXaxn/EXr+tANtInbOjSLBXZMe2y+QLRS5ktn//ic95736zvkgPx92mqI7+iqkXTaKsHybrrCNLrSBrVK5wiLlA28NMIDNRf0pVSJ2dhIyKXPfsYnlRzBca5vFJ1vf7AjzKUdcCK3HqrAFiixCKN0kNZhEqxN1LjNvjQyxRH8vbJTHzCGCEsPTV63BDHl24FPWxR/8pP/yCKOe8qnyxT0HzJiOZ66KLpioNJra4pcPYLtoaaY+OdbZZFL2phj6okTfNPvvDw8BWY8TFTl8M0rrk63SFdVgvG5ds3pfqtIwwUTL0sCEX6MFjGfDHB38oHJYxdJ6AeXIHuxTroGnGiPmtWxRJWHYm/XBv/ajPFdxJIc4Qp249q2CXYfeRTMu+xAeu1vyl6VY7XJlMZUkXNHR4Vgz9Ol54r9Q1IJvLdjfnvYyDMGOJyQhrOcJPrBI9ojM/mPU6rXe6wx0c+411ch3vnCssjqSpWMYLKQaQfn5hr3E/kBmthMckz3x/oZPu5qIv+6p3A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(64756008)(66446008)(91956017)(6506007)(316002)(66476007)(66556008)(2616005)(66946007)(5660300002)(44832011)(54906003)(83380400001)(186003)(36756003)(76116006)(4744005)(6486002)(6916009)(6512007)(71200400001)(8936002)(86362001)(2906002)(478600001)(4326008)(8676002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?WOxHt3rjj0wYpmyD2FG6iyonHJwHWDQI8rNqTE0/orv2JS0mliyhTa02p?=
	=?iso-8859-15?Q?3vWX0PidjQ8sgPW5qF20igjQwAWIPgQ04Wo1vpl/SbC6MuNGoPctGe/ZB?=
	=?iso-8859-15?Q?K9NDpelk/KqNyMPbacR7UR6uyAPB0uigg7p3qdmfvCeuUO9mWkf/m8vLH?=
	=?iso-8859-15?Q?lD/x/b6x6Vqq07HPLbOGFaxHZEZhVrYZQewsJ6OZpQgg/wjVv1i4xM1aJ?=
	=?iso-8859-15?Q?NKDlXFahy0xurPDTR8IZ45RwsC3EMch3TR2lc3WJBkGcPLSB8fSDX16mc?=
	=?iso-8859-15?Q?MNrp3V+Q1W9olFm7OASCKfwpD37EqoK8MjrqZ106RqCLzaf7nULWD22Or?=
	=?iso-8859-15?Q?0c6RKmAVzpwSWAQpsn0KlvqBOOQvQUKhubNctwVBdsRIhnNbg0lbSCbhw?=
	=?iso-8859-15?Q?p4i575GaqJVa/7JVJT16sxPlIVMih+vF/sxGiUozQ5O/nOo6qulrpwgL/?=
	=?iso-8859-15?Q?ywRFRdUZQWF1wfl9YiISMX+GSqJI2DgPKEPHvcE0WnC7XacBxyMsEtZgc?=
	=?iso-8859-15?Q?olPwkgsfmrKzilxYY+9/yUmAQE7RQpSqJPIihyJ6r0317QwGXTcqDeIgK?=
	=?iso-8859-15?Q?ntMFcNYF8tjPH73rSE5beCBH5m4toUagJYZJp9DOU0ew8yWfsHWw57wE4?=
	=?iso-8859-15?Q?yr9uY7dCktX5VNNfxegA/RDZuw6BFW7Y62vE7YbMCHWiDNavgSgu7kawS?=
	=?iso-8859-15?Q?gcxNfVss0+WeYxBF3eOkx2+V14vGRq29IydwzdTTJXXd7yRePd5NTH9sk?=
	=?iso-8859-15?Q?roGT83dSIQO4SSsKYcvoXgrIbkdZiACsDzzlMb1OdE6EezVmq4w2PchUf?=
	=?iso-8859-15?Q?RluxwSog//IOHwmhPqvfoxOb5BgsuRN8BaD6U7woLgY100Dm65ybE5b7Y?=
	=?iso-8859-15?Q?4TYgCVW0BB3wpd+5dqVjACAEPnEfumvXWjixdAvZwXdV5rlmB7Mna/tVq?=
	=?iso-8859-15?Q?XpwB8dm2pDLwuPTg9+FMSFAiCY3TT7gsS9Ii8BSwE57QELEoo9Rsd5osG?=
	=?iso-8859-15?Q?EsbXljPfTwXfz9Bzc6D3K1WrUY7tdHfCPGJEC/iDaoLc5nHGQ7U7B37vF?=
	=?iso-8859-15?Q?oYpv8vA65dO5jXdhYqXp78522SlSD/D10qlmMhUmsVxWwXGgqeM7HZOUN?=
	=?iso-8859-15?Q?xg6ej?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ef22b7-ed5a-4b99-bb65-08d8c2a7b566
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 09:41:22.9741 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GNEZYAplPsMFGHHu62y4C2OLgNJ3flSTjBbWs7HmZJ1uM/QeoKVwMuJ+GswDH7lnxYetnQI/93Ru4lqK8OsVQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4473
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10R9fWtE020999
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/6] multipathd: Fix multipathd stopping on
	shutdown
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <657EDF1FC3987542BDE120D8B297405D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-01-26 at 19:16 -0600, Benjamin Marzinski wrote:
>=20
> Martin, I noticed that this commit didn't make it into your queue
> branch. I assume it's just an oversight. Right?

Yes, I'm sorry. Fixed now.


Cheers,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

