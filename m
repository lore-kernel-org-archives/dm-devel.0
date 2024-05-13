Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5528220332
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 17:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621811; cv=none; b=UxD+zfSJTF2XUR/GYhmE/zGcoDQ/6pr78Bs1LbnH0VnWK1HtJvUEqy4zgpf96ejR1TsW4+Irmk9ELz6V6ZgvLGMI5b4tpqv0EqcLZQt66TfGV06nlhE87RfajZb6vAHhEv+CntnX5d1+z/ccnpq75yoN0+jtfLkVhyTg1ci69CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621811; c=relaxed/simple;
	bh=E4L5D1BVhPwuBIRLImdWaJV3HE2Gbu8ZCARspKVW+/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=at4Yl4lx+EPBwaGlYaseLIe2NoSeAgTkaR08oPsfps8G5nf3SwElFiDAaSsKPR6n0Zbyu+FO/q+dxVZ4kB/ld6Dv0GIeGQVcUj5rZNd4mtnvqSK7m0ky25CH4JKWXU/i+Ax/wVKkvHQLvrx54TZZtuh9ekGFz5UnVREQ+e1hgGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wsyoy/Jt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wsyoy/Jt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715621809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4Nbkxf4VYyosS70Ln4GyrLcnmUbGdmO1b19FKW80WTI=;
	b=Wsyoy/JtRFs8RlaeSJZdzdyvy7ExOAMwqR+hdksNzl7hbemS0cOXyUnE5OqB1fqSn/aYjH
	BCDyznpzMhzKXh56p4VG098NijYradmR2r7R41lSQeQk8fulf+laR2wDtd5XB0Q2vbiIWA
	zlibkSmOUbzy7X1eXRvipdaabQDdRJM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-257-i87istTzNOe0up6RLqE06g-1; Mon,
 13 May 2024 13:36:47 -0400
X-MC-Unique: i87istTzNOe0up6RLqE06g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 503E81C0514C;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40E69561A;
	Mon, 13 May 2024 17:36:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44DHakXe094440
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 May 2024 13:36:47 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44DHakDI094439;
	Mon, 13 May 2024 13:36:46 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>
Subject: [PATCH 0/7] multipath-tools man pages: add missing information
Date: Mon, 13 May 2024 13:36:39 -0400
Message-ID: <20240513173646.94424-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset is inspired by:
https://lore.kernel.org/dm-devel/1673555329-9850-1-git-send-email-bmarzins@redhat.com/

It removes the useless pathgroup wildcards section from the "show
wildcards" output and adds wildcards descriptions to the multipathd.8
man page, along with some issing multipathd commands.  In the process of
doing this, I noticed some instances where either the man page or
multipathd wasn't giving the correct information, and fixed those up.

Benjamin Marzinski (6):
  multipath-tools man pages: don't assume multipath.socket is enabled
  libmultipath: print all values in snprint_failback
  multipathd: Stop double counting map failures for no_path_retry > 0
  multipath-tools man pages: add missing multipathd commands
  libmultipath: change the vend/prod/rev printing
  multipath-tools man pages: Add format wildcard descriptions

Nitin Yewale (1):
  libmultipath: remove pathgroup wildcard options

 libmultipath/print.c       |  22 ++--
 libmultipath/structs_vec.c |   5 +-
 multipathd/multipathd.8.in | 260 +++++++++++++++++++++++++++++++++++--
 3 files changed, 263 insertions(+), 24 deletions(-)

-- 
2.45.0

