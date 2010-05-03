From: Douglas McClendon <dmc.fedora@filteredperception.org>
Subject: Re: semop failed for cookie?
Date: Sun, 02 May 2010 20:36:18 -0500
Message-ID: <4BDE2892.3080705@filteredperception.org>
References: <4BD74F99.8020605@filteredperception.org>
	<20100427223323.GB29708@agk-dp.fab.redhat.com>
	<4BD8C0B2.7020509@filteredperception.org>
	<20100429000045.GF29708@agk-dp.fab.redhat.com>
	<4BD8FDE6.40507@filteredperception.org>
	<20100429162338.GA14077@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100429162338.GA14077@agk-dp.fab.redhat.com>
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

On 04/29/2010 11:23 AM, Alasdair G Kergon wrote:
> On Wed, Apr 28, 2010 at 10:32:54PM -0500, Douglas McClendon wrote:
>> case, literally nothing would happen while both instances were 'live',
>
> If you had no data written to the snapshot or origin while both
> were loaded, you might have got away with it.  But I think the new handover
> code give you a safe and supported mechanism now.
>
> Alasdair

I've got a "BUG" for you-

So, I tried on a nightly soas livecd iso build, booted under qemu 
(should be the same for a rawhide or fedora13 beta i386 livecd iso, 
booted to runlevel 1 (for simplicity sake))

I tried to suspend the snapshot device holding the rootfs, thinking that 
I might be able to do that, then resume the newly created with a new 
name copy of that device, and then resume the rootfs device after 
loading a new table of a mirror of the copy device and the destination 
partition.

But the instant I suspend the snapshot device containing the rootfs 
(dmsetup suspend live-rw), I get-

BUG: lock held when returning to user space!

dmsetup/865 is leaving the kernel with locks still held!
1 lock held by dmsetup/865:
  #0:   (&journal->j_barrier){+.+...+}, at: [<c056b84d>] jbd2_journal_lock_\
updates+0xbd/0xc5

--------------- (manually transcribed) ------------

Now, my first guess as to how to proceed would be to try to get a 
statically linked dmsetup copied into a tmpfs.  Which, given the 
particular target and my lack of enthusiasm for all of this, may take me 
some time to try.  Any other advice?  Note, I could craft some manual 
dmsetup commands to reproduce what I'm trying to do, that would apply to 
any fedora-13/soas livecd iso.  But for the sake of argument, lets 
pretend that all I want to do is to run (dmsetup suspend live-rw ; 
dmsetup resume live-rw) and have the system not fall over dead.

Also, to reiterate again, I got that message in dmesg about a problem 
with the snapshot handover while trying to use my previously working but 
not guaranteed to work 100% method.  But note that method does not 
involve snapshot merging at all, which from the documentation I found 
(perhaps I didn't look in all the right places), is the only place that 
the snapshot handover is related to.

Note, I'm not complaining, as this is very low priority for me, but 
rather just doing my best to explain the issue.

-dmc
