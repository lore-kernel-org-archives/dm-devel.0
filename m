From: Nauman Rafique <nauman@google.com>
Subject: Re: [PATCH 21/25] io-controller: Per cgroup request descriptor
	support
Date: Mon, 20 Jul 2009 22:55:31 -0700
Message-ID: <e98e18940907202255y5c7c546ei95d87e5a451ad0c2@mail.gmail.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	 <1246564917-19603-22-git-send-email-vgoyal@redhat.com>
	 <4A655434.5060404@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754889AbZGUFzl@vger.kernel.org>
In-Reply-To: <4A655434.5060404@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

On Mon, Jul 20, 2009 at 10:37 PM, Gui
Jianfeng<guijianfeng@cn.fujitsu.com> wrote:
> Vivek Goyal wrote:
>> o Currently a request queue has got fixed number of request descript=
ors for
>> =A0 sync and async requests. Once the request descriptors are consum=
ed, new
>> =A0 processes are put to sleep and they effectively become serialize=
d. Because
>> =A0 sync and async queues are separate, async requests don't impact =
sync ones
>> =A0 but if one is looking for fairness between async requests, that =
is not
>> =A0 achievable if request queue descriptors become bottleneck.
>>
>> o Make request descriptor's per io group so that if there is lots of=
 IO
>> =A0 going on in one cgroup, it does not impact the IO of other group=
=2E
>>
>> o This is just one relatively simple way of doing things. This patch=
 will
>> =A0 probably change after the feedback. Folks have raised concerns t=
hat in
>> =A0 hierchical setup, child's request descriptors should be capped b=
y parent's
>> =A0 request descriptors. May be we need to have per cgroup per devic=
e files
>> =A0 in cgroups where one can specify the upper limit of request desc=
riptors
>> =A0 and whenever a cgroup is created one needs to assign request des=
critor
>> =A0 limit making sure total sum of child's request descriptor is not=
 more than
>> =A0 of parent.
>>
>> =A0 I guess something like memory controller. Anyway, that would be =
the next
>> =A0 step. For the time being, we have implemented something simpler =
as follows.
>>
>> o This patch implements the per cgroup request descriptors. request =
pool per
>> =A0 queue is still common but every group will have its own wait lis=
t and its
>> =A0 own count of request descriptors allocated to that group for syn=
c and async
>> =A0 queues. So effectively request_list becomes per io group propert=
y and not a
>> =A0 global request queue feature.
>>
>> o Currently one can define q->nr_requests to limit request descripto=
rs
>> =A0 allocated for the queue. Now there is another tunable q->nr_grou=
p_requests
>> =A0 which controls the requests descriptr limit per group. q->nr_req=
uests
>> =A0 supercedes q->nr_group_requests to make sure if there are lots o=
f groups
>> =A0 present, we don't end up allocating too many request descriptors=
 on the
>> =A0 queue.
>>
>
> =A0Hi Vivek,
>
> =A0In order to prevent q->nr_requests from becoming the bottle-neck o=
f allocating
> =A0requests, whether we can update nr_requests accordingly when alloc=
ating or removing
> =A0a cgroup?

Vivek,
I agree with Gui here. In fact, it does not make much sense to keep
the nr_requests limit if we already have per cgroup limit in place.
This change also simplifies code quite a bit, as we can get rid of all
that sleep_on_global logic.

>
> --
> Regards
> Gui Jianfeng
>
>
