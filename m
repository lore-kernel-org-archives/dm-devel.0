From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: trouble with generic/081
Date: Mon, 9 Jan 2017 15:22:00 +0100
Message-ID: <15605149-0590-1555-6522-38d2eff69026@redhat.com>
References: <20161215084224.GA14395@infradead.org>
	<c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
	<20161216081523.GA13847@infradead.org>
	<5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
	<577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
	<18e7613b-5a83-d802-a38f-35a9a604fdb3@sandeen.net>
	<7b8fa79f-89f8-bb9a-a2fc-8a3b966a877d@redhat.com>
	<20170105224600.GC4326@dastard> <20170109133919.GB19577@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170109133919.GB19577@infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, Eric Sandeen <sandeen@sandeen.net>, eguan@redhat.com
List-Id: dm-devel.ids

Dne 9.1.2017 v 14:39 Christoph Hellwig napsal(a):
> On Fri, Jan 06, 2017 at 09:46:00AM +1100, Dave Chinner wrote:
>> And my 2c worth on the "lvm unmounting filesystems on error" - stop
>> it, now. It's the wrong thing to do, and it makes it impossible for
>> filesystems to handle the error and recover gracefully when
>> possible.
>
> It's causing way more harm than it helps due to the namespace
> implications.  And we'll have to fix it in the FS for real because
> other storage can run out of space as well.
>


Hi

I can be blind but I still miss some simple things here -


lvm2 will initiate lazy umount of ALL thin devices from a thin-pool
when it gets about 95% fullness  (so it's a bit sooner then 100%
with still some 5% 'free-space'.

This should mostly trigger flushing as much dirty stuff on disk - possibly 
causing even 100% fullness (which is not wanted but unavoidable with todays 
RAM and sizes).

So now - filesystem gets into position of  having ENOSP errors.

I'd expect  XFS switches off  (xfs_shutdown) on this condition.

So it should get into EXACT same state as  is advocated here - do nothing case 
- without invoking 'lazy umount' but significantly later
(so IMHO causing possibly more damage to a user).

So is  'XFS  incapable to handle lazy umount at all in such conditions ?

I really would like to first understand why there is such big hallo effect 
around this - since in my eyes -  lvm2 was designed to operated within
threshold bounds - if the thin-pool volume is out of configured  bounds, lvm2 
is not capable to deliver (resize) more space and it's trying to simply stop 
further operations - so disruption of work was 'intended'.


What I'm getting from this thread is -   this is unwanted and user wish to 
continue use thin-pool further with possible damages to their data set - and
lvm2 WILL provide configurable settings for this.

I'm not disputing this part AT ALL  - just to make it really clear.


But could anyone from XFS specify -  why  umount is causing some 'more' 
damage, then  no umount at all ?

With my naive thinking - I'd just assume I hit 'xfs_shutdown' rather earlier.
Is xfs refusing to umount 'erroring' device ?


Also please note - since its mentioned namespaces here - if this is something 
Docker related - be aware for Docker thins  - lvm2 for awhile is leaving such 
volumes intact already (-> no umount for docker thins volume).


Regards

Zdenek
