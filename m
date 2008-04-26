From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] dm-ioband: I/O bandwidth controller
 v0.0.4: Document
Date: Sat, 26 Apr 2008 11:45:35 -0700
Message-ID: <20080426114535.e19283be.akpm@linux-foundation.org>
References: <20080424.201857.183035295.ryov@valinux.co.jp>
	<20080424.202219.59667073.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080424.202219.59667073.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: xen-devel@lists.xensource.com, Sergey Kononenko <sergk@sergk.org.ua>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org
List-Id: dm-devel.ids

On Thu, 24 Apr 2008 20:22:19 +0900 (JST) Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> +What's dm-ioband all about?
> +
> +     dm-ioband is an I/O bandwidth controller implemented as a device-mapper
> +   driver. Several jobs using the same physical device have to share the
> +   bandwidth of the device. dm-ioband gives bandwidth to each job according
> +   to its weight, which each job can set its own value to.
> +
> +     At this time, a job is a group of processes with the same pid or pgrp or
> +   uid. There is also a plan to make it support cgroup. A job can also be a
> +   virtual machine such as KVM or Xen.

Most writes are performed by pdflush, kswapd, etc.  This will lead to large
inaccuracy.

It isn't trivial to fix.  We'd need deep, long tracking of ownership
probably all the way up to the pagecache page.  The same infrastructure
would be needed to make Sergey's "BSD acct: disk I/O accounting" vaguely
accurate.  Other proposals need it, but I forget what they are.

Much more minor points: when merge-time comes, the patches should have the
LINUX_VERSION_CODE stuff removed.  And probably all of the many `inline's
should be removed.
