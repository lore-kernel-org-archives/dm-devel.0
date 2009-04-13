From: Milan Broz <mbroz@redhat.com>
Subject: Re: SMP-aware kcryptd?
Date: Mon, 13 Apr 2009 19:36:36 +0200
Message-ID: <49E37824.8010100@redhat.com>
References: <49E3410D.9040500@wpkg.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49E3410D.9040500@wpkg.org>
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
Cc: dm-crypt@saout.de
List-Id: dm-devel.ids

Tomasz Chmielewski wrote:
> Currently, the trend with CPUs is to add more cores rather than increase 
> the speed of a single core.
> 
> This does not scale very well with certain things in the Linux kernel. 
> One of them is kcryptd.
> 
> 
> A system able to deliver data with a speed of ~200 MB/s from a RAID 
> array, will be only able to deliver a fraction of it (i.e. ~40 MB/s in 
> my case) when reads are being done from a dm-crypt device.
> 
> This is because kcryptd is not SMP-aware: it performs all calculations 
> on a single logical CPU only.
> 
> Are there any plans to change it?

Yes, I think I already commented this in some thread,
there are basically 2 possible approaches:

1) create several "encryption" threads in dm-crypt (e.g. per CPU core) or
2) parallelize async crypto requests processing (in crypto layer)

I have some patches for 1) but the result is not what I expected
- performance highly depends on write pattern for example.
In short, the code need more thought.
(I tried to parallelize sector encryption _vs_ whole bio request encryption,
and there are still some problem with both. Also barriers and reordering
of requests can be problem here.)

Another problem with 1) is what happens when there is hw acceleration -
multiple threads are useful only if main cpu runs encryption,
for hw & async crypto requests it can cause problems.

The crypto driver is completely transparent - dm-crypt have no idea
if encryption runs on main cpu or in an accelerator hw
(=> solution 2) is more generic).

Anyway, it is not highest priority currently... but still in slow progress.
(but I guess high speed SSDs will increase priority for this too,
currently it is real problem only for RAID arrays:-)

Milan
--
mbroz@redhat.com
