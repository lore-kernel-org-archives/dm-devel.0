From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Wed, 16 Sep 2009 00:12:37 +0900 (JST)
Message-ID: <20090916.001237.226784704.ryov@valinux.co.jp>
References: <20090909105122.GF8828@linux.vnet.ibm.com>
	<20090910.165849.104059407.ryov@valinux.co.jp>
	<20090911095347.GD4474@linux.vnet.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090911095347.GD4474@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dhaval@linux.vnet.ibm.com
Cc: riel@redhat.com, guijianfeng@cn.fujitsu.com, linux-kernel@vger.kernel.org, jmoyer@redhat.com, dm-devel@redhat.com, vgoyal@redhat.com, jens.axboe@oracle.com, nauman@google.com, akpm@linux-foundation.org, agk@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Dhaval,

Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > > > I know that cgroup is a very well defined functionality, that is why
> > > > dm-ioband also supports throttling per cgroup. But how are we supposed
> > > > to do throttling on the system which doesn't support cgroup?
> > > > As I wrote in another mail to Vivek, I would like to make use of
> > > > dm-ioband on RHEL 5.x. 
> > > 
> > > Hi Ryo,
> > > 
> > > I am not sure that upstream should really be worrying about RHEL 5.x.
> > > cgroups is a relatively mature solution and is available in most (if not
> > > all) community distros today. We really should not be looking at another
> > > grouping solution if the sole reason is that then dm-ioband can be used
> > > on RHEL 5.x. The correct solution would be to maintain a separate patch
> > > for RHEL 5.x then and not to burden the upstream kernel.
> > 
> > RHEL 5.x is not the sole reason for that.
> > 
> 
> Could you please enumerate the other reasons for pushing in another
> grouping mechanism then? (Why can we not resolve them via cgroups?)

I'm sorry for late reply.

I'm not only pushing in the grouping mechanism by using the dmsetup
command. Please understand that dm-ioband also provides cgroup
interface and can be configured in the same manner like other cgroup
subsystems.
Why it is so bad to have multiple ways to configure? I think that it
rather gains in flexibility of configurations.

Thanks,
Ryo Tsuruta
