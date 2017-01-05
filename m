From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: trouble with generic/081
Date: Thu, 5 Jan 2017 12:24:46 -0600
Message-ID: <86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
References: <20161214164314.GA25105@infradead.org>
	<20161215063650.GJ4326@dastard> <20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com
List-Id: dm-devel.ids

(dropping fstests list)

On 1/5/17 4:35 AM, Zdenek Kabelac wrote:
> Dne 5.1.2017 v 00:03 Eric Sandeen napsal(a):
>>
>>
>> On 12/16/16 2:15 AM, Christoph Hellwig wrote:
>>> On Thu, Dec 15, 2016 at 10:16:23AM +0100, Zdenek Kabelac wrote:

...

>>> What XFS did on IRIX was to let the volume manager call into the fs
>>> and shut it down.  At this point no further writes are possible,
>>> but we do not expose the namespace under the mount point, and the
>>> admin can fix the situation with all the normal tools.
>>
>> <late to the party>
>>
>> Is there a need for this kind of call-up when xfs now has the configurable
>> error handling so that it will shut down after X retries or Y seconds
>> of a persistent error?
> 
> 
> We need likely to open  RFE bugzilla  here - and specify how it should
> work when some conditions are met.

We need volume manager people & filesystem people to coordinate a solution,
bugzillas are rarely the best place to do that.  ;)

> Current 'best effort' tries to minimize damage by trying to do a full-stop
> when pool approaches 95% fullness. Which is relatively 'low/small'
> for small sized thin-pool - but there is reasonable big free space
> for commonly sized thin-pool to be able to flush most of page cache
> on disk before things will go crazy.

Sounds like pure speculation. "95%" says nothing about actual space left
vs. actual amount of outstanding buffered IO.

> Now - we could probably detect presence of kernel version and
> xfs/ext4 present features - and change reactions.

Unlikely.  Kernel version doesn't mean anything when distros are
involved.  Many features are not advertised in any way.

> What I expect from this BZ is - how to detect things and what is the
> 'best' thing to do.
> 
> I'm clearly not an expert on all filesystem and all their features -
> but lvm2 needs to work reasonable well across all variants of kernels
> and filesystems - so we cannot say to user - now we require you to
> use the latest 4.10 kernel with these features enabled otherwise all
> your data could be lost.
> 
> We need to know what to do with 3.X kernel, 4.X kernel and present
> features in kernel and how we can detect them in runtime.

Like Mike said, we need to make upstream work, first.

Distros can figure out where to go from there.


Anyway, at this point I'm not convinced that anything but the filesystem
should be making decisions based on storage error conditions.

I think unmounting the filesystem is a terrible idea, and hch & mike
seem to agree.  It's problematic in many ways.

I'm not super keen on shutting down the filesystem, for similar reasons,
but I have a more open mind about that because the implications to the
system are not so severe.

Upstream now has better xfs error handling configurability.  Have you
tested with that?  (for that matter, what thinp test framework exists
on the lvm2/dm side?  We currently have only minimal testing fstests,
to be honest.  Until we have a framework to test against this seems likely
to continue going in theoretical circles.)

-Eric

> Regards
> 
> Zdenek
> 
