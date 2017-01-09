From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: trouble with generic/081
Date: Mon, 9 Jan 2017 16:11:08 +0100
Message-ID: <fb048316-72f9-5a3d-8a03-4220b25eb028@redhat.com>
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
	<15605149-0590-1555-6522-38d2eff69026@redhat.com>
	<0cb45b07-4cae-0dc5-0605-752f2e0dfda1@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0cb45b07-4cae-0dc5-0605-752f2e0dfda1@sandeen.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: dm-devel@redhat.com, eguan@redhat.com
List-Id: dm-devel.ids

Dne 9.1.2017 v 15:54 Eric Sandeen napsal(a):
> On 1/9/17 8:22 AM, Zdenek Kabelac wrote:
>> But could anyone from XFS specify -  why  umount is causing some
>> 'more' damage, then  no umount at all ?
>
> Please reread this thread...  it /started/ with problems
> /caused by unmount/ for Christoph.
>
> It's not that unmount damages the filesystem per se; it damages the
> /system/ when it uncovers the underlying mountpoint and applications
> continue writing without error, to the /wrong filesystem/.
>
> Further, if unmount requires IO that can't complete due to ENOSPC,
> then launching the unmount behind the admin's back may cause other
> problems when it gets detached from the namespace.
>
> Christoph later clarified:
>
>> Even on a production system I'd much rather have a shutdown XFS fs
>> than LVM trying to unmount, probably hanging because there are busy
>> fds on the fs, and if not the application might not write to another
>> fs becaus of this.  It's just an amazingly stupid idea.
>
> And again:
>
>> invi[si]bly unmounting
>> a file system behind the users back is actively harmful, as it is
>> contradicting the principle of least surprise, and the xfstests mess
>> is one simple example for it.
> ...
>> [ it's undesirable to ] unmount and expose the namespace below it,
>> which the administrator has probably intentionally hid.
>
>> Even worse unmount may trigger further writes and with fses not
>> handling them the fs might now be stuck after being detached from
>> the namespace without a way for the admin to detect or recover this.
>
> Dave agreed:
>
>> And my 2c worth on the "lvm unmounting filesystems on error" - stop
>> it, now. It's the wrong thing to do, and it makes it impossible for
>> filesystems to handle the error and recover gracefully when
>> possible.
>
> Now, as for:
>
>> Is xfs refusing to umount 'erroring' device ?
>
> I'm not sure what you mean by this.  XFS never unmounts itself.
> If you're asking if an XFS filesystem in an error state (i.e., shutdown,
> or with failing IOs) can unmount - yes, it is possible to unmount
> a filesystem in this state.  The administrator can make that choice.
>
>
>
> You've had two preeminent XFS developers ask repeatedly that
> you stop unmounting xfs from lvm2.  I really wish you would take their
> advice.


As said already said couple times -   lvm2 WILL provide this feature.
For sure - I'll repeat again - it will get there.


>
> We need to work together to ensure that these subsystems react
> in the best possible way to overprovisioned storage, and give the admin
> the best chance at recovery without more adverse affects.  For the reasons
> stated above, unmounting the filesystem does not achieve this goal.
>
> It leads to application IO to wrong filesystems (quite possibly root),
> detached filesystems which can no longer be administered, possible hung
> unmounts, etc.  Automatic unmount is the wrong reaction, please stop doing
> it.

I do get this - but we have 2 cases - each has it's merit.

You have the case were application will write to 'different' filesystem,
while in other cases user will be able to continue to use their filesystem
and cause irreparable filesystem damage (whatever you want to believe
is failure if thin-pool or filesystem).

So I believe it's upto a user to be able to pick which version he
prefers - and that's  why  lvm2 will provide this  behavior configurable.

You could of course do any other jobs - i.e. call fstrim  in the hook.

Regards

Zdenek
