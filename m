From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Add nr_bios to block_rq_remap tracepoint
Date: Sat, 21 Sep 2013 13:58:14 -0600
Message-ID: <20130921195814.GE2312@kernel.dk>
References: <523835AD.1030300@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <523835AD.1030300@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 17 2013, Jun'ichi Nomura wrote:
> Adding the number of bios in a remapped request to 'block_rq_remap'
> tracepoint.
> 
> Request remapper clones bios in a request to track the completion
> status of each bio. So the number of bios can be useful information
> for investigation.
> 
> Related discussions:
>   http://www.redhat.com/archives/dm-devel/2013-August/msg00084.html
>   http://www.redhat.com/archives/dm-devel/2013-September/msg00024.html
> 
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>

Thanks, added.

-- 
Jens Axboe
