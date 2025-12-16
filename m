Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A5333FE0E;
	Tue, 16 Dec 2025 23:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926420; cv=none; b=L/kdawQ0Gij0GFoOHsxgJCdBIBKjN5Vr5F4bOpcdRIPEbmQ/SG4UA2ygkHM83u9knwzctfUzJ2EFUyTAEBE5/2MAdLR+YfJ2w6vnkuY+1Phg5I3UllpAtWJtpW87JkoAsK4phKwbSrE6PmqXB7Qe3KPJR2W52bcKW6PVP7jLrJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926420; c=relaxed/simple;
	bh=SqhpEM8z1YTeqf/JpkPCTm09GUk75boOUOZMQKg9gY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/v223sp28HM50aj+OhiVV442vXnyFABNQFxH6MCysYErVaa0Gg2w7vuoa6p4mL+x3ccVNmQLQIgPrIT8XrNbV7YmmF6gZZJnCNx4/U9dICLSO4xM3tIzkmW7PQOKZJQoFU/4JyVNZvuH7E6RzkmFPO9KABIn3LHCFAtqlXLUl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bj5TcJoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bj5TcJoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E57C4CEF1;
	Tue, 16 Dec 2025 23:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926419;
	bh=SqhpEM8z1YTeqf/JpkPCTm09GUk75boOUOZMQKg9gY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bj5TcJoGqZnq2dus3x1Pwvhi/fizO82QruYGlmI2qfFwKduxxbiK3f1wFt4k4dW8D
	 9CnXFZvIbJeQYSoSg8MEUi7eyW9VKLJnayYJkTCgs05T0iPEPhHzyYfEsxT8WttPB6
	 ihjWhdh1VFg3+cQXCxMtJFQDio09uij6qAp9CtW+FBkkyLC5ZdAC3/HHKdT/exHyml
	 EI5+zjn5NDlpACgKtWx2RDHO05EQI62K3zU3wfY4XOnmzt4POs+Nwyo+MhIHKiz1GK
	 5Q59/1wL68s4R4F37CC1rmRQ+IHZBoPYRYfLXNSUwDDiTgc5KkPAp9OyQwGO0/E9XB
	 N5LT/sHnoRJ5Q==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Eran Messeri <eranm@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/7] dm-verity: remove unnecessary condition for verity_fec_finish_io()
Date: Tue, 16 Dec 2025 15:06:10 -0800
Message-ID: <20251216230614.51779-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216230614.51779-1-ebiggers@kernel.org>
References: <20251216230614.51779-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make verity_finish_io() call verity_fec_finish_io() unconditionally,
instead of skipping it when 'in_bh' is true.

Although FEC can't have been done when 'in_bh' is true,
verity_fec_finish_io() is a no-op when FEC wasn't done.  An earlier
change also made verity_fec_finish_io() very lightweight when FEC wasn't
done.  So it should just be called unconditionally.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 5c17472d7896..c9f5602a42c6 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -617,12 +617,11 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_status = status;
 
-	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
-		verity_fec_finish_io(io);
+	verity_fec_finish_io(io);
 
 	if (unlikely(status != BLK_STS_OK) &&
 	    unlikely(!(bio->bi_opf & REQ_RAHEAD)) &&
 	    !io->had_mismatch &&
 	    !verity_is_system_shutting_down()) {
-- 
2.52.0

