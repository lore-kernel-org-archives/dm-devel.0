Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D84C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 08:48:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 59CE86146B
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 08:48:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 59CE86146B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-sm1yRFD_NnKNxs-dbnJWrA-1; Mon, 29 Mar 2021 04:48:00 -0400
X-MC-Unique: sm1yRFD_NnKNxs-dbnJWrA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AA42501F4;
	Mon, 29 Mar 2021 08:47:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7EC75C8A8;
	Mon, 29 Mar 2021 08:47:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 56B771809C83;
	Mon, 29 Mar 2021 08:47:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12T8lsUU009647 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 04:47:54 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 732D421CAC6C; Mon, 29 Mar 2021 08:47:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6793621CAC6F
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 08:47:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D2E280331A
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 08:47:50 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-30-JWMQoZQjO1-vJ4TNTO8GyQ-1;
	Mon, 29 Mar 2021 04:47:47 -0400
X-MC-Unique: JWMQoZQjO1-vJ4TNTO8GyQ-1
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur03lp2051.outbound.protection.outlook.com [104.47.9.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-35-tQcYTJReMumhgrUhcDEPPw-1; Mon, 29 Mar 2021 10:47:45 +0200
X-MC-Unique: tQcYTJReMumhgrUhcDEPPw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5387.eurprd04.prod.outlook.com (2603:10a6:10:8b::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25;
	Mon, 29 Mar 2021 08:47:44 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.033;
	Mon, 29 Mar 2021 08:47:44 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/4] libmultipath: fix priorities in parse_vpd_pg83
Thread-Index: AQHXIdphHMXt7za5/0CjNSBmSMx0R6qarKiA
Date: Mon, 29 Mar 2021 08:47:44 +0000
Message-ID: <4d6e8e67bf360ffceba16b14e018576206d5996a.camel@suse.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1616719966-10221-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e598cf44-9c2d-493c-2ff6-08d8f28f5226
x-ms-traffictypediagnostic: DB7PR04MB5387:
x-microsoft-antispam-prvs: <DB7PR04MB5387AB572B2D73C151C593AFFC7E9@DB7PR04MB5387.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: f2XDCc4R1WGrz/EXSxOVeXrLnhw7BBCFn0rJ16w/cHAYrl2nEySEBugbJkFDWYDfKWj2Agyi5cbD5S1VxAqKxrpoyvtoJArrcfLg3iM2AXnPXRXB+i58pUGJhop5M6NhcPXEQjeiOkUPzehscU/Tv7+sk7OlBB+MzA5iL8VAB1GAYTc7ciz03axYkIruG0g2ApbkmEQvfWjKPKXN554U8R2aO6Jzv6YBMip5/C1FuqJ68oUWvl2BgxWKYMUrFB5Z1Yrgx43vXvFiOnr6UAkAzvY69Bn9sqF7UjpqomQFkQ+pEJQT2yzUHNb+icuRXF7J6iwTz3qVY33CLFwN6thPdwLAeqoSUNEkI+MFpGyYTdG7u0k7zM5wXsoQAtwjCwf1lVNy8tn/YXuHvRUi4ODJNcbvIx8wyp+hRzEavFA+2ZGSBBzbb/jJi5i0HE2jP+1ZmZYLM2oOKd+GFOLnyb3rUFyPo7mV1270Fqp1If5A3iRRJXtZZqwmUXtUNY63r2nP2BqLpPAk9oK/Gx7e7z3wIzecNUSIOSBPK1hhQPCyx71/M0tELnMnrRpXva6beOQBvi4GdT7Ca+YQGESfejAXYXxlN5bBRU9edD5A0WNUXGcaVjs5GuSXxZxQ3kE2Gt45wv3fE6b9rzvm16u98S8VKQK2pEsju1x/nEgPAn9qLic=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(376002)(39860400002)(136003)(396003)(346002)(91956017)(6512007)(478600001)(8676002)(2616005)(6506007)(76116006)(66446008)(8936002)(5660300002)(316002)(6486002)(64756008)(44832011)(26005)(110136005)(2906002)(66946007)(4326008)(86362001)(38100700001)(4744005)(186003)(36756003)(66556008)(66476007)(71200400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?FKkwuOl/JiZ0HQDU1+QJH9ZUmP+vgc7LcNCytvb2hXQ8RXpJcINcerDXe?=
	=?iso-8859-15?Q?r/4JuJ1mM/D0jeGmMk95I2ceQlQrpvGu+PIJRJ/y0wwK0QSxAalxWIkR+?=
	=?iso-8859-15?Q?WZhwJ/3JTiXizF0YbPUlcw9sLx4Wm76kKN4u6WX7bgcVpA3hoBzVTDOY7?=
	=?iso-8859-15?Q?swvrbX7+aD7Lo6UziJ9OSxgAV+AwZfMikANGPxSjxjBnxd4SOMwX8eTmE?=
	=?iso-8859-15?Q?RlxchUj3H5iBaEZbT9NSpytm5GS0QZNPOLjisfehUHcs+7K34f6XOk8Us?=
	=?iso-8859-15?Q?LCuNpDAD87Wop02X+ZUoI8LS/kDYQF/gnU3rzefILQYZtWUueKpTnVKfT?=
	=?iso-8859-15?Q?Jf+H0VBw7B/f0GfQkMQ5EK4VozaWPEjxfvpDx/YAN4ZuIZ1XhJQ8toAb+?=
	=?iso-8859-15?Q?FOy00gq0YJYKgWbkyWXohIXzF8okootB5pw1DwUe1QgB67q3lx7zvm0CK?=
	=?iso-8859-15?Q?i6FCr2/1QXx2eArk9+52conG8m0VaCWL+1Og0twzie6Rw40lXE+Sw1U2Z?=
	=?iso-8859-15?Q?mRKym+dCMU+AEmAVg41U05TsgBtBtA/OiP0hfCnSzdmsNTc3mV7UOw+0u?=
	=?iso-8859-15?Q?2cZhV3RpNpfZdZejTKJb9WGn04JchcuXolM/oPHzujYWZF7aQpvcnSgyd?=
	=?iso-8859-15?Q?sPcuFiYpkwVBn3LuOvHQlNLDc5tfRQ/3xR8iL/B42Cmy7i2uo/8uk8Wrc?=
	=?iso-8859-15?Q?GwcST2MGxL2Q3PLu3QZJKEECWxccKDtjX98jjJT+akberD3YJsEcOLggJ?=
	=?iso-8859-15?Q?NGfCQCu36KMB+rDAlM2IKAwSTp1f6DWR2bejS9POECFMJfU9vwbOzYUdc?=
	=?iso-8859-15?Q?Xvcv7WP3T2kuLkPeEHzK4n6ZALBmPuF82tYZk9OaQWALq+L8tmwpaZHKQ?=
	=?iso-8859-15?Q?swgsP6/icoyDeJy6LVi+FzkPvLlFa9hn1SKDqVwSpz4srTJ4izA9amRbJ?=
	=?iso-8859-15?Q?tsunPY7SAoUHUV7ztJ+JtR8T4Tw/kbdyAyCIKfiAC0F8EtsAUbEVJ+xxB?=
	=?iso-8859-15?Q?uIhf8U96YkKKIpO+1kxe6j50zPkGt5uIdwQw0t/16Kpw4/myP5WhkyoEw?=
	=?iso-8859-15?Q?lUlUqbvEhMql/BoLSYgWSunABBwnGDLHq3lBl1QYSzSTzi5tO7uo072PH?=
	=?iso-8859-15?Q?ba/h7bjQv7kvMvr9gcMdBFQ4AeLS++VwVUlt6n/+ZPWBG3HdA8NNmN88b?=
	=?iso-8859-15?Q?V4kk/C+l5mUUFpKAq9ESDeCPBz+BOnboNPu+CR3vCOQKaJGLTAdXGr6tI?=
	=?iso-8859-15?Q?kxef/9uJmTIQt+clt4yfdVza3lb3yAWbYwuJFJPwL1YN8CamDGSkH6ctl?=
	=?iso-8859-15?Q?Criczq9NMpuU94wTgfiV2wg8zjK2fLWri+3KpySgEuz+7ht9xmMEAhopW?=
	=?iso-8859-15?Q?h3lZLrt4gEl+RO8vqiGj4VLW20dMPCHro?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e598cf44-9c2d-493c-2ff6-08d8f28f5226
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 08:47:44.4725 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NYetELyP6xfmn5doWvkpMLfonfDl0L1eF++hoMCXn4CTXrMQNJQeKHGqwmtAkA7SJaZ+U9bX3mC7t43B4SyPRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5387
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12T8lsUU009647
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/4] libmultipath: fix priorities in
	parse_vpd_pg83
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <892A55947E3603489010517783AB92C4@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-25 at 19:52 -0500, Benjamin Marzinski wrote:
> The priorities for the EUI-64 (0x02) and NAME (0x08) scsi identifiers
> in
> parse_vpd_pg83() don't match their priorities in 55-scsi-
> sg3_id.rules.
> Switch them so that they match.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

After further discussion:

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

