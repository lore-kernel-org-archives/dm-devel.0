Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79B629E0FD
	for <dm-devel@lists.linux.dev>; Fri, 31 Oct 2025 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761939229; cv=none; b=JXaKXvozCEDbhRljZu/brnY0SQd1opmtRIpNH8Fh3DvcAehvVKVz+Y4dKyww+749Ey3yB3o79ZY4O/2bgchi2jmmTpzzp6Gy8ltlhzX8TjXjWB2JOcc7TJBUpxbdAVSpqXkPqENWtvWwohcYMQdjsX7PeKI+OhtMTjGziTsoBrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761939229; c=relaxed/simple;
	bh=frbC0Rw+OL5ZdWRRastnAgdLYqpTGEnueEh2MgFN/WU=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=IkTu+6m5RZJ3GsdfduCDnnKYRnKCGZpDwe38/KsYP9REDRYOv7wQqYlW8S18LeC/tw1E6Kn9JYfv5lWAKs0d2o1ufsk3+PpldPy6Xhs1IDrCw9i9/RIbI4yW+9eg4Bc7ZDJL+PU9txcDkaXObPQISAqrRRDuxNRitsu91FGZlvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=GHNI5cU9; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="GHNI5cU9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1761939207; x=1762544007; i=markus.elfring@web.de;
	bh=sNhnZJkJaoKiwMBEiyuw8YB21zIlkECWE59Cg04Ftcs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=GHNI5cU92bRQoY/p5gzDv+qsjh1W+hfiDAAERQ0V1SjOKqX386HAkVoPg2pqcT7l
	 7bgJyk5nP4gHmw2g0UWenkC4G2h+nj9CBfgcGltfx/oMSQogFDD2FT31QN3o92cff
	 Qkm37C2uQifngXNVAV4LAHh6+vR50TMoSs9JBO9PbCpcLUdoVutGTjomq6dgzrYcB
	 4Y4PdlRz5VK+AIFf8vcsGN4QqwNX1jkvt52BzkrZFUag9dq8Z1OsrPWgT/noZhtfh
	 TGea91V9POZcLIheOzT+NVcCElAgfqFDqXpa2K9Cqwqetzk75+yTQ0WQikmyh7WN8
	 sJXidy2QnmHmPv3+mA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.206]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MTOli-1vgVNy41Ii-00Imgl; Fri, 31
 Oct 2025 20:33:27 +0100
Message-ID: <b803a5a1-c2bf-4aad-9527-198e8a8046ca@web.de>
Date: Fri, 31 Oct 2025 20:33:24 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>, Josef Bacik <jbacik@fb.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Ross Zwisler <ross.zwisler@linux.intel.com>, Zach Brown <zab@zabbo.net>
Content-Language: en-GB, de-DE
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Miaoqian Lin <linmq006@gmail.com>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] dm-log-writes: Use pointers from memcpy() calls for
 assignments in two functions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:a0SbjzaEosKsewhHcTQSTvju80PLjDDKewfmjob+EKf1OB+CJMM
 nhaV0kUEw+RYn3oY8lHoC1A5U5ui09bALFPnqfKUWcB24OPuzEHTI6tMUdXNN6pY8fUw/eB
 HQlqiAkEWq6qlfCcX45Zzg+EL3/G4UTfQhb7sDiYSX6ut7QULy6ThfoQ843CHaHU20tA50b
 P0FcyAbIu32yCChe66aVA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:S+KXkM3HboU=;snc5tIfW3PATdxdqb8p4QGbXP6+
 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

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 31 Oct 2025 20:20:56 +0100

A pointer was assigned to a variable in two function implementations.
The same pointer was used for the destination parameter of a memcpy() call=
.
This function is documented in the way that the same value is returned.
Thus convert separate statements into a direct variable assignment for
the return value from a memory copy action.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/md/dm-log-writes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 7bb7174f8f4f..b450bdadfaf2 100644
=2D-- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -232,8 +232,7 @@ static int write_metadata(struct log_writes_c *lc, voi=
d *entry,
 		goto error;
 	}
=20
-	ptr =3D kmap_local_page(page);
-	memcpy(ptr, entry, entrylen);
+	ptr =3D memcpy(kmap_local_page(page), entry, entrylen);
 	if (datalen)
 		memcpy(ptr + entrylen, data, datalen);
 	memset(ptr + entrylen + datalen, 0,
@@ -287,8 +286,7 @@ static int write_inline_data(struct log_writes_c *lc, =
void *entry,
 				goto error_bio;
 			}
=20
-			ptr =3D kmap_local_page(page);
-			memcpy(ptr, data, pg_datalen);
+			ptr =3D memcpy(kmap_local_page(page), data, pg_datalen);
 			if (pg_sectorlen > pg_datalen)
 				memset(ptr + pg_datalen, 0, pg_sectorlen - pg_datalen);
 			kunmap_local(ptr);
=2D-=20
2.51.1

