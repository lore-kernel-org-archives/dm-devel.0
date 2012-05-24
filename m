From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 12/14] Closures
Date: Wed, 23 May 2012 18:23:31 -0700
Message-ID: <1337822611.4279.3.camel@joe2Laptop>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	 <1337817771-25038-13-git-send-email-koverstreet@google.com>
	 <1337820443.1747.24.camel@joe2Laptop>
	 <20120524011654.GA28662@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120524011654.GA28662-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, 2012-05-23 at 21:16 -0400, Kent Overstreet wrote:
> > or maybe just bundle all this in a single seq_printf
> Do you mean something like this?
> seq_printf(f, "%s%s%s%s%s\n",
> 	   r & CLOSURE_RUNNING	? "R" : "",
> 	   r & CLOSURE_BLOCKING ? "B" : "");

Yes.

> Or do you have a better way of writing that in mind?

No.

cheers, Joe
