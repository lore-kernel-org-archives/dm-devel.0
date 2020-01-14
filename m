From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm writecache: SB remove seq_count
Date: Tue, 14 Jan 2020 09:50:20 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001140943090.15105@file01.intranet.prod.int.rdu2.redhat.com>
References: <598c7c64-9b11-3407-2060-8d43b1ef1241@petasan.org>
	<d76f7245-034c-f225-00fe-f33c5e9abf1a@petasan.org>
	<alpine.LRH.2.02.2001021144450.18253@file01.intranet.prod.int.rdu2.redhat.com>
	<a858b409-d3d5-b439-5f15-563fb5316d2a@petasan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a858b409-d3d5-b439-5f15-563fb5316d2a@petasan.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Maged Mokhtar <mmokhtar@petasan.org>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>
List-Id: dm-devel.ids



On Mon, 13 Jan 2020, Maged Mokhtar wrote:

> 
> 
> > Hi
> > 
> > 
> > On Thu, 2 Jan 2020, Maged Mokhtar wrote:
> > 
> > > Any feedback on this patch please.
> > 
> > This will definitely not work for persistent memory - it could corrupt
> > data if a crash happens. The CPU can flush data in arbitrary order and it
> > may happen that the seq count is flushed before the pertaining data.
> > 
> > As for SSD mode - we could avoid updating the refcount in the superblock,
> > but it wouldn't be much helpful.
> > 
> > I.e. normally, commit is done this way:
> > 1. submit data writes
> > 2. submit metadata writes
> > 3. flush disk cache
> > 4. submit the write of superblock with increased seq_count
> > 5. flush disk cache
> > 
> > If we wanted to avoid writing the seq_count, we would need to change it
> > to:
> > 1. submit data writes
> > 2. flush disk cache
> > 3. submit metadata writes
> > 4. flush disk cache
> > 
> > - i.e. it sill needs two disk cache flushes per one commit request - and
> > it is not much better than the existing solution.
> > 
> > Mikulas
> > 
> 
> 
> Hi Mikulas,
> 
> I appreciate your review. For SSD mode, I see the advantages of SB writes for
> handling crash recovery and agree with what you say. Note however that after a
> crash a proper client should not assume the data is valid on a device, only at
> the point it last issued a successful flush should the data be consistent,

Yes.

> after this it should not assume so. A filesystem/db should handle
> journals/transaction at a higher level than the device. But again anything we
> can do on the device/target to make things more consistent, the better, so i
> agree there.
> 
> There is also limit to what the current crash recovery code can do, as i
> understand it if you have metadata already committed, their seq count is not
> incremented for new io on the same blocks, the crash recovery code will
> therefore not detect or recover cases where new data is written to existing 4k
> blocks at the time of crash, some blocks will end up with new data, others
> will not. Again this is my understanding so i could be wrong.

If the userspace writes some block, it is unspecified if the block will 
contain old data or new data after a crash. (the SCSI standard at some 
point even specified that the written block may contain arbitrary data - 
not just old or new).

> I think if crash consistency needs to be enhanced, it should take into account
> that most consumer/non-enterprise SSDs do not offer power loss protection. For

Both SATA and SCSI standard have command that flushes the cache in the 
disk or SSD. If the SSD ignores this command, it is broken.

> many such devices power loss can corrupt data that is already written as they
> commit data in larger chunks via a read/modify/erase/write cycle. It is
> particularly bad for metadata as it could affect many data blocks. Maybe it
> could be good to have metadata writes via transactions or journaling, dm-cache
> and thin provisioning do something like this i think.

Both dm-cache and dm-writecache use the flush command to write the device 
cache.

> i also think your suggestion of:
> > If we wanted to avoid writing the seq_count, we would need to change it
> > to:
> > 1. submit data writes
> > 2. flush disk cache
> > 3. submit metadata writes
> > 4. flush disk cache
> 
> could be better in terms of prolonging SSD lifetime, as currently the
> superblock gets much higher write frequency.

The SSDs allocate new blocks with each write, so it doesn't matter that we 
write the same block multiple times. With real persistent memory, it may 
be an issue.

> /Maged

Mikulas
