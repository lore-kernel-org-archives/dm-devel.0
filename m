From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH resend] dm zoned: remove duplicated nr_rnd_zones
 increasement
Date: Wed, 25 Mar 2020 02:23:24 +0000
Message-ID: <CO2PR04MB2343A87740F1201B0DA3EAE2E7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200324132245.27843-1-bob.liu@oracle.com>
 <20200325010157.62A0220719@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sashal@kernel.org>, Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: dm-devel.ids

On 2020/03/25 10:02, Sasha Levin wrote:=0A=
> Hi=0A=
> =0A=
> [This is an automated email]=0A=
> =0A=
> This commit has been processed because it contains a "Fixes:" tag=0A=
> fixing commit: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device =
target").=0A=
> =0A=
> The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.1=
4.174.=0A=
> =0A=
> v5.5.11: Build OK!=0A=
> v5.4.27: Failed to apply! Possible dependencies:=0A=
>     5eac3eb30c9a ("block: Remove partition support for zoned block device=
s")=0A=
>     6c1b1da58f8c ("block: add zone open, close and finish operations")=0A=
>     7fc8fb51a143 ("null_blk: clean up report zones")=0A=
>     ad512f2023b3 ("scsi: sd_zbc: add zone open, close, and finish support=
")=0A=
>     c7a1d926dc40 ("block: Simplify REQ_OP_ZONE_RESET_ALL handling")=0A=
>     c98c3d09fca4 ("block: cleanup the !zoned case in blk_revalidate_disk_=
zones")=0A=
>     ceeb373aa6b9 ("block: Simplify report zones execution")=0A=
>     d41003513e61 ("block: rework zone reporting")=0A=
>     d9dd73087a8b ("block: Enhance blk_revalidate_disk_zones()")=0A=
>     dd85b4922de1 ("null_blk: return fixed zoned reads > write pointer")=
=0A=
>     e3f89564c557 ("null_blk: clean up the block device operations")=0A=
> =0A=
> v4.19.112: Failed to apply! Possible dependencies:=0A=
>     515ce6061312 ("scsi: sd_zbc: Fix sd_zbc_report_zones() buffer allocat=
ion")=0A=
>     5f832a395859 ("scsi: sd_zbc: Fix sd_zbc_check_zones() error checks")=
=0A=
>     a2d6b3a2d390 ("block: Improve zone reset execution")=0A=
>     a91e138022bc ("block: Introduce blkdev_nr_zones() helper")=0A=
>     bd976e527259 ("block: Kill gfp_t argument of blkdev_report_zones()")=
=0A=
>     bf5054569653 ("block: Introduce blk_revalidate_disk_zones()")=0A=
>     d2e428e49eec ("scsi: sd_zbc: Reduce boot device scan and revalidate t=
ime")=0A=
>     d41003513e61 ("block: rework zone reporting")=0A=
>     e76239a3748c ("block: add a report_zones method")=0A=
> =0A=
> v4.14.174: Failed to apply! Possible dependencies:=0A=
>     08e18eab0c57 ("block: add bi_blkg to the bio for cgroups")=0A=
>     30e5e929c7bf ("nvme: don't pass struct nvme_ns to nvme_config_discard=
")=0A=
>     5238dcf4136f ("block: replace bio->bi_issue_stat with bio-specific ty=
pe")=0A=
>     53cfdc10a95d ("blk-throttle: fix null pointer dereference while throt=
tling writeback IOs")=0A=
>     5d47c89f29ea ("dm: clear all discard attributes in queue_limits when =
discards are disabled")=0A=
>     8b904b5b6b58 ("block: Use blk_queue_flag_*() in drivers instead of qu=
eue_flag_*()")=0A=
>     a2d6b3a2d390 ("block: Improve zone reset execution")=0A=
>     b889bf66d001 ("blk-throttle: track read and write request individuall=
y")=0A=
>     bd976e527259 ("block: Kill gfp_t argument of blkdev_report_zones()")=
=0A=
>     bf5054569653 ("block: Introduce blk_revalidate_disk_zones()")=0A=
>     c8b5fd031a30 ("mmc: block: Factor out mmc_setup_queue()")=0A=
>     d41003513e61 ("block: rework zone reporting")=0A=
>     d70675121546 ("block: introduce blk-iolatency io controller")=0A=
>     e447a0151f7c ("zram: set BDI_CAP_STABLE_WRITES once")=0A=
>     ed754e5deeb1 ("nvme: track shared namespaces")=0A=
> =0A=
> =0A=
> NOTE: The patch will not be queued to stable trees until it is upstream.=
=0A=
> =0A=
> How should we proceed with this patch?=0A=
> =0A=
=0A=
Fixing the conflict is simple. Bob or I can do it when Greg processes=0A=
the patch once it is upstream ? Usually Greg sends a notice for such=0A=
patches that do not apply cleanly.=0A=
=0A=
For reference, the fixed up patch for 4.19 is below.=0A=
=0A=
commit 48414897d7fde2c2a561a9f6d4b58b62ccb63e68 (HEAD -> linux-4.19.y)=0A=
Author: Bob Liu <bob.liu@oracle.com>=0A=
Date:   Tue Mar 24 21:22:45 2020 +0800=0A=
=0A=
    dm zoned: remove duplicated nr_rnd_zones increasement=0A=
=0A=
    zmd->nr_rnd_zones was increased twice by mistake.=0A=
    The other place:=0A=
    1131                 zmd->nr_useable_zones++;=0A=
    1132                 if (dmz_is_rnd(zone)) {=0A=
    1133                         zmd->nr_rnd_zones++;=0A=
                                            ^^^=0A=
=0A=
    Cc: stable@vger.kernel.org=0A=
    Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target=
")=0A=
    Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
    Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.=
c=0A=
index 086a870087cf..53eb21343b11 100644=0A=
--- a/drivers/md/dm-zoned-metadata.c=0A=
+++ b/drivers/md/dm-zoned-metadata.c=0A=
@@ -1105,7 +1105,6 @@ static int dmz_init_zone(struct dmz_metadata *zmd, st=
ruct dm_zone *zone,=0A=
=0A=
        if (blkz->type =3D=3D BLK_ZONE_TYPE_CONVENTIONAL) {=0A=
                set_bit(DMZ_RND, &zone->flags);=0A=
-               zmd->nr_rnd_zones++;=0A=
        } else if (blkz->type =3D=3D BLK_ZONE_TYPE_SEQWRITE_REQ ||=0A=
                   blkz->type =3D=3D BLK_ZONE_TYPE_SEQWRITE_PREF) {=0A=
                set_bit(DMZ_SEQ, &zone->flags);=0A=
=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
