From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: Too many I/O controller patches
Date: Tue,  5 Aug 2008 11:28:27 +0200 (MEST)
Message-ID: <48981D3B.2020701@gmail.com>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	<1217870433.20260.101.camel@nimitz> <489748E6.5080106@gmail.com>
	<000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
Reply-To: righi.andrea@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <000901c8f6a5$fe64ba30$fb2e2e90$@jp.nec.com>
List-Unsubscribe: <https://lists.linux-foundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linux-foundation.org/pipermail/virtualization>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linux-foundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 'Dave Hansen' <dave@linux.vnet.ibm.com>, vtaras@openvz.org, dm-devel@redhat.com, agk@sourceware.org, virtualization@lists.linux-foundation.org, ngupta@google.com
List-Id: dm-devel.ids

Satoshi UCHIDA wrote:
>  Andrea's requirement is
>    * to be able to set and control by absolute(direct) performance.

     * improve IO performance predictability of each cgroup
       (try to guarantee more precise IO performance values)

> And, he gave a advice "Can't a framework which organized each way,
> such as I/O elevator, be made?".
> I try to consider such framework (in elevator layer or block layer).

It would be probably the best place to evaluate the "cost" of each
IO operation.

> I think that OOM problems caused by memory/cache systems.
> So, it will be better that I/O controller created out of these problems
> first, although a lateness of the I/O device would be related.
> If these problem can be resolved, its technique should be applied into 
> normal I/O control as well as cgroups.
> 
> Buffered write I/O is also related with cache system.
> We must consider this problem as I/O control.

Agree. At least, maybe we should consider if an IO controller could be
a valid solution also for these problems.

>> I did some experiments trying to implement minimum bandwidth requirements
>> for my io-throttle controller, mapping the requirements to CFQ prio and
>> using the Satoshi's controller. But this needs additional work and
>> testing right now, so I've not posted anything yet, just informed
>> Satoshi about this.
> 
> I'm very interested in this results.

I'll collect some numbers and keep you informed.

-Andrea
