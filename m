From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 01/10] dm snapshot: Use kmalloc_array() in
 init_origin_hash()
Date: Thu, 29 Sep 2016 23:42:45 +0200
Message-ID: <1475185365.31297.50.camel@tiscali.nl>
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
         <1475183693.31297.36.camel@tiscali.nl>
         <1475184082.1954.5.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1475184082.1954.5.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, dm-devel@redhat.com, linux-raid@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: dm-devel.ids

On Thu, 2016-09-29 at 14:21 -0700, Joe Perches wrote:
> > > It doesn't matter match either way to me.
> > Why does this stop you fixing an apparently wrong checkpatch rule,
> > crude as parts of it are (ie, uppercase identifier must be a
> > constant)?
> 
> It doesn't.  It just doesn't matter much (match) to me.

Joe, please.

I've recently ping-ponged with the kernel's "resident wrong bot of the
day" over this very rule (kmalloc_array() is safer than kmalloc(), so
change your driver now!). Could we just give wrong bots a bit less
ammunition whenever that's feasible?

Even if you don't care about my ping-pong experiences: this checkpatch
test is broken, please just fix it!


Paul Bolle
