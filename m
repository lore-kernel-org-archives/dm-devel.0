Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7420CC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:23:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC2AE23BA8
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:23:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC2AE23BA8
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-XibklYTnOHWQRgg7lnroGA-1; Fri, 18 Dec 2020 18:23:28 -0500
X-MC-Unique: XibklYTnOHWQRgg7lnroGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FF92801817;
	Fri, 18 Dec 2020 23:23:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E77B5D9E4;
	Fri, 18 Dec 2020 23:23:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0CF7C180954D;
	Fri, 18 Dec 2020 23:23:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BINNMBq029945 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:23:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BA1EA2166B27; Fri, 18 Dec 2020 23:23:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B400F2166B28
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:23:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45D14800140
	for <dm-devel@redhat.com>; Fri, 18 Dec 2020 23:23:20 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-322-1KaJLkJOPN6YHnc_LlImHg-1;
	Fri, 18 Dec 2020 18:23:18 -0500
X-MC-Unique: 1KaJLkJOPN6YHnc_LlImHg-1
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
	(mail-he1eur01lp2050.outbound.protection.outlook.com [104.47.0.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-34-0ZjyqJElOvKpndK6e9kepg-1; Sat, 19 Dec 2020 00:23:15 +0100
X-MC-Unique: 0ZjyqJElOvKpndK6e9kepg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB7580.eurprd04.prod.outlook.com (2603:10a6:10:1f7::9) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25;
	Fri, 18 Dec 2020 23:23:13 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Fri, 18 Dec 2020 23:23:13 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/6] mpathpersist: update prkeys file on changing
	registrations
Thread-Index: AQHW1ZJ8k18k69mPrEKl+tjY+bpbFan9flwA
Date: Fri, 18 Dec 2020 23:23:13 +0000
Message-ID: <44f1cdda76e4b88fbc2f8826fcf933908b8d2cd4.camel@suse.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
	<1608332802-9720-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608332802-9720-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2afc006e-8b53-402d-29d2-08d8a3abe437
x-ms-traffictypediagnostic: DBBPR04MB7580:
x-microsoft-antispam-prvs: <DBBPR04MB758095EE2FBB9016EC5A64ECFCC30@DBBPR04MB7580.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hWxhN0/0iCqZMo6jpLt042sR9PJCXRxZNaXD7a6LGvMM/qNF/5TCiRxD/PY/20DuoK93I9y0dWOWg05PslptnEFIEd5dWXdUEIj62SbKbtBQxEO5WX7/S9QmgbV5DfK3IcgmiE41gL7FSl+M1u/Awmq8M6WpKZjJHwXbwIsR6zxmlmr6yRKPWCAO3qM1n3keyGoK0UT6zKHdpWDa0Ac6p8eY8OEcz9HPWszAt4mhp1wy4s8AcGqxDthnjAkWSBolOrzMPDoMJGOGEk32QDRg4Qghdz0pV2Q7+9WZp1qnM+SmBLaTkc+wAMAaqNi2HH6KRWT1zU/Rz2YNyiuf6Y400g62hZTAi9+meCGmiwfHoLDujwVp4oiUBqn0I7jnN1arRlouvWleRxB/py3kUNYtig==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(366004)(346002)(376002)(39860400002)(110136005)(186003)(5660300002)(66446008)(26005)(64756008)(36756003)(6512007)(6486002)(44832011)(66556008)(66476007)(8676002)(4744005)(66946007)(66574015)(478600001)(8936002)(2616005)(15650500001)(4326008)(83380400001)(6506007)(4001150100001)(71200400001)(2906002)(86362001)(316002)(91956017)(76116006);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?+QVsuWZLWcAMTPF3rkP/WOvT2/pfy2im7ZOSjIL7Kh14m1CA2u7IxJdWO?=
	=?iso-8859-15?Q?b5K06GP7hxotMG+SpohijPzK5cL07OhpjqDb4Sq9mktcXDGGN2ZmaGhGw?=
	=?iso-8859-15?Q?a1kGTvWjuAONRfWiKrLUyw/RTxqaKLa0nwg8QXNtSs5rDpeBMRM8C/zY+?=
	=?iso-8859-15?Q?yAZY5GcTsHaqwGIiMylSClI3XrLJz3Rk8qSlFjXw711Uiy2MsRv8Ddz95?=
	=?iso-8859-15?Q?y0PADw1HR44p0qAUlhqVc01OLcMl8UPqfhyfATJlZmWJBZlDCkbMfO9/m?=
	=?iso-8859-15?Q?k4Ed4gLWSdLx1Ao6aJtxGlQYnoo1xDNBaXuaHgOCaLjub3u3Zxx0LDltJ?=
	=?iso-8859-15?Q?Af1JyaAc8JtyxD8a9uDZC4itcpvQ8r2beAUYS+9RYGejK1ZkW7qnc1OIt?=
	=?iso-8859-15?Q?MHUe38RTolgCgHzy0JE6lmh5Txa4UdLtiwdtf3TsFPKSUVVI/G2PeKIka?=
	=?iso-8859-15?Q?m3jXmmE9UNCm4xWX/KPJP+aXqpGtLMozmUPMxMjSAoy4KgdoKqgcmE42T?=
	=?iso-8859-15?Q?TDiBA1Dab4sOwgB8HuppLwslyQdFt82A0woVF1Uuz4qo7WrrJcJEKCzEs?=
	=?iso-8859-15?Q?xXaD7nII5EW34UilRyraIuIGRscaM5sOqXJ9fhfLWKq1c5wvrJZDhUawh?=
	=?iso-8859-15?Q?/0bNY9umMgsYv0Cr5xmRYkZYlWQgCi2R9RCjxagDFDTs2QdZcN60F3FBT?=
	=?iso-8859-15?Q?r9it4oK4W75EKmYCDc+PTcmAGchAG7bFxtmuFapsRZMBHmObCXEypTS7e?=
	=?iso-8859-15?Q?4Gg5L118DyXZMa55vXyxfX5LECf2wuWAtfGTGs7qCwiGfMhtZ+zW+RZ06?=
	=?iso-8859-15?Q?Q+nUyJ17YcPNq7XH7QEA2ZyzHQx0z2R9J3TcDesttoZ4eU65wxH6+VqpL?=
	=?iso-8859-15?Q?3RrLTEL5fz8TyvSP/XW9unlEmfc8GqWEUVSJbEtaOvidpR+ACC99zZKvD?=
	=?iso-8859-15?Q?uIZm+3v1vNMs2V7ZJXGcMkE8lNVF63rXgUZuc+fb6f5xpuWZ9qzfIwpm+?=
	=?iso-8859-15?Q?0Kjz/v5tXYWrFC5wG5gq+QJxsAQIVUjzQM726APzUb5pn7H23/nOurU?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2afc006e-8b53-402d-29d2-08d8a3abe437
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 23:23:13.6210 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nz9SfJqb/R3v36C2zfkuWrPdkP6CFpEHNkZUmY2fcHxbWJ7UsWxK9IQsSiLM8Ezf7q2XUFy/bPl89Gdm7Ddt6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7580
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BINNMBq029945
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/6] mpathpersist: update prkeys file on
 changing registrations
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
Content-ID: <C0AE9F1EFF6C214DADAB5D058C196FED@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-12-18 at 17:06 -0600, Benjamin Marzinski wrote:
> When the "reservation_key" option is set to "file" and Register
> command
> is run with both the current Reservation Key and a new Service Action
> Reservation Key, mpathpersist will change the registration, but will
> not
> update the prkeys file. This means that future paths that come online
> will not be able to register, since multipathd is still using the old
> reservation key. Fix this.
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

