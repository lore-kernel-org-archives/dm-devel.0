Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA73F393DF2
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 20:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777494081; cv=none; b=d6wrH9oBhIMiL8zuKoHGTVe5hfCYRuQQbZm4o7RtyVEbz0wxA3A4fosn4eGSFWQeLgnGubnobJby7CY+ec+pTnqPhOVtG66addpI/1+eos4Y05w1LXKvnEpccwcPJfDsmTPTQKgQopXy+ObLiIomFGuGWxV0OPXcTi4RlMTSKTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777494081; c=relaxed/simple;
	bh=5nTyOwdMYanm7hNJTUM/TSInNM4qMG3i1lCtm03jVcw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=UoEsikROFuq7lpcuKgkWzpe/Sckdode2WD2DjNTU7Vo07hO/MzBg4TO+32wND/Y3NId8sB8E5Jq5Hr2694ZmVB+sMiUV6bGEDDEmBJYAK88jFfNbSvpuonhAvgPE7Rl8vT7LTgUJDaO5udfveEa76I56Uwp67a+2804/CJ0mH0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=amT8J7fF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="amT8J7fF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777494079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8VK6nM9SAk0NXUMrwNMnfZkodOPfnvsT0a7R2BtP0JI=;
	b=amT8J7fFptzcDEGHVdluNsysKpJgenZgbqeIqyjwPV7Hwu159n3B7v/gpWMPJ7wXOJo2/0
	pPdnCdJcFKmTmz583cmT9P1umAq5WCK7Rx/zKjeAT+EVJxifidiYiKdZ/hn5Ujb/RyjUX6
	+OFudBliZrz3fAgWRXejbT5Jv3k+eus=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-4A5Tj6KQNYSQpuM4FTivjA-1; Wed,
 29 Apr 2026 16:21:14 -0400
X-MC-Unique: 4A5Tj6KQNYSQpuM4FTivjA-1
X-Mimecast-MFC-AGG-ID: 4A5Tj6KQNYSQpuM4FTivjA_1777494071
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 590261800352;
	Wed, 29 Apr 2026 20:21:11 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB80030001A1;
	Wed, 29 Apr 2026 20:21:10 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63TKL9I62823280
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 16:21:09 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63TKL8B82823279;
	Wed, 29 Apr 2026 16:21:08 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        steven chen <chenste@linux.microsoft.com>
Subject: [PATCH v2 00/10] Fix dm-ima bugs
Date: Wed, 29 Apr 2026 16:20:58 -0400
Message-ID: <20260429202108.2823261-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: P_xKvJ8fly_-QP_Cloc8YCAfQDS4X7dbw-KlB5ann6o_1777494071
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The dm-ima code does not guarantee that the dm_ima_measure_on_*
functions will not be called at the same time. Since they modify and
free shared memory, this can lead to Use-After-Free errors or garbage
measurements. Further, they don't make sure that the state they measure
corresponds to the actual device state. For instance if table_load()
runs at the same time as do_resume() on a table swap,
dm_ima_measure_on_device_resume() can end up thinking the wrong table is
active. Or a concurrent dm_hash_rename() and a table swap, can end up
with a the new active table still using the old name. This patchset
makes sure the the dm-ima function are serialized and report the correct
device state.

However, the code is still messier that in could be. This is because
it duplicates the current measurement events and format. I would really
like to know if that is necessary. Specifically, it currently measures
the following dm device and table actions:

load
clear
rename
resume
remove

I don't see the benefit of reporting changes to the inactive table, or
resumes where the device does not change state. From the user's point of
view, the device is still the same after these events.  At the same
time, it doesn't measure device creates if no table was loaded, so you
can have situations where the the first measurement for a device is a
rename or a remove. A more sensible set of actions to measure would be:

create
table_swap
rename
remove

Also, the measurement format doesn't map well to how dm device's are
actually set up, in a way that makes it harder for the code and records
extraneous information. First, like I mentioned before, I don't see the
benefit of measuring the inactive table. Second, the name, uuid, and
major/minor numbers are properties of the device, not it's table (and dm
devices can't have partitions, so the minor count will always be 1). I
don't see a reason to store and occasinally log this information twice,
if there is an active and incative table, and it forces extra
coordination between the dm_ima_measure_on_* functions.

I'm wondering it we are stuck with the current events and format, now
that this has been released? Or could we bump the version, and change
what events we measure, and how we format the output?

Changes in v2:
- 05/10: Switched from using atomics and barriers to using a spinlock to
         serialize the dm_ima_measure_on_* functions
- 05/10: Fixed typos in comments and commit message
- 06/10: changed no_data string from "table_rename" to "device_rename"

If this patchset is going in largely as it is, I should point out that
there are changes to the ima measurements in corner cases, where the
data was previously incorrect (as mentioned in the patches). However
it's possible, although I don't think very likely, that systems are
expecting these incorrect measurements. We could bump the version number
because of this possible change in the measurements, but IIUC, since
this version number itself is part of the IMA measurements, that would
guarantee that systems would get different measurements. 

Benjamin Marzinski (10):
  dm-ima: remove dm_ima_reset_data()
  dm-ima: remove broken last_target_measured logic
  dm-ima: Remove status_flags from dm_ima_measure_on_table_load()
  dm-ima: don't copy the active table to the inactive table
  dm-ima: Fix UAF errors and measuring incorrect context
  dm-ima: remove new_map from dm_ima_measure_on_device_clear
  dm-ima: Fix issues with dm_ima_measure_on_device_rename
  dm-ima: Handle race between rename and table swap
  dm-ima: Fail more gracefully in dm_ima_measure_on_*
  dm-ima: use active table's size if available

 drivers/md/dm-ima.c   | 492 +++++++++++++++++++-----------------------
 drivers/md/dm-ima.h   |  68 ++++--
 drivers/md/dm-ioctl.c | 146 +++++++++++--
 drivers/md/dm.c       |   2 +-
 4 files changed, 410 insertions(+), 298 deletions(-)

-- 
2.53.0

