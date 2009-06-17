From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: init_emergency_isa_pool calling mempool_create in non-sleeping
 context
Date: Wed, 17 Jun 2009 15:45:18 -0700
Message-ID: <4A3971FE.7040700@goop.org>
References: <4A396195.8060503@goop.org> <0f79c2d4513c50184383e223d3d2ee97.squirrel@neil.brown.name> <20090617224219.GA9405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090617224219.GA9405@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On 06/17/09 15:42, Mike Snitzer wrote:
> This has been resolved and is waiting to be pushed along with the rest
> of the DM changes for 2.6.31.
>
> See:
> ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-table-establish-queue-limits-by-copying-table-limits.patch
>   

OK, good to know.

> Maybe this fix should go now rather than wait a day or so for the larger
> DM push?
>   

The machine booted fine with no apparent badness, so I don't think its
urgent.  I just reported it for diligence's sake.

    J
