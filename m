From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: sched: make struct task_struct::state 32-bit
Date: Tue, 24 Sep 2019 10:28:33 +0200
Message-ID: <a1491516-a701-8804-8277-75fb5247191a@web.de>
References: <a43fe392-bd6a-71f5-8611-c6b764ba56c3@arm.com>
 <7e3e784c-e8e6-f9ba-490f-ec3bf956d96b@web.de>
 <0c4dcb91-4830-0013-b8c6-64b9e1ce47d4@arm.com>
 <32d65b15-1855-e7eb-e9c4-81560fab62ea@arm.com>
 <alpine.DEB.2.21.1909231228200.2272@hadrien>
 <d529c390-546e-a8a4-f475-c3ee41f97645@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d529c390-546e-a8a4-f475-c3ee41f97645@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Valentin Schneider <valentin.schneider@arm.com>, Julia Lawall <julia.lawall@lip6.fr>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, dm-devel@redhat.com, linux-block@vger.kernel.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
List-Id: dm-devel.ids

>>> identifier task_state =3D~ "^TASK_";
>>
>> Are there a lot of options?  You can also enumerate them in {}, ie
>>
>> identifier task_state =3D {TASK_BLAH, TASK_BLAHBLAH};
>
> Around a dozen, can be enumerated easily and is indeed probably better t=
han
> a regexp.

Can the application of a regular expression be more convenient
for such an use case?


>> You want to look at the definitions of called functions?
>> Coccinelle doesn't really support that,

I got an other impression.


>> but there are hackish ways to add that.

How do you think about to discuss corresponding software development chall=
enges?

Regards,
Markus
