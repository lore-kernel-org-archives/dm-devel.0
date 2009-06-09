From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
Date: Tue, 9 Jun 2009 20:03:44 +0200
Message-ID: <20090609180344.GQ11363@kernel.dk>
References: <4A2E1490.7060902@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755619AbZFISDv@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A2E1490.7060902@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Tue, Jun 09 2009, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> +/*
> + * Copy request information of the original request to the clone request.
> + */
> +static void __blk_rq_prep_clone(struct request *dst, struct request *src)
> +{
> +	dst->cpu = src->cpu;
> +	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
> +	dst->cmd_type = src->cmd_type;
> +	dst->__sector = blk_rq_pos(src);
> +	dst->__data_len = blk_rq_bytes(src);
> +	dst->nr_phys_segments = src->nr_phys_segments;
> +	dst->ioprio = src->ioprio;
> +	dst->buffer = src->buffer;
> +	dst->cmd_len = src->cmd_len;
> +	dst->cmd = src->cmd;

Are you making sure that 'src' always exists while 'dst' is alive?

-- 
Jens Axboe
