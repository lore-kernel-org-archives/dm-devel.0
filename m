Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7903A382B
	for <dm-devel@lists.linux.dev>; Fri, 28 Aug 2026 05:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895859; cv=pass; b=CDuIc7DfOHA6h1TkG7XXtZYfGGkY79EJr8X8OQkebOKrl6iKxECOboZNL/5mcRYgItk5+dwnaIcqV0K4VQkEsUMkGCRJ3Y6A7gfRIkBTXj6iwTj3f5CLl+oCZoDMtYzYHFqYRQYdQN6DeImzdZETNwxWa+p42JyfkHO6hYboKTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895859; c=relaxed/simple;
	bh=Hf8b7jdlKiatljSC2B8q72HO9lbL1UdDOmM2gz+ngc4=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=QdwHNsT/sflJF0HlFgpqwdkd1LNNmjfC7jeoFvqKuu1kV+J4Raj8Gp3P0gPaLsSVXXVYdbEHRr51Cp5uhMIF01IJeta36V2AsGAsSv344WDbAAEaZeDrK2vTnl9Ag3WCf8dyEoJ9QiuuT5KkMLX7GAhUlbHSU4vePIqz8UdqRDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=C8LUEYEX; arc=pass smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="C8LUEYEX"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d710632717so4149435ad.0
        for <dm-devel@lists.linux.dev>; Thu, 27 Aug 2026 22:44:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787895858; cv=none;
        d=google.com; s=arc-20260327;
        b=hq6NSFeD9MHYsiDuYoi7eV6Q3RcEUq2FSJH6hcYZZEqi6+PDjgKI4BnNfwckvcuSyq
         nBEht8bIbw+5qW1N9LCAmGEDZfuca8jieOxGPz+TL0HRSGvquQY11H6xAYCZDVeIsZOw
         VsI2S3kgHyzdMvBwwZxLyX1sK0pAKt0Z0HJuUTN8C8tBIjw+FFA+1eaKdVNPcvCv6fDj
         YRrp4ZIRMo9Ph3kk/Linun7x5yLIyPbfaXXweY1/VbzJnKT7HpG/uxR5yJLyV3fFNSXv
         2IHhG1jJIpXBt0PTUdpIZWf+eU117GbmfCDPE0eBH1w8etcYuQiYRuGkmro3W0xsixge
         EDcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=gX5MXuN0yMPP5fZup2Supwzv/CRHAFoVR5x62kh5m90=;
        fh=p683QBxamviDzB94nJ6kCeOF2z7MGqi1iGct1AsZbNk=;
        b=dbP//i97DwVHRMg2zcIyUuzJSDfvYZz1ZOZnmQTCSe+Pojk7oc2uRykEO0c5oREfGn
         2va1TcX4YsVpMTt9imTnsAL2RCIAtOKykTFsnfxIlYZrawoYCE/zfoVC/d0cnXBKIair
         cp5vZu7yFbCyHVDxssiBJFnsj3YTJVjfJAlEbkhPQlA0yMW8qPDj88ztkNNzVPv+x3Q4
         Fpd7rtf9vQdFfcS5a4EiJvXU0XNa8QKBpkq3hISvUjd9b9PUDGvjPchbGijH7kFMvQUX
         5ZTeVtoAlXU4zOKPmYGjSq6LgPBrh6YCkSlSXNkgdTpFjNz3480zeymha8EDmRqYtRXX
         Npew==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787895858; x=1788500658; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gX5MXuN0yMPP5fZup2Supwzv/CRHAFoVR5x62kh5m90=;
        b=C8LUEYEXavabZaZMV4ib/ObbOSscPMnoAuX1KIhQkZ8XCYYOd4agm/Lwe5zETYiq0m
         qenCiGvwvh8YsVIn3a4doPFuueWIx/mCTj06Y2/4QjyRp8Luq9yxY878m1gE0lOt0dga
         aaleKHBCXf4NOd/b3deROYZMH5iGFKgWE02GaUQ53kvpUayM7X12/d6obCfoGONXBsgQ
         xOYonYHUMw+QGcPDeQj/ICus3E7G9zRJRnqIr30fTzwucXSd6YQWgl/QONzwPPqK46J1
         zqxtO/fGfHEU8sRO0ePKuD10thaTDBEus95dq1vAI3GNQgy19xf4mk1ArsHK20Y2CfA/
         ONPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787895858; x=1788500658;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gX5MXuN0yMPP5fZup2Supwzv/CRHAFoVR5x62kh5m90=;
        b=bGLCZL7AyPo/K3OCecVDPC7WaVgQ1gfGdNZTUP7vorzHTRVP6gzM5f25QcRkxyJYrr
         Vz0XhSV+RTkTZAI1SNzIYsfob2aJaAsU4Zh1yPBEB++mJR0+6TlXgBbFb/kdp+Hg0OhZ
         fU/JUk4GhAbigInOK/krOPnbZg83qeiJq+NkojL5H9qXpLbaMSMjJS7/u6IH4G0nhsuS
         KYFeMN629JN7X3dDeu7g7DFcJPsMhsLV4BYv0/mSkcL+1z7Ucc9V+qTjuPWv5mhn8GYJ
         WsRb62TEmIjbC0Dvbu2FfXT4AUbF/NiedvmYvp78NmaRhj4Q0SzIwlm8fFiGhDbtz/ph
         oYNg==
X-Forwarded-Encrypted: i=1; AHgh+RrPGSy8/5OpKhsPZpZ9jJFOoml9er/NydqBeeaB1j1BCF71GdXtGX6Bw+PZ3DEOrusw2qZZ1mNlrQ==@lists.linux.dev
X-Gm-Message-State: AFuF++kBP6uwMfDUp4JPOEZcMm50rA3/vRIYCTf4rqbvoYKF5VGuDtHw
	Xon836ZRF/5a7U23V4FLZyVKA9YEkc83jHBjV0opPQH8mZjFSG+4l6jPaEjs3rzEMuOteAEf08O
	4OsizZeXEFChGssNdPPR8OUvhWouIhP9OhDuoLIEY
X-Gm-Gg: AR+sD13zY6mmUslIaNXPBpi8jvn7/39XDderkR9139890YLhwFat4646HHNtT2SgG3a
	kJBvPt1VedXCpjChnkNu76IVj7Z6sTUvkxk+TgQdPkplVWdQ6i65ShUbXY7aT42ZFL2F8FbPbS9
	205n52+R8IQlNKJzS7K1FdxzJwaHM8hcPcQkArN1GI5X2o65MW/CftLk8ZJrkh+xW5Vjb9qLmda
	HdPYrJzLKEYf92wvwczsoBYH+wHnZxKzA0OW94HjvIBskDeZ2B8avKdmWYUDNS06y7V4RPJl7DM
	J9FDHYysm2P2rcCSbzxpSn9CmHzN++ie+2SeVaLr32fPhy5KW74my6b4/t1+GlELogs4ywYkP68
	//ZDITiXYf+wEe37hJTxJI1NBVvLIg5kTMwomlwKOmNQ=
X-Received: by 2002:a17:902:d2cc:b0:2d6:61a1:822 with SMTP id
 d9443c01a7336-2d74df04c7fmr75336995ad.10.1787895856999; Thu, 27 Aug 2026
 22:44:16 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 28 Aug 2026 05:44:16 +0000
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 28 Aug 2026 05:44:16 +0000
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Fri, 28 Aug 2026 05:44:16 +0000
X-Gm-Features: AcwNN1UfLFKvzsZ8yrGtx6F_RIY8tC-vXZ3mULzFo1lEYjjLnJ1dOGNaTOPlY9s
Message-ID: <CA+0ovCgD992wQBoKm8-dzMCMB8RTGcnOoX=Dv=3pg7s7q3rL2A@mail.gmail.com>
Subject: [BUG] KASAN: null-ptr-deref Read in dm_kcopyd_client_destroy
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: falemi@asu.edu, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/169-kasan-null-ptr-deref-read-in-dm-kcopyd-client-destroy/

  workqueue: Failed to create a rescuer kthread for wq "kcopyd": -EINTR
  BUG: KASAN: null-ptr-deref in dm_kcopyd_client_destroy+0x9e/0x480
drivers/md/dm-kcopyd.c:980
  Read of size 4 at addr 00000000000000a4 by task syz.2.409/14796
  Call Trace:
   dm_kcopyd_client_destroy+0x9e/0x480 drivers/md/dm-kcopyd.c:980
   __destroy+0x172/0x2f0 drivers/md/dm-cache-target.c:1969
   cache_create drivers/md/dm-cache-target.c:2600 [inline]
   cache_ctr+0x1614/0x2af0 drivers/md/dm-cache-target.c:2645
   dm_table_add_target+0x5c9/0xce0 drivers/md/dm-table.c:749
   populate_table drivers/md/dm-ioctl.c:1509 [inline]
   table_load+0x2f9/0x810 drivers/md/dm-ioctl.c:1551
   ctl_ioctl drivers/md/dm-ioctl.c:2115 [inline]

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
