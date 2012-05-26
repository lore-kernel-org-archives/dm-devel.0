From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v3 13/16] Make generic_make_request handle arbitrarily
 large bios
Date: Fri, 25 May 2012 17:18:56 -0700
Message-ID: <20120526001856.GA10959@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-14-git-send-email-koverstreet@google.com>
 <20120525225852.GG5761@agk-dp.fab.redhat.com>
 <20120525231232.GH5761@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120525231232.GH5761@agk-dp.fab.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On Sat, May 26, 2012 at 12:12:33AM +0100, Alasdair G Kergon wrote:
> What I'm trying to say is, by all means, let's continue to clean up this
> patch set, but then give it some serious performance testing under
> different regimes, compare it against the status quo, do whatever
> tuning seems appropriate then let the results guide us.

Ok, that is certainly fair. I'm not _terribly_ worried about the
performance impact but it's certainly possible performance will require
some more work, we do need that testing.

What's also going to help with performance is for stacking block devices
(and possibly drivers at some point) to be changed to handle arbitrary
sized bios, so the splitting code in generic_make_request() can be
disabled for them - that should also be pretty easy at this point.

I have some other ideas/cleanups that should improve performance too but
I'll leave that for later. I really do care deeply about performance -
and it's been my experience that really the most important thing for
performance is clean, simple code and interfaces - much more than people
seem to generally assume, too...
