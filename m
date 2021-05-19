Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75467C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:17:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F1F6C61040
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 07:17:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1F6C61040
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-mdJl1C9INd6-4aPNDTQROA-1; Wed, 19 May 2021 03:17:30 -0400
X-MC-Unique: mdJl1C9INd6-4aPNDTQROA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0D00802938;
	Wed, 19 May 2021 07:17:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6374F77708;
	Wed, 19 May 2021 07:17:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB9CA1800FFC;
	Wed, 19 May 2021 07:17:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J7HGUn019755 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 03:17:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2FCDD100D8E; Wed, 19 May 2021 07:17:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2901C1032B2
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:17:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 825EB833942
	for <dm-devel@redhat.com>; Wed, 19 May 2021 07:17:13 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-287-f2VV2v_xPgOgX7rj3Wsqmw-1; Wed, 19 May 2021 03:17:09 -0400
X-MC-Unique: f2VV2v_xPgOgX7rj3Wsqmw-1
IronPort-SDR: TdLQDsuR4fWvcF+30WATnpaMfpEa+UR/jK+hWYW5RX0J73HZf6Ar48abIhYTVCDElwvDRCBHNd
	Bbsr8ZYz68A4tpznksBwxE/v5WN+lEPLi2vPQqhND0Zsgr5DHmssWwuFKvlHRHEvEJj04ZQAWw
	Y0d3wZUy24TE2T2wuoToGv+iXmlSaM4c5n89eo96znqGPOKAkA05fHSw6Uc/oYWRhMLN55CnPQ
	FCQEO31412aXn+Z9T5BwgcjKQP3G72uJ5ftkvIdHFE4fl9agGhDqTI97FnZRM+osw0J1BGlRy5
	GWA=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="272616563"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 15:17:17 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7509.namprd04.prod.outlook.com (2603:10b6:510:5b::24)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 19 May 2021 07:17:04 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4129.033;
	Wed, 19 May 2021 07:17:04 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>
Thread-Topic: [PATCH 02/11] block: introduce bio zone helpers
Thread-Index: AQHXTFqE+W22j926kUe9+IgAVyhqCQ==
Date: Wed, 19 May 2021 07:17:04 +0000
Message-ID: <PH0PR04MB7416EC127D2BB9639E82E1579B2B9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-3-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:152f:cc01:95b:718f:422f:1ec2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9d9b73e-7163-4fad-252a-08d91a961a94
x-ms-traffictypediagnostic: PH0PR04MB7509:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB75098138189633FA805F36E19B2B9@PH0PR04MB7509.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Z4J8BaFmWYu3s8dPTvNM9N4hSQ2QpGm1JBgb6oh42z8zb/2oGO2pNA8zU+fQPxXknDawWUPCBWW70ZO+0HZ3GS765TZskyvKfv5Q+aCMCS96rjusleynHnX5CpqVHHPYEqvDeh8mRkGZNonDz8s7wrCKTPsdgU9U1J8Nbb7ST1dPnu9QaUc1ePXGoj7tuLEFkPh92QeFJWFJ7F+23KcsQojc3+BMvO/JJNvy9reIbYwemhO6uGAv74Ce2SIMUbNkW3pEe8qNiqryKcExJcKME2Xu1fM6w5F8jPpgS3Pytn8TLJB1DGaIYV7HRLtKnZdY+sfLmkSNVLhqCJNR1dFAXLDkMxPy1SfvE/ctX36jepYgr301mz1TRln+u9R2aW4U37Wh3e6P8qRL9ouQqdvx631SC0mzjYhCEA6BBCMDo19ixEkYl0E0+5paUSd1CbaLkprN6ef+OhaoqcLqzM+MSsU9vtsl5xXYhcnfH6Vv09xtTNfyzl/t4nBkjPt21VipR22o1k//5oi3Vv1+X06eS69gLT+7/wXJSqeuXyqjoEbykhaDrMO0z1Q3I0UbkiOH74nt4H3nqKn0GwyPCn4LXne1qXTJSowYu+8rboTwN7c=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39850400004)(71200400001)(55016002)(66556008)(64756008)(91956017)(76116006)(52536014)(5660300002)(66476007)(66446008)(4744005)(66946007)(2906002)(33656002)(53546011)(38100700002)(122000001)(186003)(83380400001)(9686003)(86362001)(478600001)(316002)(6506007)(8676002)(8936002)(110136005)(7696005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CBNYk+fQTO1sFmNMEQwkCxSODFhkQzSU9RAcWN+y1qHkHUdO+zXYKAxND4nW?=
	=?us-ascii?Q?lAxtZGa2w/fEY588k+i0FzpzGHuhtvxKTBrlZqJzh2TEzkvVXkpdYBfdWPAL?=
	=?us-ascii?Q?SCjvfjEs+CE0a9XjByZjw0JAwscGWFisfssHSCS7KHHPXIctDxoy700OER1B?=
	=?us-ascii?Q?IDgUE+e1yGBUTAO5Zm9YYvtUOUv9AZUhNKD1U18b8LnokaPaoFVnRPQt95cG?=
	=?us-ascii?Q?80Dlx2aXK+Dwloe3Dp2FlabLO120jNiD+3iC2HnSKeZK9oI6sYTeCHphCSGb?=
	=?us-ascii?Q?Y0VdLR7Iv82gcNBJU7MGGs5N96ypfkEH89+PlXfWFlnrMug+U8LpbtCaIL2g?=
	=?us-ascii?Q?p0Vkz8bPJELtPrduwDKVWHRicxNXX48JLqt4XdKXhgBN3XaYhuFOOBZACVe0?=
	=?us-ascii?Q?ZGbAq/wI4bYq7p3RaIR1rqnHUAuyzkHseBHzyyPPbGIcb/C2eaHUgR7TFZvi?=
	=?us-ascii?Q?lr989svVi//Tc5+L3N7fjBBefcOSaDObqBdmi3akXiTzs6pjQ8ix/CqM/xSZ?=
	=?us-ascii?Q?UrfoY7CUXoD/c028UmYpF+6w9zsvem1dWxybmQyDcNSY0HCUPc+QodzmMnRa?=
	=?us-ascii?Q?m8Eu1k6/Fc5LJpAXhRa5cUJGfH+i8zxcIWWBM1CjQjTlzQXAGE5rsj0IdvN/?=
	=?us-ascii?Q?8cy3GCAAH85ygTPo/3TUYFCFXM0eYHI/oaqaCfAd8O1xEUfRDFwEiSoWYVyN?=
	=?us-ascii?Q?wdX74P1fbX5WgZgajKadV/VLdZjogJ/GjwdSSeuGyyp8zR+gO/N4K0RL8/we?=
	=?us-ascii?Q?gSYQOurZaM6Wjw8BDavlWGeajmZdqeRYfw4zvIlFOJozihzyxHrSP07V14E1?=
	=?us-ascii?Q?B59DuHbBXCLox7Lypoh8NibgyodACZsOqLNWvIuR6DGAHu1JnK3ocOk8bpyp?=
	=?us-ascii?Q?qLPKChY3zwJw+cw8kNwgxf2RoWhhPEtHToP3b7UG4LJeams9pItFIe5kQuEN?=
	=?us-ascii?Q?nKxz2tDFnYRs0bquKLWCaPzqLzhnUDcbq+Ol3FCgkPmk70TzWwRQs2Lurki6?=
	=?us-ascii?Q?vb/gcCIMXVM0jn0XL7Fxmnj2A6M79CJMPByAbRLyDFYoZNzImP/Qg0v1FOj7?=
	=?us-ascii?Q?jbDlq+9kkmIf/qLxTOs1Ft1Q14X3XSVnUuIi5IyRWLZnkJTvu/gr7RvKbipv?=
	=?us-ascii?Q?LkjOtu3sbKV7mJs+O/5yQSf4SN76jZ2UktASMoAavVvr2JlR/nI9NtFuVFkO?=
	=?us-ascii?Q?sAdSF3MM5B95B/VinVkXyjLWp2y6P5+g8SV373dk4LAf5y4OVVK8LxFflfmX?=
	=?us-ascii?Q?uiP07/eK/EtZOkFlO2WYdpxqCyxw1lC9inaKvYfoEWCHDbmi1QsLrfLxthHx?=
	=?us-ascii?Q?AjmArfuCMHPmeZYIdfXS4F0SrJfmJqSeeE+xAipqMApyeYgdSA76tN4WX5c3?=
	=?us-ascii?Q?m9xPB+HV8iSlgCqv3w9SjdBOw/gt?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d9b73e-7163-4fad-252a-08d91a961a94
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 07:17:04.1166 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EeB1jC//xTIL5RudprIh8l0PCEQpIOpFWLsTE7BVY1xJFYQ1dEKdFxlOxCpt31vyYJNwor8LK9yvcka3bROY1cY+gBOj2jB2IIxYUi4YYiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7509
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J7HGUn019755
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 02/11] block: introduce bio zone helpers
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

On 19/05/2021 04:56, Damien Le Moal wrote:
> +static inline unsigned int bio_zone_no(struct request_queue *q,
> +				       struct bio *bio)
> +{
> +	return blk_queue_zone_no(q, bio->bi_iter.bi_sector);
> +}
> +
> +static inline unsigned int bio_zone_is_seq(struct request_queue *q,
> +					   struct bio *bio)
> +{
> +	return blk_queue_zone_is_seq(q, bio->bi_iter.bi_sector);
> +}
> +

Can't we derive the queue from the bio via bio->bi_bdev->bd_disk->queue
or would this be too much pointer chasing for a small helper like this?



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

