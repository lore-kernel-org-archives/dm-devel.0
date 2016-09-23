From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [RFC][PATCH] dm: Remove dm_bufio_cond_resched()
Date: Fri, 23 Sep 2016 07:32:47 -0700
Message-ID: <89c9d841-36c4-8b7e-544f-607cbdb2eec0@sandisk.com>
References: <20160913084520.GA5012@twins.programming.kicks-ass.net>
 <20160913133959.GA22833@redhat.com>
 <20160919105325.GW5016@twins.programming.kicks-ass.net>
 <alpine.LRH.2.02.1609221645510.4447@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.DEB.2.20.1609222257050.5640@nanos> <20160923073435.GL2794@worktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160923073435.GL2794@worktop>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Ingo Molnar <mingo@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 09/23/16 00:34, Peter Zijlstra wrote:
> Is anybody still using PREEMPT_NONE? Most workloads also care about
> latency to some extend. Lots of code has explicit cond_resched() and
> doesn't worry.

 From a SLES11 system:

$ grep PREEMPT_NONE /boot/config-3.0.101-0.47.67-default
CONFIG_PREEMPT_NONE=y

 From a SLES12 system:

$ grep CONFIG_PREEMPT_NONE /boot/config-4.4.16-56-default
CONFIG_PREEMPT_NONE=y

Bart.
