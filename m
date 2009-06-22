From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC] IO scheduler based io controller (V5)
Date: Mon, 22 Jun 2009 11:40:42 -0400
Message-ID: <x497hz4l1j9.fsf@segfault.boston.devel.redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<20090621152116.GC3728@balbir.in.ibm.com>
	<20090622153030.GA15600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758142AbZFVPnY@vger.kernel.org>
In-Reply-To: <20090622153030.GA15600@redhat.com> (Vivek Goyal's message of
	"Mon, 22 Jun 2009 11:30:31 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, dhaval@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal <vgoyal@redhat.com> writes:

> On Sun, Jun 21, 2009 at 08:51:16PM +0530, Balbir Singh wrote:
>> * Vivek Goyal <vgoyal@redhat.com> [2009-06-19 16:37:18]:
>> 
>> > 
>> > Hi All,
>> > 
>> > Here is the V5 of the IO controller patches generated on top of 2.6.30.
>> [snip]
>> 
>> > Testing
>> > =======
>> >
>> 
>> [snip]
>> 
>> I've not been reading through the discussions in complete detail, but
>> I see no reference to async reads or aio. In the case of aio, aio
>> presumes the context of the user space process. Could you elaborate on
>> any testing you've done with these cases? 
>> 
>
> Hi Balbir,
>
> So far I had not done any testing with AIO. I have done some just now.
> Here are the results.
>
> Test1 (AIO reads)
> ================
> Set up two fio, AIO read jobs in two cgroup with weight 1000 and 500
> respectively. I am using cfq scheduler. Following are some lines from my test
> script.
>
> ===================================================================
> fio_args="--ioengine=libaio --rw=read --size=512M"

AIO doesn't make sense without O_DIRECT.

Cheers,
Jeff
