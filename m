Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E009439F95
	for <dm-devel@lists.linux.dev>; Thu,  8 Oct 2026 20:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493089; cv=none; b=sgWE2Zw43YP0kzqD3H270ETjkvvOR+ljjEd57gUXabQLClHklp8t7/344aZr1lbV+l+/45oi9xXwQfXfNc5fmImtCs9MUqVvBdC5/XbKsyO94w308ORQ0bcmNqXVkLLpSKyjGRQ2N93F3iv9Kb+17JrQ+CnnwZUn8ohUleWWyU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493089; c=relaxed/simple;
	bh=lxnDd9jiT8/uf38YlJYM5s8pSRZWKWNNi60TeeMLZQo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gnms3dTaCrvZ2b99MWDmJHDWiF/bYyqLeO+OvxxyKMtmrpk1eD4mLs6P4qJG951EitDnm4CwFqxpxjitzH3iqpnbqMkmdEmTAvRlsg8AdwRGnZQAtylcmAn7qUnqfcTPScyUs6V/AfGY3qtlTMvA5mkNVsDf4+lRNYjotV+SYXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=XzUmX1RD; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="XzUmX1RD"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-679334baa1fso260149d50.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Oct 2026 13:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1791493085; x=1792097885; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ciuw8SG86OL3CgNS6+5Yp30la1usDGOBoesGMV+/TMU=;
        b=XzUmX1RDfqU8cdr0oMaeZul/V3BmMltCK1Wu1FrsUWejHtaND9ZvvY0HN92YBaERDz
         0w6XvH5sEMbhGULmo6P9AQK3fZMWivCZFeoP3+MZZhaGLNfN2fCNxwfkdqXufZVdGZu5
         M+OWaIDy3TPf/s9NtqtGnTGBBTngU8W9PjRJL1QVEs2Yw4FnxzTnvoBOcHnpHYOQbiwr
         ap1aavF+9hdyluQg3pme6hsM8dEoviGxxSLL7bnzRajSwipS42ipn5IfuAak2O54lVl2
         z+aMahfMFc5ChrBsspmIc7caG/9LzfC4vXV2mNJlNPItcC8ygmIZNuTLU2Pb8Skj/O12
         JdoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493085; x=1792097885;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ciuw8SG86OL3CgNS6+5Yp30la1usDGOBoesGMV+/TMU=;
        b=BaUxH872itKEtWY+ojU+Zd/Ja16rneHBNDxcroU+DG/PvjiJMjSEaLJEicE6MdS/eh
         nFeqFvdDBpSwCF14Fc5fpkkBRgwkAhagX68xxKcuWpJag0NYig6AQn4/KD3S0uNvANjm
         dPZQQpMqLLiDwOYD6Y7cugOo1nJs9hV0U09hKcOtj2spMshiQUHnQ4kyr0V8EhyEQfjb
         mjcouqxqjUYSkCofWM6gyYp4KfLTGZyRLONSDdBZ0dRXThhmqdJUPH3B4IWpIuqKKAAj
         JAk41+aDw1+agHOQ3Xt8MD6K2Govslohkee+s5qzIJTVNc+eQ0u4Oj+OHs1+ZbJlYNx7
         Cyqw==
X-Gm-Message-State: AFq9FYKP1HCEyvVG/QrqZDvNqRpcy4jcU0+H2nuJBLbh0h+YwJv+27ZB
	xtqYqNJzJSdcDqxlCzAFqNUFDMsSB/O0aJeB2WAE+ODlBfWTI5nfz0XNzwwSgliW0+kZ
X-Gm-Gg: AYBFou1atvnJKRdXIicIRQvNdjPNgTIuNzuAWornHaXPq5/z6+dSB1uCxqD42nDpHyM
	tAhOh9GD0ptEi6ZtmyEzf+dHGO/5pRUf25FutacVzWPDWRcVQf9SytLV2hkrBxqY9oS27uPVQrZ
	2R9G1jgw5Wruean8YmS1R/BFMq5/DRpUeY44zkJwSuS2bxno6269lbw3hcEMsm/0hvy9zaMpuKd
	Nx+22dg+0GrKcL6fRL8aEw8nNYTkwSqtlYH+j8az1CRLRX2X43qUI0mog2n3lGY3JU/WzSRWcP5
	+w6lb4bDbhJOkYdxoiz4N05Sz73PZdJ4+KfWz9TbbC4kEV/jlkdrJ0DWXcoXd5gOIbe5xHywIDj
	q6n05lgBsmHGNG8vNin/dwvN6tcEY/ydBJd5Tum38LTGdODek36NxLAG+IRqWf3v7BTyNzOfgWi
	uN8KkBxOL54KSXLIVRNWDq/k9dToiPESs2MoRBuCno2aARzK6uG3D4CNk/kJpyTES29JChp4LPV
	WYCdKXUJgzZ3feEZrnUPJJScwGa8VxgqCNja52MQEdiapigADl29RgjDG3YSiP9LA==
X-Received: by 2002:a05:690e:b82:b0:677:c0b6:ae45 with SMTP id 956f58d0204a3-67936339707mr14916d50.146.1791493085335;
        Thu, 08 Oct 2026 13:58:05 -0700 (PDT)
Received: from [192.168.1.110] (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67935707401sm78814d50.24.2026.10.08.13.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 13:58:04 -0700 (PDT)
From: Andrew Halaney <andrew@amutable.com>
Date: Thu, 08 Oct 2026 15:57:35 -0500
Subject: [PATCH bpf-next v2 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-ajhalaney-dmverity-key-identifier-v2-1-008456d189cb@amutable.com>
References: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
In-Reply-To: <20261008-ajhalaney-dmverity-key-identifier-v2-0-008456d189cb@amutable.com>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Eric Biggers <ebiggers@kernel.org>, 
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 bpf@vger.kernel.org, fsverity@lists.linux.dev, linux-doc@vger.kernel.org, 
 Andrew Halaney <andrew@amutable.com>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.14.3

The .dm-verity keyring is not linked into any process keyring, so
request_key() and KEYCTL_SEARCH cannot find it. Userspace has to scrape
/proc/keys for the serial to use.

That's not great, one could put in a bogus description containing
a newline to confuse userspace further. For example, thanks to AI
models, which I run as root but you could show off as any old user:

    # DESC=$'.dm-verity: 1\n0badf00d I--Q---     1 perm 082f0000     0     0 keyring   .dm-verity'
    # k=$(echo -n "1234567" | keyctl padd user "$DESC" @s)
    # keyctl setperm "$k" 0x3f010001

    # cat /proc/keys | grep dm-verity
    10402023 I------     2 perm 082f0000     0     0 keyring   .dm-verity: empty
    12e0bee6 I--Q---     1 perm 3f010001     0     0 user      .dm-verity: 1
    0badf00d I--Q---     1 perm 082f0000     0     0 keyring   .dm-verity: 7

0x0badf00d is not a keyring, it is the text inside our user's key
description. Telling the two apart needs a KEYCTL_DESCRIBE per row
which is annoying to do. i.e.:

    # keyctl rdescribe 0x10402023
    keyring;0;0;082f0000;.dm-verity
    # keyctl rdescribe 0x0badf00d
    keyctl_describe: Required key not available

Let's just give it a well known identifier, i.e.:

    # keyctl rdescribe -10
    keyring;0;0;082f0000;.dm-verity

This is exactly what
commit 264d8fd2794f ("bpf, keys: Add a bpf keyring for program signature validation")
did, and was the inspiration for this commit minus the spinlock bits
required due to dm-verity being a module.

Suggested-by: Christian Brauner (Amutable) <brauner@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Andrew Halaney <andrew@amutable.com>
---
 drivers/md/dm-verity-verify-sig.c |  3 +++
 include/linux/key.h               |  1 +
 include/uapi/linux/keyctl.h       |  1 +
 security/keys/process_keys.c      | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index b2b55c41e2cb..da509dcdd7e5 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -189,11 +189,14 @@ int __init dm_verity_verify_sig_init(void)
 	    keyring_restrict(make_key_ref(dm_verity_keyring, true), NULL, NULL))
 		panic("dm-verity can't seal keyring\n");
 
+	key_register_dm_verity_keyring(dm_verity_keyring);
+
 	return 0;
 }
 
 void dm_verity_verify_sig_exit(void)
 {
+	key_register_dm_verity_keyring(NULL);
 	key_revoke(dm_verity_keyring);
 	key_put(dm_verity_keyring);
 }
diff --git a/include/linux/key.h b/include/linux/key.h
index bd10fe45819d..ae8d3314fd93 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -441,6 +441,7 @@ extern int keyring_restrict(key_ref_t keyring, const char *type,
 			    const char *restriction);
 
 extern void key_register_bpf_keyring(struct key *keyring);
+extern void key_register_dm_verity_keyring(struct key *keyring);
 
 extern struct key *key_lookup(key_serial_t id);
 
diff --git a/include/uapi/linux/keyctl.h b/include/uapi/linux/keyctl.h
index fa85b9760391..75923941f1b3 100644
--- a/include/uapi/linux/keyctl.h
+++ b/include/uapi/linux/keyctl.h
@@ -25,6 +25,7 @@
 #define KEY_SPEC_REQKEY_AUTH_KEY	-7	/* - key ID for assumed request_key auth key */
 #define KEY_SPEC_REQUESTOR_KEYRING	-8	/* - key ID for request_key() dest keyring */
 #define KEY_SPEC_BPF_KEYRING		-9	/* - key ID for the BPF-specific keyring */
+#define KEY_SPEC_DM_VERITY_KEYRING	-10	/* - key ID for the .dm-verity keyring */
 
 /* request-key default keyrings */
 #define KEY_REQKEY_DEFL_NO_CHANGE		-1
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 44358388e395..dba3df41638b 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -25,6 +25,10 @@ static DEFINE_MUTEX(key_session_mutex);
 /* BPF keyring reachable through KEY_SPEC_BPF_KEYRING */
 static struct key *bpf_keyring __ro_after_init;
 
+/* dm-verity keyring reachable through KEY_SPEC_DM_VERITY_KEYRING */
+static struct key *dm_verity_keyring;
+static DEFINE_SPINLOCK(dm_verity_keyring_lock);
+
 /* The root user's tracking struct */
 struct key_user root_key_user = {
 	.usage		= REFCOUNT_INIT(3),
@@ -607,6 +611,24 @@ void key_register_bpf_keyring(struct key *keyring)
 	bpf_keyring = keyring;
 }
 
+/**
+ * key_register_dm_verity_keyring - Publish the keyring for KEY_SPEC_DM_VERITY_KEYRING
+ * @keyring: The keyring to publish, or NULL to withdraw it
+ *
+ * Make @keyring reachable by userspace through the KEY_SPEC_DM_VERITY_KEYRING
+ * special key ID, so that provisioning it does not require scraping its
+ * serial out of /proc/keys first. dm-verity can be unloaded as a module
+ * and the keyring deregistered, as such serialize access with
+ * dm_verity_keyring_lock.
+ */
+void key_register_dm_verity_keyring(struct key *keyring)
+{
+	spin_lock(&dm_verity_keyring_lock);
+	dm_verity_keyring = keyring;
+	spin_unlock(&dm_verity_keyring_lock);
+}
+EXPORT_SYMBOL_GPL(key_register_dm_verity_keyring);
+
 /*
  * Look up a key ID given us by userspace with a given permissions mask to get
  * the key it refers to.
@@ -766,6 +788,17 @@ key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
 		key_ref = make_key_ref(key, 0);
 		break;
 
+	case KEY_SPEC_DM_VERITY_KEYRING:
+		spin_lock(&dm_verity_keyring_lock);
+		key = dm_verity_keyring;
+		if (key)
+			__key_get(key);
+		spin_unlock(&dm_verity_keyring_lock);
+		if (!key)
+			goto error;
+		key_ref = make_key_ref(key, 0);
+		break;
+
 	default:
 		key_ref = ERR_PTR(-EINVAL);
 		if (id < 1)

-- 
2.55.0

