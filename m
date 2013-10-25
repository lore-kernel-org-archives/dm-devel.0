From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 05/24] dm cache policy mq:
	implement	writeback_work() and mq_{set, clear}_dirty()
Date: Fri, 25 Oct 2013 17:06:12 +0100
Message-ID: <20131025160612.GG17070@agk-dp.fab.redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-6-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382639437-27007-6-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Thu, Oct 24, 2013 at 02:30:18PM -0400, Mike Snitzer wrote:
> From: Joe Thornber <ejt@redhat.com>
 
> --- a/drivers/md/dm-cache-policy-mq.c

> -	 * We maintain two queues of entries.  The cache proper contains

> +	 * We maintain three queues of entries.  The cache proper,

Does the Documentation file need updating too?

: The multiqueue policy has two sets of 16 queues: one set for entries
: waiting for the cache and another one for those in the cache.

> @@ -580,7 +585,16 @@ static void check_generation(struct mq_policy *mq)

Is the comment about this function no longer accurate?

: * At the moment the threshold is taken by averaging the hit counts of some
: * of the entries in the cache (the first 20 entries of the first level).

- It looks at clean before dirty?
- It looks at more than just the first level if it needs to?

> +// FIXME: can __mq_set_clear_dirty block?

Still to check this before inclusion upstream?

Alasdair
