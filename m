From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Error when compiling drivers/md/dm-bufio.c
Date: Mon, 7 Nov 2011 16:20:56 +0000
Message-ID: <20111107162056.GA4396@agk-dp.fab.redhat.com>
References: <20111107082231.GB18221@smp.if.uj.edu.pl> <20111107134601.GH12886@agk-dp.fab.redhat.com> <Pine.LNX.4.64.1111071035380.5814@hs20-bc2-1.build.redhat.com> <20111107161514.GE18221@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111107161514.GE18221@smp.if.uj.edu.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Nov 07, 2011 at 05:15:14PM +0100, Witold Baryluk wrote:
> Adding similar include to dm-space-map-checker.c, resolves problem.
 
In there, try the new 
#include <linux/export.h>

Alasdair
