From: Andi Kleen <andi@firstfloor.org>
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3
Date: Sun, 10 Oct 2010 19:44:54 +0200
Message-ID: <20101010174454.GA21681@basil.fritz.box>
References: <20101010115941.GA8539@basil.fritz.box>
 <4CB1B3B9.4030205@redhat.com>
 <20101010130842.GE8256@basil.fritz.box>
 <4CB1DD1A.5080906@redhat.com>
 <20101010162257.GA1272@redhat.com>
 <20101010170151.GD28828@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101010170151.GD28828@agk-dp.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>, Mike Snitzer <snitzer@redhat.com>, Andi Kleen <ak@linux.intel.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 10, 2010 at 06:01:51PM +0100, Alasdair G Kergon wrote:
> On Sun, Oct 10, 2010 at 12:22:57PM -0400, Mike Snitzer wrote:
> > this out quite yet.  You have 4 patches yet you say conceptually there
> > are 2 distinct changes.
>  
> IOW should we end up with 2 bisectable patches here?
> 
> And the potentially-broken/poorly-performing stacked async should be
> explained in comments inline perhaps if we're choosing to ignore this
> apparent regression.

It's not broken AFAIK and it will not perform worse than the original
single thread work queue.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
