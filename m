Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAABAC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 15 Dec 2021 20:54:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-U5JWIDPKMpyTrOZRhpvDAg-1; Wed, 15 Dec 2021 15:54:25 -0500
X-MC-Unique: U5JWIDPKMpyTrOZRhpvDAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08D32193F560;
	Wed, 15 Dec 2021 20:54:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57A015BD1D;
	Wed, 15 Dec 2021 20:54:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9B7A04BB7C;
	Wed, 15 Dec 2021 20:54:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BFKnJl9001048 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 15 Dec 2021 15:49:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6E78E401E69; Wed, 15 Dec 2021 20:49:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69D67401DBC
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 20:49:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5028A3C0D1B3
	for <dm-devel@redhat.com>; Wed, 15 Dec 2021 20:49:19 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-168-4cV_F89oN9-ubeyct3Uhrw-1; Wed, 15 Dec 2021 15:49:18 -0500
X-MC-Unique: 4cV_F89oN9-ubeyct3Uhrw-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-3-RbWHhwSbPDGKDEs0lsWWQg-1; Wed, 15 Dec 2021 21:49:14 +0100
X-MC-Unique: RbWHhwSbPDGKDEs0lsWWQg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB7114.eurprd04.prod.outlook.com (2603:10a6:10:fe::8) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14;
	Wed, 15 Dec 2021 20:49:13 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4778.018;
	Wed, 15 Dec 2021 20:49:13 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 3/3] multipathd: avoid unnecessary path read-only
	reloads
Thread-Index: AQHX8dtoePd0q6WlZUKMoV1TKPYDUaw0BriA
Date: Wed, 15 Dec 2021 20:49:13 +0000
Message-ID: <4a0b323ba1f54175ab2af31d8491b46ffdea9886.camel@suse.com>
References: <1639590250-11293-1-git-send-email-bmarzins@redhat.com>
	<1639590250-11293-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1639590250-11293-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b27426c1-41aa-40d0-f7cb-08d9c00c5a43
x-ms-traffictypediagnostic: DB8PR04MB7114:EE_
x-microsoft-antispam-prvs: <DB8PR04MB71148A134C13AC60864DDD0AFC769@DB8PR04MB7114.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6XykuMpNayNTvC1rY2Den4TbD1m1AmogKN6kXEQiydH1/0V5eNvY4B7h8z1OEgLGzbjAnM0waxP+a67+/lwS1TrXHiCV2A6un/W9f63znv25b2Lqj2zCgvFZ/gblJ9+/gAK7d/fbHVLQDjNXia2P8PXOxdoDvHvYy8xowvmnISu9wUozRB3A/46J1xfPSo52lCWf56TvvxQqLSchaBpz+juN7qqsfo46vmuAvNeS3iQyMbppUf9knAc00AEeZJiMOH8uUN8FDSJ0zyc6bMJLmuN0+j2vivjQEw+WI3fsftlXJpBYz/4S/bcUPqlMOtAyyc8nmUvWxfkvkJ0C/tAtcYqEqxVPAashkG/aea2gwewZ/XzGrUZ8JN8WlfaX2YjvJFzTKuU1sSO7s4MEEnfn3kkawjfD3w7fjAJ5LjL1GfLPpypQb8OWfa85N8kMWNSyLmnECaGIFgTWjXWjPdkdvuvPkpI61nzZKC+IZHvx1jARt7wpNMEhP2R8dMzdNY1uTs6GO5sG9avQ+b5TNBp5rofosXLfLDhh62mEOoZPxMYAQjTTjWQ1EY7cr3c5wKiJUJQ+oR363zPBX3XBbs4s6DL4rpESr6MCjS9ZL15LDgGdpg0Xe+qnFoUJJ924i6E/Z/QLoD6OFPAux0mhjI6/dTVziGEqip1KrRz9TpzmmW5Ir1Ing87S+BcG+H+a+fkf7KkoklEUksxe+7vyu30sKw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(6506007)(86362001)(508600001)(122000001)(76116006)(5660300002)(64756008)(66556008)(66476007)(8676002)(71200400001)(66446008)(6512007)(110136005)(2906002)(38070700005)(186003)(36756003)(4744005)(2616005)(44832011)(8936002)(6486002)(91956017)(4001150100001)(66946007)(38100700002)(26005)(4326008);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?L5FyXMzi92IbnGMEdF6MlLlI7JYz4BL+rSxGUxs4tSHoMS2++d4N5tKoD?=
	=?iso-8859-15?Q?QN2vXU5EyPm7plVqAO+ALqbhYdtTXNOb2JcgfTqkhSQc+Jd2wFVHN8XBb?=
	=?iso-8859-15?Q?cKQ7qBRTPg94fuSgOp7UF4JiOH6ix8e2eAqZiE41FLbljviI1RGOGxUug?=
	=?iso-8859-15?Q?HlfYe9ZC/wX0SGwL+P7SutDI0PJXDP63cl3S/BSvU8xM1zS5xYv1ekTIv?=
	=?iso-8859-15?Q?QzLW1kpIKQKGH0X2/0WxMVHu+ECetcATM8/J6RnWq3lm77FCWC1DtqI9D?=
	=?iso-8859-15?Q?2QYUg6isXhqfSCaO6LpYUDC5Ij22f/3uQSs8XLo1rH2tHqvFEz4GElGps?=
	=?iso-8859-15?Q?EQWLGkL+L0pwaUn04HI3isSBTULa3+mcPiES2kp/sdHy+1yiaScYy1nde?=
	=?iso-8859-15?Q?fTvH4JjOjkkiXVK//lRsjkQjTWy6BmTCc680bM0qgfCnM7o5zn8Dh8rUZ?=
	=?iso-8859-15?Q?R4iVye47Vu/fiBGVTnKYApNYe+bh27SktzKVpI4S6Un6/j8i/MgeGF4BI?=
	=?iso-8859-15?Q?hI+zrhziM6VtbSDuMagVax4NvInEEFR0FbXQ7zca6/FOd2ic4fO2gc7cl?=
	=?iso-8859-15?Q?46cz5ohPHT2Ph2zhfEOaRqF4Pi3hZDHK9YQj68887tzUMpD3x7Hj2oB83?=
	=?iso-8859-15?Q?J+zkz/MqsKyn9tZCF6569lZztjd3skK1+jrnSXD0GvSbKctIVWWczmXZy?=
	=?iso-8859-15?Q?W5XuL5RUPlVuzYwsEKzujqlpTwIExOYUqynghJpDVBaXngonUtiSdTRp2?=
	=?iso-8859-15?Q?f+QGf7o/Hq4w4HX82/upxzpgkSnQ3aJnCB3AFXoWyO+BJFxaxt2wcGTXf?=
	=?iso-8859-15?Q?yhSLmxisb0tZjtM5pTMdlbw6zRiX+tZj93u07MsX+R0J7OZnkkoxB1UMh?=
	=?iso-8859-15?Q?3fsrwDYkP5tdFV/jNoX3SUmt1uulcwL8mCwFAYlkezDcf+4D05h9nq/+Z?=
	=?iso-8859-15?Q?z2YeTAQH/NgjCQHNPe0gCgHDOD0CgrQ1mXD9hcvO9GyqyYzoQIwke18Ap?=
	=?iso-8859-15?Q?vnT3cpQZJh/ZqWhtmS5KDO8NTZi/dGx2KIVBekq76gyhC7NmaP4/pNiog?=
	=?iso-8859-15?Q?JUKq8Dq9DV4XEBe9SM7kAvhHU9jPmfSWJb8d3c/M92EK337doWcTVlauO?=
	=?iso-8859-15?Q?ysWAWYEcJIGJrcuXfo2mADyN0R9st7IfLIHOT7BhX1DrXzDFE5s80X8Ce?=
	=?iso-8859-15?Q?7YOzcRMHNqW+XWyGv75bBLNCforL/Ce70OeJ/v3UnewiPwUVNiH0quRtU?=
	=?iso-8859-15?Q?080H/hQ4RssnWDU6v2CLuzGZwGFurHVJG9RyhM8494ADnkjOqA7xkcmzO?=
	=?iso-8859-15?Q?LAvv0KuNzV7WDZTvqfhpQJAXosw/lHoQkkb6cThyxlRI00ujpAXHvfEGE?=
	=?iso-8859-15?Q?CL93lZZRtKysXNS+HWM2Ul0tBEk51c6GOTuqXOaYUOpyd5UlzBeCWF8Xp?=
	=?iso-8859-15?Q?HWq0B5kITWzBOvUsj2Ujc07R9TCPSI73izrd5+VjpvIZ+yZX+cmfS0a5J?=
	=?iso-8859-15?Q?esb0GiNbD41wmPzBvYRJYis1qs1ZXizZhS/KWO0wgPOO5NToFl+SEWf5H?=
	=?iso-8859-15?Q?6HeLzp2pb6bMgEJaQnQHhfLYyK8OfgiTEYh5hgCB5MBENqmPMoe7kB12z?=
	=?iso-8859-15?Q?fitN/6g11abn4R+ate0jCkKXUvd6mlrrSdfI0lrSiFtXxzCPoRab3rsYn?=
	=?iso-8859-15?Q?kp8NQWedP/RYIBM0UPwlsQwkKZl6q5OS/9gLgC+jIOoq028=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b27426c1-41aa-40d0-f7cb-08d9c00c5a43
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 20:49:13.5500 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: em7KN6mzAk3ryYTKhtkERyRD6Q4y/xAaA71L3+PUHilmpNMtG25PAjtgURIIGEnWR29Pg1hyQTYMRNfrcAPKCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7114
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1BFKnJl9001048
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 3/3] multipathd: avoid unnecessary path
 read-only reloads
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <8FBF6C2295A42A419853BAB4EB3315B5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-12-15 at 11:44 -0600, Benjamin Marzinski wrote:
> A mulitpath device can only be reloaded read/write when all paths are
> read/write. Also, whenever a read-only scsi device is rescanned, the
> scsi subsystem will first unconditionally issue a uevent with
> DISK_RO=0
> before checking the read-only status, and if it the device is still
> read-only, issuing another uevent with DISK_RO=1. These uevents cause
> pointless reloads when read-only paths are rescanned. To avoid this,
> first check if the path is being changed to the existing multipath
> read-only state. If the state is the same, do nothing. If it's
> different, check to see if all paths are read/write before changing a
> multipath device from read-only to read/write. If the multipath
> device
> read-only state is unknown, assume that it needs to be reloaded.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

