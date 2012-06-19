From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [dm-devel] Ext4 and xfs problems in dm-thin on allocation and
 discard
Date: Tue, 19 Jun 2012 15:58:34 -0400
Message-ID: <20120619195834.GC22805@thunk.org>
References: <4FDF9EBE.2030809@shiftmail.org>
 <alpine.LFD.2.00.1206191601290.21961@dhcp-1-248.brq.redhat.com>
 <20120619141933.GC10637@thunk.org>
 <20120619144316.GD14208@agk-dp.fab.redhat.com>
 <20120619152856.GB7225@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120619152856.GB7225@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, Spelic <spelic@shiftmail.org>
List-Id: dm-devel.ids

On Tue, Jun 19, 2012 at 11:28:56AM -0400, Mike Snitzer wrote:
> 
> That is an lvm2 BZ but there is further kernel work needed.
> 
> It should be noted that the "external origin" feature was added to the
> thinp target with this commit: 
> http://git.kernel.org/linus/2dd9c257fbc243aa76ee6d
> 
> It is start, but external origin is kept read-only and any writes
> trigger allocation of new blocks within the thin-pool.

Hmm... maybe this is what I had been told.  I thought there was some
feature where you could take a read-only thinp snapshot of an external
volume (i.e., a pre-existing LVM2 volume, or a block device), and then
after that, make read-write snapshots using the read-only snapshot as
a base?  Is that something that works today, or is planned?  Or am I
totally confused?

And if it is something that works today, is there a web site or
documentation file that gives a recipe for how to use it if we want to
do some performance experiments (i.e., it doesn't have to be a user
friendly interface if that's not ready yet).

Thanks,

						- Ted
