Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFED7C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 20:10:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590--VjNnpDyPO6lnJTD9PWU0Q-1; Mon, 29 Nov 2021 15:09:55 -0500
X-MC-Unique: -VjNnpDyPO6lnJTD9PWU0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83E0B1853033;
	Mon, 29 Nov 2021 20:09:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25DE82B178;
	Mon, 29 Nov 2021 20:09:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73F1E1809C89;
	Mon, 29 Nov 2021 20:09:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ATK9lqp001970 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Nov 2021 15:09:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F3C641410DD8; Mon, 29 Nov 2021 20:09:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF00F1410DD5
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3EAF185A7BA
	for <dm-devel@redhat.com>; Mon, 29 Nov 2021 20:09:46 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-205-J4Dm3I-uOZmJh5-EKuX0PQ-1; Mon, 29 Nov 2021 15:09:42 -0500
X-MC-Unique: J4Dm3I-uOZmJh5-EKuX0PQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 14F5421892;
	Mon, 29 Nov 2021 20:09:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CD41113BDA;
	Mon, 29 Nov 2021 20:09:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id oGLhL4QzpWFsHgAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 29 Nov 2021 20:09:40 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 29 Nov 2021 21:09:00 +0100
Message-Id: <20211129200902.21817-12-mwilck@suse.com>
In-Reply-To: <20211129200902.21817-1-mwilck@suse.com>
References: <20211129200902.21817-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ATK9lqp001970
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 11/13] libmultipath: change wildcard handler
	tables to static const
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

From: Martin Wilck <mwilck@suse.com>

These arrays are actually constant lookup tables. Now that we use
local variables for field width, we can remove the width field from
these tables and make them static const, as they should be.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 119 +++++++++++++++++++++----------------------
 1 file changed, 58 insertions(+), 61 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 033d663..221b515 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -103,21 +103,18 @@
 struct path_data {
 	char wildcard;
 	char * header;
-	unsigned int width;
 	int (*snprint)(struct strbuf *, const struct path * pp);
 };
 
 struct multipath_data {
 	char wildcard;
 	char * header;
-	unsigned int width;
 	int (*snprint)(struct strbuf *, const struct multipath * mpp);
 };
 
 struct pathgroup_data {
 	char wildcard;
 	char * header;
-	unsigned int width;
 	int (*snprint)(struct strbuf *, const struct pathgroup * pgp);
 };
 
@@ -792,66 +789,66 @@ snprint_path_vpd_data(struct strbuf *buff, const struct path * pp)
 	return append_strbuf_str(buff, "[undef]");
 }
 
-static struct multipath_data mpd[] = {
-	{'n', "name",          0, snprint_name},
-	{'w', "uuid",          0, snprint_multipath_uuid},
-	{'d', "sysfs",         0, snprint_sysfs},
-	{'F', "failback",      0, snprint_failback},
-	{'Q', "queueing",      0, snprint_queueing},
-	{'N', "paths",         0, snprint_nb_paths},
-	{'r', "write_prot",    0, snprint_ro},
-	{'t', "dm-st",         0, snprint_dm_map_state},
-	{'S', "size",          0, snprint_multipath_size},
-	{'f', "features",      0, snprint_features},
-	{'x', "failures",      0, snprint_map_failures},
-	{'h', "hwhandler",     0, snprint_hwhandler},
-	{'A', "action",        0, snprint_action},
-	{'0', "path_faults",   0, snprint_path_faults},
-	{'1', "switch_grp",    0, snprint_switch_grp},
-	{'2', "map_loads",     0, snprint_map_loads},
-	{'3', "total_q_time",  0, snprint_total_q_time},
-	{'4', "q_timeouts",    0, snprint_q_timeouts},
-	{'s', "vend/prod/rev", 0, snprint_multipath_vpr},
-	{'v', "vend",          0, snprint_multipath_vend},
-	{'p', "prod",          0, snprint_multipath_prod},
-	{'e', "rev",           0, snprint_multipath_rev},
-	{'G', "foreign",       0, snprint_multipath_foreign},
-	{'g', "vpd page data", 0, snprint_multipath_vpd_data},
+static const struct multipath_data mpd[] = {
+	{'n', "name",          snprint_name},
+	{'w', "uuid",          snprint_multipath_uuid},
+	{'d', "sysfs",         snprint_sysfs},
+	{'F', "failback",      snprint_failback},
+	{'Q', "queueing",      snprint_queueing},
+	{'N', "paths",         snprint_nb_paths},
+	{'r', "write_prot",    snprint_ro},
+	{'t', "dm-st",         snprint_dm_map_state},
+	{'S', "size",          snprint_multipath_size},
+	{'f', "features",      snprint_features},
+	{'x', "failures",      snprint_map_failures},
+	{'h', "hwhandler",     snprint_hwhandler},
+	{'A', "action",        snprint_action},
+	{'0', "path_faults",   snprint_path_faults},
+	{'1', "switch_grp",    snprint_switch_grp},
+	{'2', "map_loads",     snprint_map_loads},
+	{'3', "total_q_time",  snprint_total_q_time},
+	{'4', "q_timeouts",    snprint_q_timeouts},
+	{'s', "vend/prod/rev", snprint_multipath_vpr},
+	{'v', "vend",          snprint_multipath_vend},
+	{'p', "prod",          snprint_multipath_prod},
+	{'e', "rev",           snprint_multipath_rev},
+	{'G', "foreign",       snprint_multipath_foreign},
+	{'g', "vpd page data", snprint_multipath_vpd_data},
 };
 
-static struct path_data pd[] = {
-	{'w', "uuid",          0, snprint_path_uuid},
-	{'i', "hcil",          0, snprint_hcil},
-	{'d', "dev",           0, snprint_dev},
-	{'D', "dev_t",         0, snprint_dev_t},
-	{'t', "dm_st",         0, snprint_dm_path_state},
-	{'o', "dev_st",        0, snprint_offline},
-	{'T', "chk_st",        0, snprint_chk_state},
-	{'s', "vend/prod/rev", 0, snprint_vpr},
-	{'c', "checker",       0, snprint_path_checker},
-	{'C', "next_check",    0, snprint_next_check},
-	{'p', "pri",           0, snprint_pri},
-	{'S', "size",          0, snprint_path_size},
-	{'z', "serial",        0, snprint_path_serial},
-	{'M', "marginal_st",   0, snprint_path_marginal},
-	{'m', "multipath",     0, snprint_path_mpp},
-	{'N', "host WWNN",     0, snprint_host_wwnn},
-	{'n', "target WWNN",   0, snprint_tgt_wwnn},
-	{'R', "host WWPN",     0, snprint_host_wwpn},
-	{'r', "target WWPN",   0, snprint_tgt_wwpn},
-	{'a', "host adapter",  0, snprint_host_adapter},
-	{'G', "foreign",       0, snprint_path_foreign},
-	{'g', "vpd page data", 0, snprint_path_vpd_data},
-	{'0', "failures",      0, snprint_path_failures},
-	{'P', "protocol",      0, snprint_path_protocol},
-	{'I', "init_st",       0, snprint_initialized},
+static const struct path_data pd[] = {
+	{'w', "uuid",          snprint_path_uuid},
+	{'i', "hcil",          snprint_hcil},
+	{'d', "dev",           snprint_dev},
+	{'D', "dev_t",         snprint_dev_t},
+	{'t', "dm_st",         snprint_dm_path_state},
+	{'o', "dev_st",        snprint_offline},
+	{'T', "chk_st",        snprint_chk_state},
+	{'s', "vend/prod/rev", snprint_vpr},
+	{'c', "checker",       snprint_path_checker},
+	{'C', "next_check",    snprint_next_check},
+	{'p', "pri",           snprint_pri},
+	{'S', "size",          snprint_path_size},
+	{'z', "serial",        snprint_path_serial},
+	{'M', "marginal_st",   snprint_path_marginal},
+	{'m', "multipath",     snprint_path_mpp},
+	{'N', "host WWNN",     snprint_host_wwnn},
+	{'n', "target WWNN",   snprint_tgt_wwnn},
+	{'R', "host WWPN",     snprint_host_wwpn},
+	{'r', "target WWPN",   snprint_tgt_wwpn},
+	{'a', "host adapter",  snprint_host_adapter},
+	{'G', "foreign",       snprint_path_foreign},
+	{'g', "vpd page data", snprint_path_vpd_data},
+	{'0', "failures",      snprint_path_failures},
+	{'P', "protocol",      snprint_path_protocol},
+	{'I', "init_st",       snprint_initialized},
 };
 
-static struct pathgroup_data pgd[] = {
-	{'s', "selector",      0, snprint_pg_selector},
-	{'p', "pri",           0, snprint_pg_pri},
-	{'t', "dm_st",         0, snprint_pg_state},
-	{'M', "marginal_st",   0, snprint_pg_marginal},
+static const struct pathgroup_data pgd[] = {
+	{'s', "selector",      snprint_pg_selector},
+	{'p', "pri",           snprint_pg_pri},
+	{'t', "dm_st",         snprint_pg_state},
+	{'M', "marginal_st",   snprint_pg_marginal},
 };
 
 int snprint_wildcards(struct strbuf *buff)
@@ -1052,7 +1049,7 @@ int snprint_multipath_header(struct strbuf *line, const char *format,
 {
 	int initial_len = get_strbuf_len(line);
 	const char *f;
-	struct multipath_data * data;
+	const struct multipath_data * data;
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
@@ -1113,7 +1110,7 @@ int snprint_path_header(struct strbuf *line, const char *format,
 {
 	int initial_len = get_strbuf_len(line);
 	const char *f;
-	struct path_data *data;
+	const struct path_data *data;
 	int rc;
 
 	for (f = strchr(format, '%'); f; f = strchr(++format, '%')) {
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

