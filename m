From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: [PATCH 2/2] add additional info to end of status line
Date: Tue, 4 Dec 2007 09:36:32 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC01A1DFEA@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

From: Brian Wood <brian.j.wood@intel.com>

This patch adds additional information to the status line. It is added
at the end of the returned text so it will not interfere with existing
implementations using this data. The addition of this information will
allow for a common return interface to match that returned with the
dm-raid1.c status line (with Jonathan Brassow's patches).

Here is a sample of what is returned with a mirror:
isw_eeaaabgfg_mirror: 0 488390920 mirror 2 8:16 8:32 3727/3727 1 AA 1
core
here is what is returned with this patch for a stripe: =20
isw_dheeijjdej_stripe: 0 976783872 striped 2 8:16 8:32 AA

Signed-off-by: Brian Wood <brian.j.wood@intel.com>

--- linux-2.6.24-rc3/drivers/md/dm-stripe.c	2007-12-03
07:20:53.000000000 -0800
+++ linux-2.6.24-rc3.mod/drivers/md/dm-stripe.c	2007-12-03
07:19:30.000000000 -0800
@@ -272,12 +272,20 @@
 			 status_type_t type, char *result, unsigned int
maxlen)
 {
 	struct stripe_c *sc =3D (struct stripe_c *) ti->private;
+	char buffer[sc->stripes + 1];
 	unsigned int sz =3D 0;
 	unsigned int i;
=20
 	switch (type) {
 	case STATUSTYPE_INFO:
-		result[0] =3D '\0';
+		DMEMIT("%d ", sc->stripes);
+		for (i =3D 0; i < sc->stripes; i++)  {
+			DMEMIT("%s ", sc->stripe[i].dev->name);
+			buffer[i] =3D
atomic_read(&(sc->stripe[i].error_count)) ?
+				'D' : 'A';
+		}
+		buffer[i] =3D '\0';
+		DMEMIT("%s ", buffer);
 		break;
=20
 	case STATUSTYPE_TABLE:
