From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: trouble with generic/081
Date: Thu, 5 Jan 2017 11:35:47 +0100
Message-ID: <a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
References: <20161214164314.GA25105@infradead.org>
	<20161215063650.GJ4326@dastard> <20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com, fstests@vger.kernel.org
List-Id: dm-devel.ids

Dne 5.1.2017 v 00:03 Eric Sandeen napsal(a):
>
>
> On 12/16/16 2:15 AM, Christoph Hellwig wrote:
>> On Thu, Dec 15, 2016 at 10:16:23AM +0100, Zdenek Kabelac wrote:
>>> So let me explain the logic behind this 'amazingly stupid' idea.
>>
>> And that logic doesn't make any sense at all.  invibly unmounting
>> a file system behind the users back is actively harmful, as it is
>> contradicting the principle of least surprise, and the xfstests mess
>> is one simple example for it.  Add a callback in-kernel to tell the
>> fs to shut down but NOT unmount and expose the namespace below it,
>> which the administrator has probably intentionally hid.
>>
>> Even worse unmount may trigger further writes and with fses not
>> handling them the fs might now be stuck after being detached from
>> the namespace without a way for the admin to detect or recover this.
>>
>> What XFS did on IRIX was to let the volume manager call into the fs
>> and shut it down.  At this point no further writes are possible,
>> but we do not expose the namespace under the mount point, and the
>> admin can fix the situation with all the normal tools.
>
> <late to the party>
>
> Is there a need for this kind of call-up when xfs now has the configurable
> error handling so that it will shut down after X retries or Y seconds
> of a persistent error?


We need likely to open  RFE bugzilla  here - and specify how it should
work when some conditions are met.

Current 'best effort' tries to minimize damage by trying to do a full-stop
when pool approaches 95% fullness.  Which is relatively 'low/small' for small 
sized thin-pool - but there is reasonable big free space for
commonly sized thin-pool to be able to flush most of page cache on
disk before things will go crazy.

Now - we could probably detect presence of kernel version and xfs/ext4 present 
features - and change reactions.

What I expect from this BZ is -  how to detect things and what is the 'best' 
thing to do.

I'm clearly not an expert on all filesystem and all their features - but lvm2
needs to work reasonable well across all variants of kernels and filesystems - 
  so we cannot say to user - now  we require you to use the latest 4.10
kernel with these features enabled otherwise all your data could be lost.

We need to know what to do with 3.X  kernel,  4.X kernel and present features 
in kernel and how we can detect them in runtime.

Regards

Zdenek
