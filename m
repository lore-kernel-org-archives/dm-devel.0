From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH 1/1] Resend RTPG command if buffer short
Date: Thu, 16 Nov 2006 00:17:51 +0100
Message-ID: <1163632672.10466.150.camel@localhost.localdomain>
References: <2F9C0315D2701343B960848AD8A6111495009C@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6M712xpEclEyqR5Xl2Jw"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2F9C0315D2701343B960848AD8A6111495009C@exch-2003.incipient.waltham>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Brian Geisel <brian.geisel@incipient.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--=-6M712xpEclEyqR5Xl2Jw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le mardi 14 novembre 2006 =C3=A0 19:04 -0500, Brian Geisel a =C3=A9crit :
> Hi Christophe,
>=20
> The following patch adds error and size checking to the REPORT TARGET
> PORT GROUPS command issued by rtpg.c.  The old code issued a buffer of
> 128 bytes, but never checked the return length.  The new code starts
> with a buffer of 128 bytes, but reallocates it if the buffer is too
> small (SCSI returns the necessary length in the response data).  This i=
s
> more robust as it handles devices that consume more than 128 bytes for
> RTPG, like the Incipient NSP.
>=20
> I tried to handle errors, etc. as closely as I could to what is already
> there in the code.  Let me know if you'd prefer anything written
> differently.
>=20
I merged a slightly modified version.
Please report about possible regressions.

Thanks,
cvaroqui

--=-6M712xpEclEyqR5Xl2Jw
Content-Disposition: attachment; filename=0011-alua-adjust-buffer-size.diff
Content-Type: text/x-patch; name=0011-alua-adjust-buffer-size.diff;
	charset=utf-8
Content-Transfer-Encoding: 7bit

diff --git a/path_priority/pp_alua/rtpg.c b/path_priority/pp_alua/rtpg.c
index 6922d9a..701f9d5 100644
--- a/path_priority/pp_alua/rtpg.c
+++ b/path_priority/pp_alua/rtpg.c
@@ -21,6 +21,7 @@ #include <sys/types.h>
 #include <sys/stat.h>
 #include <unistd.h>
 #include <errno.h>
+#include <inttypes.h>
 
 #define __user
 #include <scsi/sg.h>
@@ -251,14 +252,38 @@ do_rtpg(int fd, void* resp, long resplen
 int
 get_asymmetric_access_state(int fd, unsigned int tpg)
 {
-	unsigned char		buf[128];
+	unsigned char		*buf;
 	struct rtpg_data *	tpgd;
 	struct rtpg_tpg_dscr *	dscr;
 	int			rc;
-
-	rc = do_rtpg(fd, buf, sizeof(buf));
+	int			buflen;
+	uint32_t		scsi_buflen;
+
+	buflen = 128; /* Initial value from old code */
+	buf = (unsigned char *)malloc(buflen);
+	if (!buf) {
+		PRINT_DEBUG ("malloc failed: could not allocate"
+			"%u bytes\n", buflen);
+		return -RTPG_RTPG_FAILED;
+	}
+	rc = do_rtpg(fd, buf, buflen);
 	if (rc < 0)
 		return rc;
+	scsi_buflen = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
+	if (buflen < (scsi_buflen + 4)) {
+		free(buf);
+		buf = (unsigned char *)malloc(scsi_buflen);
+		if (!buf) {
+			PRINT_DEBUG ("malloc failed: could not allocate"
+				"%u bytes\n", scsi_buflen);
+			return -RTPG_RTPG_FAILED;
+		}
+		buflen = scsi_buflen;
+		rc = do_rtpg(fd, buf, buflen);
+		if (rc < 0)
+			goto out;
+	}
+		
 
 	tpgd = (struct rtpg_data *) buf;
 	rc   = -RTPG_TPG_NOT_FOUND;
@@ -274,7 +299,8 @@ get_asymmetric_access_state(int fd, unsi
 			}
 		}
 	}
-
+out:
+	free(buf);
 	return rc;
 }
 

--=-6M712xpEclEyqR5Xl2Jw
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--=-6M712xpEclEyqR5Xl2Jw--
