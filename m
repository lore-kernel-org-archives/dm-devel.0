From: akpm@linux-foundation.org
Subject: [patch 1/3] dm: strncpy does not null terminate string
Date: Fri, 18 Sep 2009 12:45:07 -0700
Message-ID: <200909181945.n8IJj7X4010399@imap1.linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: quoted-printable
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
To: agk@redhat.com
Cc: dm-devel@redhat.com, roel.kluin@gmail.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

From: Roel Kluin <roel.kluin@gmail.com>

strlcpy() will always null terminate the string.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/md/dm-ioctl.c~dm-strncpy-does-not-null-terminate-string=
 drivers/md/dm-ioctl.c
--- a/drivers/md/dm-ioctl.c~dm-strncpy-does-not-null-terminate-string
+++ a/drivers/md/dm-ioctl.c
@@ -634,9 +634,9 @@ static struct mapped_device *find_device
 		 * Sneakily write in both the name and the uuid
 		 * while we have the cell.
 		 */
-		strncpy(param->name, hc->name, sizeof(param->name));
+		strlcpy(param->name, hc->name, sizeof(param->name));
 		if (hc->uuid)
-			strncpy(param->uuid, hc->uuid, sizeof(param->uuid)-1);
+			strlcpy(param->uuid, hc->uuid, sizeof(param->uuid));
 		else
 			param->uuid[0] =3D '\0';
=20
_
