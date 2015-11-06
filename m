From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH 0/4] dm verity: add support for error correction
Date: Fri, 6 Nov 2015 19:06:34 +0000
Message-ID: <20151106190634.GA2813@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
 <563B066C.6050202@redhat.com>
 <alpine.LRH.2.02.1511061201520.5619@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1511061201520.5619@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>, device-mapper development <dm-devel@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mark Salyzyn <salyzyn@google.com>
List-Id: dm-devel.ids

On Fri, Nov 06, 2015 at 12:23:29PM -0500, Mikulas Patocka wrote:
> I'm also wondering what is this patch useful for. Disks and flash 
> controllers have their own error detection and correction

I think I addressed this earlier. Some storage devices are able to
correct bit flips, but don't have enough redundancy to correct larger
errors. Using this patch set we can correct N MiB of consecutive
corruption anywhere on the partition with the same amount of storage
overhead.

> Another point - if the read-only system partition is experiencing some
> errors, than the read-write partition will probably have errors too

On mobile devices, errors in read-only partitions often lead to
bricked devices while errors in the read-write parts might only lead
to lost cat photos. There are situations where people would prefer to
have a working phone even if it fails to store some of their data.

> Do you have some real case where such error corrections 
> increase longevity of some device?

Yes, there have been several cases where read-only partition errors
have rendered a device unusable. The sheer volume of mobile devices
means that even if a tiny fraction of them suffer from such a problem,
it's going to affect a large number of people.

> But you can take raid5 in read-only mode, put it on several partitions 
> protected with dm-verity and you get decent error correction

I agree. Unfortunately, we don't currently have the luxury of using
raid on mobile devices.

Sami
