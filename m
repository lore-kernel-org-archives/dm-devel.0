Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F338C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 19:46:38 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-x8YgbojAPDGv-W4djBqRQA-1; Tue, 15 Feb 2022 14:46:31 -0500
X-MC-Unique: x8YgbojAPDGv-W4djBqRQA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B67814245;
	Tue, 15 Feb 2022 19:46:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12CC845D78;
	Tue, 15 Feb 2022 19:46:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ACB671809C88;
	Tue, 15 Feb 2022 19:46:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FJkALq002299 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 14:46:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 752EF202699A; Tue, 15 Feb 2022 19:46:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FAA22026E03
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 19:46:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5EDF3806707
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 19:46:07 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
	[148.163.158.5]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-280-b5BfTe-jONOGPb2Emys-jg-1; Tue, 15 Feb 2022 14:46:04 -0500
X-MC-Unique: b5BfTe-jONOGPb2Emys-jg-1
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21FJdNWo001975; Tue, 15 Feb 2022 19:46:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3e8gj2jys6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:03 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FJfbfA010724;
	Tue, 15 Feb 2022 19:46:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.98])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3e8gj2jyrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:02 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FJcdt5004811;
	Tue, 15 Feb 2022 19:46:01 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com
	(d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by ppma03ams.nl.ibm.com with ESMTP id 3e64ha2a8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Tue, 15 Feb 2022 19:46:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com
	[9.149.105.58])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 21FJjxYe33292616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Tue, 15 Feb 2022 19:45:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC6704C05A;
	Tue, 15 Feb 2022 19:45:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86EF24C050;
	Tue, 15 Feb 2022 19:45:58 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown
	[9.145.18.90]) by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue, 15 Feb 2022 19:45:58 +0000 (GMT)
From: Steffen Maier <maier@linux.ibm.com>
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 15 Feb 2022 20:45:46 +0100
Message-Id: <20220215194547.51156-2-maier@linux.ibm.com>
In-Reply-To: <20220215194547.51156-1-maier@linux.ibm.com>
References: <20220215194547.51156-1-maier@linux.ibm.com>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _W55i1r0zFu_GhI7qzA36sVq0E82kIgD
X-Proofpoint-ORIG-GUID: z2wIsyh8SCfQP67xh2c0MnXkYeeEE0XF
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-15_05,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	adultscore=0 impostorscore=0
	spamscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 lowpriorityscore=0
	bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
	phishscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2201110000 definitions=main-2202150113
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Steffen Maier <maier@linux.ibm.com>, Martin Wilck <martin.wilck@suse.com>
Subject: [dm-devel] [PATCH v3 1/2] libmultipath: support host adapter name
	lookup for s390x ccw bus
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are also (FCP) HBAs that appear on a bus different from PCI.

Complements v0.6.0 commit
01ab2a468ea2 ("libmultipath: Add additional path wildcards").

With that we can easily get the full FCP addressing triplet
(HBA, WWPN, LUN) from multipath tools without additional tools
and correlation:

$ multipathd -k'show paths format "%w|%i|%a|%r"'
uuid                             |hcil       |host adapter|target WWPN
36005076400820293e8000000000000a0|1:0:3:160  |0.0.5080    |0x500507680b25c449
36005076400820293e8000000000000a0|1:0:4:160  |0.0.5080    |0x500507680b25c448
36005076400820293e8000000000000a0|58:0:3:160 |0.0.50c0    |0x500507680b26c449
36005076400820293e8000000000000a0|58:0:4:160 |0.0.50c0    |0x500507680b26c448

                                              ^^^^^^^^
                                   instead of [undef]

Make helper function static and generalize it to also cover CCW bus
in addition to the already supported PCI bus. Had to move now static
helper in front of its only user.
While at it, use string functions that are safe against buffer overflows.

As a side effect this patch theoretically also enables group by
host adapter for s390x based on v0.6.0 commit a28e61e5cc9a
("Crafted ordering of child paths for round robin path selector").

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---

Notes:
    Changes since v2:
    - ensure we don't accidentally skip a potential ccw fcp device with an
      early continue due to driver_name being NULL (Martin):
      replace early continue by guarded string comparisons
    - turn while into for loop reducing calls of udev_device_get_parent() (Martin)
    - use string functions that are safe against buffer overflows (Martin)
    
    Changes since v1:
    - Make sysfs_get_host_pci_name() static and generalize for adapters
      on different bus types, in order to reduce code duplication (Ben).
      The ancestor walk is always the same based on kernel driver core
      with the only difference that PCI matches against driver name
      whereas CCW matches against subsystem name.
      Unfortunately, the diffstat increased because I had to move the
      new static sysfs_get_host_bus_id() in front of its only user
      sysfs_get_host_adapter_name() [or else a strange upfront prototype
      would have been necessary].

 libmultipath/discovery.c | 79 ++++++++++++++++++++--------------------
 libmultipath/discovery.h |  1 -
 2 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7d939ae08004..875c80429969 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -475,60 +475,33 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 	return 0;
 }
 
-int sysfs_get_host_adapter_name(const struct path *pp, char *adapter_name)
-{
-	int proto_id;
-
-	if (!pp || !adapter_name)
-		return 1;
-
-	proto_id = pp->sg_id.proto_id;
-
-	if (proto_id != SCSI_PROTOCOL_FCP &&
-	    proto_id != SCSI_PROTOCOL_SAS &&
-	    proto_id != SCSI_PROTOCOL_ISCSI &&
-	    proto_id != SCSI_PROTOCOL_SRP) {
-		return 1;
-	}
-	/* iscsi doesn't have adapter info in sysfs
-	 * get ip_address for grouping paths
-	 */
-	if (pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
-		return sysfs_get_iscsi_ip_address(pp, adapter_name);
-
-	/* fetch adapter pci name for other protocols
-	 */
-	return sysfs_get_host_pci_name(pp, adapter_name);
-}
-
-int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
+static int sysfs_get_host_bus_id(const struct path *pp, char *bus_id)
 {
 	struct udev_device *hostdev, *parent;
 	char host_name[HOST_NAME_LEN];
-	const char *driver_name, *value;
+	const char *driver_name, *subsystem_name, *value;
 
-	if (!pp || !pci_name)
+	if (!pp || !bus_id)
 		return 1;
 
-	sprintf(host_name, "host%d", pp->sg_id.host_no);
+	snprintf(host_name, sizeof(host_name), "host%d", pp->sg_id.host_no);
 	hostdev = udev_device_new_from_subsystem_sysname(udev,
 			"scsi_host", host_name);
 	if (!hostdev)
 		return 1;
 
-	parent = udev_device_get_parent(hostdev);
-	while (parent) {
+	for (parent = udev_device_get_parent(hostdev);
+	     parent;
+	     parent = udev_device_get_parent(parent)) {
 		driver_name = udev_device_get_driver(parent);
-		if (!driver_name) {
-			parent = udev_device_get_parent(parent);
-			continue;
-		}
-		if (!strcmp(driver_name, "pcieport"))
+		subsystem_name = udev_device_get_subsystem(parent);
+		if (driver_name && !strcmp(driver_name, "pcieport"))
+			break;
+		if (subsystem_name && !strcmp(subsystem_name, "ccw"))
 			break;
-		parent = udev_device_get_parent(parent);
 	}
 	if (parent) {
-		/* pci_device found
+		/* pci_device or ccw fcp device found
 		 */
 		value = udev_device_get_sysname(parent);
 
@@ -537,7 +510,7 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
 			return 1;
 		}
 
-		strncpy(pci_name, value, SLOT_NAME_SIZE);
+		strlcpy(bus_id, value, SLOT_NAME_SIZE);
 		udev_device_unref(hostdev);
 		return 0;
 	}
@@ -545,6 +518,32 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
 	return 1;
 }
 
+int sysfs_get_host_adapter_name(const struct path *pp, char *adapter_name)
+{
+	int proto_id;
+
+	if (!pp || !adapter_name)
+		return 1;
+
+	proto_id = pp->sg_id.proto_id;
+
+	if (proto_id != SCSI_PROTOCOL_FCP &&
+	    proto_id != SCSI_PROTOCOL_SAS &&
+	    proto_id != SCSI_PROTOCOL_ISCSI &&
+	    proto_id != SCSI_PROTOCOL_SRP) {
+		return 1;
+	}
+	/* iscsi doesn't have adapter info in sysfs
+	 * get ip_address for grouping paths
+	 */
+	if (pp->sg_id.proto_id == SCSI_PROTOCOL_ISCSI)
+		return sysfs_get_iscsi_ip_address(pp, adapter_name);
+
+	/* fetch adapter bus-ID for other protocols
+	 */
+	return sysfs_get_host_bus_id(pp, adapter_name);
+}
+
 int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address)
 {
 	struct udev_device *hostdev;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 095657bb9de4..466af34504de 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -44,7 +44,6 @@ int store_pathinfo (vector pathvec, struct config *conf,
 		    struct path **pp_ptr);
 int sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint);
 int sysfs_get_timeout(const struct path *pp, unsigned int *timeout);
-int sysfs_get_host_pci_name(const struct path *pp, char *pci_name);
 int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address);
 int sysfs_get_host_adapter_name(const struct path *pp,
 				char *adapter_name);
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

