From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: [PATCH v4 3/6] IMA: update process_buffer_measurement to measure buffer hash
Date: Wed, 23 Sep 2020 12:20:08 -0700
Message-ID: <20200923192011.5293-4-tusharsu@linux.microsoft.com>
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

process_buffer_measurement() currently only measures the input buffer.
In case of SeLinux policy measurement, the policy being measured could
be large (several MB). This may result in a large entry in IMA
measurement log.

Introduce a boolean parameter measure_buf_hash to support measuring
hash of a buffer, which would be much smaller, instead of the buffer
itself.

To use the functionality introduced in this patch, the attestation
client and the server changes need to go hand in hand. The
client/kernel would know what data is being measured as-is
(e.g. KEXEC_CMDLINE), and what data has it’s hash measured (e.g. SeLinux
Policy). And the attestation server should verify data/hash accordingly.

Just like the data being measured in other cases, the attestation server
will know what are possible values of the large buffers being measured.
e.g. the possible valid SeLinux policy values that are being pushed to
the client. The attestation server will have to maintain the hash of
those buffer values.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 security/integrity/ima/ima.h                 |  3 ++-
 security/integrity/ima/ima_appraise.c        |  2 +-
 security/integrity/ima/ima_asymmetric_keys.c |  2 +-
 security/integrity/ima/ima_main.c            | 25 ++++++++++++++++++--
 security/integrity/ima/ima_queue_keys.c      |  3 ++-
 5 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 8875085db689..0f77e0b697a3 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -267,7 +267,8 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   struct ima_template_desc *template_desc);
 void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 				const char *eventname, enum ima_hooks func,
-				int pcr, const char *func_data);
+				int pcr, const char *func_data,
+				bool measure_buf_hash);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
 int ima_alloc_init_template(struct ima_event_data *event_data,
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 372d16382960..20adffe5bf58 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -336,7 +336,7 @@ int ima_check_blacklist(struct integrity_iint_cache *iint,
 		if ((rc == -EPERM) && (iint->flags & IMA_MEASURE))
 			process_buffer_measurement(NULL, digest, digestsize,
 						   "blacklisted-hash", NONE,
-						   pcr, NULL);
+						   pcr, NULL, false);
 	}
 
 	return rc;
diff --git a/security/integrity/ima/ima_asymmetric_keys.c b/security/integrity/ima/ima_asymmetric_keys.c
index 1c68c500c26f..a74095793936 100644
--- a/security/integrity/ima/ima_asymmetric_keys.c
+++ b/security/integrity/ima/ima_asymmetric_keys.c
@@ -60,5 +60,5 @@ void ima_post_key_create_or_update(struct key *keyring, struct key *key,
 	 */
 	process_buffer_measurement(NULL, payload, payload_len,
 				   keyring->description, KEY_CHECK, 0,
-				   keyring->description);
+				   keyring->description, false);
 }
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index c870fd6d2f83..6888fc372abf 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -733,12 +733,15 @@ int ima_load_data(enum kernel_load_data_id id)
  * @func: IMA hook
  * @pcr: pcr to extend the measurement
  * @func_data: private data specific to @func, can be NULL.
+ * @measure_buf_hash: if set to true - will measure hash of the buf,
+ *                    instead of buf
  *
  * Based on policy, the buffer is measured into the ima log.
  */
 void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 				const char *eventname, enum ima_hooks func,
-				int pcr, const char *func_data)
+				int pcr, const char *func_data,
+				bool measure_buf_hash)
 {
 	int ret = 0;
 	const char *audit_cause = "ENOMEM";
@@ -753,6 +756,8 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 		struct ima_digest_data hdr;
 		char digest[IMA_MAX_DIGEST_SIZE];
 	} hash = {};
+	char digest_hash[IMA_MAX_DIGEST_SIZE];
+	int hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
 	int action = 0;
 	u32 secid;
@@ -801,6 +806,21 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 		goto out;
 	}
 
+	if (measure_buf_hash) {
+		memcpy(digest_hash, hash.hdr.digest, hash_len);
+
+		ret = ima_calc_buffer_hash(digest_hash,
+					   hash_len,
+					   iint.ima_hash);
+		if (ret < 0) {
+			audit_cause = "measure_buf_hash_error";
+			goto out;
+		}
+
+		event_data.buf = digest_hash;
+		event_data.buf_len = hash_len;
+	}
+
 	ret = ima_alloc_init_template(&event_data, &entry, template);
 	if (ret < 0) {
 		audit_cause = "alloc_entry";
@@ -842,7 +862,8 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
 		return;
 
 	process_buffer_measurement(file_inode(f.file), buf, size,
-				   "kexec-cmdline", KEXEC_CMDLINE, 0, NULL);
+				   "kexec-cmdline", KEXEC_CMDLINE, 0, NULL,
+				   false);
 	fdput(f);
 }
 
diff --git a/security/integrity/ima/ima_queue_keys.c b/security/integrity/ima/ima_queue_keys.c
index 69a8626a35c0..c2f2ad34f9b7 100644
--- a/security/integrity/ima/ima_queue_keys.c
+++ b/security/integrity/ima/ima_queue_keys.c
@@ -162,7 +162,8 @@ void ima_process_queued_keys(void)
 						   entry->payload_len,
 						   entry->keyring_name,
 						   KEY_CHECK, 0,
-						   entry->keyring_name);
+						   entry->keyring_name,
+						   false);
 		list_del(&entry->list);
 		ima_free_key_entry(entry);
 	}
-- 
2.17.1
