From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Reworking dm-writeboost [was: Re: staging: Add dm-writeboost]
Date: Tue, 8 Oct 2013 11:29:25 -0400
Message-ID: <20131008152924.GA3644@redhat.com>
References: <523E3522.2060607@gmail.com> <524183A2.9050301@gmail.com>
 <20130926034325.GO26872@dastard> <20131001082654.GA10326@debian>
 <alpine.LRH.2.02.1310021956130.22612@file01.intranet.prod.int.rdu2.redhat.com>
 <20131004020417.GF4446@dastard> <524FC4F4.6050401@gmail.com>
 <20131007234307.GP4446@dastard>
 <20131008094144.GA10261@infradead.org> <5253E06C.6040101@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <5253E06C.6040101@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: devel@driverdev.osuosl.org, thornber@redhat.com, cesarb@cesarb.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, hch@infradead.org, dm-devel@redhat.com, mpatocka@redhat.com, agk@redhat.com, joe@perches.com, akpm@linux-foundation.org, ejt@redhat.com, dan.carpenter@oracle.com, m.chehab@samsung.com
List-Id: dm-devel.ids

On Tue, Oct 08 2013 at  6:37am -0400,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> Christoph,
> 
> > You can detect O_DIRECT writes by second guession a special combination
> > of REQ_ flags only used there, as cfg tries to treat it special:
> > 
> > #define WRITE_SYNC              (WRITE | REQ_SYNC | REQ_NOIDLE)
> > #define WRITE_ODIRECT           (WRITE | REQ_SYNC)
> > 
> > the lack of REQ_NOIDLE when REQ_SYNC is set gives it away.  Not related
> > to the FLUSH or FUA flags in any way, though.
> Thanks.
> But, our problem is to detect the bio may or may not be deferred.
> The flag REQ_NOIDLE is the one?
> 
> > Akira, can you explain the workloads where your delay of FLUSH or FUA
> > requests helps you in any way?  I very much agree with Dave's reasoning,
> > but if you found workloads where your hack helps we should make sure we
> > fix them at the place where they are issued.
> One of the examples is a fileserver accessed by multiple users.
> A barrier is submitted when a user closes a file for example.
> 
> As I said in my previous post
> https://lkml.org/lkml/2013/10/4/186
> writeboost has RAM buffer and we want one to be
> fulfilled with writes and then flushed to the cache device
> that takes all the barriers away with the completion.
> In that case we pay the minimum penalty for the barriers.
> Interestingly, writeboost is happy with a lot of writes.
> 
> By deferring these barriers (FLUSH and FUA)
> multiple barriers are likely to be merged on a RAM buffer
> and then processed by replacing with only one FLUSH.
> 
> Merging the barriers and replacing it with a single FLUSH
> by accepting a lot of writes
> is the reason for deferring barriers in writeboost.
> If you want to know further I recommend you to
> look at the source code to see
> how queue_barrier_io() is used and
> how the barriers are kidnapped in queue_flushing().

AFAICT, this is an unfortunate hack resulting from dm-writeboost being a
bio-based DM target.  The block layer already has support for FLUSH
merging, see commit ae1b1539622fb4 ("block: reimplement FLUSH/FUA to
support merge")
