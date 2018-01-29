From: Mike Snitzer <snitzer@redhat.com>
Subject: [LSF/MM TOPIC] block: extend generic biosets to allow per-device
 frontpad
Date: Mon, 29 Jan 2018 16:33:00 -0500
Message-ID: <20180129213300.GC5744@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

I'd like to enable bio-based DM to _not_ need to clone bios.  But to do
so each bio-based DM target's required per-bio-data would need to be
provided by upper layer biosets (as opposed to the bioset DM currently
creates).

So my thinking is that all system-level biosets (e.g. fs_bio_set,
blkdev_dio_pool) would redirect to a device specific variant bioset IFF
the underlying device advertises the need for a specific per-bio-data
payload to be provided.

I know this _could_ become a rathole but I'd like to avoid reverting DM
back to the days of having to worry about managing mempools for the
purpose of per-io allocations.  I've grown spoiled by the performance
and elegance that comes with having the bio and per-bio-data allocated
from the same bioset.

Thoughts?
Mike
