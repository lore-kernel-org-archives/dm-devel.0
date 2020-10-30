Return-Path: <SRS0=GC9A=EF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A32EC00A89
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 21:02:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E0085206DB
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 21:02:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0085206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-ntSUuZVKMWGXivaITJ6l-w-1; Fri, 30 Oct 2020 17:02:30 -0400
X-MC-Unique: ntSUuZVKMWGXivaITJ6l-w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0AE38030BD;
	Fri, 30 Oct 2020 21:02:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CEC05C1CF;
	Fri, 30 Oct 2020 21:02:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 27460181A870;
	Fri, 30 Oct 2020 21:02:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09UL28eE018424 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Oct 2020 17:02:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3982C2156A4D; Fri, 30 Oct 2020 21:02:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 333E72157F49
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 21:02:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4B3C1021F7F
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 21:02:01 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [51.163.158.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-562--6tYQa8oO6GtqtC8Jr_j2Q-1;
	Fri, 30 Oct 2020 17:01:59 -0400
X-MC-Unique: -6tYQa8oO6GtqtC8Jr_j2Q-1
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
	(mail-am5eur02lp2059.outbound.protection.outlook.com [104.47.4.59])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-17-LcAYfGIZOmC-cykJ-tHCkA-1; Fri, 30 Oct 2020 22:01:56 +0100
X-MC-Unique: LcAYfGIZOmC-cykJ-tHCkA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4475.eurprd04.prod.outlook.com (2603:10a6:5:35::13) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18;
	Fri, 30 Oct 2020 21:01:56 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.029;
	Fri, 30 Oct 2020 21:01:56 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/5] multipathd: remove redundant vector_free() int
	configure
Thread-Index: AQHWqYGiJpHYknTe2kyMfxhy+xK866mwrMiA
Date: Fri, 30 Oct 2020 21:01:56 +0000
Message-ID: <7b64e0ffdfc4db3baec271637160def735a41734.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603487708-12547-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [90.186.0.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 628fcc1f-6384-4393-86e2-08d87d1708f4
x-ms-traffictypediagnostic: DB7PR04MB4475:
x-microsoft-antispam-prvs: <DB7PR04MB4475E7F053F8832DF389BA17FC150@DB7PR04MB4475.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:626
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cqTGdOZ4say1kNcAqTU15hH1nqAP8TcaGKouomnndQXIezD2Z77OSY5rWQQUWabMddX4E6VqgMyCOIANUF5JrRFnd2VLte/MA8yUNIoCu3Q70DxqSEy1Wp9lldSFXELW+/U4quXGt8DoknV5uIuAlYlfaVSH0fUKz0niI7Jm8g9IVFdQbyDkA2V8eMyCUR5R+diVVnCebdKamSK7PhpSRCBA5eobhjIIHtoKMax3J9Qy9GJiBWXNRdkenbxJV4+6vo/2t/TZqC8boUW1phfWLqXXl+m/hSjGnm5M8BUF+5fisPMtzLjwRtTbew4OGrYEGRUSqCmFP7T4T5/+rSPuHg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(346002)(39860400002)(136003)(366004)(376002)(396003)(71200400001)(36756003)(91956017)(44832011)(2906002)(478600001)(6486002)(66446008)(64756008)(8936002)(86362001)(66556008)(66946007)(76116006)(6506007)(5660300002)(2616005)(4001150100001)(8676002)(66476007)(316002)(110136005)(4744005)(6512007)(26005)(186003)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: v6JkCG644WHLOgiXHmTEKJp9RTpS8yj1ilZUbRWyIgALdGP3+A1rbn7vmh1WEdNVeWfPzQgbYQK6AasN15BaxCKt48vky+Xx3IFDYfbn5k3LyPolTQi4wRsjRTR9C8i/D99N9ghrryhmt58D366w+bGgRqLw+wFdPqsOqhCT9fnTFZzh5F5IJZsLBHEbfnrors0pPOA0XNhWdg/HqFq4+W5qZ9wV5TUSKYdHr3EOf+Md+n0avTGfM85tGkssU71KAH/Xy7ttFdX62aRWz4I24XWLZ8cF8FpWiFWXxq/CwYmW773zKwlRqNzTPXw72VoRY/rv3SMRHfV7geP4JMjQD4g0nk2DivJ8MAD0g3IauYKNgGdNLoftbSaad/NJkTvUdSYqKpmcwuyyROyZMjlVhMilEMYeUNCzPANquK/m/qANJcEW1Da+AuQfiNXzbz5BYIcAmG7SmIyxQ199psnoDZUbNsEuzjd2ffPRKBh6ywEFflS8XHGmKyxuxSY4nYjoFHYifEns9TkPq70MQZjIAX0hUI0djxRej64LMpcj/F6Mbw+Y0i8f+8du56IIGFrTYaniGEjCtAyB/jLuzpAyZFF3PHi3dnmQyCrIlDwdYjWDNQCvLyuKZ9kDO1wI2cqSYHeGHskZxykzU4ckInGLCw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 628fcc1f-6384-4393-86e2-08d87d1708f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 21:01:56.0448 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YorOUc2dh/T79PwSiCRMDM8EkDsqH6cfN4wXq2JNx0srgc9LYGc9kHzMtDnZqyQc58jjMRQsivLhfb1Q6JTffw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4475
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09UL28eE018424
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/5] multipathd: remove redundant
 vector_free() int configure
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
Content-ID: <56CD0D8C28A8A44BA73FDE85F889A671@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> remove_maps(vecs) already calls vector_free(vecs->mpvec)
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

