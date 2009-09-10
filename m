From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: Regarding dm-ioband tests
Date: Thu, 10 Sep 2009 12:45:47 +0900 (JST)
Message-ID: <20090910.124547.71116284.ryov@valinux.co.jp>
References: <20090908134244.GA15974@redhat.com>
	<20090909.190146.59669568.ryov@valinux.co.jp>
	<20090909143159.GC8256@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753864AbZIJDpq@vger.kernel.org>
In-Reply-To: <20090909143159.GC8256@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vgoyal@redhat.com
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com, akpm@linux-foundation.org, nauman@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, balbir@linux.vnet.ibm.com
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > In addition,
> > there are devices which doesn't use standard IO schedulers, and
> > dm-ioband can work on even such devices.
> 
> This is a interesting use case. Few thoughts.
> 
> - Can't io scheduling mechanism of these devices make use of elevator and
>   elevator fair queuing interfaces to take advantage of io controlling
>   mechanism. It should not be too difficult. Look at noop. It has
>   just 131 lines of code and it now supports hierarchical io scheduling.
>  
>   This will come with request queue and its merging and plug/unplug
>   mechanism. Is that an issue?
>
> - If not, then yes, for these corner cases, io scheduler based controller
>   does not work as it is.

I have a extreme fast SSD and its device driver provides its own
make_request_fn(). So the device driver intercepts IO requests and the
subsequent processes are done within it.

Thanks,
Ryo Tsuruta
