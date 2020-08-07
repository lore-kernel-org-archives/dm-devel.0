From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [git pull] device mapper changes for 5.9
Date: Fri, 7 Aug 2020 16:40:15 -0400
Message-ID: <20200807204015.GA2178@redhat.com>
References: <20200807160327.GA977@redhat.com>
 <CAHk-=wiC=g-0yZW6QrEXRH53bUVAwEFgYxd05qgOnDLJYdzzcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wiC=g-0yZW6QrEXRH53bUVAwEFgYxd05qgOnDLJYdzzcA@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-block <linux-block@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, Ignat Korchagin <ignat@cloudflare.com>, JeongHyeon Lee <jhs2.lee@samsung.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, John Dorminy <jdorminy@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Ming Lei <ming.lei@redhat.com>, yangerkun <yangerkun@huawei.com>
List-Id: dm-devel.ids

On Fri, Aug 07 2020 at  4:11pm -0400,
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Aug 7, 2020 at 9:03 AM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > - DM crypt improvement to optionally avoid async processing via
> >   workqueues for reads and/or writes -- via "no_read_workqueue" and
> >   "no_write_workqueue" features.  This more direct IO processing
> >   improves latency and throughput with faster storage.  Avoiding
> >   workqueue IO submission for writes (DM_CRYPT_NO_WRITE_WORKQUEUE) is
> >   a requirement for adding zoned block device support to DM crypt.
> 
> Is there a reason the async workqueue isn't removed entirely if it's not a win?
> 
> Or at least made to not be the default.

I haven't assessed it yet.

There are things like rbtree sorting that is also hooked off async, but
that is more meaningful for rotational storage.

> Now it seems to be just optionally disabled, which seems the wrong way
> around to me.
> 
> I do not believe async crypto has ever worked or been worth it.
> Off-loaded crypto in the IO path, yes. Async using a workqueue? Naah.
> 
> Or do I misunderstand?

No, you've got it.

My thinking was to introduce the ability to avoid the workqueue code via
opt-in and then we can evaluate the difference it has on different
classes of storage.

More conservative approach that also allows me to not know the end from
the beginning... this was work driven by others so on this point I
rolled with what was proposed since I personally don't have the answer
(yet) on whether workqueue is actually helpful.  Best to _really_ know
that before removing it.

I'll make a point to try to get more eyes on this to see if it makes
sense to just eliminate the workqueue code entirely (or invert the
default).  Will keep you updated.

Mike
