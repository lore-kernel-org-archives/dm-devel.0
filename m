Return-Path: <SRS0=+RIL=GM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AA9C433E0
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 20:27:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8EBFC23AFB
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 20:27:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EBFC23AFB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-EHPmqQHfPZW2FCxHJcY1yQ-1; Sat, 09 Jan 2021 15:27:48 -0500
X-MC-Unique: EHPmqQHfPZW2FCxHJcY1yQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ECD1800D53;
	Sat,  9 Jan 2021 20:27:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1045019C45;
	Sat,  9 Jan 2021 20:27:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7AEB54A7C6;
	Sat,  9 Jan 2021 20:27:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 109KRd2E011311 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 9 Jan 2021 15:27:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 897BA2166B28; Sat,  9 Jan 2021 20:27:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82B6D2166B27
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 20:27:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50FA5858EEC
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 20:27:36 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-27-4fVNVaeWPfuAnhWLbyxAeQ-1; Sat, 09 Jan 2021 15:27:31 -0500
X-MC-Unique: 4fVNVaeWPfuAnhWLbyxAeQ-1
IronPort-SDR: AeY8xXEamel0IdX0nPmcK2S8R9vvsbF72t0cfjqb3VWe99gvyABW7AbnDaPFlUAKY8fHIl7ix7
	Uk9LiMce8EWa1r89fKIhHoJqQ9My49KG8XYzlOWZ6DEwO+Ua0yIsQ5glizz+9erk9uAnH4I7wW
	oOt3RpuOs+c31ZmhEgz1trlAjXCxuG8TBJIeR1+CMxw/MrUPUZThtUbu9oaP7CY+FD606Ijk1g
	3nFYw0VXbIaUopLqmXInwN/1wET+fYmUDtHUNbQYr+OqB/lo9DHKtKjBQADv9PKLPSN9Yhjyth
	XGI=
X-IronPort-AV: E=Sophos;i="5.79,334,1602518400"; d="scan'208";a="157043541"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
	by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2021 04:27:29 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BYAPR04MB5430.namprd04.prod.outlook.com (2603:10b6:a03:c7::31)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6;
	Sat, 9 Jan 2021 20:27:27 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::716c:4e0c:c6d1:298a]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::716c:4e0c:c6d1:298a%6]) with mapi id 15.20.3742.009;
	Sat, 9 Jan 2021 20:27:26 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 6/6] nvme: allow revalidate to set a namespace read-only
Thread-Index: AQHW5nUj2CJyK2PmHkCmuBYx3pEKEQ==
Date: Sat, 9 Jan 2021 20:27:26 +0000
Message-ID: <BYAPR04MB4965CD87B0E6CBA2FFD0B09886AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210109104254.1077093-1-hch@lst.de>
	<20210109104254.1077093-7-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d08f02bd-c482-40f0-926e-08d8b4dcfad6
x-ms-traffictypediagnostic: BYAPR04MB5430:
x-microsoft-antispam-prvs: <BYAPR04MB5430106A8922A21DF3D5531E86AD0@BYAPR04MB5430.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5zKg7IJilH0Xs1Bxa8SM4W4G5ecbM7jTulN2kAj/B5/6Wjzlr2QQ4zQu73ZKG3D15DArH4luuRplQwbyjOqO4UQK9g3MVcBWbIX4xDsk41yuZ9ALZM+3aWu0m58PH0FML0m7jzmdLqjKd7bKSHyiYK6ZM5nfWntjg5EqtJ0HFqSzcCR2yyUJIcqkS5o/yprprI5sZxfiecx/jtNAu//phRv3bArCaNukQuCHJkCUvPpNaov+tRZVVcEKSwcdGy70mh8GwxIQVBdD8+Mn5cxPai1949Us7SOBl0Y1nXHVGnlhU39EhjByW85PLe2QYprnaQzT+TNP3Ew75z73g6sV5ffukoCIzrdzclrRkgEjpRLHKCj6KJf2Dj1Icp+tQIk+8UZf6oihKy/4hojILoorOg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(76116006)(2906002)(66556008)(66476007)(7416002)(5660300002)(52536014)(26005)(4326008)(53546011)(316002)(186003)(6506007)(110136005)(66946007)(33656002)(66446008)(71200400001)(7696005)(54906003)(64756008)(478600001)(8936002)(55016002)(83380400001)(8676002)(9686003)(86362001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3Km9/v4XeC8e4TNNr7OdvVC0kInaVNzZ+PlvyFEDKSVROxOIdB5O9BzApV4V?=
	=?us-ascii?Q?LCx1biZw8uoWq2bsNEByXLPJE2Wn2gd3vA+PJFjo+Hc2rQfXSLuSp+TqTA9Z?=
	=?us-ascii?Q?JAyzyhKFCV+w3li26eabUOk7urAOsgZxv394ZHKbllDslE4PG/f2LUbMEGQP?=
	=?us-ascii?Q?SrLEEuvYWEUBGNnS/INZF9wH0OKtpBdym6i6TOX7rfzcReiZmfGf7syD6L0P?=
	=?us-ascii?Q?pfINU09L9yiFNfdC75fL6uQPQxGMgS8RyHo8U7CMyT8e10ikGzAwu1E+0bM2?=
	=?us-ascii?Q?gRHAgd72jSu3KPGS6e9gB9wmUtIAt6umEhHFmuDZWpLqM/IihslGrMGvqDFv?=
	=?us-ascii?Q?xg+g7cHgK8mbZcVzfDues8P6lHplWEQquztm0dqHO3xNFQ6txIpkctC152Wg?=
	=?us-ascii?Q?B1AoY7k5UXl4UXds+sQHTEeH2V22vZ/LojgQhxd9OWKomhl7XD5mKrQs2meL?=
	=?us-ascii?Q?p92VWpwTs1DFWuMUklhQKVKjWcTuear6A4Tqi7cNwzcaCbxKiEnSQXilbOlY?=
	=?us-ascii?Q?YaJ6Xt6NbkJCO54vRrXmJm7DSnEu3BFOROQxA8TnyLvQTVhl+wCChWXgtIK2?=
	=?us-ascii?Q?jM7C1L3HBTQqJEGnaGgmUNuE7tzpCNkuIhDwwZRwhDejm9Zmy2cPY0DjPy84?=
	=?us-ascii?Q?N5LcQv407+GdnRRwFQwPvxcxrZiLkJJxB0YRJ+jAz2POxq7NeDu0wT3dwbDs?=
	=?us-ascii?Q?HKYyZdqBO1pMsq+0rZ3e1dj5X6emD/DzpKLNQDto6r+KXIAgYz4TMQiTm71Z?=
	=?us-ascii?Q?i1+fIDBuRIPUlS4Vq770JXFrRY11UE/klh/6eNOFyoBeROfeMF3yqGO+8LJL?=
	=?us-ascii?Q?IRq3fLthZqBSVV7Pu54FYe4V6zmnoYLcg0P52hhyK6KCkKs9YqhwSbkWDOxq?=
	=?us-ascii?Q?A8eeYsTDTyrJTQ1vsAjdYBHc+EU0XuTIM303yG26WWcoDs7FgaOMu8LjD80Y?=
	=?us-ascii?Q?Cv7MvOOpLRJ4IzH+GFzg2wU2V8azzDNcFhFXUfBc1KTHd1wDEtJFy9n4PS3a?=
	=?us-ascii?Q?UpR3?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08f02bd-c482-40f0-926e-08d8b4dcfad6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2021 20:27:26.6252 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EHwS9qQDhhu8i5c/fE9qdQv5ao2jZNgIeyHs0gGZZ2rUhflGDLpbwuEzb9XWsW539ENucHfztLdu0yLNc8WzFJHQ6bJ8qsPwIQnHK6JPKvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5430
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 109KRd2E011311
X-loop: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Busch <kbusch@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
	Keith, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 6/6] nvme: allow revalidate to set a
	namespace read-only
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On 1/9/21 02:49, Christoph Hellwig wrote:
> Unconditionally call set_disk_ro now that it only updates the hardware
> state.  This allows to properly set up the Linux devices read-only when
> the controller turns a previously writable namespace read-only.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/nvme/host/core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index ce1b6151944131..3a0557ccc9fc5d 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2114,9 +2114,8 @@ static void nvme_update_disk_info(struct gendisk *disk,
>  	nvme_config_discard(disk, ns);
>  	nvme_config_write_zeroes(disk, ns);
>  
> -	if ((id->nsattr & NVME_NS_ATTR_RO) ||
> -	    test_bit(NVME_NS_FORCE_RO, &ns->flags))
> -		set_disk_ro(disk, true);
> +	set_disk_ro(disk, (id->nsattr & NVME_NS_ATTR_RO) ||
> +		test_bit(NVME_NS_FORCE_RO, &ns->flags));
>  }
>  

If we are adding a multi-line function call can we please consider
following, on the top of this that matches earlier multi-line function
call in the same nvme_update_disk_into() :-

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3a0557ccc9fc..5cf0f801a95e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2115,7 +2115,7 @@ static void nvme_update_disk_info(struct gendisk
*disk,
        nvme_config_write_zeroes(disk, ns);
 
        set_disk_ro(disk, (id->nsattr & NVME_NS_ATTR_RO) ||
-               test_bit(NVME_NS_FORCE_RO, &ns->flags));
+                   test_bit(NVME_NS_FORCE_RO, &ns->flags));
 }
 
static inline bool nvme_first_scan(struct gendisk *disk)

Otherwise, looks good.
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>  static inline bool nvme_first_scan(struct gendisk *disk)




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

