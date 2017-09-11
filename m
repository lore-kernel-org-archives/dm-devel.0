From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: directly insert blk-mq request from
 blk_insert_cloned_request()
Date: Mon, 11 Sep 2017 18:30:06 -0400
Message-ID: <20170911223006.GA17742@redhat.com>
References: <20170908195805.GA30517@redhat.com>
 <57b4bb39-f50c-ad5e-d47d-01f0f84ec3ca@kernel.dk>
 <20170908214236.GA49918@redhat.com>
 <49cc6184-48da-2a45-e50e-13430e14e197@kernel.dk>
 <20170908220318.GA31120@redhat.com>
 <20170911161647.GA55061@redhat.com>
 <79287d3a-62e0-912e-dcad-e7ab5297ae34@kernel.dk>
 <20170911211327.GA17344@redhat.com>
 <ed493525-57c8-6a2c-6be0-bd6b36562f09@kernel.dk>
 <20170911215134.GA17547@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170911215134.GA17547@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Sep 11 2017 at  5:51pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Sep 11 2017 at  5:27pm -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> > 
> > Does the below work for you?
> 
> I _will_ test your patch and let you know!

Tested with bfq on underlying paths and both none and bfq on upper-level
DM multipath request_queue.

Works perfectly, feel free to add my:

Tested-by: Mike Snitzer <snitzer@redhat.com>

Thanks again!
