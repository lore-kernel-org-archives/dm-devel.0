From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] blk-lib: fix error reporting
Date: Tue, 8 Jul 2014 02:50:38 -0700
Message-ID: <20140708095038.GA31180@infradead.org>
References: <alpine.LRH.2.02.1407031514320.3347@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407031514320.3347@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

> +	if (unlikely(err))
> +		ACCESS_ONCE(bb->error) = err;

I can't see a reason for the ACCESS_ONCE here.

Also the likely/unlikely annotations here smell like premature
optimization.

Otherwise looks good to me.
