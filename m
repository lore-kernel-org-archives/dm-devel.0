From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Sat, 7 Nov 2015 10:18:03 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511070959070.18330@file01.intranet.prod.int.rdu2.redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com> <563B066C.6050202@redhat.com> <alpine.LRH.2.02.1511061201520.5619@file01.intranet.prod.int.rdu2.redhat.com> <20151106190634.GA2813@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151106190634.GA2813@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids



On Fri, 6 Nov 2015, Sami Tolvanen wrote:

> On Fri, Nov 06, 2015 at 12:23:29PM -0500, Mikulas Patocka wrote:
> > I'm also wondering what is this patch useful for. Disks and flash 
> > controllers have their own error detection and correction
> 
> I think I addressed this earlier. Some storage devices are able to
> correct bit flips, but don't have enough redundancy to correct larger
> errors. Using this patch set we can correct N MiB of consecutive
> corruption anywhere on the partition with the same amount of storage
> overhead.

So, why doesn't the patch correct I/O errors? It is more likely that the 
flash controller returns an I/O error than corrupted data. Why are you 
correcting corrupted data (that is unlikely) and not correcting I/O errors 
that are likely?

> > Another point - if the read-only system partition is experiencing some
> > errors, than the read-write partition will probably have errors too
> 
> On mobile devices, errors in read-only partitions often lead to
> bricked devices while errors in the read-write parts might only lead
> to lost cat photos. There are situations where people would prefer to
> have a working phone even if it fails to store some of their data.

The read-write partition holds compiled applications and I doubt the 
smartphone would work if there were random bits flipped.

> > Do you have some real case where such error corrections 
> > increase longevity of some device?
> 
> Yes, there have been several cases where read-only partition errors
> have rendered a device unusable. The sheer volume of mobile devices
> means that even if a tiny fraction of them suffer from such a problem,
> it's going to affect a large number of people.

Why don't you reflash the device from bootloader? (by holding power and 
volume keys simultaneously on startup and using the fastboot utility)

> > But you can take raid5 in read-only mode, put it on several partitions 
> > protected with dm-verity and you get decent error correction
> 
> I agree. Unfortunately, we don't currently have the luxury of using
> raid on mobile devices.

Why not, it's just a simple kernel option. If raid5 already does data 
correction, there is no reason why to duplicate this work.

> Sami

Mikulas
