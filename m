From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-mpath: Track invalid map_context
Date: Mon, 19 Mar 2012 15:20:07 +0000
Message-ID: <20120319152007.GD4495@agk-dp.fab.redhat.com>
References: <1332170128-30232-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1332170128-30232-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Alasdair Kergon <akg@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Mar 19, 2012 at 04:15:28PM +0100, Hannes Reinecke wrote:
> -	if (r < 0 || r == DM_MAPIO_REQUEUE)
> +	if (r < 0 || r == DM_MAPIO_REQUEUE) {
>  		mempool_free(mpio, m->mpio_pool);
> +		map_context->ptr = NULL;
> +	}

What about the other places that do mempool_free() ?
Should they clear it too?

Is it better to swap the statement order - clear it *before*
freeing i

Alasdair
