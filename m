From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2] libmultipath: check udev_device_get_*
 return value to avoid segfault
Date: Mon, 21 Sep 2020 11:14:24 +0200
Message-ID: <a09c32f1acded7e3fe2e5187606e27c60c584de6.camel@suse.com>
References: <be54400a-5da9-8444-c473-562d675b10f3@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <be54400a-5da9-8444-c473-562d675b10f3@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Mon, 2020-09-21 at 12:00 +0800, lixiaokeng wrote:
> The udev_device_get_* function may return NULL, and it will be
> deregerenced in str* and sscanf func. We check the return value
> to avoid segfault. Fix all.
>

Thanks. Let me remark that this patch does _not_ fix all invocations of
udev_device_get_XYZ() (I suppose you meant something else with "Fix
all.", but please be more specific next time then).
See path_discover(), declare_sysfs_get_str(), for instance.

Anyway, that can be fixed later, so:

Reviewed-by: Martin Wilck <mwilck@suse.com>
