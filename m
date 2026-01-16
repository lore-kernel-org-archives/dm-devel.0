Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4207339282E
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 14:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768573879; cv=none; b=oBDc2KPkVGHAAMchDecH9QPq12ovH9v/pqn8ki/AdolMoXqdP735BIedxP66VWA1llAEGgODfGnGPnfM1xxxRawEIcGJ7azo2lZHABFl9jye2YnOjCwXPPH4GnD5fFhwQScz3HPOoGLi50cKMbxBBhGmkzTruunIP4EA65JGNTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768573879; c=relaxed/simple;
	bh=7t6K2sEMtp9ouD77aifBltaLlqzqghE7V5PqGMRbVNQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=KvlBJfmyq0Y11zYDM3qZu/v/J+Sl/4bYKcIIr/ippHwIDtKqDctrnzed8pOdcj9Ssiy+fRDAs5dkSJkF+ZgYlc885kymhnGnU8/ymW6p8eQuUMrRuvICgepYcgpJqF1/GDtbFiBoqDrsLQGwHFY1qK5x1WTYW4s5QgU5wwjAIAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qxsFhgFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxsFhgFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD49C116C6;
	Fri, 16 Jan 2026 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768573878;
	bh=7t6K2sEMtp9ouD77aifBltaLlqzqghE7V5PqGMRbVNQ=;
	h=From:Subject:Date:To:Cc:From;
	b=qxsFhgFjhMaXbMh8KspouwYx+UiqZSyT1AELlVXeB8/PBfY8gegTu3W+FZjINHZR1
	 rV7DlPPM/IK2SGgpivrwyv46ROEczjuHKln7k4qFHHxE6d8L8WNPoDW8TcGozyxTF4
	 pWTj5tk43leB05sr70YVUnesQVqJte5NWhbZ+QsAaUYhGVR4nPOG2Xcmrje8tM5yVa
	 I/2iHJBel0LB0kRCdMagMmDVXz2oSsV1U/ezqi7g0L+NUpi74/iSXkbs6eakZ1nvkb
	 zuh7Yv1tjqwgFNIc5a0aSp/WJAG+UZi21oHJyIElRMyZvgn1Vcmp7QF019fIDC7BRi
	 Gf/pkDpJDxMVg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] dm-verity: add dm-verity keyring
Date: Fri, 16 Jan 2026 15:30:33 +0100
Message-Id: <20260116-work-dm-verity-keyring-v1-0-0d3de29b0618@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIlLamkC/x3MQQ6DIBBA0auYWXcM0EhKr9J0ATjqxIjNYGiN8
 e6lXb7F/wdkEqYM9+YAocKZ11ShLw3EyaeRkPtqMMpYpbXF9yoz9guW2m07zrQLpxHV7TqYztn
 YuQA1fgkN/PmPH8/q4DNhEJ/i9NstPm8kbbGtdihRw3l+AdrvjhaLAAAA
X-Change-ID: 20260116-work-dm-verity-keyring-083f2596c59b
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, dm-devel@lists.linux.dev, 
 Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-a6db3
X-Developer-Signature: v=1; a=openpgp-sha256; l=13902; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7t6K2sEMtp9ouD77aifBltaLlqzqghE7V5PqGMRbVNQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRmeW/J8FCo2Kxponro2jcuE6G2Sz1mmqIX0i4G8J5h/
 jap0Pd5RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQynRkZLlz76HD082evuw3G
 0sopvnW7t7zPrBBxetJrrRa0Y1HNZUaGn/7z/mbrVl/hlb3zLmhe7aMnRxT4F/tefRTwN5lDdHo
 1CwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add a dedicated ".dm-verity" keyring for root hash signature
verification, similar to the ".fs-verity" keyring used by fs-verity.

By default the keyring is unused retaining the exact same old behavior.
For systems that provision additional keys only intended for dm-verity
images during boot, the dm_verity.keyring_unsealed=1 kernel parameter
leaves the keyring open.

We want to use this in systemd as a way add keys during boot that are
only used for creating dm-verity devices for later mounting and nothing
else. The discoverable disk image (DDI) spec at [1] heavily relies on
dm-verity and we would like to expand this even more. This will allow us
to do that in a fully backward compatible way.

Once provisioning is complete, userspace restricts and activates it for
dm-verity verification. If userspace fully seals the keyring then it
gains the guarantee that no new keys can be added.

Selftests included:

user1@localhost:~/data/kernel/linux/tools/testing/selftests/dm-verity$ sudo ./test-dm-verity-keyring.sh
[INFO] === dm-verity keyring test ===
[INFO]
[INFO] Work directory: /tmp/dm-verity-test.6pZgfJ
[INFO] Checking requirements...
[INFO] Using OpenSSL for PKCS#7 signatures
[INFO]
[INFO] ========================================
[INFO] === TEST MODE: UNSEALED KEYRING ===
[INFO] ========================================
[INFO]
[INFO] Loading dm-verity module with keyring_unsealed=1 require_signatures=1
[INFO] Unloading existing dm-verity module...
[INFO] Found .dm-verity keyring: 27532829
[INFO] Module parameters:
[INFO]   keyring_unsealed=Y
[INFO]   require_signatures=Y
[INFO] Keyring status:
  Keyring ID: 27532829
Keyring
  27532829 --a-swrv      0     0  keyring: .dm-verity
01a41e1d I------     1 perm 082f0000     0     0 keyring   .dm-verity: empty
[INFO]
[INFO] TEST: Multiple keys in keyring
[INFO] Generating key pair: vendor-a
[INFO] Generating key pair: vendor-b
[INFO] Generating key pair: vendor-c
[INFO] Uploading key 'vendor-a' to keyring...
[INFO] Key 'vendor-a' uploaded with ID: 271225594
[INFO] Uploading key 'vendor-b' to keyring...
[INFO] Key 'vendor-b' uploaded with ID: 293778700
[INFO] Uploading key 'vendor-c' to keyring...
[INFO] Key 'vendor-c' uploaded with ID: 147304219
[INFO]
[INFO] Keys in keyring before sealing:
[INFO] Keys in .dm-verity keyring:
  3 keys in keyring:
  271225594: --als--v     0     0 asymmetric: vendor-a
  147304219: --als--v     0     0 asymmetric: vendor-c
  293778700: --als--v     0     0 asymmetric: vendor-b
[INFO] Key details:
  Key 3:
[INFO] Keyring status:
  Keyring ID: 27532829
Keyring
  27532829 --a-swrv      0     0  keyring: .dm-verity
 271225594 --als--v      0     0   \_ asymmetric: vendor-a
 147304219 --als--v      0     0   \_ asymmetric: vendor-c
 293778700 --als--v      0     0   \_ asymmetric: vendor-b
01a41e1d I------     1 perm 082f0000     0     0 keyring   .dm-verity: 3
[INFO]
[INFO] Sealing the .dm-verity keyring...
[INFO] Keyring sealed successfully
[INFO]
[INFO] Keys in keyring after sealing:
[INFO] Keys in .dm-verity keyring:
  3 keys in keyring:
  271225594: --als--v     0     0 asymmetric: vendor-a
  147304219: --als--v     0     0 asymmetric: vendor-c
  293778700: --als--v     0     0 asymmetric: vendor-b
[INFO] Key details:
  Key 3:
[INFO] Keyring status:
  Keyring ID: 27532829
Keyring
  27532829 --a-swrv      0     0  keyring: .dm-verity
 271225594 --als--v      0     0   \_ asymmetric: vendor-a
 147304219 --als--v      0     0   \_ asymmetric: vendor-c
 293778700 --als--v      0     0   \_ asymmetric: vendor-b
01a41e1d I------     1 perm 082f0000     0     0 keyring   .dm-verity: 3
[PASS] Key upload and keyring sealing succeeded
[INFO]
[INFO] Creating test device images...
[INFO] Data device: /dev/loop0
[INFO] Hash device: /dev/loop1
[INFO] Creating dm-verity hash tree...
[INFO] Root hash: 6d55b4aaed08b738d3bf8340a2da2393f1492b8c10fbbab6cb9f9be432d67202
[INFO]
[INFO] Sub-test: Verify with vendor-a key
[INFO] Root hash (hex): 6d55b4aaed08b738d3bf8340a2da2393f1492b8c10fbbab6cb9f9be432d67202
[INFO] Root hash hex string size: 64 bytes
[INFO] Signed with certificate:
  subject=CN=dm-verity-test-vendor-a
[INFO] Local signature verification: PASSED
[INFO] Activating dm-verity device with signature...
[INFO] Kernel messages:
  [ 7116.491826] audit: type=1338 audit(1768573436.899:720): module=verity op=ctr ppid=11286 pid=11399 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" dev=253:0 error_msg='success' res=1
  [ 7116.525233] audit: type=1300 audit(1768573436.899:720): arch=c000003e syscall=16 success=yes exit=0 a0=6 a1=c138fd09 a2=564631524510 a3=5011b697c01be617 items=8 ppid=11286 pid=11399 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" key=(null)
  [ 7116.540295] audit: type=1307 audit(1768573436.899:720): cwd="/home/user1/data/kernel/linux/tools/testing/selftests/dm-verity"
[PASS] Verification with vendor-a key succeeded
[INFO]
[INFO] Sub-test: Verify with vendor-b key
[INFO] Root hash (hex): 6d55b4aaed08b738d3bf8340a2da2393f1492b8c10fbbab6cb9f9be432d67202
[INFO] Root hash hex string size: 64 bytes
[INFO] Signed with certificate:
  subject=CN=dm-verity-test-vendor-b
[INFO] Local signature verification: PASSED
[INFO] Activating dm-verity device with signature...
[PASS] Verification with vendor-b key succeeded
[INFO]
[INFO] Sub-test: Verify with vendor-c key
[INFO] Root hash (hex): 6d55b4aaed08b738d3bf8340a2da2393f1492b8c10fbbab6cb9f9be432d67202
[INFO] Root hash hex string size: 64 bytes
[INFO] Signed with certificate:
  subject=CN=dm-verity-test-vendor-c
[INFO] Local signature verification: PASSED
[INFO] Activating dm-verity device with signature...
[PASS] Verification with vendor-c key succeeded
[INFO]
[INFO] Sub-test: Verify with unknown key (should fail)
[INFO] Generating key pair: unknown-vendor
[INFO] Root hash (hex): 6d55b4aaed08b738d3bf8340a2da2393f1492b8c10fbbab6cb9f9be432d67202
[INFO] Root hash hex string size: 64 bytes
[INFO] Signed with certificate:
  subject=CN=dm-verity-test-unknown-vendor
[INFO] Local signature verification: PASSED
[INFO] Activating dm-verity device with signature...
device-mapper: reload ioctl on verity-test-11286 (253:0) failed: Required key not available
[INFO] Kernel messages:
  [ 7121.271149] device-mapper: table: 253:0: verity: Root hash verification failed (-ENOKEY)
[PASS] Verification with unknown key correctly rejected
[INFO]
[PASS] Multiple keys test completed successfully
[INFO]
[INFO] TEST: Verify sealed keyring rejects key additions
[INFO] Generating signing key pair...
[INFO] Certificate details:
        Issuer: CN=dm-verity-test-key
        Subject: CN=dm-verity-test-key
            X509v3 Key Usage:
[INFO] Keys generated successfully
[PASS] Sealed keyring correctly rejected key addition
[INFO]
[INFO] TEST: Verify corrupted signatures are rejected
[INFO] Sub-test: Truncated signature (should fail)
[INFO] Activating dm-verity device with signature...
device-mapper: reload ioctl on verity-test-11286 (253:0) failed: Bad message
[INFO] Kernel messages:
  [ 7121.896207] audit: type=1338 audit(1768573442.327:727): module=verity op=ctr ppid=11286 pid=11530 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" dev=253:0 error_msg='Root hash verification failed' res=0
  [ 7121.896333] device-mapper: table: 253:0: verity: Root hash verification failed (-EBADMSG)
  [ 7121.899944] audit: type=1338 audit(1768573442.327:727): module=verity op=dtr ppid=11286 pid=11530 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" dev=253:0 error_msg='success' res=1
  [ 7121.914639] audit: type=1300 audit(1768573442.327:727): arch=c000003e syscall=16 success=no exit=-74 a0=6 a1=c138fd09 a2=560615c9f3d0 a3=6f558aa5a313577d items=0 ppid=11286 pid=11530 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" key=(null)
[PASS] Truncated signature correctly rejected
[INFO] Sub-test: Corrupted signature bytes (should fail)
[INFO] Activating dm-verity device with signature...
device-mapper: reload ioctl on verity-test-11286 (253:0) failed: Required key not available
[INFO] Kernel messages:
  [ 7122.265626] audit: type=1338 audit(1768573442.695:728): module=verity op=ctr ppid=11286 pid=11549 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" dev=253:0 error_msg='Root hash verification failed' res=0
  [ 7122.265742] device-mapper: table: 253:0: verity: Root hash verification failed (-ENOKEY)
  [ 7122.279242] audit: type=1338 audit(1768573442.695:728): module=verity op=dtr ppid=11286 pid=11549 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" dev=253:0 error_msg='success' res=1
  [ 7122.301838] audit: type=1300 audit(1768573442.695:728): arch=c000003e syscall=16 success=no exit=-126 a0=6 a1=c138fd09 a2=5614e8dd3510 a3=b8e8a86e4465fecd items=0 ppid=11286 pid=11549 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" key=(null)
[PASS] Corrupted signature correctly rejected
[INFO] Sub-test: Signature over wrong data (should fail)
[INFO] Activating dm-verity device with signature...
device-mapper: reload ioctl on verity-test-11286 (253:0) failed: Key was rejected by service
[INFO] Kernel messages:
  [ 7122.570453] audit: type=1338 audit(1768573442.999:729): module=verity op=ctr ppid=11286 pid=11564 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" dev=253:0 error_msg='Root hash verification failed' res=0
  [ 7122.570706] device-mapper: table: 253:0: verity: Root hash verification failed (-EKEYREJECTED)
  [ 7122.583491] audit: type=1338 audit(1768573442.999:729): module=verity op=dtr ppid=11286 pid=11564 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts3 ses=4294967295 comm="veritysetup" exe="/usr/sbin/veritysetup" dev=253:0 error_msg='success' res=1
[PASS] Signature over wrong data correctly rejected
[PASS] Corrupted signature test completed successfully
[INFO]
[INFO] ========================================
[INFO] === TEST MODE: SEALED KEYRING (default) ===
[INFO] ========================================
[INFO]
[INFO] Loading dm-verity module with keyring_unsealed=0 require_signatures=0
[INFO] Unloading existing dm-verity module...
[INFO] Found .dm-verity keyring: 30758673
[INFO] Module parameters:
[INFO]   keyring_unsealed=N
[INFO]   require_signatures=N
[INFO] Keyring status:
  Keyring ID: 30758673
Keyring
  30758673 --a-swrv      0     0  keyring: .dm-verity
01d55711 I------     1 perm 082f0000     0     0 keyring   .dm-verity: empty
[INFO]
[INFO] TEST: Verify keyring is sealed by default (keyring_unsealed=0)
[INFO] Current keyring state (should be empty and sealed):
[INFO] Keys in .dm-verity keyring:
  (empty)
[INFO] Keyring status:
  Keyring ID: 30758673
Keyring
  30758673 --a-swrv      0     0  keyring: .dm-verity
01d55711 I------     1 perm 082f0000     0     0 keyring   .dm-verity: empty
[INFO] Generating signing key pair...
[INFO] Certificate details:
        Issuer: CN=dm-verity-test-key
        Subject: CN=dm-verity-test-key
            X509v3 Key Usage:
[INFO] Keys generated successfully
[INFO] Attempting to add key to sealed keyring...
[PASS] Keyring is correctly sealed when keyring_unsealed=0
[INFO] Keyring state after failed add attempt:
[INFO] Keys in .dm-verity keyring:
  (empty)
[INFO]
[INFO] TEST: Verify dm-verity keyring is inactive when sealed empty
[INFO] Keyring state (should be empty and sealed):
[INFO] Keys in .dm-verity keyring:
  (empty)
[INFO] Keyring status:
  Keyring ID: 30758673
Keyring
  30758673 --a-swrv      0     0  keyring: .dm-verity
01d55711 I------     1 perm 082f0000     0     0 keyring   .dm-verity: empty
[INFO] Creating test device images...
[INFO] Data device: /dev/loop0
[INFO] Hash device: /dev/loop1
[INFO] Creating dm-verity hash tree...
[INFO] Root hash: 2a905b81a24ea25ae6e90ce250bfe770407605b2eb6822e4a0f9d7c728357ff7
[INFO] Sub-test: Device activation with sealed empty keyring
[INFO] Activating dm-verity device without signature...
[PASS] Device activated (require_signatures=0, empty dm-verity keyring is inactive)
[INFO]
[INFO] ========================================
[INFO] === All tests PASSED ===
[INFO] ========================================
[INFO] Cleaning up...

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
Christian Brauner (2):
      dm-verity: add dm-verity keyring
      selftests: add dm-verity keyring selftests

 Documentation/admin-guide/kernel-parameters.txt    |   7 +
 drivers/md/dm-verity-target.c                      |  20 +-
 drivers/md/dm-verity-verify-sig.c                  |  45 ++
 drivers/md/dm-verity-verify-sig.h                  |  12 +
 tools/testing/selftests/dm-verity/Makefile         |   5 +
 tools/testing/selftests/dm-verity/config           |  10 +
 .../selftests/dm-verity/test-dm-verity-keyring.sh  | 873 +++++++++++++++++++++
 7 files changed, 971 insertions(+), 1 deletion(-)
---
base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
change-id: 20260116-work-dm-verity-keyring-083f2596c59b

