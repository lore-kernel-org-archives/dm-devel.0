From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/6] libmultipath: check udev* return value
 in ccw_sysfs_pathinfo
Date: Fri, 18 Sep 2020 09:01:37 +0200
Message-ID: <77b6ffa33ad720f9a43c4d9677346023865db955.camel@suse.com>
References: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
	<cf6ba543-dd8d-cbc9-b69d-a4e9efd0c7f9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cf6ba543-dd8d-cbc9-b69d-a4e9efd0c7f9@huawei.com>
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

On Tue, 2020-09-15 at 12:39 +0800, lixiaokeng wrote:
> We check the return value of udev_device_get_sysname.
> 
> Signed-off-by:Lixiaokeng<lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  libmultipath/discovery.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 4264b0da..27cb67f8 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1471,6 +1471,8 @@ ccw_sysfs_pathinfo (struct path *pp, const
> struct _vector *hwtable)
>  	 * host / bus / target / lun
>  	 */
>  	attr_path = udev_device_get_sysname(parent);
> +	if (attr_path)
> +		return PATHINFO_FAILED;
>  	pp->sg_id.lun = 0;
>  	if (sscanf(attr_path, "%i.%i.%x",
>  		   &pp->sg_id.host_no,

This looks wrong.
