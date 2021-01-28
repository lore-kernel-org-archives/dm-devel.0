Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE26C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:52:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 30BE764DCE
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:52:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30BE764DCE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-fB_XLFn0MAaPYCPlOxmvNw-1; Thu, 28 Jan 2021 03:51:59 -0500
X-MC-Unique: fB_XLFn0MAaPYCPlOxmvNw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCCD8180A0A0;
	Thu, 28 Jan 2021 08:51:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BBFAC62A24;
	Thu, 28 Jan 2021 08:51:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8DC1B5002F;
	Thu, 28 Jan 2021 08:51:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7SZ2h008806 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:28:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B99652166B2B; Thu, 28 Jan 2021 07:28:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1D0D2166B2A
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:28:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BD7C858284
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:28:33 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-171-7i2YZOIbMKCJoExq936v_g-1; Thu, 28 Jan 2021 02:28:31 -0500
X-MC-Unique: 7i2YZOIbMKCJoExq936v_g-1
IronPort-SDR: 5meZAAXbPsZyMOd9RQOAURE7ue4N8I0GylPazNiN4F+IkU2Nf7CrEdUTmPOyFzJi7zfeggOiiu
	Gt5Od7xhy+yHk7m31eLzfrafTPyIE2+841Tdhjt9RuKfy1UwsAhsaJEc7TrPpyeonTG5OoNRbW
	jYwfp8qY1//btPd2uEMJY+wlNQ6hUZhFAaCgz+oVCXV8JG1R++3gaALgNG32rpHLVCAPpUvSm5
	ZnyqhIjEF7MhfKsrin8SIf9C2tCW+9kugysfCU7OmxJSUh1jT50kH6wLdq3lVUWVW9JSAnaEIT
	sQI=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="268893462"
Received: from mail-sn1nam02lp2053.outbound.protection.outlook.com (HELO
	NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.53])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:27:23 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by BL0PR04MB4852.namprd04.prod.outlook.com (2603:10b6:208:59::33)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15;
	Thu, 28 Jan 2021 07:27:21 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::b880:19d5:c7fe:329d%7]) with mapi id 15.20.3784.017;
	Thu, 28 Jan 2021 07:27:21 +0000
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
Date: Thu, 28 Jan 2021 07:27:21 +0000
Message-ID: <BL0PR04MB6514DBA7EDB8EC87A1C20871E7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
	<20210128071133.60335-3-chaitanya.kulkarni@wdc.com>
	<BL0PR04MB6514C554B4AC96866BC1B16FE7BA9@BL0PR04MB6514.namprd04.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:47a:7b5a:7dfa:1b1e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 98283964-c91e-431c-9fb9-08d8c35e268c
x-ms-traffictypediagnostic: BL0PR04MB4852:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB485290861AB8AD7380809BB0E7BA9@BL0PR04MB4852.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: Hxj4fa4GkcBNNCunfMw7J9/b9iCM3fJznMuhOWkCQfvwJ0NrAIluFKg3+jXWfl1tLzPUJCh7B78dGsB53Gqk1Z2m7MWGTazT/q4pi5bAn+XOAilmmSdZvZ9sqjmQNXhEiTj4kt72t+S3/drX6amXX9FT+FK55adEN2vnuJcgUNqzT4TxQrX+LcNNGQZnWc1Tlo1+uTv04dXECuuh7Tu9LBWclBuE7jek77LbLzIUJdaPhgbGq6L/Pdx0JqnyYF+FEQPM8881yuui+kueEXVoqlzgBqK5vaKAqGJTqa0aBFevZqZNENtO6og/LDPr5d9E1UWTTP7/Da2oTdLL+35iaIOLalRmCHBRvUY6cEGhYxURyVSG+g4j64QtJxsEF71Nji99U+trtgurQXiLlnDTDGxf+MDnSLAb7nLKVPD/4Kml1pvdzPIUKukEtZD2GxrzabB/3418cwibWgs+12obfmiGrBfi16NV2BeC0p+Se0p+BmqHDY/WZr2ITJIpH7HBw28kQg7FWHu0BZbkFGLyZ1vhLckxE+yPI8cR0tXHr+nJtxvmCqxf3bBjfbGb7Q3/k4D1vq2cQ3zlnKpMfEgb0g==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(186003)(66476007)(83380400001)(53546011)(5660300002)(66446008)(316002)(8676002)(71200400001)(66556008)(91956017)(86362001)(64756008)(6506007)(2906002)(66946007)(52536014)(7366002)(7406005)(9686003)(33656002)(110136005)(7416002)(55016002)(54906003)(4326008)(76116006)(7696005)(921005)(8936002)(478600001)(21314003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sgomRkWS3uJS/HM3uKXHylAhoSZM+lVQWdt2dHx9bjA8NQXvXFM6Dfv8MW1A?=
	=?us-ascii?Q?iCsEXvQot8m+wWe1prFL3N6W4X/zd4E4zBQMqtLQEJA5H+WTWLCNwdvng6U5?=
	=?us-ascii?Q?SkD6CC9MBeyZGtVMnjn2C+bStrwfe/6T4Mh4yY7H804uejWxG1MgZhnXTjqp?=
	=?us-ascii?Q?f36HcMhJa8fqBRYTB616pNnmAuoeQyPrXZYwSIUFh1bkSg5h3DWdvFdnge8/?=
	=?us-ascii?Q?O9MCM+eECuYQXcaVSUcc0tBlY9mVO1xLxaHa+pFR3r6GyIUZVhAFKPD8DMJf?=
	=?us-ascii?Q?WqsPp+KkYw2miQ2VWu7CKnb5XE/WZZK8NjFYrO+UvBi0zDKD7ZerGy3ioMo0?=
	=?us-ascii?Q?d5CGojo5bVlNDYR39iusEWUd7T18JfU4UoWDmqvKw9astFDt7GxuiNAHMcX0?=
	=?us-ascii?Q?yyVIMk2hKHQYRROUDYWJXFKFYeCK5lmmjxBt04cM+t3AhLH2tTJ8jpap65/Y?=
	=?us-ascii?Q?8A/ijV/T2IbajTQmqxd38MsAkL8lLy0sB7zTUHpkXikXfHmE6OhpRLxglctK?=
	=?us-ascii?Q?/aViM41m44269sQxLJudPSQx/yzA7+nPRic11ihTWQ2xQYSelMI6oY07tQjC?=
	=?us-ascii?Q?hVnAD1Qaet3As9B+ynly4BGIECf/ZcPbSzc+Oocke/rsdoUZIRCx9A5o9NPg?=
	=?us-ascii?Q?7g0qYPFGa112F08uWlKr8jI4vxPqF3DcPOVvoayIcVqK9XZoqxF6lkGygG5v?=
	=?us-ascii?Q?YJDU5PuEe/Bm7FrQH0EsVCPz9aYpSofnlInNuhSpB7hk8gf+GLuZQe8ZAkA7?=
	=?us-ascii?Q?lLd1unSvvMeP5ssLoUJow6t03g2CrTllNyQmec0sH/jgAMA2cCCp8r8xmKu0?=
	=?us-ascii?Q?Gg+Dly15s3nODQmsmpsV0f+GypiBJPNVpzMiB5Rnrtqy507XVwyx/YdLVrRR?=
	=?us-ascii?Q?7DSFyDH/Gxm1k2D/VzvvIJvHY1LnFzctkrr2UgpR99aD9dEGB6hzTFgdaIQZ?=
	=?us-ascii?Q?nCCmPvdeJum19k9qpYis5Ika8c3StyujyDXHLcdbNXrwFYeKpNzciRcoJEUu?=
	=?us-ascii?Q?eP4u0Tzg0LWQzv92vuaJ8NPyfWg9Lh2zkr0bUa/54WZ0wuoaMHYXuXRE9cLO?=
	=?us-ascii?Q?raOcqCp92WeqiaDleK2EmL+MyhJdBYKk0193myzV8+3E9alBggQTIB9lKXUE?=
	=?us-ascii?Q?7KMBpTg7b29BlR2LscuWM6WzgIjSyYfNWQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98283964-c91e-431c-9fb9-08d8c35e268c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 07:27:21.2324 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /2IrgMXm3pcAMmUWJ3iRNrQ3DcnbFiB1YBVtQXVgzQ2J9zyuh/I6YXHgjhJr8lFi69x2/0yQ3ft/PTFeop9ktQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4852
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10S7SZ2h008806
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/01/28 16:21, Damien Le Moal wrote:
> On 2021/01/28 16:12, Chaitanya Kulkarni wrote:
>> Introduce bio_new() helper and use it in blk-lib.c to allocate and
>> initialize various non-optional or semi-optional members of the bio
>> along with bio allocation done with bio_alloc(). Here we also calmp the
>> max_bvecs for bio with BIO_MAX_PAGES before we pass to bio_alloc().
>>
>> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
>> ---
>>  block/blk-lib.c     |  6 +-----
>>  include/linux/bio.h | 25 +++++++++++++++++++++++++
>>  2 files changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/block/blk-lib.c b/block/blk-lib.c
>> index fb486a0bdb58..ec29415f00dd 100644
>> --- a/block/blk-lib.c
>> +++ b/block/blk-lib.c
>> @@ -14,17 +14,13 @@ struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
>>  			sector_t sect, unsigned op, unsigned opf,
>>  			unsigned int nr_pages, gfp_t gfp)
>>  {
>> -	struct bio *new = bio_alloc(gfp, nr_pages);
>> +	struct bio *new = bio_new(bdev, sect, op, opf, gfp, nr_pages);
>>  
>>  	if (bio) {
>>  		bio_chain(bio, new);
>>  		submit_bio(bio);
>>  	}
>>  
>> -	new->bi_iter.bi_sector = sect;
>> -	bio_set_dev(new, bdev);
>> -	bio_set_op_attrs(new, op, opf);
>> -
>>  	return new;
>>  }
>>  
>> diff --git a/include/linux/bio.h b/include/linux/bio.h
>> index c74857cf1252..2a09ba100546 100644
>> --- a/include/linux/bio.h
>> +++ b/include/linux/bio.h
>> @@ -826,5 +826,30 @@ static inline void bio_set_polled(struct bio *bio, struct kiocb *kiocb)
>>  	if (!is_sync_kiocb(kiocb))
>>  		bio->bi_opf |= REQ_NOWAIT;
>>  }
>> +/**
>> + * bio_new -	allcate and initialize new bio
>> + * @bdev:	blockdev to issue discard for
>> + * @sector:	start sector
>> + * @op:		REQ_OP_XXX from enum req_opf
>> + * @op_flags:	REQ_XXX from enum req_flag_bits
>> + * @max_bvecs:	maximum bvec to be allocated for this bio
>> + * @gfp_mask:	memory allocation flags (for bio_alloc)
>> + *
>> + * Description:
>> + *    Allocates, initializes common members, and returns a new bio.
>> + */
>> +static inline struct bio *bio_new(struct block_device *bdev, sector_t sector,
>> +				  unsigned int op, unsigned int op_flags,
>> +				  unsigned int max_bvecs, gfp_t gfp_mask)
>> +{
>> +	unsigned nr_bvec = clamp_t(unsigned int, max_bvecs, 0, BIO_MAX_PAGES);
>> +	struct bio *bio = bio_alloc(gfp_mask, nr_bvec);
> 
> I think that depending on the gfp_mask passed, bio can be NULL. So this should
> be checked.
> 
>> +
>> +	bio_set_dev(bio, bdev);
>> +	bio->bi_iter.bi_sector = sector;
>> +	bio_set_op_attrs(bio, op, op_flags);
> 
> This function is obsolete. Open code this.

And that also mean that you could remove one argument to bio_new(): combine op
and op_flags into "unsigned int opf"

> 
>> +
>> +	return bio;
>> +}
>>  
>>  #endif /* __LINUX_BIO_H */
>>
> 
> 


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

