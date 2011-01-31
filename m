From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: Re: [PATCH 2/2] dm mpath: allow table load with 0
	priority groups
Date: Mon, 31 Jan 2011 11:09:46 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4FF372B9C@cosmail01.lsi.com>
References: <1296490458-12910-1-git-send-email-snitzer@redhat.com>
	<1296490458-12910-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1296490458-12910-2-git-send-email-snitzer@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Looks good to me. 

> -----Original Message-----
> From: Mike Snitzer [mailto:snitzer@redhat.com]
> Sent: Monday, January 31, 2011 10:14 AM
> To: dm-devel@redhat.com
> Cc: Mike Snitzer; Moger, Babu
> Subject: [PATCH 2/2] dm mpath: allow table load with 0 priority groups
> 
> If an mpath device is held open when all paths in the last priority
> group have failed userspace multipathd will attempt to reload the
> associated DM table to reflect that the device no longer has any
> priority groups.  But the reload attempt always failed because the
> multipath target did not allow 0 priority groups.
> 
> Adjust multipath target to allow a table with both 0 priority groups
> and 0 for the initial priority group number.
> 
> All multipath target messages related to priority group (enable_group,
> disable_group, switch_group) will properly handle a priority group of
> 0 (will cause error).
> 
> When reloading a multipath table with 0 priority groups, userspace
> multipathd must be updated to specify an initial priority group number
> of 0 (rather than 1).

 Looks like we still have some action from multipath tool. CCing Ben..
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Babu Moger <babu.moger@lsi.com>
  
> ---
>  drivers/md/dm-mpath.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 97842c6..bc824bd 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -844,8 +844,8 @@ static int multipath_ctr(struct dm_target *ti,
> unsigned int argc,
>  {
>  	/* target parameters */
>  	static struct param _params[] = {
> -		{1, 1024, "invalid number of priority groups"},
> -		{1, 1024, "invalid initial priority group number"},
> +		{0, 1024, "invalid number of priority groups"},
> +		{0, 1024, "invalid initial priority group number"},
>  	};
> 
>  	int r;
> @@ -879,6 +879,13 @@ static int multipath_ctr(struct dm_target *ti,
> unsigned int argc,
>  	if (r)
>  		goto bad;
> 
> +	if ((!m->nr_priority_groups && next_pg_num) ||
> +	    (m->nr_priority_groups && !next_pg_num)) {
> +		ti->error = "invalid initial priority group";
> +		r = -EINVAL;
> +		goto bad;
> +	}
> +
>  	/* parse the priority groups */
>  	while (as.argc) {
>  		struct priority_group *pg;
> @@ -1417,7 +1424,7 @@ static int multipath_status(struct dm_target *ti,
> status_type_t type,
>  	else if (m->current_pg)
>  		pg_num = m->current_pg->pg_num;
>  	else
> -			pg_num = 1;
> +		pg_num = (m->nr_priority_groups ? 1 : 0);
> 
>  	DMEMIT("%u ", pg_num);
> 
> --
> 1.7.3.4
