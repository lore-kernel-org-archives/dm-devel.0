From: Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC] IO scheduler based io controller (V5)
Date: Sun, 21 Jun 2009 20:51:16 +0530
Message-ID: <20090621152116.GC3728@balbir.in.ibm.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
Reply-To: balbir@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752141AbZFUPYb@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

* Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:

> 
> Hi All,
> 
> Here is the V5 of the IO controller patches generated on top of 2.6.30.
[snip]

> Testing
> =======
>

[snip]

I've not been reading through the discussions in complete detail, but
I see no reference to async reads or aio. In the case of aio, aio
presumes the context of the user space process. Could you elaborate on
any testing you've done with these cases? 

-- 
	Balbir
