From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Regression in 3.15 on POWER8 with multipath SCSI
Date: Wed, 02 Jul 2014 17:30:43 +0200
Message-ID: <53B425A3.9090404@acm.org>
References: <20140630103058.GA17747@iris.ozlabs.ibm.com> <20140701193907.GA15306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140701193907.GA15306@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Paul Mackerras <paulus@samba.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Vladimir Davydov <vdavydov@parallels.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

On 07/01/14 21:39, Mike Snitzer wrote:
> (btw, Bart Van Assche also has issues with commit e8099177 due to hangs
> during cable pull testing of mpath devices -- Bart: curious to know if
> your cable pull tests pass if you just revert bcccff93).

Sorry but even with bcccff93 reverted after a few iterations my cable
pull simulation test still causes several tasks to hang in sleep_on_page().

Bart.
