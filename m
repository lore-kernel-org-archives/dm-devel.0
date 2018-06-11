From: Mike Snitzer <snitzer@redhat.com>
Subject: [git pull v2] device mapper changes for 4.18
Date: Mon, 11 Jun 2018 15:41:27 -0400
Message-ID: <20180611194126.GA16778@redhat.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180604190922.GA5586@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 04 2018 at  3:09pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Jun 04 2018 at  2:54pm -0400,
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Mon, Jun 4, 2018 at 8:32 AM Mike Snitzer <snitzer@redhat.com> wrote:
> > >
> > > - Export 2 swait symbols for use by the new DM writecache target.
> > 
> > I am *EXTREMELY* unhappy with this.
> > 
> > The swait interface is pure and utter garbage, and I thought we
> > already agreed to just have a big comment telling people not to use
> > them.
> > 
> > That seems to not have happened.
> > 
> > The swait() interfaces are pure and utter garbage because they have
> > absolutely horrid semantics that are very different from normal
> > wait-queues, and there has never been any sign that the swait users
> > are actually valid.
> > 
> > In particular, existing users were using swait because of complete
> > garbage reasons, like the alleged "win" for KVM, which was just
> > because there was only ever one waiter anyway.
> > 
> > Is the new writecache usage really worth it?
> > 
> > Is it even *correct*?
> > 
> > As mentioned, swait semantics are completely buggy, with "swake_up()"
> > not at all approximating a normal wake-up. It only wakes *one* user,
> > so it's more like an exclusive waiter, except it ends up alway
> > sassuming that every waiter is exclusive without any actual marker for
> > that.
> > 
> > End result: the interface has some very subtle races, and I'm not at
> > all convinced that the new writecache code is aware of this.
> > 
> > In particular, I see what appears to be a bug in writecache_map(): it
> > does a writecache_wait_on_freelist(), but it doesn't actually
> > guarantee that it will then use the slot that it was woken up for (it
> > just does a "continue", which might instead do a
> > writecache_find_entry().
> > 
> > So *another* thread that was waiting for a slot will now not be woken
> > up, and the thread that *was* woken up didn't actually use the
> > freelist entry that it was waiting for.
> > 
> > This is *EXACTLY* the kind of code that should not use swait lists.
> > It's buggy, and broken. And it probably works in 99% of all cases by
> > pure luck, so it's hard to debug too.
> > 
> > In other words: I'm not pulling this shit. I want people to be *VERY*
> > aware of how broken swait queues are. You are *not* to use them unless
> > you understand them, and I have yet to find a single person who does.
> > 
> > No way in hell are we exporting that shit.
> 
> Fair enough, we'll get it fixed up to use normal waitqueues for next
> merge window.

Hi Linus,

Mikulas refactored the dm-writecache target to use normal waitqueues
instead of swait.  He also switched to using wake_up_process() based on
your suggestion for the endio usecase.

As such dm-writecache is no longer using swait and has no need for the
2 swait symbols the original submission was looking to export.

I did say I'd resubmit for the next merge window but given how quickly
Mikulas was able to respond to your feedback I'd appreciate it if you'd
consider pulling these DM changes for 4.18.

To ease your review, it should be noted that the split-out patches from
Mikulas (with some tweaks from me) are available here to show the
topmost 3 incremental changes that were folded in since the last
swait-based submission:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-4.18-writecache-splitout

As you can see, I also rebased ontop of Jens' "for-linus" (which you
already pulled) because commit 2a2a4c510b7 ("dm: use
bioset_init_from_src() to copy bio_set") is critical for DM's stability
with 4.18.

All said, please pull, thanks!
Mike

The following changes since commit 2a2a4c510b761e800098992cac61281c86527e5d:

  dm: use bioset_init_from_src() to copy bio_set (2018-06-08 07:06:29 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-4.18/dm-changes-v2

for you to fetch changes up to 48debafe4f2feabcc99f8e2659e80557e3ca6b39:

  dm: add writecache target (2018-06-08 11:59:51 -0400)

----------------------------------------------------------------
- Adjust various DM structure members to improve alignment relative to
  4.18 block's mempool_t and bioset changes.

- Add DM writecache target that offers writeback caching to persistent
  memory or SSD.

- Small DM core error message change to give context for why a DM table
  type transition wasn't allowed.

----------------------------------------------------------------
Mike Snitzer (2):
      dm: report which conflicting type caused error during table_load()
      dm: adjust structure members to improve alignment

Mikulas Patocka (1):
      dm: add writecache target

 Documentation/device-mapper/writecache.txt |   68 +
 drivers/md/Kconfig                         |   11 +
 drivers/md/Makefile                        |    1 +
 drivers/md/dm-bio-prison-v1.c              |    2 +-
 drivers/md/dm-bio-prison-v2.c              |    2 +-
 drivers/md/dm-cache-target.c               |   61 +-
 drivers/md/dm-core.h                       |   38 +-
 drivers/md/dm-crypt.c                      |   26 +-
 drivers/md/dm-ioctl.c                      |    3 +-
 drivers/md/dm-kcopyd.c                     |    3 +-
 drivers/md/dm-region-hash.c                |   13 +-
 drivers/md/dm-thin.c                       |    5 +-
 drivers/md/dm-writecache.c                 | 2305 ++++++++++++++++++++++++++++
 drivers/md/dm-zoned-target.c               |    2 +-
 14 files changed, 2466 insertions(+), 74 deletions(-)
 create mode 100644 Documentation/device-mapper/writecache.txt
 create mode 100644 drivers/md/dm-writecache.c
