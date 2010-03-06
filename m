From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] blkdev: fix merge_bvec_fn return value
	checks
Date: Sat, 6 Mar 2010 02:20:15 +0000
Message-ID: <20100306022015.GU27852@agk-dp.fab.redhat.com>
References: <20100303191613.GB18480@redhat.com> <87lje9kx9i.fsf@openvz.org> <20100303200734.GW5768@kernel.dk> <Pine.LNX.4.64.1003040629230.990@hs20-bc2-1.build.redhat.com> <20100304121931.GB5768@kernel.dk> <Pine.LNX.4.64.1003041615120.17032@hs20-bc2-1.build.redhat.com> <20100305073059.GI5768@kernel.dk> <20100306085651.1a571571@notabene.brown> <20100305222748.GT27852@agk-dp.fab.redhat.com> <20100306105237.0a8621ed@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100306105237.0a8621ed@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Sat, Mar 06, 2010 at 10:52:37AM +1100, Neil Brown wrote:
> But my first suggestion, that splitting could be made easier, still stands.

In full agreement we should try to make it easier.

> And do you honour merge_bvec_fn's of underlying devices?  A quick grep
> suggests you do only for dm-linear and dm-crypt.  

We implemented it to address some specific performance problems reported by
people using those targets.  So far there hasn't been any pressing need to
implement it for other targets.

> This suggests to me that it
> is actually a hard interface to support completely in a stacked device, so we
> might be better off without it.

All this code is hard - but very useful.  The direction I want to explore when
I finally get some time to work on this is one which will probably make more
use of, and extend, merge_bvec.

> that it makes sense to only require that the lowest level does the
> splitting, as that is where the specifics on what might be required exists.

We have a hybrid model at the moment - some stuff dealt with top-down, other
stuff bottom-up.  This thread describes just one of several problems related to
this.  In the next incarnation of device-mapper I hope we'll find a way to
eliminate all of them together.  Maybe I'll finally get time later this year to
start working on these ideas properly.

Alasdair
