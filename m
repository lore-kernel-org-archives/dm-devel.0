Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB68BC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 21 Dec 2022 20:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671655355;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6tOM9/cE+t/5z7Zr8ab+ReRYACs2aniJwCnTMBgcUhw=;
	b=K9G3HGJbq+eVxXg64DWMpU7NSyc7BitEftIetqyK9aSwi5DFkRf4Kl41/30yW3KconRLp5
	ZJMKYe+EDKyYKxBuOxd7gsQEZyQmlJWa87kdiVAD1pAVwTipzJ84yR0JOGNUdNOo7iIr6p
	vp/QbVNaLwZsHZjXVLeeAzwxwy/YIZk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-N8n72O6zMXydEdqmDHd88g-1; Wed, 21 Dec 2022 15:42:34 -0500
X-MC-Unique: N8n72O6zMXydEdqmDHd88g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 901EC101A521;
	Wed, 21 Dec 2022 20:42:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 05DA4492C14;
	Wed, 21 Dec 2022 20:42:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D801E19465A8;
	Wed, 21 Dec 2022 20:42:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 763E219465A4
 for <dm-devel@listman.corp.redhat.com>; Wed, 21 Dec 2022 20:42:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 54ACA2166B29; Wed, 21 Dec 2022 20:42:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D2592166B26
 for <dm-devel@redhat.com>; Wed, 21 Dec 2022 20:42:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F3DC18E0922
 for <dm-devel@redhat.com>; Wed, 21 Dec 2022 20:42:28 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2070.outbound.protection.outlook.com [40.107.20.70]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-a1vdIdgxNEaQmi3-Oeohbw-2; Wed, 21 Dec 2022 15:42:22 -0500
X-MC-Unique: a1vdIdgxNEaQmi3-Oeohbw-2
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PA4PR04MB9366.eurprd04.prod.outlook.com (2603:10a6:102:2a9::8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 20:42:20 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%4]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 20:42:19 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/6] multipath: persistent reservation fixes
Thread-Index: AQHZFMySWp+z77un0k+CFbHn+QBb8K54z9UA
Date: Wed, 21 Dec 2022 20:42:19 +0000
Message-ID: <ec26c934008a46a60b21548c2cda315ada8f7f5e.camel@suse.com>
References: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PA4PR04MB9366:EE_
x-ms-office365-filtering-correlation-id: 6bbe8906-1ddd-45a2-131e-08dae393daed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FSsmRbRrT4OaYjbnxnzu00yoyz1ZVarKAFGebSaSCfRoiw4I9mB1HFRrFqt4/3U6wMyzwxi9+Ky+xMfCsqAdPEAtI8JghQmDuHaTn1qAPB3jwfoC30xyaVI7N06fnHmFzFP3bwuBbX+cDNT42oKTGeOBfSwe9wNTVVsYnv0erRQ9iUzmS/lYKNfW79KMtELtM4/rlpo0c7Z5QNRK/SgDIYI+h8C8C9I7QXQNS93nEmr3/jhJRl19nuwTsKgWyi5pLcz4ZeTajOgRuIfQ3I86Pflo8VP8Dt4xusAk7BlRTUyL/5HbQBreylIvlFQjmKibBpybKVSIV0zUZboDe1wt8Q13eplfhT80xK/bKhj3TO/X/EkJKaONzahHxDtm2wvjAwMvMa58IKaCBgI6v+ujnmsVFR8IbwhzUIC2IpYRCZQCsXKuCXBAby/I9cPc84AknMjyws9jHHVNtX8LlEq+BQuItzQtG7vJLRl8a66yl6t75I3CHgm5TkCkG5+TG82lRY2+7Z2nYJxaZenUPx7pbVuHPMxLqnCZnB2U4CKu5+Qgn4gi+ND481Td3SMCY7jOS3kuS/Olq5UUF3ix1oi5hlBQ433C5vZu8cTVZGQvOu06Q4v1+9MXN7/6IgcNhuHS4FIc4A+tUzKZkkeeov8HPV2koQyJUeCpaDG7gKbwhWS5tEhpTWxBQdpTS0ZC01huRVSHV+zDxBkimc6EwPaY3A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(136003)(396003)(376002)(346002)(39860400002)(366004)(451199015)(186003)(478600001)(71200400001)(6486002)(26005)(6506007)(38100700002)(122000001)(6512007)(8936002)(66446008)(38070700005)(41300700001)(44832011)(110136005)(66476007)(64756008)(2616005)(4001150100001)(316002)(66946007)(4326008)(66556008)(91956017)(8676002)(86362001)(76116006)(2906002)(83380400001)(36756003)(5660300002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?9TZWIXzm/FzCNwcvjtrvBWIgmPHTYRmaLNi/qscpIODHXLlfxb7wJXNvC?=
 =?iso-8859-15?Q?Ew4kelXIlsseO6BMIHFyBl5i6s7UDvVARQgJ0fPFpTPgSP3brYpGmv2NO?=
 =?iso-8859-15?Q?JdnfM8H/PsdNWXJeU7iahfH7TOTwSz2x97XRBr144y1DP3mz/rxuPWvrh?=
 =?iso-8859-15?Q?9ae/QL8+boil8CjT/oZ4G1TUQ6uvNiqUVbG8m533fe1/juZPxr9QPsbT4?=
 =?iso-8859-15?Q?pIRvmCoGfl8Ppk2Wq2ZGwI6SbhP2FEiApun4svnVgdHPob5jsMgkNX0EP?=
 =?iso-8859-15?Q?lw06FVhOiuo3vbSvHDN+At5FdXF8t27zgfkWypN8emM8dHsWwtEB3gKVw?=
 =?iso-8859-15?Q?NmyG+t/7c4WKC/R8PwerQihjIVM3oqSd5hb0u+LDzQhUonjYJ/JnM/0iX?=
 =?iso-8859-15?Q?HPJwpddCA5hivYbT0tRr9yjvZSz7PEuVk1SKYtQyb6cLPOr6mef11SuYg?=
 =?iso-8859-15?Q?RUSYJD8QGpW5TcxEohG/qI/9ppLgQqix9fM6uT2IUMsIC6WTAMreUENdr?=
 =?iso-8859-15?Q?fTGjsdLayy8FjaVwWpuWeo2X47qN68NnN4L1/FVbZrgEu61Jn7RHr8NmP?=
 =?iso-8859-15?Q?pMP6FIX9THiA+9AanCvmzF3ZSWj1KBvCckjvLmEMdAKdZ7uKaLdOjRzGd?=
 =?iso-8859-15?Q?j/yXOxdhyh/Kivipkya4turSDUmy6WSP2I15nyiueyrcaf2eT2NB7cRjT?=
 =?iso-8859-15?Q?lySLAu3MY9f4qOeQwsCX8r2zeZ34mv1VXKO6GGHup7vg+V/5njamiK/k9?=
 =?iso-8859-15?Q?QssGhCk+Z1cnq4vG3eQ3OOGAb9KFC4XE1D2HEhdAXU7qtnk2ijQT144fb?=
 =?iso-8859-15?Q?MjAeTJDTzRIQtO+8IL+M3NyEnIMrCK9hH3VQklT80Od8ozkJw9WI71/BX?=
 =?iso-8859-15?Q?F8tUykaQ7gNGtvYG+Tyvu5YvKIGsxNRD2wYEkYe9JczqVz6JoRLwEToMT?=
 =?iso-8859-15?Q?M6T5w0Paizj6XvHKcnY6t6XqH1YhxcnZD2mVRVkThUmn7zYQ16l6t87pB?=
 =?iso-8859-15?Q?deiwzw9XIJWAU/0bCE0o1zwMDtBhURC5XWTtbxitwT4+1Ss2fxq102tZa?=
 =?iso-8859-15?Q?raz9UH+y54UUMpOfiSm0q93Z04H2HfsNj+y0PHkOe/l0btQPSKyTGkYP8?=
 =?iso-8859-15?Q?MoyWu+BF+hLiX3EIjjXCaa/qOkHqwb4O2TrNCwyWmu+mxNXPuqkws6LUE?=
 =?iso-8859-15?Q?ahjjKmwAEQRtejt4xSsUpEjl5VYmchlDIqDXlNmPVL4yrwVLt9xSjBFNH?=
 =?iso-8859-15?Q?0cj+5Zaupiy8WQujrGuyNEgo+vcy79nF8Dj59t7CoWZ/Hy5VSBWgELPm8?=
 =?iso-8859-15?Q?DwMryeJRPBjVkn8HUipxhKILY6JxSbsD+cY8AiZNnDs8b+nTufnj/ooTD?=
 =?iso-8859-15?Q?nT8rGRK1kkM5NFKPxpKN0MHd3drn8Fd8IIFQOfvLwAfYDZwxszSKpdIrc?=
 =?iso-8859-15?Q?F/MClIl77pcbduNjFLEAFFBTu0CEiO0jWUqkoKe/GmGWLGWpvkfcU3uxs?=
 =?iso-8859-15?Q?jL+56mk/gvM2WiI4CBagOHSAXn5Pw85r4BWL3ns9GuuIpkz0/MPB/Layz?=
 =?iso-8859-15?Q?vxnFSbPeM7ha+VrMdImkdNK9Sf7jt+4jIaMiJl8NuJ0dDT7H7iqaUjyuY?=
 =?iso-8859-15?Q?XBFfig2cL5WHi2Xex+hm1ZRbrvEsrYZLO3DxfblO4I0Fgr6bIDzPzkhXI?=
 =?iso-8859-15?Q?o2qCNheVqFqtkuNvPpf23H0/RA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbe8906-1ddd-45a2-131e-08dae393daed
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 20:42:19.8688 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LO4Qy2hs9iBVla+zxC51Q5u1xh+uax7qVev/fz6hqqyyfV3dvrDS6eT8unc8kIp2GWXFhBmxCN+hryuIcYbTxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9366
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH 0/6] multipath: persistent reservation fixes
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1D1DDD2D5808BF448E01ABF414B404C1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-12-20 at 17:41 -0600, Benjamin Marzinski wrote:
> The first three patches fix issues with multipathd's persistent
> reservation handling. As long as mpathpersist is run on a multipath
> device while multipathd is montioring it, everything works fine. But
> if
> new paths to that device appear or first become active while
> multipathd
> isn't running or the multipath device doesn't exist, multipathd might
> not register keys to those paths when it starts up or adds the
> multipath
> device.
>=20
> These patches also fix an issue where, if there are no active paths
> for
> multipathd to use for checking registered keys on device creation, it
> will treat the device as if there are no registered keys.
>=20
> The other three patches fix issues I found while looking into the
> persistent reservation problems.
>=20
> Benjamin Marzinski (6):
> =A0 multipathd: make pr registration consistent
> =A0 libmultipath: make prflag an enum
> =A0 multipathd: handle no active paths in update_map_pr
> =A0 multipathd: add missing newline to cli_del_map reply
> =A0 libmultipath: skip extra vector work in remove_maps
> =A0 libmultipath: orphan paths if coalesce_paths frees newmp
>=20
> =A0libmpathpersist/mpath_persist_int.c | 10 ++++-
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 7 +++-
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 +=
+++-
> =A0libmultipath/structs_vec.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 6 +--
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 20 +++++----=
-
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 | 60 ++++++++++++++++++++-------
> --
> =A06 files changed, 77 insertions(+), 35 deletions(-)
>=20

For the series:
Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

