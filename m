From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [PATCH] kobject: provide kobject_put_wait to fix module
 unload race
Date: Sun, 05 Jan 2014 17:43:56 +0100
Message-ID: <52C98BCC.9040900@acm.org>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Jeff Mahoney <jeffm@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org, device-mapper development <dm-devel@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@kernel.org
List-Id: dm-devel.ids

On 01/04/14 19:06, Mikulas Patocka wrote:
> -	if (t && !t->release)
> -		pr_debug("kobject: '%s' (%p): does not have a release() "
> -			 "function, it is broken and must be fixed.\n",
> -			 kobject_name(kobj), kobj);
> -

Has it been considered to issue a warning if no release function has
been defined and free_completion == NULL instead of removing the above
debug message entirely ? I think even with this patch applied it is
still wrong to invoke kobject_put() on an object without defining a
release function.

Thanks,

Bart.
