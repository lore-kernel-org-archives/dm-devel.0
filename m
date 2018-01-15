From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v5 0/4] block/dm: allow DM to defer
 blk_register_queue() until ready
Date: Mon, 15 Jan 2018 12:57:11 -0500
Message-ID: <20180115175710.GA25040@redhat.com>
References: <20180112150606.6037-1-snitzer@redhat.com>
 <1516036612.10386.2.camel@wdc.com>
 <20180115172928.GB24260@redhat.com>
 <1516037769.3951.12.camel@wdc.com>
 <20180115174837.GA24981@redhat.com>
 <1516038683.3951.14.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516038683.3951.14.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "djeffery@redhat.com" <djeffery@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 15 2018 at 12:51pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Mon, 2018-01-15 at 12:48 -0500, Mike Snitzer wrote:
> > Do I need to do something more to enable lockdep aside from set
> > CONFIG_LOCKDEP_SUPPORT=y ?
> 
> Hello Mike,
> 
> I think you also need to set CONFIG_PROVE_LOCKING=y.

Ah ok, was missing that, thanks.

Mike
