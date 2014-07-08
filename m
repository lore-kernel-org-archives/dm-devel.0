From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix an error code in local_init()
Date: Tue, 8 Jul 2014 12:21:28 -0400
Message-ID: <20140708162127.GA23439@redhat.com>
References: <20140708105536.GC19737@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140708105536.GC19737@mwanda>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Jul 08 2014 at  6:55am -0400,
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We return success if we can't allocate a work queue but we should return
> -ENOMEM.  The code was a bit messy so that's why this small bug was
> introduced and I have cleaned that as well.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan!  I folded your fix into the commit that introduced this bug
because that commit was marked for stable and will be sent to Linus
shortly.  See the new rebased commit here:

https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=58f3fce6ee8c37c1c18f36439102d5cccc5363c8
