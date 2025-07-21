Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92B328C020
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 09:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753090199; cv=none; b=caDE6Q7g5cxafotR5174Rz3dxG0QXN6K4JyVktEvDky5ESs9QspGi/FtuwvvIQH/Rm+oo/XHOO5lbbUqFsW3EsB+63VrV03EVI0TXl93s+RnuViqg5sHAfulu5OY9jrEhuxj5JmLsBqvhKIIkB8QHdaus37dqY+Gf3DLT1M5oJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753090199; c=relaxed/simple;
	bh=FwepOe3FCnp2nwUtt3aFuOn26Q6HkWf8mVYRZaz/aAU=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=R/T+e7gHlIsHoewwf7sMvNb1/s17l5cyegYhjdQeWnAOLtwAMJHZz9Af+voMWlMftBsTs0N+YGAyyE4iaQKCC46D0xew2Bx6c823scdh7xwvVJ8kgteHq7n0A6MapjmtaPQI2sN1D3ogWI4KeMzQbAOoEjCi0IvEkSYpDMRvCqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1Q9nziY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1Q9nziY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753090196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=i3reXnLZS0FfK/sS81pr3ltBWY5lIxqZasoHE+bK48I=;
	b=e1Q9nziYoSKmJmxRJ45VjSFGuAnLHSNG218tQ+FaoUoYeEIMNSt4cCYyD2lfMlPceDSu13
	CadvBmxQaAB16yzZmr7GUI7hMUC+DeziRgOO9gm7XUIpvxpm/Sa7TWisL6tR5zpAoyvHNM
	HbJva6iwYQaezHykHjXwktJOyNg0Xkg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-313-faXcBnUhNyuz7MWk8RWCnw-1; Mon,
 21 Jul 2025 05:29:55 -0400
X-MC-Unique: faXcBnUhNyuz7MWk8RWCnw-1
X-Mimecast-MFC-AGG-ID: faXcBnUhNyuz7MWk8RWCnw_1753090194
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24C841800165
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 09:29:54 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC4BF1956094;
	Mon, 21 Jul 2025 09:29:52 +0000 (UTC)
Date: Mon, 21 Jul 2025 11:29:48 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matthew Sakai <msakai@redhat.com>
cc: zkabelac@redhat.com, dm-devel@lists.linux.dev
Subject: LVM testsuite failure with VDO
Message-ID: <11d4215f-06b4-84a2-29ab-a558c25c6331@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3U3-wEh5KR7yktuqTCImPlQjpCzPoinFI6vphVHC2c4_1753090194
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

When I install VDO tools version 8.3.1.1 on Debian Sid and I run the LVM 
testsuite, I get failure in these tests:

shell/lvchange-vdo.sh
shell/lvconvert-thin-from-thick.sh
shell/lvconvert-thin-vdo.sh
shell/lvconvert-vdo-raid.sh
shell/lvcreate-vdo.sh
shell/profiles-vdo.sh
shell/vgsplit-vdo.sh

There are these syslog messages:

| [ 0:00.988] [2498.650738] <6> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: table line: V4 /dev/dm-2 1310720 4096 32768 16380 deduplication on compression on maxDiscard 1 ack 1 bio 4 bioRotationInterval 64 cpu 2 hash 1 logical 1 physical 1
| [ 0:00.988] [2498.652339] <6> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: loading device '252:3'
| [ 0:00.988] [2498.652867] <6> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: zones: 1 logical, 1 physical, 1 hash; total threads: 12
| [ 0:00.988] [2498.686527] <3> 2025-07-18 20:00:38  device-mapper: vdo: vdo0:journalQ: A logical size of 584704 blocks was specified, but that differs from the 584729 blocks configured in the vdo super block
| [ 0:00.988] [2498.688822] <3> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: Could not start VDO device. (VDO error 1473, message Cannot load metadata from device)
| [ 0:00.988] [2498.890909] <6> 2025-07-18 20:00:38  device-mapper: vdo0:lvm: vdo_status_to_errno: mapping internal status code 1473 (VDO_PARAMETER_MISMATCH: VDO Status: Parameters have conflicting values) to EIO
| [ 0:00.988] [2499.077804] <3> 2025-07-18 20:00:38  device-mapper: table: 252:3: vdo: Cannot load metadata from device (-EIO)
| [ 0:00.988] [2499.078890] <3> 2025-07-18 20:00:38  device-mapper: ioctl: error adding target to table

When I use the version 8.3.0.73 on Fedora Rawhide, VDO tests don't fail. 

Do you have some idea how to debug it and why is it failing with the "A 
logical size of 584704 blocks was specified, but that differs the 584729 
blocks" message?

Mikulas

