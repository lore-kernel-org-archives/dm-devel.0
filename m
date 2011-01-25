From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH wq#for-2.6.38] workqueue: use WQ_MEM_RECLAIM instead of
 WQ_RESCUER
Date: Tue, 25 Jan 2011 14:36:56 +0100
Message-ID: <20110125133656.GW27510@htj.dyndns.org>
References: <20101231140109.GL18831@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101231140109.GL18831@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

On Fri, Dec 31, 2010 at 03:01:09PM +0100, Tejun Heo wrote:
> WQ_RESCUER is now an internal flag and should only be used in the
> workqueue implementation proper.  Use WQ_MEM_RECLAIM instead.
> 
> This doesn't introduce any functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: dm-devel@redhat.com
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Neil Brown <neilb@suse.de>

Applied to wq#for-2.6.39 sans the redundant gfs2 part.

Thanks.

-- 
tejun
