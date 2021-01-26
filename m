Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D2CC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 23:23:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CA5CE2067B
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 23:23:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA5CE2067B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-HwI3LKcBONecpMjU6g7lrg-1; Tue, 26 Jan 2021 18:23:38 -0500
X-MC-Unique: HwI3LKcBONecpMjU6g7lrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE03859;
	Tue, 26 Jan 2021 23:23:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 21BAB6F80A;
	Tue, 26 Jan 2021 23:23:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B24D44BB7B;
	Tue, 26 Jan 2021 23:23:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QNNUZs024779 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 18:23:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 217A72026D48; Tue, 26 Jan 2021 23:23:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A70B2026D47
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 23:23:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CAF2811E78
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 23:23:24 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-388-77QaGh-iO_WtbIDn-Sb0kQ-1; Tue, 26 Jan 2021 18:23:22 -0500
X-MC-Unique: 77QaGh-iO_WtbIDn-Sb0kQ-1
IronPort-SDR: PMLzSjl3IqOwSN0mI2pkm/E4W86liCDmefoMc5/dDkMfzJBhGS4ACERPrrsf54+EREVvFQKXe7
	/W4TaiIXAEX4yWVRK1+smZsQnzX2DPE9cUOWEZXQMayfL5ll3mSsUMruLmANj6P86LSWRu5jvN
	dyeAL0uFOneoIyd7GgfVY+HmsUN1+1vaH0JNhOOCS4KAROO7D7Jwv5XKfGwQLJqz1FKdMuqfJJ
	08L+O947TdtXmkAMHUFI4Ut7QNKn7LZDr5y0C3czLeP2/4Vi9oscktf6KushtDfHQ9SDS8u2WI
	32E=
X-IronPort-AV: E=Sophos;i="5.79,377,1602518400"; d="scan'208";a="262415022"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO
	NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
	by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2021 07:43:18 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6991.namprd04.prod.outlook.com (2603:10b6:208:1e1::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16;
	Tue, 26 Jan 2021 23:23:15 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Tue, 26 Jan 2021 23:23:15 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu
	<song@kernel.org>
Thread-Topic: [dm-devel] [PATCH 01/17] zonefs: use bio_alloc in
	zonefs_file_dio_append
Thread-Index: AQHW9Do52nd5GTGfH02P+8SlJRgdug==
Date: Tue, 26 Jan 2021 23:23:15 +0000
Message-ID: <BL0PR04MB65145D02027D58CAF3F59626E7BC9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-2-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:59be:e05f:a0a7:a46c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3672ab75-cb23-4fde-d810-08d8c2515bb2
x-ms-traffictypediagnostic: MN2PR04MB6991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB699141B5B4385436431DEE0EE7BC9@MN2PR04MB6991.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:660
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6SIxQcVjcZvwAOYPTqhLZd1XB17uQt0aK1fAR/nnZdW8/1hiE6ZpHh0wggzzlVJMJLMThEoVkj0pBg1JLtqF+rf0fxThv8DusNrcOip0gmsEr8aV3WA4o0dmsEsqnjQw2hMBgwlI1ta1Amm4/2puIvLuuj8Nh6mpsGV5wdkNX5N8LBOpSb4qbPpzM4WqmZBcZgVidgAMuW4ZUL22+TTNxuJzcQJoh1A7GYUGLCj+hWZjDeaayb0VX5vxSdBIVoQmTJ/aqvH0+rmX+XNpbEa6eGiLAWEooIDixsNpCHAQJQy3kQP+yY5rNUahhDmVf4tS4KRRUtAPBH+9wg1Uqg3bAbRHxV2eQlLTbKVTnl9covvkF8ON4UxGErAVsUO2zYu4YgwwP1S6knv6bp5QF5jZddm3KPidAHu6UBSkDkgno42kx6VpjYjSs9FFfQLEl4g/0meD02ntCO3CAe7CscfzST1YWPAdXu3VL3GrL13zRVzx+Rd41+12xV6qityL2JJTNBgNCxxv+9cRFV+hXDnsWQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(66946007)(83380400001)(316002)(54906003)(110136005)(86362001)(2906002)(9686003)(7696005)(7416002)(8936002)(33656002)(6506007)(4744005)(186003)(55016002)(5660300002)(53546011)(52536014)(76116006)(64756008)(66476007)(91956017)(66446008)(4326008)(66556008)(478600001)(8676002)(71200400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?h9X0Gtw9vSaAmaGPbbhrolsYgole2HKvSGxfo1iihE5lnMAH065ng76JxoU/?=
	=?us-ascii?Q?QjnKIfg46M1srZQEr6B2udU/m1X9HRZigI6fpKlWeDreCN5eWI2Gv24QwoWR?=
	=?us-ascii?Q?IJ9ys7srexeN5kNBJTuZ08cT3nJmCCq0j/7NOA/3Dy4qSUx8QtZP8UPS4upx?=
	=?us-ascii?Q?x1QNwsRkgrT88AA3q9OkNadrFEctdP6kYAOieAE4KOH1aB3knKV9b07MZ/OG?=
	=?us-ascii?Q?nLgpsuGgzhimsZMHiFTlTxdr9PNwumU4x9y/d+3NImG6+l+pKF1qxDdazbSw?=
	=?us-ascii?Q?gUum+Gb0HqPdp1gdcOcUhszciUv4N6fvoxYe/UmkU/AkfXzD89h7OejmBOBX?=
	=?us-ascii?Q?tCU1fqqH3M9PLYFwQkq8Z03FEC2QWG2pGrs30kMnq/lhAkZ1p/O5mJg3UhKI?=
	=?us-ascii?Q?BQoSozZS9lCqqA+Ea4fcvLAUumN+Hv4U3GfllgXttLwDI639o0pzyJLi/leD?=
	=?us-ascii?Q?wvAMu0s3b4ZXIY3o/A+RZdtFylNqvwJrzHw8X4dFsLwlm04TuUXKGLyH5S+b?=
	=?us-ascii?Q?FY1MDDuz6tMhQ+EfI5Ciwnbl6VXyWVJtceM505RMWvojHAvkQvAlBpJMQNdG?=
	=?us-ascii?Q?fF6D36v0Jr7UtoAZFOW1HyJ4S7rTSYc/92faN3BdI+SLDTx7J7sVAZ2md5DN?=
	=?us-ascii?Q?8bc32ncxeKg10oW6EUS6I3vL8Yhyscii5HO0oLjr7yZX2FYINzLA4UYu8Rf+?=
	=?us-ascii?Q?acN0ZMUhmQYZNnIzqy9pCv/XnVNP56XQ7PEdeC8nfs3lvyc5MXk4YMLoctM1?=
	=?us-ascii?Q?LIGKS6YmRDQWrBaByDPNXQiaLhKr3LXyuTahZ0NdobdpnjmoQwZlU9LdjSiO?=
	=?us-ascii?Q?b8n2l8k3HY5uoGpQM/y/Ki3Z0HVdKTC3uPRE/qvifSJlivrc1cO0teToFHWU?=
	=?us-ascii?Q?rmUhhJ5MHTlG8uzh9YklJXOUeARwq6nBlLUFE6IsGEM1GV07CIVVSTK5/Hjk?=
	=?us-ascii?Q?sdx8kid58h9LCuH1RqKtCmc8B4sfw7q1YK7+296qR7fVsLyHgtl+sC3Pq/UY?=
	=?us-ascii?Q?m06sV25q2Vxf///Y2YMG7/AtZantlOVcf3QAvuzHdMSidh0bIbh20KRaFpOP?=
	=?us-ascii?Q?DCmWfsAKSuU0tgd2hTmk2HIEZZ3Enj2cEwXKgbFYgFCWtl1W1msJ/l80bUTH?=
	=?us-ascii?Q?vV0CgT3SHKPwYUKs9LHIDDBJKrYxNRWiJA=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3672ab75-cb23-4fde-d810-08d8c2515bb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 23:23:15.7291 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Ys2pEm4dwPypxXNQflN2ZuOc6fOAfjNaKAfawRkYdKvpX11zpiJWlnZxqfTCWDH3c7KpfDYuSpoMS0HzU8HRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6991
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10QNNUZs024779
X-loop: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>,
	"linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Chao Yu <chao@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	David Sterba <dsterba@suse.com>,
	"drbd-dev@tron.linbit.com" <drbd-dev@tron.linbit.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	"linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/26 23:58, Christoph Hellwig wrote:
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

Acked-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

