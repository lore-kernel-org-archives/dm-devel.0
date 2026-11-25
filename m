Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602373;
	b=NI8XZ/qCyTavA4IZ+Gl20CZ3bAfsrWtBPQ3mQVkBnKmteTX/C+pWD4kTZn9bebMuHYnO
	 v2cA1ReQvVPf8sgDRS2OQ3f8OqNZNmuHabpkTowmIhF9vXsEvtjIzrczUVgrtWynwXbOG
	 bWsneryAuq1wwLnh2J3HOKkDArWK6SqgnD1eDID0HJLnSlwQ0U5T/UthtZmyfK1+Jm9/n
	 Tuau6cRmoeSgUxSY+w3C2JHk76DG9hqrLiPd7eAQEya4zVVjcHTDIHO/W9X2dBdFY4aZ6
	 qG4beNIT5Oydl3dlPLJ/VH+xQ48ZocruwwC3k7qkhFn/FMujFNmvrs1G8xw0CSSskTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602373;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=f82AZnbiSGXKlRUvqZF+jiJJSzJYJK0bJ9wk7mhSUn8=;
	b=KhLw7kh/Vx8IbB7e4mi0I6PZ0ftYiWJ6ta0ZCF4sWn+JzialXhbVeqWcoXdDnEurNXfP
	 NusONNcRuFI0tbEkT43BOEGMy0O0TNVd3f56VRM9rlH+bpNg0M4YhrMdKCJIWq/aFTFvC
	 WT7zcjBeu9/ikaKB9CsbTF/LDWMywgjP01vfQIdZXF1xcea8GEJSqgjO0eALkZlGQfnPk
	 NNI3nKPqTSp29OgFv8skjIvJsOVgd3KkN5WyK0j7tJx9RCQrz0gWRRVhJ5WBL8PyXo0sC
	 r0/jV7ahMFZbdb60ojaot0Q1BvYivzPVJ+cCCE5Z2Fv46SQ7rQLG4HRm84Y+aEzw+3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fdrFl3sd;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD069606A335
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:26:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD069606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fdrFl3sd
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bba5e1b9f9so259295e9.3
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602371; x=1796207171; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f82AZnbiSGXKlRUvqZF+jiJJSzJYJK0bJ9wk7mhSUn8=;
        b=fdrFl3sd+2QmLFAPrhDM748YZQZUyHWR//1y47TsOtZgeRwWS2yMgyxiqI08wbf5dQ
         JF219/hYEar711dn9UeMTCTMviPRvVOfSNqX+7m5FDiohXfRSvfEkDf8Buih6oT9UWPw
         gkWnaVLZ30uLIhoOeMprDjrVadTmZa8vZ9Y3sGijNpW72UuE88rzgniHvF6sanj4xSki
         s23VbgCLqW+Ny7OMN4dA1yJLzUnV5Q2riHhfZgd8rCRQ8k0DXKsZRmuWhaLqH/P8q7vN
         06Yh2xNkNyMlzG2T7UtmEx14WY35V8y7ugaToDpM2mlFICvd0LT6n2L2gpgfjhXvh9i9
         gpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602371; x=1796207171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f82AZnbiSGXKlRUvqZF+jiJJSzJYJK0bJ9wk7mhSUn8=;
        b=0ZTJLTJX05IbysVdRueHIyL/pNode2VrVmFQjW16iaA2dvAca5Ankl02SKWkp/biLA
         yzTAL7q/kC5C/dbUGynpef04XbWaIeNBidbtYeuQwD/55NTM27dU3Pd6WNZXqoKXB9Gp
         q6CYXxGxNjjgZ3Uhk4BeFXGOgeeTF+CAtHl0JSdss1fgbLfQSR9yMOYP2rz6BPgXMzYc
         M2lbUyCouMZ6TXXRzENRR8wRDwl8bczkkEiBS3MaS9swdl5K5V20nxM2Je6/2Q56xdp5
         gzbUDHLK/Mnhxw0B5GkyN9ns1K2SfG8kIjyWUSW6lKMXkLeDfEw4lsrGBCfbk/fTbLX0
         TURg==
X-Forwarded-Encrypted: i=1; AL+hErGDlOeTx1wuEsXjXwSggoo4qzlZVRZfT0w2Ycx0kGtNsb/xcanMcaPE+LhrRoNj9SzyBT5dfIDnhQ==@lists.linux.dev
X-Gm-Message-State: APuU4Z9lwwl+YkoLtfaltNfdhD0FL8qXXHL8hEAxKEdF4fKUg5SibCvs
	+9I+Q6JFPDy2OJWtqRBbp9d4JSQ4n2qFKzgsFGVDS4e0fSH13+V2niU=
X-Gm-Gg: AZFdTZeC8x1ihCkonCxfdWeym0jPXidO/GPUh2bYkzIvjnK2Gq6H0PWJHAYZLlCAoLx
	+uccyFW45lAcCHjRmeKlP2DuXOEWgWIxqS6FD9uEda1K53bgfQtN2eIE0jllBEeyxptUV68WC9U
	YKo+b4ZOUuBrt4PizZIs9wgbthcgYfQYwhZ3T3ghUXmOCS/yUnrNJt2LNowRpVVGHES0llHt7UA
	seFYyjVFzkcNbOLBv+Qr4qt7FCgWJeuuGc/tk0Rtm/z7yty6hesyO2bti6Xobhy2ehV/8Q3Ysra
	qnmDP0+T17k5vdsS+JpHfnOnkdISuFyaWthKrAEUf9Cu3O3GRZRe4tqP4phpdfPKkbB+8HHw+Q+
	kENWbU1pPtl8Q6y1u0oXYny3NQqDPDUZhnIKXi1nDzf+XMEsjrsFw3Q91MkDtWHjjBgG0kjTjiU
	USro/QqdT9bQ64bVKtxKUyYW2144FuMF9YYOlcnxlfpgncBLwqgYFTaGlQKuQfmoc1BWVRF92Yd
	Pz+4wT4aoAfSzfNLj7Bt+ZnOrSnfxvK4sU77EljjTn/mRCavWKfLX+rX19zkrj5P6QU9SPFD6yv
	bUVCQ974Yi8Qzud2pXaO4xKlHl+wcQp/pQ6y5EgQoQYyxqGMVeMfVRw2IRMwg2DJrA==
X-Received: by 2002:a05:600c:8206:b0:4a0:1f9e:5f78 with SMTP id 5b1f17b1804b1-4bb88787d87mr313848565e9.0.1795602371012;
        Wed, 25 Nov 2026 02:26:11 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb85399e2esm568463065e9.7.2026.11.25.02.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:26:10 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 1/7] multipath-tools: hwtable: reformat EMC/Celerra entry
Date: Wed, 25 Nov 2026 11:25:58 +0100
Message-ID: <20261125102605.82009-2-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125102605.82009-1-xose.vazquez@gmail.com>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Move product description inside the braces and drop the vendor name.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a37fa7d8..c6bf2d90 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -412,8 +412,8 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = 30,
 	},
-		// EMC Celerra
 	{
+		// Celerra
 		.vendor        = "EMC",
 		.product       = "Celerra",
 		.pgpolicy      = MULTIBUS,
-- 
2.56.1

