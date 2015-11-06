From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Fri, 6 Nov 2015 12:23:29 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511061201520.5619@file01.intranet.prod.int.rdu2.redhat.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com> <563B066C.6050202@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <563B066C.6050202@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, device-mapper development <dm-devel@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids



On Thu, 5 Nov 2015, Milan Broz wrote:

> On 11/05/2015 03:02 AM, Sami Tolvanen wrote:
> > This patch set adds error correction support to dm-verity, which
> > makes it possible to recover from data corruption in exchange of
> > increased space overhead.
> > 
> > The feature is implemented as part of dm-verity to take advantage
> > of the existing hash tree to improve performance and locate known
> > erasures.
> 
> Hi,
> 
> could you please elaborate why is all this needed? To extend support
> of some faulty flash chips?
> 
> Do you have some statistics that there are really such correctable errors
> in real devices?

I'm also wondering what is this patch useful for. Disks and flash 
controllers have their own error detection and correction, so the 
controller will much more likely return an I/O error rather than corrupted 
data. And the patch does absolutely nothing to recover from an I/O error, 
it only attempts to correct corrupted reads.

Another point - if the read-only system partition is experiencing some 
errors, than the read-write partition will probably have errors too 
(because both partitions are on the same flash chip) and the Chromebook or 
smartphone will be unusable anyway because of errors on the writeable 
partition. Do you have some real case where such error corrections 
increase longevity of some device?

> Anyway, I really do not understand layer separation here. Either we have
> cryptographically strong data integrity checking or we have
> error-correction. Are we sure this combination does not create some unintended
> gap in integrity checking? Why the integrity check should even try to do some
> error correction if there is an intentional integrity attack?
> 
> IMO if you need an error correction, this should be placed as a separate
> layer below the crypto integrity check, the same as RAID operates.

If error correction was placed below dm-verity, it would degrade 
performance because it would have to verify every sector, even if 
dm-verity said that the sector is valid.

But you can take raid5 in read-only mode, put it on several partitions 
protected with dm-verity and you get decent error correction (unlike this 
patch, it would also correct I/O errors returned by the flash controller). 
I suggest doing this.

> The second question - why are you writing another separate tool
> for maintenance for dm-verity when there is veritysetup?
> 
> Milan

Mikulas
