From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/1] block: add lld busy state exporting interface
Date: Wed, 1 Oct 2008 20:31:08 +0200
Message-ID: <20081001183107.GM19428@kernel.dk>
References: <20080929.113558.112628070.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080929.113558.112628070.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, akpm@linux-foundation.org, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Mon, Sep 29 2008, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> I hope the previous RFC patch(*) would be no problem, since I haven't
> gotten any negative comment.
>     (*) http://lkml.org/lkml/2008/9/25/262
> 
> So could you take this patch for 2.6.28 additionally?
> This patch adds a new interface for request stacking drivers.
> There should be no regression risk.
> 
> This patch was created on top of the commit below of for-2.6.28.
> ---------------------------------------------------------------------
> commit e857b07acc3f1352224f380fcbf26ef985116cc8
> Author: Sven Schuetz <sven@linux.vnet.ibm.com>
> Date:   Fri Sep 26 10:58:02 2008 +0200
> 
>     include blktrace_api.h in headers_install
> ---------------------------------------------------------------------

Applied

-- 
Jens Axboe

