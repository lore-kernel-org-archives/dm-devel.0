From: "Brian Geisel" <brian.geisel@incipient.com>
Subject: [PATCH 1/1] Resend RTPG command if buffer short
Date: Tue, 14 Nov 2006 19:04:54 -0500
Message-ID: <2F9C0315D2701343B960848AD8A6111495009C@exch-2003.incipient.waltham>
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
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@free.fr>
List-Id: dm-devel.ids

Hi Christophe,

The following patch adds error and size checking to the REPORT TARGET
PORT GROUPS command issued by rtpg.c.  The old code issued a buffer of
128 bytes, but never checked the return length.  The new code starts
with a buffer of 128 bytes, but reallocates it if the buffer is too
small (SCSI returns the necessary length in the response data).  This is
more robust as it handles devices that consume more than 128 bytes for
RTPG, like the Incipient NSP.

I tried to handle errors, etc. as closely as I could to what is already
there in the code.  Let me know if you'd prefer anything written
differently.

Thanks,
Brian Geisel


--- a/path_priority/pp_alua/rtpg.c
+++ b/path_priority/pp_alua/rtpg.c
@@ -21,6 +21,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <errno.h>
+#include <inttypes.h>
=20
 #define __user
 #include <scsi/sg.h>
@@ -251,14 +252,33 @@
 int
 get_asymmetric_access_state(int fd, unsigned int tpg)
 {
-	unsigned char		buf[128];
+	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
 	struct rtpg_tpg_dscr *	dscr;
 	int			rc;
+	int			buflen;
+	uint32_t		scsi_buflen;
=20
-	rc =3D do_rtpg(fd, buf, sizeof(buf));
+	buflen =3D 128; /* Initial value from old code */
+	buf =3D (unsigned char *)malloc(buflen);
+	rc =3D do_rtpg(fd, buf, buflen);
 	if (rc < 0)
 		return rc;
+	scsi_buflen =3D buf[0] << 24 | buf[1] << 16 | buf[2] << 8 |
buf[3];
+	if (buflen < (scsi_buflen + 4)) {
+		free(buf);
+		buf =3D (unsigned char *)malloc(scsi_buflen);
+		if (buf =3D=3D NULL) {
+			PRINT_DEBUG ("malloc failed: could not allocate"
+				"%u bytes\n", scsi_buflen);
+			return -RTPG_RTPG_FAILED;
+		}
+		buflen =3D scsi_buflen;
+		rc =3D do_rtpg(fd, buf, buflen);
+		if (rc < 0)
+			return rc;
+	}
+	=09
=20
 	tpgd =3D (struct rtpg_data *) buf;
 	rc   =3D -RTPG_TPG_NOT_FOUND;
@@ -275,6 +295,7 @@
 		}
 	}
=20
+	free(buf);
 	return rc;
 }
