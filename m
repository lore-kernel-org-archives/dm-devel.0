Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50653AA9CA
	for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 13:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785245294; cv=none; b=Q4t+6YDScePTGibMkAAwPXXF41A6v10DYHR2Rj5tan7oZ6aZtzolpRi3sgGIWoIaUbukHRAvA/Eri139OaOS60UUXe6h5lJPDfFNHS1h1rD5iv3e1b7fzfPk9TMD1249uCiOViH5BbNQPEBV2RSa8XkKo8kwYSGBnYlqz2bCqqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785245294; c=relaxed/simple;
	bh=fJ7DUHTSm2Vkjty5O0sz0ismVjlvQrQzwa7sNhfvbkk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=nTZX+ImiQAF67iW+lPqVn1U72bn4LE5mRtrc+vdmbObSJbyPbKqXpP1dS0be3AoO5uJzBA+QYiJ0BLBZFshBGLlzLTK6xnmMw7/5vMVf27ude3eB0EK++7+ykG8p4rCrKvrlKAOC5O+7Ej20IyJkRGQlkqHsRWwTa/73O7hgCA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WNFKyHPm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WNFKyHPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785245291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qzYazpwyMpfKoBhnEBcrUPqBRejfl/tJUhCc/onywjE=;
	b=WNFKyHPmX1ryN+5i/UBSe0WAnBy4h1v3qk+bhKblqiDIjcS8AmYUrX4M4V7+GP3HUCvbZP
	xcEf+MUJawHfqoKRAkSm49ayH3IjbEBElTy0PjKRdFn9/Y8Yny6Qli+yHs8yDT6huXWVmI
	0Uo8qdlXxmhB8p9ijRReMQBZB5pPcsg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-VEXpgC-nMweFLbLB2GVilQ-1; Tue,
 28 Jul 2026 09:28:09 -0400
X-MC-Unique: VEXpgC-nMweFLbLB2GVilQ-1
X-Mimecast-MFC-AGG-ID: VEXpgC-nMweFLbLB2GVilQ_1785245288
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CA1A1955E74;
	Tue, 28 Jul 2026 13:28:06 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53B8F3000218;
	Tue, 28 Jul 2026 13:28:04 +0000 (UTC)
Date: Tue, 28 Jul 2026 15:27:58 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Junzhe Yu <junzheyu1@gmail.com>
cc: Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [BUG] dm-stats: null-ptr-deref in dm_stat_free on stats alloc
 failure
In-Reply-To: <9c337692-ce94-4dfa-80db-47390f67f0b5@gmail.com>
Message-ID: <d0ee68fc-5773-d2bd-c881-169747b2887f@redhat.com>
References: <9c337692-ce94-4dfa-80db-47390f67f0b5@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: f05qMju6ajza5FZtSHUc3Ir60Jy2FhYaA4zd7ADJzmM_1785245288
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sat, 25 Jul 2026, Junzhe Yu wrote:

> Hello,
> 
> I am reporting a null-pointer dereference in device-mapper dm-stats when
> @stats_create fails part-way through per-CPU buffer allocation.
> 
> Summary
> =======
> 
> dm_stats_create() allocates per-CPU stat buffers in a loop. On mid-loop
> ENOMEM it jumps to out: and calls dm_stat_free(). dm_stat_free() then
> dereferences s->stat_percpu[cpu] without a NULL check, including for CPUs
> that never received a successful allocation (still NULL from zero-init).
> 
> The crash is a KASAN null-ptr-deref / general protection fault in
> dm_stat_free() at drivers/md/dm-stats.c, reached via DM_TARGET_MSG
> @stats_create.

Hi

Here I'm sending a patch for this bug.

Mikulas


dm-stats: fix a crash if allocation of per-cpu data fails

If "dm_kvzalloc(percpu_alloc_size, cpu_to_node(cpu))" fails, the code
jumps to the "out" label and calls dm_stat_free. dm_stat_free does
"for_each_possible_cpu(cpu) { dm_kvfree(s->stat_percpu[cpu][0].histogram,
s->histogram_alloc_size);", which crashes with NULL pointer dereference
if s->stat_percpu[cpu] is NULL.

This commit fixes the bug by testing s->stat_percpu[cpu] for NULL before
using it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-stats.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-stats.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stats.c	2026-07-13 20:58:56.000000000 +0200
+++ linux-2.6/drivers/md/dm-stats.c	2026-07-28 15:21:23.000000000 +0200
@@ -178,8 +178,10 @@ static void dm_stat_free(struct rcu_head
 	kfree(s->program_id);
 	kfree(s->aux_data);
 	for_each_possible_cpu(cpu) {
-		dm_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
-		dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+		if (s->stat_percpu[cpu]) {
+			dm_kvfree(s->stat_percpu[cpu][0].histogram, s->histogram_alloc_size);
+			dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+		}
 	}
 	dm_kvfree(s->stat_shared[0].tmp.histogram, s->histogram_alloc_size);
 	dm_kvfree(s, s->shared_alloc_size);

