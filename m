From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
 retrying IO if thinp is out of space
Date: Thu, 23 Jul 2015 12:43:58 -0400
Message-ID: <20150723164358.GA24562@redhat.com>
References: <20150720223610.GV7943@dastard>
 <55AE6670.40903@redhat.com>
 <20150721174753.GA8563@redhat.com>
 <20150722000923.GB7943@dastard>
 <20150722010056.GC7943@dastard>
 <20150722014029.GA10628@redhat.com>
 <20150722023711.GD7943@dastard>
 <20150722133451.GB16842@redhat.com>
 <55AFC496.4000009@redhat.com>
 <20150723051043.GB3902@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150723051043.GB3902@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de
List-Id: dm-devel.ids

On Thu, Jul 23, 2015 at 03:10:43PM +1000, Dave Chinner wrote:

[..]
> I don't think knowing the bdev timeout is necessary because the
> default is most likely to be "fail fast" in this case. i.e. no
> retries, just shut down.  IOWs, if we describe the configs and
> actions in neutral terms, then the default configurations easy for
> users to understand. i.e:
> 
> bdev enospc		XFS default
> -----------		-----------
> Fail slow		Fail fast
> Fail fast		Fail slow
> Fail never		Fail never, Record in log
> EOPNOTSUPP		Fail never
> 
> With that in mind, I'm thinking I should drop the
> "permanent/transient" error classifications, and change it "failure
> behaviour" with the options "fast slow [never]" and only the slow
> option has retry/timeout configuration options.  I think the "never"
> option still needs to "fail at unmount" config variable, but we
> enable it by default rather than hanging unmount and requiring a
> manual shutdown like we do now....

I am wondering instead of 4 knobs (fast,slow,never,retry-timeout) can
we just do with one knob per error type and that is retry-timout.

retry-timeout=0 (Fail fast)
retry-timeout=X (Fail slow)
retry-timeout=-1 (Never Give up).

Also do we really need this timeout per error type.

Also would be nice if this timeout was configurable using a mount
option. Then we can just specify it during mount time and be done
with it.

Idea of auto tuning based on what block device is doing sounds reasonable
but that should not be a requirement for this patch and can go in even
later. It is one of those nice to have features.

Thanks
Vivek
