Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6B86C433DB
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 57F3A64DE2
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:39:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57F3A64DE2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-PzBsv5ukPOawVt8qk8o2ug-1; Thu, 28 Jan 2021 03:39:40 -0500
X-MC-Unique: PzBsv5ukPOawVt8qk8o2ug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6A25AFA83;
	Thu, 28 Jan 2021 08:39:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B3C9F71C94;
	Thu, 28 Jan 2021 08:39:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 88D4E1809CB0;
	Thu, 28 Jan 2021 08:39:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7LtO4008096 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:21:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 09D622166B2C; Thu, 28 Jan 2021 07:21:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 033EF2166B2A
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:21:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2531858281
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:21:52 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-373-ckqB87sGMNqf3Jc6-6gTZA-1; Thu, 28 Jan 2021 02:21:50 -0500
X-MC-Unique: ckqB87sGMNqf3Jc6-6gTZA-1
IronPort-SDR: QEF+8TGngCqTGDYAfES0k7Iq8Lj8Z1j23hWw3M3LnFhL6QZih1XM5LZxSRsfTJXgpv5E1SblKM
	Bsu7V10JhP5TnAvBjYRtRxEqUPv2HJm33T5x70FdtpKeTam8Lku0k8SIl7hluBD5ij/As5Vw9s
	nKuDQlS8VQ8KHSrpBH6erXI92dE58YUlccMAgxKbmkG5Krj4uGkirZn5TulPgUw8Qky4rfx2PQ
	aWCuLtWfwtNgNSyX+xM2wVuWWfLlJn8a8AVx4NTLiKKss4UTZKw7CG5gC5hQr1D2fM05/SrZuv
	r5A=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="158517951"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO
	NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:21:44 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB6352.namprd04.prod.outlook.com (2603:10b6:208:1ab::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17;
	Thu, 28 Jan 2021 07:21:42 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Thu, 28 Jan 2021 07:21:42 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "drbd-dev@lists.linbit.com"
	<drbd-dev@tron.linbit.com>, "xen-devel@lists.xenproject.org"
	<xen-devel@lists.xenproject.org>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org"
	<target-devel@vger.kernel.org>, "linux-fscrypt@vger.kernel.org"
	<linux-fscrypt@vger.kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, "linux-nilfs@vger.kernel.org"
	<linux-nilfs@vger.kernel.org>, "ocfs2-devel@oss.oracle.com"
	<ocfs2-devel@oss.oracle.com>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Thread-Topic: [RFC PATCH 02/34] block: introduce and use bio_new
Thread-Index: AQHW9UTnP+XqlvwCeEC+5iodtWSeNA==
Date: Thu, 28 Jan 2021 07:21:42 +0000
Message-ID: <BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eb871fa1-3f12-44a2-a077-08d8c35d5ca2
x-ms-traffictypediagnostic: MN2PR04MB6352:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB6352DBDFAB902914B9C585EEE7BA9@MN2PR04MB6352.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: M09uEpCy2sHYnN+orzp8d3r4sKwPwnS+kovdPTr+X2vGltHHUOiuwt35YiL4pwUTQFJb9lI/cctrcvMtSEsYDG11B6WuQeQ5LhCFOm8xnCx/j7IUhZfAc+BSTsEsxty8tkWMahat2Us5tDlHI9XpWnzEpUBuIiTIis6CFGcSzDbZQv+YTkDwb0pb6zKYryvjjNyuaDbfN6d7lDvAFgMe/S84pCGpf8NIYlMhpfcnANa9rtVk1fEfaQ11KXM8VaoFYslEaC8FtVVKMdMiSlVm1G6wR6EIe9QpF54CPrt28byH/cHhwj053vEXp8RFF07hlGeGEHLWbouozYb93iT1K6F5OPFCWV/ewR8z5Kn/uykKQypwrh09HC+m3KNohPQSss4YboxRFNRKIUOjUD9KDfOD2dh3DMVG9Wehar1cknnRs6eoICQxgNf9XdAqhQxkvWGbAdwofxGFVG96zdq+KiRY7l6iGEQ9lizBBRpl1Cl5YsTWF3Ebz7haDS4uRI4CUlc0EEMGTEpRabqGyepXSSCQauC0I01aeQXMPzWGYL5JlkA/UoQC4yu0QYoNvMSIgo+cZP34MN7KkNUL2U0tyA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(7366002)(7406005)(64756008)(66556008)(66476007)(66946007)(5660300002)(7416002)(316002)(6506007)(186003)(66446008)(76116006)(110136005)(83380400001)(53546011)(7696005)(91956017)(54906003)(52536014)(9686003)(86362001)(55016002)(71200400001)(2906002)(478600001)(33656002)(4326008)(921005)(8676002)(8936002)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ilRnIHb2W+3T2C2caNzRqpDzJ0Ea0Xivh3HFrmVjFepbjG/4fJPeoU7kjRlT?=
	=?us-ascii?Q?4cfEdoxq1pKIhTR8YC8VWpTJjQgCARNQwY+MfHwWAHyq7XzZrTJ+W5zBB4Nr?=
	=?us-ascii?Q?gbqboym+VApr7h2E6XSe0FmXOz+omKq6DFZVboi3NwQAYnWCDCcygMa0n5ZC?=
	=?us-ascii?Q?i+orw+uEOMmnA8L/tMdOkJYMmLEyVDh+G9pnjfMmYkt0blpGnFBWHNDym39U?=
	=?us-ascii?Q?dIrdmaQbh6883La06gFXbWGdjQgjXOXLEnZ3UgQdxTZ3JyxZKLQ71jVVbmhr?=
	=?us-ascii?Q?0p2pkHIwQoMPz5HKOnR6V80LYTmpcP7VgrO091zZ/4rct/lsBVwykJza+GD5?=
	=?us-ascii?Q?IHbQu1IRlEAKFeXGAtTjEb578LsnTaSvJCJYoQS2vP+axrzwvVVw8mOt+5k0?=
	=?us-ascii?Q?KL2XZSeojWALtQsww9PwXxXKo/u++tt+9E5GT2jM5O4BtWCGYIeHt1uhRADL?=
	=?us-ascii?Q?gJ0hzvvlILRjU/TqEgmmCXBE50OH3C99QT7ii97n4+QFDEjw2bGLKb5lrf6H?=
	=?us-ascii?Q?IHyTRN7gvNFJTUay5wTAkpCCUyYWXZIjEb2UFpB6lV531wPPtNPC4ZXwwrWy?=
	=?us-ascii?Q?UUwx0RViz7R7iLMJP7kZUpan/n9xAtlMTSdfuUl+LJK65X0ynOT4EUBmjZh1?=
	=?us-ascii?Q?7f2FeVb24U1zoxD5JnIuvykDuOYgmJlnvf2GvI4IfNA9RybrTxAbVd7Ev1uE?=
	=?us-ascii?Q?iYKXh1HRo38Gzl+/krexExV4e0GgKuB8ROJUM1mrrLxC0PLvUJVZZWIIKY/T?=
	=?us-ascii?Q?EtWttQJe8PPeFmAWMbSTnlaoUKPvNyDC93hjlfGSDIjTTLIFZ4iZg/v8/mfl?=
	=?us-ascii?Q?vPF743c6M4QtXnUUQcdd8jMU2Xffoi6iuon4E7e6TeLOR0e7niaTBUf3bgPv?=
	=?us-ascii?Q?W2AR7teeocTc9v/wp1bkGDqoO4PDXnCni+0tsViRKD+BHAkawcDVDIjbtPby?=
	=?us-ascii?Q?TmOiQAj1HhTITExgPZ3Am1ML0xT8XHeZOcxCj8XLjunGXY367EkeICLa7oc4?=
	=?us-ascii?Q?Hx+SgjQnG25wJn9UaUXUtvbZ+SxW0OdUJGfxAAPJaG/AhMr+s6nN+ezf5jC+?=
	=?us-ascii?Q?TnbTVjltXe3BweymPazgpv3fxkvT/+e3/ihgd/xwUglKOJv1POJWqDO9pOjp?=
	=?us-ascii?Q?vVmRwBKsvdP+eIgHWtuWTOV2jEyOlzJg4w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb871fa1-3f12-44a2-a077-08d8c35d5ca2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 07:21:42.3813 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HOBO+8eTXWVmpt6dgIHyBBjDN753lOgBMYt0QXNGr1qUdGHKogIJ1c3Ww3ZO4DM7PeQNbxVnSGwrctGN0hiVFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6352
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10S7LtO4008096
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:54 -0500
Cc: "shaggy@kernel.org" <shaggy@kernel.org>,
	"sergey.senozhatsky.work@gmail.com" <sergey.senozhatsky.work@gmail.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>, "tiwai@suse.de" <tiwai@suse.de>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"gustavoars@kernel.org" <gustavoars@kernel.org>,
	"joseph.qi@linux.alibaba.com" <joseph.qi@linux.alibaba.com>,
	"pavel@ucw.cz" <pavel@ucw.cz>,
	"alex.shi@linux.alibaba.com" <alex.shi@linux.alibaba.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>, "sagi@grimberg.me" <sagi@grimberg.me>,
	"mark@fasheh.com" <mark@fasheh.com>, "osandov@fb.com" <osandov@fb.com>,
	"ebiggers@kernel.org" <ebiggers@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>,
	"len.brown@intel.com" <len.brown@intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
	"ming.lei@redhat.com" <ming.lei@redhat.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"jefflexu@linux.alibaba.com" <jefflexu@linux.alibaba.com>,
	"jaegeuk@kernel.org" <jaegeuk@kernel.org>,
	"konishi.ryusuke@gmail.com" <konishi.ryusuke@gmail.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "jth@kernel.org" <jth@kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"rjw@rjwysocki.net" <rjw@rjwysocki.net>,
	"philipp.reisner@linbit.com" <philipp.reisner@linbit.com>,
	"minchan@kernel.org" <minchan@kernel.org>, "tj@kernel.org" <tj@kernel.org>,
	"lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>,
	"roger.pau@citrix.com" <roger.pau@citrix.com>,
	"asml.silence@gmail.com" <asml.silence@gmail.com>,
	"jlbec@evilplan.org" <jlbec@evilplan.org>
Subject: Re: [dm-devel] [RFC PATCH 02/34] block: introduce and use bio_new
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/28 16:12, Chaitanya Kulkarni wrote:
> Introduce bio_new() helper and use it in blk-lib.c to allocate and
> initialize various non-optional or semi-optional members of the bio
> along with bio allocation done with bio_alloc(). Here we also calmp the
> max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  block/blk-lib.c     |  6 +-----
>  include/linux/bio.h | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index fb486a0bdb58..ec29415f00dd 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
>  			sector_t sect, unsigned op, unsigned opf,
>  			unsigned int nr_pages, gfp_t gfp)
>  {
> -	struct bio *new = bio_alloc(gfp, nr_pages);
> +	struct bio *new = bio_new(bdev, sect, op, opf, gfp, nr_pages);
>  
>  	if (bio) {
>  		bio_chain(bio, new);
>  		submit_bio(bio);
>  	}
>  
> -	new->bi_iter.bi_sector = sect;
> -	bio_set_dev(new, bdev);
> -	bio_set_op_attrs(new, op, opf);
> -
>  	return new;
>  }
>  
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c74857cf1252..2a09ba100546 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
>  	if (!is_sync_kiocb(kiocb))
>  		bio->bi_opf |= REQ_NOWAIT;
>  }
> +/**
> + * bio_new -	allcate and initialize new bio
> + * @bdev:	blockdev to issue discard for
> + * @sector:	start sector
> + * @op:		REQ_OP_XXX from enum req_opf
> + * @op_flags:	REQ_XXX from enum req_flag_bits
> + * @max_bvecs:	maximum bvec to be allocated for this bio
> + * @gfp_mask:	memory allocation flags (for bio_alloc)
> + *
> + * Description:
> + *    Allocates, initializes common members, and returns a new bio.
> + */
> +static inline struct bio *bio_new(struct block_device *bdev, sector_t sector,
> +				  unsigned int op, unsigned int op_flags,
> +				  unsigned int max_bvecs, gfp_t gfp_mask)
> +{
> +	unsigned nr_bvec = clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PAGES);
> +	struct bio *bio = bio_alloc(gfp_mask, nr_bvec);

I think that depending on the gfp_mask passed, bio can be NULL. So this should
be checked.

> +
> +	bio_set_dev(bio, bdev);
> +	bio->bi_iter.bi_sector = sector;
> +	bio_set_op_attrs(bio, op, op_flags);

This function is obsolete. Open code this.

> +
> +	return bio;
> +}
>  
>  #endif /* __LINUX_BIO_H */
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

