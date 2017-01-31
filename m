From: Ondrej Kozina <okozina@redhat.com>
Subject: [PATCH] dm-crypt: fix wrong use of RCU on key payload
	handling
Date: Tue, 31 Jan 2017 13:47:40 +0100
Message-ID: <1485866860-20356-1-git-send-email-okozina@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>, mpatocka@redhat.com, snitzer@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

This fixes following lockdep splat emerging on
table load with a key in kernel keyring service.

In fact it hints a bug in RCU usage in dm-crypt since
kernel keyring fn user_key_payload() is in fact a wrapper
for rcu_dereference_protected() which must not be used
with only rcu_read_lock() mark.

===============================
[ INFO: suspicious RCU usage. ]
4.10.0-rc5 #2 Not tainted
-------------------------------
./include/keys/user-type.h:53 suspicious usage!
other info that might help us debug this:
rcu_scheduler_active = 2, debug_locks = 1
2 locks held by cryptsetup/5555:
 #0:  (&md->type_lock){+.+.+.}, at: [<ffffffffa02472a2>] dm_lock_md_type+0x12/0x20 [dm_mod]
 #1:  (rcu_read_lock){......}, at: [<ffffffffa026b2f8>] crypt_set_key+0x1d8/0x4b0 [dm_crypt]
stack backtrace:
CPU: 1 PID: 5555 Comm: cryptsetup Not tainted 4.10.0-rc5 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
Call Trace:
 dump_stack+0x67/0x92
 lockdep_rcu_suspicious+0xc5/0x100
 crypt_set_key+0x351/0x4b0 [dm_crypt]
 ? crypt_set_key+0x1d8/0x4b0 [dm_crypt]
 crypt_ctr+0x341/0xa53 [dm_crypt]
 dm_table_add_target+0x147/0x330 [dm_mod]
 table_load+0x111/0x350 [dm_mod]
 ? retrieve_status+0x1c0/0x1c0 [dm_mod]
 ctl_ioctl+0x1f5/0x510 [dm_mod]
 dm_ctl_ioctl+0xe/0x20 [dm_mod]
 do_vfs_ioctl+0x8e/0x690
 ? task_work_run+0x7e/0xa0
 ? trace_hardirqs_on_caller+0x122/0x1b0
 SyS_ioctl+0x3c/0x70
 entry_SYSCALL_64_fastpath+0x18/0xad
RIP: 0033:0x7f1be07ceec7
RSP: 002b:00007fff38c094d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 000000000d4dbae9 RCX: 00007f1be07ceec7
RDX: 0000000001768100 RSI: 00000000c138fd09 RDI: 0000000000000005
RBP: 0000000000000006 R08: 00000000ffffffff R09: 00000000017623f0
R10: 2a28205d34383336 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff38c0987c R14: 00007fff38c097ec R15: 0000000000000000

Reported-by: Milan Broz <mbroz@redhat.com>
Fixes: c538f6ec9f56 (dm crypt: add ability to use keys from the kernel key retention service)
Signed-off-by: Ondrej Kozina <okozina@redhat.com>
---
 drivers/md/dm-crypt.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 7c6c572..37d5027 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -31,6 +31,7 @@
 #include <crypto/md5.h>
 #include <crypto/algapi.h>
 #include <crypto/skcipher.h>
+#include <linux/rcupdate.h>
 #include <keys/user-type.h>
 
 #include <linux/device-mapper.h>
@@ -1498,6 +1499,12 @@ static bool contains_whitespace(const char *str)
 	return false;
 }
 
+/* workaround for missing RCU read key payload wrapper */
+static const struct user_key_payload *_user_key_payload(const struct key *key)
+{
+	return (const struct user_key_payload *) rcu_dereference(key->payload.rcu_data0);
+}
+
 static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
 {
 	char *new_key_string, *key_desc;
@@ -1536,7 +1543,7 @@ static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string
 
 	rcu_read_lock();
 
-	ukp = user_key_payload(key);
+	ukp = _user_key_payload(key);
 	if (!ukp) {
 		rcu_read_unlock();
 		key_put(key);
-- 
2.7.4
