From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: [dm-devel] [PATCH 0/5] bio-cgroup: Introduction
Date: Fri, 19 Sep 2008 21:02:42 +0900 (JST)
Message-ID: <20080919.210242.57356043.taka@valinux.co.jp>
References: <20080919.200107.193703747.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20080919.200107.193703747.ryov@valinux.co.jp>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: dm-devel@redhat.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, agk@sourceware.org, ryov@valinux.co.jp, balbir@linux.vnet.ibm.com, fernando@oss.ntt.co.jp, xemul@openvz.org
List-Id: dm-devel.ids

Hi,

> Hi everyone,
> 
> Here are new releases of bio-cgroup.
> Changes from the previous version are as follows:
> 
> - Accurate dirty-page tracking
>   Support migrating pages between bio-cgroups with minimum overhead,

I'm the one implementing this code.
The implementation isn't finished yet that this this code can't handle
mmapped file pages correctly. Actually, the same problem goes with
the task I/O accounting mechanism since the two of them are using
the same hook

This happens when starting to free pages under memory pressure.
Dirty bit of a pte will be moved into PG_Dirty flag of the associated
page. This can be done in another process context, while the hook try
to charge this operation to the current process.

>   but I think such a situation is quite rare.

I implemented it though, I don't think this case often happens since
it's not normal that several processes try to write the same block
of a file.


Thanks,
Hirokazu Takahashi.
