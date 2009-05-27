From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH] io-controller: Add io group reference
	handling for request
Date: Wed, 27 May 2009 10:17:50 +0200
Message-ID: <20090527081749.GA7237@linux>
References: <20090518140114.GB27080@redhat.com> <20090518143921.GE3113@linux>
	<20090526.203424.39179999.ryov@valinux.co.jp>
	<20090527.155631.226800550.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090527.155631.226800550.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Wed, May 27, 2009 at 03:56:31PM +0900, Ryo Tsuruta wrote:
> > I think that only putting the hook in try_to_unmap() doesn't work
> > correctly, because IOs will be charged to reclaiming processes or
> > kswapd. These IOs should be charged to processes which cause memory
> > pressure.
> 
> Consider the following case:
> 
>   (1) There are two processes Proc-A and Proc-B.
>   (2) Proc-A maps a large file into many pages by mmap() and writes
>       many data to the file.
>   (3) After (2), Proc-B try to get a page, but there are no available
>       pages because Proc-A has used them.
>   (4) kernel starts to reclaim pages, call try_to_unmap() to unmap
>       a page which is owned by Proc-A, then blkio_cgroup_set_owner()
>       sets Proc-B's ID on the page because the task's context is Proc-B.
>   (5) After (4), kernel writes the page out to a disk. This IO is
>       charged to Proc-B.
> 
> In the above case, I think that the IO should be charged to a Proc-A,
> because the IO is caused by Proc-A's memory pressure. 
> I think we should consider in the case without memory and swap
> isolation.

mmmh.. even if they're strictly related I think we're mixing two
different problems in this way: memory pressure control and IO control.

It seems you're proposing something like the badness() for OOM
conditions to charge swap IO depending on how bad is a cgroup in terms
of memory consumption. I don't think this is the right way to proceed,
also because we already have the memory and swap control.

-Andrea
