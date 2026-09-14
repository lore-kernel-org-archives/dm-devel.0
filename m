Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5ED34389C
	for <dm-devel@lists.linux.dev>; Mon, 14 Sep 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404125; cv=none; b=YI808GDf8fmdDc7lAE48jixKrMHuK/8o+xd49pfEwC/miJyZsAR2whQgrFYCuXjRkcb6anMJyoC8a9W/VZp3JJUVi8dVpRUnzhScvAfFDWVRxK2nhbnhC6TSMOn+fyH3KnZ7UAcvtKJvsueYGMof3Hi2+VNzNT452AtU0RHqfUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404125; c=relaxed/simple;
	bh=+N9ZKaZxeybEwISedHcLFR5weaHCuqwm361zoPMxU4M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LxjApIEyCnw00p0REfBGgBDQIyfsoNo52Jq3jmzeDuKK5RktL4QvnncSNKOaWb7uLzJU3q5U6VT8G/q1g7iHmz5Asvr+MIwm18P6T3h3uQhwh0QtRQUDyVd83NyKoqqaBt8KrMb677Qf+kOB0lTPHZQGKJsVaL2rgHue98egXFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com; spf=pass smtp.mailfrom=amutable.com; dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b=lAabXu8t; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20251104.gappssmtp.com header.i=@amutable-com.20251104.gappssmtp.com header.b="lAabXu8t"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66c7e3a2332so2585429d50.2
        for <dm-devel@lists.linux.dev>; Mon, 14 Sep 2026 09:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20251104.gappssmtp.com; s=20251104; t=1789404122; x=1790008922; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SfEDwKZx2Ac2Zov3iFEW2DHPNztOR7nlXE153PDtqAw=;
        b=lAabXu8tERlDuVppDuowGTcU6DclMr3r018TlbDhfailjAQgq4Gj31xHf+tF5tGwAA
         pHiWG8x5mRUBOPaMq+tvehcnWoZEI1oK2vUx3jlbaPCFvi4pxpx0WWF2af0WCjAUAFUX
         MroviC6LuRDnqpOZkBhIcq5QeKDYZGxTDaQv6z5bq7AOIga95c6VQQi7SBH97C7HNcre
         1lcP960LM5p9oQ4ZrOJZN8OaaoMZYiROFXqKmJ5Zz4SKzvGgthLXIFD8ijM7AhQckgEk
         8SYygtmjImKhJPcxPeSXG2JiPmHWdXHTZC0ce18fRExyti23XX4dHx4GV2MaJb+PhnxX
         LJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789404122; x=1790008922;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SfEDwKZx2Ac2Zov3iFEW2DHPNztOR7nlXE153PDtqAw=;
        b=EjicH0xcdWWr+OyU+sysfDNysnywH8Dm+5p7PeB45wUYM7k97N9LMohTwP84NZCo2o
         1RJUukysUF4R6HX5QeNU8Lg7rRGeyv9zFxaCXjxMU2RAuLWruthDk08RJn6ng7qc6ZAV
         XL+SjgSfArBxWnHcP4MhB1M7CI2yWp+1qZZaH215QZLMpMReUEIOx48xwz59i/9WhGM7
         zqjEYrb2mwmP7AfLCl0xlg82ncVX7xoByjIBPoc58Q+qNffl9eJbvM9hiIdCgNGdfkfx
         5S0ih+3PPFfSdOinpvZIbGXNG06H9yAiHmtyejqAXh15nt/Shk8DXx86rcbU8Eo2DTeI
         8X7Q==
X-Gm-Message-State: AFuF++kUh7tLZTw4ypsEkJRmRYEAp1O0RywqF1dhbJJFpQhvejOuREy/
	obrF0VLOgqLlfVtv3ZdtR26wrFaGktRQziXtHfRZ2wWZRc9C4+KKCv5S9VlCXKKYX+9k
X-Gm-Gg: AYBFou3Ut9uSzaEAg41B8UhTHrPfoJfcVBd1mFbmXfeiXzDHskpxzgIS71cMX/BAIhl
	bdu97PfDJWgZgr2UJrke8/PtAuZwA9WZDT35BZ3xxO6OaFotplL3mxsE2WQKGWlUdAHHvL8fgxI
	gdRyhXRgwFilZOznOVfLk6lfP3tSgKMli/GJgHqBOsZnFYuVrYE4iRh1nek1zAmUO8Lp4dJFvjm
	NHSE7Y8qDG8C33qefT8b+m27R94aoiU/kjm53exZt6bHIas/a3nNn2GQ4eN43f2kY1qLKI1vbuA
	fQ8Nvm09k18DKje64m4nMFeDpRqFUVdnHozCSd1eBZvKpniNfTifI+/EXJDJwXf4lOI1uU1ojlE
	pDhqCLAO0PpsbNGWbK8uy/qxtWX0LjfrIvP/x9ekSAY7HG1GMvIZi9fJsA/kRHmIhuemeII4H43
	EucrjNqYkzJNbUpWxTBV1f6xFJRp3IYJh6LcSzf45a+tVo1NrrRFvv2eGdKWQ+RA==
X-Received: by 2002:a53:ac83:0:b0:66f:c1bc:c097 with SMTP id 956f58d0204a3-6714e1a194cmr1022205d50.95.1789404121718;
        Mon, 14 Sep 2026 09:42:01 -0700 (PDT)
Received: from [192.168.1.110] ([2600:1700:1ff0:d0ef::d15])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67125df42a8sm4879023d50.8.2026.09.14.09.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 09:42:01 -0700 (PDT)
From: Andrew Halaney <andrew@amutable.com>
Date: Mon, 14 Sep 2026 11:41:42 -0500
Subject: [PATCH 1/3] keys: add KEY_SPEC_DM_VERITY_KEYRING
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-ajhalaney-dmverity-key-identifier-v1-1-01922dc1366a@amutable.com>
References: <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
In-Reply-To: <20260914-ajhalaney-dmverity-key-identifier-v1-0-01922dc1366a@amutable.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
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

