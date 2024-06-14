Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDF77E76D
	for <dm-devel@lists.linux.dev>; Fri, 14 Jun 2024 18:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718389460; cv=none; b=i6ciUcH+3lNcQ1LEdTttkNhqNEo2TFSEvkQsDbavpa5k1nVBPqeUnxOutzyuXIAy/16wBqz3Kj+PNT0rq8BTRS1izZhG6cuz2xbuYiVDY4SKlUqNMZKVX6GbULRjABcjLIKJpxd6RuIEMhJ2LGwY2S2rSP548eJal6igZsyEBS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718389460; c=relaxed/simple;
	bh=o/6dxj20a4HAWtLo3dXK6pyBK76EEyYUAvWUC4siEVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=B6GTDYEmCRj5lQcBwZh9zH4Cp7ItGrQ0+z8rWxK8nSQRrB0PtLwPkhMbbZZHiH1Lvact9Sc5offbpeL8L6fkUBiEaMpUrZaPU3E6tLxf35CAAYxyA5BowvbTm9ThHfpdtf6JHB3vC9nQdqKTfuZWjA3mFNxydidbxA6bWefMudI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eXZ1VOLX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXZ1VOLX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718389457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SNZZiXRN9kBlhlwmKUkWOszxKyjTXRwd2aqfblwXd8E=;
	b=eXZ1VOLXH2j2ASGWBab5hnEKzFJ+1xwBeCYGJb2pW8Ysb6ZK716UAIo1CSzuaWcs/nELs2
	UaKdXg+YIlNOli57o5UJcaBQ2A9CdOvhro8zQGK91ZLxnLo5Q39VVm0b40wPZIutT0gy5b
	bVDOtTYfIJwlkPSnqS/PrMLlxVfeV5Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-631-2XeNX3eYMYuNL6yUj5bCbA-1; Fri,
 14 Jun 2024 14:24:15 -0400
X-MC-Unique: 2XeNX3eYMYuNL6yUj5bCbA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB033195608F;
	Fri, 14 Jun 2024 18:24:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DD591956087;
	Fri, 14 Jun 2024 18:24:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45EIOCn7952178
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 14 Jun 2024 14:24:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45EIOCdR952177;
	Fri, 14 Jun 2024 14:24:12 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 0/3] dm_io cleanup
Date: Fri, 14 Jun 2024 14:24:09 -0400
Message-ID: <20240614182412.952166-1-bmarzins@redhat.com>
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

This is a small patchset to remove some code duplication and clean up
some minor issues in dm_io.

Benjamin Marzinski (3):
  dm io: bump num_bvecs to handle offset memory.
  dm io: don't call the async_io notify.fn on invalid num_regions
  dm io: remove code duplication between sync_io and aysnc_io

 drivers/md/dm-io.c | 84 ++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 52 deletions(-)

-- 
2.45.0

