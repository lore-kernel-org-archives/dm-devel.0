From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM TOPIC] block: extend generic biosets to allow per-device
 frontpad
Date: Fri, 2 Feb 2018 17:55:21 -0500
Message-ID: <20180202225521.GA10068@redhat.com>
References: <20180129213300.GC5744@redhat.com>
 <87zi4r29sa.fsf@notabene.neil.brown.name>
 <20180202160834.GA8192@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180202160834.GA8192@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Feb 02 2018 at 11:08am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:
> 
> But if the bioset enhancements are implemented properly then the kernels
> N biosets shouldn't need to be in doubt.  They'll all just adapt to have
> N backing mempools (N being for N conflicting front_pad requirements).

This should've read:

"But if the bioset enhancements are implemented properly then the kernels
N biosets ability to provide adequate front_pad shouldn't need to be in
doubt.  They'll all just adapt to have M backing mempools (for M
conflicting front_pad requirements)."

What this implies is there would need to be a way for the bioset
code to maintain a global graph of all biosets in the system.  And when
a device comes along with a unique bioset front_pad requirement, that
isn't already met by existing mempool, the device's driver (DM in
my case) would call into a bioset interface that would add a new backing
mempool, that accounts for the front_pad increase, to each bioset in the
system.

Not liking that (DM) device creation would potentially spawn a new
mempool within each existing bioset.  It could/would easily result in
many of those mempools going completely unused.

In addition: how would a bio_alloc_bioset() call _know_ the bio was for
use on a specific block device?  The entire beauty of the existing
bio_set code, especially for upper layers like filesystems, is it _is_
device agnostic.

So all this could be the worst idea ever.. not sure.  I've deferred
judging it one way or the other because the details are shakey at best.

And I still need to look closer at all the existing code.

Mike
