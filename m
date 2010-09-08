From: Mikulas Patocka <mpatocka@redhat.com>
Subject: i_size misuses
Date: Wed, 8 Sep 2010 09:32:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1009080833180.16126@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, jaxboe@fusionio.com
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

when reviewing some i_size problem, I searched the kernel for i_size usage 
(the variable should really be written with i_size_write and read with 
i_size_read).

Properly locked direct use of "i_size" inside memory management or 
filesystems may not be a problem, but there are many problems in general 
code outside mm.

The misuses are:
SOUND/SOUND_FIRMWARE.C:l = filp->f_path.dentry->d_inode->i_size;
KERNEL/RELAY.C:buf->dentry->d_inode->i_size = buf->early_bytes;
KERNEL/RELAY.C:buf->dentry->d_inode->i_size += buf->chan->subbuf_size 
-buf->padding[old_subbuf];
DRIVERS/USB/CORE/INODE.C:dev->usbfs_dentry->d_inode->i_size = i_size;
DRIVERS/MTD/DEVICES/BLOCK2MTD.C:dev->mtd.size = 
dev->blkdev->bd_inode->i_size & PAGE_MASK;
DRIVERS/MD/MD.C: many reads of i_size 
DRIVERS/BLOCK/NBD.C: many writes to i_size without i_size_write
DRIVERS/BLOCK/DRBD/DRBD_INT.H: return bdev ? bdev->bd_inode->i_size >> 9 : 0;
DRIVERS/BLOCK/DRBD/DRBD_WRAPPERS.H: mdev->this_bdev->bd_inode->i_size = 
(loff_t)size << 9;
BLOCK/BLK-CORE.C:printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
                bdevname(bio->bi_bdev, b),
                bio->bi_rw,
                (unsigned long long)bio->bi_sector + bio_sectors(bio),
                (long long)(bio->bi_bdev->bd_inode->i_size >> 9));
maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
BLOCK/COMPAT_IOCTL.C: size = bdev->bd_inode->i_size;
return compat_put_u64(arg, bdev->bd_inode->i_size);
BLOCK/IOCTL.C: if (start + len > (bdev->bd_inode->i_size >> 9))
size = bdev->bd_inode->i_size;
return put_u64(arg, bdev->bd_inode->i_size);

The problem with this code is that if you read i_size without i_size_read 
and the size wraps around 32 bits, for example from 0xffffffff to 
0x100000000 , there is a possibility on 32-bit machines to read an invalid 
value (either 0 or 0x1ffffffff). Similarly, if you write i_size without 
i_size_write, the readers can see intermediate invalid values.


The original problem that caused this investigation is the question, how a 
block device driver can change the size of its device. Normal method (used 
in a few drivers, including dm), consists of
mutex_lock(&inode->i_mutex);
i_size_write(inode, new_size);
mutex_unlock(&inode->i_mutex);

This is deadlock-prone, because i_mutex is also held on fsync path. 
Therefore, this deadlock happens: fsync takes i_mutex and issues I/Os, 
block device driver wants to change its size, so it waits on i_mutex, 
the I/Os wait until the device driver did its internal maintenance and 
changed the inode size. The driver doesn't change the size until fsync 
finished.

Jens, as a block maintainer, please think about it and propose some 
specification how to clean this up. Also a clean verifiable rule regarding 
i_size should be specified and the code should be fixed to conform to the 
rule: maybe we could rename i_size to __i_size and ban its using.

Mikulas
