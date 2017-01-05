From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: trouble with generic/081
Date: Thu, 5 Jan 2017 20:13:08 +0100
Message-ID: <577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
References: <20161214164314.GA25105@infradead.org>
	<20161215063650.GJ4326@dastard> <20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com
List-Id: dm-devel.ids

Dne 5.1.2017 v 19:24 Eric Sandeen napsal(a):
> (dropping fstests list)
>
> On 1/5/17 4:35 AM, Zdenek Kabelac wrote:
>> Dne 5.1.2017 v 00:03 Eric Sandeen napsal(a):
>>>
>>>
>>> On 12/16/16 2:15 AM, Christoph Hellwig wrote:
>>>> On Thu, Dec 15, 2016 at 10:16:23AM +0100, Zdenek Kabelac wrote:
>
> ...
>
>>>> What XFS did on IRIX was to let the volume manager call into the fs
>>>> and shut it down.  At this point no further writes are possible,
>>>> but we do not expose the namespace under the mount point, and the
>>>> admin can fix the situation with all the normal tools.
>>>
>>> <late to the party>
>>>
>>> Is there a need for this kind of call-up when xfs now has the configurable
>>> error handling so that it will shut down after X retries or Y seconds
>>> of a persistent error?
>>
>>
>> We need likely to open  RFE bugzilla  here - and specify how it should
>> work when some conditions are met.
>
> We need volume manager people & filesystem people to coordinate a solution,
> bugzillas are rarely the best place to do that.  ;)

IMHO it's usually better then sending list to vairous list -
we need all facts single place instead of looking them out in lists.


>
>> Current 'best effort' tries to minimize damage by trying to do a full-stop
>> when pool approaches 95% fullness. Which is relatively 'low/small'
>> for small sized thin-pool - but there is reasonable big free space
>> for commonly sized thin-pool to be able to flush most of page cache
>> on disk before things will go crazy.
>
> Sounds like pure speculation. "95%" says nothing about actual space left
> vs. actual amount of outstanding buffered IO.

It's quite similar approach as when the filesystem has reserved some space for 
'root' user - to simply proceed when user exhausted things in fs.


>> Now - we could probably detect presence of kernel version and
>> xfs/ext4 present features - and change reactions.
>
> Unlikely.  Kernel version doesn't mean anything when distros are
> involved.  Many features are not advertised in any way.

Aren'y those 'new' features exposed by  /sysfs in some way ?

>>
>> We need to know what to do with 3.X kernel, 4.X kernel and present
>> features in kernel and how we can detect them in runtime.
>
> Like Mike said, we need to make upstream work, first.
>
> Distros can figure out where to go from there.
>

lvm2 upstream is  'distro' & 'kernel'  independent.

It is designed to COVER-UP known kernel bugs and detect present features.
It's the design purpose of lvm2 and it's KEY feature of lvm2.

So we can't just  'drop' existing users because we like new 4.X kernel so much.
(Yet we may issue a serious WARNING message when user is using something
with bad consequences for him)


> Anyway, at this point I'm not convinced that anything but the filesystem
> should be making decisions based on storage error conditions.

So far I'm not convinced  doing nothing is better then trying at least unmount.

Since doing nothing is known to cause  SEVERE filesystem damages,
while I've haven't heard about them when 'unmount' is in the field.

Users are not happy - but usually filesystem is repairable when new space
is added. (Note here -  user are using couple LVs and usually have
some space left to succeed with flush & umount)

>
> I think unmounting the filesystem is a terrible idea, and hch & mike
> seem to agree.  It's problematic in many ways.

So let's remain core trouble -


Data-exhausted thinpool allows  'fs' user to write to provisioned space - 
while error-out on non-provisioned/missing.

If the filesystem is not immediately stopped on the 1st. such error (like 
remount-ro does for ext4) it continues to destroy itself to major degree  as 
after reboot the non-provisioned space may actually be there  - as user do 
typically use snapshots - and write requires provisioning new space - but old 
space remains there - as thin volume metadata do not point to 'non-existing' 
block for failed provisioning - but the old existing one before error.

This puts  filesystem in rather 'tragical' situation as it reads data out of 
thin volume without knowing how consistent they are - i.e. some  mixture of 
old and new data.

I've proposed couple things - i.e.:

Configurable option that 1st. provisioning error makes ALL further 'writes' to 
thin failing - this solves filesystem repair trouble - but  was not seen as 
good idea by Mike as this would complicate logic in thinp target.

We could possibly implement this by remapping tables via lvm - but it's not
quite easy to provide such feature.


We could actually put 'error' targets instead of thins  - and let filesystem
deals with it - but still some older XFS basically OOM later without telling
user a word how bad is that   (seen users with lots of RAM and working for 2 
days....) unless user monitors syslog for stream or write errors.


>
> I'm not super keen on shutting down the filesystem, for similar reasons,
> but I have a more open mind about that because the implications to the
> system are not so severe.

Yes -   instant 'shutdown' is nice option - expect lot of users
are not using thin for their root volume - just for some data volume (virtual 
machines), so killing machine is quite major obstruction then  - unmount is 
just a tiny bit nicer.


> Upstream now has better xfs error handling configurability.  Have you
> tested with that?  (for that matter, what thinp test framework exists
> on the lvm2/dm side?  We currently have only minimal testing fstests,
> to be honest.  Until we have a framework to test against this seems likely
> to continue going in theoretical circles.)

See i.e.  lvm2/tests/shell  subdir

Regards

Zdenek
