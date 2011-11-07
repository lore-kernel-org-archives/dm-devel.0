From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Subject: Re: [dm-devel] Error when compiling drivers/md/dm-bufio.c
Date: Mon, 7 Nov 2011 17:32:15 +0100
Message-ID: <20111107163215.GF18221@smp.if.uj.edu.pl>
References: <20111107082231.GB18221@smp.if.uj.edu.pl>
 <20111107134601.GH12886@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1111071035380.5814@hs20-bc2-1.build.redhat.com>
 <CA+55aFwejLwfY6A9o2yx1YPJMD4a5grD6ttmoG1AsFdEcGZWcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_smp.if.uj.edu.pl-21326-1320683538-0001-2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFwejLwfY6A9o2yx1YPJMD4a5grD6ttmoG1AsFdEcGZWcw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-21326-1320683538-0001-2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 11-07 08:18, Linus Torvalds wrote:
> On Mon, Nov 7, 2011 at 7:36 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> > Yes, apply this patch:
> >
> > dm-bufio: Include <linux/module.h>
> 
> Actually, is just <linux/export.h> sufficient?

I changed include to <linux/export.h>, and dm-bufio.c
gives error 
  CC [M]  drivers/md/dm-bufio.o
drivers/md/dm-bufio.c:1677:63: error: expected ‘)’ before ‘ulong’
drivers/md/dm-bufio.c:1678:40: error: expected ‘)’ before string constant
drivers/md/dm-bufio.c:1680:55: error: expected ‘)’ before ‘uint’
drivers/md/dm-bufio.c:1681:35: error: expected ‘)’ before string constant
drivers/md/dm-bufio.c:1683:67: error: expected ‘)’ before ‘ulong’
drivers/md/dm-bufio.c:1684:40: error: expected ‘)’ before string constant
drivers/md/dm-bufio.c:1686:79: error: expected ‘)’ before ‘ulong’
drivers/md/dm-bufio.c:1687:46: error: expected ‘)’ before string constant
drivers/md/dm-bufio.c:1689:87: error: expected ‘)’ before ‘ulong’
drivers/md/dm-bufio.c:1690:50: error: expected ‘)’ before string constant
drivers/md/dm-bufio.c:1692:73: error: expected ‘)’ before ‘ulong’
drivers/md/dm-bufio.c:1693:43: error: expected ‘)’ before string constant
drivers/md/dm-bufio.c:1695:73: error: expected ‘)’ before ‘ulong’
drivers/md/dm-bufio.c:1696:43: error: expected ‘)’ before string constant
drivers/md/dm-bufio.c:1698:15: error: expected declaration specifiers or ‘...’ before string constant
drivers/md/dm-bufio.c:1699:20: error: expected declaration specifiers or ‘...’ before string constant
drivers/md/dm-bufio.c:1700:16: error: expected declaration specifiers or ‘...’ before string constant

It is using module_param_named, and MODULE_PARAM_DESC, MODULE_AUTHOR,
MODULE_DESCRIPTION, MODULE_LICENSE macros.
(and module_init() and module_exit() also).

However dm-space-map-checker.c compiles fine.

Update patch atached.


> 
> It's much better to use just export.h if you have the choice - lots of
> code doesn't need the whole module thing that brings in just about all
> the headers in the whole kernel (ok, not quite, but still..)
> 
> That was kind of the whole point of the split.
> 
>                   Linus

Regards,
Witek


-- 
Witold Baryluk
JID: witold.baryluk // jabster.pl

--=_smp.if.uj.edu.pl-21326-1320683538-0001-2
Content-Type: text/x-diff; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="driver-md-include-module-h-export-h.patch"
X-Mime-Autoconverted: from 8bit to 7bit by courier 0.65

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cb24666..4ef8116 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -8,6 +8,7 @@
 
 #include "dm-bufio.h"
 
+#include <linux/module.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-io.h>
 #include <linux/slab.h>
diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md/persistent-data/dm-space-map-checker.c
index bb44a93..4bbc7d5 100644
--- a/drivers/md/persistent-data/dm-space-map-checker.c
+++ b/drivers/md/persistent-data/dm-space-map-checker.c
@@ -6,6 +6,7 @@
 
 #include "dm-space-map-checker.h"
 
+#include <linux/export.h>
 #include <linux/device-mapper.h>
 
 #ifdef CONFIG_DM_DEBUG_SPACE_MAPS

--=_smp.if.uj.edu.pl-21326-1320683538-0001-2--
