From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 12/14] libmultipathpersist: use
 update_multipath_table/status, in get_mpvec
Date: Fri, 4 Sep 2020 19:05:01 -0500
Message-ID: <20200905000501.GH11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<5beca982-98a1-e48b-f86f-95810bc3c49c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5beca982-98a1-e48b-f86f-95810bc3c49c@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: lixiaokeng <lixiaokeng@huawei.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, Sep 02, 2020 at 03:24:33PM +0800, lixiaokeng wrote:
> The return values of dm_get_map, disassemble_map in get_mpvec
> were not checked. Use update_multipath_table/status to instead
> of them.
> 

Looks mostly good. I agree that we should be checking the results of
getting the raw data before we try to disassemble it. But, there's not
really any point to calling continue as the last operation of a loop.
Perhaps

if (update_multipath_table(mpp, pathvec, DI_CHECKER) == DMP_OK)
	update_multipath_status(mpp);

makes more sense.

> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  libmpathpersist/mpath_persist.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index e7256049..046fda21 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -323,7 +323,6 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
>  {
>  	int i;
>  	struct multipath *mpp;
> -	char params[PARAMS_SIZE], status[PARAMS_SIZE];
> 
>  	vector_foreach_slot (curmp, mpp, i){
>  		/*
> @@ -341,13 +340,9 @@ get_mpvec (vector curmp, vector pathvec, char * refwwid)
>  		if (refwwid && strncmp (mpp->alias, refwwid, WWID_SIZE - 1))
>  			continue;
> 
> -		dm_get_map(mpp->alias, &mpp->size, params);
> -		condlog(3, "params = %s", params);
> -		dm_get_status(mpp->alias, status);
> -		condlog(3, "status = %s", status);
> -		disassemble_map (pathvec, params, mpp);
> -		update_pathvec_from_dm(pathvec, mpp, DI_CHECKER);
> -		disassemble_status (status, mpp);
> +		if (update_multipath_table(mpp, pathvec, DI_CHECKER) != DMP_OK ||
> +		    update_multipath_status(mpp) != DMP_OK)
> +			continue;
> 
>  	}
>  	return MPATH_PR_SUCCESS ;
> -- 
