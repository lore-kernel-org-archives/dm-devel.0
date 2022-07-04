Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CBDC43334
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jul 2022 12:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656939598;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=LQejNoecHZ/YCgB6fAJwsAXK6NVv9heWkBQMrJoNng8=;
	b=Ddg/gHdtgFOvy9Jv+gikN+teTYbUFN6yC2T8U8v0fYDWCgayBOuNHPIiOg6FvYat3+ZToj
	dKgz/ggf/Pdv0EKgFV1M0tBPzEZy5MPKK6PVvhXcJ3e4Px1ajYV5qqtzEnEVWZwGa4KNZk
	Hx0Ro8eVQ15g50hsZwMoriAvqB7MqE8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-VymabCISPu62xpJAbmbhmQ-1; Mon, 04 Jul 2022 08:59:55 -0400
X-MC-Unique: VymabCISPu62xpJAbmbhmQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D899B185A79C;
	Mon,  4 Jul 2022 12:59:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B389241617E;
	Mon,  4 Jul 2022 12:59:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 82C611947041;
	Mon,  4 Jul 2022 12:59:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E0FD19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 12:59:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 204422026985; Mon,  4 Jul 2022 12:59:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B0D52026D64
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 12:59:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E031E3C0F36C
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 12:59:47 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-qpyglJ8EO-qlI8qlJLJW0w-1; Mon, 04 Jul 2022 08:59:46 -0400
X-MC-Unique: qpyglJ8EO-qlI8qlJLJW0w-1
X-IronPort-AV: E=Sophos;i="5.92,243,1650902400"; d="scan'208";a="309089340"
Received: from mail-dm6nam04lp2045.outbound.protection.outlook.com (HELO
 NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.45])
 by ob1.hgst.iphmx.com with ESMTP; 04 Jul 2022 20:58:42 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN7PR04MB5297.namprd04.prod.outlook.com (2603:10b6:408:d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Mon, 4 Jul
 2022 12:58:40 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::d54b:24e1:a45b:ab91%7]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 12:58:40 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Damien Le
 Moal <damien.lemoal@opensource.wdc.com>
Thread-Topic: [PATCH 01/17] block: remove a superflous ifdef in blkdev.h
Thread-Index: AQHYj6PpBGDuTXPD8UWi1k2YGkh+6g==
Date: Mon, 4 Jul 2022 12:58:40 +0000
Message-ID: <PH0PR04MB741671715E7F16D5335002509BBE9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220704124500.155247-1-hch@lst.de>
 <20220704124500.155247-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 313da69d-ef19-4ce0-b9a6-08da5dbcead6
x-ms-traffictypediagnostic: BN7PR04MB5297:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: gpHVWZnQqnLrwlxeeSAAWAlegpL6kN8Uf4gCpFJJ6erEnlYcM+Z3A9sPHk7ZIZSi2A6gK7bfcfY5Td719nhE0RSZK4odgJJnqc5Rb0mDky4k7/cRr0epmxL0Vc7/zI9AbH5YDdCRbs7Px18fNmmX8/40+kT6HGt2P3s9gHJ8wqr5UEwQim3kS1zn5eojAJD+vhpYDdZVyjFDGo8ChHcelL6TejxFerCbb/vwneH8N+UPL43D1g88iOvqStHrs9Cm+yLVtj9lxcT1pg3xntLe/0mOrYhmpVg7f60n9Jp0v+YzwfzXaoXhxdaseOVM2HLeIuVuBBAflo32m2ZHEgnEsVuSs/ofOKYbK54VcRGDFFDC3dkaK1FVXjflMNxvXMkWyzhQPL4wtLlKTH+GFcjn099Zh5utDLn2oQZy1S7NJEtl/gDInS5TcbtqFhlxfGAyoNE2Qmriw9EsZ5LoVv0pLp8mYSP0xj4dbw3FY+7mFJpuDXKDqUCEu2w9AVZjAVQehMjoJTQhzxZbNo0JBm2ZWHZD2xAEPlzP/99ismeeK0+QJcHAYprQDkYzaArFRIE6Or9O4pSa0L93yHsEdbWx7UrTMVgXQTBhf2TmJGV6RDC+VejBZyAYc9rqkMaEs9hka3VthkuOo7vck5xKwdT1v/ZgwgTyne/vv+BdqMaMJKv2NZKMfHyOD6aL+aRYC6B3wyH/HZenGD+VraOGspt42nxOJ15Pc8wHt2ZrknY1WMK+IwG97dyVnxB7eJtampI5pF+jPKl3N4a7JpyQnbze3YdKIzQ1SrC5oMiT91tf/hYEzUJYFw7Mrl3xrVwpubFzMK1pxCVKS2x1zuqF3JDcLw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(396003)(366004)(39860400002)(376002)(346002)(136003)(9686003)(186003)(53546011)(7696005)(83380400001)(55016003)(6506007)(41300700001)(2906002)(38100700002)(54906003)(110136005)(38070700005)(122000001)(82960400001)(478600001)(4744005)(5660300002)(8936002)(52536014)(91956017)(71200400001)(66446008)(66556008)(4326008)(8676002)(66476007)(64756008)(316002)(33656002)(76116006)(66946007)(86362001)(21314003);
 DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TO6VSNF53gDRSvoSPAdrqvqb6P31zJRu9J95U2e/iFjdZj4z9VfdphFQaKE4?=
 =?us-ascii?Q?uL77H30UZpASvrrJYczByoGigbxAgmOUyMw1KLY1X3X3cOaLtq/kegmerjqC?=
 =?us-ascii?Q?/ffOJZ4nPkWFwp/WPhpmX7NnvD9Zt2JMxxMfO/T/w8sHG11nracSkHLnstnE?=
 =?us-ascii?Q?XRfq4/bv6DxsbheCNLaim3utr1Sa+pqXrhBDf3CuuZp498rm0ck9qp4TtJD5?=
 =?us-ascii?Q?tFLBYaAcB5WcqtCereJhOrjF2qgx0iP8DSu+6Xc0DjRlkOmFC7SmdbSiWscW?=
 =?us-ascii?Q?kdWX/FrlRDxlm3746z78U7TSrJH+DunXQh38LQWu2scLgW+nqf9SoRZBPH9V?=
 =?us-ascii?Q?iKSyWXW6uGzUV9QXpkPzFKSRu9dKgwd1Ee722msNoIKxxscXRv+hseYu1M9q?=
 =?us-ascii?Q?LyjmLKn0m/KeBsHnLge0PsLndh4t9rGz2N/QN20jWLTzxLyROVdb69CqieAb?=
 =?us-ascii?Q?ue3OgNafzQsymCF2ohY6FjhVwMlpjv00nRn+hBpqKXEuBudlBfjfUc8cC5Ql?=
 =?us-ascii?Q?U/1ZpEvnjh/C78vTsyF38DdTBBMVt7s72SwsStFmae/9uQC/rJzLDRreKeUT?=
 =?us-ascii?Q?tCsIPXFl/zLd62ECIDLWl2zrOOaNYvLlA5pYD7au/VfaWFzF0KiPHQL4RAps?=
 =?us-ascii?Q?6bSOIKUy26AsKxXHEvQCYA3Ky7c6d38n+e5zZalmj0PDmQ4eS9u9GjSO2fYF?=
 =?us-ascii?Q?zqhyBIln4hMfIOK7FavN0EE6wrmFZaiLEFcq1ZyvdHE/Gc652n83pqB70pmN?=
 =?us-ascii?Q?V9yaURS/w8/xlAPLKhnLi+txYCkeuRBmmCpjkcqpN8HUKqQU12FGOdKNI5FM?=
 =?us-ascii?Q?25udxpRayOXYE7ohJMi5WPPnkS/EfbHLgn+5s/FalHPOpwwMXRrpOUHdzWit?=
 =?us-ascii?Q?Ihq0VtkZXB1NGpJfXq5bHj/UFLls5Q7qacBthDFrHSIBFYsN4Jrox9il3SWu?=
 =?us-ascii?Q?1ocByfigI8jW1ZYMJgDvHb7tNAtC3ENQujgY0UNvihWnrg2pnmZgAvhGlB/L?=
 =?us-ascii?Q?wS4tPpAwCs4LXpYH8zjaV10ZMkpEXc3aFPLw/FGNu+2SArla/ab2neuNzhvW?=
 =?us-ascii?Q?G+unbyhA5KGDcb7le0ohcQ/jyLy8kgW21UfWlenuaAhj4z68EfFnqHCkrpQB?=
 =?us-ascii?Q?6hESsZVvDEs6oDszVdORUr1knWFule7szSxF5DgEkFJtPx4Pa393wUUaAxTv?=
 =?us-ascii?Q?PNperrRek3QwVa7z9AGTriEIKSjJ20NGOSKFMoPFFPnEg1vIobEHT8WkPSRo?=
 =?us-ascii?Q?l7xI0GtJYi4zFK6O4i8mbORayvhWJJQ2g20uW7D1X+pMk9tu2+eFiD0COSBp?=
 =?us-ascii?Q?wF9LyLcDOPoR9GgadBFrHpGy1yEoTRjLpAeDV5WdlZOWEu/saaf4O/0AXF1O?=
 =?us-ascii?Q?T4pj16EMWRDglF6ydUQOXKdA8NFqeSMEV4j2ZgMlddhzO+Ygs8lcb1w/ff/c?=
 =?us-ascii?Q?8Qy1X88JXmulh9bq2yxihpJWOXa/t/8wpqOIU1VyFcfmGM9Wzq4KEsAHIBcV?=
 =?us-ascii?Q?tJaDHKj/biiNYXRBtmHIyy4CuUb77fW6ZLtCRgZOjIgnPmGbSWGgiKJ+17vJ?=
 =?us-ascii?Q?ImMcpfkN0dr5zzipudyWGaBRQ5mRlHd7g2aoyvyTVMpHbegyihMllEFdo+Sw?=
 =?us-ascii?Q?wJiVEpZi/H+KKDHvNY6CvV7yQ2FPx/gk409shvQo/MAEl8Sropqq7LJL70Cq?=
 =?us-ascii?Q?c761Bcj6PbUM80Sofota/H5mpiU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 313da69d-ef19-4ce0-b9a6-08da5dbcead6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 12:58:40.1365 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gT4aPgbnD/G0MI3rP44J50n9KJwpWx6/9r46JxIstCb00dOquUYzbcVkza0pB/dSrWA14BwsjNWrSzWoaMyBVZ7HeGMMZk8m56D/P2x0bfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB5297
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH 01/17] block: remove a superflous ifdef in
 blkdev.h
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
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 04.07.22 14:45, Christoph Hellwig wrote:
> It doesn't hurt to lways have the blk_zone_cond_str prototype, and the
> two inlines can also be defined unconditionally.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/blkdev.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index b9a94c53c6cd3..270cd0c552924 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -899,8 +899,6 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>  	return bdev->bd_queue;	/* this is never NULL */
>  }
>  
> -#ifdef CONFIG_BLK_DEV_ZONED
> -
>  /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
>  const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
>  

Won't this break tracing in null_blk, which uses blk_zone_cond_str()?


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

