From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: add check for count of groups to avoid
 wild pointer access
Date: Thu, 3 Nov 2016 11:24:37 -0400
Message-ID: <20161103152436.GB21719@redhat.com>
References: <1478170170-4748-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1478170170-4748-1-git-send-email-tang.junhui@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Thu, Nov 03 2016 at  6:49am -0400,
tang.junhui@zte.com.cn <tang.junhui@zte.com.cn> wrote:

> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> pg is not assigned to a group address when count of multipath groups
> is zero in bypass_pg_num(), then it is used in bypass_pg(), which may
> cause wild pointer access.
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
> ---
>  drivers/md/dm-mpath.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index d376dc8..8c1359c 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1084,7 +1084,7 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
>  	char dummy;
>  
>  	if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
> -	    (pgnum > m->nr_priority_groups)) {
> +	    !m->nr_priority_groups || (pgnum > m->nr_priority_groups)) {
>  		DMWARN("invalid PG number supplied to switch_pg_num");
>  		return -EINVAL;
>  	}
> -- 
> 2.8.1.windows.1
> 
> 

You mention bypass_pg_num() going on to hit a NULL/"wild" pointer.  Not
immediately seeing the relation between switch_pg_num() and
bypass_pg_num().  But shouldn't bypass_pg_num() have improved bounds
checking (and/or NULL pointer checks) too?

Maybe your patch was applied with an offset and it modified
switch_pg_num() when you really meant to modify bypass_pg_num()?
