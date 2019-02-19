From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 0/3] dm snapshot: Improve performance using a
 more fine-grained locking scheme
Date: Tue, 19 Feb 2019 13:04:51 +0200
Message-ID: <425d7efe-ab3f-67be-264e-9c3b6db229bc@arrikto.com>
References: <20181220180651.4879-1-ntsironis@arrikto.com>
	<763dd7f2-b0c2-ea15-004e-d6b95fce79ca@arrikto.com>
	<alpine.LRH.2.02.1902180936350.17098@file01.intranet.prod.int.rdu2.redhat.com>
	<20190218151530.GA7852@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190218151530.GA7852@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On 2/18/19 5:15 PM, Mike Snitzer wrote:
> On Mon, Feb 18 2019 at  9:37am -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> =

>>
>>
>> On Mon, 18 Feb 2019, Nikos Tsironis wrote:
>>
>>> Hello,
>>>
>>> This is a kind reminder for this patch set. I'm bumping this thread to
>>> solicit your feedback. Please let me know what else I may need to do for
>>> these patches to land in the upcoming merge window for 5.1.
>>>
>>> Looking forward to your feedback,
>>>
>>> Nikos
>>
>> I don't know what to do with those patches.
>>
>> The patches make it more complicated, so I can't really say if they are =

>> correct or not.
> =

> As I mentioned to you before: please do the best you can reasoning
> through (and even quantifying on your own) the performance reward these
> patches provide.
> =

> Then we'll need to make a call on risk vs reward.
> =

> Nikos mentioned in another mail on Friday that this dm-snapshot patchset
> is a prereq for more dm-snapshot changes he has.  Nikos, if you could
> forecast what those additional changes to dm-snapshot are that could
> help inform the review process for this initial patchset.

Hello Mike, hello Mikulas,

Thank you both for your feedback.

I understand your desire to ensure the patches continue to maintain the
high level of quality in the kernel and I agree completely. As part of
this effort, I have been contributing to the device mapper test suite,
extending it with a test suite for dm-snapshot. Please see the relevant
Pull Requests [1], [2]. Actually, it was this process of me trying to
understand the current functioning of the code in depth and improve its
testing, which helped me identify some minor dm-snapshot bugs previously
[3], [4].

So, I definitely agree with your effort to maintain high quality for
kernel code;  extending the device mapper test suite was my very first
step in facilitating my own coding process for these patches, and I
would be happy to implement any further suggestions for testing you
may have.

The long-term goal of my current and upcoming patches is to make
dm-snapshot usable with modern, low-latency NVMe devices, make it
scalable on multi-core machines, and reduce its overhead significantly.

I understand a lot of effort has been put to make dm-thin performant,
but we are particularly interested in improving the performance of
dm-snapshot and its usability on modern hardware, because it has distinct
advantages over using dm-thin for our specific use cases:

  * Short-lived snapshots, for consistency, where I/O performance to the
    original device degrades only while the snapshot is active, and
    returns back to its original level after deleting the snapshot

  * Taking a consistent snapshot of any volume, while still being able
    to write to the origin volume, i.e., maintaining the snapshot in an
    external device, independently of the origin, without the need to
    make the original volume a dm-thin device (versus dm-thin=92s external
    origin snapshots)

Actually, we are using dm-snapshot heavily right now for maintaining
ephemeral transient snapshot for backups. This is the only way to have
close to bare metal performance, without dm-thin=92s permanent degradation
(at least until the origin volume is completely overwritten).

So, to give you an overall idea of the end-to-end story and where the
current patch set fits:

My initial performance evaluation of dm-snapshot revealed a big
performance drop, while the snapshot is active; a drop which is not
justified by COW alone. Using fio with blktrace I noticed that the
per-CPU I/O distribution was uneven. Although many threads were doing
I/O, only a couple of the CPUs ended up submitting I/O requests to the
underlying device.

The bottleneck here is kcopyd serializing all I/O. The recent work with
blk-mq towards increasing parallelism of I/O processing in modern
multi-cores is essentially going to waste for any users of kcopyd,
including dm-snapshot, because I/Os are issued only by a single CPU at a
time, the one on which kcopyd=92s thread happens to be running.

So, the first step I took was to redesign kcopyd to prevent I/O
serialization by respecting thread locality for I/Os and their
completion. This made distribution of I/O processing uniform across
CPUs, but then dm-snapshot=92s single mutex prevented it from exploiting
kcopyd=92s improved scalability.

Further investigation revealed that dm-snapshot itself has significant
CPU overhead that increases I/O latency far beyond that of an NVMe
device. As an example, working with an NVMe array capable of 700K write
IOPS with an average latency of ~350us per request, I was seeing 65K
write IOPS with an average latency of ~4ms per request with dm-snapshot.
This was due to lock contention in dm-snapshot itself, even before it
hit kcopyd.

This is where the current patch set fits. Replacing the single mutex
with a fine-grained locking scheme reduces lock contention and enables
dm-snaphsot to scale as the number of threads increases. For all the
details, please see the measurements I include as part of PATCH 3/3.
Also, replacing dm-snapshot's single mutex with fine-grained locking
makes it ready to exploit dm-kcopyd=92s improved design, which I will
introduce in follow-up patches.

Finally, after these two patches, I would like to improve performance
specifically for transient snapshots. In the case of transient snapshots,
there is no need to complete exceptions in order
(commit 230c83afdd9cd - "dm snapshot: avoid snapshot space leak on crash")
or even sequentially. By taking advantage of the new kcopyd design, we
can complete them out-of-order and in parallel. This will also increase
IOPS significantly and slash I/O latency.

So, all in all, my end goal is to bring performance of short-lived
snapshots based on dm-snapshot as close as possible to bare-metal
performance.

To summarize, I see the following progression of patches:

  * Scale dm-snapshot (current patch set)
  * Scale kcopyd
  * Further improve transient snapshots by lifting the limitation of
    in-order and sequential completion

My current measurements show that these patch series lead to an eventual
performance improvement of ~300% increase in sustained throughput and
~80% decrease in I/O latency for transient snapshots, over the null_blk
device. =


Especially for this patch set, please find detailed measurements as part
of PATCH 3/3.

Mike, it would be great, as you say, if you could run the test suite
yourselves, and reproduce the results.

This was a rather long email, but I hope it makes the end-to-end purpose
of these patches clearer, and quantifies the reward in increased
throughput, decreased latency, and improved efficiency of dm-snapshot on
modern hardware.

I would be more than happy to continue the conversation and focus on any
other questions you may have, as you continue with reviewing these
patches.

Thanks,
Nikos.

[1] https://github.com/jthornber/device-mapper-test-suite/pull/51
[2] https://github.com/jthornber/device-mapper-test-suite/pull/52
[3] https://www.redhat.com/archives/dm-devel/2018-October/msg00460.html
[4] https://www.redhat.com/archives/dm-devel/2018-October/msg00461.html
