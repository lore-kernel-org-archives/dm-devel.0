From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Don't display the state of the newly added
	map	during addition in the daemon and don't switch groups.
Date: Fri, 20 Mar 2009 12:37:55 +0100
Message-ID: <49C38013.9090709@suse.de>
References: <1237419489-3303-1-git-send-email-konrad@virtualiron.com>	<1237419489-3303-2-git-send-email-konrad@virtualiron.com>	<1237419489-3303-3-git-send-email-konrad@virtualiron.com>
	<1237419489-3303-4-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1237419489-3303-4-git-send-email-konrad@virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Konrad,

Konrad Rzeszutek wrote:
> From: Konrad Rzeszutek <konrad@mars.virtualiron.com>
>=20
> A previous commit mass-changed #ifdef DAEMON to check for 'mpp->waiter'=
. Unfortunatly
> when the 'domap' function is called with ACT_CREATE in the daemon, the =
mpp->waiter is not
> set, hence the multipath client mode logic is choosen. Fixing this trig=
gers another
> issues which is that newly added path via ACT_CREATE won't have their w=
aitevent thread
> created as the caller checks mpp->action (which changed to ACT_NOTHING)=
 and won't
> start the thread.

Nice. Far cleaner fix. But you forgot this:

diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index f1975fb..2d024ff 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -13,6 +13,7 @@
 #include "structs.h"
 #include "util.h"
 #include "debug.h"
+#include "config.h"
=20
 #define WORD_SIZE 64
=20
@@ -297,7 +298,7 @@ disassemble_map (vector pathvec, char * params, struc=
t multi
path * mpp)
                                strncpy(pp->dev_t, word, BLK_DEV_SIZE);
=20
                                /* Only call this in multipath client mod=
e */
-                               if (!mpp->waiter && store_path(pathvec, p=
p))
+                               if (!conf->daemon && store_path(pathvec, =
pp))
                                        goto out1;
                        }
                        FREE(word);

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
