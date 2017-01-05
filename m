From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: trouble with generic/081
Date: Thu, 5 Jan 2017 13:07:39 -0500
Message-ID: <20170105180739.GA7699@redhat.com>
References: <20161214164314.GA25105@infradead.org>
 <20161215063650.GJ4326@dastard>
 <20161215084224.GA14395@infradead.org>
 <c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
 <20161216081523.GA13847@infradead.org>
 <5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
 <a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
 <20170105162600.GD6874@redhat.com>
 <89cd4c0b-e8eb-3804-adba-2f7f376e776a@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <89cd4c0b-e8eb-3804-adba-2f7f376e776a@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com, fstests@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jan 05 2017 at 12:42pm -0500,
Zdenek Kabelac <zkabelac@redhat.com> wrote:

> Dne 5.1.2017 v 17:26 Mike Snitzer napsal(a):
> >On Thu, Jan 05 2017 at  5:35am -0500,
> >Zdenek Kabelac <zkabelac@redhat.com> wrote:
> >
> >>Dne 5.1.2017 v 00:03 Eric Sandeen napsal(a):
> >>>
> >>>
> >>>On 12/16/16 2:15 AM, Christoph Hellwig wrote:
> >>>>On Thu, Dec 15, 2016 at 10:16:23AM +0100, Zdenek Kabelac wrote:
> >>>>>So let me explain the logic behind this 'amazingly stupid' idea.
> >>>>
> >>>>And that logic doesn't make any sense at all.  invibly unmounting
> >>>>a file system behind the users back is actively harmful, as it is
> >>>>contradicting the principle of least surprise, and the xfstests mess
> >>>>is one simple example for it.  Add a callback in-kernel to tell the
> >>>>fs to shut down but NOT unmount and expose the namespace below it,
> >>>>which the administrator has probably intentionally hid.
> >>>>
> >>>>Even worse unmount may trigger further writes and with fses not
> >>>>handling them the fs might now be stuck after being detached from
> >>>>the namespace without a way for the admin to detect or recover this.
> >>>>
> >>>>What XFS did on IRIX was to let the volume manager call into the fs
> >>>>and shut it down.  At this point no further writes are possible,
> >>>>but we do not expose the namespace under the mount point, and the
> >>>>admin can fix the situation with all the normal tools.
> >>>
> >>><late to the party>
> >>>
> >>>Is there a need for this kind of call-up when xfs now has the configurable
> >>>error handling so that it will shut down after X retries or Y seconds
> >>>of a persistent error?
> >>
> >>
> >>We need likely to open  RFE bugzilla  here - and specify how it should
> >>work when some conditions are met.
> >>
> >>Current 'best effort' tries to minimize damage by trying to do a full-stop
> >>when pool approaches 95% fullness.  Which is relatively 'low/small'
> >>for small sized thin-pool - but there is reasonable big free space
> >>for
> >>commonly sized thin-pool to be able to flush most of page cache on
> >>disk before things will go crazy.
> >>
> >>Now - we could probably detect presence of kernel version and
> >>xfs/ext4 present features - and change reactions.
> >>
> >>What I expect from this BZ is -  how to detect things and what is
> >>the 'best' thing to do.
> >>
> >>I'm clearly not an expert on all filesystem and all their features - but lvm2
> >>needs to work reasonable well across all variants of kernels and
> >>filesystems -  so we cannot say to user - now  we require you to use
> >>the latest 4.10
> >>kernel with these features enabled otherwise all your data could be lost.
> >>
> >>We need to know what to do with 3.X  kernel,  4.X kernel and present
> >>features in kernel and how we can detect them in runtime.
> >
> >No we need to fix upstream.  It is the job of distros to sort out other
> >solutions.  And yeah I appreciate that you need to worry about distro X,
> >Y, Z from Red Hat but lvm2 needs to not be so cute about things.
> >
> >And there has been significant progress on XFS's error handling so that
> >it no longer hangs in the face of ENOSPC.
> >
> >Eric says the basics are documented in Documentation/filesystems/xfs.txt
> >under "Error Handling".
> >
> >Bottomline is lvm2 really has no business unmounting the filesystem.
> >That lvm2 "feature" should be reverted.  It isn't what anyone would
> >expect.  And it only serves to create problems.  Nice intent but it was
> >a misfire to implement it.  At most a discard should be issued once you
> >cross a threshold.
> >
> 
> 
> Users are mostly using thin LVs with  ext4 and XFS filesytems.
> Lots of users do use quite ancient kernels (<4.X).
> 
> When lvm2 decides to UNMOUNT volumes - it's the moment where
> everything else HAS failed (mainly Admin has failed to provide
> promised space)
> And it should be seen as mild OOPS replacement.
> 
> 
> Un/fortunately lvm2 does care about older distributions and kernels
> - so unlike many other 'modern' software you can take recent lvm2 -
> compile & run on several years system and it does its best - so far
> I'd call it a feature.
> 
> Not really sure what do you mean by - leaving this on 'distro'
> maintainers since these are typically able to run   'configure &
> make',
> without no big idea about configurable lvm2 internals.
> 
> --
> 
> Now there is no objection about adding configurable behavior on such cases
> (policies) here you are 'breaking to the open doors' since we do
> plan to provide these for some time (I think there are couple BZs
> already)
> 
> So far I understand that admin  HAS to configure 'better XFS logic'
> himself on filesystem - it's not  granted default so far even on
> 4.10 kernel ?
> 
> On lvm2 side we need to first convert plugin code executions to
> lvconvert policies (will make BZ for this one).

lvm2 isn't the one that needs to fix this!

but it certainly should not be doing an unmount.  discard at most.

why is discard kernel version dependent?

You're making an historically annoying problem even more so.  please
stop this.
