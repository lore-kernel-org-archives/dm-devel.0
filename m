From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Barriers still not passing on simple dm devices...
Date: Mon, 23 Mar 2009 22:52:31 +0100
Message-ID: <E1Lls4N-0001LL-Pz@be1.7eggert.dyndns.org>
References: <ciXHh-39c-37@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760187AbZCWVws@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, device-mapper development <dm-devel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, Andi
List-Id: dm-devel.ids

Eric Sandeen <sandeen@redhat.com> wrote:

> I've noticed that on 2.6.29-rcX, with Andi's patch
> (ab4c1424882be9cd70b89abf2b484add355712fa, dm: support barriers on
> simple devices) barriers are still getting rejected on these simple devices.

> So what's the right way around this?  What should dm (or md for that
> matter) advertise on their queues about ordered-ness?  Should there be
> some sort of "QUEUE_ORDERED_PASSTHROUGH" or something to say "this level
> doesn't care, ask the next level" or somesuch?  Or should it inherit the
> flag from the next level down?  Ideas?

IMO each block device SHOULD provide barriers - either native or emulated,
and each meta device MUST provide emulated barriers if it provides dynamic
device binding and barriers.
