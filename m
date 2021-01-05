Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDF5C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 10:58:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 123A02251F
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 10:58:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 123A02251F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-w7KMJaB0Ooi4EqBsv8O2iA-1; Tue, 05 Jan 2021 05:58:12 -0500
X-MC-Unique: w7KMJaB0Ooi4EqBsv8O2iA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5A56107ACE8;
	Tue,  5 Jan 2021 10:58:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B46F110016F7;
	Tue,  5 Jan 2021 10:58:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54E89180954D;
	Tue,  5 Jan 2021 10:58:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 105Aw45Y021403 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 5 Jan 2021 05:58:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 59BAB5D211; Tue,  5 Jan 2021 10:58:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 536295D218
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 10:58:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25953101A560
	for <dm-devel@redhat.com>; Tue,  5 Jan 2021 10:58:02 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-181-rkyDPSxiPHqiLzUWd2pSxQ-1;
	Tue, 05 Jan 2021 05:58:00 -0500
X-MC-Unique: rkyDPSxiPHqiLzUWd2pSxQ-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2112.outbound.protection.outlook.com [104.47.18.112])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-21-S2ne9NSZNG-GaabXTWyC_g-1; Tue, 05 Jan 2021 11:57:57 +0100
X-MC-Unique: S2ne9NSZNG-GaabXTWyC_g-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7463.eurprd04.prod.outlook.com (2603:10a6:10:1ad::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.22;
	Tue, 5 Jan 2021 10:57:57 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3721.024;
	Tue, 5 Jan 2021 10:57:57 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/2] multipath cleanup patches
Thread-Index: AQHW4xdEIx1GX0xd2UmPek13D87jiKoY3RAA
Date: Tue, 5 Jan 2021 10:57:57 +0000
Message-ID: <a4023fca93f83c6481b81a3d1e9253b0f12b96a1.camel@suse.com>
References: <1609819195-18306-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1609819195-18306-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cccdc56c-e24b-48bb-1ee6-08d8b168c296
x-ms-traffictypediagnostic: DBAPR04MB7463:
x-microsoft-antispam-prvs: <DBAPR04MB74636FD4913D103FA2197CCBFCD10@DBAPR04MB7463.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: oJHx3BNxshhjWW4oInsdVf2THhsf+HJJQwIeSvs0Tj84hP70AnytGegMUJfzxBQsBJr9kwZPIHEOAy8kGNEt/zJ1kH6DC2t0FGFie/0xcZPUOOFz+zvHMVkGjYQmNPOAx6UWzBIVhCp+ldvybOF7K0klDxQqrGwnE5ITBL2JuwSCFycoIVtkoWgH0iVD5Kgk9yBsdb70UwQ04iskJTSIKgXoh6yZCGbOV/snj4r3yoZWEvvrZIDxqw6fYReHrTdeiqIl1w+u7iPn9hfE03ZaH9fqywx5khXftUxXDAMfYv2FSX5ErXAAM1hJrYgxLPOuwhTCLhTviVqkP8zYMJdZSiW1ceF0p74JVValRw1Lvs21a7OKabAv+vNujxl8X9tLGb+WmB0c5BTuDvYnciSlIg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(39860400002)(366004)(376002)(346002)(6512007)(66556008)(316002)(2616005)(8936002)(83380400001)(76116006)(36756003)(66946007)(64756008)(91956017)(66476007)(66446008)(478600001)(86362001)(4326008)(4744005)(6506007)(26005)(44832011)(5660300002)(186003)(110136005)(6486002)(71200400001)(2906002)(8676002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?ti0/Ug+MNxM78d6vWFyrhzRieeAqxmPkX6+eBZ1YrK53kBVue3V+i3Hfl?=
	=?iso-8859-15?Q?okm9BHffEVxmcGuIcY6Md6QdQabG6Vbcv2skZMdtk/6Xa1H7V33l4VDu/?=
	=?iso-8859-15?Q?yMHXjHYEqC0iLWHaRHRFQfSA4Q5632pEdk0Kbs0y3EzMz0c6Y5py7bbuI?=
	=?iso-8859-15?Q?bZ/RP0Yoq525Om11kaXi6xCSABSIvL1xjiWAX2tDT+eoqXinRuSY/JKWr?=
	=?iso-8859-15?Q?NB5ZgvVTi1ZkBJDRmlY4Tn93NYpg++KJfzDwvYJ74txVp8UkmkKI2hrWz?=
	=?iso-8859-15?Q?LpbbO9DXQXxmcgWvOtLjrN/alhzlKKgvfdT1rfJ1lVyu8i8XedS44tuG1?=
	=?iso-8859-15?Q?Lc9FKCDNcyNVnqRnvrAM6/sBHf17FscQTzfwPN+pVQgAwzhDreXWR+oiG?=
	=?iso-8859-15?Q?5d2efuqRZnZhQ+9mE56xYG31kks/nwUtOQbQy1EYgBoWO5Y9djKneg/4t?=
	=?iso-8859-15?Q?odHfbJxnrGGFcqTA+fBojjqGH13wEoeOUjXOevIQoyQNiH3idpj/VfsI9?=
	=?iso-8859-15?Q?NZKpWDPN2f9CyIBy3CoQGwZq0H2HSzeEt10AwvgUzXUGDDO8L5l2ESMqN?=
	=?iso-8859-15?Q?G5y9zTqRZpnq6uVN+rb2esnzj0nYsZIEnCghPxUJoZvyHcmHvRQY0/DEF?=
	=?iso-8859-15?Q?XKFfTJEMNyY5VG5ODAexUBRQx8zFdjOsHlMfSDWrtNscA/FFtEzniV2A6?=
	=?iso-8859-15?Q?T2Iu6Dwq9sMqz0oOObhmX2HlNRAkhMGilr6GWsgu3lVoK3nrN6dROLhpx?=
	=?iso-8859-15?Q?RqhgjNaHms8yhzmCnKVSe8worSbwJXdp3h1lsj0OvPgr+8B8kkAI7Yfcg?=
	=?iso-8859-15?Q?p7CEsTZWCmWHAMY1M7rlZEus1BiZgDN/qjbUI5EE5Hz/bMNqr5Pxpnw+Z?=
	=?iso-8859-15?Q?nvR3vbriexyAezwUpKkgBLqrjmc8VxHpz8lKS8y6xiv9bn2YkMPKES1F0?=
	=?iso-8859-15?Q?a6mBeEGUbOZD8DFqrzCpFRff6idm/0zbgxrpcvouMJkz+hin9iP64CjF2?=
	=?iso-8859-15?Q?bto1+M/tn7Ly4HUyMZ8dPFl3kyGLP1oF4OnKHz3sqbBtt/1BPzHbs31?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cccdc56c-e24b-48bb-1ee6-08d8b168c296
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2021 10:57:57.1149 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sd95pTUfAD7bFWkDGUAffYKF4dxWHHtVKpDcv9jrnhuJgQuJWzdEu+gJM9v3YUP14ZsVfpqIZxOQtatPu8WtGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7463
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 105Aw45Y021403
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/2] multipath cleanup patches
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2FE70DF791BA6142B3A87F3F0079AA9D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-01-04 at 21:59 -0600, Benjamin Marzinski wrote:
> These patches are cleanups that Martin mentioned for my last
> patchset.
> The first is some code that should have been in patch 4/6
> (libmultipath:
> ignore multipaths sections without wwid option). The second is V2 of
> patch 6/6 (multipath.conf.5: Improve checker_timeout description),
> which
> was updated based on Martin's comments.
>=20
> Benjamin Marzinski (2):
> =A0 libmultipath: check for null wwid before strcmp
> =A0 multipath.conf.5: Improve checker_timeout description
>=20
> =A0libmultipath/config.c=A0=A0=A0=A0=A0 |=A0 2 +-
> =A0multipath/multipath.conf.5 | 20 ++++++++++++--------
> =A02 files changed, 13 insertions(+), 9 deletions(-)
>=20

For the set:

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

