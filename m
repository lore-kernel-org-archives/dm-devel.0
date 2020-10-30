Return-Path: <SRS0=GC9A=EF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F303CC00A89
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 20:44:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2395A206E5
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 20:44:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2395A206E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-p-s72IF1MLWJ4XqNIlkHIQ-1; Fri, 30 Oct 2020 16:43:58 -0400
X-MC-Unique: p-s72IF1MLWJ4XqNIlkHIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADD241006C82;
	Fri, 30 Oct 2020 20:43:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C32C6CE4D;
	Fri, 30 Oct 2020 20:43:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E4A9258127;
	Fri, 30 Oct 2020 20:43:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09UKhpDC015032 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Oct 2020 16:43:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0E276117A942; Fri, 30 Oct 2020 20:43:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08091117A944
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 20:43:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F5EA1021E15
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 20:43:48 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [51.163.158.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-380-C9IhhlfYNJqVyFrTy3TtNQ-1;
	Fri, 30 Oct 2020 16:43:46 -0400
X-MC-Unique: C9IhhlfYNJqVyFrTy3TtNQ-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2050.outbound.protection.outlook.com [104.47.12.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-33-qsraVjfuO8azEosjb02LwQ-1; Fri, 30 Oct 2020 21:43:43 +0100
X-MC-Unique: qsraVjfuO8azEosjb02LwQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR0401MB2360.eurprd04.prod.outlook.com (2603:10a6:4:4a::11)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29;
	Fri, 30 Oct 2020 20:43:42 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.029;
	Fri, 30 Oct 2020 20:43:42 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/5] libmultipath: move fast_io_fail defines to structs.h
Thread-Index: AQHWqYGdmAeq1fd1bk+VARkykq0B2Kmwp68A
Date: Fri, 30 Oct 2020 20:43:42 +0000
Message-ID: <e76d8ffd18ce98430948996eb7e7bf5fd262678b.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603487708-12547-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [90.186.0.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1ab8a8a2-dd81-4e0b-809e-08d87d147d16
x-ms-traffictypediagnostic: DB6PR0401MB2360:
x-microsoft-antispam-prvs: <DB6PR0401MB23601596050D04BF477574CAFC150@DB6PR0401MB2360.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: FaPz5hBFGJ0XKIwkmYsmKSJKe1vM44+P/GETnDg4qTpf/TrmADZ4MFM/zjZkzdRgf93eTfq8acX0rnRvLRbmLweJNzuGeb1IvWSCte9P7mbM882LKcBDNvAteTBeX9lhW3iZk9pQCpo8vabIRI6UPdTSFjEFfrfaLOLUGNMsArk8dtYenqhdJzR4M1zo4AxfgApzaRGtiq854jhk++dE6PlKQmvARdMeSa7uLLHAlR5Ele74Im2SWKp97AYuIFcydFEHYQ8iZRkJLqejxkUoSO06/V0xBoURPjV13kspSFiZjqEG2MGGtksi9RdnRJEK6q6VA3TFu5twRmU56MeJ+g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(136003)(39860400002)(376002)(346002)(366004)(4001150100001)(4744005)(71200400001)(478600001)(44832011)(66446008)(64756008)(8936002)(8676002)(6512007)(316002)(86362001)(6486002)(2906002)(26005)(76116006)(91956017)(186003)(110136005)(66556008)(66946007)(66476007)(36756003)(5660300002)(4326008)(2616005)(6506007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: z/w+Wy1kTOPRfHXUo+olIjO+fiOj+ar0zAqkRs/Y2V+lHw1gPeiO4qo+4K5Im8KVRmQopFv8uD/1wU7kaJRI45eiZmNIJgIZhvunYdpm241srI9B22sCNPaOSGKA3dzW8zv7HIe1Z4nsVInRCZG1+itnEVCtAZjLOe1ApAx2BrdsRpycHU5KDjii5MtSdaju47OfSEvQTzVaGmm7KYFN9dulss45U3WDCbVaqEyyOtLuasHFRBl62fnfgzwDAA9pfnGXQ3unGSt2MebHJGULQPs2UeTOaN+hYzdQIvNk47JKqUlieUfPjjPu8UtOe5kBvE7CFbURLJsmOujdCwipAsjkR23L+lXVwBYwjzEOs8Ex482odqA9XVolGayBhAcu7OoG4eCKa26XqjWRpOWWC8eXYq0EDjeVPYqniI2FDSiqiuUat8FT+Bw48TFe5RuKiL0Gkn7//F+gRJgk7XLa+anR6kHgUKC+fAx/WLy2VeFXdWl5vGOyay8ZfihZe+k++xb2RPw2UqFsW9W06LF5uGA9j2QF2GKSfvwoBkVJP4wAPBFNfcw1ohllMw3tawdcoqyhUQQUNf/JgV8S/OEZxng733Qf2upCBp9IpQYJoZdgwh2+Z/IFfnMuolKWRsqzmNLxVWDrhP0a2tihgVQcQw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab8a8a2-dd81-4e0b-809e-08d87d147d16
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 20:43:42.3770 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 173z+42M3LVhUPTDxvfWqDYX3oHDK1FF+AqEv+7HDoksRD6SKwtF3n/EaZ2S3qF5BjETmpR2quBWBM3+FIc83g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2360
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09UKhpDC015032
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/5] libmultipath: move fast_io_fail defines
	to structs.h
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
Content-ID: <3B394F5DF4911A43A4543ACEB6E973BE@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> Since fast_io_fail is part of the multipath struct, its symbolic
> values
> belong in structs.h. Also, make it an instance of a general enum,
> which
> will be used again in future patches, and change the set/print
> functions
> which use it to use the general enum instead.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

> +enum undefined_off_zero {
> +=09UOZ_UNDEF =3D 0,
> +=09UOZ_OFF =3D -1,
> +=09UOZ_ZERO =3D -2,
> +};

"UOZ" sounds kind of ugly to me. Anyway:

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

