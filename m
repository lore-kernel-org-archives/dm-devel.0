From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/10] dm snapshot: Use kmalloc_array() in
 init_origin_hash()
Date: Thu, 29 Sep 2016 13:24:53 -0700
Message-ID: <1475180693.1954.1.camel@perches.com>
References: <566ABCD9.1060404@users.sourceforge.net>
         <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
         <3861d349-48fd-162b-a749-83e007f70b41@users.sourceforge.net>
         <1475142864.31297.5.camel@tiscali.nl> <1475143376.1946.2.camel@perches.com>
         <1475147577.31297.11.camel@tiscali.nl>
         <1475149503.31297.14.camel@tiscali.nl>
         <1475161270.2027.5.camel@perches.com>
         <1475178181.31297.21.camel@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475178181.31297.21.camel@tiscali.nl>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>, Andy Whitcroft <apw@canonical.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

On Thu, 2016-09-29 at 21:43 +0200, Paul Bolle wrote:
> On Thu, 2016-09-29 at 08:01 -0700, Joe Perches wrote:
> > $Constant there is any number and the match regex is
> > any upper case variable.
> Why doesn't that regex match on "ORIGIN_HASH_SIZE"?

It does match.

Did you see my earlier email?

$ ./scripts/checkpatch.pl -f drivers/md/dm-snap.c --show-types --types=alloc_with_multiply
WARNING:ALLOC_WITH_MULTIPLY: Prefer kmalloc_array over kmalloc with multiply
#329: FILE: drivers/md/dm-snap.c:329:
+       _origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),

WARNING:ALLOC_WITH_MULTIPLY: Prefer kmalloc_array over kmalloc with multiply
#338: FILE: drivers/md/dm-snap.c:338:
+       _dm_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),

total: 0 errors, 2 warnings, 2490 lines checked
