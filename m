From: lixiaokeng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 3/3] multipath: get_dm_mpvec: discard broken
	maps
Date: Mon, 28 Sep 2020 14:54:23 +0800
Message-ID: <106bcd4a-0d3c-f758-ba0d-68e0bc2c2edc@huawei.com>
References: <20200821135418.28138-1-mwilck@suse.com>
	<20200821135418.28138-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200821135418.28138-4-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-GB
To: mwilck@suse.com
Cc: dm-devel@redhat.com, Zhiqiang Liu <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

Hi Martin:
  I'm sorry for forgetting to reply this. When I test with
this patch, the multipath coredump don't cause again.

Regards
Lixiaokeng

On 2020/8/21 21:54, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Use the same logic as map_discovery() to discard maps that
> couldn't be parsed successfully. If map parsing fails,
> certain vital fields of the mpp, like features or hwhandler,
> will not be set, which might cause multipath to crash later on.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 80bc4b5..2d7ec74 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -193,7 +193,7 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
>  {
>  	int i;
>  	struct multipath * mpp;
> -	char params[PARAMS_SIZE], status[PARAMS_SIZE];
> +	int flags = (cmd == CMD_LIST_SHORT ? DI_NOIO : DI_ALL);
>  
>  	if (dm_get_maps(curmp))
>  		return 1;
> @@ -205,27 +205,22 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
>  		if (refwwid && strlen(refwwid) &&
>  		    strncmp(mpp->wwid, refwwid, WWID_SIZE)) {
>  			condlog(3, "skip map %s: out of scope", mpp->alias);
> -			free_multipath(mpp, KEEP_PATHS);
> -			vector_del_slot(curmp, i);
> +			remove_map(mpp, pathvec, curmp, PURGE_VEC);
>  			i--;
>  			continue;
>  		}
>  
> -		dm_get_map(mpp->alias, &mpp->size, params);
> -		condlog(3, "params = %s", params);
> -		dm_get_status(mpp->alias, status);
> -		condlog(3, "status = %s", status);
> -
> -		disassemble_map(pathvec, params, mpp);
> -		update_pathvec_from_dm(pathvec, mpp,
> -				       (cmd == CMD_LIST_SHORT ?
> -					DI_NOIO : DI_ALL));
> +		if (update_multipath_table(mpp, pathvec, flags) != DMP_OK ||
> +		    update_multipath_status(mpp) != DMP_OK) {
> +			condlog(1, "error parsing map %s", mpp->wwid);
> +			remove_map(mpp, pathvec, curmp, PURGE_VEC);
> +			i--;
> +			continue;
> +		}
>  
>  		if (cmd == CMD_LIST_LONG)
>  			mpp->bestpg = select_path_group(mpp);
>  
> -		disassemble_status(status, mpp);
> -
>  		if (cmd == CMD_LIST_SHORT ||
>  		    cmd == CMD_LIST_LONG) {
>  			struct config *conf = get_multipath_config();
> 
