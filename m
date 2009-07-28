From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [PATCH]multipath-tools: no_path_retry for time based
 queuing is queuing I/O for ever
Date: Tue, 28 Jul 2009 18:21:13 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C141A357072@inbmail01.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Even though no_path_retry is set for time based queuing(i.e no_path_retry=
 <N>), I/O is getting queued for ever. During all path failure condition,=
 setup_feature() resets no_path_retry of multipath structure to NO_PATH_R=
ETRY_QUEUE which queues I/O for ever. This patch skips resetting no_path_=
retry until no_path_retry is set with queue.

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>

---
diff -uprN multipath-tools-orig/libmultipath/dmparser.c multipath-tools/l=
ibmultipath/dmparser.c
--- multipath-tools-orig/libmultipath/dmparser.c	2009-07-28 10:06:46.0000=
00000 +0530
+++ multipath-tools/libmultipath/dmparser.c	2009-07-28 10:18:38.000000000=
 +0530
@@ -145,7 +145,10 @@ disassemble_map (vector pathvec, char *=20
 			FREE(word);
 			return 1;
 		}
-		setup_feature(mpp, word);
+		if ((mpp->no_path_retry =3D=3D NO_PATH_RETRY_UNDEF) ||
+			(mpp->no_path_retry =3D=3D NO_PATH_RETRY_FAIL) ||
+			(mpp->no_path_retry =3D=3D NO_PATH_RETRY_QUEUE))
+			setup_feature(mpp, word);
=20
 		FREE(word);
 	}

--
