Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C182F12E7F
	for <dm-devel@lists.linux.dev>; Fri, 20 Dec 2024 02:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734660190; cv=none; b=Jt6YbI+jK0fpInPGyshmtq+MHmTqPOiHHImOCYE1zhNwHoxIw5SHO97goUt9X8JX3E1CZmsfb1Gao/ZWeUY5BAufTNuU+x3twBoYsjj1zQ/Eobs64mZ2MUH49pYDyCmW+hEP/Rg18FqUJ8kzGhUB32tUAs8l8cKFZFpNxNdC6AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734660190; c=relaxed/simple;
	bh=zdgGJi4bYxWl/H2deOKkDhHJURN5y/GERyK+MtMWIKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=hWhqmJBOG77u1++sXsjW6aa5BNV/d1XTKsQkUtjnhPT52rFbkX3pWVw44Qf2FTXksS50TEdBzGXHjunJSCsUvS5h6ujlJwO1ZUVaHCU56kqQDuy7iKYDbvQgEdNsgO0Q9WN6SmvX61/OGYnmeTO/g2nnqng5RVxIVzrYJh5IXEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GrCWO7Ta; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GrCWO7Ta"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734660185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqHuOTt/dQ39xw5Tsc+Q/VFqijN41z6c/j0k8lTj2iU=;
	b=GrCWO7TaeRT8NEVq8S29gMjSsJbPSemIeRim8YbXr6PM0V9djzwiPqv339nlKdLnjPtG/8
	KF5iEn6U1MhmRMt+Qosdx/4gDxHj3EDW+vF55W6tYV3lCEEDLWzBbYy+MqHJTeoF2WkN2v
	E2CR1RBQDh0f3gry1CnuPqV/8Od4N5s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-383-ro26HCOgMzGZthMkT31XSQ-1; Thu,
 19 Dec 2024 21:03:00 -0500
X-MC-Unique: ro26HCOgMzGZthMkT31XSQ-1
X-Mimecast-MFC-AGG-ID: ro26HCOgMzGZthMkT31XSQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4172D1955BED;
	Fri, 20 Dec 2024 02:02:38 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E40A219560AD;
	Fri, 20 Dec 2024 02:02:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 4BK22aFl1759394
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 19 Dec 2024 21:02:36 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 4BK22aQp1759393;
	Thu, 19 Dec 2024 21:02:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Muneendra Kumar <muneendra.kumar@broadcom.com>
Subject: [PATCH 2/2] multipathd: set rport port_state to marginal for NVMe devices
Date: Thu, 19 Dec 2024 21:02:35 -0500
Message-ID: <20241220020235.1759375-3-bmarzins@redhat.com>
In-Reply-To: <20241220020235.1759375-1-bmarzins@redhat.com>
References: <20241220020235.1759375-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: o4QcXUSI4YmLX7352wsef5MmtwYyA8i3OM7GVkCY3ks_1734660179
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

When a scsi path device is set to marginal, it updates the rport state.
Do this for NVMe devices as well.

Fixes: 1cada778 ("multipathd: Added support to handle FPIN-Li events for FC-NVMe")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/fpin_handlers.c | 74 ++++++++++++++++++++++++++++++++++----
 1 file changed, 68 insertions(+), 6 deletions(-)

diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index 6b56f9b7..8b436067 100644
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
@@ -263,21 +264,79 @@ static void fpin_check_set_nvme_path_marginal(uint16_t host_num, struct path *pp
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
+		if (rport_wwpn == els_wwpn)
+			fpin_set_rport_marginal(rport_dev);
+next:
+		pthread_cleanup_pop(1);
+	}
+out:
+	pthread_cleanup_pop(1);
 }
 
 /*
@@ -338,6 +397,7 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *ve
 	struct multipath *mpp;
 	int i, k;
 	int ret = 0;
+	bool found_nvme = false;
 
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(&vecs->lock);
@@ -348,7 +408,7 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *ve
 			continue;
 		/*checks if the bus type is nvme  and the protocol is FC-NVMe*/
 		if ((pp->bus == SYSFS_BUS_NVME) && (pp->sg_id.proto_id == NVME_PROTOCOL_FC)) {
-			fpin_check_set_nvme_path_marginal(host_num, pp, els_wwpn, attached_wwpn);
+			found_nvme = fpin_check_set_nvme_path_marginal(host_num, pp, els_wwpn, attached_wwpn) || found_nvme;
 		} else if ((pp->bus == SYSFS_BUS_SCSI) &&
 			(pp->sg_id.proto_id == SCSI_PROTOCOL_FCP) &&
 			(host_num ==  pp->sg_id.host_no)) {
@@ -356,6 +416,8 @@ static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *ve
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

