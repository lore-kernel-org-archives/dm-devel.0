Return-Path: <SRS0=z9VQ=KX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8BE5C47087
	for <dm-devel@archiver.kernel.org>; Fri, 28 May 2021 08:38:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 47588613DD
	for <dm-devel@archiver.kernel.org>; Fri, 28 May 2021 08:38:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47588613DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-EEwItdKyPNebfVmfwBjL1g-1; Fri, 28 May 2021 04:38:47 -0400
X-MC-Unique: EEwItdKyPNebfVmfwBjL1g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE8F41007476;
	Fri, 28 May 2021 08:38:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C33D46A857;
	Fri, 28 May 2021 08:38:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73FBF89DA;
	Fri, 28 May 2021 08:38:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14S8cAiQ009629 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 May 2021 04:38:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9AA6E167EC0; Fri, 28 May 2021 08:38:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 953D1167ED2
	for <dm-devel@redhat.com>; Fri, 28 May 2021 08:38:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A1BD101A531
	for <dm-devel@redhat.com>; Fri, 28 May 2021 08:38:08 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-399-p5TpOKYTMYes-mLg__e51w-1; Fri, 28 May 2021 04:38:05 -0400
X-MC-Unique: p5TpOKYTMYes-mLg__e51w-1
IronPort-SDR: JHuCMYD570B9fCT6/wEAF4XM2getcSfmBXwLakS4HEEOK+pkUdiojULImBiqORnEB9ZR9hi52K
	47RVno/vtOobTLRORzb50KpllVA+n2l6gRJyxYqkHBT/gzFMmUTwdfkcLwVAuZG28gp/OyPUrb
	pvphsg3WkQuQpCxyzuWPabcvJnmSKsJovW1+c2KJ3p8ygGa2DdQZqz4Un+xsilrpLM4KAFB0SY
	25bcE2HzXgjr0ngE64OHHC4w6pBrXXiv2ZOSBzRPsoPjjYosdhDMZmtNy5jWLiAIIjqep4TCK0
	gFw=
X-IronPort-AV: E=Sophos;i="5.83,229,1616428800"; d="scan'208";a="273698711"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO
	NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
	by ob1.hgst.iphmx.com with ESMTP; 28 May 2021 16:38:17 +0800
Received: from CH2PR04MB7078.namprd04.prod.outlook.com (2603:10b6:610:98::9)
	by CH2PR04MB6743.namprd04.prod.outlook.com (2603:10b6:610:9f::12) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21;
	Fri, 28 May 2021 08:38:03 +0000
Received: from CH2PR04MB7078.namprd04.prod.outlook.com
	([fe80::4506:831d:3073:8a57]) by
	CH2PR04MB7078.namprd04.prod.outlook.com
	([fe80::4506:831d:3073:8a57%9]) with mapi id 15.20.4173.024;
	Fri, 28 May 2021 08:38:02 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer
	<snitzer@redhat.com>
Thread-Topic: [PATCH] dm zoned: check zone capacity
Thread-Index: AQHXTE36fevL6E56306mTE5k3mxbJA==
Date: Fri, 28 May 2021 08:38:02 +0000
Message-ID: <CH2PR04MB70784050C2C2EA69F2AD3295E7229@CH2PR04MB7078.namprd04.prod.outlook.com>
References: <20210519012616.664047-1-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:4140:5e35:28b2:297]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a130445e-8be4-4890-cadf-08d921b3e848
x-ms-traffictypediagnostic: CH2PR04MB6743:
x-microsoft-antispam-prvs: <CH2PR04MB67435B7327CC229424B726A4E7229@CH2PR04MB6743.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wuHe/yGLKodLyXoIxdIW8+ej1BdCcAP8fxjhhQoPByxX54QonjspgD6huIEOAOam0PGWnbkDod4CYelJtLYL13c+A0xDZenc8vGOkVn/msZzFLLkNhPIZ20QejB36f3OZm2Kp7noSytg6csmBcAge64BYSv0PppJ3TsuCBJTwOZBguDp89wOPTUC2gJBqZvbns9xUM9T61C7fkpNWYBVKZNTKNyupiJH897nMVhPOnvI1uYEaaygXSgEyJU80mHbnOSwK1YltHjYk2Zv1JO+Fp3hyZkg8jl3PCiZ9LQT15FC2qsnX65OjpaaK1xpfi7y3NweJlRd4BxLmGHDX10kArz+EvMCGAB67GQQV8q0T5XNJ4zeTRoTLpRIUkDf5x5W0fxahK/LRzz8zEgaqTs20t/LQOHZJeNerQng9Nae1bRZtJwMKKAvPJlFzVtfar0MTEBib2CQPL6U2fQjVUuJkqvwgtmQlrhjcX6u1BxVHzIVht58Xl7ac3cIRzhpWYXLU4KaLSfqTPS/H3XuknvmM/ID12j3pfm8lQJrO4DfL2OzaZm5J2hvFBC5Xm4ekTVGmM+wdf+/oMZC6i8LUMYC769lxKARoMgRaO+HwbTkBac=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:CH2PR04MB7078.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(71200400001)(9686003)(6506007)(2906002)(33656002)(122000001)(478600001)(186003)(53546011)(38100700002)(83380400001)(450100002)(316002)(55016002)(52536014)(110136005)(66476007)(5660300002)(66556008)(64756008)(8676002)(86362001)(66946007)(76116006)(91956017)(66446008)(8936002)(7696005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?PGDFM4drRG6MeF0uzAHS3svi8E23u+4WXSm3TvJ5ZrthHBsr3vQdlqnP+cnz?=
	=?us-ascii?Q?hHRk0aeHpLRxUFBl/dr34H1l6aOw3Em3O0bNVOUfpjbIfm/csxV3lU9diFSC?=
	=?us-ascii?Q?mqIJI6DCjtg7UaxLg8Dba5GErblg50wPphLWfEBncEx0RDKb3aFQXQJ5HFub?=
	=?us-ascii?Q?0C08EfBRbr9eLRP+CNH5OznlcD2kQ+arkh52viq325haH9ZZeF8AA9Swhfkw?=
	=?us-ascii?Q?eC9FKcN/sdgVO7NTm5dy0nwMWiuxinlKTT9Ni+jGAhvZLBpoIzXRwUB425uk?=
	=?us-ascii?Q?6HOD1ksCbXwS17Bpg3ZG12jvjlZC7N1syxQVdlC8NMEDhIctOzV41Z11B5Xk?=
	=?us-ascii?Q?zySQ0gvXGWi4we77oVaECZrn088mO80WxX0PgS6/2siBpXNngvFG0aEnOhWL?=
	=?us-ascii?Q?thAs2CTfNKkN3lFQ+6Am+zsN5Iprp1S7Aib3uIibFMji8VjvsDELLiHIOCrd?=
	=?us-ascii?Q?4wJJH9iw79XwIMwXwcLcGbXxL5JdS/ZZmazzrQ3dIgGT/neq+8se1JGV17G/?=
	=?us-ascii?Q?bAnAs7P+Jew+PLL7zxy9lvC37brmMaqeaCqzSWFCGRvKEPDdqMRCdeRkBwQL?=
	=?us-ascii?Q?opblztNrSBmgrEuTQhG5+gm3KpaEX69fdEdLr+x3eRi7HyppAW/PrjHBiULx?=
	=?us-ascii?Q?B43KvKXfNruIs3lZOcWXaKG0c0tqdDflqIW19qCO7oimdddd6Hhe3bKDc4SS?=
	=?us-ascii?Q?Y6WIagUDo29GD0LxgjPriWBas4GlIOo/7ZreTkHH32Yk4ZHcosXA7r3Mb8s0?=
	=?us-ascii?Q?G5FG+ggK/CPKVTcPeTpg3bJeJSBszww/6zVKMMWw3P4O4moI9KM2dhTVdJDC?=
	=?us-ascii?Q?R47nRqB5NpyseYLIb6Gk+q4qMhY14IOxFWOIOQBSn7BwSNJVmpnLh57jhfax?=
	=?us-ascii?Q?uwgKyuGoy0piGBZYyAOdxn8/tZCPa4Vtf0KvOkXsyOl23qoxcit5TFJF6YIX?=
	=?us-ascii?Q?Zj6sl55DjTgxP5B87O08mKveIceoJEMn1snhs7tR4ilV+27848mmyx3udeSy?=
	=?us-ascii?Q?SEKXeSOISbQD4e1/jEmfA6BdXzwP1XulXrc+oe+Di3WdN7oXqr1JbETcLZoQ?=
	=?us-ascii?Q?8JqR3IfWrGkir7gwk47k7p0xZ4HhUS+xGBgDTZzgM91UkQlzX/RmrmFXsF16?=
	=?us-ascii?Q?8jK09mnnEutqppTL4yc/ZnKARDR5/MXkTESpYrNoMxf3QXDr/+DyPgSqzxFX?=
	=?us-ascii?Q?tcZAvyTpvuFaoU2EGMj/7UGWjd+kOZ6U4sDhLnI/313d+L0c2hSHEHYRK1rg?=
	=?us-ascii?Q?TlsUdu/k46ZOQD12gUXzGvpEAdTQhozGIJj083zs9LxvM4kdx2Dju1vLG6Mx?=
	=?us-ascii?Q?hXyXYH0AXRBXHiEPbAa3BudTFOQWObSNOel5uCViEms9H9rAcBQkhyyhjkrB?=
	=?us-ascii?Q?HxOgD58gpc6uamGT+CKU54r3d0oY3IRn7U310eOUkNZ6uJ2VOQ=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB7078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a130445e-8be4-4890-cadf-08d921b3e848
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 08:38:02.7830 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j6OQKrtFxAWfwqctKgOEDhibNHi7/v7fUdbHx23DjPqnVZT/PxnDdvYmyZ2RQG8q+IorApTIYmlOEbFulexxRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6743
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14S8cAiQ009629
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] dm zoned: check zone capacity
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/19 10:26, Damien Le Moal wrote:
> The dm-zoned target cannot support zoned block devices with zones that
> have a capacity smaller than the zone size (e.g. NVMe zoned namespaces)
> due to the current chunk zone mapping implementation as it is assumed
> that zones and chunks have the same size with all blocks usable.
> If a zoned drive is found to have zones with a capacity different from
> the zone size, fail the target initialization.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 039d17b28938..ee4626d08557 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1390,6 +1390,13 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
>  		return -ENXIO;
>  	}
>  
> +	/*
> +	 * Devices that have zones with a capacity smaller than the zone size
> +	 * (e.g. NVMe zoned namespaces) are not supported.
> +	 */
> +	if (blkz->capacity != blkz->len)
> +		return -ENXIO;
> +
>  	switch (blkz->type) {
>  	case BLK_ZONE_TYPE_CONVENTIONAL:
>  		set_bit(DMZ_RND, &zone->flags);
> 

Hi Mike,

I just realized that I forgot to add:

Cc: stable@vger.kernel.org # v5.9+

to this patch.

Should I resend ? Or can you add this tag when applying the patch ?

Thanks !

-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

