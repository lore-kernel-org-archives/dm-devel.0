From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 09/14] libmultipath: check whether
 mpp->features is NUll in setup_map
Date: Thu, 10 Sep 2020 21:37:54 +0200
Message-ID: <88f6097496038dfdf10b3dc5d36860d124cde1c9.camel@suse.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
	<22e82157-f180-b95b-c72c-b7b13acf1c8a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22e82157-f180-b95b-c72c-b7b13acf1c8a@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Thu, 2020-09-10 at 18:51 +0800, lixiaokeng wrote:
> In assemble_map func, f = STRDUP(mp->features) is just used
> for APPEND(). We can directly pass mp->features to APPEND().
> The mpp->features, hwhandler and selector got form strdup
> should be check after select* function.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>  libmultipath/configure.c |  5 +++++
>  libmultipath/dmparser.c  | 11 ++++-------
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 5bc65fd3..5d5d9415 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -355,6 +355,11 @@ int setup_map(struct multipath *mpp, char
> *params, int params_size,
>  	select_ghost_delay(conf, mpp);
>  	select_flush_on_last_del(conf, mpp);
> 
> +	if (!mpp->features || !mpp->hwhandler || !mpp->selector) {
> +		condlog(0, "%s: map select failed", mpp->alias);
> +		return 1;
> +	}
> +
> 
> 	sysfs_set_scsi_tmo(mpp, conf->checkint);
>  	marginal_pathgroups = conf->marginal_pathgroups;
>  	pthread_cleanup_pop(1);

Just saw this: you can't return between pthread_cleanup_push() and
pthread_cleanup_pop(). You need to move this block below the
pthread_cleanup_pop() statement.

So, Nack for this version of the patch. Sorry

Martin
