From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fix string overflow in pp_hds_modular
Date: Mon, 06 Aug 2007 13:25:26 +0200
Message-ID: <46B70526.2050408@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000303020406020806010602"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>, Matthias Rudolph <Matthias.Rudolph@hds.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------000303020406020806010602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

our build checker detected a string overflow in pp_hds_modular.
One shouldn't really write 9 bytes into a 8 byte string ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)

--------------000303020406020806010602
Content-Type: text/plain; name="multipath-tools-pp_hds_modular-buffer-overflow"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="multipath-tools-pp_hds_modular-buffer-overflow"

tree d0feb33b9e79f82c08ba54e3232ff74e3d0a3e92
parent 5ac8944b746a19c2c08e96d9c91c5b00eb0ef95e
author Hannes Reinecke <hare@suse.de> 1186052416 +0200
committer Hannes Reinecke <hare@suse.de> 1186052416 +0200

pp_hds_modular: Fix buffer overflow

'vendor' is defined to hold 8 bytes, yet snprintf tries to write 9 bytes
to it. Bad.

Signed-off-by: Hannes Reinecke <hare@suse.de>
a04c8abdc0da9556ac4ccedacef3ca41f0aceeb9
 path_priority/pp_hds_modular/pp_hds_modular.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/path_priority/pp_hds_modular/pp_hds_modular.c b/path_priority/pp_hds_modular/pp_hds_modular.c
index 7411508..10b28b8 100644
--- a/path_priority/pp_hds_modular/pp_hds_modular.c
+++ b/path_priority/pp_hds_modular/pp_hds_modular.c
@@ -120,7 +120,7 @@ int main (int argc, char **argv)
 int hds_modular_prio (const char *dev)
 {
 	int sg_fd, k;
-	char vendor[8];
+	char vendor[9];
 	char product[32];
 	char serial[32];
 	char ldev[32];

--------------000303020406020806010602
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000303020406020806010602--
