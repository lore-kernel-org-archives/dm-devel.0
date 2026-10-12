Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E582641CB2E
	for <dm-devel@lists.linux.dev>; Mon, 12 Oct 2026 14:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814201; cv=none; b=shOTxiMdlDTD3U0iSWmU1s9FkbJszVd0a1inegML41V3IkoKCjXRHAE9FszS2WBAZwlxjhChlG806EWlriEAzRU6Fl7FtocnKBRFHyiwyFggjolcKWekFZ9lq7dk764sB8AazWDvw/uuEZxeG5eKGdRM+UQ4YhGAOrZnCh/G7f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814201; c=relaxed/simple;
	bh=58TwhPoKztPDojb9As4SnvOtlI+S9lAGJciQ9y8koMs=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=s9JBnDg/vLy8gLKolcNffAbrhTS8JpFr0uoqOD9sZtyuN1o5plw/nhhJvG/B7YG+PBNgT4YUO6sm5FLlHFgrnYfLOPqS7Tb+dLCF2ss3s+JrA3vFoEHlZeFgNsrO6WC0sAsX9ycdWkQzmcoXQYBN9/9nUmRGCk0kiw6e4iRR7y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P5HKjqo6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P5HKjqo6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791814198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hTlBnDmY88LB1/+UXWgJuuClTti2KJGC27VKlAhiOmE=;
	b=P5HKjqo6MDVuwIHKIaZ7pk5QhhhdQXdIrh+gJwIXNuopwjvk3cbPkMyF4+BBvX1yqHm4gy
	vPYyV+XKex2fZsXHMMypkW1O5zBOXQQW12eaGer8E7S+sI8FjGJh4FtuQOMFL8sKJP3XLL
	mqdW9/x7kRZiE+euf9fiBNZQfBlKETc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-230-ALPbSHwjMj-epp41lfLlcg-1; Mon,
 12 Oct 2026 14:09:57 +0000
X-MC-Unique: ALPbSHwjMj-epp41lfLlcg-1
X-Mimecast-MFC-AGG-ID: ALPbSHwjMj-epp41lfLlcg_1791814196
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 050F8180060B;
	Mon, 12 Oct 2026 14:09:56 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9503418005B5;
	Mon, 12 Oct 2026 14:09:54 +0000 (UTC)
Date: Mon, 12 Oct 2026 16:09:52 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] dm-bufio: fix a race leading to an unsigned integer
 underflow
Message-ID: <6caa4611-3e4a-6f71-459f-c83d4317047e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JVz87O_wmJAPtgpima-mNkTkLnL8U1aqvDtVoKbn6dg_1791814196
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The function __scan tests "count - freed <= retain_target" and then sets
"atomic_long_set(&c->need_shrink, 0);" It exits with the condition "if
(!atomic_long_read(&c->need_shrink)) break;" It may be possible that
between these two statements, another thread sets &c->need_shrink to a
non-zero value. In this case, the function __scan continues and it may
possibly the "freed" variable is larger than the "count" variable. The
expression "count - freed" underflows and the function __scan will
continue to free all the buffers, even those that are below
retain_target.

Fix this bug by immediatelly exiting if we set
"atomic_long_set(&c->need_shrink, 0)"; and don't attempt to re-read
c->need_shrink afterwards.

Fixes: 450e8dee51aa ("dm bufio: improve concurrent IO performance")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5

---
 drivers/md/dm-bufio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -2426,8 +2426,10 @@ static void __scan(struct dm_bufio_clien
 
 	for (l = 0; l < LIST_SIZE; l++) {
 		while (true) {
-			if (count - freed <= retain_target)
+			if (count - freed <= retain_target) {
 				atomic_long_set(&c->need_shrink, 0);
+				break;
+			}
 			if (!atomic_long_read(&c->need_shrink))
 				break;
 

