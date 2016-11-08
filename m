From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: disallow changing max_sectors_kb on a request
 stacking device
Date: Mon, 7 Nov 2016 22:34:57 -0500
Message-ID: <20161108033457.GA30325@redhat.com>
References: <20161028194549.14556-1-snitzer@redhat.com>
 <20161107164029.GA27464@redhat.com>
 <20161107192646.GA11572@redhat.com>
 <8d0f16fe-7293-3b1c-1c60-32a50c77fa89@kernel.dk>
 <20161107212732.GA28478@redhat.com>
 <yq1zilau1rz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1zilau1rz.fsf@sermon.lab.mkp.net>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 07 2016 at  9:46pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike,
> 
> Mike> You're suggesting that when the DM multipath device's limits are
> Mike> stacked up from the underlying devices: cap the mpath's
> Mike> max_hw_sectors to the underlying devices' max_sectors?
> 
> That will break SG_IO, firmware upgrades, etc. (things you probably
> shouldn't do on the MP device in the first place but which users often
> do).
> 
> However, doesn't it make more sense to tweak limits on DM device instead
> of the underlying ones? It seems a bit counter-intuitive to me to change
> max_sectors_kb on a different device than the one where the filesystem
> whose max I/O size you want to change is located.

As you know, the limits are stacked from the bottom-up.

> I guess this brings us back to the desire to be able to restack the
> limits at will when something changes somewhere...

Tough to do that in a race-free way when DM multipath requests are
cloned for submission to the underlying devices.

As the commit header from this thread mentioned, what I've arrived at is
to have multipathd establish a desired max_sectors_kb (if configured to
do so in multipath.conf) on the underlying paths _before_ the multipath
device is created.  Yet to check with Ben Marzinski or others but it
seems like a reasonable feature (and really the cleaniset way to deal
with this issue IMHO.. no need for lots of kernel code changes for
something so niche).
