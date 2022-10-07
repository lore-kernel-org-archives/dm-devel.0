Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33725C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  7 Oct 2022 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665164158;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=y+5tRMhIgrKHKuxqRkZeG/bXNCs14j4Pqf+Xma5fKos=;
	b=PShuOmYwt7j2ViRyWZtiA7EorX1DXFNyKQtXs+zRIxwmSF2dMXR7CufiXZnJYsyx3Ww8aC
	ML3XXmumGlCOUnVwMXVq4Nh+U8A9Obbjfz+hlZvGyX4ib0vFNPCxbnnuYQwQlozf34msxO
	PJvOe1SUeFFgmW6r52HDux3aDuiUxDk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-MepI2OvTNLa8_O2huNcUlw-1; Fri, 07 Oct 2022 13:35:57 -0400
X-MC-Unique: MepI2OvTNLa8_O2huNcUlw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C23A855306;
	Fri,  7 Oct 2022 17:35:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A143145BEE3;
	Fri,  7 Oct 2022 17:35:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0BC981946A49;
	Fri,  7 Oct 2022 17:35:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E53D1946A66
 for <dm-devel@listman.corp.redhat.com>; Fri,  7 Oct 2022 17:35:54 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 11C90145BEE9; Fri,  7 Oct 2022 17:35:54 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5A5E145BEE6;
 Fri,  7 Oct 2022 17:35:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 297HZq5Y006786;
 Fri, 7 Oct 2022 12:35:52 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 297HZqDf006783;
 Fri, 7 Oct 2022 12:35:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri,  7 Oct 2022 12:35:43 -0500
Message-Id: <1665164144-6716-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 7/8] libmultipath: get nvme path transport
 protocol
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Read the transport protocol from /sys/block/nvmeXnY/device/transport.
Update protocol_name[] and bus_protocol_id() to store the nvme protocol
names after the scsi protocol names.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c   | 18 ++++++++++++++++--
 libmultipath/structs.c     | 22 +++++++++++++++++-----
 libmultipath/structs.h     | 33 +++++++++++++++++++++------------
 multipath/multipath.conf.5 |  8 ++++++--
 4 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e937f090..f3fccedd 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1539,6 +1539,7 @@ nvme_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 	struct udev_device *parent;
 	const char *attr_path = NULL;
 	const char *attr;
+	int i;
 
 	if (pp->udev)
 		attr_path = udev_device_get_sysname(pp->udev);
@@ -1561,6 +1562,18 @@ nvme_sysfs_pathinfo (struct path *pp, const struct _vector *hwtable)
 	attr = udev_device_get_sysattr_value(parent, "cntlid");
 	pp->sg_id.channel = attr ? atoi(attr) : 0;
 
+	attr = udev_device_get_sysattr_value(parent, "transport");
+	if (attr) {
+		for (i = 0; i < NVME_PROTOCOL_UNSPEC; i++){
+			if (protocol_name[SYSFS_BUS_NVME + i] &&
+			    !strcmp(attr,
+				    protocol_name[SYSFS_BUS_NVME + i] + 5)) {
+				pp->sg_id.proto_id = i;
+				break;
+			}
+		}
+	}
+
 	snprintf(pp->vendor_id, SCSI_VENDOR_SIZE, "NVME");
 	snprintf(pp->product_id, PATH_PRODUCT_SIZE, "%s",
 		 udev_device_get_sysattr_value(parent, "model"));
@@ -1815,9 +1828,10 @@ sysfs_pathinfo(struct path *pp, const struct _vector *hwtable)
 		pp->bus = SYSFS_BUS_SCSI;
 		pp->sg_id.proto_id = SCSI_PROTOCOL_UNSPEC;
 	}
-	if (!strncmp(pp->dev,"nvme", 4))
+	if (!strncmp(pp->dev,"nvme", 4)) {
 		pp->bus = SYSFS_BUS_NVME;
-
+		pp->sg_id.proto_id = NVME_PROTOCOL_UNSPEC;
+	}
 	switch (pp->bus) {
 	case SYSFS_BUS_SCSI:
 		return scsi_sysfs_pathinfo(pp, hwtable);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index fb44cd64..7a2ff589 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -25,7 +25,6 @@ const char * const protocol_name[LAST_BUS_PROTOCOL_ID + 1] = {
 	[SYSFS_BUS_UNDEF] = "undef",
 	[SYSFS_BUS_CCW] = "ccw",
 	[SYSFS_BUS_CCISS] = "cciss",
-	[SYSFS_BUS_NVME] = "nvme",
 	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_FCP] = "scsi:fcp",
 	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SPI] = "scsi:spi",
 	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_SSA] = "scsi:ssa",
@@ -37,6 +36,13 @@ const char * const protocol_name[LAST_BUS_PROTOCOL_ID + 1] = {
 	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_ATA] = "scsi:ata",
 	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_USB] = "scsi:usb",
 	[SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC] = "scsi:unspec",
+	[SYSFS_BUS_NVME + NVME_PROTOCOL_PCIE] = "nvme:pcie",
+	[SYSFS_BUS_NVME + NVME_PROTOCOL_RDMA] = "nvme:rdma",
+	[SYSFS_BUS_NVME + NVME_PROTOCOL_FC] = "nvme:fc",
+	[SYSFS_BUS_NVME + NVME_PROTOCOL_TCP] = "nvme:tcp",
+	[SYSFS_BUS_NVME + NVME_PROTOCOL_LOOP] = "nvme:loop",
+	[SYSFS_BUS_NVME + NVME_PROTOCOL_APPLE_NVME] = "nvme:apple-nvme",
+	[SYSFS_BUS_NVME + NVME_PROTOCOL_UNSPEC] = "nvme:unspec",
 };
 
 struct adapter_group *
@@ -746,11 +752,17 @@ out:
 }
 
 unsigned int bus_protocol_id(const struct path *pp) {
-	if (!pp || pp->bus < 0 || pp->bus > SYSFS_BUS_SCSI)
+	if (!pp || pp->bus < 0 || pp->bus > SYSFS_BUS_NVME)
 		return SYSFS_BUS_UNDEF;
-	if (pp->bus != SYSFS_BUS_SCSI)
+	if (pp->bus != SYSFS_BUS_SCSI && pp->bus != SYSFS_BUS_NVME)
 		return pp->bus;
-	if ((int)pp->sg_id.proto_id < 0 || pp->sg_id.proto_id > SCSI_PROTOCOL_UNSPEC)
+	if (pp->sg_id.proto_id < 0)
 		return SYSFS_BUS_UNDEF;
-	return SYSFS_BUS_SCSI + pp->sg_id.proto_id;
+	if (pp->bus == SYSFS_BUS_SCSI &&
+	    pp->sg_id.proto_id > SCSI_PROTOCOL_UNSPEC)
+		return SYSFS_BUS_UNDEF;
+	if (pp->bus == SYSFS_BUS_NVME &&
+	    pp->sg_id.proto_id > NVME_PROTOCOL_UNSPEC)
+		return SYSFS_BUS_UNDEF;
+	return pp->bus + pp->sg_id.proto_id;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d3054662..9e2c1ab0 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -56,15 +56,6 @@ enum failback_mode {
 	FAILBACK_FOLLOWOVER
 };
 
-/* SYSFS_BUS_SCSI should be last, see bus_protocol_id() */
-enum sysfs_buses {
-	SYSFS_BUS_UNDEF,
-	SYSFS_BUS_CCW,
-	SYSFS_BUS_CCISS,
-	SYSFS_BUS_NVME,
-	SYSFS_BUS_SCSI,
-};
-
 enum pathstates {
 	PSTATE_UNDEF,
 	PSTATE_FAILED,
@@ -190,14 +181,32 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_ATA = 8,
 	SCSI_PROTOCOL_USB = 9,  /* USB Attached SCSI (UAS), and others */
 	SCSI_PROTOCOL_UNSPEC = 0xa, /* No specific protocol */
+	SCSI_PROTOCOL_END = 0xb, /* offset of the next sysfs_buses entry */
+};
+
+/* values from /sys/class/nvme/nvmeX */
+enum nvme_protocol {
+	NVME_PROTOCOL_PCIE = 0,
+	NVME_PROTOCOL_RDMA = 1,
+	NVME_PROTOCOL_FC = 2,
+	NVME_PROTOCOL_TCP = 3,
+	NVME_PROTOCOL_LOOP = 4,
+	NVME_PROTOCOL_APPLE_NVME = 5,
+	NVME_PROTOCOL_UNSPEC = 6, /* unknown protocol */
+};
+
+enum sysfs_buses {
+	SYSFS_BUS_UNDEF,
+	SYSFS_BUS_CCW,
+	SYSFS_BUS_CCISS,
+	SYSFS_BUS_SCSI,
+	SYSFS_BUS_NVME = SYSFS_BUS_SCSI + SCSI_PROTOCOL_END,
 };
 
 /*
  * Linear ordering of bus/protocol
- * This assumes that SYSFS_BUS_SCSI is last in enum sysfs_buses
- * SCSI is the only bus type for which we distinguish protocols.
  */
-#define LAST_BUS_PROTOCOL_ID (SYSFS_BUS_SCSI + SCSI_PROTOCOL_UNSPEC)
+#define LAST_BUS_PROTOCOL_ID (SYSFS_BUS_NVME + NVME_PROTOCOL_UNSPEC)
 unsigned int bus_protocol_id(const struct path *pp);
 extern const char * const protocol_name[];
 
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 46a4126c..07476497 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1377,7 +1377,9 @@ Regular expression for the protocol of a device to be excluded/included.
 The protocol strings that multipath recognizes are \fIscsi:fcp\fR,
 \fIscsi:spi\fR, \fIscsi:ssa\fR, \fIscsi:sbp\fR, \fIscsi:srp\fR,
 \fIscsi:iscsi\fR, \fIscsi:sas\fR, \fIscsi:adt\fR, \fIscsi:ata\fR,
-\fIscsi:unspec\fR, \fIccw\fR, \fIcciss\fR, \fInvme\fR, and \fIundef\fR.
+\fIscsi:unspec\fR, \fInvme:pcie\fR, \fInvme:rdma\fR, \fInvme:fc\fR,
+\fInvme:tcp\fR, \fInvme:loop\fR, \fInvme:apple-nvme\fR, \fInvme:unspec\fR,
+\fIccw\fR, \fIcciss\fR, and \fIundef\fR.
 The protocol that a path is using can be viewed by running
 \fBmultipathd show paths format "%d %P"\fR
 .RE
@@ -1773,7 +1775,9 @@ The protocol subsection recognizes the following mandatory attribute:
 The protocol string of the path device. The possible values are \fIscsi:fcp\fR,
 \fIscsi:spi\fR, \fIscsi:ssa\fR, \fIscsi:sbp\fR, \fIscsi:srp\fR,
 \fIscsi:iscsi\fR, \fIscsi:sas\fR, \fIscsi:adt\fR, \fIscsi:ata\fR,
-\fIscsi:unspec\fR, \fIccw\fR, \fIcciss\fR, \fInvme\fR, and \fIundef\fR. This is
+\fIscsi:unspec\fR, \fInvme:pcie\fR, \fInvme:rdma\fR, \fInvme:fc\fR,
+\fInvme:tcp\fR, \fInvme:loop\fR, \fInvme:apple-nvme\fR, \fInvme:unspec\fR,
+\fIccw\fR, \fIcciss\fR, and \fIundef\fR. This is
 \fBnot\fR a regular expression. the path device protocol string must match
 exactly. The protocol that a path is using can be viewed by running
 \fBmultipathd show paths format "%d %P"\fR
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

