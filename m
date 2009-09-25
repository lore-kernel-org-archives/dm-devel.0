From: Rik van Riel <riel@redhat.com>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 25 Sep 2009 11:04:31 -0400
Message-ID: <4ABCDBFF.1020203@redhat.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>	<20090924143315.781cd0ac.akpm@linux-foundation.org>	<20090925050429.GB12555@redhat.com>
	<20090925.180724.104041942.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090925.180724.104041942.ryov@valinux.co.jp>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Ryo Tsuruta wrote:

> Because dm-ioband provides faireness in terms of how many IO requests
> are issued or how many bytes are transferred, so this behaviour is to
> be expected. Do you think fairness in terms of IO requests and size is
> not fair?

When there are two workloads competing for the same
resources, I would expect each of the workloads to
run at about 50% of the speed at which it would run
on an uncontended system.

Having one of the workloads run at 95% of the
uncontended speed and the other workload at 5%
is "not fair" (to put it diplomatically).

-- 
All rights reversed.
