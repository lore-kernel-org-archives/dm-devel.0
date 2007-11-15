From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 15/40] dm delay: fix status
Date: Wed, 14 Nov 2007 22:44:41 -0800
Message-ID: <20071115064441.GP19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932127AbXKOG61@vger.kernel.org>
Content-Disposition: inline; filename="dm-delay-fix-status.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Milan Broz <mbroz@redhat.com>

patch 79662d1ea37392651f2cff08626cab6a40ba3adc in mainline.


Fix missing space in dm-delay target status output
if separate read and write delay are configured.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/md/dm-delay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -305,7 +305,7 @@ static int delay_status(struct dm_target
 		       (unsigned long long) dc->start_read,
 		       dc->read_delay);
 		if (dc->dev_write)
-			DMEMIT("%s %llu %u", dc->dev_write->name,
+			DMEMIT(" %s %llu %u", dc->dev_write->name,
 			       (unsigned long long) dc->start_write,
 			       dc->write_delay);
 		break;

-- 
