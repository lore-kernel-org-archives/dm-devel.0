From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/5] dm mpath: reduce size of multipath
	structure
Date: Wed, 09 May 2012 08:58:53 +0200
Message-ID: <4FAA15AD.2040709@suse.de>
References: <1336514167-15393-1-git-send-email-snitzer@redhat.com>
	<1336514167-15393-4-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1336514167-15393-4-git-send-email-snitzer@redhat.com>
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
Cc: dm-devel@redhat.com, babu.moger@netapp.com, agk@redhat.com
List-Id: dm-devel.ids

On 05/08/2012 11:56 PM, Mike Snitzer wrote:
> Move multipath structure's 'lock' and 'queue_size' members to eliminate
> 2 4-byte holes.  Also use a bit within a single unsigned int for each
> existing flag (saves 8-bytes).  This allows future flags to be added
> without each consuming an unsigned int.
> =

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-mpath.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> =

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 754f38f..c351607 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -61,11 +61,11 @@ struct multipath {
>  	struct list_head list;
>  	struct dm_target *ti;
>  =

> -	spinlock_t lock;
> -
>  	const char *hw_handler_name;
>  	char *hw_handler_params;
>  =

> +	spinlock_t lock;
> +
>  	unsigned nr_priority_groups;
>  	struct list_head priority_groups;
>  =

> @@ -81,16 +81,17 @@ struct multipath {
>  	struct priority_group *next_pg;	/* Switch to this PG if set */
>  	unsigned repeat_count;		/* I/Os left before calling PS again */
>  =

> -	unsigned queue_io;		/* Must we queue all I/O? */
> -	unsigned queue_if_no_path;	/* Queue I/O if last path fails? */
> -	unsigned saved_queue_if_no_path;/* Saved state during suspension */
> +	unsigned queue_io:1;		/* Must we queue all I/O? */
> +	unsigned queue_if_no_path:1;	/* Queue I/O if last path fails? */
> +	unsigned saved_queue_if_no_path:1; /* Saved state during suspension */
> +
>  	unsigned pg_init_retries;	/* Number of times to retry pg_init */
>  	unsigned pg_init_count;		/* Number of times pg_init called */
>  	unsigned pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
>  =

> +	unsigned queue_size;
>  	struct work_struct process_queued_ios;
>  	struct list_head queued_ios;
> -	unsigned queue_size;
>  =

>  	struct work_struct trigger_event;
>  =


Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
