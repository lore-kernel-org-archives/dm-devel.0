Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F41B4C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:29:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 816CF6124F
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 816CF6124F
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-XkrdA197OhiZRxGw8yYKSw-1; Thu, 04 Nov 2021 17:28:59 -0400
X-MC-Unique: XkrdA197OhiZRxGw8yYKSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D66B119253C6;
	Thu,  4 Nov 2021 21:28:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8628118351;
	Thu,  4 Nov 2021 21:28:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 282BD4E9F5;
	Thu,  4 Nov 2021 21:28:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4LROIe026799 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 17:27:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3573B400F3C6; Thu,  4 Nov 2021 21:27:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 307DF401A993
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 21:27:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 190FE811E7F
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 21:27:24 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-436-keXbp8-WMDiAXMIYzYHr8g-1;
	Thu, 04 Nov 2021 17:27:22 -0400
X-MC-Unique: keXbp8-WMDiAXMIYzYHr8g-1
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
	(mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-15-yHlzyoKwNfaz_TD5t20vmQ-1; Thu, 04 Nov 2021 22:27:20 +0100
X-MC-Unique: yHlzyoKwNfaz_TD5t20vmQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5579.eurprd04.prod.outlook.com (2603:10a6:10:80::32) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15;
	Thu, 4 Nov 2021 21:27:18 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 21:27:18 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/7] libmultipath: don't use fallback wwid in
	update_pathvec_from_dm
Thread-Index: AQHXxebdy0QOjX6d8kS7JaDRRs1/+avz+a8A
Date: Thu, 4 Nov 2021 21:27:18 +0000
Message-ID: <3c684fa27c44626cb3c2e94f28120a9aaba365c2.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e73a3ff9-bdff-4e65-30e3-08d99fd9e153
x-ms-traffictypediagnostic: DB7PR04MB5579:
x-microsoft-antispam-prvs: <DB7PR04MB557959E3C99351013D30D6E1FC8D9@DB7PR04MB5579.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: avQi0hVYkv6V0aQwCNNxGB7SKrO/ItGJSyFc56RUDnbFnNw/AdZcmX3I9hAAxs4kAR3Mo8gxQocwQ3a0xn6QpqCNEhPY+e04aSwL/krbMnhaMpBNL+pLyAyFLrcEFKaoYyOK7KKasJn3Bbx40HpuWBPQ0jj3pbCD8g9cNjNWJMTzxmKSVtgjMRmWHUx3cNNtfmPiO+JxV0RkX4vqlv91622wUvYwIrRwNAlqfJ/5q03vNGEZu05mvFChuY/1259oCXUvlKKZYFF4de9vFkkqNF0tKSd2I6OL9OpTBmBAgLSv54L7bXfgCRCh8AekuSVdtrCzyTSvFs2fwvMwRQ8TYTfa7iFM66GdzNU01eAdE6deHyiaAi8CpvEnJRWIm5XxOsKaaV/FHchj2FV+AR4E1g9lSVJQeRBozCzfCkskJVaHnbkRuPA3GhY8p2pJ5FQ54KAEg25xTv3CQt8fsWEnwBSdzTqVodCyVoQ3QgHQdFl2ApkfoUajJJDUQdWS8zJ4zXF2wn8oDJSi8FdmRLiqNHJIPmaJ5s0c5sAgW0ZA360ngWYVGDmULOB7yW8AR1YmF0N7y4RYXXES/QLRjKycEW/4qfkB/BIyfdzLRwxyrJC7VJSsj1IONrfSFdL0TYB8oPWnkVQKp65CH97BR86+06pPzZDy4mG+6qhkApWsoKOxSo5uZTqIikSc/njwRcTRk/T2EvxMu5jAVloVixtUkw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(8936002)(6506007)(8676002)(2616005)(6486002)(26005)(186003)(110136005)(316002)(2906002)(6512007)(15650500001)(4001150100001)(4326008)(71200400001)(5660300002)(508600001)(44832011)(4744005)(122000001)(83380400001)(38100700002)(66556008)(64756008)(66946007)(76116006)(66446008)(66476007)(86362001)(38070700005)(36756003)(91956017);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?KHjpTEjivF8wfJ0zCuTD/SnoS08tBA4DdY/Dnj4sXUg7UPAreM86n2V5o?=
	=?iso-8859-15?Q?sTO0s4K9y3DiE26kYltSkEUrxsnQBd5Bf90tWxR0Bm0urDHTx5iwHjBfk?=
	=?iso-8859-15?Q?62GI4b/N8az65n+KaVtzCQ3A9Z3aT3xh3IofjkifHyIueH6byvDTu4nqT?=
	=?iso-8859-15?Q?WfOgfBHIhsDSZng4c5hSyECmeRx4eWd3LKxfZGMaqcr6ZJny59x4TxD3c?=
	=?iso-8859-15?Q?kKJv+wNlrPaUJfjxcebZ8e0RUP3K4U1oCHJiUOBhKq9GCv9o+qulSHVxB?=
	=?iso-8859-15?Q?95fdIwb0aqsldfvp+IFstzOJv5XgvjXJibaQuTu6+woFeOfK90MY3XPnE?=
	=?iso-8859-15?Q?M7A5Mdf6CJEAwQZ5KkIGektUiOyREqVDmuY5d/CAYTg4HO0X5soVyLuie?=
	=?iso-8859-15?Q?t2ogVF3ylltoJ1k2SYG+n4PZlpLIDbenGjzkF/l1EoVjB5GzW5jLejDq8?=
	=?iso-8859-15?Q?PNoLtz62c9DRLzEX+lONL/Jogv6I9KUpEikZWVEwxHDNvaznze+MTLZyc?=
	=?iso-8859-15?Q?V53nPNQykGQ8JRUoMa6MPfbUS564eIXbg2LAIh3ppFQh5UKWQ0U/1tSgQ?=
	=?iso-8859-15?Q?ohGy/+9cNRnQmTFf/PF1+Xp0XZ+AqIgJsnzwEzWUoByCkXnbyBogldtkj?=
	=?iso-8859-15?Q?lPuOErMlQ4nKouaeSAZFFi6YTJQFuNCLwW3l4akwL0utNPtJ4oPAKdxUQ?=
	=?iso-8859-15?Q?YqE//xXHCNrS7oVIBBNRRJ+JrCK/FygEj4WNUqo9IN8DpUL02XrQ1J4sT?=
	=?iso-8859-15?Q?5MkFCNtPSQqb/uN7j39jMguc+gldvfIS6WPkNSTanJw6HoW/X0SKFUz0M?=
	=?iso-8859-15?Q?1CE+hPbjnisgPp8pXVa3QExCNHvoEn5ZiA51r7M6rDqdHZJwvWUeg5ziU?=
	=?iso-8859-15?Q?tGJ3XLA3rmM/s8ODG/dEb7mpvQ5Rh9bkQDx8e4LDpDLpUXakoox+4rmXc?=
	=?iso-8859-15?Q?HqYh8YppXJ2SsyXVXXzJFmpN/WWN+b7gIKDVr+35wYtZybkeD4orYtPuc?=
	=?iso-8859-15?Q?Y1YUoIhLrwSK8mJaRAj9BJ4Jhy2kFxo2wRy2GgSXbK4zcnjlL3sJA/mO1?=
	=?iso-8859-15?Q?0diMSeurFRv5s3zfYX7x/j5JwYpH4YDSY61ci9rLczlz7F6sEMElgGK6z?=
	=?iso-8859-15?Q?n6MH1EP9mO8ZOVRRXVhWEq2xn6Rda6EqJiuRXpwGHsiD45G48QNTW6Nyu?=
	=?iso-8859-15?Q?TK4kIGmJwYzu9aaH5GlkpeyYwS42PuHPtHAZM3Z5sP/C/o3Z/F+Llz/rN?=
	=?iso-8859-15?Q?Mq4vnuu4MpfCu5q+XI/XCrVFFSY2zJ0MONomtWlVrtTa3xkqHxpiTa7PE?=
	=?iso-8859-15?Q?3iSxnPFUD7Y92gSuKEANTZj9bWCWhfgBy6Oa8FgRcpH8QSLVE0AYbC+Xf?=
	=?iso-8859-15?Q?wu1y70RmMjxEMzZFFxAGeZ1APmGsm69oyyS9VeS1rEVnUxTwsYCjOCnhR?=
	=?iso-8859-15?Q?jf3wXvNdByzzT41kEv/cYRkziRmu46wYjQDZixLQiUI8PruoThl7FKQqX?=
	=?iso-8859-15?Q?gdzhz0Co74SEvWIhSVedJb5F4IbGOHrTFpyXuF8lh6fxVKviKrSZQjE3P?=
	=?iso-8859-15?Q?aJbnDQFBF/Y8cV2ueedQtm95oLYbkkOL3XcZT+yMqRAHWhvf2S/C73PRU?=
	=?iso-8859-15?Q?emHGzr6SvZlCypXFLm3zU+F5Fa1NpaPljCBs9nrHzuiEKFYgh7EzCYgBK?=
	=?iso-8859-15?Q?NFudDuQlNPU1zmzUhgjGJE9Ys1FoDGlzsljKdlH3kfSlroI=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e73a3ff9-bdff-4e65-30e3-08d99fd9e153
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 21:27:18.5191 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MpQKys9i5j1vZaDgGMVYX2jYq0OQ13uq6OsOWkHo2DB0Vwnar4QEQVhuC7UflY0gtz5G6nDt8sMLUiAGo1qJnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5579
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4LROIe026799
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/7] libmultipath: don't use fallback wwid in
 update_pathvec_from_dm
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <DE7C93F81B0BC445AD06EF81AD0C0E60@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> When new paths are added in update_pathvec_from_dm(). If they can't
> get
> their regular wwid, they shouldn't try the getting the fallback wwid,
> and should just copy the wwid of the multipath device.
> 
> Signed-off-by: Benjamin Marzinski <marzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

