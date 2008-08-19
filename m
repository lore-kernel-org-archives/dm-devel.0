From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
Date: Tue, 19 Aug 2008 09:31:24 +0530
Message-ID: <48AA4594.1000908@linux.vnet.ibm.com>
References: <20080812.213449.104039151.ryov@valinux.co.jp> <20080812.213533.189720227.ryov@valinux.co.jp> <20080818103938.8b4e8bfa.kamezawa.hiroyu@jp.fujitsu.com> <20080819.122811.59660409.ryov@valinux.co.jp>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752655AbYHSEBk@vger.kernel.org>
In-Reply-To: <20080819.122811.59660409.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: kamezawa.hiroyu@jp.fujitsu.com, xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, xemul@openvz.org, fernando@oss.ntt.co.jp
List-Id: dm-devel.ids

Ryo Tsuruta wrote:
> Hi Kamezawa-san,
> 
>> I'm now writing remove-lock-page-cgroup patches. it works well.
>> please wait for a while...
> 
> I'm looking forward to those patches.
> 
> By the way, I'm glad if memory-cgroup has a feature which can make a
> page_cgroup move between cgroups with small overhead. It makes
> bio-cgroup improve the accuracy of tracking down pages.

Page movement can be a very expensive operation and is proportional to the size
of the control group. I think movement should be an optional feature, if we ever
add it.

-- 
	Balbir
