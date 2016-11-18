From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/7] dm-mpath: Document a locking assumption
Date: Thu, 17 Nov 2016 19:07:17 -0500
Message-ID: <20161118000717.GA32114@redhat.com>
References: <e83f8718-9e73-5544-3bcc-4d9851b90ba1@sandisk.com>
	<951713a6-d3ff-43ac-489b-613944a2b085@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <951713a6-d3ff-43ac-489b-613944a2b085@sandisk.com>
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

On Tue, Nov 15 2016 at  6:33pm -0500,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Document that __pg_init_all_paths() must be called with
> multipath.lock held.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  drivers/md/dm-mpath.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index e477af8..f1e226d 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -348,6 +348,8 @@ static int __pg_init_all_paths(struct multipath *m)
>  	struct pgpath *pgpath;
>  	unsigned long pg_init_delay = 0;
>  
> +	lockdep_assert_held(&m->lock);
> +
>  	if (atomic_read(&m->pg_init_in_progress) || test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
>  		return 0;
>  
> -- 
> 2.10.1
> 

The leading underscores document the need for locking
(__pg_init_all_paths vs pg_init_all_paths).
