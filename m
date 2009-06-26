From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] io-controller: do some changes of io.policy interface
Date: Fri, 26 Jun 2009 08:59:43 +0800
Message-ID: <4A441D7F.2070505@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-19-git-send-email-vgoyal@redhat.com> <6599ad830906241452t76e64815s7d68a22a6e746a59@mail.gmail.com> <4A435038.60406@cn.fujitsu.com> <20090625125513.GA25439@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754986AbZFZBAN@vger.kernel.org>
In-Reply-To: <20090625125513.GA25439@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> 
> Hi Gui,
> 
> Thanks for the patch. "unsigned long" for ioprio_class is too big. How
> about using "unsigned short"? I noticed that in io_cgroup also we are
> using "unsigned long". I will fix that.

  Ah, i see, If you already have the patch, would you share it?

> 
> For storing weight now we are planning to use "unsigned int". Can you
> please switch to that.
> 
> Thanks
> Vivek
> 
> 
> 

-- 
Regards
Gui Jianfeng
