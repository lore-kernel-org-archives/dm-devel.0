From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/3] dm: log writes target
Date: Mon, 23 Mar 2015 14:02:45 -0400
Message-ID: <20150323180245.GE3172@redhat.com>
References: <1426797070-27463-1-git-send-email-jbacik@fb.com>
 <1426797070-27463-2-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1426797070-27463-2-git-send-email-jbacik@fb.com>
Sender: fstests-owner@vger.kernel.org
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, zab@redhat.com, fstests@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Mar 19, 2015 at 04:31:08PM -0400, Josef Bacik wrote:

[..]
> + * We log writes only after they have been flushed, this makes the log describe
> + * close to the order in which the data hits the actual disk, not its cache.  So
> + * for example the following sequence (W means write, C means complete)
> + *
> + * Wa,Wb,Wc,Cc,Ca,FLUSH,FUAd,Cb,CFLUSH,CFUAd
> + *
> + * Would result in the log looking like this
> + *
> + * c,a,flush,fuad,b,<other writes>,<next flush>
> + *

A minor nit, Should this sequence be following.

c,a,b, flush,fuad,<other writes>,<next flush>

when flush completed by that time write of b has completed too. So it
should be written first?

Thanks
Vivek
