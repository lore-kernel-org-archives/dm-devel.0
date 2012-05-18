From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 06/13] block: Add bio_reset()
Date: Fri, 18 May 2012 09:16:08 -0700
Message-ID: <20120518161608.GF19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <9953623f6fae97018e59d96971a2612caf6c01e7.1337308722.git.koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9953623f6fae97018e59d96971a2612caf6c01e7.1337308722.git.koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de
List-Id: dm-devel.ids

Hello,

On Thu, May 17, 2012 at 10:59:53PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> Reusing bios is something that's been highly frowned upon in the past,
> but driver code keeps doing it anyways. If it's going to happen anyways,
> we should provide a generic method.
> 
> This'll help with getting rid of bi_destructor.

It would be nice to explain a bit why this helps bi_destructor
removal.

> +#define BIO_RESET_OFFSET	offsetof(struct bio, bi_max_vecs)

Maybe better named BIO_RESET_BYTES?  As offset tends to indicate the
start of a region.

Thanks.

-- 
tejun
