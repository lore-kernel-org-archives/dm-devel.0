From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: dm-ioband + bio-cgroup benchmarks
Date: Fri, 19 Sep 2008 20:31:53 +0900 (JST)
Message-ID: <20080919.203153.183041336.ryov@valinux.co.jp>
References: <20080918.210418.226794540.ryov@valinux.co.jp>
	<48D36794.6010002@oss.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <48D36794.6010002@oss.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: yoshikawa.takuya@oss.ntt.co.jp
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, xemul@openvz.org, fernando@oss.ntt.co.jp, kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Yoshikawa-san,

> When you have time, would you explain me how you succeeded to check the
> time, bandwidth, especially when you did write() tests? Actually, I tried
> similar tests and failed to check the bandwidth correctly. Did you insert
> something in the kernel source?

I'm using our own tool, which issues I/Os in prallel in a specified
period and counts up how many I/Os are issued and how many bytes are
transferred in the period.

I'm also using our own tool for measurement of throughput variation to
see the internal data of dm-ioband. This tool is implemented as a
kernel module.

Thanks,
Ryo Tsuruta
