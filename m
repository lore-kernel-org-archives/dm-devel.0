From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH for-3.15 1/3] dm: add era target
Date: Mon, 10 Mar 2014 20:08:14 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1403101739270.28738@file01.intranet.prod.int.rdu2.redhat.com>
References: <1394153248-32217-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1394153248-32217-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Edward Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: Morgan.Mears@netapp.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 6 Mar 2014, Mike Snitzer wrote:

> From: Joe Thornber <ejt@redhat.com>
> 
> dm-era is a target that behaves similar to the linear target.  In
> addition it keeps track of which blocks were written within a user
> defined period of time called an 'era'.  Each era target instance
> maintains the current era as a monotonically increasing 32-bit
> counter.
> 
> Use cases include tracking changed blocks for backup software, and
> partially invalidating the contents of a cache to restore cache
> coherency after rolling back a vendor snapshot.
> 
> dm-era is primarily expected to be paired with the dm-cache target.

Hi

I reviewed dm-era, here is a possible list of bugs:

There is no tracking of in-progress writes. Suppose that this happens:
1) a write is received, era_map sees that metadata_current_marked(era->md, 
   block) is true, so it lets the write through
2) the user sends the checkpoint message
3) the write received in step 1) hits the disk and modifies it
4) the user sends metadata_take_snap message, the write is not in the 
   snapshot, although it modified the disk between steps 2) and 4)
You can use the functions dm_internal_suspend and dm_internal_resume to 
clear in-progress bios - this is lightweight suspend/resume callable only 
from the kernel.

era_destroy calls metadata_close(era->md); without checking that era->md 
is not NULL. This can cause crash if era_destroy is called early in the 
constructor.

era->sectors_per_block should be validated that it is not zero.

There is no write memory barrier between the setting of rpc->result and 
rpc->complete:
                if (r)
                        list_for_each_entry_safe(rpc, tmp, &calls, list)
                                rpc->result = r;
        }

        list_for_each_entry_safe(rpc, tmp, &calls, list) {
                atomic_set(&rpc->complete, 1);
And there is no read memory barrier between the reading of rpc->complete 
and rpc->result:
        wait_event(rpc->wait, atomic_read(&rpc->complete));

        return rpc->result;
You should use completion (include/linux/completion.h) instead of 
rpc->complete and rpc->wait, it simplifies the code and takes care of 
memory barriers.

metadata_space_map_root is not aligned on 64-bit boundary, but it is 
accessed as 64-bit numbers in sm_ll_open_metadata.

Mixing 32-bit and 64-bit current_era (I'm not sure it this is a bug or 
not).

Missing read and write memory barriers around accesses to 
archived_writesets (I'm not sure if this is a bug, but it looks strange).

create_fresh_metadata doesn't free md->tm and md->sm on errors.

format_metadata doesn't undo the effect of create_fresh_metadata if 
write_superblock fails.

superblock_all_zeroes checks the full block for zeroes, although lvm 
zeroes only zeroes 4k at the beginning of a new logical volume.

test_bit and test_and_set_bit take signed integer as a parameter (on some 
architectures the argument is long, on some int), so you must restrict the 
maximum number of blocks to 2^31-1. Or, alternatively, do not use test_bit 
and test_and_set_bit and implement these functions on your own - this will 
allow you to have 64-bit block numbers.

The argument to bitset_size may overflow, it is not checked. If you allow 
64-bit argument to bitset_size, you must also check that the conversion to 
size_t does not overflow.

era_status: /* FIXME: do we need to protect this? */ dm_sm_get_nr_free - 
on 32-bit architectures you need to lock it because 64-bit accesses are 
nonatomic. You can see the implementation of i_size_read and i_size_write 
and do something similar.

era_map doesn't distinguish REQ_FLUSH bios, it should just pass them 
through without accessing bio->bi_iter.bi_sector.


Possible improvements:

atomic64_inc(&md->current_era); - there is no concurrent access to 
current_era, so you can use this to avoid the interlocked instruction:
atomic64_set(&md->current_era, atomic64_read(&md->current_era) + 1)

process_deferred_bios: deferred_lock is never taken from interrupt, so you 
can replace spin_lock_irqsave/spin_unlock_irqrestore with 
spin_lock/spin_unlock.

writeset_test_and_set: test_and_set_bit is interlocked instruction - here, 
no concurrent access happens, so use __test_and_set_bit, which is not 
interlocked. Alternatively - reimplement it if you want 2^31 or more 
blocks - see above.


Mikulas
