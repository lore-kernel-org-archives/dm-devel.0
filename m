Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCAEAE7D0AA
	for <dm-devel@archiver.kernel.org>; Thu, 21 Sep 2023 21:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695332060;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6dqiFMa0UjFmqxiX+adfYW2ETLImF3rdxq4s4G90Cjk=;
	b=Qa5+CQLIjBTfhriFTsOogf+9DwUtRoqNV9vhkOldIAFTHWx9bNXh6i8aTntVflkqlWqSer
	s/R3OdVwhc4eUWMTXpJLQkUg8Fp6PRwolbCer7BLf7K8HqsHpfEPsxnFpcG4OZOWb2fQhR
	LQKipYn8NocGi7qEupiBFB+ET+uRfFw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-197-Aw0FGjtbPEev5fQwznK2dQ-1; Thu, 21 Sep 2023 17:34:17 -0400
X-MC-Unique: Aw0FGjtbPEev5fQwznK2dQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B31C382134E;
	Thu, 21 Sep 2023 21:34:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4673810EE859;
	Thu, 21 Sep 2023 21:34:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0478D1946595;
	Thu, 21 Sep 2023 21:34:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC22F1946595
 for <dm-devel@listman.corp.redhat.com>; Thu, 21 Sep 2023 10:32:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ABD6E1005B96; Thu, 21 Sep 2023 10:32:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A2C921006B79
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 10:32:44 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E9683800EB5
 for <dm-devel@redhat.com>; Thu, 21 Sep 2023 10:32:44 +0000 (UTC)
Received: from relay.smtp-ext.broadcom.com (lpdvsmtp11.broadcom.com
 [192.19.166.231]) by relay.mimecast.com with ESMTP id
 us-mta-595-wd87d8EeP3Od6wvjV6QlnA-1; Thu, 21 Sep 2023 06:32:40 -0400
X-MC-Unique: wd87d8EeP3Od6wvjV6QlnA-1
Received: from localhost.localdomain (unknown [10.157.2.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by relay.smtp-ext.broadcom.com (Postfix) with ESMTPS id E4EE5C0026C2;
 Thu, 21 Sep 2023 03:32:37 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com E4EE5C0026C2
From: Muneendra Kumar <muneendra.kumar@broadcom.com>
To: dm-devel@redhat.com,
	bmarzins@redhat.com,
	mwilck@suse.com
Date: Wed, 20 Sep 2023 20:41:15 -0700
Message-Id: <20230921034115.3118511-1-muneendra.kumar@broadcom.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Thu, 21 Sep 2023 21:33:57 +0000
Subject: [dm-devel] [PATCH v2] multipathd: Added support to handle FPIN-Li
 events for FC-NVMe
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
Cc: Muneendra <muneendra.kumar@broadcom.com>, mkumar@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: broadcom.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Muneendra <muneendra.kumar@broadcom.com>

    This patch adds the support to handle FPIN-Li for FC-NVMe.
    On receiving the FPIN-Li events this patch moves the devices paths
    which are affected due to link integrity to marginal path groups.
    The paths which are set to marginal path group will be unset
    on receiving the RSCN events

Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

---
Notes:
v2:
Addressed the review comments from Martin

Made changes to make sure that fpin_path_setmarginal()
now always set the path to marginal.
---
 multipathd/fpin_handlers.c | 204 +++++++++++++++++++++++++++----------
 1 file changed, 149 insertions(+), 55 deletions(-)

diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index aa0f63c9..f495f6ee 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -60,18 +60,15 @@ static void _udev_device_unref(void *p)
 
 
 /*set/unset the path state to marginal*/
-static int fpin_set_pathstate(struct path *pp, bool set)
+static void fpin_set_pathstate(struct path *pp, bool set)
 {
 	const char *action = set ? "set" : "unset";
 
-	if (!pp || !pp->mpp || !pp->mpp->alias)
-		return -1;
-
-	condlog(3, "\n%s: %s  marginal path %s (fpin)",
-		action, pp->mpp->alias, pp->dev_t);
+	condlog(3, "%s: %s marginal path %s (fpin)",
+		pp->mpp ? pp->mpp->alias : "orphan", action, pp->dev_t);
 	pp->marginal = set;
-	pp->mpp->fpin_must_reload = true;
-	return 0;
+	if (pp->mpp)
+		pp->mpp->fpin_must_reload = true;
 }
 
 /* This will unset marginal state of a device*/
@@ -82,14 +79,14 @@ static void fpin_path_unsetmarginal(char *devname, struct vectors *vecs)
 	pp = find_path_by_dev(vecs->pathvec, devname);
 	if (!pp)
 		pp = find_path_by_devt(vecs->pathvec, devname);
-
-	fpin_set_pathstate(pp, false);
+	if (pp)
+		fpin_set_pathstate(pp, false);
 }
 
 /*This will set the marginal state of a device*/
-static int fpin_path_setmarginal(struct path *pp)
+static void  fpin_path_setmarginal(struct path *pp)
 {
-	return fpin_set_pathstate(pp, true);
+	fpin_set_pathstate(pp, true);
 }
 
 /* Unsets all the devices in the list from marginal state */
@@ -183,8 +180,8 @@ static void fpin_set_rport_marginal(struct udev_device *rport_dev)
 					 udev_device_get_syspath(rport_dev));
 }
 
-/*Add the marginal devices info into the list*/
-static void
+/*Add the marginal devices info into the list and return 0 on success*/
+static int
 fpin_add_marginal_dev_info(uint32_t host_num, char *devname)
 {
 	struct marginal_dev_list *newdev = NULL;
@@ -199,65 +196,159 @@ fpin_add_marginal_dev_info(uint32_t host_num, char *devname)
 		list_add_tail(&(newdev->node),
 				&fpin_li_marginal_dev_list_head);
 		pthread_mutex_unlock(&fpin_li_marginal_dev_mutex);
-	}
+	} else
+		return -ENOMEM;
+	return 0;
 }
 
 /*
- * This function goes through the vecs->pathvec, and for
- * each path, check that the host  number,
- * the target WWPN associated with the path matches
- * with the els wwpn and sets the path and port state to
+ * This function compares Transport Address Controller Port pn,
+ * Host Transport Address Controller Port pn with the els wwpn ,attached_wwpn
+ * and return 1 (match) or 0 (no match) or a negative error code
+ */
+static int  extract_nvme_addresses_chk_path_pwwn(const char *address,
+		uint64_t els_wwpn, uint64_t els_attached_wwpn)
+
+{
+	uint64_t traddr;
+	uint64_t host_traddr;
+
+	/*
+	 *  Find the position of "traddr=" and "host_traddr="
+	 *  and the address will be in the below format
+	 *  "traddr=nn-0x200400110dff9400:pn-0x200400110dff9400,
+	 *  host_traddr=nn-0x200400110dff9400:pn-0x200400110dff9400"
+	 */
+	const char *traddr_start = strstr(address, "traddr=");
+	const char *host_traddr_start = strstr(address, "host_traddr=");
+
+	if (!traddr_start || !host_traddr_start)
+		return -EINVAL;
+
+	/* Extract traddr pn */
+	if (sscanf(traddr_start, "traddr=nn-%*[^:]:pn-%" SCNx64, &traddr) != 1)
+		return -EINVAL;
+
+	/* Extract host_traddr pn*/
+	if (sscanf(host_traddr_start, "host_traddr=nn-%*[^:]:pn-%" SCNx64,
+				&host_traddr) != 1)
+		return -EINVAL;
+	condlog(4, "traddr 0x%lx hosttraddr 0x%lx els_wwpn 0x%lx els_host_traddr 0x%lx",
+			traddr, host_traddr,
+			els_wwpn, els_attached_wwpn);
+	if ((host_traddr == els_attached_wwpn) && (traddr == els_wwpn))
+		return 1;
+	return 0;
+}
+
+/*
+ * This function check that the Transport Address Controller Port pn,
+ * Host Transport Address Controller Port pn associated with the path matches
+ * with the els wwpn ,attached_wwpn and sets the path state to
  * Marginal
  */
-static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *vecs,
+static void fpin_check_set_nvme_path_marginal(uint16_t host_num, struct path *pp,
+		uint64_t els_wwpn, uint64_t attached_wwpn)
+{
+	struct udev_device *ctl = NULL;
+	const char *address = NULL;
+	int ret = 0;
+
+	ctl = udev_device_get_parent_with_subsystem_devtype(pp->udev, "nvme", NULL);
+	if (ctl == NULL) {
+		condlog(2, "%s: No parent device for ", pp->dev);
+		return;
+	}
+	address = udev_device_get_sysattr_value(ctl, "address");
+	if (!address) {
+		condlog(2, "%s: unable to get the address ", pp->dev);
+		return;
+	}
+	condlog(4, "\n address %s: dev :%s\n", address, pp->dev);
+	ret = extract_nvme_addresses_chk_path_pwwn(address, els_wwpn, attached_wwpn);
+	if (ret <= 0)
+		return;
+	ret = fpin_add_marginal_dev_info(host_num, pp->dev);
+	if (ret < 0)
+		return;
+	fpin_path_setmarginal(pp);
+}
+
+/*
+ * This function check the host  number, the target WWPN
+ * associated with the path matches with the els wwpn and
+ * sets the path and port state to Marginal
+ */
+static void fpin_check_set_scsi_path_marginal(uint16_t host_num, struct path *pp,
 		uint64_t els_wwpn)
 {
-	struct path *pp;
-	struct multipath *mpp;
-	int i, k;
 	char rport_id[42];
 	const char *value = NULL;
 	struct udev_device *rport_dev = NULL;
 	uint64_t wwpn;
 	int ret = 0;
+	sprintf(rport_id, "rport-%d:%d-%d",
+			pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
+	rport_dev = udev_device_new_from_subsystem_sysname(udev,
+			"fc_remote_ports", rport_id);
+	if (!rport_dev) {
+		condlog(2, "%s: No fc_remote_port device for '%s'", pp->dev,
+				rport_id);
+		return;
+	}
+	pthread_cleanup_push(_udev_device_unref, rport_dev);
+	value = udev_device_get_sysattr_value(rport_dev, "port_name");
+	if (!value)
+		goto unref;
+
+	wwpn =  strtol(value, NULL, 16);
+	/*
+	 * If the port wwpn matches sets the path and port state
+	 * to marginal
+	 */
+	if (wwpn == els_wwpn) {
+		ret = fpin_add_marginal_dev_info(host_num, pp->dev);
+		if (ret < 0)
+			goto unref;
+		fpin_path_setmarginal(pp);
+		fpin_set_rport_marginal(rport_dev);
+	}
+unref:
+	pthread_cleanup_pop(1);
+	return;
+
+}
+
+/*
+ * This function goes through the vecs->pathvec, and for
+ * each path, it checks and sets the path state to marginal
+ * if the path's associated port wwpn ,hostnum  matches with
+ * els wwnpn ,attached_wwpn
+ */
+static int  fpin_chk_wwn_setpath_marginal(uint16_t host_num,  struct vectors *vecs,
+		uint64_t els_wwpn, uint64_t attached_wwpn)
+{
+	struct path *pp;
+	struct multipath *mpp;
+	int i, k;
+	int ret = 0;
 
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(&vecs->lock);
 	pthread_testcancel();
 
 	vector_foreach_slot(vecs->pathvec, pp, k) {
-		/* Checks the host number and also for the SCSI FCP */
-		if (pp->bus != SYSFS_BUS_SCSI || pp->sg_id.proto_id != SCSI_PROTOCOL_FCP || host_num !=  pp->sg_id.host_no)
+		if (!pp->mpp)
 			continue;
-		sprintf(rport_id, "rport-%d:%d-%d",
-				pp->sg_id.host_no, pp->sg_id.channel, pp->sg_id.transport_id);
-		rport_dev = udev_device_new_from_subsystem_sysname(udev,
-				"fc_remote_ports", rport_id);
-		if (!rport_dev) {
-			condlog(2, "%s: No fc_remote_port device for '%s'", pp->dev,
-					rport_id);
-			continue;
-		}
-		pthread_cleanup_push(_udev_device_unref, rport_dev);
-		value = udev_device_get_sysattr_value(rport_dev, "port_name");
-		if (!value)
-			goto unref;
-
-		if (value)
-			wwpn =  strtol(value, NULL, 16);
-		/*
-		 * If the port wwpn matches sets the path and port state
-		 * to marginal
-		 */
-		if (wwpn == els_wwpn) {
-			ret = fpin_path_setmarginal(pp);
-			if (ret < 0)
-				goto unref;
-			fpin_set_rport_marginal(rport_dev);
-			fpin_add_marginal_dev_info(host_num, pp->dev);
+		/*checks if the bus type is nvme  and the protocol is FC-NVMe*/
+		if ((pp->bus == SYSFS_BUS_NVME) && (pp->sg_id.proto_id == NVME_PROTOCOL_FC)) {
+			fpin_check_set_nvme_path_marginal(host_num, pp, els_wwpn, attached_wwpn);
+		} else if ((pp->bus == SYSFS_BUS_SCSI) &&
+			(pp->sg_id.proto_id == SCSI_PROTOCOL_FCP) &&
+			(host_num ==  pp->sg_id.host_no)) {
+			/* Checks the host number and also for the SCSI FCP */
+			fpin_check_set_scsi_path_marginal(host_num, pp, els_wwpn);
 		}
-unref:
-		pthread_cleanup_pop(1);
 	}
 	/* walk backwards because reload_and_sync_map() can remove mpp */
 	vector_foreach_slot_backwards(vecs->mpvec, mpp, i) {
@@ -286,14 +377,17 @@ fpin_parse_li_els_setpath_marginal(uint16_t host_num, struct fc_tlv_desc *tlv,
 	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
 	int count = 0;
 	int ret = 0;
+	uint64_t attached_wwpn;
 
 	/* Update the wwn to list */
 	wwn_count = be32_to_cpu(li_desc->pname_count);
-	condlog(4, "Got wwn count as %d\n", wwn_count);
+	attached_wwpn = be64_to_cpu(li_desc->attached_wwpn);
+	condlog(4, "Got wwn count as %d detecting wwn 0x%lx attached_wwpn 0x%lx\n",
+			wwn_count, be64_to_cpu(li_desc->detecting_wwpn), attached_wwpn);
 
 	for (iter = 0; iter < wwn_count; iter++) {
 		wwpn = be64_to_cpu(li_desc->pname_list[iter]);
-		ret = fpin_chk_wwn_setpath_marginal(host_num, vecs, wwpn);
+		ret = fpin_chk_wwn_setpath_marginal(host_num, vecs, wwpn, attached_wwpn);
 		if (ret < 0)
 			condlog(2, "failed to set the path marginal associated with wwpn: 0x%" PRIx64 "\n", wwpn);
 
-- 
2.26.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

