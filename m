From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] disable barriers in dm-crypt [was Re: BUG: Files
 corrupt after moving LVM volume to USB disk]
Date: Fri, 23 Mar 2007 15:45:26 +0100
Message-ID: <4603E806.3030205@redhat.com>
References: <20070322000348.92631512.akpm@linux-foundation.org>	
	<20070322153301.GN27600@agk.surrey.redhat.com>
	<2a12af650703221742p6691f4b5i21667a5c98217fb6@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2a12af650703221742p6691f4b5i21667a5c98217fb6@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Marti Raudsepp <marti@juffo.org>
Cc: Christophe Saout <christophe@saout.de>, Kernel hackers <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> Summary of what I've managed to rule out so far:
>1. this problem does not occur without dm-crypt

Please could you test attached patch ?
Sorry for another annoying reboot :-)

Milan
--
mbroz@redhat.com



From: Milan Broz <mbroz@redhat.com>

Disable barriers in dm-crypt because of current workqueue processing
can reorder requests.

This must be addresed later but for now disabling barriers is needed
to prevent data corruption.

Signed-off-by: Milan Broz <mbroz@redhat.com>

Index: linux-2.6.20.1/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.20.1.orig/drivers/md/dm-crypt.c	2007-03-23 15:07:11.000000000 +0100
+++ linux-2.6.20.1/drivers/md/dm-crypt.c	2007-03-23 15:09:59.000000000 +0100
@@ -925,6 +925,9 @@ static int crypt_map(struct dm_target *t
 	struct crypt_config *cc = ti->private;
 	struct crypt_io *io;
 
+	if (bio_barrier(bio))
+		return -EOPNOTSUPP;
+
 	io = mempool_alloc(cc->io_pool, GFP_NOIO);
 	io->target = ti;
 	io->base_bio = bio;
