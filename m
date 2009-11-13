From: malahal@us.ibm.com
Subject: Re: [PATCH 2/2] dm: Add suspended check to
	multipath_message
Date: Fri, 13 Nov 2009 10:35:27 -0800
Message-ID: <20091113183527.GC19866@us.ibm.com>
References: <20091113080637.17587.64935.stgit@localhost.localdomain>
	<20091113080647.17587.58265.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091113080647.17587.58265.stgit@localhost.localdomain>
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
> Add suspended check to multipath_message
> 
> Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
> ---
>  drivers/md/dm-mpath.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 32d0b87..ee56ef7 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1402,6 +1402,9 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
>  	struct multipath *m = (struct multipath *) ti->private;
>  	action_fn action;
> 
> +	if (dm_table_md_suspended(ti->table))
> +		return -EBUSY;

Same question as DELETING. SUSPEND bit could be set just after the above
check. Is it OK if the following code executes after the SUSPEND bit is
set???

> +
>  	if (argc == 1) {
>  		if (!strnicmp(argv[0], MESG_STR("queue_if_no_path")))
>  			return queue_if_no_path(m, 1, 0);
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
