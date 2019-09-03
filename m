From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Tue, 3 Sep 2019 17:31:46 +0100
Message-ID: <64003dcd-d954-b76d-856a-214ff11ac000@arm.com>
References: <20190902210558.GA23013@avx2>
 <7b94004e-4a65-462b-cd6b-5cbd23d607bf@arm.com> <20190903162303.GA2173@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190903162303.GA2173@avx2>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, aarcange@redhat.com
List-Id: dm-devel.ids



On 03/09/2019 17:23, Alexey Dobriyan wrote:
> On Tue, Sep 03, 2019 at 12:02:38AM +0100, Valentin Schneider wrote:
>> struct task_struct {
>> 	struct thread_info         thread_info;          /*     0    24 */
>> 	volatile int               state;                /*    24     4 */
>>
>> 	/* XXX 4 bytes hole, try to pack */
>>
>> 	void *                     stack;                /*    32     8 */
>>
>> Though seeing as this is also the boundary of the randomized layout we can't
>> really do much better without changing the boundary itself. So much for
>> cacheline use :/
> 
> Cacheline use of task_struct is pretty hopeless because of all the ifdefs.
> 

Yeah I figured, then had a minute of silence for those forsaken bytes.
