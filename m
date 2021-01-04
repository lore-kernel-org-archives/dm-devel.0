Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986C5C433DB
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:05:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 185112068D
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 19:05:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 185112068D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-3U4GGveLOaSSzGp4r1A7BA-1; Mon, 04 Jan 2021 14:05:32 -0500
X-MC-Unique: 3U4GGveLOaSSzGp4r1A7BA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23FAA8049C1;
	Mon,  4 Jan 2021 19:05:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0378861F20;
	Mon,  4 Jan 2021 19:05:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE8C018087F1;
	Mon,  4 Jan 2021 19:05:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104J3OAJ021845 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 14:03:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 700172026D47; Mon,  4 Jan 2021 19:03:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EA312026D76
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 19:03:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06E988007D9
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 19:03:22 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-1-Sf2yRW_wNxuDs4ky0ZpSXA-1; Mon, 04 Jan 2021 14:03:17 -0500
X-MC-Unique: Sf2yRW_wNxuDs4ky0ZpSXA-1
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	104Iii5I048337; Mon, 4 Jan 2021 19:03:03 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by aserp2130.oracle.com with ESMTP id 35tebanu3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL); Mon, 04 Jan 2021 19:03:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	104IkLJE024624; Mon, 4 Jan 2021 19:03:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
	by aserp3030.oracle.com with ESMTP id 35v4rah92q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Jan 2021 19:03:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 104J2u4u021597;
	Mon, 4 Jan 2021 19:02:57 GMT
Received: from localhost (/67.169.218.210)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Mon, 04 Jan 2021 11:02:56 -0800
Date: Mon, 4 Jan 2021 11:02:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Message-ID: <20210104190254.GB6919@magnolia>
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
	<CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
	<20210104104159.74236-3-selvakuma.s1@samsung.com>
	<BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999
	mlxscore=0 bulkscore=0
	suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101040120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9854
	signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
	phishscore=0
	priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1011 bulkscore=0
	lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
	malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2101040120
X-MIME-Autoconverted: from 8bit to quoted-printable by aserp2130.oracle.com id
	104Iii5I048337
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 104J3OAJ021845
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"javier.gonz@samsung.com" <javier.gonz@samsung.com>,
	"hch@lst.de" <hch@lst.de>, "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v4 2/3] block: add simple copy support
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

SelvaKumar S: This didn't show up on dm-devel, sorry for the OT reply...

On Mon, Jan 04, 2021 at 12:47:11PM +0000, Damien Le Moal wrote:
> On 2021/01/04 19:48, SelvaKumar S wrote:
> > Add new BLKCOPY ioctl that offloads copying of one or more sources
> > ranges to a destination in the device. Accepts copy_ranges that contain=
s
> > destination, no of sources and pointer to the array of source
> > ranges. Each range_entry contains start and length of source
> > ranges (in bytes).
> >=20
> > Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> > bio with control information as payload and submit to the device.
> > REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted
> > to zoned device.
> >=20
> > If the device doesn't support copy or copy offload is disabled, then
> > copy is emulated by allocating memory of total copy size. The source
> > ranges are read into memory by chaining bio for each source ranges and
> > submitting them async and the last bio waits for completion. After data
> > is read, it is written to the destination.
> >=20
> > bio_map_kern() is used to allocate bio and add pages of copy buffer to
> > bio. As bio->bi_private and bio->bi_end_io is needed for chaining the
> > bio and over written, invalidate_kernel_vmap_range() for read is called
> > in the caller.
> >=20
> > Introduce queue limits for simple copy and other helper functions.
> > Add device limits as sysfs entries.
> > =09- copy_offload
> > =09- max_copy_sectors
> > =09- max_copy_ranges_sectors
> > =09- max_copy_nr_ranges
> >=20
> > copy_offload(=3D 0) is disabled by default.
> > max_copy_sectors =3D 0 indicates the device doesn't support native copy=
.
> >=20
> > Native copy offload is not supported for stacked devices and is done vi=
a
> > copy emulation.
> >=20
> > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > Signed-off-by: Javier Gonz=E1lez <javier.gonz@samsung.com>
> > ---
> >  block/blk-core.c          |  94 ++++++++++++++--
> >  block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++
> >  block/blk-merge.c         |   2 +
> >  block/blk-settings.c      |  10 ++
> >  block/blk-sysfs.c         |  50 +++++++++
> >  block/blk-zoned.c         |   1 +
> >  block/bounce.c            |   1 +
> >  block/ioctl.c             |  43 ++++++++
> >  include/linux/bio.h       |   1 +
> >  include/linux/blk_types.h |  15 +++
> >  include/linux/blkdev.h    |  13 +++
> >  include/uapi/linux/fs.h   |  13 +++

This series should also be cc'd to linux-api since you're adding a new
userspace api.

Alternately, save yourself the trouble of passing userspace API review
by hooking this up to the existing copy_file_range call in the vfs.  /me
hopes you sent blktests to check the operation of this thing, since none
of the original patches made it to this list.

If you really /do/ need a new kernel call for this, then please send in
a manpage documenting the fields of struct range_entry and copy_range,
and how users are supposed to use this.

<now jumping to the ioctl definition because Damien already reviewed the
plumbing...>

> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index f44eb0a04afd..5cadb176317a 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -64,6 +64,18 @@ struct fstrim_range {
> >  =09__u64 minlen;
> >  };
> > =20
> > +struct range_entry {
> > +=09__u64 src;

Is this an offset?  Or the fd of an open bdev?

> > +=09__u64 len;
> > +};
> > +
> > +struct copy_range {
> > +=09__u64 dest;
> > +=09__u64 nr_range;
> > +=09__u64 range_list;

Hm, I think this is a pointer?  Why not just put the range_entry array
at the end of struct copy_range?

> > +=09__u64 rsvd;

Also needs a flags argument so we don't have to add BLKCOPY2 in like 3
months.

--D

> > +};
> > +
> >  /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl defin=
itions */
> >  #define FILE_DEDUPE_RANGE_SAME=09=090
> >  #define FILE_DEDUPE_RANGE_DIFFERS=091
> > @@ -184,6 +196,7 @@ struct fsxattr {
> >  #define BLKSECDISCARD _IO(0x12,125)
> >  #define BLKROTATIONAL _IO(0x12,126)
> >  #define BLKZEROOUT _IO(0x12,127)
> > +#define BLKCOPY _IOWR(0x12, 128, struct copy_range)
> >  /*
> >   * A jump here: 130-131 are reserved for zoned block devices
> >   * (see uapi/linux/blkzoned.h)
> >=20
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research
>=20
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

