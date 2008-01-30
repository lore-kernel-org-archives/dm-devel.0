From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: dm-band: The I/O bandwidth controller: Performance
	Report
Date: Wed, 30 Jan 2008 12:32:02 +0900 (JST)
Message-ID: <20080130.123202.189729685.ryov@valinux.co.jp>
References: <20080123.215350.193721890.ryov@valinux.co.jp>
	<20080125.160720.183032233.ryov@valinux.co.jp>
	<479ECAC9.5070709@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <479ECAC9.5070709@jp.fujitsu.com>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: inakoshi.hiroya@jp.fujitsu.com
Cc: containers@lists.linux-foundation.org, xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

> you mean that you run 128 processes on each user-device pairs?  Namely,
> I guess that
> 
>   user1: 128 processes on sdb5,
>   user2: 128 processes on sdb5,
>   another: 128 processes on sdb5,
>   user2: 128 processes on sdb6.

"User-device pairs" means "band groups", right?
What I actually did is the followings:

  user1: 128 processes on sdb5,
  user2: 128 processes on sdb5,
  user3: 128 processes on sdb5,
  user4: 128 processes on sdb6.

> The second preliminary studies might be:
> - What if you use a different I/O size on each device (or device-user pair)?
> - What if you use a different number of processes on each device (or
> device-user pair)?

There are other ideas of controlling bandwidth, limiting bytes-per-sec,
latency time or something. I think it is possible to implement it if 
a lot of people really require it. I feel there wouldn't be a single
correct answer for this issue. Posting good ideas how it should work
and submitting patches for it are also welcome.

> And my impression is that it's natural dm-band is in device-mapper,
> separated from I/O scheduler.  Because bandwidth control and I/O
> scheduling are two different things, it may be simpler that they are
> implemented in different layers.

I would like to know how dm-band works on various configurations on
various type of hardware. I'll try running dm-band on with other
configurations. Any reports or impressions of dm-band on your machines
are also welcome.

Thanks,
Ryo Tsuruta
