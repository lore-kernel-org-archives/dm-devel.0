Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AE4156C6A
	for <dm-devel@lists.linux.dev>; Mon, 10 Feb 2025 16:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206001; cv=none; b=jg5/cUaa8syo6U4usBWFX1oim/ForE+IldaRuSrZNPiARQw+ERBfIajPHG4PWF40/WbR6Ep1xJctOUvutXZou7A8c1kZkK4RK0dZW2oVB/+eB1NMPKnEeagn+Ys/CehO0xCQYZNxw/v2RVg/iqXJvuMkW+UXZyhHayOB8SKhDMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206001; c=relaxed/simple;
	bh=1Uui0LP+dRy/nF/7kQOgRby59OEfk0bdqA8gUXuO9fI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ZVZtl+srnxOFOWK3IhIKCuPW7ZAiAs8eavcLjqiOsCIL2dJEn6iTjiQvNwiSgr9Lxl1MJDP9VQpe40cusSfIpqSxnQNsr2KBOpyd9nH+1ObXSUjLkW2f6FfQjY3+2UWTGKC+XN3HFq97Y7ZZLETZawjn5DKLhAE2PUmZXA+N03g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q13AjmEB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q13AjmEB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739205998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9tKkdtm92j2d1e6fcm2f9ZD5mkyDaEahDExQkA7AKaA=;
	b=Q13AjmEBgPfi/KMiw/DWf9ghYyivTs4rVbDPuVz8DnQheWpRz+qOawG1WTYi+GqmFftFsx
	+Uclu5826/7+y8myA+KSXKSTmXNiokgqpILowkZ54QA0SgcQ+4tAuo0YJ2uKTtGJX/AcYw
	7ymddMYUR5ZgruhiFADdYH+8mjAHpiU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-609-fbVD1i7LMmiof3r_x1bnJg-1; Mon,
 10 Feb 2025 11:46:35 -0500
X-MC-Unique: fbVD1i7LMmiof3r_x1bnJg-1
X-Mimecast-MFC-AGG-ID: fbVD1i7LMmiof3r_x1bnJg
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C45C1955D5C;
	Mon, 10 Feb 2025 16:46:34 +0000 (UTC)
Received: from [10.45.225.131] (unknown [10.45.225.131])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22C651800358;
	Mon, 10 Feb 2025 16:46:30 +0000 (UTC)
Date: Mon, 10 Feb 2025 17:46:26 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
cc: Akilesh Kailash <akailash@google.com>, 
    Sami Tolvanen <samitolvanen@google.com>, kernel-team@android.com, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dm-verity: do forward error correction on metadata
 I/O errors
In-Reply-To: <60c1acde-839d-4d23-8270-2acf032a4ef9@gmail.com>
Message-ID: <4dc8f521-e6ca-b80c-eee8-060158a38407@redhat.com>
References: <629167c1-9be0-6128-8605-eb02391e821d@redhat.com> <60c1acde-839d-4d23-8270-2acf032a4ef9@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111



On Mon, 10 Feb 2025, Milan Broz wrote:

> On 2/10/25 4:04 PM, Mikulas Patocka wrote:
> > Do forward error correction if metadata I/O fails.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> Not directly related to this patch, but...
> please could you also increase the dm-verity version?
> 
> I just implemented support for the errors-as-corruption
> dm-verity flags in veritysetup.
> 
> The version of dm-verity stayed at 1.10 for a very long, and
> the IO error processing change was a functional change that we
> would like to detect.
> We cannot set version retrospectively, but at least now with other
> changes.
> 
> (Veritysetup tries the requested flags; if activation fails,
> it displays a better error message based on the detected
> target version. That way it works even with backports.)
> 
> Thanks,
> Milan

OK.


From: Mikulas Patocka <mpatocka@redhat.com>

Do forward error correction if metadata I/O fails.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity-target.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2025-02-10 16:24:56.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2025-02-10 17:43:50.000000000 +0100
@@ -324,8 +324,22 @@ static int verity_verify_level(struct dm
 						&buf, bio->bi_ioprio);
 	}
 
-	if (IS_ERR(data))
-		return PTR_ERR(data);
+	if (IS_ERR(data)) {
+		r = PTR_ERR(data);
+		data = dm_bufio_new(v->bufio, hash_block, &buf);
+		if (IS_ERR(data))
+			return r;
+		if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
+				      hash_block, data) == 0) {
+			aux = dm_bufio_get_aux_data(buf);
+			aux->hash_verified = 1;
+			goto release_ok;
+		} else {
+			dm_bufio_release(buf);
+			dm_bufio_forget(v->bufio, hash_block);
+			return r;
+		}
+	}
 
 	aux = dm_bufio_get_aux_data(buf);
 
@@ -366,6 +380,7 @@ static int verity_verify_level(struct dm
 		}
 	}
 
+release_ok:
 	data += offset;
 	memcpy(want_digest, data, v->digest_size);
 	r = 0;
@@ -1761,7 +1776,7 @@ static struct target_type verity_target
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
 	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
-	.version	= {1, 10, 0},
+	.version	= {1, 11, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,

