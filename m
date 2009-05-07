From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: IO scheduler based IO Controller V2
Date: Thu, 07 May 2009 09:18:58 +0900 (JST)
Message-ID: <20090507.091858.226775723.ryov@valinux.co.jp>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com>
	<20090505132441.1705bfad.akpm@linux-foundation.org>
	<20090506023332.GA1212@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760614AbZEGATR@vger.kernel.org>
In-Reply-To: <20090506023332.GA1212@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: akpm@linux-foundation.org, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, peterz@infradead.org
List-Id: dm-devel.ids

Hi Vivek,

> Ryo, dm-ioband breaks the notion of classes and priority of CFQ because
> of FIFO dispatch of buffered bios. Apart from that it tries to provide
> fairness in terms of actual IO done and that would mean a seeky workload
> will can use disk for much longer to get equivalent IO done and slow down
> other applications. Implementing IO controller at IO scheduler level gives
> us tigher control. Will it not meet your requirements? If you got specific
> concerns with IO scheduler based contol patches, please highlight these and
> we will see how these can be addressed.

I'd like to avoid making complicated existing IO schedulers and other
kernel codes and to give a choice to users whether or not to use it.
I know that you chose an approach that using compile time options to
get the same behavior as old system, but device-mapper drivers can be
added, removed and replaced while system is running.

Thanks,
Ryo Tsuruta
