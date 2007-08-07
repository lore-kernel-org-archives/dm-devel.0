From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Fix remap handling by blktrace
Date: Tue, 7 Aug 2007 15:32:52 +0200
Message-ID: <20070807133252.GY5245@kernel.dk>
References: <46B87357.8040802@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934024AbXHGNdP@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46B87357.8040802@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: btrace <linux-btrace@vger.kernel.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Aug 07 2007, Alan D. Brunelle wrote:
> 

> 
> This patch provides more information concerning REMAP operations on block
> IOs. The additional information provides clearer details at the user level,
> and supports post-processing analysis in btt.
> 
> o  Adds in partition remaps on the same device.
> o  Fixed up the remap information in DM to be in the right order
> o  Sent up mapped-from and mapped-to device information
> 
> Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>

Thanks (again) Alan, applied!

-- 
Jens Axboe
