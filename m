Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8896A1096A
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 06:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Vg9KQKLy"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-35d7cc7cabcso10295745ab.1
        for <dm-devel@lists.linux.dev>; Tue, 05 Dec 2023 22:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1701842794; x=1702447594; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHSvpgHbJd6Eu7qsv8V2o7uK7jb6cBWSzdjaYC45cFQ=;
        b=Vg9KQKLyoQu2vCP1OAsk53niZbBb9yi7bH0qqUuFalJWn0mxnrJPyJPHKSBe7e98oR
         63li+bnmyFehs98kc0qNFTb9C82I1FvHij7l74GQfBOu6mWquxD3i0TXjn3IMRybJU4N
         myPAtIb5DyWQqNT8yUopxuh8Wp1FUID6FbecETrPWFe3jrQWwmKIG8saaG4VqwIdvaLg
         fuBHi2QJECd+CNIQ4scrSzI5IlJqKngy4RT51VvsEnszsJSfp21OAPbIECqUeABl2FKP
         ec6Lphto0avStuhOEoaFmlfJszQxElUY9EieHBX0lC3LrJf3jfIE9qrpqup9MDVTLAK9
         srNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701842794; x=1702447594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wHSvpgHbJd6Eu7qsv8V2o7uK7jb6cBWSzdjaYC45cFQ=;
        b=cBC8JhCty/wt1eP5eA+fgCbRcymyYh+p6OLgmrsfcXi4vR7KhorxdX+Dxuc2ll/wPL
         ijTpOMxbfj835YcKToytTBXjg8+ykEgD4CAlfazazoLn1vMFgGmpX8OSM5cjcAj/mT8I
         ZRq9jYGDIq8AfVH3VVvS4AkEZjk/wF82chf0BmfRDUG82m3oYlmFf3spjD6a5h2mBQ3P
         DH+vHkIzMpT/9I1GxyK5Xylfr9D1CBLWAnHFYAgTkFeQRlIyicS/dAJifPVyNEB/IsCZ
         TmtAnvTy3kMGOp9y5vY1ImIMSOIb+UL/j9b+gKaYI8KwGflNyUwbJG91nbBm45Oijw+9
         wa4g==
X-Gm-Message-State: AOJu0YwphV5vAW+rlSt4Gfh+462ROD24zNertCFNZQyE0j2PxsR+YoLE
	6flt9ZCvk9QwcQryoSPq8KaC1w==
X-Google-Smtp-Source: AGHT+IFyEkydutbRflbUebHhG6N121DmGV5SoFJedHB237+BvShkltfvd92qMh3rpX3+xBNwHz7Raw==
X-Received: by 2002:a05:6e02:13e8:b0:35d:6a39:faeb with SMTP id w8-20020a056e0213e800b0035d6a39faebmr517082ilj.10.1701842794477;
        Tue, 05 Dec 2023 22:06:34 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id i123-20020a639d81000000b005c662e103a1sm6488754pgd.41.2023.12.05.22.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 22:06:33 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rAl3I-004VOv-0L;
	Wed, 06 Dec 2023 17:06:31 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rAl3H-0000000BrVQ-2oA0;
	Wed, 06 Dec 2023 17:06:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	linux-cachefs@redhat.com,
	dhowells@redhat.com,
	gfs2@lists.linux.dev,
	dm-devel@lists.linux.dev,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] vfs: factor out inode hash head calculation
Date: Wed,  6 Dec 2023 17:05:35 +1100
Message-ID: <20231206060629.2827226-7-david@fromorbit.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231206060629.2827226-1-david@fromorbit.com>
References: <20231206060629.2827226-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

In preparation for changing the inode hash table implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 3426691fa305..fead81550cf4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -59,6 +59,22 @@ static unsigned int i_hash_shift __ro_after_init;
 static struct hlist_head *inode_hashtable __ro_after_init;
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(inode_hash_lock);
 
+static unsigned long hash(struct super_block *sb, unsigned long hashval)
+{
+	unsigned long tmp;
+
+	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
+			L1_CACHE_BYTES;
+	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> i_hash_shift);
+	return tmp & i_hash_mask;
+}
+
+static inline struct hlist_head *i_hash_head(struct super_block *sb,
+		unsigned int hashval)
+{
+	return inode_hashtable + hash(sb, hashval);
+}
+
 /*
  * Empty aops. Can be used for the cases where the user does not
  * define any of the address_space operations.
@@ -502,16 +518,6 @@ static inline void inode_sb_list_del(struct inode *inode)
 		dlock_lists_del(&inode->i_sb_list);
 }
 
-static unsigned long hash(struct super_block *sb, unsigned long hashval)
-{
-	unsigned long tmp;
-
-	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
-			L1_CACHE_BYTES;
-	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> i_hash_shift);
-	return tmp & i_hash_mask;
-}
-
 /**
  *	__insert_inode_hash - hash an inode
  *	@inode: unhashed inode
@@ -1187,7 +1193,7 @@ struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
 			    int (*test)(struct inode *, void *),
 			    int (*set)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+	struct hlist_head *head = i_hash_head(inode->i_sb, hashval);
 	struct inode *old;
 
 again:
@@ -1291,7 +1297,7 @@ EXPORT_SYMBOL(iget5_locked);
  */
 struct inode *iget_locked(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct hlist_head *head = i_hash_head(sb, ino);
 	struct inode *inode;
 again:
 	spin_lock(&inode_hash_lock);
@@ -1359,7 +1365,7 @@ EXPORT_SYMBOL(iget_locked);
  */
 static int test_inode_iunique(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *b = inode_hashtable + hash(sb, ino);
+	struct hlist_head *b = i_hash_head(sb, ino);
 	struct inode *inode;
 
 	hlist_for_each_entry_rcu(inode, b, i_hash) {
@@ -1446,7 +1452,7 @@ EXPORT_SYMBOL(igrab);
 struct inode *ilookup5_nowait(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct hlist_head *head = i_hash_head(sb, hashval);
 	struct inode *inode;
 
 	spin_lock(&inode_hash_lock);
@@ -1501,7 +1507,7 @@ EXPORT_SYMBOL(ilookup5);
  */
 struct inode *ilookup(struct super_block *sb, unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct hlist_head *head = i_hash_head(sb, ino);
 	struct inode *inode;
 again:
 	spin_lock(&inode_hash_lock);
@@ -1550,7 +1556,7 @@ struct inode *find_inode_nowait(struct super_block *sb,
 					     void *),
 				void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct hlist_head *head = i_hash_head(sb, hashval);
 	struct inode *inode, *ret_inode = NULL;
 	int mval;
 
@@ -1595,7 +1601,7 @@ EXPORT_SYMBOL(find_inode_nowait);
 struct inode *find_inode_rcu(struct super_block *sb, unsigned long hashval,
 			     int (*test)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct hlist_head *head = i_hash_head(sb, hashval);
 	struct inode *inode;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
@@ -1633,7 +1639,7 @@ EXPORT_SYMBOL(find_inode_rcu);
 struct inode *find_inode_by_ino_rcu(struct super_block *sb,
 				    unsigned long ino)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct hlist_head *head = i_hash_head(sb, ino);
 	struct inode *inode;
 
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
@@ -1653,7 +1659,7 @@ int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
 	ino_t ino = inode->i_ino;
-	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct hlist_head *head = i_hash_head(sb, ino);
 
 	while (1) {
 		struct inode *old = NULL;
-- 
2.42.0

