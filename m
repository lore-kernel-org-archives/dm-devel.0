Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B629A5F
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177795; cv=none; b=b9c3tOfXxVqlLdW+gqH8HoMnBMQHBnbzZ0t+UoiIkIcPIGgRkg7uuxVnoM3jM0lrlYuhENPxCAva/AFVed4blYiutR9fpHvsZzz2ffwGZL++YX83H3ro13L79IGgFV+6X9adSr1xPHFtjBMRf7cDykfKlfERAaOHnYtQ5ddZuE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177795; c=relaxed/simple;
	bh=mPN94HIjAQpjiTzjCjl8SyhKp7Gk7OnPj55n0SQun40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TLOEPgCQhhnccfaDDMKyHCDlIhg6ZluOFw/QK1iXY9KBIFqV248uzy8wKQ4hbM8Qkm4Tn+3QpCUn7fc3QLi33ORPOF94e1CQyc8G2O1NQwwQfUuMFKwZGmWZTbMAEpmtTiNCO2cTyrrpWw0Av2r7KEWu0a+ARLOEymtrG2wQyiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V3yza+F/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V3yza+F/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JdUJbv2T/oPmgNjKjByCCBj5eR1UerN1TqEnQv4jZIw=;
	b=V3yza+F/RyO3O6E+pGNweJ08b4gxCXlISPi/7T4OlrgBPml6GjALNIO13U8ka3HElaFCuP
	78JK9gZhmb0BOMqHgV3iD2QJ4m4Y7ydyOkItUv+97pNKah/oFWVjddDzpyOTPHu/nmkWGE
	jclPqL4h1lP821xwef8DMb/0ZGUqAGU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-4kxuu36zNbSPSec-KEgEuQ-1; Thu,
 12 Sep 2024 17:49:52 -0400
X-MC-Unique: 4kxuu36zNbSPSec-KEgEuQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAEDF19560A3;
	Thu, 12 Sep 2024 21:49:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 127851956096;
	Thu, 12 Sep 2024 21:49:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnm7i783850
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:48 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnlKM783849;
	Thu, 12 Sep 2024 17:49:47 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 00/22] Yet Another path checker refactor
Date: Thu, 12 Sep 2024 17:49:25 -0400
Message-ID: <20240912214947.783819-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

This patchset cleans up some of the ugly code from my last refactor, and
speeds up multipathd path checking, by refactoring how paths are
checked.

multipathd previously ran the checker on a path, waited briefly for it
to complete, and if it did, updated the path and the priorities for the
multipath device and possibly reloaded it.

This had multiple issues.
1. All the paths waited for their checkers to complete serially. This
wasted time with no benefit. It also meant that it wasn't that uncommon
for a checker to not finish in time, and get marked pending.

2. The prioritiers could get run on paths multiple times during a
checker loop if multiple paths were restored at the same time, which is
a common occurance.

3. In an effort to keep a multipath device's state consistent despite
the delays introduced by waiting for the path checkers, paths were
checked by multipath device. However checking the paths could involve
reloading a multipath device table, or even removing a multipath device.
This added some ugly backout and retry logic to the path check code.

With this patchset, the code now first starts the path checkers on all
devices due for a path check. If there are path checkers that need
waiting it then unocks the vecs lock and waits 5ms. Next, it goes back
and updates the state of all the path devices. Once all of the paths
have been updated, it goes through each multipath device, updating path
priorities and reloading the device as necessary.

This allows multipathd to spend less time and do less redundant work
while checking paths, while making paths more likely to not spend a
checker cycle marked as pending. Since multipathd drops the vecs lock
while waiting, uevents and user commands can be processed while its
waiting.

Since there isn't a delay waiting for the previous checker before
starting the next one, the path checker code has reverted to checking
all paths in pathvec order, instead of by multipath device. Updating the
paths in pathvec order simplifies the code, since the multipath devices
can change during path updates. Starting the checkers in pathvec order
keeps a path from having its checker started towards the end of the list
of paths but checking for the result towards the start of the list of
paths.

Changes since v1:

The original patches have been updated based on suggestions from Martin
Wilck (patches listed using their original numbering):

- Moved checker path_state initialization code from 06 to 01
- Check for NULL before dereference in checker_get_state() in 04
- Moved adding start_checker to version file from 07 to 06
- Renamed check_path_state() to get_new_state() in 08. updated 09, 11,
  and 12 to deal with the name change.
- Added new patch before 13 ('fix "fail path" and "reinstate path"
  commands') to fix issues with manually failing and reinstating paths
  between when the checkers are run and the paths are updated
- Fixed check in update_paths in 13
- Split patch 13 into three patches, one to move priority updating out
  of the individual path updating code, and two others to clean up some
  of the logic about updating priorities and path groups.

After the now 18 patches from the original patchset, four new patches
have been added to move the waiting for pending paths out from
checker_get_state() and into the existing waiting code in checkerloop().
Doing the waiting outside of the checkers (in fact, outside of the
vecs lock completely) means that we can't wait till a checker has
completed. We must just pick a time and wait for all of it. On Martin's
suggestion I picked 5ms. Since multipathd isn't sleeping with the vecs
lock held, it's much less critical to do this quickly.

For checker run in pathinfo, I kept the previous timeout of 1ms, but I
waffled on whether to wait at all here, and I'd be perfectly fine with
removing the wait altogether, and just let the paths be pending when
called from multipathd with async checkers.

Also, I've just added these patches to the end of the patchset to make
it easier to see the changes from v1, but if people want less churn in
the checker code commits, I'd be find with resending this patchset with
these patches refactored into the earlier patches.

Benjamin Marzinski (22):
  libmultipath: store checker_check() result in checker struct
  libmultipath: add missing checker function prototypes
  libmultipath: split out the code to wait for pending checkers
  libmultipath: remove pending wait code from libcheck_check calls
  multipath-tools tests: fix up directio tests
  libmultipath: split get_state into two functions
  libmultipath: change path_offline to path_sysfs_state
  multipathd: split check_path_state into two functions
  multipathd: split do_checker_path
  multipathd: split check_path into two functions
  multipathd: split handle_uninitialized_path into two functions
  multipathd: split check_paths into two functions
  multipathd: fix "fail path" and "reinstate path" commands
  multipathd: update priority once after updating all paths
  multipathd: simplify checking for followover_should_failback
  multipathd: only refresh prios on PATH_UP and PATH_GHOST
  multipathd: remove pointless check
  multipathd: fix deferred_failback_tick for reload removes
  libmultipath: add libcheck_need_wait checker function
  libmultipath: don't wait in libcheck_pending
  multipathd: wait for checkers to complete
  multipath-tools tests: fix up directio tests

 libmultipath/checkers.c           |  47 ++--
 libmultipath/checkers.h           |  10 +-
 libmultipath/checkers/directio.c  | 144 +++++++----
 libmultipath/checkers/tur.c       |  78 +++---
 libmultipath/discovery.c          |  97 +++++---
 libmultipath/discovery.h          |   6 +-
 libmultipath/libmultipath.version |   4 +-
 libmultipath/print.c              |   2 +-
 libmultipath/propsel.c            |   1 +
 libmultipath/structs.h            |  21 +-
 multipathd/cli_handlers.c         |   1 +
 multipathd/main.c                 | 399 ++++++++++++++++++------------
 tests/directio.c                  | 182 ++++++++++----
 13 files changed, 643 insertions(+), 349 deletions(-)

-- 
2.45.0

