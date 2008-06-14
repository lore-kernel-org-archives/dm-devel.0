From: Brett Lymn <blymn@baesystems.com.au>
Subject: Re: [dm-devel] NetBSD libdevmapper port
Date: Sat, 14 Jun 2008 19:28:12 +0930
Message-ID: <20080614095812.GA21126@baea.com.au>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com> <200806131652.m5DGqD0s015068@sbuxscan.baea.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <bounces-tech-kern-owner-netbsd-tech-kern=m.gmane.org@NetBSD.org>
Content-Disposition: inline
In-Reply-To: <200806131652.m5DGqD0s015068@sbuxscan.baea.com.au>
Sender: tech-kern-owner@NetBSD.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Adam Hamsik <haaaad@gmail.com>, dm-devel@redhat.com, tech-kern@netbsd.org
List-Id: dm-devel.ids


Hi - I am mentoring Adam in this project

On Fri, Jun 13, 2008 at 12:51:48PM -0400, Mikulas Patocka wrote:
> 
> If you are rewriting it --- have you somehow thought about avoiding 
> suspend?
>

I assume you are talking about handling a suspend of a device
underlying the LVM.  At the moment, NetBSD does not have the facility
to suspend a device in this manner so I dont think we will have this
issue (yet).
 
> 
> A Linux LVM does something like: suspend old table, write to disk with 
> direct i/o, resume new table. I'd suggest that you invent some method how 
> to batch these operations into single syscall

I think this should be doable with the API that Adam is using - in
NetBSD there is a thing called proplib which is a method of passing a
very limited form of XML into the kernel - Adam is using proplib to
pass the lvm parameters into the kernel.

>  --- the question --- how to do it portably on all 
> NetBSD architectures?), 

Actually, most of the operations you have listed are, from memory,
machine independent code - there is very little of the kernel that
actually is architecture specific we work hard to keep it that way.

> 
> --- if you port lvm2 as it is, you'll have to audit (and maybe rewrite) 
> many parts of NetBSD kernel for not waiting for I/O. If you do it badly, 
> you'll get deadlocks.
> 

The head of the bleeding edge NetBSD code (netbsd-current) is having a
lot of work done on it to make the kernel re-entrant and
multi-threaded.  This may be a bit of a bonus in terms of what you are
saying because there should be locks that need to be held to perform
the i/o - it may be a case of just making the acquiring of these locks
non-blocking (or it may not be an issue at all).  We shall need to
wait and see on that one.

Thanks for the input.

-- 
Brett Lymn
"Warning:
The information contained in this email and any attached files is
confidential to BAE Systems Australia. If you are not the intended
recipient, any use, disclosure or copying of this email or any
attachments is expressly prohibited.  If you have received this email
in error, please notify us immediately. VIRUS: Every care has been
taken to ensure this email and its attachments are virus free,
however, any loss or damage incurred in using this email is not the
sender's responsibility.  It is your responsibility to ensure virus
checks are completed before installing any data sent in this email to
your computer."
