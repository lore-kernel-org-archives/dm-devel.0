From: Vasily Tarasov <tarasov@vasily.name>
Subject: Re: [PATCH RFCv2 00/10] dm-dedup: device-mapper
 deduplication target
Date: Fri, 23 Jan 2015 11:27:39 -0500
Message-ID: <CAFTzLMNz6JCa8sndMVjyOvaQsJ_DEL1B=gRL0uL0B-Zmw+tdJA@mail.gmail.com>
References: <53ffb64b.257e320a.6ec4.2b61@mx.google.com>
	<20150114194315.GA9520@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150114194315.GA9520@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

Hi Vivek,

Thanks for reading our paper! Please, find the answers to the issues
you raised inline.

> Hi,
>
> I have quickly browsed through the paper above and have some very
> basic questions.
>
> - What real life workload is really going to benefit from this? Do you
>   have any numbers for that?
>
>   I see one example of storing multiple linux trees in tar format and for
>   the sequential write case with CBT backend performance has almost halfed
>   with CBT backend. And we had a dedup ratio of 1.88 (for perfect case).
>
>   INRAM numbers I think really don't count because it is not practical to
>   keep all metadata in RAM. And the case of keeping all data in NVRAM is
>   still little futuristic.
>
>   So this sounds like a too huge a performance penalty to me to be really
>   useful on real life workloads?

Dm-dedup is designed so that different metadata backends can be
implemented easily. We first implemented Copy-on-Write (COW) backend
because device-mapper already provides a COW-based persistent metadata
library. That library was specifically designed  for various
device-mapper targets to store metadata reliably in a common way.
Using COW library allows us to use a well-tested code that is already
in kernel instead of increasing the code size of our submission.

You're right, however, that COW B-tree exhibits relatively high I/O
overhead which might not be acceptable in some environments. For such
environments, new backends with higher performance will be added in
the future. As an example, we present DTB and INRAM backends in the
paper. INRAM backend is that simple that we even include it in the
submitted patches. We envision it to be used in cases similar to
Intel's pmfs file system (persistent memory file system). Persistent
memory is not that futuristic anymore, IMHO :)

Talking about workloads. Many workloads have uneven performance
profiles, so CBT's cache can adsorb peaks and then flush metadata
during the lower load phases. In many cases, deduplication ratio is
also higher, e.g., file systems that store hundreds of VM disk images,
backups, etc. So, we believe that for many situations CBT backend is
practical.

>
> - Why did you implement an inline deduplication as opposed to out-of-line
>   deduplication? Section 2 (Timeliness) in paper just mentioned
>   out-of-line dedup but does not go into more details that why did you
>   choose an in-line one.
>
>   I am wondering that will it not make sense to first implement an
>   out-of-line dedup and punt lot of cost to worker thread (which kick
>   in only when storage is idle). That way even if don't get a high dedup
>   ratio for a workload, inserting a dedup target in the stack will be less
>   painful from performance point of view.

Both in-line and off-line deduplication approaches have their own
pluses and minuses. Among the minuses of  the off-line approach is
that it requires allocation of extra space to buffer non-deduplicated
writes, re-reading the data from disk when deduplication happens (i.e.
more I/O used). It also complicates space usage accounting and user
might run out of space though deduplication process will discover many
duplicated blocks later.

Our final goal is to support both approaches but for this code
submission we wanted to limit the amount of new code. In-line
deduplication is a core part, around which we can implement off-line
dedup by adding an extra thread that will reuse the same logic as
in-line deduplication.

>
> - You mentioned that random workload will become sequetion with dedup.
>   That will be true only if there is a single writer, isn't it? Have
>   you run your tests with multiple writers doing random writes and did
>   you get same kind of imrovements?
>
>   Also on the flip side a seqeuntial file will become random if multiple
>   writers are overwriting their sequential file (as you always allocate
>   a new block upon overwrite) and that will hit performance.


Even for multiple random writers the workload at the data device level
becomes sequential. The thing is that we allocate blocks on data
device as requests are inserted in the I/O queue, no matter which
process inserts the request.

You're right, however, that as with any log-structured file system,
sequential allocation of data blocks in Dm-dedup leads to
fragmentation. Blocks that belong to the same file, for example, might
not be close if multiple writers wrote these blocks at different
times. Moreover, such fragmentaion is a general problem with any
deduplication system. In fact, if you have an identical chunk that
belongs to two (or more files) in the system, then the file layout is
not sequential for all files but one (or none of the files).

In future, mechanisms for defragmentation can be implemented to
mitigate this effect.

>
> - What is 4KB chunking? Is it same as saying that block size will be
>   4KB? If yes, I am concerned that this might turn out to be a performance
>   bottleneck.

Yes, chunk is a conventional name for a unit of deduplication.
Dm-dedup's user can configure chunk's size with respect to his or her
workload and performance requirements.  Larger chunks generally cause
less metadata and more sequentiality on allocation but lower
deduplication ratio.

Vasily
