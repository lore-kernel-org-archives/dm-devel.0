From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v4 01/11] block: make generic_make_request handle
 arbitrarily sized bios
Date: Thu, 4 Jun 2015 20:06:36 -0400
Message-ID: <20150605000636.GA24611@redhat.com>
References: <1432318723-18829-2-git-send-email-mlin@kernel.org>
 <20150526143626.GA4315@redhat.com>
 <CAF1ivSb3ptYObS3_8bJwWhq98EcNgAgRhN_L-c3uyFfCzdn=9A@mail.gmail.com>
 <20150526160400.GB4715@redhat.com>
 <CAF1ivSZ351yV4re1Ghf5yqPjgq6aXjrZT4yWd+T9msAFsBnDSw@mail.gmail.com>
 <20150528003627.GD32216@agk-dp.fab.redhat.com>
 <1433138551.11778.4.camel@hasee>
 <CAF1ivSY_7M1OhrMuXg0OKu7BPy=SbTHSHCk+2q6vfEVgvJL8YA@mail.gmail.com>
 <20150604210617.GA23710@redhat.com>
 <CAF1ivSa_U5LFNWMdw8dBadoWVU6uk+ph_NP5jQztLWYHyRz-MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAF1ivSa_U5LFNWMdw8dBadoWVU6uk+ph_NP5jQztLWYHyRz-MQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, Alasdair G Kergon <agk@redhat.com>, Lars Ellenberg <drbd-dev@lists.linbit.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, Andreas Dilger <andreas.dilger@intel.com>, Geoff Levand <geoff@infradead.org>, Jiri Kosina <jkosina@suse.cz>, lkml <linux-kernel@vger.kernel.org>, Jim Paris <jim@jtan.com>, Minchan Kim <minchan@kernel.org>, Dongsu Park <dpark@posteo.net>, drbd-user@lists.linbit.com
List-Id: dm-devel.ids

On Thu, Jun 04 2015 at  6:21pm -0400,
Ming Lin <mlin@kernel.org> wrote:

> On Thu, Jun 4, 2015 at 2:06 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > We need to test on large HW raid setups like a Netapp filer (or even
> > local SAS drives connected via some SAS controller).  Like a 8+2 drive
> > RAID6 or 8+1 RAID5 setup.  Testing with MD raid on JBOD setups with 8
> > devices is also useful.  It is larger RAID setups that will be more
> > sensitive to IO sizes being properly aligned on RAID stripe and/or chunk
> > size boundaries.
> 
> I'll test it on large HW raid setup.
> 
> Here is HW RAID5 setup with 19 278G HDDs on Dell R730xd(2sockets/48
> logical cpus/264G mem).
> http://minggr.net/pub/20150604/hw_raid5.jpg
> 
> The stripe size is 64K.
> 
> I'm going to test ext4/btrfs/xfs on it.
> "bs" set to 1216k(64K * 19 = 1216k)
> and run 48 jobs.

Definitely an odd blocksize (though 1280K full stripe is pretty common
for 10+2 HW RAID6 w/ 128K chunk size).

> [global]
> ioengine=libaio
> iodepth=64
> direct=1
> runtime=1800
> time_based
> group_reporting
> numjobs=48
> rw=read
> 
> [job1]
> bs=1216K
> directory=/mnt
> size=1G

How does time_based relate to size=1G?  It'll rewrite the same 1 gig
file repeatedly?

> Or do you have other suggestions of what tests I should run?

You're welcome to run this job but I'll also check with others here to
see what fio jobs we used in the recent past when assessing performance
of the dm-crypt parallelization changes.

Also, a lot of care needs to be taken to eliminate jitter in the system
while the test is running.  We got a lot of good insight from Bart Van
Assche on that and put it to practice.  I'll see if we can (re)summarize
that too.

Mike
