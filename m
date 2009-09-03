From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches
 from Ryo to track async bios.
Date: Thu, 03 Sep 2009 12:41:44 +0900 (JST)
Message-ID: <20090903.124144.104054881.ryov@valinux.co.jp>
References: <20090902135821.GB5012@redhat.com>
	<20090903.112423.226782505.ryov@valinux.co.jp>
	<20090903024014.GA8644@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090903024014.GA8644@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: vgoyal@redhat.com
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > > At ioband level you just get to see bio and page. How do you decide wheter
> > > this bio is being issued by a process which is a memory hog?
> > > 
> > > In fact requester of memory could be anybody. It could be memory hog or a
> > > different process. So are you saying that you got a mechanism where you 
> > > can detect that a process is memory hog and charge swap activity to it.
> > > IOW, if there are two processes A and B and assume A is the memory hog and
> > > then B requests for memory which triggers lot of swap IO, then you can
> > > charge all that IO to memory hog A?
> > 
> > When an annoymou page is allocated, blkio-cgroup sets an ID to the
> > page. And then when the page is going to swap out, dm-ioband can know
> > who the owner of the page is by retrieving ID from the page.
> > 
> > In the above case, since the pages of the process A are swapped-out, 
> > dm-ioband charges swap IO to the process A.
> > 
> 
> But this does not mean that in all cases memory hog is being charged for
> swap IO, as you have said. So if a process A has done some anonymous page
> allocations and later a memory hog B comes in and forces swap out of A, 
> you will charge A for swap activity which does not seem fair as B is
> memory hog here?

I think this charging policy is not bad, but I think I can understand
you think it's not fair. Do you think it's fair if all IO is carged to B?

We should use both io and memory controller together, as you wrote, 

Thanks,
Ryo Tsuruta
