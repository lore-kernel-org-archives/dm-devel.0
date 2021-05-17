Return-Path: <SRS0=cSVF=KM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87703C433B4
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 18:52:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DDFDA61057
	for <dm-devel@archiver.kernel.org>; Mon, 17 May 2021 18:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDFDA61057
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-P806zHkDOw-OJF6dNgviRw-1; Mon, 17 May 2021 14:52:12 -0400
X-MC-Unique: P806zHkDOw-OJF6dNgviRw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 913F410509DE;
	Mon, 17 May 2021 18:52:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE64E5D6A8;
	Mon, 17 May 2021 18:52:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0B0911800BB0;
	Mon, 17 May 2021 18:52:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14HIq1kc017937 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 May 2021 14:52:01 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8AE1311457D2; Mon, 17 May 2021 18:52:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5010110FFE70
	for <dm-devel@redhat.com>; Mon, 17 May 2021 18:51:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B1E595F34C
	for <dm-devel@redhat.com>; Mon, 17 May 2021 18:51:58 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-541-wM_PKO46N5ShLKbOApZxJQ-1;
	Mon, 17 May 2021 14:51:55 -0400
X-MC-Unique: wM_PKO46N5ShLKbOApZxJQ-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2055.outbound.protection.outlook.com [104.47.4.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-31-xltEH7XHN-GHQDi5Ucs4hg-1; Mon, 17 May 2021 20:51:53 +0200
X-MC-Unique: xltEH7XHN-GHQDi5Ucs4hg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5065.eurprd04.prod.outlook.com (2603:10a6:10:1b::33) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Mon, 17 May 2021 18:51:52 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4129.031;
	Mon, 17 May 2021 18:51:52 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v4 3/6] multipathd: fix ev_remove_path return code
	handling
Thread-Index: AQHXSzn99+6T/KIoLkS9WBxfb33JWaroBPGA
Date: Mon, 17 May 2021 18:51:52 +0000
Message-ID: <d18212229ca58f069af5a7489548ff228a3552b6.camel@suse.com>
References: <1621268999-6280-1-git-send-email-bmarzins@redhat.com>
	<1621268999-6280-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1621268999-6280-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5def50b3-615e-43ab-5520-08d91964d604
x-ms-traffictypediagnostic: DB7PR04MB5065:
x-microsoft-antispam-prvs: <DB7PR04MB50654F33896F9EF77A297F98FC2D9@DB7PR04MB5065.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cCK3NjKIgzbFFA9fmOecCMjkZsaZQ/IN49rvzUr8RQK9QNGn3/jBFq6O+KZsDCg7enFt9ek6szkPoQSa+tzZuYCpb4xUFJP5JYgCVdPxSAOPNvfSAf/EpXKCsCtLBtopi3sNuvqHv5EsDroZ+dCHbP2rt8tkLV8D55NUJhuRbSvK8j9mWcIC6VceBOrP5mumPluPTH4rjcNJCDV5nAiG7tK9Wk2xNuUExonOp2j2Jxh3rfOnBigPbsyKy6YuUM61/3JY+QN7qLQ6jutH1WrFlm6NBstGs2//P1YGBcZ6nBhRfaIauDJUu1KnJiZmzq2X6+/qumX+U63/X7WU1mECZT5ypbrgyGYenXVEbTOMtYVz+kJqlJfhLtXW+S8ty4ZoLuKVUxoxHlz1GX/ncF+qdkSHOSacAq6DWF8XIyl/4t20cnQsOKZfW1Q/CffVjkgGXIl99VrihMl0vSR8XpXPA6V8ZNnPMlmn65zO9gDm3/2VrX0slHf11CqG/kDyaADsfL8ke2iUMpkSo8nw5agMF1yq4bIDPa0OZcPKCztpuV3RVD0Y30qkv8tBpmd0aoLcHEz5suhgsxL9uLtdze/uRn5ng+QT7XwSbEHhBRvmH5o=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(136003)(39850400004)(376002)(396003)(366004)(76116006)(66946007)(71200400001)(91956017)(66446008)(64756008)(66556008)(66476007)(4326008)(83380400001)(8676002)(6486002)(6512007)(86362001)(478600001)(36756003)(6506007)(5660300002)(2616005)(26005)(110136005)(316002)(2906002)(4744005)(44832011)(38100700002)(122000001)(186003)(8936002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?pm5TWS0VgH+jFdrraUn7u78PN1TRoF9OayDBWXHSPXYZaHTlwBytL1FPM?=
	=?iso-8859-15?Q?ySrj5sQzCmWVwHNKQaOWdsVJwNnmRfkuSvASI02RFYuTyeowVxj13rYo9?=
	=?iso-8859-15?Q?3FQIUKHiVmVdOCeNUxo2ai9nrJC+hJhLOa1V2cBEjESO+Y/cAXIiqL4Zf?=
	=?iso-8859-15?Q?1i+HKxT0xqEo1Da5bQtb29PWdRm4YfxOB3UhngIprXn3JwNf5TSW8HoMq?=
	=?iso-8859-15?Q?uqbwixFovtsYQ5p+HKeD6J+5eC/zBXU1XhPWK4OQpNND6PBnlMf8QyXIU?=
	=?iso-8859-15?Q?KctqgnNDMF6F73KA0aQVNVVkYt7PauzSb0Kb0b+QZRu3dIF2d0DBaQalL?=
	=?iso-8859-15?Q?uUaNQeSqg5oRgqx7m2rh1J4uWMbSv/KeJNzTOQiTOvrWGGqXgW8CsDMiF?=
	=?iso-8859-15?Q?eesNgin5cAcVyzXchGxaW5KGIb8ENTQfhYY7Ot6VVgUqbJlxNxLf7i17H?=
	=?iso-8859-15?Q?akv3qWbTfUBmC3DvEXVd2XFgJ4T2rVPwSyB06DzhPd1CSGex8mMBw0SAH?=
	=?iso-8859-15?Q?XPFonqAJOW23V3hKLShN5NVDTeYqn7tSHZXNUTnMIqPNcvjh+yVpPBGjC?=
	=?iso-8859-15?Q?tqWVM4ZfANav7LbpU5VRnLzeKrtnOB2Q5BqhMLjOye8BiuLlFajP0zXob?=
	=?iso-8859-15?Q?JGvgI+dmkeFwBktNp5ffjzO6f+MoEZtCn2tRIo157xr/deN7gX8PN0SbQ?=
	=?iso-8859-15?Q?sF/iEMA63bV9TEdM5S8q7n2t7FTB9CYeBlcrGZp/+cpLNKLWnbCO7TpRH?=
	=?iso-8859-15?Q?QFeODLc/B4OZCaQz8uV54ZCWltx/Ne1izHGV6tRK9QErfnUReEkJj2I5o?=
	=?iso-8859-15?Q?wZPvTvH1h9+aaegRMtVPTb3kuz9D1AL5Noja8muxxKWTtkvBydfrpG4HS?=
	=?iso-8859-15?Q?zCmJ2yIRvT0lwjbdquGOxmZNvWGAnq2wPePL3pWU8JlicHJqZ1g/+1kw4?=
	=?iso-8859-15?Q?Fv5ACoaA+dD1MgzN9dPmN575qyFDR/IhJDvcEbJYgDf3/ssEWezgWo+39?=
	=?iso-8859-15?Q?ZYd2RN6eV4VGOWoqUMyQ/8triwXq6W+NPVnoLv1tTJD9bPltd8qtwzl1b?=
	=?iso-8859-15?Q?4c9B9Ew8LV54CfQT62qePxAVFnUaT6sCdq5N3V0enEEGMSMV2pHefKWz1?=
	=?iso-8859-15?Q?eEZY8ANi7PD3a+NzuJ3Qq8USYNlp/K/qbem97H6Gm8a2u53WvKfspd1Nm?=
	=?iso-8859-15?Q?eAj13ozZnDtu0Jaedk/pT0B3c1tKH6wj2S7jjVLkodDeGTvtjdU5wmw6t?=
	=?iso-8859-15?Q?yh1D19whJGHaWMo40zwojLBBCSuPgqJEPpMooXoZB7doP0eNwg6ghtraE?=
	=?iso-8859-15?Q?SSh2gOI1xPWtT6hGcmMYIK23KOU9CBsLxlegY6ovhqM1AKoCNotBG5FxO?=
	=?iso-8859-15?Q?3vbWiA4emXmaTTru71A/DyIYxv9uuIIXX?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5def50b3-615e-43ab-5520-08d91964d604
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 18:51:52.7048 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ae3oGPB0jXGh/uY6Eyyk5542CmMx7v7VzDfbvt8ZtY7aGvvPnLsVgcodxxR1FFPWh23mO66TblUkhIhV//DRjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5065
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14HIq1kc017937
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 3/6] multipathd: fix ev_remove_path return
 code handling
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
Content-ID: <5EB037D929760A4195C58934D924146B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-05-17 at 11:29 -0500, Benjamin Marzinski wrote:
> When ev_remove_path() returned success, callers assumed that the path
> (and possibly the map) had been removed.=A0 When ev_remove_path()
> returned
> failure, callers assumed that the path had not been removed. However,
> the path could be removed on both success or failure. This could cause
> callers to dereference the path after it was removed.
>=20
> To deal with this, make ev_remove_path() return a different symbolic
> value for each outcome, and make the callers react appropriately for
> the different values. Found by coverity.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>+

Reviewed-by: Martin Wilck <mwilck@suse.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

