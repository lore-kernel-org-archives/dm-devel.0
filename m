Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7370D171A1
	for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 18:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379621; cv=none; b=dMTB5pH9c5OPCR8Th1HQAZhRbrWmuETcEm+0+A3ooYJmm4cpyzibP2+oxlt9JBVX4Y0xv9pQl9kLd17T+66rQlb8TPsXhwKZ+wo9XAZ1FlSB9lP8Y3by3D+T/2hKQ4oF4dXIYlw1k5riokJo3QdiN1G+ynNnNPrBRNdcxUw6NzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379621; c=relaxed/simple;
	bh=IsP5IV+jUQFxbgWNWPmpLEVlqwWF7aCK6IkgNOwRwis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5JEDNmZZZFNOJ1/sGGlFl0U254l1/gV06NwxavWQQnzQH77IcYZPbXhOBliWEhR0cPDLS27EJR6Gyy7vtMZ9PcwHaHKAcDLWlKypMvJPFLBDzNsasJ/qW5Hwj4N7fXKSYassgKAvnC6TCFqTtZ1w7c27JcZP/3i8HPvjAxgU0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CKTL//7R; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CKTL//7R"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a524ecaf215so580354566b.2
        for <dm-devel@lists.linux.dev>; Wed, 17 Apr 2024 11:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713379618; x=1713984418; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JpYhjYm5FDWPMTBd0ATasJ02QXsCYM7X2shAUnSlddc=;
        b=CKTL//7RU03zukgAa1pWc+LWj37V/1TEcO29S+8iOW/WpIy6XSE+Ud8S3ZMOBxXFMy
         Rpgmknk7qUTSNWr6istBeeBzS0ugL+qoVqb3hyqxlln6sER+A+JuBf2/9QpIbQPstezS
         8697wNP+93Qut+pIWmcEF7dlWRQkSeyMUrKQ4g62XL/EYqKMqLvdoQ8jZ9yt4h+AnMGe
         IKjvgHrXLXyUfDMujOgaFUuYupzzOVREgCzveWcQwyLjxXLy+k1NGzPKmo0jhbA2qprj
         vCQLf9IJQREAlKHl0Nhtp2zRACs82zDT8yL/tSJro+MCDNL62w+q2ORP+rJZ/lpAsCdr
         4XrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713379618; x=1713984418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JpYhjYm5FDWPMTBd0ATasJ02QXsCYM7X2shAUnSlddc=;
        b=qkfWKDHVBnaUJolztlLmwgybGJlhaDa4wmrWsbn1KNth/94ONd0LfskbSyixRaDHyB
         QI9GBh8kI74Vu0WmAv/lVoW4WJGb7BG22cAQ9017zMQ17XWKgFW16BCnKXHLh923zO+Z
         2PyyyeZUD4csVB8CR5FAjgVC7HbOBtNPmHsZWg9xUUT/J8MYMpiHXvak/JsQ/B77EGZx
         PqdALpnKGwCGlKxD7+3YSD2k1mE/CyP4jLjv2ecjeDt6V2ZlQAnhOeXGBphh/jg76XnX
         HWAdgqizf21JY4gMOrVWLKrGauuydF8DowgfgBCEfTEfR5VSwogsegT31zIs45eaywaJ
         TwNQ==
X-Gm-Message-State: AOJu0YydntJqaG+wif1cb9R6p6C561DhqCVFW+mewkkb7kaV5Mc6ZZac
	Om2HCaROmnQll4zzdOgoxcrRcb8Og9LOFEBEh6KKQ1mrqcg6gmyjJW+l6SzrNqw=
X-Google-Smtp-Source: AGHT+IHuFZabrMcTmZJTrQcb8bd5TvkeQUXfj5FlVhmlCBkFVFRpGl1QQVyEyBLsUHAFgtUfEJO5RQ==
X-Received: by 2002:a17:906:4151:b0:a52:c873:a66 with SMTP id l17-20020a170906415100b00a52c8730a66mr249758ejk.34.1713379617824;
        Wed, 17 Apr 2024 11:46:57 -0700 (PDT)
Received: from localhost (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with UTF8SMTPSA id f18-20020a170906391200b00a5546604a5asm2235209eje.104.2024.04.17.11.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Apr 2024 11:46:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Etienne AUJAMES <eaujames@ddn.com>
Subject: [PATCH 3/8] libmultipath: add mp_find_path_by_devt()
Date: Wed, 17 Apr 2024 20:46:39 +0200
Message-ID: <20240417184644.6193-4-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240417184644.6193-1-mwilck@suse.com>
References: <20240417184644.6193-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A helper function that searches a struct multipath by dev_t, and
works whether or not mpp->paths is currently available.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 19 +++++++++++++++++++
 libmultipath/structs.h |  3 +++
 2 files changed, 22 insertions(+)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 74e31a1..e248fb5 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -526,6 +526,25 @@ find_path_by_devt (const struct _vector *pathvec, const char * dev_t)
 	return NULL;
 }
 
+struct path *mp_find_path_by_devt(const struct multipath *mpp, const char *devt)
+{
+	struct path *pp;
+	struct pathgroup *pgp;
+	unsigned int i, j;
+
+	pp = find_path_by_devt(mpp->paths, devt);
+	if (pp)
+		return pp;
+
+	vector_foreach_slot (mpp->pg, pgp, i){
+		vector_foreach_slot (pgp->paths, pp, j){
+			if (!strcmp(pp->dev_t, devt))
+				return pp;
+		}
+	}
+	return NULL;
+}
+
 static int do_pathcount(const struct multipath *mpp, const int *states,
 			unsigned int nr_states)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 734905e..a25eb9d 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -568,6 +568,9 @@ struct path * find_path_by_devt (const struct _vector *pathvec, const char *devt
 struct path * find_path_by_dev (const struct _vector *pathvec, const char *dev);
 struct path * first_path (const struct multipath *mpp);
 
+struct path *mp_find_path_by_devt(const struct multipath *mpp, const char *devt);
+
+
 int pathcount (const struct multipath *, int);
 int count_active_paths(const struct multipath *);
 int count_active_pending_paths(const struct multipath *);
-- 
2.44.0

