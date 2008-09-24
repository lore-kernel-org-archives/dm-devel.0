From: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>
Subject: Re: [dm-devel] Re: [PATCH] dm-snapshot: poor copy-on-write performance
 due to I/O reordering
Date: Wed, 24 Sep 2008 14:55:50 +0900
Message-ID: <48D9D666.8010402@oss.ntt.co.jp>
References: <bd0gX-4ma-13@gated-at.bofh.it>	<E1KfzFv-00041e-8A@be1.7eggert.dyndns.org> <48D1AA84.3050603@oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754304AbYIXF53@vger.kernel.org>
In-Reply-To: <48D1AA84.3050603@oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: 7eggert@gmx.de, kjamieson@bycast.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hello,

 > Bodo Eggert wrote:
 >> Kazuo Ito <ito.kazuo@oss.ntt.co.jp> wrote:
 >>
 >>> Write throughput to LVM snapshot origin volume is an order
 >>> of magnitude slower than those to LV without snapshots or
 >>> snapshot target volumes, especially in the case of sequential
 >>> writes with O_SYNC on.
 >>>
 >>> The following patch originally written by Kevin Jamieson and
 >>> Jan Blunck and slightly modified for the current RCs by myself
 >>> tries to improve the performance by modifying the behaviour
 >>> of kcopyd, so that it pushes back an I/O job to the head of
 >>> the job queue instead of the tail as process_jobs() currently
 >>> does when it has to wait for free pages. This way, write
 >>> requests aren't shuffled to cause extra seeks.
 >>
 >> Did you check for starvation problems, too?

I have twice and four times as many pages allocated
to each kcopyd client without patching the queuing behaviour
and got these figures (MiB/s) -- allocating more buffers doesn't
seem to help much, so I don't think it's memory shortage
that matters here.

test \ # of buffer pages   256(default)      512        1024
  10M dd+fsync, create        16.00          18.60      18.95
  10M dd+fsync, update        16.14          18.39      19.70
100M dd+fsync, create        15.18          18.80      19.29
100M dd+fsync, update        15.28          19.29      19.45

--
> Kazuo Ito, NTT Open Source Software Center
> Phone: +81-3-5860-5125 / FAX: +81-3-5463-5690 / E-mail: 
> ito.kazuo@oss.ntt.co.jp
