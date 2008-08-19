From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory
 subsystem into two parts
Date: Tue, 19 Aug 2008 12:28:11 +0900 (JST)
Message-ID: <20080819.122811.59660409.ryov@valinux.co.jp>
References: <20080812.213449.104039151.ryov@valinux.co.jp>
	<20080812.213533.189720227.ryov@valinux.co.jp>
	<20080818103938.8b4e8bfa.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20080818103938.8b4e8bfa.kamezawa.hiroyu@jp.fujitsu.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, xemul@openvz.org, fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Kamezawa-san,

> I'm now writing remove-lock-page-cgroup patches. it works well.
> please wait for a while...

I'm looking forward to those patches.

By the way, I'm glad if memory-cgroup has a feature which can make a
page_cgroup move between cgroups with small overhead. It makes
bio-cgroup improve the accuracy of tracking down pages.

Thanks,
Ryo Tsuruta
