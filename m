From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Review of dm-block-manager.c
Date: Mon, 1 Aug 2011 17:00:32 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108011620590.9983@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is review of dm-block-manager.c:


char buffer_cache_name[32];
sprintf(bm->buffer_cache_name, "dm_block_buffer-%d:%d",
--- it may not fit in 32 bytes.


__wait_block uses TASK_INTERRUPTIBLE sleep and returns error code 
-ERESTARTSYS if interrupted by a signal. But this error code is never 
checked. Consequently, if the process receives a signal, this signal will 
interrupt waiting, and the rest of the buffer management code will 
mistakenly think that the event to wait for happened.
This should be replaced by TASK_UNINTERRUPTIBLE sleep and functions 
__wait_io, __wait_unlocked, __wait_read_lockable, __wait_all_writes, 
__wait_all_io, __wait_clean be changed to return void (because their 
return code is never checked anyway).


The code uses only a spinlock to protect it state. When the spinlock is 
dropped (for example during wait), the buffer may have been reused for 
other purposes, but it is not checked. There is a comment "/* FIXME: Can b 
have been recycled between io completion and here? */" indicating that Joe 
is aware of the problem.


b->write_lock_pending++;
__wait_unlocked(b, &flags);
b->write_lock_pending--;
if (b->where != block)
        goto retry;
If the buffer was reused while we were waiting, b->write_lock_pending was 
already reset to zero (in __transition BS_EMPTY). We decrement it to 
0xffffffff.


Error buffers are linked in error_list and this list is only flushed at a 
specific case (in __wait_flush). If there are many i/o errors (for 
example, the disk is unplugged) and __wait_flush is not called 
sufficiently often, all existing buffers will be moved to error_list and 
then the code deadlocks as there would be no empty or clean buffers.


The code uses fixed-size cache of 4096 buffers and a single process may 
hold more than one buffer. This may deadlock in case of massive 
parallelism --- for example, imagine that 4096 processes come 
concurrently, each process requesting two buffers --- each process 
allocates one buffer and then a deadlock happens, each process is waiting 
for some free buffer that never comes. (this bug existed already the last 
year when I looked at the code)


Mikulas
