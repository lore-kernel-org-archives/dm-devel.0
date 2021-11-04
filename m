Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60BBC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:20:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 360ED6120F
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:20:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 360ED6120F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596-fgFp5UumNiy-7dYw15qsNw-1; Thu, 04 Nov 2021 17:20:33 -0400
X-MC-Unique: fgFp5UumNiy-7dYw15qsNw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13ACE1808304;
	Thu,  4 Nov 2021 21:20:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E498460C17;
	Thu,  4 Nov 2021 21:20:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B63EF4E58F;
	Thu,  4 Nov 2021 21:20:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4LKPbU026256 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 17:20:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C6C4040D1B9E; Thu,  4 Nov 2021 21:20:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFFF740C1252
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 21:20:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6CF1899EC0
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 21:20:25 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-287--1AYSi_VNNynlTdHrfSY6w-1;
	Thu, 04 Nov 2021 17:20:24 -0400
X-MC-Unique: -1AYSi_VNNynlTdHrfSY6w-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-28-cjNqZAAbMYGF0wAxj9vhhg-1; Thu, 04 Nov 2021 22:20:22 +0100
X-MC-Unique: cjNqZAAbMYGF0wAxj9vhhg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR04MB3111.eurprd04.prod.outlook.com (2603:10a6:6:7::12) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4649.19; Thu, 4 Nov 2021 21:20:21 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 21:20:21 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/7] libmultipath: skip unneeded steps to get path name
Thread-Index: AQHXxebdkewmTD/zlEaoP6xyJ4Kcn6vz97wA
Date: Thu, 4 Nov 2021 21:20:20 +0000
Message-ID: <bb5ce0f4ddd6b829a9abd52211be14180ac8408c.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c45b203-174a-4b8d-25ea-08d99fd8e871
x-ms-traffictypediagnostic: DB6PR04MB3111:
x-microsoft-antispam-prvs: <DB6PR04MB3111445D8411CF01B0D15CECFC8D9@DB6PR04MB3111.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Tt7qYlWGAtjwZZ8s3hgBaL+V0XhfaZrxFP3aYbIHBbL7nolGKqpHbjltoodODxfUtlGRozlx+pBM3HUxARnUuSgwH0eSwQDUsEhVJ04dIIKyG5gv3ycx7PDlrCtKMEvvgIgYBcaEiOT8TWoydRFN2SHTxVJ0+mCwn2lSBpzDcpf+gwU68ZovtOMqX7nmpDCsGDukkmYL/fXRlcK1r4kolMsUCRW1tZET26Zom+Vh0+pihDbdmlVd8Ys/y+pRob7aKSD1r5zzWsXSloOJN7DQYnexp4LmnD/O6MH9Kjkt+bLf5acVeIHVKmyjP3DTuN4O9QpUZQQizIp2ZV8FcDl2vqVNgUHodI7jZUjhxVgOWRmSRPVp+orcDkdWsNrGNCwK1PWQHM+oWZiG00yyKwO11Rh1coSi3JusmDzEb9lchi75Y6M1AP3jEh339cUCprEb/FmBr5e+lAlfbzzBa0zndJUMMbWTyR00i5WGjN06y3I8XHoknn6fU7lYe5Z7j1nYx7LmuSzK4JzokuOIokYYkMturi1lGEnUeGoQvLgk2y7J/mJ+EliflnRWPj8LiriJXZjWAA07wF1fIXEIfiRhN7wrHfMPU7qRxZdme9x1gF3nFNy5Q/+AzNXHvH3TsRv38Wml1lxp4oWy/qsS9ZPlUncgDYl3FzXoIpheDZ3w4WQkbHoBXkU3R98snX8rt7jVOd/rAJ5M4tOITlDLNsLi/w==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8676002)(64756008)(110136005)(86362001)(66446008)(508600001)(66556008)(6486002)(66476007)(6512007)(66946007)(71200400001)(186003)(5660300002)(26005)(558084003)(2616005)(316002)(91956017)(76116006)(4326008)(6506007)(44832011)(8936002)(38100700002)(4001150100001)(38070700005)(122000001)(36756003)(2906002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?8MTqA7LLFg5QLdWNu55bLVgjhjMEGA2v64NIGaoI/mB6faPhOzmSWBYP4?=
	=?iso-8859-15?Q?obxk4IxB6PfQEQg+DASxrK6LkluxJmcBp2E8cLVk6HJxnYwYkp0Rs3QzJ?=
	=?iso-8859-15?Q?aQFIN8pnBf+pllsfa5s9uLxZzpmVgx2iwGg6zAwD7VW3XIiYJlQefpmTw?=
	=?iso-8859-15?Q?jSWQjw61ze5zd37ZqEOlxBlZuRW40vDdynv4NgEC0i81Y7uILx465cAhG?=
	=?iso-8859-15?Q?5St7X/sthcpzxhx0S4igaG+oL0N5/QHT1IwfltdXsmPzieyriyHX5kDlB?=
	=?iso-8859-15?Q?Rt3A0Hy4aihiVoehZyrNwIM9srsOrfNI7o0+Nd4gB1F3uWGRa0ROdLRLM?=
	=?iso-8859-15?Q?wZRXRsADg9ZZUT2uHHWbH88kDOwRMm2OWP/uzr/hyKciWQ8Ug/5vc2dZF?=
	=?iso-8859-15?Q?SG0V99zj724/mwP27CET+XLClWXlHHVu023/uF1qjj8arIDuyle0mc4U1?=
	=?iso-8859-15?Q?aQwhVLcNwzqoB+i0Rs8HnGCHMj5WY+iDhTaRsAm689jLIoYBtKlcG6dgg?=
	=?iso-8859-15?Q?EWFA+MV9PYlvwwOYdlmdIbybTshHrv28ls3ULVqW6YmfFU6JaMOhdzzq2?=
	=?iso-8859-15?Q?reVNd9G80595aAcW002NVENqzSp0J0AyKcH9+hzVFcz+23wPtuPypH9VQ?=
	=?iso-8859-15?Q?fYa1tQvgcYmtpCz6WOkhzWOhA2abk79LStgh+Bz4hREJZVBHHjUhrCDR+?=
	=?iso-8859-15?Q?7A1GWV52WdcLMpzHwugvR+YZI7bHYS8k1zIaPyHD2/Daa/tPkIeWNN2gQ?=
	=?iso-8859-15?Q?ReUdjksvCzQq+aULH2zy/M8cZ4uQRLGfFaQIJ84D74whDkOoyxD2wHp4O?=
	=?iso-8859-15?Q?hYjSFbofisrqGxzl3sh/HXdSeH8BY4ridHyLZPI+6l2T5TJgQSXmjN9Me?=
	=?iso-8859-15?Q?Z/GqOJgvJqPqeuGoYTD/jW6GGn+7JN5U4DRj/6bLLHpQifYmpLWKIw4gB?=
	=?iso-8859-15?Q?l5BS7dEnQDLFWH94hdgMmw+SUVbeH6InTAwN3MCy9CY0aM9Rkgn3flmvP?=
	=?iso-8859-15?Q?W6/OZVvYseXz9bIBppKHPA3P1L9ciAX64ijnu+29wYob+sjEprWVIc7im?=
	=?iso-8859-15?Q?jBMmKn9vCdYYJm7FZ08c0Tssh4JU595I4x0AKLE5nAm7ahLh/RL7nrth5?=
	=?iso-8859-15?Q?0IQea17h6YWGXWtVGKV4eqYj7pjPwSE0Tn/3V3pJyM39lBUbGJJP5z5Ub?=
	=?iso-8859-15?Q?572QEbg+M/x7K/s90s07lvih0DDFx5Luv+N6cqY0O16p5CjhHwlpDZebR?=
	=?iso-8859-15?Q?tsE+T9s7Xx4TOrqiOLBLEnvIXxVLtGSxd/1YkyAEvVuuXfKaTJ2lC5+tg?=
	=?iso-8859-15?Q?oindwrEMX5viFy8Uyg2I5uWxE/nJtE56k7oC7MY7KipTTzkmdB3uxBeOX?=
	=?iso-8859-15?Q?+HXMMWt88Z2Qw9UOmwHy+li6ldaLC3JVuhKHpMmgkA6cjB+3iuTWO2v0R?=
	=?iso-8859-15?Q?1pVDfrbhYH6SK//jKRgHoD4oLJBY+Rrz+uTNGek6AHEKzQgHGq6Mzn8vH?=
	=?iso-8859-15?Q?qhlY5oKlyW6T2TQ8nXrVBDSUUBOo+UH5I7w8poI0de00IQH/xG/C6zhjw?=
	=?iso-8859-15?Q?hoe33oIeSBGwkERfsJKlzRje2FDwxk7OW1vHNJHDeRgrJvO5NOWuGfGCL?=
	=?iso-8859-15?Q?vQ8Eke2jZusf1h3ledZusHEf+biAq5kmDYhjU8MAo05a92hD0cemf93V9?=
	=?iso-8859-15?Q?eY2x7ugTA8+VF9R8T6+6lF9ydBLsSY1OJry6SXy5+NkIqnc=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c45b203-174a-4b8d-25ea-08d99fd8e871
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 21:20:20.9458 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lDaIINqXocV3y36AO5kcPvRwI2h7Y46huNQp2vCwx95qyknCzWsY01GUDYe1BAXpFf6ybAEkXfdSwajD0b21PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3111
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4LKPbU026256
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/7] libmultipath: skip unneeded steps to get
	path name
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D028FE82ADE593458ACA09E6E4D9A16F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> The path already must have a udev device at this point, so it just
> needs to copy the sysname from it.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

