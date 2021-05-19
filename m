Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49439C43470
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 09:51:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CBCBC610A1
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 09:51:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBCBC610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-gQRhmMOONzqOPvpLhUMjsQ-1; Wed, 19 May 2021 05:51:02 -0400
X-MC-Unique: gQRhmMOONzqOPvpLhUMjsQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DA24107ACE6;
	Wed, 19 May 2021 09:50:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46FA919D61;
	Wed, 19 May 2021 09:50:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 173DB55352;
	Wed, 19 May 2021 09:50:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J9otGd007589 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 19 May 2021 05:50:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0EC242039DB7; Wed, 19 May 2021 09:50:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 08E442039DAF
	for <dm-devel@redhat.com>; Wed, 19 May 2021 09:50:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35CF980D0E2
	for <dm-devel@redhat.com>; Wed, 19 May 2021 09:50:52 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-465-7SqySPD3NjeWYn-f_-rX6Q-1; Wed, 19 May 2021 05:50:49 -0400
X-MC-Unique: 7SqySPD3NjeWYn-f_-rX6Q-1
IronPort-SDR: xDDN63B2aUhecGP/ubjSl1k5X/O6hbNSCX/ADmNmL2rkRQ7oSaTtT3R/oDmDPHS7sw+nv50ezX
	c3wBfJ1apPy6xmZvTGJi+Qa+84BDIl5VkmP7WWKqq+5LZt1QXCQ5hTZ5tC72Y33n6oC8odWF/X
	jxn0V/wI/69qoy4jpMlH7H5ZPwaI8BcvDGcZAfkc6xiDAG/vrXjq3NOV8HxAfaGZafZ6tH3bN/
	XkA7XbDpEbJFDgUuxNXKXazE+MygnB4mVN+qBCwGRZeSGUg+N16AHeKcg/d0TZgucXfvCmKeDD
	O9A=
X-IronPort-AV: E=Sophos;i="5.82,312,1613404800"; d="scan'208";a="169233537"
Received: from mail-bn8nam08lp2041.outbound.protection.outlook.com (HELO
	NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.41])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 17:50:48 +0800
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
	by DM6PR04MB7084.namprd04.prod.outlook.com (2603:10b6:5:242::15) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Wed, 19 May 2021 09:50:44 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806]) by
	DM6PR04MB7081.namprd04.prod.outlook.com
	([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.033;
	Wed, 19 May 2021 09:50:44 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "hch@infradead.org" <hch@infradead.org>
Thread-Topic: [PATCH 03/11] block: introduce BIO_ZONE_WRITE_LOCKED bio flag
Thread-Index: AQHXTFpy7sj/vH/I0EOvvec4HIbMzQ==
Date: Wed, 19 May 2021 09:50:44 +0000
Message-ID: <DM6PR04MB7081E0776484474876D2B10DE72B9@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
	<20210519025529.707897-4-damien.lemoal@wdc.com>
	<YKTdUYIizUPCtiTa@infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:688d:8185:801b:83a0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9cd838e-44ac-4343-dfbb-08d91aab9283
x-ms-traffictypediagnostic: DM6PR04MB7084:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <DM6PR04MB70849BF4B879D2B9DB69F13BE72B9@DM6PR04MB7084.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:400
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SUwZnmAQr8pOr7XM6I7gJ1Ciyjc+QxPQa9v9I8OwUDTq4AGt2kOC3BUpPDthnKyyN0zjpITbH614gIPaTbcN2XLvmI8eEMltgRO6hEhAj1T06GLIWgvXN/3iOHBULoF7z1ytZJBE+YLEMmqeIZfOx8rgXvwvhFwMRDi01DDPxS+M/1JljB/+FeREDM8q9jRd15kK/UBD2qKuPc3Kd2gvWn2zxuN1AHzvhmFTGwdhA1f1OZDV+jnYp/DGQVBnq3BH1UhoAmfLyS6X4dARGPyLyFODA1jslnNZ4KXI93MncdTW/2g7y3f9BX8Pf/OVik15jHAQF6Pt0srDjQqFMKquqdyirp76qshIBHNp1DA9qjSa3XTTx2rKIknts95Wjl3oQI2hnbHJkx9Fmj9Wlj1hVPrNEP0bUV6bUN8OOZQJX2ueHtky/x1cI9int6eHt1C3BUp7hgsC8s573VVQ6TBnBSJmxmbW/SzGUtirpFuAyOsyXqeph/9+Y20JlYFAr83Gc+d19tP/PQjD2lm+bRM2QZ3x4YMJpWTgCddBkzahxtg/PWA9A5pS853o+yfIH0QsgqzHe2jBJAeFk1R6sTZwupPey0qUs5Cpv7MmlKUhNpY=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB7081.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(66446008)(64756008)(66556008)(66476007)(52536014)(66946007)(33656002)(122000001)(91956017)(76116006)(478600001)(71200400001)(8936002)(4744005)(8676002)(86362001)(38100700002)(54906003)(55016002)(9686003)(316002)(2906002)(7696005)(53546011)(6506007)(186003)(5660300002)(83380400001)(4326008)(6916009);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Ep9bdy8KPdAXF8HeF/CATCdDS27EP0lc+VkWcVIPINjnNTlaK+WmlYtmFuTH?=
	=?us-ascii?Q?XzMIW4z/Hzj5I+d+EtHxjJTSozge3i3aWpNoMg1NS+qdh/X7TGUd6kV25v/z?=
	=?us-ascii?Q?cHhDCGa2tVVBp9QCW8ONNvn8u7B13USlCFc5oKchz64sc7JQnUCKuYifdTBL?=
	=?us-ascii?Q?4VxzuBay5Pz+MANae5/C5yapOxtN2/rUgNWv0FqMG6NiNv1UIwxbTdij8tx/?=
	=?us-ascii?Q?goFP43dMychJ7AlO1MLCUTh2j2mfkuANezGJS5pQ0L4tT1oFHt0npPghCFr+?=
	=?us-ascii?Q?QgsEHes5/8DB9wqnCaiCk+MDBAFNzk2hBHKfksNjg3hGfkxaqVvksA4CwQCt?=
	=?us-ascii?Q?jdoP/fB3JSZfyO6eVmnD8i/sorf0mdramV003isXn/8mlw4X/TJeM/hsqqZ9?=
	=?us-ascii?Q?BWZ1/cqfmaInhibuu7zpcmSiALWOqu3jhl59GKm/+FYAWDDgAwpJLmuCu8BI?=
	=?us-ascii?Q?HfQL0YZ6Z/gfzPSPaJxs5uvxfgeWRa9sF9C97Xi6b04dd5Q+0p/+xPvV8LoY?=
	=?us-ascii?Q?KaOS72//7dv30bHaC62sZ6YPgnz1Jv5ugzy6ndqBtvYejayWAAT4Cr98LmkJ?=
	=?us-ascii?Q?CdiNNiSL1xvrOYH0RTtXxlIofpKYD2wrJsolkDGy9Kpb4kpQ1BEJjO7dLzVQ?=
	=?us-ascii?Q?3wLcIyNnE8VNCNstcmMbE6jYXa7hO0ChxfGZ2/l12YinwnY9A1ORXQRhuhFx?=
	=?us-ascii?Q?ydfcelmhovs/9sbx2q/Qb69FRmJNuxSseM+zdLd0XV9Tnmz5abt6vmBksxUg?=
	=?us-ascii?Q?SgX1lqks5Ptu2vTRBEI0nJbM2AkFKCi8XzGG7WxOobcdwLpGxc3CT3rii7xF?=
	=?us-ascii?Q?2JSRjjhQ/FbemThu2aKoPrUrQLaT98c3dxWHyZ7ojZc8NHsLHcn/DPSAydWC?=
	=?us-ascii?Q?zfk+GXv5WP0sYaXRE4dsouMIp6+T5HwxSLLIBi1OZPN5JSbVC07ZRsL8pSYO?=
	=?us-ascii?Q?6TH/XVjyF3JNX2kI5NirjhVA+Ups0NFUB+t0Uk4a3U4B15RN6HmCGBihPzFo?=
	=?us-ascii?Q?JVy2XYYiZI2UwSNCHqUlRz7t80+Q6JpQC2M0YXJMfUsLQTFNcU89fbX+vJ5Z?=
	=?us-ascii?Q?UV/wqAFhIZLqYWR6Zbi5n0zUM4SMAtEid7qOwmBhT0ZwyV/vSEJ+nLFiStSz?=
	=?us-ascii?Q?miOFlx3HXEWQlxDzqwhpg6EVHZEl6UlOINhWsnRvBvVlwOha3eIbfrNJ0GC7?=
	=?us-ascii?Q?qxMkSi0tmmrIYtSTLpwuOR7MjP+VyRj7mjGKgBhEK2+YlenPmiW7GZRMzcZJ?=
	=?us-ascii?Q?lmtqLUiWvZjLReylIE5LQYma4yjhXfhGJzy6c3BTLK/0E6mFyU6whTdV7dvE?=
	=?us-ascii?Q?NOlttu+/guaQ/aNTRLqlb1iB7NHpr0p3sCgbGv/FasPmZ0c6NwTfUPo5zQfO?=
	=?us-ascii?Q?rpCTUaXE+7uzbTJ00CCarYHMrd5gvr4+lpzb3v6tO3fayiAgAA=3D=3D?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cd838e-44ac-4343-dfbb-08d91aab9283
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2021 09:50:44.8262 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Cl1/Dwcq/RoME5LuNQu0ShRataIXsTFTizgSuKFmPv5zB9HXT22JaQ0KQdDXTYvawXxMJ5WRe6oKApIDSoOxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7084
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14J9otGd007589
X-loop: dm-devel@redhat.com
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 03/11] block: introduce BIO_ZONE_WRITE_LOCKED
	bio flag
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/05/19 18:42, Christoph Hellwig wrote:
> On Wed, May 19, 2021 at 11:55:21AM +0900, Damien Le Moal wrote:
>> Introduce the BIO flag BIO_ZONE_WRITE_LOCKED to indicate that a BIO owns
>> the write lock of the zone it is targeting. This is the counterpart of
>> the struct request flag RQF_ZONE_WRITE_LOCKED. This new BIO flag is
>> reserved for now for zone write locking control for device mapper
>> targets exposing a zoned block device.
> 
> So normally we try to use a REQ_* flag instead of duplicate BIO_ and
> RQF ones.  But I think this is a special case as the flag never gets
> propagated.  Can you document that in the commit log?

Will do.

> 
> With that:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

