From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 00/20] dm-crypt: parallel processing
Date: Thu, 23 Aug 2012 13:15:36 -0700
Message-ID: <20120823201536.GE14962@google.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<503356E7.4080604@redhat.com> <20120821182340.GA24861@google.com>
	<5034B459.1000107@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5034B459.1000107@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

Hello,

On Wed, Aug 22, 2012 at 12:28:41PM +0200, Milan Broz wrote:
> Whatever, if logic is implemented in workqueue code, others can use t as well.
> I would really prefer not to have "too smart" dmcrypt...
> (Someone mentioned btrfs on top of it with all workqueues - how it can behave nicely
> if every layer will try to implement own smart logic.)
> 
> Anyway, thanks for discussion, this is exactly what was missing here :)

I've been thinking about it and am still unsure.  If there are enough
use cases, we can try to manage unbound workers such that each CPU has
some standby ones, but at this point such approach seems a bit
overkill and I'm skeptical how useful a purely opportunistic approach
would be.

Another thing is that this is something which really belongs to the
scheduler.  The scheduler can know better and do things like this much
better.  Unfortunately, kthreads don't have mechanisms to be
discovered in terms of its optimal association (as opposed to, say,
autonuma for userland).

So... I don't know.  dm-crypt probably is the most extreme use case in
kernel, so maybe going for specialized solution might not be too
crazy.  Also, how much of a problem is this?  Is it really worth
solving?

Thanks.

-- 
tejun
