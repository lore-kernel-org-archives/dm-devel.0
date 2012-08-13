From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v5 02/12] dm: Use bioset's front_pad for
 dm_rq_clone_bio_info
Date: Mon, 13 Aug 2012 14:44:46 -0700
Message-ID: <20120813214446.GC9541@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-3-git-send-email-koverstreet@google.com>
 <20120808220612.GA6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120808235731.GA7262@moria.home.lan>
 <CAOzFzEhPW5-edb6mnL2gNbb4956u2MbWqQovv01010PyBCbc+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEhPW5-edb6mnL2gNbb4956u2MbWqQovv01010PyBCbc+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Glanville <joseph.glanville@orionvm.com.au>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net, snitzer@redhat.com
List-Id: dm-devel.ids

On Sat, Aug 11, 2012 at 03:24:45PM +1000, Joseph Glanville wrote:
> Hi Kent, Tejun
> 
> On 9 August 2012 09:57, Kent Overstreet <koverstreet@google.com> wrote:
> >> Also, how was this tested?
> >
> > Well, AFAICT the only request based dm target is multipath, and from the
> > documentation I've seen it doesn't appear to work without multipath
> > hardware, or at least I haven't seen it documented how. So, unless
> > there's another user I missed it's not been tested.
> 
> Multipath can be tested quite easily with a loopback scsi target, you
> don't require specialized hardware.
> The easiest way to do this would probably be the built in LIO target +
> open_iscsi initiator.
> 
> I haven't attempted running this current version of the patch series
> but I haven't run into issues with bcache+multipath in the past.

Actually, I bet you have been running this code - do you think you could
check the git log for the version you're running? That'd be awesome if
you are.
