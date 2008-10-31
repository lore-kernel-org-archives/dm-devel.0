From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: FW: [PATCH 0/9] dm snapshot: shared exception store
Date: Fri, 31 Oct 2008 21:58:00 +0900
Message-ID: <20081031215729K.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0810310251460.28755@hs20-bc2-1.build.redhat.com>
	<20081031175925U.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0810310753170.8838@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0810310753170.8838@hs20-bc2-1.build.redhat.com>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Fri, 31 Oct 2008 08:27:26 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> > > You have alloc_chunk_buffer in alloc_chunk_buffer. vmalloc can trigger 
> > > writeouts and wait for them, resulting in a deadlock. Try
> > > __vmalloc(size, GFP_NOFS, PAGE_KERNEL)
> > > instead. Or you can use bufio instead of this, see below.
> 
> Oh, now I realized that it should be GFP_NOIO, not GFP_NOFS (both here and 
> in kzalloc). GFP_NOFS causes that the allocator won't reenter filesystem, 
> but it can still wait on IO on pages or swap. GFP_NOIO supresses any IO 
> requests from the allocator.
> 
> Please, also rename brelse and set_buffer_dirty to something else, because 
> these functions already exists in Linux --- they're static in your 
> implementation, but if structure of include files change, you could easily 
> end up including that one that contains brelse and set_buffer_dirty and 
> get an error from conflicting definitions.

They came from Zumastor. I'm too lazy to change these names. Well,
I'll change them later.


> > If dm provides something that can work for the
> > shared-exception-snapshot target, I'd love to use it and dump the
> > home-grown caching code.
> 
> The core dm doesn't provide it now, but my patch (into core dm) does. The 
> patch would be merged one day into core dm.

Well, I can use only things in mainline or things will be surely
merged into mainline.


> > Your solution is fine by me. If an admin removes the origin, all the
> > snapshots of it has to go. It sounds reasonable. Well, if we add a new
> > mechanism for the first option to dm, that might be better.
> 
> I thought about it, but preventing removal of target would affect some 
> other code (for example, dmsetup remove_all command would have to remove 
> targets according to their dependencies), so it'd be better just solve 
> this problem in a target and do not try to change device mapper 
> architecture.

As I said, it would needs lots of changes, let's go with other options.


> > Anyway, I'd like to go with the simplest option. As long as the kernel
> > doesn't crash, I have no complaint.
> > 
> > > You can look at bufio layer, I wrote it for my implementation: 
> > > http://people.redhat.com/mpatocka/patches/kernel/2.6.27/dm-bufio.patch
> > > Bufio does exactly the same thing as your caching, but it is implemented 
> > > in such a way that multiple targets can reuse it. So it could be good to 
> > > use it to reduce code duplication.
> > > 
> > > With bufio, you can hold at most one buffer per thread, more threads can 
> > > hold buffers concurrently. The buffer is accessed with dm_bufio_read 
> > > (reads from disk) or dm_bufio_new (doesn't read from disk, it is expected 
> > > that the caller immediatelly initializes the buffer). After access, it is 
> > > released with dm_bufio_release. dm_bufio_mark_buffer_dirty marks the 
> > > buffer dirty after you modified it and dm_bufio_write_dirty_buffers writes 
> > > dirty buffers. Dirty buffers can be written automatically prior to 
> > > dm_bufio_write_dirty_buffers if there is memory pressure. If you want to 
> > > use it and have some comments on it (or you need some extensions), write 
> > > to me.
> > 
> > As I wrote above, I'm pretty happy to try bufio if it will be merged
> > into mainline. I guess that bufio doesn't update multiple chunks
> > atomically but it's fine. I can work on it later on.
> 
> Well, nothing can update multiple chunks atomically :) The disks only 
> guarantee you that they update 512-byte sector atomically, not even the 
> whole chunk. You have to use journaling or some other method (phase trees, 
> crash counts...) to get atomic updates --- and you can use it with 
> dm-bufio.

As I said in the first submission, I plan to use journaling.
