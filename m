From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Thu, 31 May 2007 08:24:04 +0200
Message-ID: <20070531062404.GH32105@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown>
	<18010.12472.209452.148229@notabene.brown>
	<20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com>
	<20070529234832.GT85884050@sgi.com>
	<465DAA15.3070703@cfl.rr.com> <465DDE1D.3000809@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <465DDE1D.3000809@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Tejun Heo <htejun@gmail.com>, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Wed, May 30 2007, Phillip Susi wrote:
> >That would be the exactly how I understand Documentation/block/barrier.txt:
> >
> >"In other words, I/O barrier requests have the following two properties.
> >1. Request ordering
> >...
> >2. Forced flushing to physical medium"
> >
> >"So, I/O barriers need to guarantee that requests actually get written
> >to non-volatile medium in order." 
> 
> I think you misinterpret this, and it probably could be worded a bit 
> better.  The barrier request is about constraining the order.  The 
> forced flushing is one means to implement that constraint.  The other 
> alternative mentioned there is to use ordered tags.  The key part there 
> is "requests actually get written to non-volatile medium _in order_", 
> not "before the request completes", which would be synchronous IO.

No Stephan is right, the barrier is both an ordering and integrity
constraint. If a driver completes a barrier request before that request
and previously submitted requests are on STABLE storage, then it
violates that principle. Look at the code and the various ordering
options.

-- 
Jens Axboe
