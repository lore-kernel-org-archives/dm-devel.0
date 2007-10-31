From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: dm: bounce_pfn limit added
Date: Wed, 31 Oct 2007 02:11:23 +0000
Message-ID: <20071031021123.GM10006@agk.fab.redhat.com>
References: <47257E4B.4080904@sw.ru>
	<20071030131138.3ba59731.akpm@linux-foundation.org>
	<20071030232617.GJ10006@agk.fab.redhat.com>
	<20071031020133.GL10006@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20071031020133.GL10006@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vasily Averin <vvs@sw.ru>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org, devel@openvz.org
List-Id: dm-devel.ids

On Wed, Oct 31, 2007 at 02:01:33AM +0000, Alasdair G Kergon wrote:
> What if you swap in alternative dm targets, e.g. if it's linear,
> try multipath (round-robin, one path)?
  
And try using md instead of dm - does that also show the problem?
(md takes a similar stance to dm on this I believe.)

Alasdair
-- 
agk@redhat.com
