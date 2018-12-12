From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: for-next hangs on test srp/012
Date: Tue, 11 Dec 2018 19:22:39 -0500
Message-ID: <20181212002238.GB20445@redhat.com>
References: <1544569107.185366.391.camel@acm.org>
	<20181211230514.GA20445@redhat.com>
	<1544569767.185366.393.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1544569767.185366.393.camel@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 11 2018 at  6:09pm -0500,
Bart Van Assche <bvanassche@acm.org> wrote:

> On Tue, 2018-12-11 at 18:05 -0500, Mike Snitzer wrote:
> > On Tue, Dec 11 2018 at  5:58pm -0500,
> > Bart Van Assche <bvanassche@acm.org> wrote:
> > 
> > > Hi Jens,
> > > 
> > > If I run the following subset of blktests:
> > > 
> > >   while :; do ./check -q srp && ./check -q nvmeof-mp; done
> > > 
> > > against today's for-next branch (commit dd2bf2df85a7) then after some
> > > time the following hang is reported:
> > 
> > Jens has applied a fix from me today that I think is very relevant;
> > it'll be in tomorrow's for-next:
> > 
> > http://git.kernel.dk/cgit/linux-block/commit/?h=for-4.21/block&id=c4576aed8d85d808cd6443bda58393d525207d01
> > 
> > Please try with that and see how things go.
> 
> Hi Mike,
> 
> Thank you for your reply. I should have mentioned that I used Jens' for-next
> branch as starting point and that that commit is present in the branch I used
> as a starting point for my tests:
> 
> $ git branch --contains c4576aed8d85d808cd6443bda58393d525207d01    
> * axboe-block-for-next

next-20181211 doesn't contain c4576aed8d85d808cd6443bda58393d525207d01

I'll try to reproduce, but in the meantime can you just try jens'
for-4.21/block?  It is currently 2c4d5356e64
