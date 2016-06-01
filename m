From: "James Johnston" <johnstonj.public@codenest.com>
Subject: RE: [PATCH] dm-crypt: Fix error with too large bios (was: bcache gets stuck flushing writeback cache when used in combination with LUKS/dm-crypt and non-default bucket size)
Date: Wed, 1 Jun 2016 04:19:11 -0000
Message-ID: <07be01d1bbbc$c2e37f70$48aa7e50$@codenest.com>
References: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com> <5739F07A.5090608@buttersideup.com> <alpine.LRH.2.11.1605191618560.22436@mx.ewheeler.net> <02b101d1b265$2bc46fb0$834d4f10$@codenest.com> <alpine.LRH.2.11.1605201322530.26328@mx.ewheeler.net> <034e01d1b3e2$1de2f910$59a8eb30$@codenest.com> <alpine.LRH.2.02.1605271037470.2109@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1605271037470.2109@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Mikulas Patocka' <mpatocka@redhat.com>
Cc: 'Eric Wheeler' <bcache@lists.ewheeler.net>, 'Tim Small' <tim@buttersideup.com>, 'Kent Overstreet' <kent.overstreet@gmail.com>, 'Alasdair Kergon' <agk@redhat.com>, 'Mike Snitzer' <snitzer@redhat.com>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, dm-crypt@saout.de, 'Neil Brown' <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Fri, 27 May 2016, Mikulas Patocka wrote:
> dm-crypt: Fix error with too large bios
> 
> When dm-crypt processes writes, it allocates a new bio in the function
> crypt_alloc_buffer. The bio is allocated from a bio set and it can have at
> most BIO_MAX_PAGES vector entries, however the incoming bio can be larger
> if it was allocated by other means. For example, bcache creates bios
> larger than BIO_MAX_PAGES. If the incoming bio is larger, bio_alloc_bioset
> fails and error is returned.
> 
> To avoid the error, we test for too large bio in the function crypt_map
> and dm_accept_partial_bio to split the bio. dm_accept_partial_bio trims
> the current bio to the desired size and requests that the device mapper
> core sends another bio with the rest of the data.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Cc: stable@vger.kernel.org	# v3.16+

Tested-by: James Johnston <johnstonj.public@codenest.com>

I tested this patch by:

1.  Building v4.7-rc1 from Torvalds git repo.  Confirmed that original bug
    still occurs on Ubuntu 15.10.

2.  Applying your patch to v4.7-rc1.  My kill sequence no longer works,
    and the writeback cache is now successfully flushed to disk, and the
    cache can be detached from the backing device.

3.  To check data integrity, copied 250 MB of /dev/urandom to some file
    on main volume.  Then, dd copy this file to /dev/bcache0.  Then,
    detached the cache device from the backing device.  Then, rebooted.
    Then, dd copy /dev/bcache0 to another file on main volume.  Then,
    diff the files and confirm no changes.

So it looks like it works, based on this admittedly brief testing.  Thanks!

Best regards,

James Johnston


