Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EC1C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 15:08:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 716AA2310E
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 15:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 716AA2310E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-rFy-5vVoNemsqSQfxEucyg-1; Tue, 26 Jan 2021 10:08:32 -0500
X-MC-Unique: rFy-5vVoNemsqSQfxEucyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D9AF192D788;
	Tue, 26 Jan 2021 15:08:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D99F060C47;
	Tue, 26 Jan 2021 15:08:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BD674BB7B;
	Tue, 26 Jan 2021 15:08:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QF8Pwi013633 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 10:08:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 54468110F72B; Tue, 26 Jan 2021 15:08:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F639110F72A
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 15:08:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB7B3187504E
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 15:08:20 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-423-TUlB130vNc639QM50Y8R2g-1; Tue, 26 Jan 2021 10:08:17 -0500
X-MC-Unique: TUlB130vNc639QM50Y8R2g-1
IronPort-SDR: HcbuzBJm1u6RCEVGWBL1UbDszAA+554lNR+8jGCPOhUhrTc+pKHhEVvRzitrqKNbyKqgmM+S7Q
	G2Wdop8XSypkKCpBYBeBnooXwC2sfytvfQ3e0kVjrnwIIAQhYTSgzfyLoUcFGpu1+NQWyUaU4V
	00pHs71QW1NGoBT6OqA+Zu/2Pfs1SKd24Xqi0IciCZDdaEipwIxhtHh7NQahTyhBluwWxtCjrd
	5+ZDosG++y+NG5j75CXTMWBGV5iW1IbV1DAB57oUFFRAfht1GTG1zNuUCSQsu7bII6h0Ru2rUm
	vPE=
X-IronPort-AV: E=Sophos;i="5.79,375,1602518400"; d="scan'208";a="158356113"
Received: from mail-cys01nam02lp2058.outbound.protection.outlook.com (HELO
	NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.58])
	by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2021 23:08:14 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4928.namprd04.prod.outlook.com
	(2603:10b6:805:9d::28) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15;
	Tue, 26 Jan 2021 15:08:13 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017;
	Tue, 26 Jan 2021 15:08:12 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu
	<song@kernel.org>
Thread-Topic: [PATCH 01/17] zonefs: use bio_alloc in zonefs_file_dio_append
Thread-Index: AQHW8/Qrc+FuLwDd/k+CySi1dId/TA==
Date: Tue, 26 Jan 2021 15:08:12 +0000
Message-ID: <SN4PR0401MB359852658B9D8F386CC7C76A9BBC9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [62.216.203.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0edb4c87-c068-4eca-1592-08d8c20c335c
x-ms-traffictypediagnostic: SN6PR04MB4928:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB49288B3AD6F1136E28FA89949BBC9@SN6PR04MB4928.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:660
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ExQuz7m9Z2JVMsakrHKGh0w8++Sxwbj8vy2sZznmg+RMf5rlwJ/ppA3m6/sEhNljkawHlpJht9TX5mm7If/bB/0EYB3U/pShUTwqr0LlFZ/NbtM0Ln3oVrpquJBYV7xQ4ktogxqG7S0n3864flZphyYvkvX9iZzIFpuM3eLUHBo8NGPquM1XIRl1mykcCLhZiMJyZ4kn60XiYBLIsVCyvXaU5Xfg2jKTQ0zrEx+HRmNNaXO9GdfTw6939Wxz5I+922JREaPlm4z5Kpr+Z3piocSgZjCYqw+Bp9XX+A0U5LxgP2jp4FEb+v1/w/BZnnt8LCTzNnLz8qjb9TKVensQrlig83ktPU8lKmds0gnH6PF/BVfPijaHLkvdw8tvGlYEG8kkAduxcBhD3dOXK8FHiA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(4326008)(86362001)(8936002)(9686003)(4744005)(8676002)(55016002)(83380400001)(76116006)(66946007)(66476007)(66556008)(6506007)(33656002)(2906002)(64756008)(478600001)(5660300002)(66446008)(316002)(26005)(52536014)(54906003)(7696005)(91956017)(71200400001)(53546011)(186003)(110136005)(7416002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JQM9L3OEQhlXD6MnYa/VUMRsZExwv8hBqCMxm7neHEOCgV/vnva2Jko4lwvn?=
	=?us-ascii?Q?6a5hV43yv20zlJHD4OiWZ7JqFrxjRCKRwi4D3aR8wFfWRpNdwzB+OtI1Tuqp?=
	=?us-ascii?Q?L7+NjWgG1GIONUMdtWnCZsT5fT3IaaxfjqRG2Hukzm4fzUIQtwwqCzWMBy2l?=
	=?us-ascii?Q?ydxkeNdzouh67olxMR/iIGc15/qRlXhVaWD6fOJWJf4trGiSm11hJjkcg2jL?=
	=?us-ascii?Q?vBWCuMJ30PTxTvvrpbOiSMiHe7Um+Ht0mx57HkwBsF3drQld0QIMd1lv+mKh?=
	=?us-ascii?Q?/EuvP+OPrq6A48BWYa10L1YtTUigufbDtErUVIZLXoHuMPk70FUCdzvW6JPY?=
	=?us-ascii?Q?b7CnDgnYfPUkdVGHxdTIT8w2/UKvSruMWsgRlEkX+UDSiuBhHich9z0kUJ4C?=
	=?us-ascii?Q?XvNaJtBj5Y1UXflXVz0UCnZNRprdvOPIQiyMslHkC/vAsSps+8HP3xAtxE17?=
	=?us-ascii?Q?gVKZ7CzAKybcpEIjO20BCHfCAyhZN0+/zPpdzd9N+pNqKUvDCyKnYdHhOQBV?=
	=?us-ascii?Q?sLYk/pcR+Xzw97zlXrZnI/WTKZ4x2CssnUE+4KMYDbQcoRB8sNAAvMTIrtG/?=
	=?us-ascii?Q?9BF8YKm0a9aNS/sXsL4FY3a+XjIL87rPhpI3HRdyN9aCAO53BJNFByy0TmV/?=
	=?us-ascii?Q?htJ3LGo1uzagc93ru67FZbKWgLnRUKbfq84XAMif6VxgPRj/1sId4wikimF2?=
	=?us-ascii?Q?8bWEuV8aMBb25XcVqg4EkJs9iQpc6BQtslQxVQdxYC7iUQf9I+79iFGUe/cE?=
	=?us-ascii?Q?qLr96pHL/9Hg2plPbC2nQdJWI0eUhbVxZWja8U7tgiuPZxCxMhx9G18TF6t1?=
	=?us-ascii?Q?BIWMu/BC4BMtyiiKlVhbsobqy4tp696zVUrWmLtmgH3bacZJw4a5yDug4avi?=
	=?us-ascii?Q?/MRJMmMOPkrD0TbEXErimf53cgaIDTba0ei/2knbuPboyxPnkFP4S15AegCh?=
	=?us-ascii?Q?LzqEe/GWZyoboUlIt/p0nbGkjX2vX8pDYeUfU+nBvD58Hk3HBag2BDpgCWIu?=
	=?us-ascii?Q?gdIi/PGTK0fWpr9ceKNt9APVCteH9F/etNlvGJTc87zZ3AyNgJBpo7K8N7bX?=
	=?us-ascii?Q?AnGwC++QZn0LXiYiYAgruyRLfkPajA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0edb4c87-c068-4eca-1592-08d8c20c335c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 15:08:12.8135 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q0E+MnIjdP3+t2e6Q3SF/nPCtiVsfV+MwOfDhDYdKs+Gxw8i48xjhHtX6szGMutRVdsMhisZcVPNCbyiIQoF8KnrFdBgFcRxwbNEaS3pxFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4928
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QF8Pwi013633
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	Ryusuke, Chao Yu <chao@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	"drbd-dev@lists.linbit.com" <drbd-dev@tron.linbit.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Konishi <konishi.ryusuke@gmail.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>, Philipp,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Reisner <philipp.reisner@linbit.com>,
	"linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 01/17] zonefs: use bio_alloc in
	zonefs_file_dio_append
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 26/01/2021 16:01, Christoph Hellwig wrote:
> Use bio_alloc instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/zonefs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index bec47f2d074beb..faea2ed34b4a37 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -678,7 +678,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>  	if (!nr_pages)
>  		return 0;
>  
> -	bio = bio_alloc_bioset(GFP_NOFS, nr_pages, &fs_bio_set);
> +	bio = bio_alloc(GFP_NOFS, nr_pages);
>  	if (!bio)
>  		return -ENOMEM;
>  
> 

Whoopsie my bad,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

