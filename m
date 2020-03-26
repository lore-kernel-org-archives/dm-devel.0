From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag for
 REQ_OP_WRITE_ZEROES
Date: Thu, 26 Mar 2020 16:48:08 +0000
Message-ID: <BYAPR04MB4965C03A4E397333E5141B9086CF0@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <e2b7cbab-d91f-fd7b-de6f-a671caa6f5eb@virtuozzo.com>
 <69c0b8a4-656f-98c4-eb55-2fd1184f5fc9@virtuozzo.com>
 <67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
 <20200319102819.GA26418@infradead.org> <yq1tv2k8pjn.fsf@oracle.com>
 <20200325162656.GJ29351@magnolia> <20200325163223.GA27156@infradead.org>
 <yq1d090jqlm.fsf@oracle.com> <20200326092935.GA6478@infradead.org>
 <yq1lfnngp6l.fsf@oracle.com> <20200326144556.GA4317@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "bob.liu@oracle.com" <bob.liu@oracle.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "song@kernel.org" <song@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "osandov@fb.com" <osandov@fb.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "minwoo.im.dev@gmail.com" <minwoo.im.dev@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "andrea.parri@amarulasolutions.com" <andrea.parri@amarulasolutions.com>, "hare@suse.com" <hare@suse.com>, "tj@kernel.org" <tj@kernel.>
List-Id: dm-devel.ids

On 03/26/2020 07:46 AM, Christoph Hellwig wrote:=0A=
> On Thu, Mar 26, 2020 at 10:34:42AM -0400, Martin K. Petersen wrote:=0A=
>>> I just worry about the proliferation of identical merging and=0A=
>>> splitting code throughout the block stack as we add additional=0A=
>>> single-range, no payload operations (Verify, etc.). I prefer to=0A=
>>> enforce the semantics in the LLD and not in the plumbing. But I=0A=
>>> won't object to a separate REQ_OP_ALLOCATE if you find the=0A=
>>> resulting code duplication acceptable.=0A=
> I find it acceptable for now.  And I think we should find some way=0A=
> (e.g. by being table driven) to share code between differnet=0A=
> opcodes.=0A=
>=0A=
=0A=
With reference to Martin's comment (verify etc) there is a significant=0A=
advantage when using payloadless bio to offload the functionality=0A=
to the directly attached device and over the fabrics when dealing=0A=
with larger disks.=0A=
=0A=
How about we create a helper which is independent of the operations=0A=
can accept req_op and issues the payloadless bios. Something like=0A=
following totally untested :-=0A=
=0A=
diff --git a/block/blk-lib.c b/block/blk-lib.c=0A=
index cf9e75a730b4..d3fccd3211cc 100644=0A=
--- a/block/blk-lib.c=0A=
+++ b/block/blk-lib.c=0A=
@@ -209,6 +209,33 @@ int blkdev_issue_write_same(struct block_device=0A=
*bdev, sector_t sector,=0A=
  }=0A=
  EXPORT_SYMBOL(blkdev_issue_write_same);=0A=
=0A=
+static void __blkdev_issue_payloadless(struct block_device *bdev,=0A=
unsigned op,=0A=
+               sector_t sector, sector_t nr_sects, gfp_t gfp_mask,=0A=
+               struct bio **biop, unsigned bio_opf, unsigned int=0A=
max_sectors)=0A=
+{=0A=
+       struct bio *bio =3D *biop;=0A=
+=0A=
+       while (nr_sects) {=0A=
+               bio =3D blk_next_bio(bio, 0, gfp_mask);=0A=
+               bio->bi_iter.bi_sector =3D sector;=0A=
+               bio_set_dev(bio, bdev);=0A=
+               bio->bi_opf =3D op;=0A=
+               bio->bi_opf |=3D bio_opf;=0A=
+=0A=
+               if (nr_sects > max_sectors) {=0A=
+                       bio->bi_iter.bi_size =3D max_sectors << 9;=0A=
+                       nr_sects -=3D max_sectors;=0A=
+                       sector +=3D max_sectors;=0A=
+               } else {=0A=
+                       bio->bi_iter.bi_size =3D nr_sects << 9;=0A=
+                       nr_sects =3D 0;=0A=
+               }=0A=
+               cond_resched();=0A=
+       }=0A=
+=0A=
+       *biop =3D bio;=0A=
+}=0A=
+=0A=
  static int __blkdev_issue_write_zeroes(struct block_device *bdev,=0A=
                 sector_t sector, sector_t nr_sects, gfp_t gfp_mask,=0A=
                 struct bio **biop, unsigned flags)=0A=
@@ -216,6 +243,7 @@ static int __blkdev_issue_write_zeroes(struct=0A=
block_device *bdev,=0A=
         struct bio *bio =3D *biop;=0A=
         unsigned int max_write_zeroes_sectors;=0A=
         struct request_queue *q =3D bdev_get_queue(bdev);=0A=
+       unsigned int unmap =3D (flags & BLKDEV_ZERO_NOUNMAP) ? REQ_NOUNMAP=
=0A=
: 0;=0A=
=0A=
         if (!q)=0A=
                 return -ENXIO;=0A=
@@ -229,24 +257,8 @@ static int __blkdev_issue_write_zeroes(struct=0A=
block_device *bdev,=0A=
         if (max_write_zeroes_sectors =3D=3D 0)=0A=
                 return -EOPNOTSUPP;=0A=
=0A=
-       while (nr_sects) {=0A=
-               bio =3D blk_next_bio(bio, 0, gfp_mask);=0A=
-               bio->bi_iter.bi_sector =3D sector;=0A=
-               bio_set_dev(bio, bdev);=0A=
-               bio->bi_opf =3D REQ_OP_WRITE_ZEROES;=0A=
-               if (flags & BLKDEV_ZERO_NOUNMAP)=0A=
-                       bio->bi_opf |=3D REQ_NOUNMAP;=0A=
-=0A=
-               if (nr_sects > max_write_zeroes_sectors) {=0A=
-                       bio->bi_iter.bi_size =3D max_write_zeroes_sectors=
=0A=
<< 9;=0A=
-                       nr_sects -=3D max_write_zeroes_sectors;=0A=
-                       sector +=3D max_write_zeroes_sectors;=0A=
-               } else {=0A=
-                       bio->bi_iter.bi_size =3D nr_sects << 9;=0A=
-                       nr_sects =3D 0;=0A=
-               }=0A=
-               cond_resched();=0A=
-       }=0A=
+       __blkdev_issue_payloadless(bdev, REQ_OP_WRITE_ZEROES, sector,=0A=
nr_sects,=0A=
+                       gfp_mask, biop, unmap, max_write_zeroes_sectors);=
=0A=
=0A=
         *biop =3D bio;=0A=
         return 0;=0A=
=0A=
I'll be happy to send out a well tested patch based on the above=0A=
suggestion or any feedback I get and re-spin this series or OP can=0A=
re-spin this series whatever works.=0A=
