Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24712190063
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130819; cv=none; b=sOy07mTT3pDmMTH7xXSkw7t/CDTrtute4oXucZvuFS3AWIUBeWrR8+7q7oISjMuSiWTgeTXK5R3xduPUw9xHmMHJxAqj7cH/SVoljaPOa8qAPesd28gC/416LitEdrRNiQmuqUNqv2JHd0b/ocaWYzGObhLgk8WZ9PwAUUwQ5Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130819; c=relaxed/simple;
	bh=TxYC24j9GM7ydyj8Ifqu3VwA1kfVwlcdSpB1ArG2As0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQOOA8yskjdUqNoxyfeRd0qvTMZziFfbFjlJTQSJSiTu4YE2WNgWwiy15dUawIFMH3EtmyLZ1eR6G2DAb941tiHxaAUfxnaQ4HiXQaWjbeuvy063+9UTCImES3j//Fr5KRRaD7sbWD02TZdZi8334LGBcrWvMbHspo5hEMWqb60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qq4M6Dlh; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qq4M6Dlh"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a6135eso1651936a12.0
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130815; x=1723735615; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JA63NfXh38zI7QlfT2oUdMyI0pdIgc+Lcl8UNIoi84o=;
        b=Qq4M6Dlhyj7RBzMhwqMtxiCw6TpXzlnJl8WZ+jKEJ9xQm41Rx8THZvwUDac5vFpEs4
         x0lXAk5HPiUFCSmkcO90sgac3Y5Pf/I9t9WzMPrjkK0M049pW7KyN2IDf3JUpeu/H/d8
         ldi5cPSCd3L/q2dEK9l8Uocll3lF1jehGzp6wVJOe3yRoISuCWCWOmm6iFUtgM4TA3b5
         440Me82mm7OHXo9hhaBUhL0J/K5XGfjLNF2jI7Ce3mAU0yEJUyrDZfGT0CvDCj/bPTLs
         X5DzN147KW11EUdxdAFRckiwUUpivif6So437KqHkhqALUIkQ2LnxqER5aGS51HIX05b
         5RjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130815; x=1723735615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JA63NfXh38zI7QlfT2oUdMyI0pdIgc+Lcl8UNIoi84o=;
        b=XEkJP/q4R+QUN6n80PXYHv45La6F/KBv3Ar3LAQujv6OYBQ1wnSdkVYRclO7BHMy+P
         YV2qvptwVrc8tVA7vLE5WpGgS1iHQ67ndfCHu1tVExi7pW9WGQkmrBz+INbNl9UzHSnD
         kTKArxIz7LJ13gcxLJfsTtjCAworMwmDZdQVFlWWSw5FgxdwWrZW8y6UoGlXT3ZogQz6
         iTSjUzW5XqmyBaFkvRazTRNqijIwg73GrHcNgTwIMMfPXg47XNBxusPSWGROReIsarAD
         ZnA4yI+l/4qqFL+R6Rhd4Yz4vhHkrt6dyM3LJ/hPTr532S8cYXReeYjL1HYmkgKQxNiG
         VsnA==
X-Gm-Message-State: AOJu0YxwF5xe3MMWhy7BhKfBXbWc3gAG0LXYY34VJQM6cBTPeIadapJ2
	ncbsnx/kVZsCwXyq8p4RSdLHMOOtqwNlbfC/NiREbWLHFciiLBa6iOJleeKTerk=
X-Google-Smtp-Source: AGHT+IFfxmsCUyrz5iY93Qi3021JsqJuLf4Sa+BzEKFzSS5OzOsM/lB1ZpF0GA5HVNQi1bc3TwV42w==
X-Received: by 2002:a05:6402:26d4:b0:59e:a1a6:11b9 with SMTP id 4fb4d7f45d1cf-5bbb3bc0154mr2087927a12.2.1723130815039;
        Thu, 08 Aug 2024 08:26:55 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5bbb2d3496fsm737199a12.72.2024.08.08.08.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:54 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 21/41] libmultipath: rename __snprint_foreign_topology()
Date: Thu,  8 Aug 2024 17:26:00 +0200
Message-ID: <20240808152620.93965-22-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

... and __LAST_FOREIGN_RETCODE.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/foreign.c | 6 +++---
 libmultipath/foreign.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index d01a5ef..2a42df5 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -499,7 +499,7 @@ void foreign_multipath_layout(fieldwidth_t *width)
 	pthread_cleanup_pop(1);
 }
 
-static int __snprint_foreign_topology(struct strbuf *buf, int verbosity,
+static int snprint_foreign_topology__(struct strbuf *buf, int verbosity,
 				      const fieldwidth_t *width)
 {
 	struct foreign *fgn;
@@ -540,7 +540,7 @@ int snprint_foreign_topology(struct strbuf *buf, int verbosity,
 		return 0;
 	}
 	pthread_cleanup_push(unlock_foreigns, NULL);
-	rc = __snprint_foreign_topology(buf, verbosity, width);
+	rc = snprint_foreign_topology__(buf, verbosity, width);
 	pthread_cleanup_pop(1);
 	return rc;
 }
@@ -570,7 +570,7 @@ void print_foreign_topology(int verbosity)
 		fgn->release_paths(fgn->context, vec);
 		pthread_cleanup_pop(1);
 	}
-	__snprint_foreign_topology(&buf, verbosity, width);
+	snprint_foreign_topology__(&buf, verbosity, width);
 	pthread_cleanup_pop(1);
 	printf("%s", get_strbuf_str(&buf));
 }
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index db1592c..f3bc1b2 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -32,7 +32,7 @@ enum foreign_retcode {
 	FOREIGN_UNCLAIMED,
 	FOREIGN_NODEV,
 	FOREIGN_ERR,
-	__LAST_FOREIGN_RETCODE,
+	LAST_FOREIGN_RETCODE__,
 };
 
 /**
-- 
2.46.0

