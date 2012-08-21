From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 00/20] dm-crypt: parallel processing
Date: Tue, 21 Aug 2012 11:23:40 -0700
Message-ID: <20120821182340.GA24861@google.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<503356E7.4080604@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <503356E7.4080604@redhat.com>
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

(cc'ing Jens and Vivek, hi!)

On Tue, Aug 21, 2012 at 11:37:43AM +0200, Milan Broz wrote:
> Better adding cc to Tejun here, I still think there are several things
> which perhaps should be done through kernel wq...
> 
> (I would prefer to use kernel wq as well btw.)

What do you mean by kernel wq?  One of the system_*_wq's?  If not,
from scanning the patch names, it seems like it's converting to
unbound workqueue from bound one.

> > 1) Last two patches (19/20) provides sorting of IO requests, this
> > logically should be done in IO scheduler.
> > 
> > I don't think this should be in dmcrypt, if scheduler doesn't work
> > properly, it should be fixed or tuned for crypt access pattern.

I kinda agree but preserving (not strictly but at least most of the
time) issuing order across stacking driver like dm probably isn't a
bad idea.  I *think* the direction block layer should be headed is to
reduce the amount of work it does as the speed and characteristics of
underlying devices improve.  We could afford to do a LOT of things to
better cater to devices with spindles but the operating margin
continues to become narrower.  Jens, Vivek, what do you guys think?

> > 2) Could be kernel workqueue used/fixed here instead? Basically all it needs
> > is to prefer submitting CPU, if it is busy just move work to another CPU.

The problem, I suppose, is that w/ wq, it's either bound or completely
unbound.  If bound, the local CPU can become the bottleneck.  If
unbound, wq doesn't discern local and remote at all and thus loses any
benefit from locality association.

It would be nice if workqueue can somehow accomodate the situation
better - maybe by migrating the worker to the issuing CPU before
setting it loose so that the scheduler needs to migrate it away
explicitly.  Maybe we can do it opportunistically - e.g. record which
CPU an unbound worker was on before entering idle and queue to local
one if it exists.  It wouldn't be trivial to implement tho.  I'll
think more about it.

Thanks.

-- 
tejun
