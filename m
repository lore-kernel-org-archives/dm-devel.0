From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/4] Support discard if at least one
 underlying device supports it
Date: Fri, 2 Jul 2010 14:14:30 -0400
Message-ID: <20100702181430.GD26916@redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Fri, Jul 02 2010 at 11:19am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Support discard if at least one underlying device supports it
> 
> The previous code was too restrictive. It required that every underlying
> device supports discard to advertise discard support.
> 
> If one of the underlying devices doesn't support discard and other does,
> it makes still sense to advertise discard support and forward discards only
> to the device that supports them.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

As we discussed, we have a challenge where we need DM to avoid issuing
a barrier before the discard IFF a target doesn't support the discard
(which the barrier is paired with).

My understanding is that blkdev_issue_discard() only cares if the
discard was supported.  Barrier is used just to decorate the discard
(for correctness).  So by returning -EOPNOTSUPP we're saying the discard
isn't supported; we're not making any claims about the implict barrier,
so best to avoid the barrier entirely.

Otherwise we'll be issuing unnecessary barriers (and associated
performance loss).

So yet another TODO item... Anyway:

Acked-by: Mike Snitzer <snitzer@redhat.com>
