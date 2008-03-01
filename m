From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [dm-devel] Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Sat, 01 Mar 2008 16:44:47 +0100
Message-ID: <47C979EF.7070906@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762144AbYCAPp1@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>, agk@redhat.com, herbert@gondor.apana.org.au, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

Ritesh Raj Sarraf wrote:

(...)

> Meanwhile I was able to reproduce the bug again with the same configuration 
> and the same scenario. So I believe that the bug can be reproduced 
> consistently.
> 
> Here are the steps:
> 
> 1) Initialize a device using dm-crypt and LUKS
> 2) Create a filesystem on top of it and mount it.
> 3) Write huge amount of data (as a normal user). Something like 150GB.
> 
> As the load goes hight (to something like 12-14), the kernel lock-up is logged 
> into dmesg.
> At that moment, the OS is barely responsive.

I tried to reproduce it on two machines running 2.6.24.2, with cfq 
scheduler.

One machine, with 5x HDD, RAID-5, dm-crypt/LUKS, LVM, ext3 on top of it 
all - I created a 250 GB file, the load was 4-5. No lockups or anything.
Later, removing that 250 GB file took over 7 minutes, but that's a 
different story.


Second machine, dm-crypt on a USB-connected drive, LVM, ext3 on top of 
it, X with nvidia binary blob (version 169.09). I created a 190 GB file, 
the load was indeed pretty high - up to about 14. But still, no lockups 
of any kind.


-- 
Tomasz Chmielewski
http://wpkg.org
