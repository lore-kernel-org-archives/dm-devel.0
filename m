From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/6] libmultipath: check udev* func return
	value
Date: Thu, 17 Sep 2020 21:26:26 -0500
Message-ID: <20200918022626.GU11108@octiron.msp.redhat.com>
References: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: lixiaokeng <lixiaokeng@huawei.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Tue, Sep 15, 2020 at 12:38:27PM +0800, lixiaokeng wrote:
> Hi,
>   The udev* function may return NULL,and it will be
> dereferenced in str* and sscanf func. For example,
> there is a coredump caused in add func, which show in
> be7a043(commit id) in upstream-queue. We check the
> return value to avoid dereference NULL.
> 
> repo: openSUSE/multipath-tools
> repo link: https://github.com/openSUSE/multipath-tools
> branch: upstream-queue
> 
For the set
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>


> lixiaokeng (6):
>   libmultipath: check uedv* return value in sysfs_get_host_pci_name
>   libmultipath: check udev* return value in ccw_sysfs_pathinfo
>   libmultipath: check udev* return value in sysfs_get_tgt_nodename
>   libmultipath: check udev* return value in
>     trigger_partitions_udev_change
>   libmultipath: check udev* renturn value in get_ctrl_blkdev
>   libmultipath: check udev* return value in _find_path_by_syspath
> 
>  libmultipath/configure.c    |  4 +++-
>  libmultipath/discovery.c    |  9 +++++++--
>  libmultipath/foreign/nvme.c | 10 +++++++---
>  3 files changed, 17 insertions(+), 6 deletions(-)
