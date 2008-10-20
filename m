From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller
 v1.8.0: Introduction
Date: Mon, 20 Oct 2008 18:01:30 +0900 (JST)
Message-ID: <20081020.180129.193689104.ryov@valinux.co.jp>
References: <20081017.160950.71109894.ryov@valinux.co.jp>
	<2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <2891419e0810200140s3cf9c0a3q228620519ae5f4af@mail.gmail.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: baramsori72@gmail.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, corsetproject@googlegroups.com, fernando@oss.ntt.co.jp, agk@redhat.com
List-Id: dm-devel.ids

Hi Dong-Jae,

> I am trying to install your new released dm-ioband v1.8.0
> I/O bandwidth controller v1.8.0 could be adjusted to  the latest
> stable kernel 2.6.27.1
> it was good news for me
> but, I had a problem when I try to patch bio-cgroup files to  stable
> kernel 2.6.27.1
> many patch failure and hunk messages were occured.
> 
> Can you check bio-cgroup patch files against stable kernel 2.6.27.1?

bio-cgroup patch can apply only to 2.6.27-rc5-mm1 so far.
Please use 2.6.27-rc5-mm1 to try both bio-cgroup and dm-ioband,
dm-ioband v1.8.0 can also apply to 2.6.27-rc5-mm1.

Thanks,
Ryo Tsuruta
