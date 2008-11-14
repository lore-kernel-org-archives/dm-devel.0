From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [dm-devel] [PATCH 1/8] dm-ioband: Introduction
Date: Fri, 14 Nov 2008 10:38:28 +0900 (JST)
Message-ID: <20081114.103828.737004071327928691.ryov@valinux.co.jp>
References: <20081113.121146.623571555980959797.ryov@valinux.co.jp>
	<491C81CB.7010705@cfl.rr.com>
	<20081114.081840.114538392.taka@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <20081114.081840.114538392.taka@valinux.co.jp>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: dm-devel@redhat.com, taka@valinux.co.jp
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, agk@sourceware.org, balbir@linux.vnet.ibm.com, psusi@cfl.rr.com, fernando@oss.ntt.co.jp, kamezawa.hiroyu@jp.fujitsu.com, xemul@openvz.org
List-Id: dm-devel.ids

Hi Phillip,

> > Ryo Tsuruta wrote:
> > > Create two ioband devices "ioband1" and "ioband2". "ioband1" is mapped
> > > to "/dev/sda1" and has a weight of 40. "ioband2" is mapped to "/dev/sda2"
> > > and has a weight of 10. "ioband1" can use 80% --- 40/(40+10)*100 ---
> > > of the bandwidth of the physical disk "/dev/sda" while "ioband2" can use 20%.
> > 
> > Just to clarify, when you say ioband1 can use 80% of the bandwidh, you 
> > mean that is how much it will get if both io bands are loaded right?  If 
> > there is no activity on ioband2, then ioband1 will get the full disk 
> > bandwidth right?
> 
> Absolutely, you are right!

Here is a benchmark result of sharing bandwidth between three ioband
devices. When there is no activity on ioband2, the total bandwidth of
the disk is shared only between ioband1 and ioband3 according to their
weights.
http://people.valinux.co.jp/~ryov/dm-ioband/benchmark/partition1.html

--
Ryo Tsuruta <ryov@valinux.co.jp>
