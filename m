From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: Re: dm-ioband + bio-cgroup benchmarks
Date: Fri, 19 Sep 2008 20:20:31 +0900 (JST)
Message-ID: <20080919.202031.86647893.taka@valinux.co.jp>
References: <20080918.210418.226794540.ryov@valinux.co.jp>
	<20080918131554.GB20640@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20080918131554.GB20640@redhat.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: vgoyal@redhat.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, righi.andrea@gmail.com, agk@sourceware.org, ryov@valinux.co.jp, xemul@openvz.org, fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi,

> > Hi All,
> > 
> > I have got excellent results of dm-ioband, that controls the disk I/O
> > bandwidth even when it accepts delayed write requests.
> > 
> > In this time, I ran some benchmarks with a high-end storage. The
> > reason was to avoid a performance bottleneck due to mechanical factors
> > such as seek time.
> > 
> > You can see the details of the benchmarks at:
> > http://people.valinux.co.jp/~ryov/dm-ioband/hps/

  (snip)

> Secondly, why do we have to create an additional dm-ioband device for 
> every device we want to control using rules. This looks little odd
> atleast to me. Can't we keep it in line with rest of the controllers
> where task grouping takes place using cgroup and rules are specified in
> cgroup itself (The way Andrea Righi does for io-throttling patches)?

It isn't essential dm-band is implemented as one of the device-mappers.
I've been also considering that this algorithm itself can be implemented
in the block layer directly.

Although, the current implementation has merits. It is flexible.
  - Dm-ioband can be place anywhere you like, which may be right before
    the I/O schedulers or may be placed on top of LVM devices.
  - It supports partition based bandwidth control which can work without
    cgroups, which is quite easy to use of.
  - It is independent to any I/O schedulers including ones which will
    be introduced in the future.

I also understand it's will be hard to set up without some tools
such as lvm commands.

> To avoid creation of stacking another device (dm-ioband) on top of every
> device we want to subject to rules, I was thinking of maintaining an
> rb-tree per request queue. Requests will first go into this rb-tree upon
> __make_request() and then will filter down to elevator associated with the
> queue (if there is one). This will provide us the control of releasing
> bio's to elevaor based on policies (proportional weight, max bandwidth
> etc) and no need of stacking additional block device.

I think it's a bit late to control I/O requests there, since process
may be blocked in get_request_wait when the I/O load is high.
Please imagine the situation that cgroups with low bandwidths are
consuming most of "struct request"s while another cgroup with a high
bandwidth is blocked and can't get enough "struct request"s.

It means cgroups that issues lot of I/O request can win the game.

> I am working on some experimental proof of concept patches. It will take
> some time though.
> 
> I was thinking of following.
> 
> - Adopt the Andrea Righi's style of specifying rules for devices and
>   group the tasks using cgroups.
> 
> - To begin with, adopt dm-ioband's approach of proportional bandwidth
>   controller. It makes sense to me limit the bandwidth usage only in
>   case of contention. If there is really a need to limit max bandwidth,
>   then probably we can do something to implement additional rules or
>   implement some policy switcher where user can decide what kind of
>   policies need to be implemented.
> 
> - Get rid of dm-ioband and instead buffer requests on an rb-tree on every
>   request queue which is controlled by some kind of cgroup rules.
>
> It would be good to discuss above approach now whether it makes sense or 
> not. I think it is kind of fusion of io-throttling and dm-ioband patches
> with additional idea of doing io-control just above elevator on the request
> queue using an rb-tree.
> 
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
