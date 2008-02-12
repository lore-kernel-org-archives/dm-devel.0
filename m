From: Gabriel Barazer <gabriel@oxeva.fr>
Subject: Re: How to Resize Partition
Date: Tue, 12 Feb 2008 17:07:26 +0100
Message-ID: <47B1C43E.601@oxeva.fr>
References: <342d47870802120730h324dff50ic68f58a2fc20a98@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870802120730h324dff50ic68f58a2fc20a98@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 02/12/2008 4:30:38 PM +0100, "Scott Moseman" <scmoseman@gmail.com> wrote:
> This is the original size of my partition, 50GB...
> 
> # df -h | grep mpath
> /dev/mapper/mpath0p1   50G  2.1G   45G   5% /san

50G is the size of the mounted filesystem, not related to the block device

> 
> I increased it to 60GB and am trying to resize.  Through my
> troubleshooting and various attempts, I've increased /dev/sdb1 (NIC),
> /dev/sdc1 (HBA) and /dev/mapper/mpath0p1 (MPIO).
> 
> Disk /dev/sdb: 64.4 GB, 64424509440 bytes
> /dev/sdb1               1       61440    62914544   83  Linux
> 
> Disk /dev/sdc: 64.4 GB, 64424509440 bytes
> /dev/sdc1               1       61440    62914544   83  Linux
> 
> Disk /dev/mapper/mpath0: 64.4 GB, 64424509440 bytes
> /dev/mapper/mpath0p1               1       61440    62914544   83  Linux
> 

Here are the block device size, not related with the filesystem mounted 
on top of it.

> I unmount/mount, reboot, etc and the mounted partition keeps showing
> up as 50GB.  How do I get my additional 10GB?  This is on a CentOS 4.5
> server.

You increased the block device size, but not the filesystem. You only 
have to modify the filesystem to take the extra room added into account.
You didn't mentionned what FS you use. For ext2/3 see tune2fs; for 
reiserfs see resize_reiserfs; for XFS (highly recommended! for this kind 
of usage, except if you are using a cluster FS) use xfs_growfs.

Anyway, the device-mapper is aware of the new size (because acting at 
the block-level), but no dm tool can do anything on data (filesystems) 
above the block layer.

For cluster filesystems, you have to check the docs because you cannot 
modify a filesystem without any locking management (or else you will 
cause a big mess in your data). Or maybe you will have to unmount the 
device to do that.

Gabriel
