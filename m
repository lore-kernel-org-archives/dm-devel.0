From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: trouble with generic/081
Date: Thu, 15 Dec 2016 10:16:23 +0100
Message-ID: <c05b64b6-80d3-655d-db9b-6f49038e53ee@redhat.com>
References: <20161214164314.GA25105@infradead.org>
 <20161215063650.GJ4326@dastard> <20161215084224.GA14395@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20161215084224.GA14395@infradead.org>
Sender: fstests-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: eguan@redhat.com, fstests@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 15.12.2016 v 09:42 Christoph Hellwig napsal(a):
> On Thu, Dec 15, 2016 at 05:36:50PM +1100, Dave Chinner wrote:
>> Yup, same here. My local patch is this:
>
> I have a sleep 1 before the unmount.  To be honest this lvm behavior of
> auto-unmounting on error seems like a huge mess, I wonder if there is a way
> to disable it?
>
> Even on a production system I'd much rather have a shutdown XFS fs than LVM
> trying to unmount, probably hanging because there are busy fds on the fs,
> and if not the application might not write to another fs becaus of this.
> It's just an amazingly stupid idea.
>

Hi

So let me explain the logic behind this 'amazingly stupid' idea.

The full pool is by far worst case and ATM lvm2 has only a single policy
(though for many many years) to prevent bigger disaster by intentionally
causing smaller one - and sometimes it works (since typically if you have open
descriptors in apps - and you can't open new one app dies, descriptors are
closed, FS is unmounted....) (Originally we wanted to be even more 'brutal' -
and replace such thin devices with error targets...)   Unfortunately remount
of filesystem to read-only mode will not ensure there will be no further
writes (journal replies, endless retry of XFS to store unwritten blocks...)
but could be possibly better choice.

What is worth here to emphasize: the 95% fullness of thin-poll (which is the
moment where  the unmount will be tried) it simply the failure of admin - it
should never get to that fullness in the first place - plain and simple.

Thin-pool is NOT designed to be commonly operated over the corner cases - if
that's your common use scenario - you've picked wrong technology - it doesn't
fit.  We have already seen some  use scenarios where 100% full pool was meant
to be part of regular work-flow....

If you do monitor with threshold 70% and you already have a pool over 95%
there is nearly zero chance it will get fixed by some miracle.

Filesystem are not so much ready yet to deal  with full thin-pool well - this
is plain real-world fact. They will destroy them-self totally when they
suddenly face massive random error sector counts. It may cause serious
possibly even irreparable damage in case of XFS. The ext4 is ahead with years
proven error remount read-only behavior technology and until very recently
where XFS gained something close to this.


But of course we are open to proposal - what better we should do to not be
'amazingly stupid'   (just note  trying to use full thin-pool is not
'amazingly smart') - this is incomparable case to full single filesystem.


We do already have some plans to call  'fstrim' at some points - but still
we need something as emergency stop for filesystem before there
is hit of  full-pool wall - this is the case which always means
data-loss and is not-trival to recover.

For each such proposal it's worth to make upstream Bugzilla.

Regards

Zdenek
