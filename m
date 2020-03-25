From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v7 0/6] block: Introduce REQ_ALLOCATE flag for
 REQ_OP_WRITE_ZEROES
Date: Wed, 25 Mar 2020 09:32:23 -0700
Message-ID: <20200325163223.GA27156@infradead.org>
References: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
 <e2b7cbab-d91f-fd7b-de6f-a671caa6f5eb@virtuozzo.com>
 <69c0b8a4-656f-98c4-eb55-2fd1184f5fc9@virtuozzo.com>
 <67d63190-c16f-cd26-6b67-641c8943dc3d@virtuozzo.com>
 <20200319102819.GA26418@infradead.org>
 <yq1tv2k8pjn.fsf@oracle.com>
 <20200325162656.GJ29351@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200325162656.GJ29351@magnolia>
Sender: linux-block-owner@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, axboe@kernel.dk, bob.liu@oracle.com, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Mar 25, 2020 at 09:26:56AM -0700, Darrick J. Wong wrote:
> > That said, I do think that we have traditionally put emphasis on the
> > wrong part of these operations. All we ever talk about wrt. discard and
> > friends is the zeroing aspect. But I actually think that, semantically,
> > the act of allocating and deallocating blocks is more important. And
> > that zeroing is an optional second order effect of those operations. So
> > if we could go back in time and nuke multi-range DSM TRIM/UNMAP, I would
> > like to have REQ_OP_ALLOCATE/REQ_OP_DEALLOCATE with an optional REQ_ZERO
> > flag. I think that would be cleaner. I have a much easier time wrapping
> > my head around "allocate this block and zero it if you can" than "zero
> > this block and do not deallocate it". But maybe that's just me.
> 
> I'd love to transition to that.  My brain is not good at following all
> the inverse logic that NOUNMAP spread everywhere.  I have a difficult
> time following what the blockdev fallocate code does, which is sad since
> hch and I are the primary stuckees^Wmeddlers^Wauthors of that function. :/

I am very much against that for the following reason:

 - the current REQ_OP_DISCARD is purely a hint, and implementations can
   (and do) choose to ignore it
 - REQ_OP_WRITE_ZEROES is an actual data integrity operation with
   everything that entails

Going back to mixing these two will lead to a disaster sooner or later.
