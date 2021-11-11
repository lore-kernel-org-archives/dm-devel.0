Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 423D1C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:34:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE3C361208
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 11:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE3C361208
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-KrUWNhtaOhW5aJXSOxY3RA-1; Thu, 11 Nov 2021 06:34:53 -0500
X-MC-Unique: KrUWNhtaOhW5aJXSOxY3RA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8602B1023F4D;
	Thu, 11 Nov 2021 11:34:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13FB519C59;
	Thu, 11 Nov 2021 11:34:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D99091819AC1;
	Thu, 11 Nov 2021 11:34:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABBYlZV009661 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 06:34:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 12ADA404727C; Thu, 11 Nov 2021 11:34:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CFF44047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:34:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7460821990
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 11:34:46 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-347-dbfAp2S7PbWJd6_kq85xoA-1;
	Thu, 11 Nov 2021 06:34:45 -0500
X-MC-Unique: dbfAp2S7PbWJd6_kq85xoA-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2106.outbound.protection.outlook.com [104.47.18.106])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-12--QuYE253P_6MzbXyjPFaYg-1; Thu, 11 Nov 2021 12:34:43 +0100
X-MC-Unique: -QuYE253P_6MzbXyjPFaYg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5067.eurprd04.prod.outlook.com (2603:10a6:10:1a::28) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15;
	Thu, 11 Nov 2021 11:34:42 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4669.016;
	Thu, 11 Nov 2021 11:34:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 6/9] libmultipath: improve checks for set_str
Thread-Index: AQHX1phkIhnFbf4kWkeEAyNyNSO++Kv+MwqA
Date: Thu, 11 Nov 2021 11:34:42 +0000
Message-ID: <476665a007143afaf8e89541d5cdb694a982cb3d.camel@suse.com>
References: <1636592780-20391-1-git-send-email-bmarzins@redhat.com>
	<1636592780-20391-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636592780-20391-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 410092d2-b271-4c1f-f4c6-08d9a507411c
x-ms-traffictypediagnostic: DB7PR04MB5067:
x-microsoft-antispam-prvs: <DB7PR04MB50679973E27F24460B9B2755FC949@DB7PR04MB5067.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Qx8yO6NYWs9DU81tVqDRPKtVH9NCLJ+cEq1LFkbxQdQIw9T/KCHlhpKOzSwLJ2vb1kTplVNMNTrcF2PGG8sqN+a6pwcIfmYYrMgDs7GxMX6rKmwOb/ZqNJxIxmvwc/DxZztux5RlaPHUlQTglxfnY9Ud6aeM1pAy/4CbXrXrGdbZNwk1h7Sj1Cg+W8BciRkgJvK6gAWYPnTpjJlYG+rMCZNsGEuZ3EHyLSc5XjTYY48imNuZApBJOfoFmjeiGW10AECBtb1vV58MKd5r62W5lLGKVml9h1XAfo6KfXM66NbcH1zTlvKhXVaO778lKLh8VGMfY7nr7yCVkgk6CQp0mDnszNKgwkI8SBXGuTZnvDzaTzAQs9Ep+o63j5uIv/ABy9nyE8SRrXZ/LxkFx7i4IwCkdDM4KslmGc4tD0j1p/du6VoHUfvz4Q5j0WAzTQUAV7EJAE9FtRAJxul/0spd7owM823JA6krcDL/E7SF1gLzTBeUONCBsWVvSXEKmHMvXnjt31VCiR9/Iq8R4f3k2AY9+IjJHaNDQfCZF/YZixjFcwCQ61s2E+cCyyB46130U0lskvYzKxP7CMaVJ7Jpri9nydOgAFg5PNdDqIihkjH66L9+9snI4R3QCLTepklrZg6F+GAFjHIRcV26O9zf0rA+wW2w7lGMS+r3IQNOh38C7VPTk6kW3BLinOhCFzA5xSfmvB2B3M18G03Eq1T0BQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(2616005)(4326008)(508600001)(6486002)(44832011)(110136005)(64756008)(38070700005)(66476007)(5660300002)(4744005)(76116006)(66556008)(91956017)(86362001)(38100700002)(122000001)(66446008)(8936002)(66946007)(26005)(316002)(36756003)(4001150100001)(6506007)(71200400001)(6512007)(186003)(2906002)(8676002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?S/byJdaPsjWUrQhCUdYisc9XiskVUuW1pHmBuhfcd0HgVHmfWTk5BriCn?=
	=?iso-8859-15?Q?mHsk2dfnjvfVA7HajCy4ZaEK8LKnS5sv8t6FQDZCQn1/Qs2aE4lhXDTg7?=
	=?iso-8859-15?Q?3JboDNIcCjnVezlEb+Uu7HhEiatcICxUctBxnTNKpCJDepFiYqHJgsRTe?=
	=?iso-8859-15?Q?xojh5NbFXOhirEbZ320gFjFnbwz8O5+/YcfBmX6aorIQiHe6O0jLKVaTR?=
	=?iso-8859-15?Q?Wz6OZz2qVdbSTKQ+sQKMnNc/2dEzPzkj6DcQj4ooMRTxkj3D+4CvZZF28?=
	=?iso-8859-15?Q?KFXVcdKN+70O0Q4hOdxJjO2YRFghyJRQ8Yj6ueNHQM4e6Nu412KNHKqq4?=
	=?iso-8859-15?Q?7bBnFO1ByT8CwqH6TypkbbVh8DtKwXE9RNcTa3IR0H2us750KF18D5bGX?=
	=?iso-8859-15?Q?mNzM+w3fadthUEEnYqkzxYulA7fCSbgWkgXDJt+DLZSY6KvSUsu8YWRX0?=
	=?iso-8859-15?Q?mo7nm6kZVfiMkFEoUhEgmC4HZYzxPHQQ2P/xVeAM2RGE6xG7E0L5Aqttg?=
	=?iso-8859-15?Q?1T2b3qkESZr9sobVI6GEJFR847a7GO5zOO66wXURxRQWflULihKuBGwXr?=
	=?iso-8859-15?Q?js7WZf22T87CZHgpePBA6UwAIflp/iAR3arjFxuROPS6kjwWuDPEivrAP?=
	=?iso-8859-15?Q?jzt0Ox25+DtIOnwL0S3/ErETN+sZ+sL5Ky3LQmvXm6YwoYeLfXWYB1iFd?=
	=?iso-8859-15?Q?4jLhdMxE+V0Vdz8TljUsEiRPT6mAj4xtY75xULQD2cRahWLZjEJ0cJn/U?=
	=?iso-8859-15?Q?xn2CyEmQpJf83fgShW/VwFs6vIq5lLTWFhi1P3TFYUHLII8SjwFxzviic?=
	=?iso-8859-15?Q?BNfMvMLBnpH1oe/pkeOmTj8gUwPfdBenPI+zexg5HUd6dtJ4QUfkthM2M?=
	=?iso-8859-15?Q?Bba+Zrhc3RrF2n2FEr5PTTaIgfmsd7SZaNKoaKKAZTBsGFEOm01g5D2sV?=
	=?iso-8859-15?Q?/eNJ1GPNncPMu0l1p3jO3YIawylyLC0pslbE/TNt7kfQ4MVhHOorl6Hk3?=
	=?iso-8859-15?Q?qxlqVNmK88gSxuwrCGu7ZdxPaMCvlcedQh7FBL5rpP4AY82Me9rdu3SZm?=
	=?iso-8859-15?Q?H52TndAjfNXN70svY4q4w7YqQ2fpImn9jHOZhdj5IDxemM0B8C7ykBg5k?=
	=?iso-8859-15?Q?OGidrvPc7H4Vp0tg4UT/gr9NHYl+u4VHwprZ4KYLtRsjUUOIbGcoWH0MR?=
	=?iso-8859-15?Q?B7rxtP1OPOxQvVch3SESkaybDh8bVrWuFGfVYjnnq52XcOUPet5SbJnC3?=
	=?iso-8859-15?Q?vCI0D9suuySkxrwfT1ru/9CJI3309/fO9kgHk5JKtMR/I5nqSNhdofcNZ?=
	=?iso-8859-15?Q?cM7Wysq3k+OMt70yBp+YZSHcVhjSeAtbHtsjGzE/uwN5d0usesT2utOTm?=
	=?iso-8859-15?Q?swRCwAnA9nAU0WP6JEYDJFiL/P7m1dtOVJu7kgMjhiCpTUDYtdBs2oxAY?=
	=?iso-8859-15?Q?Tqu9kLlUbK6gAAzXWPypy+bX0F+VzzsaQLi/3AQWxJwfza/z1n9I/PYq+?=
	=?iso-8859-15?Q?a3Rd9sriVoLPXgLYzdS7JVkaRc7/T5n8x5Xf6Uut8nfh/8OUZ4Bn4aIca?=
	=?iso-8859-15?Q?AbcuOOY1kN4kqAZy8H8ElsvuI+GfbBOUEVOWMRbetJSQqLCU+DeUZLzoi?=
	=?iso-8859-15?Q?051ghPnkxzEguTUhT5CQSB2gLY1dStLPNMuHVwghTgeCsF410+6DmiTFu?=
	=?iso-8859-15?Q?hPEZMHokUzIdq3yCjpsYnBDOYObQnHqbT2uC/KgaGHCg9pI=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410092d2-b271-4c1f-f4c6-08d9a507411c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 11:34:42.4247 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cNkPMlb8BEFJ/v9yx9QdrmOuiRJJXntZHF7B3gy7hEXN3ZvF6AcRIaIt3sVWslpSbqJ1fkkT/j0r3MrrxdRxDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5067
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ABBYlZV009661
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 6/9] libmultipath: improve checks for
	set_str
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
Content-ID: <70559698221BCA4495F64179CFC422AC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-11-10 at 19:06 -0600, Benjamin Marzinski wrote:
> multipath always requires absolute pathnames, so make sure all file
> and
> directory names start with a slash.=A0 Also check that the directories
> exist.=A0 Finally, some strings, like the alias, will be used in paths.
> These must not contain the slash character '/', since it is a
> forbidden
> character in file/directory names. This patch adds seperate handlers
> for
> these three cases. If a config line is invalid, these handlers retain
> the existing config string, if any.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

