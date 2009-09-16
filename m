From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: ioband: Writer starves reader even without competitors
Date: Wed, 16 Sep 2009 21:08:35 +0900 (JST)
Message-ID: <20090916.210835.104036814.ryov@valinux.co.jp>
References: <4AA68AA5.10505@redhat.com>
	<20090908175400.GE15974@redhat.com>
	<20090915233706.GA3770@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758787AbZIPMIg@vger.kernel.org>
In-Reply-To: <20090915233706.GA3770@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: nauman@google.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com, riel@redhat.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Ryo,
> 
> I notice that with-in a single ioband device, a single writer starves the
> reader even without any competitor groups being present.
> 
> I ran following two tests with and without dm-ioband devices

Thank you again for testing dm-ioband.
I got the similar results and am investigating it now.
I'll let you know if I find something.

Thanks,
Ryo Tsuruta
