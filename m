From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Tue, 29 May 2007 23:05:00 +0100
Message-ID: <20070529220500.GA6513@agk.fab.redhat.com>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528094358.GM25091@agk.fab.redhat.com>
	<5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Bader <sbader3@googlemail.com>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Tue, May 29, 2007 at 11:25:42AM +0200, Stefan Bader wrote:
> doing a sort of suspend, issuing the
> barrier request, calling flush to all mapped devices and then wait for
> in-flight I/O to go to zero? 

Something like that is needed for some dm targets to support barriers.
(We needn't always wait for *all* in-flight I/O.)
When faced with -EOPNOTSUP, do all callers fall back to a sync in
the places a barrier would have been used, or are there any more
sophisticated strategies attempting to optimise code without barriers?

> I am not a hundred percent sure about
> that but I think that just passing the barrier flag on to mapped
> devices might in some (maybe they are rare) cases cause a layer above
> to think all data is on-disk while this isn't necessarily true (see my
> previous post). What do you think?

An efficient I/O barrier implementation would not normally involve
flushing AFAIK: dm surely wouldn't "cause" a higher layer to assume
stronger semantics than are provided.
 
Alasdair
-- 
agk@redhat.com
