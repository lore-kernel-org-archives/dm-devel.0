Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A533351C0C
	for <dm-devel@lists.linux.dev>; Sat, 27 Jun 2026 09:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782551768; cv=none; b=CFPuI9k9NNGIoQjvlqamHXq3rVAr2qdqBXPkFfNzPf9EWDeTwEoA9xhNXmugHiPqfrViNoU1/4s36kRJ7mvdu5B8cDcMS2pHhh0QcrW5aV7nxIy3PyenLqXlJthCdyJ2HC1mQ68oy/6e+FdYbtvB+P9JkldF29Yi+B7NcA797s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782551768; c=relaxed/simple;
	bh=sTAhDUleXYtlvjsypG1oul3MvhHMsnPeBHtM1mSZpME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ONj+5gns0AN9dHo3YzVw8RTc0tTbbs+D1VYPTvwrx9v2wNkRla5gcY/6ghHRZlbJCb9z8Ri1AT5z4WPwzWl8tlhr7gQFT3xPHysHqSmGLYka6jbQ9eMJe20W1gFlaM6GMycTIvJ+g5SwdHQLIDQOyDkjysmr9Nt3uIjzum7RRNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=m/n1itRs; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=Chf0MxmK; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="m/n1itRs";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="Chf0MxmK"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4gnRjV3RPdz9tWS;
	Sat, 27 Jun 2026 11:15:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782551758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pXQ+5vRw8gFPOsPV7D/1ZGV5eGUKSwaLPREyxVc1zFc=;
	b=m/n1itRsS/aAWVXYzbQ7IF2q48yifmUJfhit3nzZP9H1J5NXfPGbs0ReLL/hZwdKn40bQU
	bSLHKCctVNl9h9swx3Kc/8RSw2hRcvW5dXlEB4u/HM5f4EStdxXl2+L5soFNZpv7KmS5ir
	Ew2nIQK1Ekr6/p1BuXNwYMBF0uHSu/kdF6bqsAUJ+VEW5RzkDOWUvq6Ud3zUtjFSM0S4DZ
	BN101D5XlHlAdlIiRkWORcFSFqxmBXL98FTLerzRolwRpng7Jsz/s55uFyykvR8VE+hLqL
	+6MWgJNrC68vuxFf8hK7lXaZFTzr6qgG69TREIMpOrytGODXU2vFRwk71DFs/g==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=Chf0MxmK;
	spf=pass (outgoing_mbo_mout: domain of manuelebner@mailbox.org designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org
From: Manuel Ebner <manuelebner@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1782551756;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pXQ+5vRw8gFPOsPV7D/1ZGV5eGUKSwaLPREyxVc1zFc=;
	b=Chf0MxmK2ONKnVlhFY2t4mYk6oRrCLmv3p/KV3SQX4DjG4BUuNlEYRfljWa1HQG2bwKGId
	f2oHZc/uHuH//NZB3Iw7QKdETMzoFDqoRYQG8czAowOoIOzDUH75go9brsBrLEWo7tUJat
	cZPD2wxjV+7H784QUkrno6xakBGfol/b/GLugnsijn2a5A0+FrbgENvOa0y+HahFMtL2dV
	BsR93hvmfCehuqJbBrnp8JaAjlFT+tQgtD2LwbnIP2lfxYsToWqJcyxdgcUMClm9W/6N8L
	xMPjW+i+H9TnwFbq2jih+z2ZjjQUd7qHyrZZfT/kCUVCpcXA4DSVb2Mko44Isg==
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kees Cook <kees@kernel.org>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-kernel@vger.kernel.org (open list)
Cc: Manuel Ebner <manuelebner@mailbox.org>
Subject: [PATCH] Documentation: device-mapper: adopt new coding style of type-aware kmalloc-family
Date: Sat, 27 Jun 2026 11:15:07 +0200
Message-ID: <20260627091506.29534-2-manuelebner@mailbox.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: if1srcg7xfuct4h3mouatgp5usae4eap
X-MBO-RS-ID: 54a6d1f2fbb6e1a076e
X-Rspamd-Queue-Id: 4gnRjV3RPdz9tWS

Change the Documentation to reflect this commit 69050f8d6d07 ("treewide: Replace
kmalloc with kmalloc_obj for non-scalar types")
kmalloc -> kmalloc_objs

Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
---
 Documentation/admin-guide/device-mapper/statistics.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/statistics.rst b/Documentation/admin-guide/device-mapper/statistics.rst
index 41ded0bc5933..2190b90118f8 100644
--- a/Documentation/admin-guide/device-mapper/statistics.rst
+++ b/Documentation/admin-guide/device-mapper/statistics.rst
@@ -30,7 +30,7 @@ region, etc.  Unique region_ids enable multiple userspace programs to
 request and process statistics for the same DM device without stepping
 on each other's data.
 
-The creation of DM statistics will allocate memory via kmalloc or
+The creation of DM statistics will allocate memory via kmalloc_objs or
 fallback to using vmalloc space.  At most, 1/4 of the overall system
 memory may be allocated by DM statistics.  The admin can see how much
 memory is used by reading:
-- 
2.54.0

