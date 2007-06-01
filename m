From: david@lang.hm
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Thu, 31 May 2007 22:55:58 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528094358.GM25091@agk.fab.redhat.com>
	<5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com>
	<20070529220500.GA6513@agk.fab.redhat.com>
	<5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com>
	<465DAC72.1010201@cfl.rr.com>
	<5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com>
	<465F9197.7060002@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <465F9197.7060002@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <htejun@gmail.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Fri, 1 Jun 2007, Tejun Heo wrote:

> but one
> thing we should bear in mind is that harddisks don't have humongous
> caches or very smart controller / instruction set.  No matter how
> relaxed interface the block layer provides, in the end, it just has to
> issue whole-sale FLUSH CACHE on the device to guarantee data ordering on
> the media.

if you are talking about individual drives you may be right for the moment 
(but 16M cache on drives is a _lot_ larger then people imagined would be 
there a few years ago)

but when you consider the self-contained disk arrays it's an entirely 
different story. you can easily have a few gig of cache and a complete OS 
pretending to be a single drive as far as you are concerned.

and the price of such devices is plummeting (in large part thanks to Linux 
moving into this space), you can now readily buy a 10TB array for $10k 
that looks like a single drive.

David Lang
