Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3376C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:18:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3C59E61220
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:18:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3C59E61220
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-4ZnWMmBdMeamRFpOvRKEtg-1; Thu, 04 Nov 2021 18:17:58 -0400
X-MC-Unique: 4ZnWMmBdMeamRFpOvRKEtg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81DBA10144E2;
	Thu,  4 Nov 2021 22:17:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56976197FC;
	Thu,  4 Nov 2021 22:17:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E25494E58F;
	Thu,  4 Nov 2021 22:17:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4MHrau032506 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 18:17:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id F10802156730; Thu,  4 Nov 2021 22:17:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E9CFD2156729
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:17:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02987811E84
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:17:50 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-519-eZ8_5DBnMN6vUO4zi4EFRQ-1;
	Thu, 04 Nov 2021 18:17:48 -0400
X-MC-Unique: eZ8_5DBnMN6vUO4zi4EFRQ-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-12-Y3EeJXx2PvK95Hi8i-eASg-1; Thu, 04 Nov 2021 23:17:46 +0100
X-MC-Unique: Y3EeJXx2PvK95Hi8i-eASg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBBPR04MB6266.eurprd04.prod.outlook.com (2603:10a6:10:ce::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10;
	Thu, 4 Nov 2021 22:17:44 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 22:17:44 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 7/7] multipathd: Remove dependency on
	systemd-udev-settle.service
Thread-Index: AQHXxebgE8PgftL2NEeQfQYACA06Kqv0B8WA
Date: Thu, 4 Nov 2021 22:17:44 +0000
Message-ID: <9fae1dc55d6f177898cb61e52985ffcd3db30e8d.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-8-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ee6e46d-fef1-4405-fb61-08d99fe0ecbc
x-ms-traffictypediagnostic: DBBPR04MB6266:
x-microsoft-antispam-prvs: <DBBPR04MB62666B35CA7786B70BE07DE8FC8D9@DBBPR04MB6266.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LCcay9NG4ZX2hZfGsmaVMrn27QQFKc1UM4Yak/byQdOl80h/yHCaYPA9twac6JAV7A9cQ1RSXNBRb5fs3hmMg1awYG8ZBI1HWFJji6iUh9MtniU7XsEosbhi6h95rSE66CTmEGrPIS1PR5UJH8ve75cexPBFbKQPWpzOWcZfQfxxfXX1GeKnewdTtk2U/Ck90pDUFJKqxtElWRBq9vRsnM2ltemPZ3SoGTO0AI28/KjTXbWr8SPCdgvjPQLTkUf7xDCzEO39aw/Qj+ShqwbWCTIzne6bDWOQ/ClozwW6EGgeSRdmJGOxfODl8TEZIAgnhfyJpybzoVIb6NFWGZdrLPRXGvjxKSNPqV96YObHtwa2dzTkV1n1Xv18AXpxsfNuQmPxKtXUlV4IaC9zErkzgXHAQOEo+kXZzYnM2GR7L7/ayDVI4t2SOXKNMUmeG1AmD90/sH7c84rEBi7yE3V1diwlEvp3JmMMBmPjZ0CfUIR6x1bETofoeelxJM8BwiZTArleSLP79v16mQG/soeANVKNA7L3PeEQIR7ETIf9qr1m2+asaOyG2QTGdq/H9MZ5m7xVj8CTXIPambYHxER6FGdIKs9rhbVxA+cL8yH1QpJyjHGWAYzoSGISBfK/t4MWsKQ9sVAjlSLmRAIlOcB998qomWVtCFDyr7qLhXpIjMCpI9JnPYPDBrVaJ1j2S49y849cv8zef1cw1t6mZuBcrA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(2906002)(186003)(122000001)(38100700002)(5660300002)(6506007)(71200400001)(8936002)(4326008)(26005)(4001150100001)(66556008)(64756008)(66476007)(316002)(66946007)(38070700005)(110136005)(2616005)(66446008)(86362001)(6512007)(8676002)(6486002)(508600001)(76116006)(4744005)(44832011)(91956017)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?2vEw9DaHnWe5ekk6ZOKGCSFq33EbNCL7TeGBm0oRRrweBmpD5yl+ipnfA?=
	=?iso-8859-15?Q?UFK8PI/ACoOq2tlTU4fIISBY19u+uybkKPwcCDcc9N/Wc/lelQ7m5eIEE?=
	=?iso-8859-15?Q?jU9DGsKSymu4aYdV7NCcyEb2xTTYMe8hpXNeT/JpoigOluJ1By78VEj1z?=
	=?iso-8859-15?Q?hPgXhAJpnefXZ33PvLUB2JVzIodiyhchhvgz3r/17ZfhJA/A6sub/GnS5?=
	=?iso-8859-15?Q?ShO3iCL8gt1cwqc9ctOgwqG3Cw/Tga/xdvRGebo4LgWRe0DxzIvq57JdO?=
	=?iso-8859-15?Q?KhC+wpOmbeCRE49UgLD3xJlNrkEfLabfq8acj1upfpJ6JyKUeBzLDhvT6?=
	=?iso-8859-15?Q?b2QvZ51wLil9j1dXjwnQWEh+i0oBjB5W7eXcj0KTEA/QRfDOa44PXLnbl?=
	=?iso-8859-15?Q?mOJeAhfNVYXP90eeDXy/bJe3sCBvcwqoRgyy2KssgCiwxikXHmuPxNmGs?=
	=?iso-8859-15?Q?x/vEpdEFrH3Jcta/sk6MMtoCsAV7ECQg3tC+C09aFPUknEcnojjiamo21?=
	=?iso-8859-15?Q?gYTd4dZdnzjlaWHR5B9oGvBkimZy/qBedt4w6twzDeenQNRsCfBah2MJ+?=
	=?iso-8859-15?Q?7n82CMSeIWxdZSSwPi43IC94fgpGj0onchvXhvCiwk1YvmdY+AiDcq9JF?=
	=?iso-8859-15?Q?4Jg7fZdIYJWJHRk97VI3+58exQIXWs6DLd7Tm9SwlvUwurPlWguzx2zWP?=
	=?iso-8859-15?Q?16bGIplKsQxb9m1SPAGMhrVxHJTEn0KcomVY8ngcXgvwvPmN4W5odFn25?=
	=?iso-8859-15?Q?S2JVqoM15j4Wcp6COybt+BV5K8wY09oBZIdKWxufXS0ZR3TcsCxoSI6rg?=
	=?iso-8859-15?Q?gUcWN26sQcZD9KtrRfscflP16WNdfRd1hh8WT0ut90j5Fl0sjndpOJWez?=
	=?iso-8859-15?Q?6fa8MDqAeKz0s+jwO/DseenKPZclu6X5AD0prtcFp8GVRIWpUv+cE4gXF?=
	=?iso-8859-15?Q?GblEb04Ufkbhkcu340sj86415xIptUXXsLsS22fYVOTz3LPuJSMaYV936?=
	=?iso-8859-15?Q?FiCAmpFQike57PrVvyNVp/o2MSXug7fyt3a70GdWJ3K2Z+YLvypU+snz+?=
	=?iso-8859-15?Q?MwqY+7DOpDDRBbLjoMv1nSeIJ5rj7h9R3Jjh6ZNWhTbU9Fyh4aEUmnFtG?=
	=?iso-8859-15?Q?YZhlfYpsRSBpm9sGazTSA8Kbo3AxwTf0VbsMtlZaJWGDMTv/RLvyonrhQ?=
	=?iso-8859-15?Q?uiH/dZbPRfG2PtkBItX15/9FIEy7uRTT/8q7YpOIIXtQztCh1dVc8F/5d?=
	=?iso-8859-15?Q?TQPY+jnJdS448LJVab+LyfJbUl4bgIOszZzySCljSO+JFanXnxMD4+YSm?=
	=?iso-8859-15?Q?xINM80jcQMC6y40A/92P0mY6+ivc8wgNEmgWhfZkbUKsydbFoa2xEipzX?=
	=?iso-8859-15?Q?MzEyMBfOn4dQOGW0FgLBW5sLIHOBGGUyI+szFJOfgORQ8/3kx4s34Cf37?=
	=?iso-8859-15?Q?IjblDUv2rqiSS0UPZQrD0RRl2F5fMuIUXp+hk7IN05q51LZmxMVPNNrHS?=
	=?iso-8859-15?Q?aXx97X+H7qpaI5iMAjaf3ot6S6gXRVnvXsIgp9Gh5qrvHLmxfyca7G2US?=
	=?iso-8859-15?Q?97pz/eGncSHtsRnrQF6Z4HTfuk7xxmhF7c93Q2FvXxindlfqJAL8/4vp3?=
	=?iso-8859-15?Q?hsZ5dQ2noyJy+t50/1pPZM68bBlVOJjBfmWGX8npv9gdHpVkaNaFeu0m2?=
	=?iso-8859-15?Q?QXTuIaXcxRlH6Qp3nJJOZAOIxgvLnnTbaVBJ/m+kC6GRtX0=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee6e46d-fef1-4405-fb61-08d99fe0ecbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 22:17:44.2604 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WGECxJZ1BrIZykeIiNApbSm5vO+XPGuGAeWoGVxh09uPQKnJzCP2xYbr9e8mnnrPXEUQG/DB6r0IjhaYBNbSXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6266
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4MHrau032506
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 7/7] multipathd: Remove dependency on
 systemd-udev-settle.service
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
Content-ID: <A7C50E21B52ECF489A6D3F7FE23A8CEC@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> multipathd can now handle starting up with incompletely initialized
> paths, so it no longer needs to wait for the device Coldplug to
> complete. However multipathd may need to write to /etc (for the wwids
> and bindings files), so in needs to wait for the root filesystem to
> be remounted read/write before starting.

Side note: This reminds me of the fact that daemons writing to /etc are
deprecated these days. One day we should move the default location of
the bindings file to /var/lib/multipath or the like.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

