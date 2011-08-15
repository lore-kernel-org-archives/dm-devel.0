From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch,v3] block: fix flush machinery for stacking drivers with
 differring flush flags
Date: Mon, 15 Aug 2011 17:49:25 +0200
Message-ID: <20110815154925.GG4254@htj.dyndns.org>
References: <x49vcty7k2e.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49vcty7k2e.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, shaohua <shli@kernel.org>
List-Id: dm-devel.ids

On Mon, Aug 15, 2011 at 11:47:53AM -0400, Jeff Moyer wrote:
...
> Now, however, we don't get into the flush machinery at all.  Instead,
> __elv_next_request just hands a request with flush and fua bits set to
> the scsi_request_fn, even if the underlying request_queue does not
> support flush or fua.
> 
> The agreed upon approach is to fix the flush machinery to allow
> stacking.  While this isn't used in practice (since there is only one
> request-based dm target, and that target will now reflect the flush
> flags of the underlying device), it does future-proof the solution, and
> make it function as designed.
> 
> In order to make this work, I had to add a field to the struct request,
> inside the flush structure (to store the original req->end_io).  Shaohua
> had suggested overloading the union with rb_node and completion_data,
> but the completion data is used by device mapper and can also be used by
> other drivers.  So, I didn't see a way around the additional field.
> 
> I tested this patch on an HP EVA with both ext4 and xfs, and it recovers
> the lost performance.  Comments and other testers, as always, are
> appreciated.
> 
> Cheers,
> Jeff
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks a lot for the persistence. :)

-- 
tejun
