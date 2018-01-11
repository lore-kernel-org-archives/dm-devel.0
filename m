From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v3 2/3] block: allow gendisk's request_queue
 registration to be deferred
Date: Thu, 11 Jan 2018 12:29:43 -0500
Message-ID: <20180111172943.GA30762@redhat.com>
References: <20180111021256.37490-1-snitzer@redhat.com>
 <20180111021256.37490-3-snitzer@redhat.com>
 <804df5df-2598-df69-757d-85df18185d4c@suse.de>
 <20180111170430.GA30621@redhat.com>
 <1515691112.2752.21.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515691112.2752.21.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hare@suse.de" <hare@suse.de>, "hch@lst.de" <hch@lst.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at 12:18pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-11 at 12:04 -0500, Mike Snitzer wrote:
> > So my v4, that I'll send out shortly, won't be using test_and_clear_bit()
> 
> Please use queue_flag_set(), queue_flag_clear(), queue_flag_test_and_clear() and/or
> queue_flag_test_and_set() to manipulate queue flags.

Can you please expand on this?  My patch is only using test_bit().

So your comment isn't relevant.

Mike
