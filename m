Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDEFC2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:20:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 42637222EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 07:20:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42637222EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-O4ZbkaxUNu--I2cWR5sFyg-1; Mon, 26 Oct 2020 03:20:28 -0400
X-MC-Unique: O4ZbkaxUNu--I2cWR5sFyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72EB81074649;
	Mon, 26 Oct 2020 07:20:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 45DDD60BF3;
	Mon, 26 Oct 2020 07:20:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1650392F27;
	Mon, 26 Oct 2020 07:20:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09N2nJEj022107 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Oct 2020 22:49:19 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 04C309C04C; Fri, 23 Oct 2020 02:49:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F335B9C04D
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 02:49:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DA0C811E76
	for <dm-devel@redhat.com>; Fri, 23 Oct 2020 02:49:16 +0000 (UTC)
Received: from aserp2130.oracle.com (aserp2130.oracle.com [141.146.126.79])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-199-zONzWaspMLWd1AYIkmO-ig-1; Thu, 22 Oct 2020 22:49:13 -0400
X-MC-Unique: zONzWaspMLWd1AYIkmO-ig-1
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
	by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	09N0PS33169166; Fri, 23 Oct 2020 00:28:02 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by aserp2130.oracle.com with ESMTP id 347p4b8s9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL); Fri, 23 Oct 2020 00:28:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id
	09N0QA8S078718; Fri, 23 Oct 2020 00:28:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserp3030.oracle.com with ESMTP id 348a6r74b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Oct 2020 00:28:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
	by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09N0S0cF021888;
	Fri, 23 Oct 2020 00:28:00 GMT
Received: from ol2.localdomain (/73.88.28.6)
	by default (Oracle Beehive Gateway v4.0)
	with ESMTP ; Thu, 22 Oct 2020 17:28:00 -0700
From: Mike Christie <michael.christie@oracle.com>
To: dm-devel@redhat.com, snitzer@redhat.com
Date: Thu, 22 Oct 2020 19:27:50 -0500
Message-Id: <1603412870-3627-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
	mlxlogscore=999
	bulkscore=0 spamscore=0 adultscore=0 suspectscore=2 mlxscore=0
	phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2010230001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782
	signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2
	priorityscore=1501
	clxscore=1011 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
	phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
	classifier=spam adjust=0 reason=mlx scancount=1
	engine=8.12.0-2009150000 definitions=main-2010230001
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 26 Oct 2020 03:19:19 -0400
Subject: [dm-devel] [PATCH 1/1] dm mpath: add IO affinity path selector
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds a path selector that selects paths based on a CPU to
path mapping the user passes in and what CPU we are executing on. The
primary user for this PS is where the app is optimized to use specific
CPUs so other PSs undo the apps handy work, and the storage and it's
transport are not a bottlneck.

For these io-affinity PS setups a path's transport/interconnect
perf is not going to flucuate a lot and there is no major differences
between paths, so QL/HST smarts do not help and RR always messes up
what the app is trying to do.

On a system with 16 cores, where you have a job per CPU:

fio --filename=/dev/dm-0 --direct=1 --rw=randrw --bs=4k \
--ioengine=libaio --iodepth=128 --numjobs=16

and a dm-multipath device setup where each CPU is mapped to one path:

// When in mq mode I had to set dm_mq_nr_hw_queues=$NUM_PATHS.
// Bio mode also showed similar results.
0 16777216 multipath 0 0 1 1 io-affinity 0 16 1 8:16 1 8:32 2 8:64 4
8:48 8 8:80 10 8:96 20 8:112 40 8:128 80 8:144 100 8:160 200 8:176
400 8:192 800 8:208 1000 8:224 2000 8:240 4000 65:0 8000

we can see a IOPs increase of 25%.

The percent increase depends on the device and interconnect. For a
slower/medium speed path/device that can do around 180K IOPs a path
if you ran that fio command to it directly we saw a 25% increase like
above. Slower path'd devices that could do around 90K per path showed
maybe around a 2 - 5% increase. If you use something like null_blk or
scsi_debug which can multi-million IOPs and hack it up so each device
they export shows up as a path then you see 50%+ increases.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/Kconfig          |   9 ++
 drivers/md/Makefile         |   1 +
 drivers/md/dm-io-affinity.c | 272 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 282 insertions(+)
 create mode 100644 drivers/md/dm-io-affinity.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 30ba357..c82d8b6 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -463,6 +463,15 @@ config DM_MULTIPATH_HST
 
 	  If unsure, say N.
 
+config DM_MULTIPATH_IOA
+	tristate "I/O Path Selector based on CPU submission"
+	depends on DM_MULTIPATH
+	help
+	  This path selector selects the path based on the CPU the IO is
+	  executed on and the CPU to path mapping setup at path addition time.
+
+	  If unsure, say N.
+
 config DM_DELAY
 	tristate "I/O delaying target"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 6d3e234..4f95f33 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
 obj-$(CONFIG_DM_MULTIPATH_ST)	+= dm-service-time.o
 obj-$(CONFIG_DM_MULTIPATH_HST)	+= dm-historical-service-time.o
+obj-$(CONFIG_DM_MULTIPATH_IOA)	+= dm-io-affinity.o
 obj-$(CONFIG_DM_SWITCH)		+= dm-switch.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
 obj-$(CONFIG_DM_PERSISTENT_DATA)	+= persistent-data/
diff --git a/drivers/md/dm-io-affinity.c b/drivers/md/dm-io-affinity.c
new file mode 100644
index 0000000..7c03ab2
--- /dev/null
+++ b/drivers/md/dm-io-affinity.c
@@ -0,0 +1,272 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Oracle Corporation
+ *
+ * Module Author: Mike Christie
+ */
+#include "dm-path-selector.h"
+
+#include <linux/device-mapper.h>
+#include <linux/module.h>
+
+#define DM_MSG_PREFIX "multipath io-affinity"
+
+struct path_info {
+	struct dm_path *path;
+	cpumask_var_t cpumask;
+	refcount_t refcount;
+	bool failed;
+};
+
+struct selector {
+	struct path_info **path_map;
+	cpumask_var_t path_mask;
+	atomic_t map_misses;
+};
+
+static void ioa_free_path(struct selector *s, unsigned int cpu)
+{
+	struct path_info *pi = s->path_map[cpu];
+
+	if (!pi)
+		return;
+
+	if (refcount_dec_and_test(&pi->refcount)) {
+		cpumask_clear_cpu(cpu, s->path_mask);
+		free_cpumask_var(pi->cpumask);
+		kfree(pi);
+
+		s->path_map[cpu] = NULL;
+	}
+}
+
+static int ioa_add_path(struct path_selector *ps, struct dm_path *path,
+			int argc, char **argv, char **error)
+{
+	struct selector *s = ps->context;
+	struct path_info *pi = NULL;
+	unsigned int cpu;
+	int ret;
+
+	if (argc != 1) {
+		*error = "io-affinity ps: invalid number of arguments";
+		return -EINVAL;
+	}
+
+	pi = kzalloc_node(sizeof(*pi), GFP_KERNEL, cpu_to_node(cpu));
+	if (!pi) {
+		*error = "io-affinity ps: Error allocating path context";
+		return -ENOMEM;
+	}
+
+	pi->path = path;
+	path->pscontext = pi;
+	refcount_set(&pi->refcount, 1);
+
+	if (!zalloc_cpumask_var(&pi->cpumask, GFP_KERNEL)) {
+		*error = "io-affinity ps: Error allocating cpumask context";
+		ret = -ENOMEM;
+		goto free_pi;
+	}
+
+	ret = cpumask_parse(argv[0], pi->cpumask);
+	if (ret) {
+		*error = "io-affinity ps: invalid cpumask";
+		ret = -EINVAL;
+		goto free_mask;
+	}
+
+	for_each_cpu(cpu, pi->cpumask) {
+		if (cpu >= nr_cpu_ids) {
+			DMWARN_LIMIT("Ignoring mapping for CPU %u. Max CPU is %u\n",
+				     cpu, nr_cpu_ids);
+			break;
+		}
+
+		if (s->path_map[cpu]) {
+			DMWARN("CPU mapping for %u exists. Ignoring.", cpu);
+			continue;
+		}
+
+		cpumask_set_cpu(cpu, s->path_mask);
+		s->path_map[cpu] = pi;
+		refcount_inc(&pi->refcount);
+		continue;
+	}
+
+	if (refcount_dec_and_test(&pi->refcount)) {
+		*error = "io-affinity ps: No new/valid CPU mapping found";
+		ret = -EINVAL;
+		goto free_mask;
+	}
+
+	return 0;
+
+free_mask:
+	free_cpumask_var(pi->cpumask);
+free_pi:
+	kfree(pi);
+	return ret;
+}
+
+static int ioa_create(struct path_selector *ps, unsigned argc, char **argv)
+{
+	struct selector *s;
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	s->path_map = kzalloc(nr_cpu_ids * sizeof(struct path_info *),
+			      GFP_KERNEL);
+	if (!s->path_map)
+		goto free_selector;
+
+	if (!zalloc_cpumask_var(&s->path_mask, GFP_KERNEL))
+		goto free_map;
+
+	atomic_set(&s->map_misses, 0);
+	ps->context = s;
+	return 0;
+
+free_map:
+	kfree(s->path_map);
+free_selector:
+	kfree(s);
+	return -ENOMEM;
+}
+
+static void ioa_destroy(struct path_selector *ps)
+{
+	struct selector *s = ps->context;
+	unsigned cpu;
+
+	for_each_cpu(cpu, s->path_mask)
+		ioa_free_path(s, cpu);
+
+	free_cpumask_var(s->path_mask);
+	kfree(s->path_map);
+	kfree(s);
+
+	ps->context = NULL;
+}
+
+static int ioa_status(struct path_selector *ps, struct dm_path *path,
+		      status_type_t type, char *result, unsigned int maxlen)
+{
+	struct selector *s = ps->context;
+	struct path_info *pi;
+	int sz = 0;
+
+	if (!path) {
+		DMEMIT("0 ");
+		return sz;
+	}
+
+	switch(type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%d ", atomic_read(&s->map_misses));
+		break;
+	case STATUSTYPE_TABLE:
+		pi = path->pscontext;
+		DMEMIT("%*pb ", cpumask_pr_args(pi->cpumask));
+		break;
+	}
+
+	return sz;
+}
+
+static void ioa_fail_path(struct path_selector *ps, struct dm_path *p)
+{
+	struct path_info *pi = p->pscontext;
+
+	pi->failed = true;
+}
+
+static int ioa_reinstate_path(struct path_selector *ps, struct dm_path *p)
+{
+	struct path_info *pi = p->pscontext;
+
+	pi->failed = false;
+	return 0;
+}
+
+static struct dm_path *ioa_select_path(struct path_selector *ps,
+				       size_t nr_bytes)
+{
+	unsigned int cpu, node;
+	struct selector *s = ps->context;
+	const struct cpumask *cpumask;
+	struct path_info *pi;
+	int i;
+
+	cpu = get_cpu();
+
+	pi = s->path_map[cpu];
+	if (pi && !pi->failed)
+		goto done;
+
+	/*
+	 * Perf is not optimal, but we at least try the local node then just
+	 * try not to fail.
+	 */
+	if (!pi)
+		atomic_inc(&s->map_misses);
+
+	node = cpu_to_node(cpu);
+	cpumask = cpumask_of_node(node);
+	for_each_cpu(i, cpumask) {
+		pi = s->path_map[i];
+		if (pi && !pi->failed)
+			goto done;
+	}
+
+	for_each_cpu(i, s->path_mask) {
+		pi = s->path_map[i];
+		if (pi && !pi->failed)
+			goto done;
+	}
+	pi = NULL;
+
+done:
+	put_cpu();
+	return pi ? pi->path : NULL;
+}
+
+static struct path_selector_type ioa_ps = {
+	.name		= "io-affinity",
+	.module		= THIS_MODULE,
+	.table_args	= 1,
+	.info_args	= 1,
+	.create		= ioa_create,
+	.destroy	= ioa_destroy,
+	.status		= ioa_status,
+	.add_path	= ioa_add_path,
+	.fail_path	= ioa_fail_path,
+	.reinstate_path	= ioa_reinstate_path,
+	.select_path	= ioa_select_path,
+};
+
+static int __init dm_ioa_init(void)
+{
+	int ret = dm_register_path_selector(&ioa_ps);
+
+	if (ret < 0)
+		DMERR("register failed %d", ret);
+	return ret;
+}
+
+static void __exit dm_ioa_exit(void)
+{
+	int ret = dm_unregister_path_selector(&ioa_ps);
+
+	if (ret < 0)
+		DMERR("unregister failed %d", ret);
+}
+
+module_init(dm_ioa_init);
+module_exit(dm_ioa_exit);
+
+MODULE_DESCRIPTION(DM_NAME " multipath path selector that selects paths based on the CPU IO is being executed on");
+MODULE_AUTHOR("Mike Christie <michael.christie@oracle.com>");
+MODULE_LICENSE("GPL");
-- 
1.8.3.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

