From: "D. North" <rold5@tditx.com>
Subject: Re: HSG80, DM, multipath issues
Date: Mon, 10 Apr 2006 15:48:22 -0500
Message-ID: <20060410204822.GA6573@tditx.com>
References: <20060410174210.GA3798@tditx.com> <443AA3DF.3080404@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <443AA3DF.3080404@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Thus spake Christophe Varoqui (christophe.varoqui@free.fr):

> The one I used is "force a bounce per LUN just after driver loading", 
> which this snippet does :
> 
>        sg_start -s 1 /dev/$i


Thanks! ... This got me going enough to get a /dev/mapper/lun4p1...p3 up & running!
This was done manually from a 'rescue mode' boot of SuSE 10.

After trying the required commands on a running system, it's clear now that the
device mapper setup has to be done in the initrd if I expect to boot from this
array. No problem there... that's just a comment.

What is troubling me more at the moment is the difference between the device
mapper table setup commands created by the multipath command and how they
are different from what dm-mpath.c is actually expecting.

I downloaded 0.4.7 multipath tools & verified that they produce the same
table setup issues that I'm having trouble with from the 0.4.5 tool that
is current with SuSE 10. For example, the SuSE version of multipath command
produces this:
       0 443027195 multipath 0 0 2 1 round-robin 1 1 8:0 1000 round-robin 1 1 8:16 1000
Which produces the previously mentioned misparse in dm-mpath.c (my debugging mods)
       Apr 10 15:30:35 orthus-san kernel: nr_params is 1001, nr_selector_args = 1000, pg->nr_pgpaths is 8

Multipath tools 0.4.7 also causes the same diagnostic message (from my
debugging modifications), and it is sending in the same number of arguments
(14) to dm-mpath.c.  I don't, however, get the diagnostic message any more from
this version of multipath to determine what it is actually sending into
libdevmapper, so I am not, at the moment, absolutely certain that the argument
list is the same as 0.4.5.

To bypass the misparse, I can still use a command like this:
       # echo 0 443027195 multipath 0 0 2 1 round-robin 1 1 1 0 8:0 round-robin 1 1 1 0 8:16 | dmsetup create lun4

I have successfully set up a device mapper mapping that I can read & write
to from a rescue system, so the above command does actually work.

Unfortunately, if I correctly understand what I'm seeing, this means that the
current multipath tools 0.4.7 is incompatible with the dm_multipath module in
my 2.6.13-15.8 kernel. Also, this would seem to mean that multipathd is also
incompatible with this kernel.

Is anyone aware of a workaround or even a better identification for this
incompatibility?

Thanks!
-- 
D. North
