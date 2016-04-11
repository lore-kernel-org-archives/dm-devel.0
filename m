From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: MAINTAINERS: correct entry for LVM
Date: Mon, 11 Apr 2016 19:52:35 -0400
Message-ID: <20160411235235.GA28565@redhat.com>
References: <1460388039-20282-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460388039-20282-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Shaohua Li <shli@kernel.org>, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Apr 11 2016 at 11:20am -0400,
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> The entry of dm-devel@redhat.com was duplicated and the duplicate entry
> was marked as a Maintainer but it appears from the email address that it
> is a List. So remove the entry of M and only keep the L entry.
> 
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 51891b2..1c32e82 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3557,7 +3557,6 @@ S:	Maintained
>  DEVICE-MAPPER  (LVM)
>  M:	Alasdair Kergon <agk@redhat.com>
>  M:	Mike Snitzer <snitzer@redhat.com>
> -M:	dm-devel@redhat.com
>  L:	dm-devel@redhat.com
>  W:	http://sources.redhat.com/dm
>  Q:	http://patchwork.kernel.org/project/dm-devel/list/
> -- 
> 1.9.1
> 

Nack.

DM isn't unique here.  XFS does the same thing:

XFS FILESYSTEM
P:      Silicon Graphics Inc
M:      Dave Chinner <david@fromorbit.com>
M:      xfs@oss.sgi.com
L:      xfs@oss.sgi.com
...

There really is more important stuff to deal with than bothering about
MAINTAINERS entries like this.  Please stop.
