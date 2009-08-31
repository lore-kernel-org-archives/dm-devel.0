From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches
	from Ryo to track async bios.
Date: Mon, 31 Aug 2009 14:56:40 -0400
Message-ID: <20090831185640.GF3758@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-19-git-send-email-vgoyal@redhat.com>
	<4A9C09BE.4060404@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A9C09BE.4060404@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Rik van Riel <riel@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Mon, Aug 31, 2009 at 01:34:54PM -0400, Rik van Riel wrote:
> Vivek Goyal wrote:
>> o blkio_cgroup patches from Ryo to track async bios.
>>
>> o This functionality is used to determine the group of async IO from page
>>   instead of context of submitting task.
>>
>> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
>> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> This seems to be the most complex part of the code so far,
> but I see why this code is necessary.
>

Hi Rik,

Thanks for reviewing the patches. I wanted to have better understanding of
where all does it help to associate a bio to the group of process who
created/owned the page. Hence few thoughts.

When a bio is submitted to IO scheduler, it needs to determine the group
bio belongs to and group which should be charged to. There seem to be two 
methods.

- Attribute the bio to cgroup submitting process belongs to.
- For async requests, track the original owner hence cgroup of the page
  and charge that group for the bio. 

One can think of pros/cons of both the approaches.

- The primary use case of tracking async context seems be that if a
  process T1 in group G1 mmaps a big file and then another process T2 in
  group G2, asks for memory and triggers reclaim and generates writes of
  the file pages mapped by T1, then these writes should not be charged to
  T2, hence blkio_cgroup pages.

  But the flip side of this might be that group G2 is a low weight group
  and probably too busy also right now, which will delay the write out
  and possibly T2 will wait longer for memory to be allocated.

- At one point of time Andrew mentioned that buffered writes are generally a
  big problem and one needs to map these to owner's group. Though I am not
  very sure what specific problem he was referring to. Can we attribute
  buffered writes to pdflush threads and move all pdflush threads in a 
  cgroup to limit system wide write out activity?

- Somebody also gave an example where there is a memory hogging process and
  possibly pushes out some processes to swap. It does not sound fair to 
  charge those proccess for that swap writeout. These processes never
  requested swap IO.

- If there are multiple buffered writers in the system, then those writers
  can also be forced to writeout some pages to disk before they are
  allowed to dirty more pages. As per the page cache design, any writer
  can pick any inode and start writing out pages. So it can happen a
  weight group task is writting out pages dirtied by a lower weight group
  task. If, async bio is mapped to owner's group, it might happen that
  higher weight group task might be made to sleep on lower weight group
  task because request descriptors are all consumed up.

It looks like there does not seem to be a clean way which covers all the
cases without issues. I am just trying to think, what is a simple way
which covers most of the cases. Can we just stick to using submitting task
context to determine a bio's group (as cfq does). Which can result in
following.

- Less code and reduced complexity.

- Buffered writes will be charged to pdflush and its group. If one wish to
  limit buffered write activity for pdflush, one can move all the pdflush
  threads into a group and assign desired weight. Writes submitted in
  process context will continue to be charged to that process irrespective
  of the fact who dirtied that page.

- swap activity will be charged to kswapd and its group. If swap writes
  are coming from process context, it gets charged to process and its
  group. 

- If one is worried about the case of one process being charged for write
  out of file mapped by another process during reclaim, then we can
  probably make use of memory controller and mount memory controller and
  io controller together on same hierarchy. I am told that with memory
  controller, group's memory will be reclaimed by the process requesting
  more memory. If that's the case, then IO will automatically be charged
  to right group if we use submitting task context.

I just wanted to bring this point forward for more discussions to know
what is the right thing to do? Use bio tracking or not.

Ryo, any thoughts on this?

Thanks
Vivek

> Acked-by: Rik van Riel <riel@redhat.com>
