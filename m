From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm cache: add writeback watermarks
Date: Tue, 8 Mar 2016 15:23:36 +0000
Message-ID: <20160308152335.GA4126@rh-vpn>
References: <1457448762-6784-1-git-send-email-swilton@fluentit.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1457448762-6784-1-git-send-email-swilton@fluentit.com.au>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steven Wilton <swilton@fluentit.com.au>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 08, 2016 at 10:52:42PM +0800, Steven Wilton wrote:
> Add 2 new options to the dm-cache code, writeback_low_watermark to
> keep a section of the cache dirty in order to reduce the amount
> of data being migrated from the cache to the origin, and
> writeback_high_watermark to allow a threshold to be set where the
> dirty cache entries are flushed as quick as possible.

Right. mq is being removed, or rather becoming an alias for smq (patch
posted a couple of weeks ago to dm-devel).

smq already has a writeback delay to prevent writeback of frequently
changing data:

https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-cache-policy-smq.c#L338
https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-cache-policy-smq.c#L850
https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-cache-policy-smq.c#L876

and has a threshold/watermark that triggers more aggressive writeback:

https://github.com/jthornber/linux-2.6/blob/thin-dev/drivers/md/dm-cache-policy-smq.c#L1463

I think this decision belongs in the policy, you've moved it to the
core.

Also I'm trying to avoid introducing tunables to the interface.  It's
not enough to document what the tunables do, but we also have to
explain how people should arrive at the correct values for their work
loads.

Have you tried smq?  What work load are you running?  Does your patch
improve things?

- Joe
