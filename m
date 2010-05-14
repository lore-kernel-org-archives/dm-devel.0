From: Paul Raines <raines@nmr.mgh.harvard.edu>
Subject: missing /sys/block/dm-*/queue
Date: Fri, 14 May 2010 12:43:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.1005141234190.24031@gate.nmr.mgh.harvard.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Sorry if this is the wrong contact to ask this

I am running RHEL 5.5 w/ device-mapper-multipath-0.4.7-34.el5

I am trying to tune my disks for better performance with the settings

   echo 2048 > /sys/block/$bdev/queue/read_ahead_kb
   echo 64 > /sys/block/$bdev/queue/nr_requests
   echo deadline > /sys/block/$bdev/queue/scheduler
   echo 8192 > /sys/block/$bdev/queue/max_sectors_kb

On the individual disk when I do this I get a big jump in read 
performance of nearly 2x

# dd if=/dev/sdig bs=1024k of=/dev/null skip=3000 count=3000
3000+0 records in
3000+0 records out
3145728000 bytes (3.1 GB) copied, 13.8672 seconds, 227 MB/s

# dd if=/dev/sdig bs=1024k of=/dev/null skip=9000 count=3000
3000+0 records in
3000+0 records out
3145728000 bytes (3.1 GB) copied, 7.70806 seconds, 408 MB/s

So /dev/sdig is part of a multipath

# ls -l /sys/block/dm-119/slaves/
total 0
lrwxrwxrwx 1 root root 0 May 14 12:14 sdez -> ../../../block/sdez
lrwxrwxrwx 1 root root 0 May 14 12:14 sdif -> ../../../block/sdif

I apply the tuning to both sdez and sdif, however, when I do the
dd read test on the dm device, it is still slow

# dd if=/dev/dm-119 bs=1024k of=/dev/null skip=18000 count=3000
3000+0 records in
3000+0 records out
3145728000 bytes (3.1 GB) copied, 15.1546 seconds, 208 MB/s

Fine, I need to apply the tuning to the dm-119 device itself.  But there
is no queue sub dir in /sys/block/dm-119

# ls /sys/block/dm-119
dev  holders  range  removable  size  slaves  stat  subsystem  uevent


So how do I tune the multipath device itself?

-- 
---------------------------------------------------------------
Paul Raines                email: raines at nmr.mgh.harvard.edu
MGH/MIT/HMS Athinoula A. Martinos Center for Biomedical Imaging
149 (2301) 13th Street     Charlestown, MA 02129	    USA
