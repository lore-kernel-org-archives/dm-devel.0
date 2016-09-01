From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/9] dm: Rename a function argument
Date: Wed, 31 Aug 2016 23:29:53 -0400
Message-ID: <20160901032952.GC4741@redhat.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
	<0753eed4-ba3a-a747-648d-cd5520916134@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0753eed4-ba3a-a747-648d-cd5520916134@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 31 2016 at  6:16pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Rename 'interruptible' into 'sleep_state' to make it clear that this
> argument is a task state instead of a boolean.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

Shouldn't the type also be changed from int to long (to match 'state'
member from 'struct task_struct')?

> ---
>  drivers/md/dm.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index fa9b1cb..1d3627c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1934,7 +1934,8 @@ void dm_put(struct mapped_device *md)
>  }
>  EXPORT_SYMBOL_GPL(dm_put);
>  
> -static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
> +/* @sleep_state: e.g. TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE */
> +static int dm_wait_for_completion(struct mapped_device *md, int sleep_state)
>  {
>  	int r = 0;
>  	DECLARE_WAITQUEUE(wait, current);
> @@ -1942,12 +1943,12 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
>  	add_wait_queue(&md->wait, &wait);
>  
>  	while (1) {
> -		set_current_state(interruptible);
> +		set_current_state(sleep_state);
>  
>  		if (!md_in_flight(md))
>  			break;
>  
> -		if (interruptible == TASK_INTERRUPTIBLE &&
> +		if (sleep_state == TASK_INTERRUPTIBLE &&
>  		    signal_pending(current)) {
>  			r = -EINTR;
>  			break;
> @@ -2075,6 +2076,10 @@ static void unlock_fs(struct mapped_device *md)
>  }
>  
>  /*
> + * @suspend_flags: DM_SUSPEND_LOCKFS_FLAG and/or DM_SUSPEND_NOFLUSH_FLAG
> + * @sleep_state: e.g. TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE
> + * @dmf_suspended_flag: DMF_SUSPENDED or DMF_SUSPENDED_INTERNALLY
> + *
>   * If __dm_suspend returns 0, the device is completely quiescent
>   * now. There is no request-processing activity. All new requests
>   * are being added to md->deferred list.
> @@ -2082,7 +2087,7 @@ static void unlock_fs(struct mapped_device *md)
>   * Caller must hold md->suspend_lock
>   */
>  static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
> -			unsigned suspend_flags, int interruptible,
> +			unsigned suspend_flags, int sleep_state,
>  			int dmf_suspended_flag)
>  {
>  	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
> @@ -2149,7 +2154,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
>  	 * We call dm_wait_for_completion to wait for all existing requests
>  	 * to finish.
>  	 */
> -	r = dm_wait_for_completion(md, interruptible);
> +	r = dm_wait_for_completion(md, sleep_state);
>  	if (!r)
>  		set_bit(dmf_suspended_flag, &md->flags);
>  
> -- 
> 2.9.3
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
