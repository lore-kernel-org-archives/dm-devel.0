From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 6/6] libmultipath: check udev* return value
 in _find_path_by_syspath
Date: Fri, 18 Sep 2020 08:58:08 +0200
Message-ID: <8d91632f52d943cb7e95b4b8cc595fc4720ee83f.camel@suse.com>
References: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
	<40f72a77-5dcc-89e4-e164-d19e0da10699@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <40f72a77-5dcc-89e4-e164-d19e0da10699@huawei.com>
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

On Tue, 2020-09-15 at 12:42 +0800, lixiaokeng wrote:
> We check udev_device_get_syspath return value before
> dereference it.
> 
> Signed-off-by: Lixiaokeng<lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  libmultipath/foreign/nvme.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/foreign/nvme.c
> b/libmultipath/foreign/nvme.c
> index a0668713..28e0d192 100644
> --- a/libmultipath/foreign/nvme.c
> +++ b/libmultipath/foreign/nvme.c
> @@ -482,6 +482,7 @@ _find_path_by_syspath(struct nvme_map *map, const
> char *syspath)
>  	struct nvme_pathgroup *pg;
>  	char real[PATH_MAX];
>  	const char *ppath;
> +	const char *psyspath;
>  	int i;
> 
>  	ppath = realpath(syspath, real);
> @@ -493,8 +494,8 @@ _find_path_by_syspath(struct nvme_map *map, const
> char *syspath)
>  	vector_foreach_slot(&map->pgvec, pg, i) {
>  		struct nvme_path *path = nvme_pg_to_path(pg);
> 
> -		if (!strcmp(ppath,
> -			    udev_device_get_syspath(path->udev)))
> +		psyspath = udev_device_get_syspath(path->udev);
> +		if (!psyspath && !strcmp(ppath, psyspath))
>  			return path;
>  	}
>  	condlog(4, "%s: %s: %s not found", __func__, THIS, ppath);

This looks wrong to me.
