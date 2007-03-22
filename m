From: Christophe Saout <christophe@saout.de>
Subject: Re: [PATCH 0/3] Fix SMP races in dm-crypt
Date: Thu, 22 Mar 2007 21:28:16 +0100
Message-ID: <1174595296.2458.13.camel@leto.intern.saout.de>
References: <200703210806.30499.okir@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200703210806.30499.okir@lst.de>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Olaf,

> (I'm resending this, because it seems mailman ate this posting
> the first time around - apologies if you're seeing this twice).
> 
> I investigated kernel Bug 5948 (Oops when accessing SATA with device mapper on
> AMD 64 X2) to help cut down on the number of open bugs.
> 
> The problem reported in that bug seems to be caused by memory pressure
> when writing - crypt_alloc_buffer can return less than the full number of
> pages required. In that case, the bio is split, but we're keeping a pointer
> to the first chunk of the request around in first_clone, and copy it. If the
> first clone completes I/O while we're cloning it, we oops on garbage in
> the bvec.
> 
> I was able to reproduce this on 2.6.20 - and the following patches
> seem to fix it for me.
> 
> dm-crypt-clone_init-early
> 	We need to call clone_init early on, before we can conceivably
> 	ever call bio_put on the clone
> 
> dm-crypt-clone-race
> 	Do no access bios after generic_make_request
> 
> dm-crypt-drop-first_clone
> 	Drop the first_clone business, and always allocate a fresh bio.

I fully agree. I didn't notice when the sharing of the bvec went away,
but it's no longer needed and the code is simpler. As for the other two
- ouch, you're right.

Thanks for investigating fixing these things.

All four patches are

Acked-By: Christophe Saout <christophe@saout.de>
