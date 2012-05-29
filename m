From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Date: Mon, 28 May 2012 23:34:34 -0400
Message-ID: <20120529033434.GC10175@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120529015438.GZ5091@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120529015438.GZ5091@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net, mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com, tj@kernel.org, sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com, Dave Chinner <dchinner@redhat.com>, tytso@google.com
List-Id: dm-devel.ids

On Tue, May 29, 2012 at 11:54:38AM +1000, Dave Chinner wrote:
> It also allowed us to build IOs that span
> entire RAID stripe widths, thereby avoiding potential RAID RMW
> cycles, and even allowing high end raid controllers to trigger BBWC
> bypass fast paths that could double or triple the write throughput
> of the arrays...

merge_bvec_fn has nothing to do with that though, since for one there
aren't any merge_bvec_fn's being called in the IO paths on these high
end disk arrays, and for our software raid implementations their
merge_bvec_fns will keep you from sending them bios that span entire
stripes.
