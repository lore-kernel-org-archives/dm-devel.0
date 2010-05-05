From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Snapshot handover working, yippee!,
 was Re:  semop failed for cookie?
Date: Wed, 5 May 2010 11:22:05 -0400
Message-ID: <20100505152204.GB21704@redhat.com>
References: <4BD74F99.8020605@filteredperception.org>
	<20100427223323.GB29708@agk-dp.fab.redhat.com>
	<4BD8C0B2.7020509@filteredperception.org>
	<20100429000045.GF29708@agk-dp.fab.redhat.com>
	<4BD8FDE6.40507@filteredperception.org>
	<20100429162338.GA14077@agk-dp.fab.redhat.com>
	<4BE0FF8B.2070800@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4BE0FF8B.2070800@filteredperception.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Douglas McClendon <dmc.fedora@filteredperception.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, May 05 2010 at  1:18am -0400,
Douglas McClendon <dmc.fedora@filteredperception.org> wrote:

> Ok, so my complaining about code-progress should now be complete.  I
> think I'm back in action.  But the "BUG: lock held when returning to
> user space" still seems like a message you folks wanted yourselves
> to hear.
> 
> After grumbling to myself that fedora doesn't provide a package with
> dmsetup.static, I went ahead and copied all relocatable deps
> (/lib/ld-linux.so.2??) to tmpfs along with dmsetup, using
> LD_LIBRARY_PATH.  I also used --noudevrules and --noudevsync.  Then
> I followed the documentation I found which, for use cases as
> esoteric as mine, might be desirable in snapshot.txt
> 
> https://patchwork.kernel.org/patch/59806/
> 
> I.e. rules for snapshot handover in the general case.  (who knows,
> maybe I'll be the only user of non-snapshot-merge snapshot handover
> for all time) (though technically I guess you can call what I've
> been doing for the last several years to be an alternate form of
> snapshot merging. I.e. where your snapshot base is readonly and you
> are merging both the readonly base and cow to a third writable
> device)
> 
> Anyway, I finally got my stuffs working again, or at least, I have a
> virtual snapshot-as-rootfs being dm-mirror migrated right now.  I
> assume that my loading of a new table, is sufficiently equivalent to
> the dmsetup remove of the old snapshot as described in the above
> link.

Glad to hear snapshot cow handover is working well for you.

> But finally, and the real reason for this message- during this I
> noticed that the aforementioned "BUG:" was not in fact what was
> killing my system.  I.e. I still get that message, though everything
> else appears to work and it appears to be harmless (I hope).
> 
> BUG: lock held when returning to user space!
> 
> dmsetup/865 is leaving the kernel with locks still held!
> 1 lock held by dmsetup/865:
>  #0:   (&journal->j_barrier){+.+...+}, at: [<c056b84d>] jbd2_journal_lock_updates+0xbd/0xc5

This is an ext4 issue that has been fixed upstream, see:
https://bugzilla.redhat.com/show_bug.cgi?id=568503

and it is staged for inclussion in the next kernel (2.6.35):
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commit;h=74a8f0090293696a716c728f9cd484b45083937f
