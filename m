From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: dm-ioband + bio-cgroup benchmarks
Date: Thu, 18 Sep 2008 21:04:18 +0900 (JST)
Message-ID: <20080918.210418.226794540.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755499AbYIRME3@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: agk@sourceware.org, balbir@linux.vnet.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, fernando@oss.ntt.co.jp
List-Id: dm-devel.ids

Hi All,

I have got excellent results of dm-ioband, that controls the disk I/O
bandwidth even when it accepts delayed write requests.

In this time, I ran some benchmarks with a high-end storage. The
reason was to avoid a performance bottleneck due to mechanical factors
such as seek time.

You can see the details of the benchmarks at:
http://people.valinux.co.jp/~ryov/dm-ioband/hps/

Thanks,
Ryo Tsuruta
