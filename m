From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Fwd: Hello,
 Andrew! Short question: Recently I've tried 2.6.24-git11 ...
Date: Mon, 4 Feb 2008 07:49:17 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802040746380.7554@hp.linux-foundation.org>
References: <43d009740802020227u187576a0s3931a24107e847ae@mail.gmail.com>
	<43d009740802031020j6b9fdcdfj1573d7758d75284e@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43d009740802031020j6b9fdcdfj1573d7758d75284e@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Igor <for.poige+linux@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Mon, 4 Feb 2008, Igor wrote:
> 
> ... and found out that it doesn't "see" my LVM-2's devices. Which way to bug
> report it would be the best one -- http://bugzilla.kernel.org/ or what?
> 
>    Are more details required or this would be enough?

Please do (at a minimum)
 - describe when it worked and when it broke (ie does -git10 work for you, 
   and -git11 breaks?)
 - describe differences in dmesg in working/non-working setup.
 - and shortly describe your setup

because the "it doesn't work" thing doesn't tell anybody much of 
anything ;)

		Linus
