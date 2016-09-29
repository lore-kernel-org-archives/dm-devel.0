From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 01/10] dm snapshot: Use kmalloc_array() in
 init_origin_hash()
Date: Thu, 29 Sep 2016 23:14:53 +0200
Message-ID: <1475183693.31297.36.camel@tiscali.nl>
References: <566ABCD9.1060404@users.sourceforge.net>
         <080668d9-1e1e-e208-f9ea-ff718e8070e5@users.sourceforge.net>
         <3861d349-48fd-162b-a749-83e007f70b41@users.sourceforge.net>
         <1475142864.31297.5.camel@tiscali.nl> <1475143376.1946.2.camel@perches.com>
         <1475147577.31297.11.camel@tiscali.nl>
         <1475149503.31297.14.camel@tiscali.nl>
         <1475161270.2027.5.camel@perches.com>
         <1475178181.31297.21.camel@tiscali.nl>
         <1475180693.1954.1.camel@perches.com>
         <1475181593.31297.25.camel@tiscali.nl>
         <1475182586.1954.3.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1475182586.1954.3.camel@perches.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

On Thu, 2016-09-29 at 13:56 -0700, Joe Perches wrote:
> It doesn't matter match either way to me.
> 
> The case for the unnecessary multiply with <= gcc 4.8 was
> removed with:
> 
> commit 91c6a05f72a996bee5133e76374ab3ad7d3b9b72
> Author: Alexey Dobriyan <adobriyan@gmail.com>
> Date:   Tue Jul 26 15:22:08 2016 -0700
> 
>     mm: faster kmalloc_array(), kcalloc()
>     
>     When both arguments to kmalloc_array() or kcalloc() are known at compile
>     time then their product is known at compile time but search for kmalloc
>     cache happens at runtime not at compile time.
>     
>     Link: http://lkml.kernel.org/r/20160627213454.GA2440@p183.telecom.by
>     Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>     Cc: Christoph Lameter <cl@linux.com>
>     Cc: Pekka Enberg <penberg@kernel.org>
>     Cc: David Rientjes <rientjes@google.com>
>     Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

You've lost me.

Why does this stop you fixing an apparently wrong checkpatch rule,
crude as parts of it are (ie, uppercase identifier must be a constant)?


Paul Bolle
