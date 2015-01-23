From: Vasily Tarasov <tarasov@vasily.name>
Subject: Re: [PATCH RFCv2 00/10] dm-dedup: device-mapper
 deduplication target
Date: Fri, 23 Jan 2015 11:34:21 -0500
Message-ID: <CAFTzLMNkw3uh-9HRZY+yt_fXbs6rbxNxV5FvOf0QJLzGoCvU1w@mail.gmail.com>
References: <53ffb64b.257e320a.6ec4.2b61@mx.google.com>
	<20150114194315.GA9520@redhat.com>
	<20150115180847.53853d3477b3f668f0db6f46@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150115180847.53853d3477b3f668f0db6f46@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

Akira,

I don't think modern SSDs deduplicate data internally (at least most
of them don't). So, in terms of space, dm-dedup will still be
beneficial for SSDs.

We consider the scenario when data is stored on HDD more common
because HDDs are much larger and can store large datasets. Applying
deduplication to large datasets is somewhat more justified. But, as I
mentioned, some people might want to apply dedup to SSDs as well.
Dm-dedup can be for this as well.

Vasily

On Thu, Jan 15, 2015 at 4:08 AM, Akira Hayakawa <ruby.wktk@gmail.com> wrote:
> Hi,
>
> Just a comment.
>
> If I understand correctly, dm-dedup is a block-level fix-sized chunking
> online deduplication.
> That first splits the incoming request into fixed-sized chunk (the smaller
> the chunk is the more efficient the deduplication is) that's typically 4KB.
>
> My caching driver dm-writeboost also splits requests into 4KB chunks but
> the situations aren't the same.
> I think if the backend (not metadata) storage is HDD, the splitting won't be
> a bottleneck but if it's more fast storage like SSD, it probably will. In my case
> on the other hand, the backend storage is always HDD. That's the difference.
>
> In your paper, you mention that the typical combination of backend/metadata storage
> is HDD/SSD but I think the backend storage nowadays can be SSD. Do you think SSD
> deduplicates the data internally and so dm-dedup will not be used in that case?
>
> As you mention in the future work, variable-length chunking can save metadata but
> more complex data management is needed. However, I think avoiding splitting will
> make sense with SSD backend. And because you compute hashing for each chunk, CPU
> usage is relatively high, so you don't need to worry about the another CPU usage.
>
> - Akira
>
> On Wed, 14 Jan 2015 14:43:15 -0500
> Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> On Thu, Aug 28, 2014 at 06:48:28PM -0400, Vasily Tarasov wrote:
>> > This is a second request for comments for dm-dedup.
>> >
>> > Updates compared to the first submission:
>> >
>> > - code is updated to kernel 3.16
>> > - construction parameters are now positional (as in other targets)
>> > - documentation is extended and brought to the same format as in other targets
>> >
>> > Dm-dedup is a device-mapper deduplication target.  Every write coming to the
>> > dm-dedup instance is deduplicated against previously written data.  For
>> > datasets that contain many duplicates scattered across the disk (e.g.,
>> > collections of virtual machine disk images and backups) deduplication provides
>> > a significant amount of space savings.
>> >
>> > To quickly identify duplicates, dm-dedup maintains an index of hashes for all
>> > written blocks.  A block is a user-configurable unit of deduplication with a
>> > recommended block size of 4KB.  dm-dedup's index, along with other
>> > deduplication metadata, resides on a separate block device, which we refer to
>> > as a metadata device.  Although the metadata device can be on any block
>> > device, e.g., an HDD or its own partition, for higher performance we recommend
>> > to use SSD devices to store metadata.
>> >
>> > Dm-dedup is designed to support pluggable metadata backends.  A metadata
>> > backend is responsible for storing metadata: LBN-to-PBN and HASH-to-PBN
>> > mappings, allocation maps, and reference counters.  (LBN: Logical Block
>> > Number, PBN: Physical Block Number).  Currently we implemented "cowbtree" and
>> > "inram" backends.  The cowbtree uses device-mapper persistent API to store
>> > metadata.  The inram backend stores all metadata in RAM as a hash table.
>> >
>> > Detailed design is described here:
>> >
>> > http://www.fsl.cs.sunysb.edu/docs/ols-dmdedup/dmdedup-ols14.pdf
>> >
>> > Our preliminary experiments on real traces demonstrate that Dmdedup can even
>> > exceed the performance of a disk drive running ext4.  The reasons are that (1)
>> > deduplication reduces I/O traffic to the data device, and (2) Dmdedup
>> > effectively sequentializes random writes to the data device.
>> >
>> > Dmdedup is developed by a joint group of researchers from Stony Brook
>> > University, Harvey Mudd College, and EMC.  See the documentation patch for
>> > more details.
>>
>> Hi,
>>
>> I have quickly browsed through the paper above and have some very
>> basic questions.
>>
>> - What real life workload is really going to benefit from this? Do you
>>   have any numbers for that?
>>
>>   I see one example of storing multiple linux trees in tar format and for
>>   the sequential write case with CBT backend performance has almost halfed
>>   with CBT backend. And we had a dedup ratio of 1.88 (for perfect case).
>>
>>   INRAM numbers I think really don't count because it is not practical to
>>   keep all metadata in RAM. And the case of keeping all data in NVRAM is
>>   still little futuristic.
>>
>>   So this sounds like a too huge a performance penalty to me to be really
>>   useful on real life workloads?
>>
>> - Why did you implement an inline deduplication as opposed to out-of-line
>>   deduplication? Section 2 (Timeliness) in paper just mentioned
>>   out-of-line dedup but does not go into more details that why did you
>>   choose an in-line one.
>>
>>   I am wondering that will it not make sense to first implement an
>>   out-of-line dedup and punt lot of cost to worker thread (which kick
>>   in only when storage is idle). That way even if don't get a high dedup
>>   ratio for a workload, inserting a dedup target in the stack will be less
>>   painful from performance point of view.
>>
>> - You mentioned that random workload will become sequetion with dedup.
>>   That will be true only if there is a single writer, isn't it? Have
>>   you run your tests with multiple writers doing random writes and did
>>   you get same kind of imrovements?
>>
>>   Also on the flip side a seqeuntial file will become random if multiple
>>   writers are overwriting their sequential file (as you always allocate
>>   a new block upon overwrite) and that will hit performance.
>>
>> - What is 4KB chunking? Is it same as saying that block size will be
>>   4KB? If yes, I am concerned that this might turn out to be a performance
>>   bottleneck.
>>
>> Thanks
>> Vivek
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
>
> --
> Akira Hayakawa <ruby.wktk@gmail.com>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
