From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm bufio: fix missed destroy of mutex c->lock
Date: Thu, 4 Jan 2018 12:46:20 -0500
Message-ID: <20180104174619.GA14374@redhat.com>
References: <20180104140811.20182-1-sxwjean@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180104140811.20182-1-sxwjean@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xiongwei Song <sxwjean@gmail.com>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

I already staged a similar fix, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=cfb0bd8b25eb90faa7cbbad9a52ad2c33102123e

On Thu, Jan 04 2018 at  9:08am -0500,
Xiongwei Song <sxwjean@gmail.com> wrote:

> The mutex c->lock is initialized in dm_bufio_client_create, however,
> it is not destroyed before free the structure of dm_bufio_client in
> dm_bufio_client_destroy.
> 
> Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
> ---
>  drivers/md/dm-bufio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index c546b567f3b5..53c0d5d2039a 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -1811,6 +1811,7 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
>  		BUG_ON(c->n_buffers[i]);
>  
>  	dm_io_client_destroy(c->dm_io);
> +	mutex_destroy(&c->lock);
>  	kfree(c);
>  }
>  EXPORT_SYMBOL_GPL(dm_bufio_client_destroy);
> -- 
> 2.15.1
> 
