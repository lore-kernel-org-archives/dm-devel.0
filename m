Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0B918A6DB
	for <dm-devel@lists.linux.dev>; Sun, 17 Aug 2025 19:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755460186; cv=none; b=u4Qdh47gE0XzKzWGW6S59MImziedR0kGZDU9VWvJdL+u6d5kQSneG4j1DNsZa3Bj3EqnWw21KfEa0DAMo0Qf0tt5N41g7fJeQx7m3Cd9HWF19Dn1+aLT1ImOcFEKOT1TFeWhh9rDVqEhy1qYPX00GSIbluAub8yrzJaxiAucxMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755460186; c=relaxed/simple;
	bh=4dPB9987j+f29VjAxK3KHofCF1n0ALa032h7JMh3n/c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=NpNZJa8/HRSmsKvc446xcKM+d1lgjfui+HBv3wZlf9JbqZEajYaZXmzIddkAHyJUrwbGJloVXw4IWW/uI517uv1poHb1Ml3lbS1xdU5wt7StYPeOOy0qMjOb6ZJzbfFMEoKaCKf3Tb+UB4gyo+iJ5glkKW5psUT4MXzE7rMJrOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KxkNhTpo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KxkNhTpo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755460182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9OPWpj3DC8NZc1yZ24CVADfv/jibxleiCU9+442vbxU=;
	b=KxkNhTpolbdG4OLYlPxBFyhqIAsR+cKXiLQxG5OBD0P9c1M3CzHL+BLmdAyk+AVYzCbku1
	KdEmXkCBEsWY8tLPiREmtO/kGWGQTKz2BZrTsOOgcA2hshe0/3ZI+SuJZ9ND7idsvD4kEY
	MOJhoQSUkSicXLfjJyd0mTtmnHzw4vg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-VNNtUMX_NpyI7tVauT61Xg-1; Sun,
 17 Aug 2025 15:49:40 -0400
X-MC-Unique: VNNtUMX_NpyI7tVauT61Xg-1
X-Mimecast-MFC-AGG-ID: VNNtUMX_NpyI7tVauT61Xg_1755460180
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB5A51800451;
	Sun, 17 Aug 2025 19:49:39 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.47.238.126])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 682331800282;
	Sun, 17 Aug 2025 19:49:38 +0000 (UTC)
From: Alex Kalenyuk <akalenyu@redhat.com>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com
Subject: [PATCH] Take undef enum into account for correct array index comparison
Date: Sun, 17 Aug 2025 22:49:23 +0300
Message-ID: <20250817194923.307911-1-akalenyu@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: knqMLbf4mdc3Z3z08J21-Bx4TpSObh6Q1rZPhot5tk0_1755460180
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Previously this would compare to the wrong index
since the enum has an additional UNDEF entry

Signed-off-by: Alex Kalenyuk <akalenyu@redhat.com>
---
 libmultipath/dict.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index a06a6138..2e820b2e 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -550,6 +550,7 @@ static int snprint_def_partition_delim(struct config *conf, struct strbuf *buff,
 }
 
 static const char * const find_multipaths_optvals[] = {
+	[FIND_MULTIPATHS_UNDEF] = "undef",
 	[FIND_MULTIPATHS_OFF] = "off",
 	[FIND_MULTIPATHS_ON] = "on",
 	[FIND_MULTIPATHS_STRICT] = "strict",
@@ -793,6 +794,7 @@ declare_def_snprint(allow_usb_devices, print_yes_no)
 
 
 static const char * const flush_on_last_del_optvals[] = {
+	[FLUSH_UNDEF] = "undef",
 	[FLUSH_NEVER] = "never",
 	[FLUSH_ALWAYS] = "always",
 	[FLUSH_UNUSED] = "unused",
-- 
2.50.1

