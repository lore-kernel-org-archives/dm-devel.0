Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABC912D757
	for <dm-devel@lists.linux.dev>; Thu, 13 Jun 2024 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718296004; cv=none; b=Pe77hCiz/6AJ0nsQwMmbTGuRK80O+HswX0GcZvjT4jFk6Lmqewfp+m5EZ1t4hEnv2dAvkrqZiqVSk/qSd84UE1z8aiCTrnfqSIEpgNjxNhdqRfQ4kKfBFZ47L0ae0ZLOtO1ryyaZeL1EBk0r0/uNYm0cF516OEmdYVAeg7w3shw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718296004; c=relaxed/simple;
	bh=SLAMqQrPfN9uJV7ziyrWbCdtmQk1fwT2/ftGRh6ehlo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KTSkIwTyhAwQgchEsbjNhBG6bcqef+2mi4SBUvNaqmS9JYNSFQVFaVgfFnsww9tw5FOcHtXyhljGIfwSoa7IRYcNMm6lEIwir/jDGNmf+yo3VITYQ0rzyXVkT3ZqHQrDEwQFBM8ZqhW3NYT8BhtK4R5CUVCtokT6HbQmytrpb1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePvGThU2; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePvGThU2"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1f7028196f2so10674515ad.2
        for <dm-devel@lists.linux.dev>; Thu, 13 Jun 2024 09:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718296003; x=1718900803; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jpfupifUWRjEWXSRFkPnEzWD919BOKz8LYHjIiDIHpU=;
        b=ePvGThU2sCZGcn823/Zdma0bAsi29gHYa5LOJEmoqwaRe4/piM00hiA291N+P6/EMo
         5HCdTxQ3fqEOPwwlRd5Dj4n3bscC8vBR3g+jKSNscfaUJIxEYR2WD1xd139jTiwBf3Uy
         FZ5ALp+W2o2d+LWHW1Yr4+s3vtyto5gJYKOpDVLwqVwyVE6wTx5Bwc5mRbGv133hO1F3
         APspLgy3fY5DkGYZbHlmUp9lvlsf0ybWv9OHYmV5IYJ/GV0azqjN46flZ9jK21roq+5J
         2mxjsnJZAnnnF5+kmitoEZuD6zpbgwBX/Nx2haHIL9Skibc0gHvdjBPcQfJC9njam3u/
         +JbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718296003; x=1718900803;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpfupifUWRjEWXSRFkPnEzWD919BOKz8LYHjIiDIHpU=;
        b=ucvVUJ4/RrBk1qi4L37U5bbBcchuSwtkc3TAS77fMEPdMeaMqumayqJhUXrlFayPdh
         Zb9zMz4UbkAAjyRPmno62AR9+wnvGZQpM8j3nxxNWej8DP1H0nFJtFTnJ+CYMk1eWOEf
         rmsM/zsx5UOqixsuAzBIfrDKeSUzMNKJ/1hFRmRIS2jhBTloyGMZN9I/3dxXyz4s/CVW
         Ntc6jSsf8SeJ2cW6q2+ATOHuYPWxkoQO4lKinKy9kKkBSWQo9vwB+RASTxGbfJGWbsYZ
         xIkfbL2d9tfYGGOvT/wDgzq++onuQY0Dr4VqdqM03aQ+X//2D7OOQfGQN3ijg+R9tTOH
         XT/g==
X-Forwarded-Encrypted: i=1; AJvYcCWNyOOGbbwHLAGWJfJN8TiFVarIh2OeQfbcFbKIsiG5SvOxCo02qmGcZDLJiyYm0pwS43h1krqGybqKalaPyH28jkLt7OwEY9w=
X-Gm-Message-State: AOJu0YyMYxaECC6Xu+PdUuQCr1B9Y7bCCB4ZxRNIbnF8n1eDAArlCzpA
	FvlRYwuezMPXMQVY+WbEZZoAl+pFFsypPz7kftZGad5/GHkQHMAY
X-Google-Smtp-Source: AGHT+IFQZ7TreFX+MuHWfU3c8/pJOKTSk15d6PXmnzSSxZ4nnGjnuU1csrJaNr4+eDxIUFfcasMYwA==
X-Received: by 2002:a17:902:f54f:b0:1f7:42e6:ada2 with SMTP id d9443c01a7336-1f8627cab2amr1685545ad.41.1718296002522;
        Thu, 13 Jun 2024 09:26:42 -0700 (PDT)
Received: from dev0.. ([49.43.162.104])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855ee81bfsm15848995ad.137.2024.06.13.09.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 09:26:42 -0700 (PDT)
From: Abhinav Jain <jain.abhinav177@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: bmarzins@redhat.com,
	skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	jain.abhinav177@gmail.com
Subject: [PATCH v2] dm: Add support for escaped characters in str_field_delimit()
Date: Thu, 13 Jun 2024 16:26:32 +0000
Message-Id: <20240613162632.38065-1-jain.abhinav177@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove all the escape characters that come before separator.
Tested this code by writing a dummy program containing the two
functions and testing it on below input, sharing results:

Original string: "field1\,with\,commas,field2\,with\,more\,commas"
Field: "field1"
Field: "with"
Field: "commas"
Field: "field2"
Field: "with"
Field: "more"
Field: "commas"

Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>
---
PATCH v1:
https://lore.kernel.org/all/20240609141721.52344-1-jain.abhinav177@gmail.com/

Changes since v1:
 - Modified the str_field_delimit function as per shared feedback
 - Added remove_escaped_characters function
---
---
 drivers/md/dm-init.c | 53 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 2a71bcdba92d..0e31ecf1b48e 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -76,6 +76,24 @@ static void __init dm_setup_cleanup(struct list_head *devices)
 	}
 }
 
+/* Remove escape characters from a given field string. */
+static void __init remove_escape_characters(char *field)
+{
+	char *src = field;
+	char *dest = field;
+
+	while (*src) {
+		if (*src == '\\') {
+			src++;
+			if (*src)
+				*dest++ = *src++;
+		} else {
+			*dest++ = *src++;
+		}
+	}
+	*dest = '\0';
+}
+
 /**
  * str_field_delimit - delimit a string based on a separator char.
  * @str: the pointer to the string to delimit.
@@ -87,16 +105,39 @@ static void __init dm_setup_cleanup(struct list_head *devices)
  */
 static char __init *str_field_delimit(char **str, char separator)
 {
-	char *s;
+	char *s, *escaped, *field;
 
-	/* TODO: add support for escaped characters */
 	*str = skip_spaces(*str);
 	s = strchr(*str, separator);
-	/* Delimit the field and remove trailing spaces */
-	if (s)
+
+	/* Check for escaped character */
+	escaped = strchr(*str, '\\');
+	while (escaped && (s == NULL || escaped < s)) {
+		/*
+		 * Move the separator search ahead if escaped
+		 * character comes before.
+		 */
+		s = strchr(escaped + 1, separator);
+		escaped = strchr(escaped + 1, '\\');
+	}
+
+	/* If we found a separator, we need to handle escape characters */
+	if (s) {
+		*s = '\0';
+
+		remove_escape_characters(*str);
+		field = *str;
+		*str = s + 1;
+	} else {
+		/* Handle the last field when no separator is present */
+		s = *str + strlen(*str);
 		*s = '\0';
-	*str = strim(*str);
-	return s ? ++s : NULL;
+
+		remove_escape_characters(*str);
+		field = *str;
+		*str = s;
+	}
+	return field;
 }
 
 /**
-- 
2.34.1

