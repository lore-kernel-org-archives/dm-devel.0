From: lvshuo <testfile82@hotmail.com>
Subject: dmdedup target mkfs.ext3 failed
Date: Wed, 25 Jun 2014 00:59:00 +0000
Message-ID: <BAY182-W133FFDD90BFFAA99DE9704D5190@phx.gbl>
References: <BAY182-W11AC11F417AD568551DD7CD51E0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BAY182-W11AC11F417AD568551DD7CD51E0@phx.gbl>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "tarasov@vasily.name" <tarasov@vasily.name>, "philip.shilane@emc.com" <philip.shilane@emc.com>, "hch@infradead.org" <hch@infradead.org>, "ezk@fsl.cs.sunysb.edu" <ezk@fsl.cs.sunysb.edu>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids


when I user dedup target,

echo "0 8 dedup data_dev=3D/dev/sdb metadata_dev=3D/dev/sdd mdbackend=3Dcow=
btree reconstruct=3Dno" | dmsetup create mydedup

=A0[root@localhost md]# mkfs.ext3  /dev/mapper/mydedup
=A0mke2fs 1.41.12 (17-May-2010)
=A0/dev/mapper/mydedup: Not enough space to build proposed filesystem while=
 setting up superblock
=A0[root@localhost md]#

=A0why the create filesystem failed?  dedup have any problem?


=A0[root@localhost md]# fdisk -l

=A0Disk /dev/sdb: 2147 MB, 2147483648 bytes
=A0255 heads, 63 sectors/track, 261 cylinders
=A0Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
=A0Sector size (logical/physical): 512 bytes / 512 bytes
=A0I/O size (minimum/optimal): 512 bytes / 512 bytes
=A0Disk identifier: 0x00000000


=A0Disk /dev/sdc: 1073 MB, 1073741824 bytes
=A0255 heads, 63 sectors/track, 130 cylinders
=A0Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
=A0Sector size (logical/physical): 512 bytes / 512 bytes
=A0I/O size (minimum/optimal): 512 bytes / 512 bytes
=A0Disk identifier: 0x00000000


=A0Disk /dev/sdd: 8589 MB, 8589934592 bytes
=A0255 heads, 63 sectors/track, 1044 cylinders
=A0 Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
=A0Sector size (logical/physical): 512 bytes / 512 bytes
=A0I/O size (minimum/optimal): 512 bytes / 512 bytes
=A0Disk identifier: 0x00000000

 		 	   		  =
