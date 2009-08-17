From: <Yanqing_Liu@Dell.com>
Subject: [PATCH] add support for next generation of Dell PV array
Date: Mon, 17 Aug 2009 13:07:44 -0500
Message-ID: <D00AA2C108EC0346B503219C7565A66F9E28E9@ausx3mpc138.aus.amer.dell.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

This patch is to add DM support for next generation of Dell PowerVault
storage array.


Signed-off-by: Yanqing Liu <Yanqing_Liu@Dell.com>

--- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig
2009-08-05 16:30:51.000000000 -0500
+++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c
2009-08-05 16:34:00.000000000 -0500
@@ -631,6 +631,8 @@ static const struct scsi_dh_devlist rdac
 	{"SUN", "LCSM100_F"},
 	{"DELL", "MD3000"},
 	{"DELL", "MD3000i"},
+	{"DELL", "MD32xx"},
+	{"DELL", "MD32xxi"},
 	{"LSI", "INF-01-00"},
 	{"ENGENIO", "INF-01-00"},
 	{NULL, NULL},

Thanks,
Yanqing
