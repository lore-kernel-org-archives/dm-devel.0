From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: trouble with generic/081
Date: Thu, 5 Jan 2017 13:29:33 -0600
Message-ID: <18e7613b-5a83-d802-a38f-35a9a604fdb3@sandeen.net>
References: <20161214164314.GA25105@infradead.org>
	<20161215063650.GJ4326@dastard> <20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
	<577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
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

On 1/5/17 1:13 PM, Zdenek Kabelac wrote:
>> Anyway, at this point I'm not convinced that anything but the filesystem
>> should be making decisions based on storage error conditions.
> 
> So far I'm not convinced  doing nothing is better then trying at least unmount.
> 
> Since doing nothing is known to cause  SEVERE filesystem damages,
> while I've haven't heard about them when 'unmount' is in the field.

I'm pretty sure that's exactly what started this thread.  ;)

Failing IOs should never cause "severe filesystem damage" - that is what
a journaling filesystem is /for/.  Can you explain further?

(A journal may not be replayable on mount if it needs to allocate more
thin blocks on replay and is unable to do so, but hat should just fail
gracefully)

> 
> Users are not happy - but usually filesystem is repairable when new space
> is added. (Note here -  user are using couple LVs and usually have
> some space left to succeed with flush & umount)
> 
>>
>> I think unmounting the filesystem is a terrible idea, and hch & mike
>> seem to agree.  It's problematic in many ways.
> 
> So let's remain core trouble -
> 
> 
> Data-exhausted thinpool allows 'fs' user to write to provisioned
> space - while error-out on non-provisioned/missing.

as expected.

> If the filesystem is not immediately stopped on the 1st. such error
> (like remount-ro does for ext4) it continues to destroy itself to
> major degree 

Again, please provide concrete examples here so we know what you've
seen in this regard.

It's my expectation that a journaling filesystem will make noise,
might shut down, but should never be /damaged/ by IO errors.  If that's
not the case, can you provide a reproducer?

> as after reboot the non-provisioned space may actually
> be there - as user do typically use snapshots - and write requires
> provisioning new space - but old space remains there - as thin volume
> metadata do not point to 'non-existing' block for failed provisioning
> - but the old existing one before error.
> 
> This puts filesystem in rather 'tragical' situation as it reads data
> out of thin volume without knowing how consistent they are - i.e.
> some mixture of old and new data.

I lost you there.  A testcase for this filesystem-destroying
behavior might help me understand.

> I've proposed couple things - i.e.:
> 
> Configurable option that 1st. provisioning error makes ALL further
> 'writes' to thin failing - this solves filesystem repair trouble -
> but was not seen as good idea by Mike as this would complicate logic
> in thinp target.
> 
> We could possibly implement this by remapping tables via lvm - but
> it's not quite easy to provide such feature.> 
> 
> We could actually put 'error' targets instead of thins  - and let filesystem
> deals with it - but still some older XFS basically OOM later without telling
> user a word how bad is that   (seen users with lots of RAM and working for 2 days....) unless user monitors syslog for stream or write errors.
> 
> 
>>
>> I'm not super keen on shutting down the filesystem, for similar reasons,
>> but I have a more open mind about that because the implications to the
>> system are not so severe.
> 
> Yes -   instant 'shutdown' is nice option - expect lot of users
> are not using thin for their root volume - just for some data volume
> (virtual machines), so killing machine is quite major obstruction
> then - unmount is just a tiny bit nicer.

I am not following you at all.  I'm not talking about killing the machine,
I am talking about shutting down the /filesystem/ which has hit errors.
("shutdown" is xfs-speak for ext4's remount-ro, more or less).

> 
> 
>> Upstream now has better xfs error handling configurability.  Have you
>> tested with that?  (for that matter, what thinp test framework exists
>> on the lvm2/dm side?  We currently have only minimal testing fstests,
>> to be honest.  Until we have a framework to test against this seems likely
>> to continue going in theoretical circles.)
> 
> See i.e.  lvm2/tests/shell  subdir

Thx.

-Eric

> Regards
> 
> Zdenek
