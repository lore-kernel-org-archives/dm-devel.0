From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: md: Use new topology calls to indicate alignment and
	I/O sizes
Date: Wed, 24 Jun 2009 11:27:49 -0400
Message-ID: <20090624152748.GA16648@redhat.com>
References: <yq1ws73turf.fsf@sermon.lab.mkp.net>
	<170fa0d20906231444t5432998eo8cc2335c6d4a3a0d@mail.gmail.com>
	<19009.42494.925771.283731@notabene.brown>
	<yq1zlbyrzo9.fsf@sermon.lab.mkp.net>
	<19009.50739.830769.821582@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <19009.50739.830769.821582@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Wed, Jun 24 2009 at  2:22am -0400,
Neil Brown <neilb@suse.de> wrote:

> 
> On Wednesday June 24, martin.petersen@oracle.com wrote:
> > >>>>> "Neil" == Neil Brown <neilb@suse.de> writes:
> > Neil>   But when io_min is larger than physical_block_size, what does it
> > Neil>   mean?  Maybe I just didn't look hard enough for the
> > Neil>   documentation??
> > 
> > Documentation/ABI/testing/sysfs-block.txt
> 
> Ahh, thanks.  I searched for "io_min" not "minimum_io" :-)
> 
> > 
> > The difference is that the io_min parameter can be scaled up by stacking
> > drivers.  For RAID5 you may sit on top of disks with 512 byte physical
> > blocks but I/Os that small will cause MD to perform read-modify-write.
> > So you scale io_min up to whatever makes sense given the chunk size.
> > 
> > Think of physical_block_size as an indicator of physical atomicity for
> > correctness reasons and io_min as the smallest I/O you'd want to issue
> > for performance reasons.
> 
> That correctness/performance distinction is a good one, but is not at
> all clear from the documentation.
> 
> Are you saying that if you tried to write a 512byte sector to a SATA
> drive with 4KB sectors it would corrupt the data?  Or it would fail?
> In either case, the reference to "read-modify-write" in the
> documentation seems misplaced.
> 
> So a write MUST be physical_block_size
> and SHOULD be minimum_io_size
> 
> Now I don't get the difference between "preferred" and "optimal".
> Surely we would always prefer everything to be optimal.
> The definition of "optimal_io_size" from the doco says it is the
> "preferred unit of receiving I/O".  Very confusing.
> 
> What I can see at present is 5 values:
>   logical_block_size
>   physical_block_size
>   minimum_io_size
>   optimal_io_size
>   read_ahead_kb
> and only one distinction: "correctness" vs "performance" aka "MUST" vs
> "SHOULD".  Maybe there is another distinction: "SHOULD" for read and
> "SHOULD" for write.
> 
> Though reading further about the alignment, it seems that the
> physical_block_size isn't really a 'MUST', as having a partition that
> was not properly aligned to a MUST size would be totally broken.
> 
> Is it possible to get more precise definitions of these?
> I would like definitions that make strong statements so I can compare
> these to the actual implementation to see if the implementation is
> correct or not.
> 
> My current thought for raid0 for example is that the only way it
> differs from the max of the underlying devices is that the read-ahead
> size should be N times the max for N drives.  A read_ahead related to
> optimal_io_size ??

Hi Neil,

For some reason I thought you were aware of what Martin had put
together.  I assumed as much given you helped sort out some MD interface
compile fixes in linux-next relative to topology-motivated changes.
Anyway, not your fault that you didn't notice the core topology
support.. It is likely a function of Martin having implemented the MD
bits; you got this topology support "for free"; whereas I was forced to
implement DM's topology support (and a few important changes to the core
infrastructure).

Here is a thread from April that discusses the core of the topology
support:
http://marc.info/?l=linux-ide&m=124058535512850&w=4

This post touches on naming and how userland tools are expected to
consume the topology metrics:
http://marc.info/?t=124055146700007&r=1&w=4

This post talks about the use of sysfs:
http://marc.info/?l=linux-ide&m=124058543713031&w=4


Martin later shared the following with Alasdair and I and it really
helped smooth out my understanding of these new topology metrics (I've
updated it to reflect the current naming of these metrics):

>>>>> "Alasdair" == Alasdair G Kergon <agk@redhat.com> writes:

Alasdair> All I/O to any device MUST be a multiple of the hardsect_size.

Correct.


Alasdair> I/O need not be aligned to a multiple of the hardsect_size.

Incorrect.  It will inevitably be aligned to the hardsect_size but not
necessarily to the physical block size.

Let's stop using the term hardsect_size.  It is confusing.  I have
killed the term.

The logical_block_size (what was called hardsect_size) is the block size
exposed to the operating system by way of the programming interface (ATA
or SCSI Block Commands).  The logical block size is the smallest atomic
unit we can programmatically access on the device.

The physical_block_size is the entity the storage device is using
internally to organize data.  On contemporary disk drives the logical
and physical blocks are both 512 bytes.  But even today we have RAID
arrays whose internal block size is significantly bigger than the
logical ditto.

So far this hasn't been a big issue because the arrays have done a
decent job at masking their internal block sizes.  However, disk drives
don't have that luxury because there's only one spindle and no
non-volatile cache to mask the effect of accessing the device in a
suboptimal fashion.

The performance impact of doing read-modify-write on disk drives is
huge.  Therefore it's imperative that we submit aligned I/O once drive
vendors switch to 4KB physical blocks (no later than 2011).

So we have:

	- hardsect_size = logical_block_size = the smallest unit we can
	  address using the programming interface

	- minimum_io_size = physical_block_size = the smallest unit we
	  can write without incurring read-modify-write penalty

	- optimal_io_size = the biggest I/O we can submit without
	  incurring a penalty (stall, cache or queue full).  A multiple
	  of minimum_io_size.

	- alignment_offset = padding to the start of the lowest aligned
          logical block.

The actual minimum_io_size at the top of the stack may be scaled up (for
RAID5 chunk size, for instance).

Some common cases will be:

Legacy drives:
	- 512-byte logical_block_size (was hardsect_size)
	- 512-byte physical_block_size (minimum_io_size)
	- 0-byte optimal_io_size (not specified, any multiple of
	  minimum_io_size)
        - 0-byte alignment_offset (lowest logical block aligned to a
	  512-byte boundary is LBA 0)

4KB desktop-class SATA drives:
	- 512-byte logical_block_size (was hardsect_size)
        - 4096-byte physical_block_size (minimum_io_size)
        - 0-byte optimal_io_size (not specified, any multiple of
          minimum_io_size)
        - 3584-byte alignment_offset (lowest logical block aligned to a
	  minimum_io_size boundary is LBA 7)

4KB SCSI drives and 4KB nearline SATA:
	- 4096-byte logical_block_size (was hardsect_size)
        - 4096-byte physical_block_size (minimum_io_size)
        - 0-byte optimal_io_size (not specified, any multiple of
          minimum_io_size)
        - 0-byte alignment_offset (lowest logical block aligned to an
	  minimum_io_size boundary is LBA 0)

Example 5-disk RAID5 array:
	- 512-byte logical_block_size (was hardsect_size)
	- 64-Kbyte physical_block_size (minimum_io_size == chunk size)
	- 256-Kbyte optimal_io_size (4 * minimum_io_size == full stripe)
        - 3584-byte alignment_offset (lowest logical block aligned to a
          64-Kbyte boundary is LBA 7)

Alasdair> There is an alignment_offset - of 63 sectors in your
Alasdair> example.  IF this is non-zero, I/O SHOULD be offset to a
Alasdair> multiple of the minimum_io_size plus this alignment_offset.

I/O SHOULD always be submitted in multiples of the alignment_offset.

I/O SHOULD always be aligned on the alignment_offset boundary.

if (bio->bi_sector * logical_block_size) % minimum_io_size == alignment_offset)
   /* I/O is aligned */


> > Neil> 2/ Is it too late to discuss moving the sysfs files out of the
> > Neil> 'queue' subdirectory?  'queue' has a lot of values the are purely
> > Neil> related to the request queue used in the elevator algorithm, and
> > Neil> are completely irrelevant to md and other virtual devices (I look
> > Neil> forward to the day when md devices don't have a 'queue' at all).
> > 
> > These sat under /sys/block/<dev>/topology for a while but there was
> > overlap with the existing queue params and several apps expected to find
> > the values in queue.  Also, at the storage summit several people
> > advocated having the limits in queue instead of introducing a new
> > directory.
> 
> (not impressed with having summits like that in meat-space - they
> exclude people who are not in a position to travel.. Maybe we should
> try on-line summits).
> 
> I think /sys/block/<dev>/topology is an excellent idea (except that
> the word always makes me think of rubber sheets with cups and handles
> - from third year mathematics).  I'd go for "metrics" myself.  Or bdi.
> 
> Yes, some values would be duplicated from 'queue', but we already have
> read_ahead_kb duplicated in queue and bdi.  Having a few more
> duplicated, and then trying to phase out the legacy usage would not be
> a bad idea.
> 
> Actually, the more I think about it the more I like the idea that this
> is all information about the backing device for a filesystem,
> information that is used by the VM and the filesystem to choose
> suitable IO sizes (just like read_ahead_kb).
> So I *really* think it belongs in bdi.
>
> > If you look at the patches that went in through block you'll see that MD
> > devices now have the queue directory exposed in sysfs despite not really
> > having a queue (nor an associated elevator).  To me, it's more a matter
> > of the term "queue" being a misnomer rather than the actual
> > values/functions that are contained in struct request_queue.  I always
> > implicitly read request_queue as request_handling_goo.
> 
> Agreed, the name 'queue' is part of the problem, and 'goo' might work
> better.
> But there is more to it than that.
> Some fields are of interest only to code that has special knowledge
> about the particular implementation.  These fields will be different
> for different types of devices.  nr_request for the elevator,
> chunk_size for a raid array.  This is 'goo'.
> Other fields are truly generic.  'size' 'read_ahead_kb'
> 'hw_sector_size'  are relevant to all devices and needed by some
> filesystems.  This is metrics, or bdi.
> I think the 'particular' and the 'generic' should be in different
> places.
> 
> > 
> > That being said I don't have a problem moving the limits somewhere else
> > if that's what people want to do.  I agree that the current sysfs
> > location for the device limits is mostly a function of implementation
> > and backwards compatibility.
> 
> Who do I have to get on side for you to be comfortable moving the
> various metrics to 'bdi' (leaving legacy duplicates in 'queue' where
> that is necessary) ??  i.e. which people need to want it?

While I agree that adding these generic topology metrics to 'queue' may
not be the perfect place I don't feel 'bdi' really helps userland
understand them any better.  Nor would userland really care.  But I do
agree that 'bdi' is likely a better place.

You had mentioned your goal of removing MD's 'queue' entirely. Well DM
already had that but Martin exposed a minimalist one as part of
preparations for the topology support, see commit:
cd43e26f071524647e660706b784ebcbefbd2e44

This 'bdi' vs 'queue' discussion really stands to cause problems for
userland.  It would be unfortunate to force tools be aware of 2 places.
Rather than "phase out legacy usage" of these brand new topology limits
it would likely be wise to get it right the first time.  Again, I'm OK
with 'queue'; but Neil if you feel strongly about 'bdi' we should get a
patch to Linus ASAP for 2.6.31.

I can take a stab at it now if you don't have time.

We _could_ then backout cd43e26f071524647e660706b784ebcbefbd2e44 too?

Mike
