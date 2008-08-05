From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
Subject: RE: Too many I/O controller patches
Date: Tue, 5 Aug 2008 11:50:17 +0900
Message-ID: <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	<1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <489748E6.5080106@gmail.com>
Content-Language: ja
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: righi.andrea@gmail.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 'Dave Hansen' <dave@linux.vnet.ibm.com>, vtaras@openvz.org, dm-devel@redhat.com, agk@sourceware.org, 'Ryo Tsuruta' <ryov@valinux.co.jp>, virtualization@lists.linux-foundation.org, ngupta@google.com
List-Id: dm-devel.ids

Hi, Andrea.

I participated in Containers Mini-summit.
And, I talked with Mr. Andrew Morton in The Linux Foundation Japan
Symposium BoF, Japan, July 10th.

Currently, in ML, some I/O controller patches is sent and the respective
patch keeps sending the improvement version.
We and maintainers wouldn't like this situation.
We wanted to solve this situation by the Mini-summit, but unfortunately, 
no other developers participated.
(I couldn't give an opinion, because  my English skill is low)
Mr. Naveen present his way in Linux Symposium, and we discussed about
I/O control at a few time after this presentation.


Mr. Andrew gave a advice "Should discuss about design more and more"
to me.
And, in Containers Mini-summit (and Linux Symposium 2008 in Ottawa),
Paul said that a necessary to us is to decide a requirement first.
So, we must discuss requirement and design.

My requirement is
 * to be able to distribute performance moderately.
 (* to be able to isolate each group(environment)). 

I guess (it may be wrong)
 Naveen's requirement is
   * to be able to handle latency.
      (high priority is always precede in handling I/O)
　　　(Only share isn't just given priority to, like CFQ.)
   * to be able to distribute performance moderately.
 Andrea's requirement is
   * to be able to set and control by absolute(direct) performance.
 Ryo's requirement is
   * to be able to distribute performance moderately.
   * to be able to set and control I/Os at flexible range
         (multi device such as LVM).

I think that most solutions controls I/O performance moderately
(by using weight/priority/percentage/etc. and by not using absolute) 
because disk I/O performance is inconstant and is affected by
situation (such as application, file(data) balance, and so on).
So, it is difficult to guarantee performance which is set by
absolute bandwidth.
If devices have constant performance, it will good to control by
absolute bandwidth.
And, when guaranteeing it by the low ability, it'll be possible.
However, no one likes to make the resources wasteful.


And, he gave a advice "Can't a framework which organized each way,
such as I/O elevator, be made?".
I try to consider such framework (in elevator layer or block layer).
Now, I look at the other methods, again.


I think that OOM problems caused by memory/cache systems.
So, it will be better that I/O controller created out of these problems
first, although a lateness of the I/O device would be related.
If these problem can be resolved, its technique should be applied into 
normal I/O control as well as cgroups.

Buffered write I/O is also related with cache system.
We must consider this problem as I/O control.
I don't have a good way which can resolve this problems.


> I did some experiments trying to implement minimum bandwidth requirements
> for my io-throttle controller, mapping the requirements to CFQ prio and
> using the Satoshi's controller. But this needs additional work and
> testing right now, so I've not posted anything yet, just informed
> Satoshi about this.

I'm very interested in this results.


Thanks,
 Satoshi Uchida.

> -----Original Message-----
> From: Andrea Righi [mailto:righi.andrea@gmail.com]
> Sent: Tuesday, August 05, 2008 3:23 AM
> To: Dave Hansen
> Cc: Ryo Tsuruta; linux-kernel@vger.kernel.org; dm-devel@redhat.com;
> containers@lists.linux-foundation.org;
> virtualization@lists.linux-foundation.org;
> xen-devel@lists.xensource.com; agk@sourceware.org; Satoshi UCHIDA
> Subject: Re: Too many I/O controller patches
> 
> Dave Hansen wrote:
> > On Mon, 2008-08-04 at 17:51 +0900, Ryo Tsuruta wrote:
> >> This series of patches of dm-ioband now includes "The bio tracking
> mechanism,"
> >> which has been posted individually to this mailing list.
> >> This makes it easy for anybody to control the I/O bandwidth even when
> >> the I/O is one of delayed-write requests.
> >
> > During the Containers mini-summit at OLS, it was mentioned that there
> > are at least *FOUR* of these I/O controllers floating around.  Have you
> > talked to the other authors?  (I've cc'd at least one of them).
> >
> > We obviously can't come to any kind of real consensus with people just
> > tossing the same patches back and forth.
> >
> > -- Dave
> >
> 
> Dave,
> 
> thanks for this email first of all. I've talked with Satoshi (cc-ed)
> about his solution "Yet another I/O bandwidth controlling subsystem for
> CGroups based on CFQ".
> 
> I did some experiments trying to implement minimum bandwidth requirements
> for my io-throttle controller, mapping the requirements to CFQ prio and
> using the Satoshi's controller. But this needs additional work and
> testing right now, so I've not posted anything yet, just informed
> Satoshi about this.
> 
> Unfortunately I've not talked to Ryo yet. I've continued my work using a
> quite different approach, because the dm-ioband solution didn't work
> with delayed-write requests. Now the bio tracking feature seems really
> prosiming and I would like to do some tests ASAP, and review the patch
> as well.
> 
> But I'm not yet convinced that limiting the IO writes at the device
> mapper layer is the best solution. IMHO it would be better to throttle
> applications' writes when they're dirtying pages in the page cache (the
> io-throttle way), because when the IO requests arrive to the device
> mapper it's too late (we would only have a lot of dirty pages that are
> waiting to be flushed to the limited block devices, and maybe this could
> lead to OOM conditions). IOW dm-ioband is doing this at the wrong level
> (at least for my requirements). Ryo, correct me if I'm wrong or if I've
> not understood the dm-ioband approach.
> 
> Another thing I prefer is to directly define bandwidth limiting rules,
> instead of using priorities/weights (i.e. 10MiB/s for /dev/sda), but
> this seems to be in the dm-ioband TODO list, so maybe we can merge the
> work I did in io-throttle to define such rules.
> 
> Anyway, I still need to look at the dm-ioband and bio-cgroup code in
> details, so probably all I said above is totally wrong...
> 
> -Andrea
