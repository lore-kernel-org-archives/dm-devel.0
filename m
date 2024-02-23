Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509AF12C802
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 17:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708662; cv=none; b=b8DXMew+8BBuOQAYXU92Y0/za0m38FKgM+Y4K0XUZlOnd4J+wf8vJbiEdQxL2ZgWvKMzzGMj7FxQtD7ju3cmYuyrM/Q+8A30fVq9lMwnZG/9WdrspaQsqZE3HDIsL7getS3Eae7lEcbgqytTC0S3XfiUNOt8zSrewXjOXJpoJ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708662; c=relaxed/simple;
	bh=uUh/WyYIbYsAfpy4+L2U+5AEMxonwfCxCyyaq0K7Xfk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YCQ7rwv5Mrv2BN5j8EhzGqkyR0Q+OIiNxOoo1Zw31vQAHG7hEos8uvEK3KYyocuulUSCkjOC8/L+5lUf7qRindhce6wTQjgM0lhVHqKzIZ4Oq9mgn8RTdMw1QPthq0ovxp2Usg2/jumjSUr83+etphmFE9/IdMuhpistONl8IPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-787ac9ddca1so81790185a.1
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 09:17:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708708659; x=1709313459;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7d5bEzl4Pfk/hPSxARER9ZRkgxcRli8GERqXAK0ZBGo=;
        b=u5gdzcfwvySgoqv52x1YRFcv3AK8V1J0YGONBAJCsvHex4VCHnW+AxB1c7W/x8s6/o
         YpjUHYu/h7vVbdYKXvdHR1Q1tm96ZwUC5q3otNLE/EJiM8V2Yu7zdfGhV08K9xfzXzf6
         ezw0+nljQaUMuLQe66rLS3C8Ba1YoEkrUAvmREeZewD1/8ZtZV8HkETnVtjpcXeUtTbK
         KvH3pzSpV+agDPOq8VKORW4dLZDRaZGuh5DlEw8p3+N52rxXOQVYeXhgHVJ4Paaf0puN
         5nDQEZzE5lDE1SF+2ClLIgqFuJUtadRbmSxSDAaLIDLCWU/H97X8eZ3hNrrW4idd9gNb
         B/0A==
X-Gm-Message-State: AOJu0YwSG0QHmgMCTwKfp69WfiOsPbg8XjltvT9+rOYH8D6RErAN0GaZ
	0VHohG17psMrNhZKxm6UUiW5bKxEzYTp2Bi1JPtGNxhH9BNZba4NeSeabqd+Vw==
X-Google-Smtp-Source: AGHT+IF5G0gsP29p/juoIFVDXB5cyHaaiyFCO/QrSTWgfFcIFkXe8vBN5FaTxKZTDDbYfaAi2puOVg==
X-Received: by 2002:a05:620a:f88:b0:787:a9af:d6b8 with SMTP id b8-20020a05620a0f8800b00787a9afd6b8mr659327qkn.8.1708708659302;
        Fri, 23 Feb 2024 09:17:39 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id v9-20020ae9e309000000b007877cc523f3sm3585957qkf.127.2024.02.23.09.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 09:17:38 -0800 (PST)
Date: Fri, 23 Feb 2024 12:17:37 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Alasdair G Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [git pull] device mapper fixes for 6.8-rc6
Message-ID: <ZdjTMZRwZ_9GjCmc@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 54be6c6c5ae8e0d93a6c4641cb7528eb0b6ba478:

  Linux 6.8-rc3 (2024-02-04 12:20:36 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.8/dm-fixes-2

for you to fetch changes up to 0e0c50e85a364bb7f1c52c84affe7f9e88c57da7:

  dm-crypt, dm-integrity, dm-verity: bump target version (2024-02-20 13:35:47 -0500)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Stable fixes for 3 DM targets (integrity, verity and crypt) to
  address systemic failure that can occur if user provided pages map
  to the same block.

- Fix DM crypt to not allow modifying data that being encrypted for
  authenticated encryption.

- Fix DM crypt and verity targets to align their respective bvec_iter
  struct members to avoid the need for byte level access (due to
  __packed attribute) that is costly on some arches (like RISC).
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmXY0iwACgkQxSPxCi2d
A1oG3Qf/WE0T5qyBnDZ7irhvJmSLVx4oAwzB0PmMtELZ3Tkyn7BBAxq1Q2I2UT3x
r90d1uy/pz6Y+kZkAPZjYuYLctukEa1swpfFe0Sn01dBrbgGU/p2vi3fkF+ZK6/t
n5EN8S5dkf6rIDmp8R56iP8mP4OEultYjLugxc6ROohFgHZicoqv+Pye9kHp0Y19
HSW2eueag/s2nMa9HKjIEd3+NBgmGb0qMMf3M6CXpRLNi/f/cyHbPzq83+eW3gcg
jl480w5YHk2nOUSqrO8UfIaP4BpD3SEXQxVqIzdkVX4cEBO4yRcBNrQpsT89GsXj
sg5zinkq3g7SThEpQWdpkeZMR/6q/A==
=n0nQ
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mike Snitzer (1):
      dm-crypt, dm-integrity, dm-verity: bump target version

Mikulas Patocka (5):
      dm-integrity: recheck the integrity tag after a failure
      dm-verity: recheck the hash after a failure
      dm-crypt: don't modify the data when using authenticated encryption
      dm-crypt: recheck the integrity tag after a failure
      dm-verity, dm-crypt: align "struct bvec_iter" correctly

 drivers/md/dm-crypt.c         | 101 ++++++++++++++++++++++++++++++++++--------
 drivers/md/dm-integrity.c     |  95 ++++++++++++++++++++++++++++++++++-----
 drivers/md/dm-verity-target.c |  88 +++++++++++++++++++++++++++++++++---
 drivers/md/dm-verity.h        |  10 ++++-
 4 files changed, 256 insertions(+), 38 deletions(-)
