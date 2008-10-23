From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 0/2] dm-ioband: I/O bandwidth controller
 v1.8.0: Introduction
Date: Thu, 23 Oct 2008 20:28:51 +0900 (JST)
Message-ID: <20081023.202851.112594221.ryov@valinux.co.jp>
References: <48FEDC63.308@windriver.com>
	<20081022.170536.193712541.ryov@valinux.co.jp>
	<1224756158.8286.36.camel@pek-hzhang-d1>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <1224756158.8286.36.camel@pek-hzhang-d1>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: haotian.zhang@windriver.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, fernando@oss.ntt.co.jp, bruce.ashfield@windriver.com, zumeng.chen@windriver.com
List-Id: dm-devel.ids

Hi Haotian,

> The results are almost the same. I can not see any change of Direct I/O
> performance for this bio-cgroup kernel feature with dm-ioband support!
> 
> Does the methord to caculate throughout should be the Rate of xdd.linux
> output? 
> Dose my testing approach should be correct? If not, please help me point
> out.

Could you try to run the xdd programs simultaneously?
dm-ioband controls bandwidth while I/O requests are issued
simultaneously from processes which belong to different cgroup.
If I/O requests are only issued from processes which belong to one
cgroup, the processes can use the whole bandwidth.

The following URL is an example of how bandwidth is shared to I/O
load change.
http://people.valinux.co.jp/~ryov/dm-ioband/benchmark/partition1.html

Thanks,
Ryo Tsuruta
