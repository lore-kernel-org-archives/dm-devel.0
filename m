From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 25 Sep 2009 16:09:11 +0900 (JST)
Message-ID: <20090925.160911.71102299.ryov@valinux.co.jp>
References: <20090925100952.55c2dd7a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090925101821.1de8091a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090925052911.GK4590@balbir.in.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090925052911.GK4590@balbir.in.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: balbir@linux.vnet.ibm.com
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Hi,

Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > I think I must support dirty-ratio in memcg layer. But not yet.
> > 
> 
> We need to add this to the TODO list.
> 
> > OR...I'll add a bufferred-write-cgroup to track bufferred writebacks.
> > And add a control knob as
> >   bufferred_write.nr_dirty_thresh
> > to limit the number of dirty pages generetad via a cgroup.
> > 
> > Because memcg just records a owner of pages but not records who makes them
> > dirty, this may be better. Maybe I can reuse page_cgroup and Ryo's blockio
> > cgroup code.
> 
> Very good point, this is crucial for shared pages.
> 
> > 
> > But I'm not sure how I should treat I/Os generated out by kswapd.
> >
> 
> Account them to process 0 :)

How about accounting them to processes who make pages dirty? I think
that a process which consumes more memory should get penalty. However,
this allows a page request process to use other's bandwidth, but If
a user doesn't want to swap-out the memory, the user should allocate
enough memory for the process by using memcg in advance.

Thanks,
Ryo Tsuruta
