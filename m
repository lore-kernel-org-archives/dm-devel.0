From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/6] libmultipath: check uedv* return value
 in sysfs_get_host_pci_name
Date: Fri, 18 Sep 2020 09:34:19 +0200
Message-ID: <168f8b0cb8444dfb8bc94516e8583013957e6a89.camel@suse.com>
References: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
	<965e9cd1-f0dc-b94a-4314-0e8f6cb50bf5@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <965e9cd1-f0dc-b94a-4314-0e8f6cb50bf5@huawei.com>
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
> udev_device_get_sysname may return NULL. We check the return value.
> 
> Signed-off-by:Lixiaokeng<Lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  libmultipath/discovery.c | 3 +++
>  1 file changed, 3 insertions(+)

The patch is correct, but please watch out for spelling mistakes,
in particular in the subject.

Martin
