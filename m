From: Daniel Walker <dwalker@fifo99.com>
Subject: Re: [PATCH 2/3] block: Rename trace_block_remap to
 trace_block_bio_remap
Date: Fri, 18 Sep 2009 09:13:45 -0700
Message-ID: <1253290425.7060.37.camel@desktop>
References: <4AB3A393.5000709@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753486AbZIRQNg@vger.kernel.org>
In-Reply-To: <4AB3A393.5000709@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, 2009-09-19 at 00:13 +0900, Jun'ichi Nomura wrote:
>   **/
> -static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
> -                                      dev_t dev, sector_t from)
> +static void blk_add_trace_bio_remap(struct request_queue *q, struct bio
> *bio,
> +                                   dev_t dev, sector_t from)
>  {

You might need to resubmit this, you have some line wrapping in the
above lines.. Your should be able to set the patch part of the email to
"preformatted" , you don't want your mailer line wrapping .. (even
better just use git-format-patch and git-send-email) ..

Daniel
