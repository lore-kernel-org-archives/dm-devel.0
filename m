From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v3 2/3] block: allow gendisk's request_queue
 registration to be deferred
Date: Thu, 11 Jan 2018 14:50:13 -0500
Message-ID: <20180111195013.GB31104@redhat.com>
References: <20180111021256.37490-1-snitzer@redhat.com>
 <20180111021256.37490-3-snitzer@redhat.com>
 <804df5df-2598-df69-757d-85df18185d4c@suse.de>
 <20180111170430.GA30621@redhat.com>
 <1515691112.2752.21.camel@wdc.com>
 <20180111172943.GA30762@redhat.com>
 <1515692836.2752.42.camel@wdc.com>
 <20180111192027.GA31104@redhat.com>
 <1515699161.2752.49.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515699161.2752.49.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hare@suse.de" <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  2:32pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-11 at 14:20 -0500, Mike Snitzer wrote:
> > Yes, I noticed the use of sysfs_lock also.  I've fixed it up earlier in
> > my v4 patchset and build on it.  I'll add your Reported-by too.
> 
> Hello Mike,
> 
> There are many more inconsistencies with regard to queue flag manipulation
> in the block layer core and in block drivers. I'm working on a series to
> address all inconsistencies in the block layer and in the sd driver.

OK, well I needed to fix this anyway to build my changes up properly.
I think my v4 changes are ready for Jens to pick up, so you'll just have
to rebase.

I'll send out v4 shortly.

Thanks,
Mike
