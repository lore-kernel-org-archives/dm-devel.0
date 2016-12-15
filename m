From: Christoph Hellwig <hch@infradead.org>
Subject: Re: trouble with generic/081
Date: Thu, 15 Dec 2016 00:42:24 -0800
Message-ID: <20161215084224.GA14395@infradead.org>
References: <20161214164314.GA25105@infradead.org>
 <20161215063650.GJ4326@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161215063650.GJ4326@dastard>
Sender: fstests-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: eguan@redhat.com, fstests@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Dec 15, 2016 at 05:36:50PM +1100, Dave Chinner wrote:
> Yup, same here. My local patch is this:

I have a sleep 1 before the unmount.  To be honest this lvm behavior
of auto-unmounting on error seems like a huge mess, I wonder if there is
a way to disable it?

Even on a production system I'd much rather have a shutdown XFS fs
than LVM trying to unmount, probably hanging because there are busy
fds on the fs, and if not the application might not write to another
fs becaus of this.  It's just an amazingly stupid idea.

> 
> ---
>  tests/generic/081 | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tests/generic/081 b/tests/generic/081
> index 11755d4d89ff..ff33ffaa4fb8 100755
> --- a/tests/generic/081
> +++ b/tests/generic/081
> @@ -36,6 +36,11 @@ _cleanup()
>  	rm -f $tmp.*
>  	# lvm may have umounted it on I/O error, but in case it does not
>  	$UMOUNT_PROG $mnt >/dev/null 2>&1
> +
> +	# on a pmem device, the vgremove/pvremove commands fail immediately
> +	# after unmount. Wait a bit before removing them in the hope it
> +	# succeeds.
> +	sleep 5
>  	$LVM_PROG vgremove -f $vgname >>$seqres.full 2>&1
>  	$LVM_PROG pvremove -f $SCRATCH_DEV >>$seqres.full 2>&1
>  }
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
