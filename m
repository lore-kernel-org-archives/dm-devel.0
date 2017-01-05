From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: trouble with generic/081
Date: Thu, 5 Jan 2017 12:40:07 -0600
Message-ID: <2887ea8e-d4a4-7213-21ae-13a41a2d64ae@sandeen.net>
References: <20161214164314.GA25105@infradead.org>
 <20161215063650.GJ4326@dastard> <20161215084224.GA14395@infradead.org>
 <c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
 <20161216081523.GA13847@infradead.org>
 <5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
 <a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
 <20170105162600.GD6874@redhat.com>
 <89cd4c0b-e8eb-3804-adba-2f7f376e776a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <89cd4c0b-e8eb-3804-adba-2f7f376e776a@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com, fstests@vger.kernel.org
List-Id: dm-devel.ids

On 1/5/17 11:42 AM, Zdenek Kabelac wrote:
> Dne 5.1.2017 v 17:26 Mike Snitzer napsal(a):

...

>> Bottomline is lvm2 really has no business unmounting the filesystem.
>> That lvm2 "feature" should be reverted.  It isn't what anyone would
>> expect.  And it only serves to create problems.  Nice intent but it was
>> a misfire to implement it.  At most a discard should be issued once you
>> cross a threshold.

Agreed.

> 
> 
> Users are mostly using thin LVs with  ext4 and XFS filesytems.
> Lots of users do use quite ancient kernels (<4.X).

Yes, old kernels have bugs.  Enterprise distros should fix those bugs,
configure && make distros and roll-your-own users get what they
get, IMHO.

> When lvm2 decides to UNMOUNT volumes - it's the moment where
> everything else HAS failed (mainly Admin has failed to provide
> promised space)
> And it should be seen as mild OOPS replacement.

unmounting is a bad idea.  It's not even guaranteed to complete,
because unmount may well require IO.  It has undesirable and unpredictable
impacts on the system.  At a bare minimum, it should not be the default
behavior.

> 
> Un/fortunately lvm2 does care about older distributions and kernels -
> so unlike many other 'modern' software you can take recent lvm2 -
> compile & run on several years system and it does its best - so far
> I'd call it a feature.

It's great that lvm2 stays compatible - xfsprogs does too,
FWIW - but trying to work around every old bad behavior is likely
to be a fool's errand, IMHO.

> Not really sure what do you mean by - leaving this on 'distro'
> maintainers since these are typically able to run 'configure &
> make', without no big idea about configurable lvm2 internals.

But unmounting /does not/ solve that for them.  It's bad behavior.
It's far better IMHO to let xfs spew errors to the log for a day
than to unmount a volume and then fill the root fs with ongoing
IO, for example.
 
> -- 
> 
> Now there is no objection about adding configurable behavior on such cases
> (policies) here you are 'breaking to the open doors' since we do plan
> to provide these for some time (I think there are couple BZs
> already)
> 
> So far I understand that admin HAS to configure 'better XFS logic'
> himself on filesystem - it's not granted default so far even on 4.10
> kernel ?

Ok, back to concrete things: Right, XFS behavior is tunable, but
largely unchanged other than a better behavior at unmount.  Default
behavior in the face of IO errors is otherwise unchanged.  Not all
the world is thinp; there are other error conditions and cases which
may warrant different responses.  As such, the default remains to
keep trying IO unless something critical fails, which will then shut
down the filesystem.

That said, lvm2 offering to configure such behavior for xfs on a thin
volume might be quite reasonable.

I really think we need a robust test framework for all of this so we
can move beyond anecdotes and assumptions, and get some repeatable
regression tests going.

-Eric

> On lvm2 side we need to first convert plugin code executions to lvconvert policies (will make BZ for this one).
> 
> 
> Regards
> 
> Zdenek
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
