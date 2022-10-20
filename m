Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDBCC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666277910;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6kaPXG3RYSjT/AaEmie/Nzd5QCS2pl76+2CHtnc5sjU=;
	b=c2W8AKRz+0LcJKbXNKqLUp76mMFzU5PDNcWzksxUAdsRX2LonnYovdQcIZhc1mMI4TWQW9
	nzivZ+QJ2TVpjYr/FB2aQR8vfVnXzzo2QubjqX8i6Bxmo5MzrRvFDRf9RqQNNII0hCdPNl
	UF4ah4ayvCQG830arOD4ww7Olg5vKH8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-kuD1YJFoP0q7BxIwd-JUcA-1; Thu, 20 Oct 2022 10:58:27 -0400
X-MC-Unique: kuD1YJFoP0q7BxIwd-JUcA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 873978339CF;
	Thu, 20 Oct 2022 14:58:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2C0B740C6EC2;
	Thu, 20 Oct 2022 14:58:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0F6A21946595;
	Thu, 20 Oct 2022 14:58:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 497661946595
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 14:58:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 382AD1759E; Thu, 20 Oct 2022 14:58:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2FB85FD48
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09F8F185A79C
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:24 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-eopbgr130080.outbound.protection.outlook.com [40.107.13.80]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-LAKGQFLfPhWLYgxUD0f_1A-1; Thu, 20 Oct 2022 10:58:22 -0400
X-MC-Unique: LAKGQFLfPhWLYgxUD0f_1A-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB8753.eurprd04.prod.outlook.com (2603:10a6:20b:42c::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 20 Oct
 2022 14:58:18 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 14:58:18 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 0/8] mutipath: handle nvme:tcp paths better
Thread-Index: AQHY2nNABeEC2opi0UGhnp4xqGyeqq4Xc90A
Date: Thu, 20 Oct 2022 14:58:18 +0000
Message-ID: <3d3c0678365036db7d69a96caa5feaccb8aacfe1.camel@suse.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB8753:EE_
x-ms-office365-filtering-correlation-id: 777ab2f2-9130-419f-fe94-08dab2ab8601
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: U6k9poqk5bkoSG/XDpbGgnTHuwq04UXThKAdlS5oBURXzsvxFkTsFcEgBMY2mOI/pKLyLskGna5eaOGNukQOP1n6vMBPQQpc29cGs/fQUOZuBuRbXIAUNDED7+N8lCTE5e068bidLUbI+Ry2KkM6B8pPh+A2bwokNuSPLmOsFRCUd8BFx4LeSnWiw7fAF3aWqZK5ZTfIms5xeoa4zCJQFNjGlI4n/AIy7/mjhwf/gagHVIIxXrstld3KfN67HPtDrkTqHeKPj5De4k8WBsI+77ynz8YARdFppO64b0OLQltC7Bq73+Mn11Ewp35kfc6cbjdHrCTtMuxx/jgkH1SSOUKFQdm9VC6BEFJYfLFhUYGOeD1Wp26tJJoexksjDASHQL2OTwptcrnC5D4t5HqCVM2o0YBDEy/iBkp16KsLDVqnubf+I2tPOVCL7ugiyRexneVPtblb8j3cKajNF0R+/IHrcShiEZPRZ82bWfARJvmQgPhT3CYEcdylycCA/bAeG6lWnpujhJRS+G4WGk2uUO8RF4MKgty3/fweRA16TPI+ALBIMyoGk/Tb8eZTUkruld4bZJ52QMKi79U3oUtgwxbJUq7fcrSrILXjd7lFFsCj/jWYytV5nTQNRGsfWakBOkdvRuEbx0qxeY1ycCubveTwinDnIyO6Gu5iaZ9LMW/koB+JuD11g3Zrm52FUz07x0j3GYQP+b9qx0LjVxj87QKVXHdQQ0B5dv/ETdW1WAqIkrWN/rJOOr/F1/JAaFayVQvPQF1N38nr+p+1W3LJDAVOzk/TpkbivZfYEB6sxMg=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199015)(186003)(2616005)(44832011)(2906002)(71200400001)(122000001)(38100700002)(36756003)(86362001)(38070700005)(83380400001)(66556008)(6506007)(26005)(6512007)(316002)(110136005)(64756008)(8676002)(4326008)(66446008)(966005)(6486002)(41300700001)(478600001)(5660300002)(8936002)(66476007)(76116006)(66946007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?Etb0WtQ9xXbzXRvflUcdhUNSpDmIBj8hiSrjItafoqZsW6XDZjWRtFZSk?=
 =?iso-8859-15?Q?bjsP4BiJyK9Q3bhCsBnUmcc2aL4klwz6hECLiSwYQr/Cs4vsGNNNGcaHp?=
 =?iso-8859-15?Q?u08tgLD5fTT4AwX5c/MomNSEFg94g5vxTL0819eA6cErA1tHV1KMJuJxL?=
 =?iso-8859-15?Q?zyPb1V4oHcHX+zQyew9NZAPPdYV60OuGTZLdyEiKeOkdXubp/epgyM1po?=
 =?iso-8859-15?Q?lRtcOtqnylDTD98YTbgWNrEPEi2VUJAjyIAQhW6tzJg0/Mi+stGOHg+9r?=
 =?iso-8859-15?Q?Q3IOHcRZQ9Mc1rkS90aMDTWcP4qrSx3AxI4X4+dAhG8IW+XZ4WcNS37aZ?=
 =?iso-8859-15?Q?TAz4FyRGrUGUIM7sEVbPIuFUHio5SKnqLQdH+d7zhyAs81XlWCfJzxDmX?=
 =?iso-8859-15?Q?vluRZjijQUJpxmDx3A53jYkHQn6c1fJrlh+tjfChzpL9NJ7Zis8k/XBFb?=
 =?iso-8859-15?Q?veSRYqm0d44qR4xiz1O8yjCnYfj2lNgxqAtk81AuDURvzeDAr+GSFl/ot?=
 =?iso-8859-15?Q?NY8h3m88j4RT7jJdKda2MUnxUskXvfe1y/SzOoVPzKQyvD/tVbZnlMSHf?=
 =?iso-8859-15?Q?T4Z5obbyr6/d5QKBofJf5XzK0uI7nnyTIPjUx3nPPoueZdmWWmEh4vdQS?=
 =?iso-8859-15?Q?oqilzx1sZ1IVeaCACSg47b1aQPFcosts72xrNAEfAhB6R2KDY6/HbVZqo?=
 =?iso-8859-15?Q?KMnQzss3UxvliJdAZCMsRIXh0bPjzhxXJ+6qOslukxxXslqGj3kWK0TC1?=
 =?iso-8859-15?Q?Ew/PbsKex7M5i4zPnYFocTmS7O7ZBGhIFxRhqhktmvIPTl7JYhZqGlrgo?=
 =?iso-8859-15?Q?WR8j6Ri8C4nu75htUzCXHe+66nOm7+kc3b6E05cm7dgMREzHCPA+RB2lo?=
 =?iso-8859-15?Q?+/B/n/iFHb0UMBC3dY5JD4qIxclsqer8Ot2XFOIImoCrhPfEq7/4zrb3A?=
 =?iso-8859-15?Q?uakr+SjkN/n3vufnDwg0cwazPlF5OR4CZMLcskG4BTKSATkaS4Mgh+k7o?=
 =?iso-8859-15?Q?AHtHP2IjxFELO1IXwDDUu1ZUWbzP3MEzwUlCbnew6oCCy7T9vWATu7g6D?=
 =?iso-8859-15?Q?/ci9+KtBJYb0MPS1vvP31ToXa7PbTn0V2X5SSfHpMEH3YbSKdR8Ineydc?=
 =?iso-8859-15?Q?nWN7X571BKlZV4sHI6VJlnOqNxx2N2S+oZr5PjPEp1di0/zqv82Tpc8r3?=
 =?iso-8859-15?Q?sTAHSVkLP0V5q5dwgRqErPi6HzuXS7VyN6Q/lc0t1RXlQZgcJyJ9CdRHz?=
 =?iso-8859-15?Q?rjsteYpui8L5nbD9NPhTrvOAZoHTw/zZfpIVMicy20NZNBNpgBpfVYTWL?=
 =?iso-8859-15?Q?Oif3t3/kFgJgdJe4M31be+3CcWWE8vafZ0GSk4EywnCyIqPIfVRw34s1o?=
 =?iso-8859-15?Q?jsZDM0KUwZiornPvfX4QMifWgTj8vJYD+sU+3SVFtpo/DSZbHt4W0eRqF?=
 =?iso-8859-15?Q?ZMNUdlcj2LN3yh5oTNHRP1cqqBw48AlSKugt3wqjBBmnNoiF+cycS7iVo?=
 =?iso-8859-15?Q?Xr9+OyCjONi+eNj65vVcITQMvmaGivvig9jMUdk+uvnzTiYMFsPfoZbOd?=
 =?iso-8859-15?Q?1Yt69qqZwCcQ/GCvtxq8he3BRaRL+reEWO6/CS7AWEbQzKf9Ap0XqxIOs?=
 =?iso-8859-15?Q?xMKeYOPXv9lOiZsnX4udqa8Rvok41B1iXgMOAUzTZlvu3v0epxxmtHI7f?=
 =?iso-8859-15?Q?oAfvIKRfgGZ/eXtlJWFxcCk0Yw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 777ab2f2-9130-419f-fe94-08dab2ab8601
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 14:58:18.3151 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OfJIXP+CcLH3jYgUut+TGMRiIytjn7Hra0Yu1q34Cf8467VbrnBSjH0UVPvvfOwmwtEHplBQXlrZZFIMpy+46A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8753
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 0/8] mutipath: handle nvme:tcp paths better
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <B935961F887C9D4EAC376F42CC8E5247@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> nvme:tcp devices set BLK_MQ_F_BLOCKING (they are the only block
> devices
> which multipath supports that do so), meaning that block_mq expects
> that
> they can block at certain points while servicing a request.=A0 However,
> due to the way device-mapper sets up its queue, it is not able to set
> BLK_MQ_F_BLOCKING when it includes paths that set this flag.=A0 Patches
> were written to address this issue but they were rejected upstream
>=20
> https://lore.kernel.org/linux-block/YcH%2FE4JNag0QYYAa@infradead.org/T/#t
>=20
> The proposed solution was to have multipath use the bio queue_mode
> for
> multipath devices that include nvme:tcp paths.

Request-based dm-multipath is superior to bio-based in multiple ways. I
thought that was consensus. It's sad that we need to make this clumsy
workaround in user space while a much neater kernel-side approach would
be available.

> Multipathd currently doesn't handle queue_mode as well as it could.
> Once
> a multipath device is created, queue_mode cannot be changed, but
> multipath doesn't enforce this. This patchset improves multipath's
> handling of the queue_mode feature, and then makes sure that if a
> multipath device includes a nvme:tcp path, it will have queue_mode
> set to bio.
>=20
> Benjamin Marzinski (8):
> =A0 libmultipath: cleanup remove_feature
> =A0 libmultipath: cleanup add_feature
> =A0 multipath tests: tests for adding and removing features
> =A0 libmultipath: fix queue_mode feature handling
> =A0 multipath tests: tests for reconcile_features_with_queue_mode
> =A0 libmultipath: prepare proto_id for use by non-scsi devivces
> =A0 libmultipath: get nvme path transport protocol
> =A0 libmultipath: enforce queue_mode bio for nmve:tcp paths
>=20
> =A0libmultipath/configure.c=A0=A0 |=A0 28 +-
> =A0libmultipath/discovery.c=A0=A0 |=A0 31 ++-
> =A0libmultipath/dmparser.c=A0=A0=A0 |=A0=A0 2 +
> =A0libmultipath/print.c=A0=A0=A0=A0=A0=A0 |=A0=A0 6 +-
> =A0libmultipath/propsel.c=A0=A0=A0=A0 |=A0 55 ++++
> =A0libmultipath/structs.c=A0=A0=A0=A0 | 155 +++++------
> =A0libmultipath/structs.h=A0=A0=A0=A0 |=A0 44 ++-
> =A0libmultipath/structs_vec.c |=A0=A0 7 +
> =A0multipath/multipath.conf.5 |=A0 17 +-
> =A0multipathd/fpin_handlers.c |=A0=A0 2 +-
> =A0tests/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 4 +-
> =A0tests/features.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 549
> +++++++++++++++++++++++++++++++++++++
> =A012 files changed, 784 insertions(+), 116 deletions(-)
> =A0create mode 100644 tests/features.c
>=20

For the series:=A0

Reviewed-by: Martin Wilck <mwilck@suse.com>

I have a few remarks and suggestions for additional improvement which
I'll send as replies to the individual patches.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

