From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 0/6] libmultipath: check udev* func return
	value
Date: Fri, 18 Sep 2020 13:15:19 +0200
Message-ID: <473373836362e808c1d856048ce06a27487b31bb.camel@suse.com>
References: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
	<20200918022626.GU11108@octiron.msp.redhat.com>
	<011310221c816f3c3573d96d91aca3e0a48fb80d.camel@suse.com>
	<3735c20d-a0fd-ca41-be9a-0df679022668@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3735c20d-a0fd-ca41-be9a-0df679022668@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel, list <dm-devel@redhat.com>, linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Fri, 2020-09-18 at 16:39 +0800, lixiaokeng wrote:
> 
>    Here we use multipath-tools basing on iscsi. When iscsi logout,
> the path
> will disappear in sysfs and a uevent will cause. Before uevent
> processed,
> some coredump will happen but if coredump is solved the multipathd
> will
> deal with the disappeared path latter.
>   In this set, the funcs will not be processed when multipath-tools
> bases
> on iscsi. However, I think multipathd will deal with the disappeared
> path
> like basing on iscsi. So I just check them. Anyway, if you have any
> better
> idea, please tell me.

Of course we need to avoid the segfaults. As I said, please fix your
patches and resend. It's good to know that just avoiding the NULL
dereferences fixes the issues you were seeing.

Perhaps it would be sufficient to set INIT_REMOVED on a path device
when something like this happens. But I need to think it through.

Martin
