From: "Grant Grundler" <grundler@google.com>
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
Date: Mon, 3 Mar 2008 09:33:15 -0800
Message-ID: <da824cf30803030933j5647b0d4k61f6d110ff9f29bb@mail.gmail.com>
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>
	 <47CC2652.1080601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <47CC2652.1080601@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Mon, Mar 3, 2008 at 8:24 AM, Hannes Reinecke <hare@suse.de> wrote:

>  I would rather have rq->complete_io() to be pointing to blk_end_io in the
>  default case, this way rq->complete_io() would always be valid and we
>  would be saving us the if() clause.

This is a good idea. But...

...
>  So when using my proposal this would just become:
>
>  {
>     BUG_ON(!rq->complete_io);
>
>     return rq->complete_io(rq, error, nr_bytes, 0, NULL);
>  }

This "BUG_ON" is also an "if()" clause except
it will panic. The box will panic if the function
pointer is a null pointer and it won't be hard to
sort out why. I suggest omitting the BUG_ON.

thanks,
grant
