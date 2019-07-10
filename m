From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [RFC PATCH 1/1] dm: add clone target
Date: Wed, 10 Jul 2019 21:45:22 +0300
Message-ID: <e2b23d5c-0ef2-400b-9697-3fb7899ce3e2@arrikto.com>
References: <20190709141522.29606-1-ntsironis@arrikto.com>
	<20190709141522.29606-2-ntsironis@arrikto.com>
	<a6d47841-fcbc-50b2-724c-082be9e764d1@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a6d47841-fcbc-50b2-724c-082be9e764d1@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>, snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: vkoukis@arrikto.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On 7/10/19 12:28 AM, Heinz Mauelshagen wrote:
> Hi Nikos,
> 
> what is the crucial factor your target offers vs. resynchronizing such a 
> latency distinct
> 2-legged mirror with a read-write snapshot (local, fast exception store) 
> on top, tearing the
> mirror down keeping the local leg once fully in sync and merging the 
> snapshot back into it?
> 
> Heinz
> 

Hi Heinz,

The most significant benefits of dm-clone over the solution you propose
is significantly better performance, no need for extra COW space, no
need to merge back a snapshot, and the ability to skip syncing the
unused space of a file system.

1. In order to ensure snapshot consistency, dm-snapshot needs to
   commit a completed exception, before signaling the completion of the
   write that triggered it to upper layers.

   The persistent exception store commits exceptions every time a
   metadata area is filled or when there are no more exceptions
   in-flight. For a 4K chunk size we have 256 exceptions per metadata
   area, so the best case scenario is one commit per 256 writes. Here I
   assume a write with size equal to the chunk size of dm-snapshot,
   e.g., 4K, so there is no COW overhead, and that we write to new
   chunks, so we need to allocate new exceptions.

   Part of committing the metadata is flushing the cache of the
   underlying device, if there is one. We have seen SSDs which can
   sustain hundreds of thousands of random write IOPS, but they take up
   to 8ms to flush their cache. In such a case, flushing the SSD cache
   every few writes significantly degrades performance.

   Moreover, dm-snapshot forces exceptions to complete in the order they
   were allocated, to avoid snapshot space leak on crash (commit
   230c83afdd9cd). This inserts further latency in exception completions
   and thus user write completions.

   On the other hand, when cloning a device we don't need to be so
   strict and can rely on committing the metadata every time a FLUSH or
   FUA bio is written, or periodically, like dm-thin and dm-cache do.

   dm-clone does exactly that. When a region/chunk is cloned or
   over-written by a write, we just set a bit in the relevant in-core
   bitmap. The metadata are committed once every second or when we
   receive a FLUSH or FUA bio.

   This improves performance significantly and results in increased IOPS
   and reduced latency, especially in cases where flushing the disk
   cache is very expensive.

2. For large devices, e.g. multi terabyte disks, resynchronizing the
   local leg can take a lot of time. If the application running over the
   local device is write-heavy, dm-snapshot will end up allocating a
   large number of exceptions. This increases the number of hash table
   collisions and thus increases the time we need to do a hash table
   lookup.

   dm-snapshot needs to look up the exception hash tables in order to
   service an I/O, so this increases latency and degrades performance.

   On the other hand, dm-clone is just testing a bit to see if a region
   is cloned or not and decides what to do based on that test.

3. With dm-clone there is no need to reserve extra COW space for
   temporarily storing the written data, while the clone device is
   syncing. Nor would one need to worry about monitoring and expanding
   the COW device to prevent it from filling up.

4. With dm-clone there is no need to merge back potentially several
   gigabytes once cloning/syncing completes. We also avoid the relevant
   performance degradation incurred by the merging process. Writes just
   go directly to the clone device.

5. dm-clone implements support for discards, so it can skip
   cloning/syncing the relevant regions. In the case of a large block
   device which contains a filesystem with empty space, e.g. a 2TB
   device containing 500GB of useful data in a filesystem, this can
   significantly reduce the time needed to sync/clone.

This was a rather long email, but I hope it makes the significant
benefits of dm-clone over using dm-snapshot, and our rationale behind
the decision to implement a new target clearer.

I would be more than happy to continue the conversation and focus on any
other questions you may have.

Thanks,
Nikos
