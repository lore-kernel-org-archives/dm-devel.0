From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] fix crash in blk_queue_abort
Date: Tue, 21 Apr 2009 09:29:03 +0200
Message-ID: <20090421072903.GY4593@kernel.dk>
References: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
	<20090417063615.GE4593@kernel.dk>
	<Pine.LNX.4.64.0904200220290.22707@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904200220290.22707@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Apr 20 2009, Mikulas Patocka wrote:
> > Lets just add a
> > 
> >         if (!q->request_fn)
> >                 return;
> > 
> > at the top of blk_abort_queue(), no need in making this generic until
> > someone actually needs different behaviour.
> > 
> > -- 
> > Jens Axboe
> 
> Good point. Do it this way.

Already did :-)

-- 
Jens Axboe
