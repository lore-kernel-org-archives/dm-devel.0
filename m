From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/13] dm-mpath: Introduce assign_bit()
Date: Thu, 27 Apr 2017 08:40:41 +0200
Message-ID: <92134c1b-9a0a-e658-507a-450f407bae27@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-13-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-13-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On 04/26/2017 08:37 PM, Bart Van Assche wrote:
> This patch does not change any functionality but makes the code
> easier to read.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/md/dm-mpath.c | 37 ++++++++++++++++---------------------
>  1 file changed, 16 insertions(+), 21 deletions(-)
> =

> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 0eafe7a2070b..57b467207741 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -613,6 +613,14 @@ static void process_queued_bios(struct work_struct *=
work)
>  	blk_finish_plug(&plug);
>  }
>  =

> +static void assign_bit(bool value, long nr, unsigned long *addr)
> +{
> +	if (value)
> +		set_bit(nr, addr);
> +	else
> +		clear_bit(nr, addr);
> +}
> +
>  /*
>   * If we run out of usable paths, should we queue I/O or error it?
>   */
> @@ -622,23 +630,12 @@ static int queue_if_no_path(struct multipath *m, bo=
ol queue_if_no_path,
>  	unsigned long flags;
>  =

>  	spin_lock_irqsave(&m->lock, flags);
> -
> -	if (save_old_value) {
> -		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
> -			set_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
> -		else
> -			clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
> -	} else {
> -		if (queue_if_no_path)
> -			set_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
> -		else
> -			clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
> -	}
> -	if (queue_if_no_path || dm_noflush_suspending(m->ti))
> -		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
> -	else
> -		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
> -
> +	assign_bit((save_old_value &&
> +		    test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) ||
> +		   (!save_old_value && queue_if_no_path),
> +		   MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
> +	assign_bit(queue_if_no_path || dm_noflush_suspending(m->ti),
> +		   MPATHF_QUEUE_IF_NO_PATH, &m->flags);
>  	spin_unlock_irqrestore(&m->lock, flags);
>  =

>  	if (!queue_if_no_path) {
> @@ -1593,10 +1590,8 @@ static void multipath_resume(struct dm_target *ti)
>  	unsigned long flags;
>  =

>  	spin_lock_irqsave(&m->lock, flags);
> -	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags))
> -		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
> -	else
> -		clear_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
> +	assign_bit(test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags),
> +		   MPATHF_QUEUE_IF_NO_PATH, &m->flags);
>  	spin_unlock_irqrestore(&m->lock, flags);
>  }
>  =

> =

Not that it makes the code easier to read, but it's certainly shorter.
Personally, I would love to do away with the 'SAVED_QUEUE_IF_NO_PATH'
thingie. But anyway.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
