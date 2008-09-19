From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: dm-ioband + bio-cgroup benchmarks
Date: Fri, 19 Sep 2008 17:49:24 +0900
Message-ID: <48D36794.6010002@oss.ntt.co.jp>
References: <20080918.210418.226794540.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757296AbYISIrm@vger.kernel.org>
In-Reply-To: <20080918.210418.226794540.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp, balbir@linux.vnet.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, agk@sourceware.org
List-Id: dm-devel.ids

Hi Tsuruta-san,

Ryo Tsuruta wrote:
> Hi All,
> 
> I have got excellent results of dm-ioband, that controls the disk I/O
> bandwidth even when it accepts delayed write requests.
> 
> In this time, I ran some benchmarks with a high-end storage. The
> reason was to avoid a performance bottleneck due to mechanical factors
> such as seek time.
> 
> You can see the details of the benchmarks at:
> http://people.valinux.co.jp/~ryov/dm-ioband/hps/
> 

I took a look at your beautiful results!
When you have time, would you explain me how you succeeded to check the
time, bandwidth, especially when you did write() tests? Actually, I tried
similar tests and failed to check the bandwidth correctly. Did you insert
something in the kernel source?

Thanks,
Takuya Yoshikawa
