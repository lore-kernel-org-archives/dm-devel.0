Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69BD405FB
	for <dm-devel@lists.linux.dev>; Wed,  2 Oct 2024 14:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880181; cv=none; b=NNb04iUrjplKR7i5Yzk+0FG+QvrVNbWl+AzU/p2MOefL6egX7sVbjcgBo7K/l+D6lhHfWQFC0uC/9Vz7dY7L6fto2F0q5/lE7UGDEv+AkEZkKtPzGjLv8iefZwJPY8E0zn7aNyzD4lcusiCGnXtFwWGTX3nZDqBim9SToEYJ/YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880181; c=relaxed/simple;
	bh=k2chyUKBkefQImvxp7g6wewT9eb3xa/ufurtSBEvpKk=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=DCrActWUwtC8MPB1TzEmNvimLX9a0+8rS2YdZW84iqCCdBWEkVLZnIM0b9G9AaomfpoIBpw2ctb4yP1fnzC4YWn7Rai1bT/Gg2fSZQYrT59HL33oO/BbXFjE4fsuvK40H5h4ghWlKlH/KErZ1FgaQ1qnuVm9OLhvd+Bm5MaXjfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NUkI92fU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NUkI92fU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727880178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=vkBDBSOEUheM76YZq+ISQrbYge/JfrxmXXmCjyUI1b8=;
	b=NUkI92fUxrI3n2oAbkQXT8UWJQ0g8ta+6MiU03xnqyaxvrtbhbtXLdmH3PF8D9Csauc4pt
	iBZId5EB+PngI7Wwc9IWHlSS3P02vnTD0LQ1erDeOAHdnCKylUdrgsk9gSGS7dazLk1VTg
	s+gnovRKGvfuWN6PfBADMOokppJb4Dk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-DLABvQLhNciuclTXL9i8jg-1; Wed,
 02 Oct 2024 10:42:57 -0400
X-MC-Unique: DLABvQLhNciuclTXL9i8jg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 736EA1955EE7;
	Wed,  2 Oct 2024 14:42:56 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FB0619560A2;
	Wed,  2 Oct 2024 14:42:54 +0000 (UTC)
Date: Wed, 2 Oct 2024 16:42:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Sami Tolvanen <samitolvanen@google.com>, Will Drewry <wad@chromium.org>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 6.12
Message-ID: <2790bb57-22bd-f146-570b-9f4956838a6e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 9852d85ec9d492ebef56dc5f229416c925758edc:

  Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-6.12/dm-fixes

for you to fetch changes up to f811b83879fb6717cdb288e34253cf26d135b019:

  dm-verity: introduce the options restart_on_error and panic_on_error (2024-10-02 16:21:08 +0200)

Please, pull, thanks
Mikulas

----------------------------------------------------------------
- revert the patch that makes dm-verity restart or panic on I/O errors

- add new options that enable restart or panic on I/O errors
-----BEGIN PGP SIGNATURE-----

iIoEABYIADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCZv1YFxQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbTXKAQD29bvBnFN69zYYvrX3X7fHy6o/eOxU
oZJbFpvA2G+NigD+McEsLzOvOE1ZC/okkB/UUfju/ChEvACIgsNXGkPK2Ag=
=ygvr
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Mikulas Patocka (2):
      Revert: "dm-verity: restart or panic on an I/O error"
      dm-verity: introduce the options restart_on_error and panic_on_error

 drivers/md/dm-verity-target.c | 94 +++++++++++++++++++++++++++++++++++--------
 drivers/md/dm-verity.h        |  1 +
 2 files changed, 79 insertions(+), 16 deletions(-)

