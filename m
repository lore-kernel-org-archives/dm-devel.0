From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: Re: dm snapshot: Use kmalloc_array() in init_origin_hash() ?
Date: Fri, 30 Sep 2016 09:14:19 +0200
Message-ID: <e851f012-0bf2-c675-ec4e-09641809cc96@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
 <3861d349-48fd-162b-a749-83e007f70b41@users.sourceforge.net>
 <1475142864.31297.5.camel@tiscali.nl> <1475143376.1946.2.camel@perches.com>
 <1475147577.31297.11.camel@tiscali.nl> <1475149503.31297.14.camel@tiscali.nl>
 <1475161270.2027.5.camel@perches.com> <1475178181.31297.21.camel@tiscali.nl>
 <1475180693.1954.1.camel@perches.com> <1475181593.31297.25.camel@tiscali.nl>
 <1475182586.1954.3.camel@perches.com> <1475183693.31297.36.camel@tiscali.nl>
 <1475184082.1954.5.camel@perches.com> <1475185365.31297.50.camel@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475185365.31297.50.camel@tiscali.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

> I've recently ping-ponged with the kernel's "resident wrong bot of the
> day" over this very rule (kmalloc_array() is safer than kmalloc(), so
> change your driver now!).

Your bot of the day is going to point more update candidates out
in various source files that can "accidentally" belong also to Linux. ;-)


> Could we just give wrong bots a bit less ammunition whenever that's feasible?

How do you think about to clarify constraints any further so that
the probability for false positives can be reduced as desired for
the involved source code analysis tools?


> Even if you don't care about my ping-pong experiences: this checkpatch
> test is broken, please just fix it!

I am curious how collateral software evolution will be continued.

Regards,
Markus
