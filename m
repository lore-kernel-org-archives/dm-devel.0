Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD44C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 18:56:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-RK9p1XQmOH-5g5e4YLpnRw-1; Mon, 14 Feb 2022 13:56:43 -0500
X-MC-Unique: RK9p1XQmOH-5g5e4YLpnRw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A41F2801B0C;
	Mon, 14 Feb 2022 18:56:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7695010AD784;
	Mon, 14 Feb 2022 18:56:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8AB671809CB8;
	Mon, 14 Feb 2022 18:56:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21EIuZIA007352 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 13:56:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F0DE40E80EC; Mon, 14 Feb 2022 18:56:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0AE1540E80E8
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 18:56:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FF8A3C0012B
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 18:56:34 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-41-cCDslImHMMC_BzKAUPoMZQ-1; Mon, 14 Feb 2022 13:56:30 -0500
X-MC-Unique: cCDslImHMMC_BzKAUPoMZQ-1
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	21EIJaE8031543; Mon, 14 Feb 2022 18:56:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e6rt1duxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:29 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21EHbgl0010070;
	Mon, 14 Feb 2022 18:56:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com
	[169.51.49.99])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e6rt1dux3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
	by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EIrt7Z030201;
	Mon, 14 Feb 2022 18:56:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com
	(d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
	by ppma04ams.nl.ibm.com with ESMTP id 3e64h9rb5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Mon, 14 Feb 2022 18:56:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com
	[9.149.105.61])
	by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 21EIuOQ241025856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Mon, 14 Feb 2022 18:56:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2750411C054;
	Mon, 14 Feb 2022 18:56:24 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4C5711C052;
	Mon, 14 Feb 2022 18:56:23 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown
	[9.145.68.17]) by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Mon, 14 Feb 2022 18:56:23 +0000 (GMT)
From: Steffen Maier <maier@linux.ibm.com>
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 14 Feb 2022 19:55:58 +0100
Message-Id: <20220214185559.28363-2-maier@linux.ibm.com>
In-Reply-To: <20220214185559.28363-1-maier@linux.ibm.com>
References: <20220214185559.28363-1-maier@linux.ibm.com>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9HNMwkLImOFZGx_13NxhxeJ_KGkiuxi5
X-Proofpoint-ORIG-GUID: Q8ZqIzQNJQGYKrY_V_71-jqSUKgpMq-P
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	mlxlogscore=999
	impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
	clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0 spamscore=0
	bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
	scancount=1
	engine=8.12.0-2201110000 definitions=main-2202140109
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Steffen Maier <maier@linux.ibm.com>, Martin Wilck <martin.wilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/2] libmultipath: support host adapter name
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

As a side effect this patch theoretically also enables group by
host adapter for s390x based on v0.6.0 commit a28e61e5cc9a
("Crafted ordering of child paths for round robin path selector").

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---

Notes:
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

 libmultipath/discovery.c | 69 ++++++++++++++++++++++------------------
 libmultipath/discovery.h |  1 -
 2 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7d939ae08004..5aba7e8d495f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -475,39 +475,13 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
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
 
 	sprintf(host_name, "host%d", pp->sg_id.host_no);
@@ -525,10 +499,17 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
 		}
 		if (!strcmp(driver_name, "pcieport"))
 			break;
+		subsystem_name = udev_device_get_subsystem(parent);
+		if (!subsystem_name) {
+			parent = udev_device_get_parent(parent);
+			continue;
+		}
+		if (!strcmp(subsystem_name, "ccw"))
+			break;
 		parent = udev_device_get_parent(parent);
 	}
 	if (parent) {
-		/* pci_device found
+		/* pci_device or ccw fcp device found
 		 */
 		value = udev_device_get_sysname(parent);
 
@@ -537,7 +518,7 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
 			return 1;
 		}
 
-		strncpy(pci_name, value, SLOT_NAME_SIZE);
+		strncpy(bus_id, value, SLOT_NAME_SIZE);
 		udev_device_unref(hostdev);
 		return 0;
 	}
@@ -545,6 +526,32 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
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

