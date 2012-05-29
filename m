From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 05/16] block: Kill bi_destructor
Date: Tue, 29 May 2012 11:20:25 +0900
Message-ID: <20120529022025.GH20954@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-6-git-send-email-koverstreet@google.com>
 <20120528013608.GE9891@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120529021042.GA6472@dhcp-172-18-216-138.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120529021042.GA6472-RcKxWJ4Cfj3IzGYXcIpNmNLIRw13R84JkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

Hello, Kent.

On Mon, May 28, 2012 at 10:10:42PM -0400, Kent Overstreet wrote:
> Heh. Well, in my view deleting stuff is good by default, and if you can
> delete things without user visible effects and without making the code
> more complicated... 
> 
> So I guess given the simplicity of this particular patch in the series
> I'm not sure what there is to justify here. Any suggestions on what
> would make sense to put in...?

So, what I would prefer to see is the justification of the whole
changes somewhere in the patch stream, so that patches can do,n

patch 1: update X to not use bi_destructor which will soon be removed.
patch 2: ditto for Y
...
patch N: bi_destructor is stupid because blah blah and after preceding
         changes is no longer used.  Kill it.

so that when one sees a patch in the series and wonders why the change
is being made, [s]he can follow the patch stream and understand.

Thanks.

-- 
tejun
