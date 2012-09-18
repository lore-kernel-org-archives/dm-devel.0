From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm table: do not allow queue limits
	that	will exceed hardware limits
Date: Tue, 18 Sep 2012 12:40:23 +0100
Message-ID: <20120918114022.GA17356@agk-dp.fab.redhat.com>
References: <20120914204133.GA376@redhat.com>
	<213748621.1049831.1347911069189.JavaMail.root@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <213748621.1049831.1347911069189.JavaMail.root@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: David Jeffery <djeffery@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 17, 2012 at 03:44:29PM -0400, David Jeffery wrote:
> @@ -2425,6 +2425,15 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)

> +	if (limits.max_sectors == UINT_MAX)
  
Specifically, I don't want dm.c to be peering directly into limits.

It just called calculate_queue_limits() above that.
Why is calculate_queue_limits getting the limits wrong?

Alasdair
