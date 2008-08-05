From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: Too many I/O controller patches
Date: Tue, 05 Aug 2008 21:01:50 +0900 (JST)
Message-ID: <20080805.210150.91309965.taka@valinux.co.jp>
References: <1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com>
	<000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: s-uchida@ap.jp.nec.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com, vtaras@openvz.org, dm-devel@redhat.com, agk@sourceware.org, ryov@valinux.co.jp, virtualization@lists.linux-foundation.org, ngupta@google.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

Hi,

> I think that OOM problems caused by memory/cache systems.
> So, it will be better that I/O controller created out of these problems
> first, although a lateness of the I/O device would be related.
> If these problem can be resolved, its technique should be applied into 
> normal I/O control as well as cgroups.

Yes, this is one of the problems linux kernel still has, which should
be solved.

But I believe this should be done in the linux memory management layer
including the cgroup memory controller, which has to work correctly
on any type of device with various access speeds.

I think it's better that I/O controllers should only focus on flow of
I/O requests. This approach will keep the implementation of linux
kernel simple.

> Buffered write I/O is also related with cache system.
> We must consider this problem as I/O control.
> I don't have a good way which can resolve this problems.
> 

Thank you,
Hirokazu Takahashi.
