Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8B01F12E9
	for <dm-devel@lists.linux.dev>; Sat, 26 Jul 2025 03:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753502347; cv=none; b=s7BE6eQKi+q/yNgpRjFv2zc76GXLfUU4E7oFpUKCHSMyyECVPQtHkTMsuVccOA4iDv9AIxRbgGFCaZhBq7BsuBF+jOfTwxPLqrv9kVgy9urPwAiHA61vSxIuHDMMarBW7sHbptXOyOh3ua2SDrKPwT5BpckJkRQiJFt1aQeOQ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753502347; c=relaxed/simple;
	bh=Ne5H9D2bql1DNstbSaCTUVcL9y76SUrBaFscNQFI7yM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=unlRdPHLft61E9Qg3dNeU5C2B5w/3rPUJDyXbLXGWln2+Jcpl1PX/8AueOc/76dBc+AUmd0SzMq2VQK8r7k6TSKuM64nREXQdBl1283lHG6+pq/YaJup8XgW/EwzH9CQL4A8En58bxBKAP72t6Xi022WHUIvuLBeBMniJSpUC3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPkqsyLu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPkqsyLu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753502344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RY416vRaxVoeI9okTfkBv4S5L82vlHT0XREVaRrf9iA=;
	b=VPkqsyLurZOzC+cQom1Olhdhg6VWettW+pGhxMpgTcjKK5ecLUFwYmmVDsgWtoa5rEyH40
	hTl40ewX9yZGAyAWMq2YxmtM7xJEPq0qjBXVubFPPcdyjnqoGZFeo7IuT8pDbGBH2nL1v0
	JhArYfglOXcl+rHwf6X1tWHmQ4DV1LA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-IKivmB_2NsKY8QL8HIqBKA-1; Fri,
 25 Jul 2025 23:59:00 -0400
X-MC-Unique: IKivmB_2NsKY8QL8HIqBKA-1
X-Mimecast-MFC-AGG-ID: IKivmB_2NsKY8QL8HIqBKA_1753502338
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91E9C195609F;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 483531966666;
	Sat, 26 Jul 2025 03:58:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 56Q3wuOh363313
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Jul 2025 23:58:56 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 56Q3wtRn363312;
	Fri, 25 Jul 2025 23:58:55 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 00/14] Additional fixes and cleanups
Date: Fri, 25 Jul 2025 23:58:41 -0400
Message-ID: <20250726035855.363290-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cVbZnNfWz_dP8ZE-0i9er-vEIupm9Obdh0UDDLIee04_1753502338
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This patchset builds on top of my previous libmpathpersist patchset,
("Improve mpathpersist's unavailable path handling") and add various
fixes and cleanups to multipath's persistent reservation handling.

The issues handled by this patchset are:
- Handling removal of keys from paths that were down when the multipath
  device was unregistered.
- Changing how conflicts on key registration are handled. Instead of
  the current rollback method (which was broken anyways),
  libmpathpersist now retrys with REGISTER AND IGNORE, as long as the
  REGISTER command completed successfully down some of the paths.
- Changing when the reservation key is set to fix corner cases on
  failure and registration while paths are coming up.
- Retrying on conflicts in mpath_prout_common to fix corner cases when
  a path is coming up while a doing a reserve, preempt or clear.
- Allowing registrations to succeed when there are retryable errors, 
  if the paths are actually down.
- Fixing the reservation key validation code

I realize that a number of these fixes are dealing with races between
libmpathperist and multipathd, which points to shortcomings with the
current design of libmpathpersist. The code could likely be simpler and 
more robust if limpathpersist was a thin wrapper around commands to
multipathd, which handled issuing the actual persistent reservation
commands. However, we have customers that need persistent reservations
working well on currently released versions of the mutipath-tools, and
redesigning how the libmpathpersist library works is a much larger task,
and even harder to backport. I'd like to know if people think that would
be a worthwhile task for later, however.

Benjamin Marzinski (14):
  limpathpersist: remove update_map_pr code for NULL pp
  libmpathpersist: move update_map_pr to multipathd
  multipathd: clean up update_map_pr and mpath_pr_event_handle
  libmpathpersist: clean up duplicate function declarations
  multipathd: wrap setting and unsetting prflag
  multipathd: unregister PR key when path is restored if necessary
  libmpathpersist: Fix-up reservation_key checking
  libmpathpersist: change how reservation conflicts are handled
  libmpathpersist: Clear prkey in multipathd before unregistering
  libmpathpersist: only clear the key if we are using the prkeys file
  libmpathpersist: Restore old reservation key on failure
  libmpatpersist: update reservation key before checking paths
  libmpathpersist: retry on conflicts in mpath_prout_common
  libmpathpersist: Don't always fail registrations for retryable errors

 libmpathpersist/libmpathpersist.version |   1 -
 libmpathpersist/mpath_persist_int.c     | 363 +++++++++++++-----------
 libmpathpersist/mpath_persist_int.h     |   2 -
 libmpathpersist/mpath_pr_ioctl.c        |  12 +-
 libmultipath/structs.h                  |   2 +
 mpathpersist/main.c                     |   2 -
 multipathd/cli_handlers.c               |  11 +-
 multipathd/main.c                       | 132 +++++++--
 multipathd/main.h                       |   2 +
 9 files changed, 311 insertions(+), 216 deletions(-)

-- 
2.48.1

