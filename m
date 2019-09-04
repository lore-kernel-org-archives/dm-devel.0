From: Valentin Schneider <valentin.schneider@arm.com>
Subject: Re: [PATCH] sched: make struct task_struct::state 32-bit
Date: Wed, 4 Sep 2019 11:25:14 +0100
Message-ID: <d46b479b-247b-a291-75f9-b60dd7114440@arm.com>
References: <20190902210558.GA23013@avx2>
 <d8ad0be1-4ed7-df74-d415-2b1c9a44bac7@arm.com> <20190903181920.GA22358@avx2>
 <651c419e45e043e9be8d0877b5a5406d@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <651c419e45e043e9be8d0877b5a5406d@AcuMS.aculab.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>, 'Alexey Dobriyan' <adobriyan@gmail.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "rcu@vger.kernel.org" <rcu@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "aarcange@redhat.com" <aarcange@redhat.com>
List-Id: dm-devel.ids

On 04/09/2019 10:43, David Laight wrote:
> From: Alexey Dobriyan
>> Sent: 03 September 2019 19:19
> ...
>>> How did you come up with this changeset, did you pickaxe for some regexp?
>>
>> No, manually, backtracking up to the call chain.
>> Maybe I missed a few places.
> 
> Renaming the structure field and getting the compiler to find all the uses can help.
> 
> 	David
> 

It's a good idea but sadly doesn't cover whatever the config doesn't
compile. A safer starting point could be

---
@state_var@
struct task_struct *p;
identifier var;
@@
(
var = p->state
|
p->state = var
)

@@
identifier state_var.var;
@@
- var
+ FIXME
---

But I'm hoping we can get something even better from coccinelle, stay
tuned...

> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
