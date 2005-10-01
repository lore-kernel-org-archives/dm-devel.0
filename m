From: Eduard Bloch <edi@gmx.de>
Subject: Strange data corruption with RW snapshots
Date: Sat, 1 Oct 2005 13:20:09 +0200
Message-ID: <20051001112009.GC24685@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello people,

I am trying to create a modified KNOPPIX using devmapper RW snapshots
instead of its unionfs solution. The problem is: I get corrupted data
and cannot see where it comes from. The relevant part of setup code
is attached below. The resulting snapshot volume looks ok at the first
glance (dmsetup status) and can be mounted (ext2), the directory tree is
displayed but it returns corruped data on most files. I cannot see the
problem, a simulation with the same setup method in another environment
(kernel 2.6.13) did work as expected. Also Ubuntu uses that method for
their Live CD and there it works as well.

I looked for a good and up-to-date documentation of the snapshot target
but could not find anything. I hope someone can give me a clue, I cannot
see how I could solve the problem now.

# state: KNOPDEV is /dev/cloop, readonly block device and mounted on
# /KNOPPIX, DMSETUP is a static. linked version from devmapper-1.01.04,
# kernel is .2.6.12 (.4 or so)
COW_NAME=3DCOW
CHUNK_SIZE=3D8
SNAPSHOT_NAME=3Dknop_rw
VOL_SIZE=3D$(blockdev --getsize $KNOPDEV)

# create space for the cow data and assign it to a free loop device COWDE=
V
echo | dd bs=3D1 of=3D/ramdisk/$COW_NAME seek=3D`expr 512 \* $VOL_SIZE` c=
ount=3D1 2>/dev/null
for x in /dev/loop* ; do if losetup $x >/dev/null 2>&1 ; then continue ; =
else COWDEV=3D$x ; break ; fi ; done
losetup $COWDEV /ramdisk/$COW_NAME

umount /KNOPPIX
# critical part, no /KNOPPIX/* system tools for now
$DMSETUP mknodes
echo "0 $VOL_SIZE linear /dev/cloop 0" | $DMSETUP create knop_ro

# this was expected to be a workaround, mapping the loop device to a
# devmapper volume. It did also fail when using pure $COWDEV
echo "0 $VOL_SIZE linear $COWDEV 0"    | $DMSETUP create cow

echo "0 $VOL_SIZE snapshot /dev/mapper/knop_ro /dev/mapper/cow p $CHUNK_S=
IZE" | $DMSETUP create $SNAPSHOT_NAME

$DMSETUP mknodes $SNAPSHOT_NAME

#remount
/static/mount /dev/mapper/$SNAPSHOT_NAME /KNOPPIX
# we are back, rewritable
bash
# And this bash command running on /KNOPPIX already fails with obscure
# errors.

Thanks,
Eduard.

--=20
<Getty> LOL die Telefonnummer vom Arbeitsamt M=F6nchengladbach ist echt 4=
04-0?
<Getty> Soll das nen schlechter Scherz sein?
