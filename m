From: Hannes Reinecke <hare@suse.de>
Subject: Infinite recursion when creating devices
Date: Wed, 29 Feb 2012 15:23:03 +0100
Message-ID: <4F4E34C7.7070005@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi all,

I found a nice way of crashing the kernel:

dd if=3D/dev/zero of=3D/tmp/testdisk bs=3D512 count=3D4096
losetup /dev/loop1 /tmp/testdisk
echo '0 4096 linear /dev/loop1 0' | dmsetup create test1
echo '0 4096 linear /dev/dm-0 0' | dmsetup reload test1
dmsetup resume test1
-> Watch the system go up in flames.

The above case can be trivially fixed by eg:

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0e575d1..da46690 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -896,6 +896,12 @@ int bd_link_disk_holder(struct block_device
*bdev, struct g
endisk *disk)
        if (WARN_ON(!disk->slave_dir || !bdev->bd_part->holder_dir))
                goto out_unlock;

+       /* Prevent infinite loops */
+       if (bdev->bd_disk =3D=3D disk) {
+               ret =3D -ELOOP;
+               goto out_unlock;
+       }
+
        holder =3D bd_find_holder_disk(bdev, disk);
        if (holder) {
                holder->refcnt++;

but obviously that doesn't cover the more 'interesting' cases
involving several devices, like

dd if=3D/dev/zero of=3D/tmp/testdisk bs=3D512 count=3D4096
losetup /dev/loop1 /tmp/testdisk
echo '0 4096 linear /dev/loop1 0' | dmsetup create test1
echo '0 4096 linear /dev/dm-0 0' | dmsetup create test2
echo '0 4096 linear /dev/dm-1 0' | dmsetup create test3
echo '0 4096 linear /dev/dm-2 0' | dmsetup reload test1
dmsetup resume test1

For these cases we probably don't have any better chance
then fixing things ex-post, eg proper loop detection in each and
every interaction.

Anyone a better idea?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
