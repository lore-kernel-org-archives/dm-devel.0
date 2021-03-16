Return-Path: <SRS0=mox9=IO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B06C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 03:28:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5EC1C64F40
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 03:28:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EC1C64F40
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-OvwYvNOkMzWNabz_6XhmCg-1; Mon, 15 Mar 2021 23:28:46 -0400
X-MC-Unique: OvwYvNOkMzWNabz_6XhmCg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AE4D3B7C;
	Tue, 16 Mar 2021 03:28:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B69226A038;
	Tue, 16 Mar 2021 03:28:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5CCAF57DC1;
	Tue, 16 Mar 2021 03:28:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12G3Sc1g004352 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Mar 2021 23:28:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 32CEB568F1; Tue, 16 Mar 2021 03:28:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AF1463799
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 03:28:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A555D811E93
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 03:28:35 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-483-8dXgVYzTOdynyDx46D1YAQ-1; Mon, 15 Mar 2021 23:28:31 -0400
X-MC-Unique: 8dXgVYzTOdynyDx46D1YAQ-1
IronPort-SDR: 9EMduOO6OPjR74EfRZTpPAqS550guTfvSpYzR/qfqh19qO6Q4rMpA6JeUNzw90Mf88fjh9NtWr
	TXG1PBsAZhtzRSGlQ5x+9+TAsXstgGIfxGkZTQnADMXGh7qGQRC2SNljvKr+FaJMr0+N+1Tnnl
	jmA5LAEmnEV0Hm/6LDCskn7011VN9K5k49rpAXFx6dJZqbvpryunu0BDmtIIFF9hQskwcn29l/
	fk/QaPNiCVDVOiOLfATG6pqVPNTrxQj6mgfmy0qj7jX8B/pBQO6MtAy5Aj8UKex6fehMd5P1Wy
	QVI=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; d="scan'208";a="266605817"
Received: from mail-mw2nam12lp2049.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.49])
	by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 11:26:28 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB5333.namprd04.prod.outlook.com (2603:10b6:a03:c2::27)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32;
	Tue, 16 Mar 2021 03:26:25 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::c897:a1f8:197a:706b]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3933.032;
	Tue, 16 Mar 2021 03:26:24 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [RFC PATCH 01/11] block: add helper of blk_queue_poll
Thread-Index: AQHXGhMMI3cXeBzoIUOBWmHIqtHowg==
Date: Tue, 16 Mar 2021 03:26:24 +0000
Message-ID: <BYAPR04MB49657BD04960EA2C63ACF4A6866B9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210316031523.864506-1-ming.lei@redhat.com>
	<20210316031523.864506-2-ming.lei@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 69e2ca13-5439-41cd-5ea6-08d8e82b4730
x-ms-traffictypediagnostic: BYAPR04MB5333:
x-microsoft-antispam-prvs: <BYAPR04MB53338B035384CFEDF0AABCC8866B9@BYAPR04MB5333.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:669
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: aloSD8vFkdniZp6I/LQCofV1gTEEOC3y5oneysx/3fZ3u0H18TpQEThLl232i73PSJHYqI28pTv9BqmGAGYHFTI94duXORq01EBjjnyIOevJ03HlTPbt+J3dn6vcVwtQbfvr9jbtVMR0HpgiIqBGsKGCsyVAAWqxdhr5SbdwCKkvPQi835vqk6tE+81mZD5Zp45dZKaDdL70cereLKm9D1LoVdl7I66brhMtwEtuaXEsZPh9kFHrZHdZC2OSRA6mtpYMnOxbXRT+dKMsKxjWl5LPompBW83Sryl4LONKUWfF6Od4Cc23T2xk8kae5PURprDTGXLH/xj/f8smEMLHPI7/tc+uKIpWLz6FRLnrdozwbE76k5tFKfT+grIVyf2+NNqoMcnnBniA3JlZVQqMSdgYFaQ9WjbZ6TTVs/YtW8AjH/MsXpdxrNHEz8d3aM+urJ3Yb9Le0y6Y2sTThR5QEAABSPl725JJp73l0ropRtzcxAYg+lyYr+iHPibTyRFK6Knoclo6W/w2h4LIQeIUQteLfZwCs1pNB5JcSwHFK+Nsbjxe5sni7BeP3PChMv9x
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(91956017)(66556008)(53546011)(66476007)(66446008)(33656002)(64756008)(66946007)(76116006)(26005)(110136005)(316002)(6506007)(558084003)(4326008)(71200400001)(5660300002)(186003)(54906003)(86362001)(8936002)(7696005)(55016002)(8676002)(2906002)(9686003)(478600001)(52536014);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2g9lpXD1lsk9lGkAJJRNTm1St/lIPS2HmKuICAkZuWWgdv03LvsXK9Jk1n6P?=
	=?us-ascii?Q?yNP8Hc9+GH/MbU5X53Px/U2dpghuPiTAhY2GJ2noka9RFfeltCxaqsdFP5A+?=
	=?us-ascii?Q?SP1U3tGUtO4id+bWQLb+IpThl2THCRpSzxyyxuFxVrC+vs4Pgx7smpTa6r4x?=
	=?us-ascii?Q?qXskcT8W4IBphTGx5Hir5Xc+SA6J2sd2XmpJd9mZn/dE/6+zM5cADLb1S+9E?=
	=?us-ascii?Q?VBkij5ornVya6UXLRF3qBJ+SPtr6WILlsU2juPfw+BmevfYnWjkbhUGOPA+z?=
	=?us-ascii?Q?4kB2m+KTxEWAt8ipQ3kExm356Rm/hArIYO2PfojbR+QDZ+3cXDZyHGesMDv4?=
	=?us-ascii?Q?sIf/M30yp2NoNILUQ7SosD10OljzsrluckXZxfwc5n6T+D9qWxikt4jCwOJf?=
	=?us-ascii?Q?eGJXGTNmfrqbuKQ16QXqYLvgeaVNPKWrtHqJYlie9QldXFHVhKDW99YkoP4j?=
	=?us-ascii?Q?YVOJeDJQMKUyKpZoazb7XhgzrWPeJUSYI2LCkVVZvbjYo9g0/i2y3E0Z5Sju?=
	=?us-ascii?Q?S4kVNuaG1wtitqVQiSnYGmnpktOyYfbj0PSlnWAYoHLpbqvA4zrEURNLxOmc?=
	=?us-ascii?Q?D9c/7zRmTeEx6JpEb/1IIVGC8O7BJAznqTf7t60mpE41qntNFNFxEW4anYon?=
	=?us-ascii?Q?pSPFUuTN5Ppu0jbp1hIOJh3ErP+TjVkzRtbiE00mKv8Kf7YSj2+EM1En5Bas?=
	=?us-ascii?Q?YBVWHI2yyHnBOT3UepOiAL0iVMtIKALZZ+3c7wUaz10O8eewey1XiWj8BU18?=
	=?us-ascii?Q?/qgZVJUFmuo3HUQST+TKBtccVy+7tlIX/lDzjWkhVzqrtLkl/vbLvTjg9i5M?=
	=?us-ascii?Q?GIAkPnwc3u7Fmy0RSt2pVZL25XRyuZdfiRwsRw8hB93WgVDhKsWatvDlKf9s?=
	=?us-ascii?Q?FXV7qA6MWYHL+wdlSPZGGetZhirttjTU63XUM+3GFiozKw62J+78b1eUH//x?=
	=?us-ascii?Q?Y8aOWUeRlV0EEoL+z9f7LbprBQwIRybVeOC6PZwViVGPq5H1HEMV8DFKxZSH?=
	=?us-ascii?Q?aG3UxhovzXnp0Cp724rBZi8v+5O/fUPeGXnPr3MXo+qHVfvETvnKgFAiurwM?=
	=?us-ascii?Q?64YrU3I5pcuJo+yVCU/mXXtKFhEPTjHvrrHypogq+4ELoiQUt94RjkKIX1Cg?=
	=?us-ascii?Q?v9hRsonJwPkcrEm7EeIDhW1cZhxvhtZCowjK2AqO/CGuERbrLrn69dO/VCBv?=
	=?us-ascii?Q?yD2EQ9jdL5oI4TfnfA/PnT8Us4Qm+t+gDLCv4GjaDVxw7ws5Vr19YJ0nszPj?=
	=?us-ascii?Q?94B1XOnjwc0cIccBoG1EB2UqVUZEh52XB2IrKM4OciUHh+FWxAoDKJO4LFNX?=
	=?us-ascii?Q?DlzkqNsomAepHCZZeVMsSKio?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e2ca13-5439-41cd-5ea6-08d8e82b4730
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 03:26:24.7018 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qA44kAFMh6+GowQdIqkJTgrTPas8G7uRa38evEQugvXxV6e4vTsPUiNiqfSO7unsTqSdJJoVTgoTAEsfk83c669Ji8jcyh7kkFupYSKUTPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5333
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12G3Sc1g004352
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>, Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH 01/11] block: add helper of blk_queue_poll
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 3/15/21 20:18, Ming Lei wrote:
> There has been 3 users, and will be more, so add one such helper.
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

This looks good to me irrespective of RFC.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

