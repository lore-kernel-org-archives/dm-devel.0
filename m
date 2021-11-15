Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813B9C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:30:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1FD5761221
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:30:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1FD5761221
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-ym9Q0IOAMZWoEHspzU03Aw-1; Mon, 15 Nov 2021 11:30:49 -0500
X-MC-Unique: ym9Q0IOAMZWoEHspzU03Aw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7039B1B2C980;
	Mon, 15 Nov 2021 16:30:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 549DC22719;
	Mon, 15 Nov 2021 16:30:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 065031819AC1;
	Mon, 15 Nov 2021 16:30:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AFGUfbd029404 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Nov 2021 11:30:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ABD842026D2D; Mon, 15 Nov 2021 16:30:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4E632026D11
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:30:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE98E181E06A
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:30:38 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-93-BRoKKgVWOSekrX2DycR5Wg-1;
	Mon, 15 Nov 2021 11:30:36 -0500
X-MC-Unique: BRoKKgVWOSekrX2DycR5Wg-1
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur01lp2053.outbound.protection.outlook.com [104.47.2.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-4-CXDPbVgXNmSZVOwqf_ovxQ-1; Mon, 15 Nov 2021 17:30:34 +0100
X-MC-Unique: CXDPbVgXNmSZVOwqf_ovxQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5227.eurprd04.prod.outlook.com (2603:10a6:10:17::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27;
	Mon, 15 Nov 2021 16:30:32 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Mon, 15 Nov 2021 16:30:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/4] multipathd: add "reconfigure all" command.
Thread-Index: AQHXrnZBQU93GCfRsU2Ub5ojip7DM6wFH0sA
Date: Mon, 15 Nov 2021 16:30:32 +0000
Message-ID: <bad13913385c6377b2ec4dc60056417d163171a4.camel@suse.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<1632180076-9294-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1632180076-9294-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82a42ba8-f4ba-4234-6471-08d9a8553ee0
x-ms-traffictypediagnostic: DB7PR04MB5227:
x-microsoft-antispam-prvs: <DB7PR04MB5227A2DB536DF549C965791FFC989@DB7PR04MB5227.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:935
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: CFILELmVwVAD5LaAWUuRWBf4uJ+eTudFYyAoe0M3nVfsqx2JJhkiVD0vu+kokvN7B1rw+N7XQ14J44Rzuq++W2dndYnFQYbQqNq4YlU6XYxjWJKSJRC1Cieg9Lyv3GDbKBmCCa0sulocMwfrZ8z3Pc24Q8r+BXd4KfoCirheNk4Zbu1/13KP/ZOG8cts3z46TaxqMiTlu/QXmk/aOaPkKJs+/eiPg34TZYNwyPXrRU0MhbnRdv6pOFRj2ISvyRFscdqSmVBU95fsvpdEG7Tn93KExcmIKf63tOyfIGaQErUtEh8Qh0DLy98rzVYcV2SoZKJjjj/biR2VIeZ7QDQ66TbB9bMimgbUXbriWI5wRRTtMySMg6L8ctyORNZS+IKk135x8/J+h8KuG1G/KtxJJWuPqE0PihVR4DPM1L6/SUXcOMshWTFih08YGVvPC8f4GDmbKj1AsQGiYid87nk7K1I4fs6JtTAKTLFzoarrPvq8SbVOKLLBG59zFVw/0HuTljQ0z+JyfovMHK0G9SGVHKgY+nN9QXcHzR0xIJ4FgYcQJvStA/Z5QPadfn6rbyoN09xh0TlHG+3Fw8qcma5E1H4Es5yh9d5nkm3SXqEFgf5QMaCerGCQKFAPNuxlQCwPOc+8NJWrwxryWeWh6EbT9oLr+r57RwmYzyNA/S5y4poTOHdbBBlI2/TA2vemp2wFNOiFDSbMaFSNEbu7xvE4vA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(66476007)(66556008)(91956017)(76116006)(71200400001)(6486002)(110136005)(66946007)(64756008)(66446008)(6512007)(4744005)(186003)(2906002)(26005)(36756003)(2616005)(6506007)(4326008)(38100700002)(8676002)(8936002)(122000001)(44832011)(5660300002)(508600001)(86362001)(38070700005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?YoWveW/0v5KHgWyNJ2OA1TeqsioC7AI05QHpOEFsSMUdXS/CTyBU7emLR?=
	=?iso-8859-15?Q?uQIjXVh03NGGIu1ZkWSxYWRGVez1rsxxNVwS8nvZ+xEbFsnUZOAZFL5IL?=
	=?iso-8859-15?Q?Kmn02ljnNPv8bro1F031odWjudMUS5MwLI7X8Zjw82Rw3fZ+ZRxr5DYgi?=
	=?iso-8859-15?Q?YLAJZhoMU20ZH6fjX3yKVHvSPZUreIxbSfdi087BqgipSWuWz2EWTUGxx?=
	=?iso-8859-15?Q?T1/hQT7aVysUgImRcOjRj+mE3l+lu7vI8OZBO1Uj7PJlGXyc0uRjX+oRk?=
	=?iso-8859-15?Q?WVku7f+MeTUNJnZ5tWNEA0IISq1zzEW0vm3ORCjPdm933nWezt0pvUt8z?=
	=?iso-8859-15?Q?4mtdcHkJYadX7lSQ3qqwB3JvINKpCuipdD7Pf/8W+K4tZkuWgW7u2rMlp?=
	=?iso-8859-15?Q?GaqreBxIvDeWsZUnUnjiOnuviNOAbwv6qKuZg2Aq8EWOZuXH5eOTUT7eV?=
	=?iso-8859-15?Q?iB0tELueh2/psMwZS+09ZoMxZhIzUuBvloQ//7i7tekYGKgWQyLUkgTGm?=
	=?iso-8859-15?Q?SJP/FNHeNQS63qFqdT63FDRld77ovRC1QmziI0XsQa6iQfZs1rpOIpuxS?=
	=?iso-8859-15?Q?FrLuC1zBZ2unJxK3ceBdS6JWv30x7n7/VH2d4YN8pgGN/9A1X4WQn9pDR?=
	=?iso-8859-15?Q?hbCP7fP2jp3nzX7vmJ9Iy9pdfaab5Ust+t5ukh0XKh+p7Exi7BDQEvA+j?=
	=?iso-8859-15?Q?cO7XvO19P4Uh1isrZKqiAYmLUFAqzzLU0n1XwqZvYcjzVlwuSJ4Qdd7Ze?=
	=?iso-8859-15?Q?U8Ws0D+OELRiCbC8+rVKU1J8/G2Bbuq066V49w95PR22SNG3wV2ZLgriP?=
	=?iso-8859-15?Q?GeOT5H9oV+05YQ9cV6XZY40OIXeJc9pCk+xSUWVrd3IpPKKex4UXEC1ya?=
	=?iso-8859-15?Q?EGrMYn5WovGZx4Ov2crMQxxqvtOn5bYfILsyZw4rY5Z3vS4Vo2JtK984y?=
	=?iso-8859-15?Q?53kYN3z+lzqYrvXGc6D8CAVf9L25cFG155H/lfauARAChuSrs/dnpzfW7?=
	=?iso-8859-15?Q?p4ja4J5CIZ986m+qusC66cvRLsS0DOe8KYipHtpMvyGcZ4OSaJXfyauBG?=
	=?iso-8859-15?Q?6Jzzdb3hUdlSW8ghFhVrOQkg6FFteNGwFjpzyc26BL3k0I1KgcjL34U3u?=
	=?iso-8859-15?Q?teL9ZYgenbiCTqzCkuH5flVjSw+AWGrSLQjNzv96l+btswo91rrdv2dAu?=
	=?iso-8859-15?Q?JpUOeNiqyXC6Y8W89j/gwJv41dPj6Nf6WxYSp8Ist/07TzDi3VemeOVNc?=
	=?iso-8859-15?Q?oxDK1tw/SotH/y8+kmA7erhcj1uqxYysZ1hDPM+qr6Y+6SIhDieIBTk7T?=
	=?iso-8859-15?Q?jhOJCqhO4tnXkU7eRIr0DKiZ5kOHIgk2eSbwBhfYg0BmT4mVm3yUkFwmq?=
	=?iso-8859-15?Q?ASxT1/3MXAG1atTIb1CBwzEcZeiSFDNQFJn1a1lIhog2YZ2rorIwQNKO0?=
	=?iso-8859-15?Q?vk/AQVyWC8Fhl0+MqNwxLO1kT/6rUdKf+c61ZX4fI3zR9IaRwX31B4fNW?=
	=?iso-8859-15?Q?pB0waV0mVnMm09Rfp7QQU0AkW/mtDYe0NX0HZHL0lGOVI3G4QZieHIPHm?=
	=?iso-8859-15?Q?lVewMp8H9t4ElDQx4kMC5go/8NScsl5+N9IWiItxBaIz0RW2cpNGqI00q?=
	=?iso-8859-15?Q?4Q9lfn/+TC1zFjIfR6tX1GuV6eLaxLd3j7V4+nFNgIHVNMgUF+X3bILbg?=
	=?iso-8859-15?Q?jyY9zeq13ItsBHau+xff8AtS9RuakVEGjPuoH7vN2UmUlFs=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82a42ba8-f4ba-4234-6471-08d9a8553ee0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 16:30:32.9076 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WadyYYU1hNP+WLM0OHvZjEfCxEcBXRvkaetlsL61SFCWMaHvLhrzOEAKp3EZTBsAOGuFF00Wxsk8bLpa7k9e4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5227
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AFGUfbd029404
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/4] multipathd: add "reconfigure all"
	command.
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
Content-ID: <A2DB48572FFBC84B8DB19F82F231E41C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 2021-09-20 at 18:21 -0500, Benjamin Marzinski wrote:
> With this commit, multipathd no longer defaults to full reconfigures
> for
> the "reconfigure" command and the HUP signal. The default is a weak
> reconfigure. A new command, "reconfigure all", has been added to do
> a full reconfigure.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

