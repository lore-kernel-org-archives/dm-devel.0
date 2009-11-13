From: malahal@us.ibm.com
Subject: Re: [PATCH 3/3] dm: Add deleting check to target_message
Date: Fri, 13 Nov 2009 10:32:43 -0800
Message-ID: <20091113183243.GB19866@us.ibm.com>
References: <20091113080422.17412.49305.stgit@localhost.localdomain>
	<20091113080438.17412.87434.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091113080438.17412.87434.stgit@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Mike Anderson [andmike@linux.vnet.ibm.com] wrote:
> Add dm_table_md_deleting check to target_message
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> ---
>  drivers/md/dm-ioctl.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index a679429..04e252c 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1292,6 +1292,11 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
>  	if (!table)
>  		goto out_argv;
> 
> +	if (dm_table_md_deleting(table)) {
> +		r = -ENXIO;
> +		goto out_table;
> +	}

Is there some reason that DELETING bit won't be set while executing the
rest of the following code. If not, what is the point of checking the
bit above?

> 
>  	ti = dm_table_find_target(table, tmsg->sector);
>  	if (!dm_target_is_valid(ti)) {
>  		DMWARN("Target message sector outside device.");
> @@ -1303,6 +1308,7 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
>  		r = -EINVAL;
>  	}
> 
> + out_table:
>  	dm_table_put(table);
>   out_argv:
>  	kfree(argv);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
