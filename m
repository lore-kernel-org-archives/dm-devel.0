From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: more multipath deadlocks -- this time involving memory
Date: Thu, 24 Mar 2005 15:07:47 +0000
Message-ID: <20050324150747.GW19749@agk.surrey.redhat.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A856@SRMANNING.eng.emc.com>
	<1111619402.7024.50.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1111619402.7024.50.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Mar 24, 2005 at 12:10:02AM +0100, christophe varoqui wrote:
> A mempool would have to wait for another release, if at all desirable.

You don't need that in userspace: glibc still supports memory 
pre-allocation the original way (brk) used before mmap was
invented.  Then your code is free to use malloc() within the
amount it pre-allocated and locked - this is how the LVM2 code
dodges userspace memory issues.

The first thing is to re-visit the design and determine which
things *have* to be done inside this tight regime and which things
can be moved outside it and whether it's ever going to be possible
to make it do anything useful.  Everything possible needs to be moved 
ouside.  Logging, for example, can certainly be moved outside 
(e.g. queued asynchronously to another process, perhaps using shmget
- I've never tested this)

Things the LVM2 pvmove experience taught us:
  Pathname lookups are not allowed
  (i.e. it looked impossible to guarantee never blocking
   while converting pathname to inode)
    - this is why dm tables encourage you refer to devices using major:minor
  You can't open any files or block devices: you need to have all the 
    file descriptors you need prepared in advance;
  All reads/writes to block devices must use O_DIRECT;
  If you do have to read a file, you must previously have used the ioctl that turns 
    off its atime updates;
  You cannot write to any files (as you can't disable the update to the inode times)

Scanning for new devices/paths is never going to be able to fit within this
regime so has to be handled separately.

The issue is how to monitor the state of the existing paths in a table within
this regime.
 
Alasdair
-- 
agk@redhat.com
