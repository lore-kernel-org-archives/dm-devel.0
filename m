From: Tejun Heo <tj@kernel.org>
Subject: Re: HPA unlock during partition scan of RAID components
Date: Fri, 4 Nov 2011 19:52:18 -0700
Message-ID: <CAOS58YOH68c2=79YywBN+JzZMn08XZYUwjK5ogbKnOqxKi=AOQ@mail.gmail.com>
References: <74AAB12B538EC94087A0D16AFDFC24F4045674@IRSMSX102.ger.corp.intel.com>
	<20111103153835.GF4417@google.com> <4EB2E4B7.7000103@cfl.rr.com>
	<CAOS58YNMOYDjuok5DDVF+CcgmP5Z4pdscv6boUC9gUqd7DiUpw@mail.gmail.com>
	<4EB407DC.8070307@cfl.rr.com> <20111104155228.GY4417@google.com>
	<4EB4121A.1060102@cfl.rr.com> <20111104163207.GA4417@google.com>
	<4EB45467.4060605@cfl.rr.com> <20111104215025.GB4417@google.com>
	<4EB49191.6060609@cfl.rr.com>
	<CAOS58YNVoghyAxfj-MnTGNmRSt_4Mff2s9adq78UnzxsUv_Eug@mail.gmail.com>
	<4EB49EDD.3020708@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EB49EDD.3020708@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, "Hawrylewicz Czarnowski,
	Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: dm-devel.ids

Hello,

> Well if it breaks under Windows, then we can't be faulted for having
> the same results now can we?

Heh, let's just remove all hpa features and screw all the current
users which depend on them!

> The other argument is that unlocking by default trashes whatever data
> the bios was trying to hide in the HPA, and deviates from the behavior
> of Windows.

On the former point, I don't think it matters. If the user doesn't
know what it is, [s]he can leave it alone. Maybe userland can do
something smarter if it knows the partition lives in hpa locked area,
like not mounting it by default or hiding it from browser.

On the point of not deviating from windows, I kinda agree and my
previous "let's just remove all hpa stuff" isn't all that sarcastic,
but it really isn't that simple. On BIOS raid configs, the vendor
controls both bios and driver and those drivers are very self
contained. They implement all from bit pushing driver itself to raid
stack and high level device management, and actually assumes that they
have full control of the whole stack and do good number of crazy
things. It would be surprising if no driver is unlocking hpa during
driver init. And they do all sorts of crazy and broken stuff. Try to
follow windows bios raid troubleshooting threads, it often ends up
"umm... I lost everything and had to reinitialized the whole array
from BIOS and reinstall".

So... um... I don't know. The dual size thing was the best solution
that I know of (don't remember who came up with it first) and at least
some of the ATA people seem to agree with it. Anyways, I don't think
we're making any useful progress in this thread, so this probably will
be my last message unless something new comes up.

If you have a great new idea to solve them all, please go ahead. I'll
be happy to review.

Good luck.

-- 
tejun
