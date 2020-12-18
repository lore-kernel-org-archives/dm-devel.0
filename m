Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E68C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:32:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4134F23BA7
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:32:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4134F23BA7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-CTyFEJxZPhuOziVhAnq9Ug-1; Fri, 18 Dec 2020 18:32:02 -0500
X-MC-Unique: CTyFEJxZPhuOziVhAnq9Ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C5B610054FF;
	Fri, 18 Dec 2020 23:31:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AF0F57;
	Fri, 18 Dec 2020 23:31:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BCCEE4BB7B;
	Fri, 18 Dec 2020 23:31:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BINUq3H030894 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:30:52 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3341510DCF52; Fri, 18 Dec 2020 23:30:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E30010DCF5C
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:30:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BEC11811E78
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:30:49 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-451-MylyZvLAOF2xubTG2HOdAw-1;
	Fri, 18 Dec 2020 18:30:45 -0500
X-MC-Unique: MylyZvLAOF2xubTG2HOdAw-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2056.outbound.protection.outlook.com [104.47.13.56])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-30-7yfj45IyNbK26G_O29WCxQ-1; Sat, 19 Dec 2020 00:30:42 +0100
X-MC-Unique: 7yfj45IyNbK26G_O29WCxQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5387.eurprd04.prod.outlook.com (2603:10a6:10:8b::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14;
	Fri, 18 Dec 2020 23:30:41 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Fri, 18 Dec 2020 23:30:41 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/6] libmultipath: ignore multipaths sections without
	wwid option
Thread-Index: AQHW1ZJ9ueQhvdNTtEKAc26q6YmCgan9gHIA
Date: Fri, 18 Dec 2020 23:30:41 +0000
Message-ID: <f85cd35716780e8e2dfe096bc7789762376efc18.camel@suse.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608332802-9720-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06b1428b-379a-4eb1-e70d-08d8a3acef01
x-ms-traffictypediagnostic: DB7PR04MB5387:
x-microsoft-antispam-prvs: <DB7PR04MB5387C7F6B361BAA2DE5A520DFCC30@DB7PR04MB5387.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: sViL2F1KxhkuAt70SsASifzJQ82y0lbk1rd7byvXGCzJzLALNQoJ9GDBXtSDtImx74c06taQK8+VFlkftssIToTQNdCL+v+JAtYSPC43UXGKVH1vXVn27rJ7oQQkc0VpK5EX5X66qoRvmquluGJpZ4M73wJ+U7YNWHI9QE3Uy3nUvFRr7lA4LB2UjWpclxxInomyuY7mCD870ENKONQJCldRyPzK5E4MC8J3ik9lAWj0FZsLsVcV4wdQpheh0A1cLkSDWArr4Z1eQ6ebUZUqfl+igjv/OVT1b+IKKC6wufcLOyS0FgFD17MpJB4T5n+Pe3DEQZDs7QZoUXz3ORS47A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(376002)(366004)(396003)(39860400002)(346002)(316002)(110136005)(4326008)(71200400001)(36756003)(8936002)(186003)(86362001)(26005)(2906002)(4001150100001)(66946007)(66446008)(66476007)(64756008)(66556008)(91956017)(76116006)(6512007)(8676002)(6486002)(478600001)(6506007)(2616005)(5660300002)(44832011);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?0WjirEIfRWaZzLy0OXP3/3OP/oafKdtr+Lxa6tI8gc4K1IDkzgUqLvXoK?=
	=?iso-8859-15?Q?Ea1ZTmikhNgdPFfun+U6dF54rXNi3pi5n15Tg+8cd+uEzU+GERp+xllsR?=
	=?iso-8859-15?Q?2QlvlUrOq6rPmYkArbGVs+Wvz7cnp2/fpBzN20Luhih9qKAGNuxdDjcsL?=
	=?iso-8859-15?Q?vuZa+XF0FTgOa4MkX7/wkbkaUjor8vJeQrNKnIMt3HUR+EOKGYCurSbY+?=
	=?iso-8859-15?Q?Y6US/QC9OARQshGBUjdM1INzZLTtnO3+jMNrZ19FVzbKhbadHrafPN11n?=
	=?iso-8859-15?Q?Wo3GWfJJWWHuzRfTrrbBZz0xWASR0DQoGBwKOHoX0JyE3AiLW3Q7j+sPp?=
	=?iso-8859-15?Q?wJLQjatBFkgytxyfD9BV3XvihTGHA1QrUoOo9f5MsEHrUd8KLVY+I1yCz?=
	=?iso-8859-15?Q?qlnYevUNPFjGDYyc9+L8rRM/mgZWJFL/Td5/6W/K3CqlqkKzST7kWorwX?=
	=?iso-8859-15?Q?lW8f8BGSANS138Zh4pvooTDh0+6xQp2iHyOXcSjPTh+ykQqox1xJhVmQA?=
	=?iso-8859-15?Q?NoTRJs1UhKvofBwdZD5RI4U31OvYY5tqCPPkJPBY3ejYYZkr4F5ND/pW3?=
	=?iso-8859-15?Q?Xtg/lT9HViBuDkh2DsG3gOXQ/byK3g0ppeIECE21wP7xEe+XllTzYXj1P?=
	=?iso-8859-15?Q?T60ATh16HWDr7mTmfKqUKivREXplP0f3oMMBuGOe3akkJzoNRo9vR6MLl?=
	=?iso-8859-15?Q?daCvp5hTJJkvirL3Ldsa19XKTihkyNsG8Rd7qZhO5iGDugIWfSA8wrO+P?=
	=?iso-8859-15?Q?pkxrsN+a2B3vixOlLY2WsfRIjTCDLdh0ALLknCJU9m0Y+qXr/1zcs9wpP?=
	=?iso-8859-15?Q?ZL7dNqitgmoFwjdnatYvQI17GrSzzR0+NIlPlsOO6WL3a3t2TnQafSIxX?=
	=?iso-8859-15?Q?PhoL3xE9uD3FjVgD0c/h8HqR96Y+WfROLPSQD5R5NaMvXimUPk9EWxJsr?=
	=?iso-8859-15?Q?r6grQ/dSNxeI8vWP6V6rVbS5XK4clhnxzLNhN6q02y0h5UkSVUlE2l6WB?=
	=?iso-8859-15?Q?rXEyi53jzccf6KcBrIbDNWyZnDGJ2p+ZtOv/2ACGzeWpLg7Bdxvg2kr?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b1428b-379a-4eb1-e70d-08d8a3acef01
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 23:30:41.1617 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +T+qyJbFDw08Wy5Dk9RZx0+mbutS/CFUwOjauuyK7c9g8iAbMu2P5afhb2Ue0dJ7Njqz9bKuu3hm7CN1z86mmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5387
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BINUq3H030894
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/6] libmultipath: ignore multipaths sections
 without wwid option
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <4F67DB58782767418CDDD82A1E4C914D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> "multipathd show config local" was crashing in find_mp_by_wwid() if
> the multipath configuration included a multipaths section that did
> not set a wwid option. There is no reason to keep a mpentry that
> didn't set its wwid. Remove it in merge_mptable().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 9f3cb38d..a643703e 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -509,6 +509,13 @@ void merge_mptable(vector mptable)
>  =09int i, j;
> =20
>  =09vector_foreach_slot(mptable, mp1, i) {
> +=09=09/* drop invalid multipath configs */
> +=09=09if (!mp1->wwid) {
> +=09=09=09condlog(0, "multipaths config section missing
> wwid");
> +=09=09=09vector_del_slot(mptable, i--);
> +=09=09=09free_mpe(mp1);
> +=09=09=09continue;
> +=09=09}
>  =09=09j =3D i + 1;
>  =09=09vector_foreach_slot_after(mptable, mp2, j) {
>  =09=09=09if (strcmp(mp1->wwid, mp2->wwid))

Wouldn't you need to check mp2->wwid, too?

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

