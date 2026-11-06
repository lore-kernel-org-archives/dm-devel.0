Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.101.131.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978736;
	b=wOsjp+LWUGzh5azQK0yVcHjrVasd+RGxR7yWxMowlCDryv5cH0iwMf1T1IlL5HzAK1HH
	 jz/Cl1+g/nv/Ofh6T48K6gms4AnDjYb//o+gVDgnw5GTYEWOh/0DiPgLrU/4Dc6bZujzJ
	 nDpU/kUFSxG0KuZsx+Y3LJ1IbuwcOE4UHTa2qCOe0WkSS7f6YfrBaR16tZsMc+M1ZOnKv
	 fqfxpnqK45RblQRqehZwn7nWwddouRGGDsojcAZNR1adc+HM0MhIJ9OiCNGrwgr5GaB05
	 nnJAeQ8UwthSy6Exd0tDbwNLb+GkuRXQygjO5dS7gSjgNT0MwFRbKql5DQJFbCjaH3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978736;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfPbeB75l3XwMMZN8kk1GGrGHVsQyXyZBqu10FUZDzc=;
	b=o9PnJQEalwEg82OQVrT3o9a6WhWW+oL0lwrEfAnPiHmM5yMDFCZSlqV/QBHzTxyKL0n/
	 C64cKynn3zXovQWdUF/rBe7gbH/6dGvxPCASq3KM9MAkqYVyy/DsqXvglDIQVbbSGZ1zB
	 j5DshKUzUL+ucw8UvDWF53Gz0BE9qeQW/yUlP/rszK+Hu2rEeaRNcQhABXd37BEm/5A7Q
	 ebkP2h6Xj8nHAhdMjrK+RCswtOavFOeWaein91NPk0P6C1+p8hNkJEdn/I4P2+v8s/8jx
	 MM1TXS5AlYeL28IBiaZLZgOSvgEIaZ7TNrJpmRYEgW4xj0mN3usMIiNwwgZjMMvnozQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=citrix.com;
	spf=pass smtp.mailfrom=citrix.com;
	arc=none smtp.remote-ip=160.101.131.9
Received: from na1pdmzitismtp02.tibco.com (unknown [160.101.131.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E50606A329
	for <dm-devel@lists.linux.dev>; Fri,  6 Nov 2026 15:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8E50606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
Received: from mewpvdipd1100.citrite.net (unknown [10.113.40.46])
	by na1pdmzitismtp02.tibco.com (Postfix) with ESMTP id 060E9850EC18;
	Fri,  6 Nov 2026 10:24:17 -0500 (EST)
From: Alex Brett <alex.brett@citrix.com>
To: dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alex Brett <alex.brett@citrix.com>
Subject: [PATCH] libmultipath: open_file: rewind after writing the header
Date: Fri,  6 Nov 2026 15:24:44 +0000
Message-ID: <20261106152444.1541438-1-alex.brett@citrix.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When creating a new file, open_file() returns it with the offset after
the header it has just written, but on opening an existing file it will
return it with the offset at 0.

_read_bindings_file() reads sequentially from the returned fd, so on a
newly created bindings file the header check in _check_bindings_file()
hits EOF and declares the file bad. Without -B this is masked by
rewriting the file, but "multipath -B" may not write it and aborts:

  ERROR: bad settings in read-only bindings file /etc/multipath/bindings
  fatal configuration error, aborting

This affects the first "multipath -B" on any system without a bindings
file, such as an installer environment.

The wwids and prkeys code paths seek before every access and are
unaffected.

Fixes: 7eaeb33ae9f7 ("multipathd: watch bindings file with inotify + timestamp")
Signed-off-by: Alex Brett <alex.brett@citrix.com>
Assisted-by: Claude:claude-opus-5-5
---
 libmultipath/file.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/file.c b/libmultipath/file.c
index ce9ff610..215a48cd 100644
--- a/libmultipath/file.c
+++ b/libmultipath/file.c
@@ -159,6 +159,11 @@ open_file(const char *file, int *can_write, const char *header)
 			goto fail;
 		}
 		fsync(fd);
+		if (lseek(fd, 0, SEEK_SET) < 0) {
+			condlog(0, "Cannot rewind file %s : %s", file,
+				strerror(errno));
+			goto fail;
+		}
 		condlog(3, "Initialized new file [%s]", file);
 	}
 
-- 
2.53.0

