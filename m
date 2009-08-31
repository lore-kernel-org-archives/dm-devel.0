From: Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
	track async bios.
Date: Mon, 31 Aug 2009 16:51:25 -0700
Message-ID: <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	 <1251495072-7780-19-git-send-email-vgoyal@redhat.com>
	 <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752225AbZHaXvc@vger.kernel.org>
In-Reply-To: <20090831185640.GF3758@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, containers@lists.linux-foundation.org, dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu
List-Id: dm-devel.ids

On Mon, Aug 31, 2009 at 11:56 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Mon, Aug 31, 2009 at 01:34:54PM -0400, Rik van Riel wrote:
>> Vivek Goyal wrote:
>>> o blkio_cgroup patches from Ryo to track async bios.
>>>
>>> o This functionality is used to determine the group of async IO fro=
m page
>>> =A0 instead of context of submitting task.
>>>
>>> Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
>>> Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>
>> This seems to be the most complex part of the code so far,
>> but I see why this code is necessary.
>>
>
> Hi Rik,
>
> Thanks for reviewing the patches. I wanted to have better understandi=
ng of
> where all does it help to associate a bio to the group of process who
> created/owned the page. Hence few thoughts.
>
> When a bio is submitted to IO scheduler, it needs to determine the gr=
oup
> bio belongs to and group which should be charged to. There seem to be=
 two
> methods.
>
> - Attribute the bio to cgroup submitting process belongs to.
> - For async requests, track the original owner hence cgroup of the pa=
ge
> =A0and charge that group for the bio.
>
> One can think of pros/cons of both the approaches.
>
> - The primary use case of tracking async context seems be that if a
> =A0process T1 in group G1 mmaps a big file and then another process T=
2 in
> =A0group G2, asks for memory and triggers reclaim and generates write=
s of
> =A0the file pages mapped by T1, then these writes should not be charg=
ed to
> =A0T2, hence blkio_cgroup pages.
>
> =A0But the flip side of this might be that group G2 is a low weight g=
roup
> =A0and probably too busy also right now, which will delay the write o=
ut
> =A0and possibly T2 will wait longer for memory to be allocated.
>
> - At one point of time Andrew mentioned that buffered writes are gene=
rally a
> =A0big problem and one needs to map these to owner's group. Though I =
am not
> =A0very sure what specific problem he was referring to. Can we attrib=
ute
> =A0buffered writes to pdflush threads and move all pdflush threads in=
 a
> =A0cgroup to limit system wide write out activity?
>
> - Somebody also gave an example where there is a memory hogging proce=
ss and
> =A0possibly pushes out some processes to swap. It does not sound fair=
 to
> =A0charge those proccess for that swap writeout. These processes neve=
r
> =A0requested swap IO.
>
> - If there are multiple buffered writers in the system, then those wr=
iters
> =A0can also be forced to writeout some pages to disk before they are
> =A0allowed to dirty more pages. As per the page cache design, any wri=
ter
> =A0can pick any inode and start writing out pages. So it can happen a
> =A0weight group task is writting out pages dirtied by a lower weight =
group
> =A0task. If, async bio is mapped to owner's group, it might happen th=
at
> =A0higher weight group task might be made to sleep on lower weight gr=
oup
> =A0task because request descriptors are all consumed up.
>
> It looks like there does not seem to be a clean way which covers all =
the
> cases without issues. I am just trying to think, what is a simple way
> which covers most of the cases. Can we just stick to using submitting=
 task
> context to determine a bio's group (as cfq does). Which can result in
> following.
>
> - Less code and reduced complexity.
>
> - Buffered writes will be charged to pdflush and its group. If one wi=
sh to
> =A0limit buffered write activity for pdflush, one can move all the pd=
flush
> =A0threads into a group and assign desired weight. Writes submitted i=
n
> =A0process context will continue to be charged to that process irresp=
ective
> =A0of the fact who dirtied that page.

What if we wanted to control buffered write activity per group? If a
group keeps dirtying pages, we wouldn't want it to dominate the disk
IO capacity at the expense of other cgroups (by dominating the writes
sent down by pdflush).

>
> - swap activity will be charged to kswapd and its group. If swap writ=
es
> =A0are coming from process context, it gets charged to process and it=
s
> =A0group.
>
> - If one is worried about the case of one process being charged for w=
rite
> =A0out of file mapped by another process during reclaim, then we can
> =A0probably make use of memory controller and mount memory controller=
 and
> =A0io controller together on same hierarchy. I am told that with memo=
ry
> =A0controller, group's memory will be reclaimed by the process reques=
ting
> =A0more memory. If that's the case, then IO will automatically be cha=
rged
> =A0to right group if we use submitting task context.
>
> I just wanted to bring this point forward for more discussions to kno=
w
> what is the right thing to do? Use bio tracking or not.
>
> Ryo, any thoughts on this?
>
> Thanks
> Vivek
>
>> Acked-by: Rik van Riel <riel@redhat.com>
>
