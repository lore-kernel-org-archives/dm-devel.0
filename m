From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 21:19:34 +0000
Message-ID: <20131111211934.GB24324@agk-dp.fab.redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1384190448-3861-2-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 11, 2013 at 12:20:43PM -0500, Mike Snitzer wrote:
> From: Joe Thornber <ejt@redhat.com>
> 
> Allow a cache to shrink if the blocks being removed from the cache are
> not dirty.
 
Please would you document the intended procedure here?

> +			DMERR("unable to shrink cache due to dirty blocks");

This error is highly undesirable: part of a device has been removed
while it is still needed!

How does someone go about reducing the size of the cache avoiding this
error?  (Analogy: to reduce size of a filesystem you run a filesystem
resize process before reducing the size of the block device.)

Alasdair
