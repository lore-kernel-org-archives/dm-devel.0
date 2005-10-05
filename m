From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: Strange data corruption with RW snapshots
Date: Wed, 5 Oct 2005 10:49:30 -0500
Message-ID: <200510051049.31055.kevcorry@us.ibm.com>
References: <20051001112009.GC24685@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051001112009.GC24685@debian>
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

Hi Eduard,

On Sat October 1 2005 6:20 am, Eduard Bloch wrote:
> I am trying to create a modified KNOPPIX using devmapper RW snapshots
> instead of its unionfs solution. The problem is: I get corrupted data
> and cannot see where it comes from. The relevant part of setup code
> is attached below. The resulting snapshot volume looks ok at the first
> glance (dmsetup status) and can be mounted (ext2), the directory tree is
> displayed but it returns corruped data on most files. I cannot see the
> problem, a simulation with the same setup method in another environment
> (kernel 2.6.13) did work as expected. Also Ubuntu uses that method for
> their Live CD and there it works as well.
>
> I looked for a good and up-to-date documentation of the snapshot target
> but could not find anything. I hope someone can give me a clue, I cannot
> see how I could solve the problem now.
>
> # state: KNOPDEV is /dev/cloop, readonly block device and mounted on
> # /KNOPPIX, DMSETUP is a static. linked version from devmapper-1.01.04,
> # kernel is .2.6.12 (.4 or so)
> COW_NAME=COW
> CHUNK_SIZE=8
> SNAPSHOT_NAME=knop_rw
> VOL_SIZE=$(blockdev --getsize $KNOPDEV)
>
> # create space for the cow data and assign it to a free loop device COWDEV
> echo | dd bs=1 of=/ramdisk/$COW_NAME seek=`expr 512 \* $VOL_SIZE` count=1 \
>   2>/dev/null
> for x in /dev/loop* ; do
>    if losetup $x >/dev/null 2>&1 ; then
>       continue
>    else
>       COWDEV=$x
>       break
>    fi
> done
> losetup $COWDEV /ramdisk/$COW_NAME
>
> umount /KNOPPIX
> # critical part, no /KNOPPIX/* system tools for now
> $DMSETUP mknodes
> echo "0 $VOL_SIZE linear /dev/cloop 0" | $DMSETUP create knop_ro

If /dev/cloop is read-only (and apparently unmounted anyway), you shouldn't 
need to create the knop_ro device. You can just use /dev/cloop directly.


> # this was expected to be a workaround, mapping the loop device to a
> # devmapper volume. It did also fail when using pure $COWDEV
> echo "0 $VOL_SIZE linear $COWDEV 0"    | $DMSETUP create cow

This also should not be necessary. What kind of failure do you get if you use 
$COWDEV directly?


> echo "0 $VOL_SIZE snapshot /dev/mapper/knop_ro /dev/mapper/cow p \
>   $CHUNK_SIZE" | $DMSETUP create $SNAPSHOT_NAME

Based on what I mentioned above, this could be:

echo "0 $VOL_SIZE snapshot /dev/cloop $COWDEV p $CHUNK_SIZE" | \
   $DMSETUP create $SNAPSHOT_NAME


> $DMSETUP mknodes $SNAPSHOT_NAME
>
> #remount
> /static/mount /dev/mapper/$SNAPSHOT_NAME /KNOPPIX
> # we are back, rewritable
> bash
> # And this bash command running on /KNOPPIX already fails with obscure
> # errors.

I just ran a similar test (on a 2.6.12 kernel):

# Create loop devices
dd if=/dev/zero of=loop_file0 bs=1M count=1 seek=1024
dd if=/dev/zero of=loop_file1 bs=1M count=1 seek=1024
losetup /dev/loop0 loop_file0
losetup /dev/loop1 loop_file1

# Create filesystem on first loop device and copy some data to it.
mkfs.ext3 /dev/loop0
mount /dev/loop0 /mnt/loop0/
cp -a /usr/src/linux-2.6.12 /mnt/loop0/
umount /mnt/loop0

# Create the snapshot.
echo "0 `blockdev --getsize /dev/loop0` snapshot /dev/loop0 /dev/loop1 p 8" \
   | dmsetup create loop_snap

# Mount the snapshot. Compare data and modify data.
mount /dev/mapper/loop_snap /mnt/loop_snap
cd /mnt/loop_snap
diff -Naur --brief linux-2.6.12 /usr/src/linux-2.6.12
cp -a /usr/src/linux-2.6.11 .
rm -rf linux-2.6.12
diff -Naur --brief linux-2.6.11 /usr/src/linux-2.6.11
cd /

# Unmount the snapshot. Deactivate and reactivate the snapshot. Mount again
# and compare and modify data again.
umount /mnt/loop_snap
dmsetup remove loop_snap
echo "0 `blockdev --getsize /dev/loop0` snapshot /dev/loop0 /dev/loop1 p 8" \
   | dmsetup create loop_snap
mount /dev/mapper/loop_snap /mnt/loop_snap
cd /mnt/loop_snap
diff -Naur --brief linux-2.6.11 /usr/src/linux-2.6.11
rm -rf linux-2.6.11


I have not seen any kind of errors at all. What specific errors are you 
getting? Anything in the kernel log? Can you test again without the extra 
dm-linear devices?

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/
