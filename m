From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] blk/core: Gracefully handle unset make_request_fn
Date: Thu, 23 Jan 2020 05:35:41 -0500
Message-ID: <20200123103541.GA28102@redhat.com>
References: <20200123091713.12623-1-stefan.bader@canonical.com>
 <20200123091713.12623-2-stefan.bader@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200123091713.12623-2-stefan.bader@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Tyler Hicks <tyler.hicks@canonical.com>
List-Id: dm-devel.ids

On Thu, Jan 23 2020 at  4:17am -0500,
Stefan Bader <stefan.bader@canonical.com> wrote:

> When device-mapper adapted for multi-queue functionality, they
> also re-organized the way the make-request function was set.
> Before, this happened when the device-mapper logical device was
> created. Now it is done once the mapping table gets loaded the
> first time (this also decides whether the block device is request
> or bio based).
> 
> However in generic_make_request(), the request function gets used
> without further checks and this happens if one tries to mount such
> a partially set up device.
> 
> This can easily be reproduced with the following steps:
>  - dmsetup create -n test
>  - mount /dev/dm-<#> /mnt
> 
> This maybe is something which also should be fixed up in device-
> mapper.

I'll look closer at other options.

> But given there is already a check for an unset queue
> pointer and potentially there could be other drivers which do or
> might do the same, it sounds like a good move to add another check
> to generic_make_request_checks() and to bail out if the request
> function has not been set, yet.
> 
> BugLink: https://bugs.launchpad.net/bugs/1860231

From that bug;
"The currently proposed fix introduces no chance of stability
regressions. There is a chance of a very small performance regression
since an additional pointer comparison is performed on each block layer
request but this is unlikely to be noticeable."

This captures my immediate concern: slowing down everyone for this DM
edge-case isn't desirable.

Mike
