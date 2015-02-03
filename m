From: Vasily Tarasov <tarasov@vasily.name>
Subject: Re: [PATCH RFCv2 00/10] dm-dedup: device-mapper
 deduplication target
Date: Tue, 3 Feb 2015 11:11:07 -0500
Message-ID: <CAFTzLMPZb5t5PiA5MLDPSdhQBj8TkEmLh9CHg+8tVdyWccOnzQ@mail.gmail.com>
References: <53ffb64b.257e320a.6ec4.2b61@mx.google.com>
	<20150114194315.GA9520@redhat.com>
	<CAFTzLMNz6JCa8sndMVjyOvaQsJ_DEL1B=gRL0uL0B-Zmw+tdJA@mail.gmail.com>
	<20150130155639.GA8364@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150130155639.GA8364@redhat.com>
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

Thanks, Vivek. We'll also start working on adding off-line dedup
support to Dmdedup.

Vasily

On Fri, Jan 30, 2015 at 10:56 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Jan 23, 2015 at 11:27:39AM -0500, Vasily Tarasov wrote:
>
> [..]
>> > - Why did you implement an inline deduplication as opposed to out-of-line
>> >   deduplication? Section 2 (Timeliness) in paper just mentioned
>> >   out-of-line dedup but does not go into more details that why did you
>> >   choose an in-line one.
>> >
>> >   I am wondering that will it not make sense to first implement an
>> >   out-of-line dedup and punt lot of cost to worker thread (which kick
>> >   in only when storage is idle). That way even if don't get a high dedup
>> >   ratio for a workload, inserting a dedup target in the stack will be less
>> >   painful from performance point of view.
>>
>> Both in-line and off-line deduplication approaches have their own
>> pluses and minuses. Among the minuses of  the off-line approach is
>> that it requires allocation of extra space to buffer non-deduplicated
>> writes,
>
> Well, that extra space requirement is temporary. So you got to pay the cost
> somewhere. Personally, I will be more than happy to consume more disk
> space when I am writing and not take a hit and let worker threads optimize
> space usage later.
>
>> re-reading the data from disk when deduplication happens (i.e.
>> more I/O used).
>
> Worker threads are supposed to kick in when disk is idle so it might not
> be as big a concern.
>
>> It also complicates space usage accounting and user
>> might run out of space though deduplication process will discover many
>> duplicated blocks later.
>
> Anyway, user needs to plan for extra space. De-dup is not exact science
> and one does not know how much will be the de-dup ratio in a data set.
>
>>
>> Our final goal is to support both approaches but for this code
>> submission we wanted to limit the amount of new code. In-line
>> deduplication is a core part, around which we can implement off-line
>> dedup by adding an extra thread that will reuse the same logic as
>> in-line deduplication.
>
> Ok. I am fine with building both if that makes sense.
>
> I also understand that there are pros/cons to both the approaches. Just
> that given the higt cost of inline dedupe, I am finding it little odd
> that it be implemented first as opposed to offline one.
>
> Anyway, I will spend some time on patches now.
>
> Thanks
> Vivek
>
