From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory
 subsystem into two parts
Date: Wed, 20 Aug 2008 14:47:36 +0900 (JST)
Message-ID: <20080820.144736.16128062.taka@valinux.co.jp>
References: <48AA4594.1000908@linux.vnet.ibm.com>
	<20080819.214635.70071441.taka@valinux.co.jp>
	<48AACF41.5090905@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <48AACF41.5090905@linux.vnet.ibm.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: balbir@linux.vnet.ibm.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org
List-Id: dm-devel.ids

Hi,

> >>>> I'm now writing remove-lock-page-cgroup patches. it works well.
> >>>> please wait for a while...
> >>> I'm looking forward to those patches.
> >>>
> >>> By the way, I'm glad if memory-cgroup has a feature which can make a
> >>> page_cgroup move between cgroups with small overhead. It makes
> >>> bio-cgroup improve the accuracy of tracking down pages.
> >> Page movement can be a very expensive operation and is proportional to the size
> >> of the control group. I think movement should be an optional feature, if we ever
> >> add it.
> > 
> > Yes, we should avoid moving pages as far as it is balanced fairly well
> > between groups.
> > 
> > But I want to move pages between bio-cgoups in case it started charging
> > quite a few I/O requests to a wrong bio-cgroup. I think it will be okay
> > if pages moves between bio-cgroups, but they don't need to move between
> > memory cgroups. I know the latter is really heavy and the effect seems
> > to be so limited.
> 
> I was under the impression that you wanted memory-cgroup to provide the page
> movement feature. That is not on the TODO list for us now.

I think it's practically enough to implement this feature only on
bio-cgroup side and leave the memory controller untouched.
This kind of requests will happen only when making pages dirty.

Of cousrse I'd be happier if you put it on your list to implement
this as a generic feature.

Thanks,
Hirokazu Takahsahi.
