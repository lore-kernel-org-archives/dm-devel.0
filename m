From: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Re: Re: dm-ioband + bio-cgroup benchmarks
Date: Wed, 24 Sep 2008 16:34:32 +0530
Message-ID: <661de9470809240404i62300942o15337ecec335fe22@mail.gmail.com>
References: <48D267B5.20402@gmail.com> <20080918150634.GH20640@redhat.com>
	<48D2715A.6060002@gmail.com>
	<20080919.123405.91829935.taka@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0450886798=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080919.123405.91829935.taka@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, agk@sourceware.org, xemul@openvz.org, fernando@oss.ntt.co.jp, vgoyal@redhat.com, righi.andrea@gmail.com
List-Id: dm-devel.ids

--===============0450886798==
Content-Type: multipart/alternative;
	boundary="----=_Part_53800_26159460.1222254272322"

------=_Part_53800_26159460.1222254272322
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, Sep 19, 2008 at 9:04 AM, Hirokazu Takahashi <taka@valinux.co.jp>wrote:

> Hi,
>
> > >> Vivek Goyal wrote:
> > >>> On Thu, Sep 18, 2008 at 09:04:18PM +0900, Ryo Tsuruta wrote:
> > >>>> Hi All,
> > >>>>
> > >>>> I have got excellent results of dm-ioband, that controls the disk
> I/O
> > >>>> bandwidth even when it accepts delayed write requests.
> > >>>>
> > >>>> In this time, I ran some benchmarks with a high-end storage. The
> > >>>> reason was to avoid a performance bottleneck due to mechanical
> factors
> > >>>> such as seek time.
> > >>>>
> > >>>> You can see the details of the benchmarks at:
> > >>>> http://people.valinux.co.jp/~ryov/dm-ioband/hps/<http://people.valinux.co.jp/%7Eryov/dm-ioband/hps/>
> > >>>>
> > >>> Hi Ryo,
> > >>>
> > >>> I had a query about dm-ioband patches. IIUC, dm-ioband patches will
> break
> > >>> the notion of process priority in CFQ because now dm-ioband device
> will
> > >>> hold the bio and issue these to lower layers later based on which
> bio's
> > >>> become ready. Hence actual bio submitting context might be different
> and
> > >>> because cfq derives the io_context from current task, it will be
> broken.
> > >>>
> > >>> To mitigate that problem, we probably need to implement Fernando's
> > >>> suggestion of putting io_context pointer in bio.
> > >>>
> > >>> Have you already done something to solve this issue?
> > >>>
> > >>> Secondly, why do we have to create an additional dm-ioband device for
> > >>> every device we want to control using rules. This looks little odd
> > >>> atleast to me. Can't we keep it in line with rest of the controllers
> > >>> where task grouping takes place using cgroup and rules are specified
> in
> > >>> cgroup itself (The way Andrea Righi does for io-throttling patches)?
> > >>>
> > >>> To avoid creation of stacking another device (dm-ioband) on top of
> every
> > >>> device we want to subject to rules, I was thinking of maintaining an
> > >>> rb-tree per request queue. Requests will first go into this rb-tree
> upon
> > >>> __make_request() and then will filter down to elevator associated
> with the
> > >>> queue (if there is one). This will provide us the control of
> releasing
> > >>> bio's to elevaor based on policies (proportional weight, max
> bandwidth
> > >>> etc) and no need of stacking additional block device.
> > >>>
> > >>> I am working on some experimental proof of concept patches. It will
> take
> > >>> some time though.
> > >>>
> > >>> I was thinking of following.
> > >>>
> > >>> - Adopt the Andrea Righi's style of specifying rules for devices and
> > >>>   group the tasks using cgroups.
> > >>>
> > >>> - To begin with, adopt dm-ioband's approach of proportional bandwidth
> > >>>   controller. It makes sense to me limit the bandwidth usage only in
> > >>>   case of contention. If there is really a need to limit max
> bandwidth,
> > >>>   then probably we can do something to implement additional rules or
> > >>>   implement some policy switcher where user can decide what kind of
> > >>>   policies need to be implemented.
> > >>>
> > >>> - Get rid of dm-ioband and instead buffer requests on an rb-tree on
> every
> > >>>   request queue which is controlled by some kind of cgroup rules.
> > >>>
> > >>> It would be good to discuss above approach now whether it makes sense
> or
> > >>> not. I think it is kind of fusion of io-throttling and dm-ioband
> patches
> > >>> with additional idea of doing io-control just above elevator on the
> request
> > >>> queue using an rb-tree.
> > >> Thanks Vivek. All sounds reasonable to me and I think this is be the
> right way
> > >> to proceed.
> > >>
> > >> I'll try to design and implement your rb-tree per request-queue idea
> into my
> > >> io-throttle controller, maybe we can reuse it also for a more generic
> solution.
> > >> Feel free to send me your experimental proof of concept if you want,
> even if
> > >> it's not yet complete, I can review it, test and contribute.
> > >
> > > Currently I have taken code from bio-cgroup to implement cgroups and to
> > > provide functionality to associate a bio to a cgroup. I need this to be
> > > able to queue the bio's at right node in the rb-tree and then also to
> be
> > > able to take a decision when is the right time to release few requests.
> > >
> > > Right now in crude implementation, I am working on making system boot.
> > > Once patches are at least in little bit working shape, I will send it
> to you
> > > to have a look.
> > >
> > > Thanks
> > > Vivek
> >
> > I wonder... wouldn't be simpler to just use the memory controller
> > to retrieve this information starting from struct page?
> >
> > I mean, following this path (in short, obviously using the appropriate
> > interfaces for locking and referencing the different objects):
> >
> > cgrp = page->page_cgroup->mem_cgroup->css.cgroup
> >
> > Once you get the cgrp it's very easy to use the corresponding controller
> > structure.
> >
> > Actually, this is how I'm doing in cgroup-io-throttle to associate a bio
> > to a cgroup. What other functionalities/advantages bio-cgroup provide in
> > addition to that?
>
> I've decided to get Ryo to post the accurate dirty-page tracking patch
> for bio-cgroup, which isn't perfect yet though. The memory controller
> never wants to support this tracking because migrating a page between
> memory cgroups is really heavy.
>

It depends on the migration. The cost is proportional to the number of pages
moved. The cost can be brought down (I do have a  design on paper  -- from
long long ago), where moving mm's will reduce the cost of migration, but it
adds an additional dereference in the common path.


>
> I also thought enhancing the memory controller would be good enough,
> but a lot of people said they wanted to control memory resource and
> block I/O resource separately.


Yes, ideally we do want that.


>
> So you can create several bio-cgroup in one memory-cgroup,
> or you can use bio-cgroup without memory-cgroup.
>
> I also have a plan to implement more acurate tracking mechanism
> on bio-cgroup after the memory cgroup team re-implement the infrastructure,
> which won't be supported by memory-cgroup.
> When a process are moved into another memory cgroup,
> the pages belonging to the process don't move to the new cgroup
> because migrating pages is so heavy. It's hard to find the pages
> from the process and migrating pages may cause some memory pressure.
> I'll implement this feature only on bio-cgroup with minimum overhead
>

Kamezawa has also wanted the page migration feature and we've agreed to
provide a per-cgroup flag to decide to turn migration on/off. I would not
mind refactoring memcontrol.c if that can help the IO controller and if you
want migration, force the migration flag to on and warn the user if they try
to turn it off.

Balbir

------=_Part_53800_26159460.1222254272322
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><br><br><div class="gmail_quote">On Fri, Sep 19, 2008 at 9:04 AM, Hirokazu Takahashi <span dir="ltr">&lt;<a href="mailto:taka@valinux.co.jp">taka@valinux.co.jp</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi,<br>
<div><div></div><div class="Wj3C7c"><br>
&gt; &gt;&gt; Vivek Goyal wrote:<br>
&gt; &gt;&gt;&gt; On Thu, Sep 18, 2008 at 09:04:18PM +0900, Ryo Tsuruta wrote:<br>
&gt; &gt;&gt;&gt;&gt; Hi All,<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt; I have got excellent results of dm-ioband, that controls the disk I/O<br>
&gt; &gt;&gt;&gt;&gt; bandwidth even when it accepts delayed write requests.<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt; In this time, I ran some benchmarks with a high-end storage. The<br>
&gt; &gt;&gt;&gt;&gt; reason was to avoid a performance bottleneck due to mechanical factors<br>
&gt; &gt;&gt;&gt;&gt; such as seek time.<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt; You can see the details of the benchmarks at:<br>
&gt; &gt;&gt;&gt;&gt; <a href="http://people.valinux.co.jp/%7Eryov/dm-ioband/hps/" target="_blank">http://people.valinux.co.jp/~ryov/dm-ioband/hps/</a><br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; Hi Ryo,<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; I had a query about dm-ioband patches. IIUC, dm-ioband patches will break<br>
&gt; &gt;&gt;&gt; the notion of process priority in CFQ because now dm-ioband device will<br>
&gt; &gt;&gt;&gt; hold the bio and issue these to lower layers later based on which bio&#39;s<br>
&gt; &gt;&gt;&gt; become ready. Hence actual bio submitting context might be different and<br>
&gt; &gt;&gt;&gt; because cfq derives the io_context from current task, it will be broken.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; To mitigate that problem, we probably need to implement Fernando&#39;s<br>
&gt; &gt;&gt;&gt; suggestion of putting io_context pointer in bio.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; Have you already done something to solve this issue?<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; Secondly, why do we have to create an additional dm-ioband device for<br>
&gt; &gt;&gt;&gt; every device we want to control using rules. This looks little odd<br>
&gt; &gt;&gt;&gt; atleast to me. Can&#39;t we keep it in line with rest of the controllers<br>
&gt; &gt;&gt;&gt; where task grouping takes place using cgroup and rules are specified in<br>
&gt; &gt;&gt;&gt; cgroup itself (The way Andrea Righi does for io-throttling patches)?<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; To avoid creation of stacking another device (dm-ioband) on top of every<br>
&gt; &gt;&gt;&gt; device we want to subject to rules, I was thinking of maintaining an<br>
&gt; &gt;&gt;&gt; rb-tree per request queue. Requests will first go into this rb-tree upon<br>
&gt; &gt;&gt;&gt; __make_request() and then will filter down to elevator associated with the<br>
&gt; &gt;&gt;&gt; queue (if there is one). This will provide us the control of releasing<br>
&gt; &gt;&gt;&gt; bio&#39;s to elevaor based on policies (proportional weight, max bandwidth<br>
&gt; &gt;&gt;&gt; etc) and no need of stacking additional block device.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; I am working on some experimental proof of concept patches. It will take<br>
&gt; &gt;&gt;&gt; some time though.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; I was thinking of following.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; - Adopt the Andrea Righi&#39;s style of specifying rules for devices and<br>
&gt; &gt;&gt;&gt; &nbsp; group the tasks using cgroups.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; - To begin with, adopt dm-ioband&#39;s approach of proportional bandwidth<br>
&gt; &gt;&gt;&gt; &nbsp; controller. It makes sense to me limit the bandwidth usage only in<br>
&gt; &gt;&gt;&gt; &nbsp; case of contention. If there is really a need to limit max bandwidth,<br>
&gt; &gt;&gt;&gt; &nbsp; then probably we can do something to implement additional rules or<br>
&gt; &gt;&gt;&gt; &nbsp; implement some policy switcher where user can decide what kind of<br>
&gt; &gt;&gt;&gt; &nbsp; policies need to be implemented.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; - Get rid of dm-ioband and instead buffer requests on an rb-tree on every<br>
&gt; &gt;&gt;&gt; &nbsp; request queue which is controlled by some kind of cgroup rules.<br>
&gt; &gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt; It would be good to discuss above approach now whether it makes sense or<br>
&gt; &gt;&gt;&gt; not. I think it is kind of fusion of io-throttling and dm-ioband patches<br>
&gt; &gt;&gt;&gt; with additional idea of doing io-control just above elevator on the request<br>
&gt; &gt;&gt;&gt; queue using an rb-tree.<br>
&gt; &gt;&gt; Thanks Vivek. All sounds reasonable to me and I think this is be the right way<br>
&gt; &gt;&gt; to proceed.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; I&#39;ll try to design and implement your rb-tree per request-queue idea into my<br>
&gt; &gt;&gt; io-throttle controller, maybe we can reuse it also for a more generic solution.<br>
&gt; &gt;&gt; Feel free to send me your experimental proof of concept if you want, even if<br>
&gt; &gt;&gt; it&#39;s not yet complete, I can review it, test and contribute.<br>
&gt; &gt;<br>
&gt; &gt; Currently I have taken code from bio-cgroup to implement cgroups and to<br>
&gt; &gt; provide functionality to associate a bio to a cgroup. I need this to be<br>
&gt; &gt; able to queue the bio&#39;s at right node in the rb-tree and then also to be<br>
&gt; &gt; able to take a decision when is the right time to release few requests.<br>
&gt; &gt;<br>
&gt; &gt; Right now in crude implementation, I am working on making system boot.<br>
&gt; &gt; Once patches are at least in little bit working shape, I will send it to you<br>
&gt; &gt; to have a look.<br>
&gt; &gt;<br>
&gt; &gt; Thanks<br>
&gt; &gt; Vivek<br>
&gt;<br>
&gt; I wonder... wouldn&#39;t be simpler to just use the memory controller<br>
&gt; to retrieve this information starting from struct page?<br>
&gt;<br>
&gt; I mean, following this path (in short, obviously using the appropriate<br>
&gt; interfaces for locking and referencing the different objects):<br>
&gt;<br>
&gt; cgrp = page-&gt;page_cgroup-&gt;mem_cgroup-&gt;css.cgroup<br>
&gt;<br>
&gt; Once you get the cgrp it&#39;s very easy to use the corresponding controller<br>
&gt; structure.<br>
&gt;<br>
&gt; Actually, this is how I&#39;m doing in cgroup-io-throttle to associate a bio<br>
&gt; to a cgroup. What other functionalities/advantages bio-cgroup provide in<br>
&gt; addition to that?<br>
<br>
</div></div>I&#39;ve decided to get Ryo to post the accurate dirty-page tracking patch<br>
for bio-cgroup, which isn&#39;t perfect yet though. The memory controller<br>
never wants to support this tracking because migrating a page between<br>
memory cgroups is really heavy.<br>
</blockquote><div><br>It depends on the migration. The cost is proportional to the number of pages moved. The cost can be brought down (I do have a&nbsp; design on paper&nbsp; -- from long long ago), where moving mm&#39;s will reduce the cost of migration, but it adds an additional dereference in the common path.<br>
&nbsp;</div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><br>
I also thought enhancing the memory controller would be good enough,<br>
but a lot of people said they wanted to control memory resource and<br>
block I/O resource separately.</blockquote><div><br>Yes, ideally we do want that.<br>&nbsp;</div><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
<br>
So you can create several bio-cgroup in one memory-cgroup,<br>
or you can use bio-cgroup without memory-cgroup.<br>
<br>
I also have a plan to implement more acurate tracking mechanism<br>
on bio-cgroup after the memory cgroup team re-implement the infrastructure,<br>
which won&#39;t be supported by memory-cgroup.<br>
When a process are moved into another memory cgroup,<br>
the pages belonging to the process don&#39;t move to the new cgroup<br>
because migrating pages is so heavy. It&#39;s hard to find the pages<br>
from the process and migrating pages may cause some memory pressure.<br>
I&#39;ll implement this feature only on bio-cgroup with minimum overhead<br>
</blockquote><div><br></div></div>Kamezawa has also wanted the page migration feature and we&#39;ve agreed to provide a per-cgroup flag to decide to turn migration on/off. I would not mind refactoring memcontrol.c if that can help the IO controller and if you want migration, force the migration flag to on and warn the user if they try to turn it off.<br>
<br>Balbir<br></div>

------=_Part_53800_26159460.1222254272322--


--===============0450886798==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0450886798==--
