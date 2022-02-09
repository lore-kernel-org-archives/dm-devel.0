Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE2E5C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 08:18:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-86sl-pfAP-64hRdn6BcT8A-1; Thu, 10 Feb 2022 03:18:49 -0500
X-MC-Unique: 86sl-pfAP-64hRdn6BcT8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B8B7835BDD;
	Thu, 10 Feb 2022 08:18:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFBB273160;
	Thu, 10 Feb 2022 08:18:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C37D34A7CB;
	Thu, 10 Feb 2022 08:18:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 219JlV9r002524 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 14:47:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 23B13492D1F; Wed,  9 Feb 2022 19:47:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F0A7492D1C
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 19:47:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05B7B800B31
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 19:47:31 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
	[148.163.156.1]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-637-JRE1uqKCOh6bEZv3jR3gYg-1; Wed, 09 Feb 2022 14:47:29 -0500
X-MC-Unique: JRE1uqKCOh6bEZv3jR3gYg-1
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id
	219IMeQa024907; Wed, 9 Feb 2022 19:47:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e4fffppnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 09 Feb 2022 19:47:27 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
	by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219JkjKi026693;
	Wed, 9 Feb 2022 19:47:27 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com
	[159.122.73.72])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3e4fffppn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 09 Feb 2022 19:47:27 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
	by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219JhTRi017861;
	Wed, 9 Feb 2022 19:47:24 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com
	(d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by ppma06fra.de.ibm.com with ESMTP id 3e1ggjg937-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NOT); Wed, 09 Feb 2022 19:47:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com
	[9.149.105.60])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with
	ESMTP id 219JlMr844040540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK); Wed, 9 Feb 2022 19:47:22 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 139EC4203F;
	Wed,  9 Feb 2022 19:47:22 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E9DD4204F;
	Wed,  9 Feb 2022 19:47:21 +0000 (GMT)
Received: from li-c43276cc-23ad-11b2-a85c-bda00957cb67.ibm.com.com (unknown
	[9.145.91.188])
	by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Wed,  9 Feb 2022 19:47:21 +0000 (GMT)
From: Steffen Maier <maier@linux.ibm.com>
To: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  9 Feb 2022 20:47:12 +0100
Message-Id: <20220209194713.56556-2-maier@linux.ibm.com>
In-Reply-To: <20220209194713.56556-1-maier@linux.ibm.com>
References: <20220209194713.56556-1-maier@linux.ibm.com>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4bPlGhXxtSH91CaFfILs-In-l5zdEsQ9
X-Proofpoint-GUID: 8p-QTggOwzgtrHHXzYAkTxCtSEgbxOFS
X-Proofpoint-Virus-Version: vendor=baseguard
	engine=ICAP:2.0.205, Aquarius:18.0.816, Hydra:6.0.425,
	FMLib:17.11.62.513
	definitions=2022-02-09_10,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
	clxscore=1015 mlxscore=0
	spamscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
	malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0
	impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
	scancount=1 engine=8.12.0-2201110000 definitions=main-2202090103
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Feb 2022 03:18:24 -0500
Cc: Steffen Maier <maier@linux.ibm.com>,
	ShivaKrishna Merla <shivakrishna.merla@netapp.com>,
	Martin Wilck <martin.wilck@suse.com>
Subject: [dm-devel] [PATCH 1/2] libmultipath: support host adapter name
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 libmultipath/discovery.c | 41 +++++++++++++++++++++++++++++++++++++++-
 libmultipath/discovery.h |  1 +
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7d939ae08004..bb4913d9b75f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -497,8 +497,12 @@ int sysfs_get_host_adapter_name(const struct path *pp, char *adapter_name)
 		return sysfs_get_iscsi_ip_address(pp, adapter_name);
 
 	/* fetch adapter pci name for other protocols
+	 * or try to get s390x channel subsystem FCP device bus-ID [zfcp]
 	 */
-	return sysfs_get_host_pci_name(pp, adapter_name);
+	if (sysfs_get_host_pci_name(pp, adapter_name))
+		return sysfs_get_host_ccw_name(pp, adapter_name);
+	else
+		return 0;
 }
 
 int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
@@ -545,6 +549,41 @@ int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
 	return 1;
 }
 
+int sysfs_get_host_ccw_name(const struct path *pp, char *ccw_name)
+{
+	struct udev_device *hostdev, *parent;
+	char host_name[HOST_NAME_LEN];
+	const char *value;
+
+	if (!pp || !ccw_name)
+		return 1;
+
+	sprintf(host_name, "host%d", pp->sg_id.host_no);
+	hostdev = udev_device_new_from_subsystem_sysname(udev,
+			"scsi_host", host_name);
+	if (!hostdev)
+		return 1;
+
+	parent = udev_device_get_parent_with_subsystem_devtype(hostdev, "ccw",
+							       NULL);
+	if (parent) {
+		/* s390x ccw FCP device found
+		 */
+		value = udev_device_get_sysname(parent);
+
+		if (!value) {
+			udev_device_unref(hostdev);
+			return 1;
+		}
+
+		strncpy(ccw_name, value, SLOT_NAME_SIZE);
+		udev_device_unref(hostdev);
+		return 0;
+	}
+	udev_device_unref(hostdev);
+	return 1;
+}
+
 int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address)
 {
 	struct udev_device *hostdev;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 095657bb9de4..0a58c725d700 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -44,6 +44,7 @@ int store_pathinfo (vector pathvec, struct config *conf,
 		    struct path **pp_ptr);
 int sysfs_set_scsi_tmo (struct multipath *mpp, unsigned int checkint);
 int sysfs_get_timeout(const struct path *pp, unsigned int *timeout);
+int sysfs_get_host_ccw_name(const struct path *pp, char *ccw_name);
 int sysfs_get_host_pci_name(const struct path *pp, char *pci_name);
 int sysfs_get_iscsi_ip_address(const struct path *pp, char *ip_address);
 int sysfs_get_host_adapter_name(const struct path *pp,

base-commit: d9d7ae9e2125116b465b4ff4d98ce65fe0eac3cc
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

