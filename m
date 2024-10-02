Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3171D0B8E
	for <dm-devel@lists.linux.dev>; Wed,  2 Oct 2024 14:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877842; cv=none; b=pKmAucoRlccMkGJPbLCjePr0wrl1V15dDMsi5GuqLmfhhkC2cNVa9+SgiKjC6fioU5YkaQgHdk+DnUbRmM+RPMUtqVlwQyAzYGYp1sCmkUyeguRWcRpMcmvsDuSnD1Uu1zjG/WMsQQKgCpb0iV2IPI+IFwi6ckLVKD15QStHFxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877842; c=relaxed/simple;
	bh=dAfks9Ca8IYfsqJxUSs92hR4BdTWGUZ1WeuchE1A4qc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=AkIIZ736SkeH4/jCgSZHF2xtbbnuBMYqU9rtr6qT831kkpwBk0CYm+D7qe/b3YHl+zv9yAEPYbV7qLe1mx7TlZp9Ot8nMNm+3wsVTsePfnl5Eyf6lPJS9vYBFOBgx6etdP1KysWUkMtQonQp1vlF+OGTYXPQHH4Hmc0BKatyK3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LDwHbOLw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LDwHbOLw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727877839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=03bq1oquFd9XBb+sJkmy+UQriDGNlbIFIByOXRIxvgM=;
	b=LDwHbOLwayzHl+/UoKkkw3B+kYj6etLatkpocjDwioxKm6tockqOEXhAVeUrzt70Zkb40a
	Wz6b/1vhYKOPi5NVX2JUhmfbBP0k3oCbIBYsARBqlU7L/kXhgri1ch8Ob86iQ/kJU/oLmv
	d6OvP/0GOd3x+F0S5+J5YZAP5IZ513s=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-FzW6S_2oNvyBgGjdaPRbmA-1; Wed,
 02 Oct 2024 10:03:56 -0400
X-MC-Unique: FzW6S_2oNvyBgGjdaPRbmA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B6ACB1954B0E;
	Wed,  2 Oct 2024 14:03:46 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BFA1519560A3;
	Wed,  2 Oct 2024 14:03:43 +0000 (UTC)
Date: Wed, 2 Oct 2024 16:03:41 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev
cc: Will Drewry <wad@chromium.org>, Sami Tolvanen <samitolvanen@google.com>, 
    Maxim Suhanov <dfirblog@gmail.com>, Milan Broz <gmazyland@gmail.com>, 
    Akilesh Kailash <akailash@google.com>, Alasdair G Kergon <agk@redhat.com>, 
    Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, 
    security@kernel.org, Eric Biggers <ebiggers@google.com>
Subject: [PATCH 2/2] dm-verity: introduce the options restart_on_error and
 panic_on_error
Message-ID: <9c9017f1-89bd-1a25-fa9d-ef060645e65b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

This patch introduces the options restart_on_error and panic_on_error on
dm-verity.

Previously, restarting on error was handled by the patch
e6a3531dd542cb127c8de32ab1e54a48ae19962b, but Google engineers wanted to
have a special option for it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity-target.c |   83 +++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-verity.h        |    1 
 2 files changed, 83 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-10-02 12:40:18.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-10-02 16:02:07.000000000 +0200
@@ -36,11 +36,13 @@
 #define DM_VERITY_OPT_LOGGING		"ignore_corruption"
 #define DM_VERITY_OPT_RESTART		"restart_on_corruption"
 #define DM_VERITY_OPT_PANIC		"panic_on_corruption"
+#define DM_VERITY_OPT_ERROR_RESTART	"restart_on_error"
+#define DM_VERITY_OPT_ERROR_PANIC	"panic_on_error"
 #define DM_VERITY_OPT_IGN_ZEROES	"ignore_zero_blocks"
 #define DM_VERITY_OPT_AT_MOST_ONCE	"check_at_most_once"
 #define DM_VERITY_OPT_TASKLET_VERIFY	"try_verify_in_tasklet"
 
-#define DM_VERITY_OPTS_MAX		(4 + DM_VERITY_OPTS_FEC + \
+#define DM_VERITY_OPTS_MAX		(5 + DM_VERITY_OPTS_FEC + \
 					 DM_VERITY_ROOT_HASH_VERIFICATION_OPTS)
 
 static unsigned int dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
@@ -583,6 +585,11 @@ static inline bool verity_is_system_shut
 		|| system_state == SYSTEM_RESTART;
 }
 
+static void restart_io_error(struct work_struct *w)
+{
+	kernel_restart("dm-verity device has I/O error");
+}
+
 /*
  * End one "io" structure with a given error.
  */
@@ -597,6 +604,23 @@ static void verity_finish_io(struct dm_v
 	if (!static_branch_unlikely(&use_bh_wq_enabled) || !io->in_bh)
 		verity_fec_finish_io(io);
 
+	if (unlikely(status != BLK_STS_OK) &&
+	    unlikely(!(bio->bi_opf & REQ_RAHEAD)) &&
+	    !verity_is_system_shutting_down()) {
+		if (v->error_mode == DM_VERITY_MODE_PANIC) {
+			panic("dm-verity device has I/O error");
+		}
+		if (v->error_mode == DM_VERITY_MODE_RESTART) {
+			static DECLARE_WORK(restart_work, restart_io_error);
+			queue_work(v->verify_wq, &restart_work);
+			/*
+			 * We deliberately don't call bio_endio here, because
+			 * the machine will be restarted anyway.
+			 */
+			return;
+		}
+	}
+
 	bio_endio(bio);
 }
 
@@ -805,6 +829,8 @@ static void verity_status(struct dm_targ
 				DMEMIT("%02x", v->salt[x]);
 		if (v->mode != DM_VERITY_MODE_EIO)
 			args++;
+		if (v->error_mode != DM_VERITY_MODE_EIO)
+			args++;
 		if (verity_fec_is_enabled(v))
 			args += DM_VERITY_OPTS_FEC;
 		if (v->zero_digest)
@@ -834,6 +860,19 @@ static void verity_status(struct dm_targ
 				BUG();
 			}
 		}
+		if (v->error_mode != DM_VERITY_MODE_EIO) {
+			DMEMIT(" ");
+			switch (v->error_mode) {
+			case DM_VERITY_MODE_RESTART:
+				DMEMIT(DM_VERITY_OPT_ERROR_RESTART);
+				break;
+			case DM_VERITY_MODE_PANIC:
+				DMEMIT(DM_VERITY_OPT_ERROR_PANIC);
+				break;
+			default:
+				BUG();
+			}
+		}
 		if (v->zero_digest)
 			DMEMIT(" " DM_VERITY_OPT_IGN_ZEROES);
 		if (v->validated_blocks)
@@ -886,6 +925,19 @@ static void verity_status(struct dm_targ
 				DMEMIT("invalid");
 			}
 		}
+		if (v->error_mode != DM_VERITY_MODE_EIO) {
+			DMEMIT(",verity_error_mode=");
+			switch (v->error_mode) {
+			case DM_VERITY_MODE_RESTART:
+				DMEMIT(DM_VERITY_OPT_ERROR_RESTART);
+				break;
+			case DM_VERITY_MODE_PANIC:
+				DMEMIT(DM_VERITY_OPT_ERROR_PANIC);
+				break;
+			default:
+				DMEMIT("invalid");
+			}
+		}
 		DMEMIT(";");
 		break;
 	}
@@ -1088,6 +1140,25 @@ static int verity_parse_verity_mode(stru
 	return 0;
 }
 
+static inline bool verity_is_verity_error_mode(const char *arg_name)
+{
+	return (!strcasecmp(arg_name, DM_VERITY_OPT_ERROR_RESTART) ||
+		!strcasecmp(arg_name, DM_VERITY_OPT_ERROR_PANIC));
+}
+
+static int verity_parse_verity_error_mode(struct dm_verity *v, const char *arg_name)
+{
+	if (v->error_mode)
+		return -EINVAL;
+
+	if (!strcasecmp(arg_name, DM_VERITY_OPT_ERROR_RESTART))
+		v->error_mode = DM_VERITY_MODE_RESTART;
+	else if (!strcasecmp(arg_name, DM_VERITY_OPT_ERROR_PANIC))
+		v->error_mode = DM_VERITY_MODE_PANIC;
+
+	return 0;
+}
+
 static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 				 struct dm_verity_sig_opts *verify_args,
 				 bool only_modifier_opts)
@@ -1119,6 +1190,16 @@ static int verity_parse_opt_args(struct
 			if (r) {
 				ti->error = "Conflicting error handling parameters";
 				return r;
+			}
+			continue;
+
+		} else if (verity_is_verity_error_mode(arg_name)) {
+			if (only_modifier_opts)
+				continue;
+			r = verity_parse_verity_error_mode(v, arg_name);
+			if (r) {
+				ti->error = "Conflicting error handling parameters";
+				return r;
 			}
 			continue;
 
Index: linux-2.6/drivers/md/dm-verity.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity.h	2024-10-02 12:39:50.000000000 +0200
+++ linux-2.6/drivers/md/dm-verity.h	2024-10-02 13:38:28.000000000 +0200
@@ -64,6 +64,7 @@ struct dm_verity {
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
 	unsigned int hash_reqsize; /* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
+	enum verity_mode error_mode;/* mode for handling I/O errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
 
 	struct workqueue_struct *verify_wq;

