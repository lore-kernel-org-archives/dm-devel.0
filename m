From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v5 0/4] block/dm: allow DM to defer
 blk_register_queue() until ready
Date: Fri, 12 Jan 2018 11:13:48 -0500
Message-ID: <20180112161348.GA4782@redhat.com>
References: <20180112150606.6037-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112150606.6037-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: David Jeffery <djeffery@redhat.com>, Ming Lei <tom.leiming@gmail.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Bart.VanAssche@wdc.com
List-Id: dm-devel.ids

On Fri, Jan 12 2018 at 10:06am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi Jens,
> 
> I'm submitting this v5 with more feeling now ;)

Of course PATCH 02/04 needed a v6.

> I've distilled the changes down to be quite minimal.  Hopefully this
> will help you and others review.

I could make it even simpler by dropping 02/04 entirely.  But I do think
it worthwhile to try to get 02/04 in at this time too.

> I've also done a dry-run of applying 4.16 block changes and then
> merging dm-4.16; no merge conflicts:
> https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=block-4.16
> https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=dm-4.16
> https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/log/?h=block-4.16_dm-4.16
> 
> And all tests very well for me.
> 
> Please consider for 4.16, thanks!

Anyway, I've genuinely tested with blk-mq now.  Sorry for all the
iterations on this patchset in such rapid succession.  Obviously I know
it doesn't instill confidence...

But I really would appreciate you giving this patchset serious
consideration.

DM is long overdue for this fix.

Thanks,
Mike
