From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH 00/20] dm-crypt: parallel processing
Date: Tue, 21 Aug 2012 15:26:32 -0400
Message-ID: <20120821192632.GA16061@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<503356E7.4080604@redhat.com> <20120821182340.GA24861@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120821182340.GA24861@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, device-mapper development <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 21, 2012 at 11:23:40AM -0700, Tejun Heo wrote:

[..]
> > > 1) Last two patches (19/20) provides sorting of IO requests, this
> > > logically should be done in IO scheduler.
> > > 
> > > I don't think this should be in dmcrypt, if scheduler doesn't work
> > > properly, it should be fixed or tuned for crypt access pattern.
> 
> I kinda agree but preserving (not strictly but at least most of the
> time) issuing order across stacking driver like dm probably isn't a
> bad idea.  I *think* the direction block layer should be headed is to
> reduce the amount of work it does as the speed and characteristics of
> underlying devices improve.  We could afford to do a LOT of things to
> better cater to devices with spindles but the operating margin
> continues to become narrower.  Jens, Vivek, what do you guys think?

I think we can make various block layer functionalities optional and
faster drivers can choose which ones do they want. For example,
"queue/nomerges" disables merging. May be another sys tunable or a queue
flag (which driver provides at the time of registration) for "nosorting"
can be used to reduce the amount of work block layer does.

That way slower devices can still make use of loaded block layer and
faster devices can opt out of those features.

Thanks
Vivek
