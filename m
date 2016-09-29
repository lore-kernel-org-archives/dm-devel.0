From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 01/10] dm snapshot: Use kmalloc_array() in
 init_origin_hash()
Date: Thu, 29 Sep 2016 13:12:57 +0200
Message-ID: <1475147577.31297.11.camel@tiscali.nl>
References: <566ABCD9.1060404@users.sourceforge.net>
         <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
         <3861d349-48fd-162b-a749-83e007f70b41@users.sourceforge.net>
         <1475142864.31297.5.camel@tiscali.nl> <1475143376.1946.2.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1475143376.1946.2.camel@perches.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

On Thu, 2016-09-29 at 03:02 -0700, Joe Perches wrote:
> What's the false positive?
> 
> I get:
> 
> $ ./scripts/checkpatch.pl -f drivers/md/dm-snap.c --show-types --types=alloc_with_multiply
> WARNING:ALLOC_WITH_MULTIPLY: Prefer kmalloc_array over kmalloc with multiply
> #329: FILE: drivers/md/dm-snap.c:329:
> +	_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
> 
> WARNING:ALLOC_WITH_MULTIPLY: Prefer kmalloc_array over kmalloc with multiply
> #338: FILE: drivers/md/dm-snap.c:338:
> +	_dm_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
> 
> total: 0 errors, 2 warnings, 2490 lines checked
> 
> NOTE: For some of the reported defects, checkpatch may be able to
>       mechanically convert to the typical style using --fix or --fix-inplace.
> 
> drivers/md/dm-snap.c has style problems, please review.
> 
> NOTE: Used message types: ALLOC_WITH_MULTIPLY
> 
> NOTE: If any of the errors are false positives, please report
>       them to the maintainer, see CHECKPATCH in MAINTAINERS.

It seems it was intended to be silent about multiplying with constants,
where things that look like preprocessor defines are also considered
constants. Or did I misread that test?


Paul Bolle
