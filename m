From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-snap-persistent-fix-dtr-cleanup.patch
Date: Thu, 19 Mar 2009 22:42:31 +0000
Message-ID: <20090319224231.GX3063@agk.fab.redhat.com>
References: <1236202436.28664.8.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1236202436.28664.8.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Mar 04, 2009 at 03:33:56PM -0600, Jon Brassow wrote:
> @@ -481,10 +484,17 @@ static void persistent_dtr(struct dm_exc
>  {
>  	struct pstore *ps = get_info(store);
>  
> -	destroy_workqueue(ps->metadata_wq);
> -	dm_io_client_destroy(ps->io_client);
> -	vfree(ps->callbacks);
> +	/* Created in read_header */
> +	if (ps->io_client)
> +		dm_io_client_destroy(ps->io_client);
>  	free_area(ps);
> +
> +	/* Allocated in persistent_read_metadata */
> +	if (ps->callbacks)
> +		vfree(ps->callbacks);
> +
> +	/* Don't need to check these, because they are done in ctr */
> +	destroy_workqueue(ps->metadata_wq);
>  	kfree(ps);
>  }
  
I presume it's safe to reorder those operations as the workqueue is
guaranteed to be empty?  It needs an inline comment though.
(Or can we just keep the original, logical, order?)

Alasdair
-- 
agk@redhat.com
