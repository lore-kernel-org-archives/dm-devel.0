Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146D61DDC2E
	for <dm-devel@lists.linux.dev>; Mon, 24 Mar 2025 20:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742849714; cv=none; b=jqpKNH+3qxMvp5f5LwbjAE1RGLLczO0eXs3Hu0gwV8QGHihl2knLwxSUzsZPz0NY03/mzfNrJAsjD6i9jd/jZBQ1L0pN9MhHMk0fmHWgQWl/AvnCgtWPE+sYR3/aDKM4e735RFXWRxiJdozLDod6sI7I8cmNkxcBf6QC06ULSvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742849714; c=relaxed/simple;
	bh=yhp5wey9D9ssgFhnWejDApNw/0ZOJs/FX62Vc64FAZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=K263WrBO1K9oBPgrcsuX4JNOUpjEguKhbT+BiQYjj/YjSn1BtMj9xylEULK7zaGSVI6mTbIiHqpP/njTBFDCiZ04eW5rhJ2CIN0tlg3ksQjHF95rO14fDIsqs1TwvtLOUTTXRZFJQ7m8FRr8JFAET/Mdd6YX+cvf+v3/afhbod4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d3buNwv0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d3buNwv0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742849711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+2s1ob/HaadwOleN3VeDR5uRO646PSsklYzTKVad+s4=;
	b=d3buNwv0ov0MN1AiziBcg3atGPEKWTJmNzzRfHha0w2sAwPfQMHTQoycA0mAXv1lg8YzL0
	ONIkXnk6sqKGtewVsq9vVvZl8LxzB3wRWBBuIpCOcp5s+d+fJxigf7aJNGSLv4717etBXz
	+EqBi7c68omNHZukvVNJ7IatjQEPhDo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-dItXnZVgPPeGSK3ggtjHzA-1; Mon,
 24 Mar 2025 16:55:08 -0400
X-MC-Unique: dItXnZVgPPeGSK3ggtjHzA-1
X-Mimecast-MFC-AGG-ID: dItXnZVgPPeGSK3ggtjHzA_1742849707
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 843AA196D2FA;
	Mon, 24 Mar 2025 20:55:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C7271801750;
	Mon, 24 Mar 2025 20:55:07 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 52OKt5CJ2523505
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 24 Mar 2025 16:55:05 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 52OKt4r72523504;
	Mon, 24 Mar 2025 16:55:04 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 0/3] fix issue of multipathd not tracking device
Date: Mon, 24 Mar 2025 16:55:01 -0400
Message-ID: <20250324205504.2523493-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MdLywmQr5XK0ixndN6D3VG_IHU0Cg5tMU4LO86OI4rE_1742849707
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

I ran into an issue where multipathd wasn't tracking a multipath
device that was created by the multipath command. It turns out that if
multipathd fully initialized a path device, and that device later
goes offline and then a multipath device that could use that path is
created by multipath, multipathd will attempt to reload the device
to use the offline path, which will fail. This will cause it to not
track the multipath device at all.

The first patch fixes this. The second patch allows mutipathd to track
these offline paths that should belong to a device, and add them to
device once they come back online. The third patch is just a cleanup.

Benjamin Marzinski (3):
  multipathd: monitor new multipath dev even if we can't update it
  multipathd: re-add paths skipped because they were offline
  multipathd: don't update paths in INIT_MISSING_UDEV

 libmultipath/print.c       |  1 +
 libmultipath/structs.h     |  5 ++++
 libmultipath/structs_vec.c |  5 ++++
 multipathd/main.c          | 59 ++++++++++++++++++++++++++++++++++++--
 4 files changed, 67 insertions(+), 3 deletions(-)

-- 
2.48.1

