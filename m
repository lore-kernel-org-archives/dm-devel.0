From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: Regarding dm-ioband tests
Date: Fri, 11 Sep 2009 15:23:48 +0530
Message-ID: <20090911095347.GD4474@linux.vnet.ibm.com>
References: <20090908170649.GC8828@linux.vnet.ibm.com> <20090909.150511.112608142.ryov@valinux.co.jp> <20090909105122.GF8828@linux.vnet.ibm.com> <20090910.165849.104059407.ryov@valinux.co.jp>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754380AbZIKJyi@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090910.165849.104059407.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: vgoyal@redhat.com, riel@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

On Thu, Sep 10, 2009 at 04:58:49PM +0900, Ryo Tsuruta wrote:
> Hi,
> 
> Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > I know that cgroup is a very well defined functionality, that is why
> > > dm-ioband also supports throttling per cgroup. But how are we supposed
> > > to do throttling on the system which doesn't support cgroup?
> > > As I wrote in another mail to Vivek, I would like to make use of
> > > dm-ioband on RHEL 5.x. 
> > 
> > Hi Ryo,
> > 
> > I am not sure that upstream should really be worrying about RHEL 5.x.
> > cgroups is a relatively mature solution and is available in most (if not
> > all) community distros today. We really should not be looking at another
> > grouping solution if the sole reason is that then dm-ioband can be used
> > on RHEL 5.x. The correct solution would be to maintain a separate patch
> > for RHEL 5.x then and not to burden the upstream kernel.
> 
> RHEL 5.x is not the sole reason for that.
> 

Could you please enumerate the other reasons for pushing in another
grouping mechanism then? (Why can we not resolve them via cgroups?)

Thanks,
-- 
regards,
Dhaval
