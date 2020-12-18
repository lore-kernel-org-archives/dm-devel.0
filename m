Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD6FC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:32:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3423523BA7
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3423523BA7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-KXu__hdiPASSrnx6d6chNA-1; Fri, 18 Dec 2020 18:32:44 -0500
X-MC-Unique: KXu__hdiPASSrnx6d6chNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 971F98049C3;
	Fri, 18 Dec 2020 23:32:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75B3260C47;
	Fri, 18 Dec 2020 23:32:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2001C4A7C6;
	Fri, 18 Dec 2020 23:32:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BINVcl4030974 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:31:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 96C2C10DCF5D; Fri, 18 Dec 2020 23:31:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 91E8F10DCF52
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:31:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE0B4101A561
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:31:33 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-265-2cBzHNSoOHO-qd4rS7qPlg-1;
	Fri, 18 Dec 2020 18:31:29 -0500
X-MC-Unique: 2cBzHNSoOHO-qd4rS7qPlg-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-8-yWIe1jDjP_qp--VMVMTmpA-1; Sat, 19 Dec 2020 00:31:27 +0100
X-MC-Unique: yWIe1jDjP_qp--VMVMTmpA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5387.eurprd04.prod.outlook.com (2603:10a6:10:8b::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14;
	Fri, 18 Dec 2020 23:31:25 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Fri, 18 Dec 2020 23:31:25 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/6] multipathd: Fix multipathd stopping on shutdown
Thread-Index: AQHW1ZJ+SJOHFWrTD0++S0No5oFU9qn9gKcA
Date: Fri, 18 Dec 2020 23:31:25 +0000
Message-ID: <2bda2d5b184bf72cbd63ccdcd7d63404c5414ce5.camel@suse.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608332802-9720-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8052ec3-e920-4685-5a24-08d8a3ad0998
x-ms-traffictypediagnostic: DB7PR04MB5387:
x-microsoft-antispam-prvs: <DB7PR04MB5387AE11CA7A167D5AB1622DFCC30@DB7PR04MB5387.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ALAY+y34f7JhxZ8mzpjGPhz9wx8Ok7uHVhXcFWVitD+y1RQSKlT+Clsl9ml20FixCcfj6r4t+Rg94evnw2DiCKXRoU85abs4jCMh1Xewu+Q+0zUZhkJ0rPtIEXJ13ibV2x0wIcjVFxDUjTUWRFssFASd2L4n00lwEjF/9rbP0sHjydZ18hOwN5G9kbV2hyangEKCgD6TPBTBKgVhWmq6XWtnLukSxuQsE5XEmHQaB3FIiwY31n8yq1BQt8uXe7jr7cmK0t7v0KCjUusjrbX0/88ZcovLP53df0B7vx1SAwklrnSPQWq7uUOO94rRVdQqGO53iePeOwkxE6JZK0G7vQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(346002)(39860400002)(366004)(396003)(136003)(8676002)(6512007)(478600001)(6486002)(66946007)(66446008)(66476007)(64756008)(4001150100001)(66556008)(91956017)(76116006)(5660300002)(44832011)(2616005)(6506007)(4744005)(36756003)(4326008)(71200400001)(110136005)(316002)(2906002)(83380400001)(26005)(8936002)(186003)(86362001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?xcEtnX64zJO80hhFZl8usU9iyAcjX1q5UoQ0y5WDkX6CpS/FQP2K8PFqv?=
	=?iso-8859-15?Q?H4CHUcORpPFb9N6q9Fr7NP7v8yvL5S5yo46HvDzJvkOq2Bu53bDB/SUgT?=
	=?iso-8859-15?Q?vFFITGzb68sq/loBrqnOtnBSqNSky/yK8hyNtCfCNOcd0TOeoRfeKSWcY?=
	=?iso-8859-15?Q?mPAb7Mb3Kqu1RKNUwylpD+edBCvImmV/mNLZDNvMpcsJBNd2qzxDmpyah?=
	=?iso-8859-15?Q?Ngikn5m/Ry8+TJ1i1DVN+BJ9t2lnodyq6rbs9hlVOcjL61CXU6mcZdEWE?=
	=?iso-8859-15?Q?jqvOJK6/Vuc8VZppynekqAPdiqW+QeZnQOBtXAS8YBekpdS03x3N/owfD?=
	=?iso-8859-15?Q?1YDRUGxSE95hBTmjkZuBDQt+ZNYEEjg5bAZDaAKUTtkNSxGrz/Tu19o44?=
	=?iso-8859-15?Q?J6hhH8TZlVL8K1AH7hAYoSEldt2ekqoHx/LJ25+bCCYfP1nc5pXlEyvEz?=
	=?iso-8859-15?Q?C7OASnket9Eh+Sm5478q+n0SLH5tGTr68rGe54qEHuj06oCP4+1UOHZRW?=
	=?iso-8859-15?Q?xgkD3siIU28JbaVdRJ8r4A57muOHvcw1M+ItPVw4iP0O1jJKGVzIsArkS?=
	=?iso-8859-15?Q?czN8WSDx5Lwva/HdM+rO79U01STObdEvVZsRHx47uCAs5U1ixJctuRtbX?=
	=?iso-8859-15?Q?6V4S0Zg2Sr1N+BOUu17B1sINEgyIEacKJyZk4Q1nlWLn8uuasA4Hv5Wwl?=
	=?iso-8859-15?Q?Kt7mlsW4n+dIhD2hT2VaSRuugQ0FBGB93p67biLfxGnrrCTKFepqJ4uTq?=
	=?iso-8859-15?Q?Sh+wXKmbVeMUIskRfvVAsHlqPgvtZwqpJw2z5v48wjb4XtbWVl/Ia+9XB?=
	=?iso-8859-15?Q?GpKNgXjAdAJ/yOgLZxjnNd3XBcmM2MvBeMudMhS4gIRbllEedx0Ilm5UR?=
	=?iso-8859-15?Q?7nvWig9NIc0nMt0Nft7ytO4mXxFySciQXZZdP5oHPIjAUaVkq8Fcsys6E?=
	=?iso-8859-15?Q?2oEgcKU9YnuMAtcvy0j+fLyDBKG7t0seb6c/hUWkIpjct0bmYsu5jguM/?=
	=?iso-8859-15?Q?O/1YCvl2wAzMgE9mh8/7Gi/y3zS3xS8dX0Acxp2c+F3kU67GhEP2iNj?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8052ec3-e920-4685-5a24-08d8a3ad0998
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 23:31:25.7574 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qxj9zWegEiAAnRKltC2a7LnvhSVphMh7iAX5Jt2MgcAoyuue89zxCSmOEfjDkYCUzxNKv3QfngwwTmWhthXJ/Q==
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BINVcl4030974
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <90BA0402B9E3ED4DB2DA17E97ABB5CC1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> According to man "systemd.special"
>=20
> "shutdown.target: ... Services that shall be terminated on system
> shutdown shall add Conflicts=3D and Before=3D dependencies to this unit
> for
> their service unit, which is implicitly done when
> DefaultDependencies=3Dyes is set (the default)."
>=20
> multipathd.service sets DefaultDependencies=3Dno and includes the
> Conflits=3D dependency, but not the Before=3D one. This can cause
> multipathd
> to continue running past when it is supposed to during shutdown.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

