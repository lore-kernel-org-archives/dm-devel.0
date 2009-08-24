From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Seperate read and write statistics of in_flight
	requests
Date: Mon, 24 Aug 2009 13:07:36 +0200
Message-ID: <20090824110735.GI12579@kernel.dk>
References: <200908241603.15158.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752244AbZHXLHg@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200908241603.15158.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Mark Landis <mark.landis@teradata.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Aug 24 2009, Nikanth Karthikesan wrote:
> Currently, there is a single in_flight counter measuring the number of
> requests in the request_queue. But some monitoring tools would like to know
> how many read requests and write requests are in progress. Split the current
> in_flight counter into two seperate counters for read and write.
> 
> This patch is based on a patch from Mark Landis <mark.landis@teradata.com>

With fear of stating the obvious, this changes the output format of the
exported stat files. This can/will break existing tools.

-- 
Jens Axboe
