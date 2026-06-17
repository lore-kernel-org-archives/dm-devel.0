Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BACA4963AF;
	Wed, 17 Jun 2026 16:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781713295; cv=none; b=QdK4UaW11QXlcSM88MXXyrEmgi2LZmWz7ySGvucu44G8aMtmS/PoXZ6taWf6gveyFxhVJ3bFRK//U6ZPXJFzfPR/mlxIv1fLv0YRdF5p+Gvgt9ohy1Uegw6RO4e9selJZH7mR33JUK52Xw8sNFj9rWCFKnuKPkBxWQRwG4zUjDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781713295; c=relaxed/simple;
	bh=aQLgDihblQHjOGt5WwFEyi+vbcGscKyL86qT6YH0dIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRUufv+H9329GT3RBYWl7JU4xcQW8vhMYwCJwoRZGafNsTJ1fw1ZjK+JzMF8G3fxNxWMHJsiGCXtw1jd+h+Hx53ydokjO8aGYk4aPJJkr6zkTaTRGQbz0P7lmSS1ATl4MjOyO+dQUfUEQ+maGW1q0Agp4Xz2gD332vVQsz5gEdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dxvvn9T2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dxvvn9T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B921F000E9;
	Wed, 17 Jun 2026 16:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781713290;
	bh=hLu8faO/8oqmYLdvW3TsLnHt8kNeuLpZ1aR42WDeZ+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dxvvn9T2uifmjeZ2pKvNo45mdsBsUX5NReSjO35fddwBFPAatrxSBwkXke8JgmvbP
	 9p4JSNKN0Qm6cguk/OMsJdlzVbmzL6bUkwvRyQfhScasBWoOAlr1a+sju5K8Yn8LFM
	 AE76L0R1bpIBxcVZ1+THn+AXZIbOCiNf8BxPGOwkteaopWdhXKayl5pqpcSB+GK/+M
	 Eshx1AkIgH2J6fP8YROgntmVBYf9PaQJqzfuvm1UGTwzNPus6uZ/LgcXP7+unSdY/2
	 AzTg0xl+xx0XOQhIHcPV02RUMk99NamVKY2GxgoN53KAzTzvatw7jIVxZDCNPTYhET
	 9alBqQkWxhjow==
Date: Wed, 17 Jun 2026 10:21:28 -0600
From: Keith Busch <kbusch@kernel.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, mpatocka@redhat.com,
	Vjaceslavs Klimovs <vklimovs@gmail.com>
Subject: Re: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O
 errors
Message-ID: <ajLJiOwim7qBp_0P@kbusch-mbp>
References: <20260616150554.1686662-1-kbusch@meta.com>
 <20260616150554.1686662-2-kbusch@meta.com>
 <ajGN1OKun3qyvqMc@gallifrey>
 <ajGacnaCZ6v6VE1B@kbusch-mbp>
 <ajGtbuJ2kXo1GZ1d@gallifrey>
 <ajK4YacvP7eQ-S2o@kbusch-mbp>
 <ajK-Y7uoK0QT5PVl@gallifrey>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajK-Y7uoK0QT5PVl@gallifrey>

On Wed, Jun 17, 2026 at 03:33:55PM +0000, Dr. David Alan Gilbert wrote:
> * Keith Busch (kbusch@kernel.org) wrote:
> > On Tue, Jun 16, 2026 at 08:09:18PM +0000, Dr. David Alan Gilbert wrote:
> > > root@dalek:/home/dg# lvcreate  --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> > 
> > So this is a subtle difference from your original report which ran
> > lvcreate a little differently:
> > 
> >   # lvcreate --type mirror --mirrors 1 -L 1G main /dev/sda2 /dev/sdb2
> > 
> > This patch series address problems with the original report with the
> > "--type mirror" parameter, which uses dm-raid1.c instead of md/raid1.c.
> 
> Ah OK.
> (I think I think I did say that somewhere, hmm ajFK5NXkxd6jU5zu@gallifrey ? )

I see. This will fix that setup:

---
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5b9368bd9e700..17a5f0d98aacc 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -322,7 +322,9 @@ static void call_bio_endio(struct r1bio *r1_bio)
 {
 	struct bio *bio = r1_bio->master_bio;
 
-	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
+	if (test_bit(R1BIO_Invalid, &r1_bio->state))
+		bio->bi_status = BLK_STS_INVAL;
+	else if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
 		bio->bi_status = BLK_STS_IOERR;
 
 	bio_endio(bio);
@@ -403,6 +405,8 @@ static void raid1_end_read_request(struct bio *bio)
 		;
 	} else if (!raid1_should_handle_error(bio)) {
 		uptodate = 1;
+		if (bio->bi_status == BLK_STS_INVAL)
+			set_bit(R1BIO_Invalid, &r1_bio->state);
 	} else {
 		/* If all other devices have failed, we want to return
 		 * the error upwards rather than fail the last device.
@@ -519,6 +523,14 @@ static void raid1_end_write_request(struct bio *bio)
 		 */
 		r1_bio->bios[mirror] = NULL;
 		to_put = bio;
+		/*
+		 * An invalid I/O (e.g. a misaligned bio rejected by the lower
+		 * device) was ignored above rather than faulting the device.
+		 * It is not a successful write, though, so report the error to
+		 * the caller instead of completing the master bio as uptodate.
+		 */
+		if (bio->bi_status == BLK_STS_INVAL)
+			set_bit(R1BIO_Invalid, &r1_bio->state);
 		/*
 		 * Do not set R1BIO_Uptodate if the current device is
 		 * rebuilding or Faulty. This is because we cannot use
diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index c98d43a7ae993..21e837db5b25e 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -184,6 +184,12 @@ enum r1bio_state {
 	R1BIO_MadeGood,
 	R1BIO_WriteError,
 	R1BIO_FailFast,
+/* An invalid I/O (e.g. a bio rejected by the lower device because it does
+ * not meet that device's dma_alignment) is not a device failure.  Report
+ * the error to the caller without faulting the device or retrying, and do
+ * not complete a write as if it had succeeded.
+ */
+	R1BIO_Invalid,
 };
 
 static inline int sector_to_idx(sector_t sector)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index cee5a253a281d..3cee9612be26d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -323,7 +323,9 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	struct r10conf *conf = r10_bio->mddev->private;
 
 	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
-		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
+		if (test_bit(R10BIO_Invalid, &r10_bio->state))
+			bio->bi_status = BLK_STS_INVAL;
+		else if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
 			bio->bi_status = BLK_STS_IOERR;
 		bio_endio(bio);
 	}
@@ -403,6 +405,8 @@ static void raid10_end_read_request(struct bio *bio)
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
 	} else if (!raid1_should_handle_error(bio)) {
 		uptodate = 1;
+		if (bio->bi_status == BLK_STS_INVAL)
+			set_bit(R10BIO_Invalid, &r10_bio->state);
 	} else {
 		/* If all other devices that store this block have
 		 * failed, we want to return the error upwards rather
@@ -523,6 +527,8 @@ static void raid10_end_write_request(struct bio *bio)
 		 * before rdev->recovery_offset, but for simplicity we don't
 		 * check this here.
 		 */
+		if (bio->bi_status == BLK_STS_INVAL)
+			set_bit(R10BIO_Invalid, &r10_bio->state);
 		if (test_bit(In_sync, &rdev->flags) &&
 		    !test_bit(Faulty, &rdev->flags))
 			set_bit(R10BIO_Uptodate, &r10_bio->state);
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index ec79d87fb92f6..a1adad3acafe1 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -175,5 +175,11 @@ enum r10bio_state {
 /* failfast devices did receive failfast requests. */
 	R10BIO_FailFast,
 	R10BIO_Discard,
+/* An invalid I/O (e.g. a bio rejected by the lower device because it does not
+ * meet that device's queue_limits) is not a device failure. Report the error
+ * to the caller without faulting the device or retrying, and do not complete a
+ * write as if it had succeeded.
+ */
+	R10BIO_Invalid,
 };
 #endif
--
