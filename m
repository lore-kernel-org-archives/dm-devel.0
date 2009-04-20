From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] fix crash in blk_queue_abort
Date: Mon, 20 Apr 2009 02:20:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200220290.22707@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904161948420.312@hs20-bc2-1.build.redhat.com>
	<20090417063615.GE4593@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090417063615.GE4593@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> Lets just add a
> 
>         if (!q->request_fn)
>                 return;
> 
> at the top of blk_abort_queue(), no need in making this generic until
> someone actually needs different behaviour.
> 
> -- 
> Jens Axboe

Good point. Do it this way.

Mikulas
