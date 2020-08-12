From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: [PATCH 3/3] IMA: define IMA hook to measure critical data from kernel components
Date: Wed, 12 Aug 2020 12:31:02 -0700
Message-ID: <20200812193102.18636-4-tusharsu@linux.microsoft.com>
References: <20200812193102.18636-1-tusharsu@linux.microsoft.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200812193102.18636-1-tusharsu@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, nramas@linux.microsoft.com
List-Id: dm-devel.ids

Currently, IMA does not provide a generic function to kernel components
to measure their data. A generic function provided by IMA would
enable various parts of the kernel with easier and faster on-boarding to
use IMA infrastructure, would avoid code duplication, and consistent
usage of IMA policy CRITICAL_DATA+data_sources across the kernel.

Define a generic IMA function ima_measure_critical_data() to measure
data from various kernel components. Limit the measurement to the
components that are specified in the IMA policy - 
CRITICAL_DATA+data_sources.
Update process_buffer_measurement() to return the status code of the
operation.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 include/linux/ima.h               |  9 ++++++++
 security/integrity/ima/ima.h      |  8 +++----
 security/integrity/ima/ima_main.c | 37 ++++++++++++++++++++++++-------
 3 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index d15100de6cdd..865332ecedcb 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -26,6 +26,9 @@ extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
 extern void ima_post_path_mknod(struct dentry *dentry);
 extern int ima_file_hash(struct file *file, char *buf, size_t buf_size);
 extern void ima_kexec_cmdline(int kernel_fd, const void *buf, int size);
+extern int ima_measure_critical_data(const char *event_name,
+				     const char *event_data_source,
+				     const void *buf, int buf_len);
 
 #ifdef CONFIG_IMA_KEXEC
 extern void ima_add_kexec_buffer(struct kimage *image);
@@ -104,6 +107,12 @@ static inline int ima_file_hash(struct file *file, char *buf, size_t buf_size)
 }
 
 static inline void ima_kexec_cmdline(int kernel_fd, const void *buf, int size) {}
+static inline int ima_measure_critical_data(const char *event_name,
+					    const char *event_data_source,
+					    const void *buf, int buf_len)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_IMA */
 
 #ifndef CONFIG_IMA_KEXEC
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 99773dfa2541..e65ab067e700 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -266,10 +266,10 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   struct evm_ima_xattr_data *xattr_value,
 			   int xattr_len, const struct modsig *modsig, int pcr,
 			   struct ima_template_desc *template_desc);
-void process_buffer_measurement(struct inode *inode, const void *buf,
-				int buf_len, const char *eventname,
-				enum ima_hooks func, int pcr,
-				const char *func_data);
+int process_buffer_measurement(struct inode *inode, const void *buf,
+			       int buf_len, const char *eventname,
+			       enum ima_hooks func, int pcr,
+			       const char *func_data);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
 int ima_alloc_init_template(struct ima_event_data *event_data,
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index a8740b7ea417..129bcaaf13e2 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -736,10 +736,11 @@ int ima_load_data(enum kernel_load_data_id id)
  *
  * Based on policy, the buffer is measured into the ima log.
  */
-void process_buffer_measurement(struct inode *inode, const void *buf,
-				int buf_len, const char *eventname,
-				enum ima_hooks func, int pcr,
-				const char *func_data)
+
+int process_buffer_measurement(struct inode *inode, const void *buf,
+			       int buf_len, const char *eventname,
+			       enum ima_hooks func, int pcr,
+			       const char *func_data)
 {
 	int ret = 0;
 	const char *audit_cause = "ENOMEM";
@@ -759,7 +760,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf,
 	u32 secid;
 
 	if (!ima_policy_flag)
-		return;
+		return 0;
 
 	/*
 	 * Both LSM hooks and auxilary based buffer measurements are
@@ -773,7 +774,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf,
 		action = ima_get_action(inode, current_cred(), secid, 0, func,
 					&pcr, &template, func_data);
 		if (!(action & IMA_MEASURE))
-			return;
+			return 0;
 	}
 
 	if (!pcr)
@@ -788,7 +789,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf,
 			pr_err("template %s init failed, result: %d\n",
 			       (strlen(template->name) ?
 				template->name : template->fmt), ret);
-			return;
+			return ret;
 		}
 	}
 
@@ -820,7 +821,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf,
 					func_measure_str(func),
 					audit_cause, ret, 0, ret);
 
-	return;
+	return ret;
 }
 
 /**
@@ -847,6 +848,26 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
 	fdput(f);
 }
 
+/**
+ * ima_measure_critical_data - measure critical data
+ * @event_name: name for the given data
+ * @event_data_source: name of the event data source
+ * @buf: pointer to buffer containing data to measure
+ * @size: Number of bytes in buf
+ *
+ * Buffers can only be measured, not appraised.
+ */
+int ima_measure_critical_data(const char *event_name,
+			      const char *event_data_source,
+			      const void *buf, int buf_len)
+{
+	if (!event_name || !event_data_source || !buf || !buf_len)
+		return -EINVAL;
+
+	return process_buffer_measurement(NULL, buf, buf_len, event_name,
+					  CRITICAL_DATA, 0, event_data_source);
+}
+
 static int __init init_ima(void)
 {
 	int error;
-- 
2.17.1
