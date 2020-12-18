Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69160C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:33:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D397E23BA7
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:33:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D397E23BA7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-wN2YB2LzMmWmem0d2C92Mw-1; Fri, 18 Dec 2020 18:33:06 -0500
X-MC-Unique: wN2YB2LzMmWmem0d2C92Mw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4CE4107ACF5;
	Fri, 18 Dec 2020 23:33:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B31845C1C5;
	Fri, 18 Dec 2020 23:33:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8A4E44E58E;
	Fri, 18 Dec 2020 23:33:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BINT66T030693 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:29:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 261ED2166B28; Fri, 18 Dec 2020 23:29:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FBEF2166B27
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:29:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2ADC185A7BC
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:29:03 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-193-pjLzTnPmM5qORLm120XMxQ-1;
	Fri, 18 Dec 2020 18:29:01 -0500
X-MC-Unique: pjLzTnPmM5qORLm120XMxQ-1
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-31-xovZEoorMEqReEl2vdw0iw-1; Sat, 19 Dec 2020 00:28:55 +0100
X-MC-Unique: xovZEoorMEqReEl2vdw0iw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5387.eurprd04.prod.outlook.com (2603:10a6:10:8b::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.14;
	Fri, 18 Dec 2020 23:28:53 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Fri, 18 Dec 2020 23:28:53 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/6] libmultipath: warn about missing braces at end of
	multipath.conf
Thread-Index: AQHW1ZJ7q2ArFe30j0SObCmb4cR566n9f/EA
Date: Fri, 18 Dec 2020 23:28:53 +0000
Message-ID: <f13f7c8da20d7ea8921e9629ebb3e6a1fbf22e50.camel@suse.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608332802-9720-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 06399b65-d05e-4ff9-4875-08d8a3acaebb
x-ms-traffictypediagnostic: DB7PR04MB5387:
x-microsoft-antispam-prvs: <DB7PR04MB5387E8C3050F9C363A78D4A8FCC30@DB7PR04MB5387.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wd8JUAla/GPIF5qe3AjGerjlWlVuRdAvIiXqpOCs1K8tbIZ9EJUdctkGfPMWvDyBRwfhs2aj1gxizo0QBFPkUdG+zwqyx7JUvtKIRN+6+HZlFNqqGdGAWjyVyjn8XLvflmNyIIvWr5qHpVrP0fgP/uGIR86WPkOUVmXUv9CzIcaEOPZOmjxDpZBbAloNBwQuAL4YBSjLbJI7+IyCcCVwATiBW3DNgpqR6yf14LlYwkt/15yBIF7Y0MHsfoJgps6L65hOT9nBELWvWR871fsBPiLHhQC8OG6/fsGhz1UxJuhEv2tj2ozVEbm3II1payaoK8+dHzwfvIZvcHWFuLO4cg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(136003)(376002)(366004)(396003)(39860400002)(346002)(316002)(110136005)(4326008)(71200400001)(36756003)(8936002)(186003)(86362001)(83380400001)(26005)(2906002)(4001150100001)(66946007)(66446008)(66476007)(64756008)(66556008)(91956017)(76116006)(6512007)(8676002)(6486002)(478600001)(6506007)(4744005)(66574015)(2616005)(5660300002)(44832011);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?qIz9rvW3u1DsGA/0/aKbDQie0Y1CpbiKByTPT4thY55nMi+jIFDn6rncA?=
	=?iso-8859-15?Q?UKm+DhsJHXkyamIZPYocav1XNfy5rM/BKiSsMwkRjY/0fcmn1UL7L0pd2?=
	=?iso-8859-15?Q?msFBQNidvKtmDkEj8x0ZqPkXEdj8WDcB4C+tMqvmcPVvs/BRWj6Bgz+7L?=
	=?iso-8859-15?Q?YJ9GJ+1KLILVIim1u7ueinDxCl8VQVkhftjIOC0tcszXsaqbMHHm5rkb3?=
	=?iso-8859-15?Q?vixM6Wyd7xouzm1h7V2FH22Er4Pu5B2iqmD7x51JnIzhurwKjSWVhOXiZ?=
	=?iso-8859-15?Q?sc82R5VH6Re5zmOw7duSb+Q/d8FDSdVHHrCX7U/fxiUdUuYPyH4mdLyz4?=
	=?iso-8859-15?Q?rdDIgCqMzqHEzGttfSOTAaDLBhZwZDXyB5EZht8Hdr3AQDzfrtdyLABVD?=
	=?iso-8859-15?Q?6UovtDNUyAo1iEtnCmefDLka+vTRJfiZ9OkS8117mvEu7x0dMO+e17kA/?=
	=?iso-8859-15?Q?2EnCws4yMB17v20936hZyymG6KetwC/+eAHOVkGAFMvqYbxn+vB5tAO1Y?=
	=?iso-8859-15?Q?jywosYj0Pn9VK9a7GdQF4YZDgcOpx2DBODUHGlge7uv0HGxn3SKxzmZfU?=
	=?iso-8859-15?Q?nz2Q5ltAIFcFI2rBXBgsG2gB1C0eNjZZhDKIodost9O2b5//SiWcVGp3D?=
	=?iso-8859-15?Q?4PiZMIE/i8QdPTfFn/4T2NLdmejkZffD7sL+BPova89H9kxK1lRfBYOkC?=
	=?iso-8859-15?Q?ym1EBhi35hqjJtg4cMfIvZBdVYAdDWuG6uH751D6UtGCz3XRuEzBLBUHZ?=
	=?iso-8859-15?Q?q7SgrYg1cz4CO5WmJ0eSasiIzUFEhq1cjmWxGX4jJ4vjeeVf4L098KR+G?=
	=?iso-8859-15?Q?8fogwyFYp34wZaCstxHZfLQqVNTo9i6nr5KEZyoxmIYQzqxCfS+3Kvv1I?=
	=?iso-8859-15?Q?HW2VCjdDGQNtyJbizSpkjzFk3XMHSvHH8SszGRZcijfmrxpPw3tC26yIC?=
	=?iso-8859-15?Q?qt2M9joklnldkTgmcBa499+TmXC0+qPOwm2AsiNOFtyk9yCOMi9vEvjtY?=
	=?iso-8859-15?Q?sidDWjj0G5wr2ZQNUh09tGFvMRvtYhl/9PIVz6M7jHDXPXtJIqiqZxM?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06399b65-d05e-4ff9-4875-08d8a3acaebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 23:28:53.3677 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upZyrbVwTQhif91bfCbRhgbZGn3WwDMaPx8uqWR8/zsdgctOmgPDMETuHxmw+pm/ioHQPr3c308lFIxoVnSx7w==
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BINT66T030693
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/6] libmultipath: warn about missing braces
 at end of multipath.conf
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
Content-ID: <414654BF2562D045B4FDDD6EEFD922EB@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> Multipath doesn't warn when multipath.conf is missing closing braces
> at
> the end of the file. This has confused people about the correct
> config
> file syntax, so add a warning.
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

