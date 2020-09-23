From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: [PATCH v4 6/6] IMA: validate supported kernel data sources before measurement
Date: Wed, 23 Sep 2020 12:20:11 -0700
Message-ID: <20200923192011.5293-7-tusharsu@linux.microsoft.com>
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Currently, IMA does not restrict random data sources from measuring
their data using ima_measure_critical_data(). Any kernel data source can
call the function, and it's data will get measured as long as the input
event_data_source is part of the IMA policy - RITICAL_DATA+data_sources.
Supporting random data sources at run-time may impact the reliability of
the system.

To ensure that only data from supported sources are measured, the kernel
component needs to be added to a compile-time list of supported sources
(an "allowed list of components"). IMA then validates the input
parameter - "event_data_source" passed to ima_measure_critical_data()
against this allowed list at run-time.

This compile time list must be updated when kernel components are
updated to measure their data using IMA.

Provide an infrastructure for kernel data sources to be added to
IMA's supported data sources list at compile-time. Update
ima_measure_critical_data() to validate, at run-time, that the data
source is supported before measuring the data coming from that source.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 security/integrity/ima/ima.h      | 29 +++++++++++++++++++++++++++++
 security/integrity/ima/ima_main.c |  6 ++++++
 2 files changed, 35 insertions(+)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index c1acf88e1b5d..4a35db010d91 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -228,6 +228,35 @@ extern const char *const func_tokens[];
 
 struct modsig;
 
+#define __ima_supported_kernel_data_sources(source)	\
+	source(MIN_SOURCE, min_source)			\
+	source(MAX_SOURCE, max_source)
+
+#define __ima_enum_stringify(ENUM, str) (#str),
+
+enum ima_supported_kernel_data_sources {
+	__ima_supported_kernel_data_sources(__ima_hook_enumify)
+};
+
+static const char * const ima_supported_kernel_data_sources_str[] = {
+	__ima_supported_kernel_data_sources(__ima_enum_stringify)
+};
+
+static inline bool ima_kernel_data_source_is_supported(const char *source)
+{
+	int i;
+
+	if (!source)
+		return false;
+
+	for (i = MIN_SOURCE + 1; i < MAX_SOURCE; i++) {
+		if (!strcmp(ima_supported_kernel_data_sources_str[i], source))
+			return true;
+	}
+
+	return false;
+}
+
 #ifdef CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS
 /*
  * To track keys that need to be measured.
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index d55896f28790..61f9642747a8 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -888,6 +888,12 @@ void ima_measure_critical_data(const char *event_name,
 		return;
 	}
 
+	if (!ima_kernel_data_source_is_supported(event_data_source)) {
+		pr_err("measuring data source %s is not permitted",
+		       event_data_source);
+		return;
+	}
+
 	process_buffer_measurement(NULL, buf, buf_len, event_name,
 				   CRITICAL_DATA, 0, event_data_source,
 				   measure_buf_hash);
-- 
2.17.1
