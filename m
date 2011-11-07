From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [dm-devel] Error when compiling drivers/md/dm-bufio.c
Date: Mon, 7 Nov 2011 08:18:13 -0800
Message-ID: <CA+55aFwejLwfY6A9o2yx1YPJMD4a5grD6ttmoG1AsFdEcGZWcw@mail.gmail.com>
References: <20111107082231.GB18221@smp.if.uj.edu.pl> <20111107134601.GH12886@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1111071035380.5814@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1111071035380.5814@hs20-bc2-1.build.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Witold Baryluk <baryluk@smp.if.uj.edu.pl>, Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 7, 2011 at 7:36 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> Yes, apply this patch:
>
> dm-bufio: Include <linux/module.h>

Actually, is just <linux/export.h> sufficient?

It's much better to use just export.h if you have the choice - lots of
code doesn't need the whole module thing that brings in just about all
the headers in the whole kernel (ok, not quite, but still..)

That was kind of the whole point of the split.

                  Linus
