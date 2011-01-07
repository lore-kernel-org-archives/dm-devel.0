From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [patch] md/dm-log: use PTR_ERR value instead of
	-ENOMEM
Date: Fri, 7 Jan 2011 14:08:51 -0600
Message-ID: <E61297FC-BC25-45CB-B151-458BB0E52091@redhat.com>
References: <20100516063119.GC18464@bicker>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100516063119.GC18464@bicker>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

ACK

  brassow

On May 16, 2010, at 1:31 AM, Dan Carpenter wrote:

> It's nicer to return the PTR_ERR() value instead of just returning
> -ENOMEM.  In the current code the PTR_ERR() value is always equal to
> -ENOMEM so this doesn't actually affect anything, but still...
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
> index 5a08be0..fbd80fb 100644
> --- a/drivers/md/dm-log.c
> +++ b/drivers/md/dm-log.c
> @@ -455,7 +455,7 @@ static int create_log_context(struct  
> dm_dirty_log *log, struct dm_target *ti,
> 			r = PTR_ERR(lc->io_req.client);
> 			DMWARN("couldn't allocate disk io client");
> 			kfree(lc);
> -			return -ENOMEM;
> +			return r;
> 		}
>
> 		lc->disk_header = vmalloc(buf_size);
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
