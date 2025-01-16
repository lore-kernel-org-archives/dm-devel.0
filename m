Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB6D236A8E
	for <dm-devel@lists.linux.dev>; Thu, 16 Jan 2025 20:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737058964; cv=none; b=Tu2LjtmwK7gI2zkqPs8M0BuF4BYlm3qL7DNK9OgnMc0DhY/wf3KMj2CpyMdcr9CaE2LsTz/3A5KM7DTIhShQPV+upqZxsHejW0Y0c69cyZfFS8IqtH6XTAkBpkHf3JdmIKzky1XqxkxL7xuUvdn5YNRn4n0S7fxz4MKMFS+MRQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737058964; c=relaxed/simple;
	bh=bXpV4DDJemo/uGX7spVRSC7L5g7Pbfux47j17YF0lxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ek9nglW44kHtL9UxbFKojM32cuPIVDcxnJ0tFzUnUM04pWPyWXmh3+Z2StLS4ztD+Pwq9oNCPOxzVH2QSpt2FX7+Y/JVVrd0fqubkstgjN+w9AB5q3hPJlu+N5Jbf110we3fU/ZKkUFbL97VTij7wEQL5k0qX/XMSYEH9hIrJ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=biL1JLGO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="biL1JLGO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737058961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DsLnyMq85fJ3DrWMgpBIMFONCf4dgpmLeucyHwtM80M=;
	b=biL1JLGOhxPWPLivSTYRSPp5ewt1SepJn8rnB0hrjfLFKANavSqx7NNLZ8wlSyOVFinpfw
	qmTQm8JgqWHGoT2GJe6+0EAXbhdiRwaCVTPGL1NvGfLWRGu0vF4cSsPfKtWOCuMwkbcz6a
	mDhy+so85QgE/CoKxbCj4SaWVDg+lak=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-y9mtByBkPPywBqloQpGmIA-1; Thu,
 16 Jan 2025 15:22:38 -0500
X-MC-Unique: y9mtByBkPPywBqloQpGmIA-1
X-Mimecast-MFC-AGG-ID: y9mtByBkPPywBqloQpGmIA
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 366F61955DDD;
	Thu, 16 Jan 2025 20:22:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD70219560AD;
	Thu, 16 Jan 2025 20:22:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 50GKMZ4f2753979
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 15:22:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 50GKMZSG2753978;
	Thu, 16 Jan 2025 15:22:35 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 2/2] multipathd: set rport port_state to marginal for NVMe devices
Date: Thu, 16 Jan 2025 15:22:34 -0500
Message-ID: <20250116202234.2753960-3-bmarzins@redhat.com>
In-Reply-To: <20250116202234.2753960-1-bmarzins@redhat.com>
References: <20250116202234.2753960-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -VdPc7XJp2-_tKA3IvA59MBKaU4zBuCkjNuGN8oPdMw_1737058957
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When a scsi path device is set to marginal, it updates the rport state.
Do this for NVMe devices as well. Unlike with scsi devices, setting the
rport state to marginal will not directly change the nvme driver
behavior. However it will allow users to see the rports associated with
their Marginal paths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/fpin_handlers.c | 79 +++++++++++++++++++++++++++++++++++---
 1 file changed, 73 insertions(+), 6 deletions(-)

diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index 6b56f9b7..2920469d 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -15,6 +15,7 @@
 #include "debug.h"
 #include "util.h"
 #include "sysfs.h"
+#include "discovery.h"
 
 #include "fpin.h"
 #include "devmapper.h"
@@ -253,7 +254,7 @@ static int  extract_nvme_addresses_chk_path_pwwn(const char *address,
  * with the els wwpn ,attached_wwpn and sets the path state to
  * Marginal
  */
-static void fpin_check_set_nvme_path_marginal(uint16_t host_num, struct path *pp,
+static bool fpin_check_set_nvme_path_marginal(uint16_t host_num, struct path *pp,
 		uint64_t els_wwpn, uint64_t attached_wwpn)
 {
 	struct udev_device *ctl = NULL;
@@ -263,21 +264,84 @@ static void fpin_check_set_nvme_path_marginal(uint16_t host_num, struct path *pp
 	ctl = udev_device_get_parent_with_subsystem_devtype(pp->udev, "nvme", NULL);
 	if (ctl == NULL) {
 		condlog(2, "%s: No parent device for ", pp->dev);
-		return;
+		return false;
 	}
 	address = udev_device_get_sysattr_value(ctl, "address");
 	if (!address) {
 		condlog(2, "%s: unable to get the address ", pp->dev);
-		return;
+		return false;
 	}
 	condlog(4, "\n address %s: dev :%s\n", address, pp->dev);
 	ret = extract_nvme_addresses_chk_path_pwwn(address, els_wwpn, attached_wwpn);
 	if (ret <= 0)
-		return;
+		return false;
 	ret = fpin_add_marginal_dev_info(host_num, pp->dev);
 	if (ret < 0)
-		return;
+		return false;
 	fpin_path_setmarginal(pp);
+	return true;
+}
+
+static void fpin_nvme_set_rport_marginal(uint16_t host_num, uint64_t els_wwpn)
+{
+	struct udev_enumerate *udev_enum = NULL;
+	struct udev_list_entry *entry;
+
+	pthread_cleanup_push(cleanup_udev_enumerate_ptr, &udev_enum);
+	udev_enum = udev_enumerate_new(udev);
+	if (!udev_enum) {
+		condlog(0, "fpin: rport udev_enumerate_new() failed: %m");
+		goto out;
+	}
+	if (udev_enumerate_add_match_subsystem(udev_enum, "fc_remote_ports") < 0 ||
+	    udev_enumerate_add_match_is_initialized(udev_enum) < 0 ||
+	    udev_enumerate_scan_devices(udev_enum) < 0) {
+		condlog(0, "fpin: error setting up rport enumeration: %m");
+		goto out;
+	}
+	udev_list_entry_foreach(entry,
+				udev_enumerate_get_list_entry(udev_enum)) {
+		const char *devpath;
+		const char *rport_id, *value;
+		struct udev_device *rport_dev = NULL;
+		uint16_t rport_hostnum;
+		uint64_t rport_wwpn;
+		unsigned int unused;
+		bool found = false;
+
+		pthread_cleanup_push(cleanup_udev_device_ptr, &rport_dev);
+		devpath = udev_list_entry_get_name(entry);
+		if (!devpath)
+			goto next;
+		rport_id = libmp_basename(devpath);
+		if (sscanf(rport_id, "rport-%hu:%u-%u", &rport_hostnum, &unused,
+			   &unused) != 3 || rport_hostnum != host_num)
+			goto next;
+
+		rport_dev = udev_device_new_from_syspath(udev, devpath);
+		if (!rport_dev) {
+			condlog(0, "%s: error getting rport dev: %m", rport_id);
+			goto next;
+		}
+		value = udev_device_get_sysattr_value(rport_dev, "port_name");
+		if (!value) {
+			condlog(0, "%s: error getting port_name: %m", rport_id);
+			goto next;
+		}
+
+		rport_wwpn = strtol(value, NULL, 16);
+		/* If the rport wwpn matches, set the port state to marginal */
+		if (rport_wwpn == els_wwpn) {
+			found = true;
+			fpin_set_rport_marginal(rport_dev);
+		}
+next:
+		pthread_cleanup_pop(1);
+		if (found)
+			break;
+	}
+out:
+	pthread_cleanup_pop(1);
 }
 
 /*
@@ -338,6 +402,7 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *ve
 	struct multipath *mpp;
 	int i, k;
 	int ret = 0;
+	bool found_nvme = false;
 
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(&vecs->lock);
@@ -348,7 +413,7 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *ve
 			continue;
 		/*checks if the bus type is nvme  and the protocol is FC-NVMe*/
 		if ((pp->bus == SYSFS_BUS_NVME) && (pp->sg_id.proto_id == NVME_PROTOCOL_FC)) {
-			fpin_check_set_nvme_path_marginal(host_num, pp, els_wwpn, attached_wwpn);
+			found_nvme = fpin_check_set_nvme_path_marginal(host_num, pp, els_wwpn, attached_wwpn) || found_nvme;
 		} else if ((pp->bus == SYSFS_BUS_SCSI) &&
 			(pp->sg_id.proto_id == SCSI_PROTOCOL_FCP) &&
 			(host_num ==  pp->sg_id.host_no)) {
@@ -356,6 +421,8 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *ve
 			fpin_check_set_scsi_path_marginal(host_num, pp, els_wwpn);
 		}
 	}
+	if (found_nvme)
+		fpin_nvme_set_rport_marginal(host_num, els_wwpn);
 	/* walk backwards because reload_and_sync_map() can remove mpp */
 	vector_foreach_slot_backwards(vecs->mpvec, mpp, i) {
 		if (mpp->fpin_must_reload) {
-- 
2.46.2

