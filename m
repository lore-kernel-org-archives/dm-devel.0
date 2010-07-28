From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: RAID/block regression starting from 2.6.32, bisected
Date: Wed, 28 Jul 2010 22:16:19 +0400
Message-ID: <4C5073F3.1060406@vlnb.net>
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net> <20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

In recent kernels we are experiencing a problem that in our setup using SCST BLOCKIO backend some BIOs are finished, i.e. the finish callback called for them, with error -EIO. It happens quite often, much more often than one would expect to have an actual IO error. (BLOCKIO backend just converts all incoming SCSI commands to the corresponding block requests.)

After some investigation, we figured out, that, most likely, raid5.c::make_request() for some reason sometimes calls bio_endio() with not BIO_UPTODATE bios.

We bisected it to commit: 

commit a82afdfcb8c0df09776b6458af6b68fc58b2e87b
Author: Tejun Heo <tj@kernel.org>
Date:   Fri Jul 3 17:48:16 2009 +0900

    block: use the same failfast bits for bio and request
    
    bio and request use the same set of failfast bits.  This patch makes
    the following changes to simplify things.
    
    * enumify BIO_RW* bits and reorder bits such that BIOS_RW_FAILFAST_*
      bits coincide with __REQ_FAILFAST_* bits.
    
    * The above pushes BIO_RW_AHEAD out of sync with __REQ_FAILFAST_DEV
      but the matching is useless anyway.  init_request_from_bio() is
      responsible for setting FAILFAST bits on FS requests and non-FS
      requests never use BIO_RW_AHEAD.  Drop the code and comment from
      blk_rq_bio_prep().
    
    * Define REQ_FAILFAST_MASK which is OR of all FAILFAST bits and
      simplify FAILFAST flags handling in init_request_from_bio().
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

After looking at it I can't see how it can lead to the effect we are experiencing. Could anybody comment on this, please? Is it a known problem?

The error can be only reproduced when running RAID 5. The general layout is:

Disks --> RAID5 --> LVM --> BLOCKIO VDISK

The problem is easy to reproduce by forcing the RAID 5 array to re-sync its members, eg just fail out one member and add it back into the array and then generate some IO using dd. In fact, just writing out to the partition table on the exported block device is usually enough to provoke the error.

The complete thread about the topic you can find in http://sourceforge.net/mailarchive/forum.php?thread_name=20100727220110.GF31152%40atlantis.cc.ndsu.nodak.edu&forum_name=scst-devel

If any additional information is needed we would be glad to provide it.

Thanks,
Vlad


