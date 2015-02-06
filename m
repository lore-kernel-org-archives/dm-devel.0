From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFCv2 03/10] dm-dedup: hash computation
Date: Fri, 6 Feb 2015 16:42:07 -0500
Message-ID: <20150206214207.GA27130@redhat.com>
References: <53ffb650.0878320a.243a.133d@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <53ffb650.0878320a.243a.133d@mx.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

On Thu, Aug 28, 2014 at 06:04:55PM -0400, Vasily Tarasov wrote:

[..]
> +#include "dm-dedup-target.h"
> +#include "dm-dedup-hash.h"
> +#include <linux/atomic.h>
> +#include <linux/blk_types.h>
> +
> +/*
> + * We are declaring and initalizaing global hash_desc, because
> + * we need to do hash computation in endio function, and this
> + * function is called in softirq context. Hence we are not
> + * allowed to perform any operation on that path which can sleep.
> + * And tfm allocation in hash_desc, at one point, tries to take
> + * semaphore and hence tries to sleep. And because of this we get
> + * BUG, which complains "Scheduling while atomic". Hence to avoid
> + * this scenario, we moved the declaration and initialization out
> + * of critical path.
> + */

Hi,

Is this comment still valid? We calculate hash when bio is submitted
from the worker thread context. So where is the softirq context here?

do_work()
 process_bio()
  handle_write()
   compute_hash_bio()

This all is happening in worker worker thread context and not softirq
context?

Thanks
Vivek
