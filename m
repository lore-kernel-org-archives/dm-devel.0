From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: a room for blkio-cgroup in struct page_cgroup
Date: Thu, 3 Sep 2009 09:30:05 +0900 (JST)
Message-ID: <fa721014d75b6e193623349bfde28124.squirrel@webmail-b.css.fujitsu.com>
References: <20090902.205137.71100180.ryov@valinux.co.jp>
    <ff13736137802f78cf492d13c43c1af1.squirrel@webmail-b.css.fujitsu.com>
    <661de9470909021302ge86d01s5d107dc2b5cffbc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <661de9470909021302ge86d01s5d107dc2b5cffbc5@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Ryo Tsuruta <ryov@valinux.co.jp>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, linux-mm@kvack.org
List-Id: dm-devel.ids

Balbir Singh wrote:
> 2009/9/2 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
>> Ryo Tsuruta wrote:
>>> Hi Kamezawa-san,
>>>
>>> As you wrote before (http://lkml.org/lkml/2009/7/22/65)
>>>> To be honest, what I expected in these days for people of blockio
>>>> cgroup is like following for getting room for themselves.
>>> <<snip>>
>>>> --- mmotm-2.6.31-Jul16.orig/include/linux/page_cgroup.h
>>>> +++ mmotm-2.6.31-Jul16/include/linux/page_cgroup.h
>>>> @@ -13,7 +13,7 @@
>>>> &#160;struct page_cgroup {
>>>> &#160; &#160; &#160; unsigned long flags;
>>>> &#160; &#160; &#160; struct mem_cgroup *mem_cgroup;
>>>> - &#160; &#160; struct page *page;
>>>> + &#160; &#160; /* block io tracking will use extra unsigned long
bytes */
>>>> &#160; &#160; &#160; struct list_head lru; &#160; &#160; &#160; /*
per cgroup LRU list */
>>>> };
>>>
>>> Have you already added a room for blkio_cgroup in struct page_cgroup?
>> No.
>>
>
> The diff above is unclear, are you removing struct page from page_cgrou=
p?
>
I said him "if you want a room, plz get by youself, consider more"
And offered this change.
 http://lkml.org/lkml/2009/7/22/65
you were CC'd.
Because page_cgroup's layout is same to memmap, we can use similar functi=
on
as
  page_cgroup_to_pfn(), pfn_to_page_cgroup().
And, we don't access page_cgroup->page in fast path. (maybe)
But as I wrote, we're busy. I'll not do this until all performance fixes
go ahead.

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
