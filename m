From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] io-controller: do some changes of io.policy
	interface
Date: Fri, 26 Jun 2009 08:27:22 +0800
Message-ID: <4A4415EA.4090201@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-19-git-send-email-vgoyal@redhat.com>
	<6599ad830906241452t76e64815s7d68a22a6e746a59@mail.gmail.com>
	<4A435038.60406@cn.fujitsu.com> <20090625125513.GA25439@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090625125513.GA25439@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, Paul Menage <menage@google.com>, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
...
> 
> Hi Gui,
> 
> Thanks for the patch. "unsigned long" for ioprio_class is too big. How
> about using "unsigned short"? I noticed that in io_cgroup also we are
> using "unsigned long". I will fix that.
> 
> For storing weight now we are planning to use "unsigned int". Can you
> please switch to that.

  Sure, i'll post another patch to switch to that.

> 
> Thanks
> Vivek
> 
> 
> 

-- 
Regards
Gui Jianfeng
