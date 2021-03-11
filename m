Return-Path: <SRS0=c+In=IJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AB8C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:33:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BBA1264F84
	for <dm-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:33:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBA1264F84
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-DZoP89VeNFGaHa9lnYLCVg-1; Thu, 11 Mar 2021 16:32:57 -0500
X-MC-Unique: DZoP89VeNFGaHa9lnYLCVg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC9BD19253C2;
	Thu, 11 Mar 2021 21:32:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 967B660853;
	Thu, 11 Mar 2021 21:32:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED5E157DC1;
	Thu, 11 Mar 2021 21:32:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12BLWoFD013786 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 16:32:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 913CE2166BA2; Thu, 11 Mar 2021 21:32:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 899D62166BA4
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 21:32:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C2CE85A5B5
	for <dm-devel@redhat.com>; Thu, 11 Mar 2021 21:32:48 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-499-3nYX4oaQNZy4SWWdEVvE0Q-1;
	Thu, 11 Mar 2021 16:32:46 -0500
X-MC-Unique: 3nYX4oaQNZy4SWWdEVvE0Q-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2056.outbound.protection.outlook.com [104.47.13.56])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-18-gjMS-SEQNQ-5nq3lBBp0Fg-1; Thu, 11 Mar 2021 22:32:43 +0100
X-MC-Unique: gjMS-SEQNQ-5nq3lBBp0Fg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7351.eurprd04.prod.outlook.com (2603:10a6:10:1b2::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.27;
	Thu, 11 Mar 2021 21:32:42 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3912.029;
	Thu, 11 Mar 2021 21:32:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/2] libmultipath: check if user_friendly_name is in use
Thread-Index: AQHXFfKCPjSdEBGI/kGvdK/G88EHXKp/UDyA
Date: Thu, 11 Mar 2021 21:32:41 +0000
Message-ID: <fe391d761c53d0e333301ade356e49af04d84e3e.camel@suse.com>
References: <1615410915-12555-1-git-send-email-bmarzins@redhat.com>
	<1615410915-12555-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1615410915-12555-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 506aa1be-27ce-4939-3c2e-08d8e4d533c7
x-ms-traffictypediagnostic: DBAPR04MB7351:
x-microsoft-antispam-prvs: <DBAPR04MB7351D856DBF4094D00967409FC909@DBAPR04MB7351.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WR6gOx6ZNDD4lBHD980XCoJz+4sNxh9CuKTbDl+awbcOvj8rTIdFIo49XFK7+UGvUpg8Qm/1ksDwxCLMr9OcJDYGSNqP44wbzWmWcQBF+XYjCTg5awmvC6yyk0lJuUdf7Q8R5iYD9dWQ3eFuQQHoy7FfsDviWe5gGfg4Jm0xlCeLRVJ3A1ryj9A9I1Y095G+ktn12Ts2lTu8pNvECXY7v7V/Qsu1raqOKycpZC1JDNE4OvlURwzMLntkOWnz2ZvBTXhHNGk+ZYVQcWgCywfjl9aKGP2+qWOLhIIYJYcwot94LF1/DbcFukz8tUE7o2Vu417ze4EVSrgQQ92F16kXImdIs2ZbBq7WxhFtbIjKSyJExV5VqKwE/Y8T3lpo5Ml0ukVtPDhCLwaWEYoG9eZSE0DM3DUi05RzGNA26RuSv14zCpJFtTzOXDp6IQwUzsj59oSxNgaTctt2xwnePxIRknkFUz+ZEi1AIzPOant1Z6gq/b1/SePoRrneLRp9kF5ppHCvy/cXGwXNy3KwSyM/jg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(366004)(376002)(39850400004)(396003)(136003)(66476007)(8936002)(66556008)(91956017)(76116006)(66946007)(6512007)(86362001)(71200400001)(110136005)(6486002)(6506007)(316002)(36756003)(8676002)(83380400001)(2616005)(44832011)(26005)(5660300002)(186003)(2906002)(64756008)(478600001)(66446008)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?jMgKaHg9AqwsHvsYTPiVa5L8R98SvyZ5t14KcyOCX1CEaXhF5shdMZvxW?=
	=?iso-8859-15?Q?4B4OAcjbHNXjbHMxUDfyZ3Y/1DTEl3pECIRZfvRItw/ANChj7GJnVYTpP?=
	=?iso-8859-15?Q?v4SP3kuQvfgnWnH+9HlmYQ2/AhQEjp7bde7IyVShvvZoJn7fbeOi26uLh?=
	=?iso-8859-15?Q?YpmgIDYDi3z/tc0m+5wLi0G26hjt4t1xITUaJCFQaAAjaukFzCnU/Mtw3?=
	=?iso-8859-15?Q?0XYvpEd+rajW4gQpNWGJO+ra6rpDhdW29RMgy2aDYGXjNjFvhTOKA5CFJ?=
	=?iso-8859-15?Q?iDt4jF8f86FwRWkSyaiLmsO57exOZ547njWQFnwPTnhxV0HOHHADrXJY6?=
	=?iso-8859-15?Q?yUCecJsg/2JSJF8ObEGDOykVXcx6tQptnhtSA/AIix7E1bvPwTCBX+DWu?=
	=?iso-8859-15?Q?/2VpDKHZAC08ZIP4EAb/8TCmIeQOqen6+ji8bQ6Dgn2YUAf/1oPj0OG1A?=
	=?iso-8859-15?Q?R4MFVXqAWYf+g7m22IWcF5u3FfbVbaBcPXwHkoFsTIkkJWlVkG5k7cYwR?=
	=?iso-8859-15?Q?sugi/wdlFpObcpgoEUdVdtNJx37hLC8df4lZcRKGoloi45YHnqyU4TTki?=
	=?iso-8859-15?Q?RUlpBynNt0PifNsVUGHTOpXt5bhlDy01EeNjeoX1wwNELbig6RkDz7DE8?=
	=?iso-8859-15?Q?7JDFegHxNGBVEGVNK9rtZYVyXXawcN84R5jaj2CgU5ewqCNWkn0dEzV9z?=
	=?iso-8859-15?Q?p92UHszCLQbXEldONKELINNj8C4C2FbzCH0AzkBvist/8eya1tzx6IB65?=
	=?iso-8859-15?Q?E/8IHp3LEM28TKvPC1r8eECEFz+nTQxEQ4vmQmWWqjOl2RanA5WWIBZQQ?=
	=?iso-8859-15?Q?fOZBHlKCZ8hJKy/kTvvf6B6YzLPHsfwdXseJswqIi9GUbflo7+xjZXGyb?=
	=?iso-8859-15?Q?EbwAtwr/WEVgZM4t6/quQ21uxs/gUexWvl2ihNF4cUO/emtJZ7LL92IsF?=
	=?iso-8859-15?Q?e65J6HZrXOks93KlaMkvR6zudASc9XD7Pu1FOodiu6jFoj2AZlcSJehvU?=
	=?iso-8859-15?Q?1/NqZoeYnAOQRnD+IbcC5JQPnkeH9lvBbBWBF97dIDEpxVuuq113VMh3k?=
	=?iso-8859-15?Q?68vaSoKdXrGZqlFzCkzb/9c6/lL13IPKErZh27PlLNhA58kzv6fugjtp2?=
	=?iso-8859-15?Q?ZstPtihTqgsJLtoaZA+m+VP652jN5NXPv+DVTIQzTc4EMX8migEOEErfh?=
	=?iso-8859-15?Q?nKIZtAzYM+1F/I9RoqwsrgTe/GOu2gj14h8oaBxxzsDVpzUDuL7WtslVc?=
	=?iso-8859-15?Q?vr7pxdxAM2laonDg58rrcjXy678id1wX+4FnC5+PzUdTOtBVcfEBz3rJN?=
	=?iso-8859-15?Q?gTMa9/YsJohQZB2kytyjN7WNX52uTV1gijRKuh8/ZmL7u1N2Sdr6qXd16?=
	=?iso-8859-15?Q?eVFShDcWCZ0p4+5OPmzCWGLwUDhbRoEoF?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 506aa1be-27ce-4939-3c2e-08d8e4d533c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 21:32:41.9607 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lOlEjUQO+QdLfu8ab6Ya1GTbhK8HE1q8FWGJHzHRRop0yNmIan3HmvKL5pZ/1lMAkuM594GqQhQmD4cA2WYnBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7351
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12BLWoFD013786
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] libmultipath: check if
	user_friendly_name is in use
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
Content-ID: <60BE2C4440372047AA8CAAE08BC40F72@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-03-10 at 15:15 -0600, Benjamin Marzinski wrote:
> If there are multipath devices that have user_friendly_names but do
> not
> have their bindings in the bindings_file, get_user_friendly_alias()
> can
> currently give out those names again. This can result in an incorrect
> entry in the bindings file, and a device that gets created with a
> WWID
> alias instead of a user_friendly_name. This situation can happen
> after
> the pivot root, if a multipath device is created in the initramfs.=A0
> If
> this device doesn't have a binding in the regular filesystem
> bindings_file and a new multipath device is created before it can add
> its binding, the new device can steal that user_friendly_name during
> multipathd's initial configure.
>=20
> To solve this, get_user_friendly_alias() now calls lookup_binding()
> with
> a new paramter, telling it to check if the id it found is already in
> use
> by a diffent device. If so, lookup_binding() will continue to check
> open
> ids, until it finds one that it not currently in use by a dm device.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
>=20


> =A0/*
> =A0 * Returns: 0=A0=A0 if matching entry in WWIDs file found
> =A0 *=A0=A0=A0=A0=A0=A0=A0=A0 -1=A0=A0 if an error occurs
> @@ -128,7 +151,7 @@ scan_devname(const char *alias, const char
> *prefix)
> =A0 */
> =A0static int
> =A0lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *prefix)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const char *prefix, int check_if=
_taken)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0char buf[LINE_MAX];
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int line_nr =3D 0;
> @@ -183,12 +206,31 @@ lookup_binding(FILE *f, const char *map_wwid,
> char **map_alias,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 0;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (!prefix && check_if_taken)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D -1;
> =A0=A0=A0=A0=A0=A0=A0=A0if (id >=3D smallest_bigger_id) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (biggest_id < INT_MAX)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
d =3D biggest_id + 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
d =3D -1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (id > 0 && check_if_taken) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while(id_already_taken(id, =
prefix, map_wwid)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(id =3D=3D INT_MAX) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0id =3D -1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id+=
+;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(id =3D=3D smallest_bigger_id) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (biggest_id =3D=3D INT_MAX) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D -1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (biggest_id >=3D smallest_bigger_id)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0id =3D biggest_id + 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}

This seems to be correct, but I am never certain when I look at this
code. I truly dislike the awkward logic of lookup_binding(), and adding
more complexity to it doesn't improve matters. I really only trust that
logic because of the unit test.

Rather than re-reading the file on every lookup, we should cache its
contents in a sorted array. That would make it much easier to=20
write an algorithm for locating free slots that could be reviewed by
average human beings. We could even add the aliases of detected
existing maps to that array, so that no additional "already taken"
check would be necessary.

I'd actually started working on that some time ago, but never finished
that work.

Anyway, it't not a cause against your patch.

Martin

Reviewed-by: Martin Wilck <mwilck@suse.com>>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

