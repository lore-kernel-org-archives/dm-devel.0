From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm:for-next 53/58]
 drivers/md/dm-zoned-metadata.c:779:3: error: implicit declaration of
 function 'export_uuid'
Date: Fri, 15 May 2020 09:25:35 +0200
Message-ID: <a1e65e5a-4b23-6c6e-d52f-7bf6eb69e7c8@suse.de>
References: <202005151432.U61i8wOc%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <202005151432.U61i8wOc%lkp@intel.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <lkp@intel.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, dm-devel@redhat.com, kbuild-all@lists.01.org, Bob Liu <bob.liu@oracle.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Mike,

On 5/15/20 8:32 AM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/lin=
ux-dm.git for-next
> head:   6c871f63986b34c7768080259ddf5991c55ee385
> commit: 70978208ec91d798066f4c291bc98ff914bea222 [53/58] dm zoned: metada=
ta version 2
> config: nios2-allyesconfig (attached as .config)
> compiler: nios2-linux-gcc (GCC) 9.3.0
> reproduce:
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sb=
in/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          git checkout 70978208ec91d798066f4c291bc98ff914bea222
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=3D$HOME/0day GCC_VERSION=3D9.3.0 make.cros=
s ARCH=3Dnios2
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
>=20
> All errors (new ones prefixed by >>, old ones prefixed by <<):
>=20
> drivers/md/dm-zoned-metadata.c: In function 'dmz_write_sb':
>>> drivers/md/dm-zoned-metadata.c:779:3: error: implicit declaration of fu=
nction 'export_uuid' [-Werror=3Dimplicit-function-declaration]
> 779 |   export_uuid(sb->dmz_uuid, &zmd->uuid);
> |   ^~~~~~~~~~~
> drivers/md/dm-zoned-metadata.c: In function 'dmz_check_sb':
>>> drivers/md/dm-zoned-metadata.c:1015:3: error: implicit declaration of f=
unction 'import_uuid' [-Werror=3Dimplicit-function-declaration]
> 1015 |   import_uuid(&sb_uuid, sb->dmz_uuid);
> |   ^~~~~~~~~~~
> cc1: some warnings being treated as errors
>=20
> vim +/export_uuid +779 drivers/md/dm-zoned-metadata.c
>=20
>     761=09
>     762=09/*
>     763=09 * Write super block of the specified metadata set.
>     764=09 */
>     765=09static int dmz_write_sb(struct dmz_metadata *zmd, unsigned int =
set)
>     766=09{
>     767=09=09struct dmz_mblock *mblk =3D zmd->sb[set].mblk;
>     768=09=09struct dmz_super *sb =3D zmd->sb[set].sb;
>     769=09=09struct dmz_dev *dev =3D zmd->sb[set].dev;
>     770=09=09sector_t sb_block;
>     771=09=09u64 sb_gen =3D zmd->sb_gen + 1;
>     772=09=09int ret;
>     773=09
>     774=09=09sb->magic =3D cpu_to_le32(DMZ_MAGIC);
>     775=09
>     776=09=09sb->version =3D cpu_to_le32(zmd->sb_version);
>     777=09=09if (zmd->sb_version > 1) {
>     778=09=09=09BUILD_BUG_ON(UUID_SIZE !=3D 16);
>   > 779=09=09=09export_uuid(sb->dmz_uuid, &zmd->uuid);
>     780=09=09=09memcpy(sb->dmz_label, zmd->label, BDEVNAME_SIZE);
>     781=09=09=09export_uuid(sb->dev_uuid, &dev->uuid);
>     782=09=09}
>     783=09
>     784=09=09sb->gen =3D cpu_to_le64(sb_gen);
>     785=09
>     786=09=09/*
>     787=09=09 * The metadata always references the absolute block address=
,
>     788=09=09 * ie relative to the entire block range, not the per-device
>     789=09=09 * block address.
>     790=09=09 */
>     791=09=09sb_block =3D zmd->sb[set].zone->id << zmd->zone_nr_blocks_sh=
ift;
>     792=09=09sb->sb_block =3D cpu_to_le64(sb_block);
>     793=09=09sb->nr_meta_blocks =3D cpu_to_le32(zmd->nr_meta_blocks);
>     794=09=09sb->nr_reserved_seq =3D cpu_to_le32(zmd->nr_reserved_seq);
>     795=09=09sb->nr_chunks =3D cpu_to_le32(zmd->nr_chunks);
>     796=09
>     797=09=09sb->nr_map_blocks =3D cpu_to_le32(zmd->nr_map_blocks);
>     798=09=09sb->nr_bitmap_blocks =3D cpu_to_le32(zmd->nr_bitmap_blocks);
>     799=09
>     800=09=09sb->crc =3D 0;
>     801=09=09sb->crc =3D cpu_to_le32(crc32_le(sb_gen, (unsigned char *)sb=
, DMZ_BLOCK_SIZE));
>     802=09
>     803=09=09ret =3D dmz_rdwr_block(dev, REQ_OP_WRITE, zmd->sb[set].block=
,
>     804=09=09=09=09     mblk->page);
>     805=09=09if (ret =3D=3D 0)
>     806=09=09=09ret =3D blkdev_issue_flush(dev->bdev, GFP_NOIO, NULL);
>     807=09
>     808=09=09return ret;
>     809=09}
>     810=09
>=20
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>=20
This is cause by missing commit d01cd62400b3 ("uuid: Add inline helpers=20
to import / export UUIDs"), which went into 5.7.
Mind to update your tree?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
HRB 36809 (AG N=FCrnberg), Gesch=E4ftsf=FChrer: Felix Imend=F6rffer
