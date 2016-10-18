From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/3] segment faulty occured in dm_get_status()
Date: Tue, 18 Oct 2016 11:21:09 -0500
Message-ID: <20161018162109.GK1972@octiron.msp.redhat.com>
References: <1476759069-9832-1-git-send-email-tang.junhui@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1476759069-9832-1-git-send-email-tang.junhui@zte.com.cn>
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
Cc: dm-devel@redhat.com, zhang.kai16@zte.com.cn
List-Id: dm-devel.ids

On Tue, Oct 18, 2016 at 10:51:07AM +0800, tang.junhui@zte.com.cn wrote:
> From: "tang.junhui" <tang.junhui@zte.com.cn>
> 
> Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>

ACK. Obviously we don't want uninitialized pointers.  But do you know
what as going on with the device that caused it to return no target? Was
there simply no table loaded for the device? 

-Ben

> 
> segment faulty occured in dm_get_status(), the call trace is:
> ----------------------------------------------------------------------
> (gdb) bt
> 0  0x000000338ec328a5 in raise () from /lib64/libc.so.6
> 1  0x000000338ec3400d in abort () from /lib64/libc.so.6
> 2  0x000000000040596d in sigsegv ()
> 3  <signal handler called>
> 4  0x000000338ec480ac in vfprintf () from /lib64/libc.so.6
> 5  0x000000338ec6f9d2 in vsnprintf () from /lib64/libc.so.6
> 6  0x000000338ec4f4a3 in snprintf () from /lib64/libc.so.6
> 7  0x00007f43fe66bbb9 in dm_get_status (name=0x7f43f0001eb0 "spathe",
> outstatus=<value optimized out>) at devmapper.c:521
> 8  0x00007f43fe68c058 in update_multipath_status (mpp=0x7f43f000ad60,
> pathvec=<value optimized out>) at structs_vec.c:465
> 9  update_multipath_strings (mpp=0x7f43f000ad60, pathvec=<value optimized
> out>) at structs_vec.c:495
> 10 0x0000000000409056 in check_path ()
> 11 0x0000000000409c7e in checkerloop ()
> 12 0x0000003b27207851 in start_thread () from /lib64/libpthread.so.0
> 13 0x000000338ece890d in clone () from /lib64/libc.so.6
> -----------------------------------------------------------------------
> we debuged the code, and found that targets information storing in the
> list dmt->head which fetching from kernel by executing dm_task_run()
> is null.
> -----------------------------------------------------------------------
> rbx            0x7f43c4000d60   139929027874144
> (gdb) p *(struct dm_task *)0x7f43c4000d60
> $3 = {type = 10, dev_name = 0x7f43c4000d40 "spathe", head = 0x0, tail =
> 0x0, read_only = 0, event_nr = 0, major = -1, minor = -1,
>   allow_default_major_fallback = 1, uid = 0, gid = 0, mode = 384,
>   read_ahead = 4294967295, read_ahead_flags = 0, dmi = {
>       v4 = 0x7f43c40011e0, v1 = 0x7f43c40011e0}, newname = 0x0, message =
>       0x0, geometry = 0x0, sector = 0, no_flush = 0,
>         no_open_count = 1, skip_lockfs = 0, query_inactive_table = 0,
> 	suppress_identical_reload = 0, existing_table_size = 0,
> 	  cookie_set = 0, uuid = 0x0}
> -----------------------------------------------------------------------
> since status is not initioned to null, so after calling
> dm_get_next_target(dmt, next, &start, &length,&target_type,
> &status),status becaming wild pointer, which lead snprintf() into the
> situation of segment faulty.
> ---
>  libmultipath/devmapper.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 5eb1713..89aa5da 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -534,8 +534,8 @@ dm_get_status(char * name, char * outstatus)
>  	int r = 1;
>  	struct dm_task *dmt;
>  	uint64_t start, length;
> -	char *target_type;
> -	char *status;
> +	char *target_type = NULL;
> +	char *status = NULL;
>  
>  	if (!(dmt = dm_task_create(DM_DEVICE_STATUS)))
>  		return 1;
> @@ -551,6 +551,10 @@ dm_get_status(char * name, char * outstatus)
>  	/* Fetch 1st target */
>  	dm_get_next_target(dmt, NULL, &start, &length,
>  			   &target_type, &status);
> +	if (!status) {
> +		condlog(2, "get null status.");
> +		goto out;
> +	}
>  
>  	if (snprintf(outstatus, PARAMS_SIZE, "%s", status) <= PARAMS_SIZE)
>  		r = 0;
> -- 
> 2.8.1.windows.1
