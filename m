Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6E1189BB6
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 11:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723117992; cv=none; b=LqzL8b2g1ISEiqwwQDNUlUXk1MKO9BUP5VDiiewXq5a8fIiQDnCRbgdpiR4drfICaNir8sSo+5wdcVh1dS6AlHNuuUb44wMjYIRTYIi8xjNPV1k3GWrIpHXTmh8I1RJNv21ZWvmNCPq3UyLivVeWDas6iObt7PKwdjVh91FDC1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723117992; c=relaxed/simple;
	bh=BdG3wCIknrKu95G5lSY6jXof1KmgIM43VhOUS3EXjXo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dI/PaklGTwEVWoMO0XMacerEysDTTmRqgzV/16t5MTKHivQb1H3Sdnv3Mo9geTY0JVRHqml7iU70ONsF0OXRM6meK2UGmFdpNnIsdiGudybLK1Yc9aoQN2J8RtPCpvW272+HNBtFfTflCwhXZ00NUGjKl02QZEnzipS1k9AgFZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W2LP9lBu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2LP9lBu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723117989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nhICHQhvH9mxC4p/asewU1gNr7NRYgV/lVF2C9TrU3I=;
	b=W2LP9lBuHoJNE8T8rrx47j4jeUcDXkter0F4QJy85CRGRLZMo0nph/ulxODerdCVmBP7zC
	x+CMhizS54uGpKHMbxTiTLJZNIe8beOFu7tlTMU5GyWi+dNBC6pJV3QgHfQLIkhHAXg8Ai
	OqWh4XHoEWFqHXDpGBQFLc/2i4M8B14=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-NNcZdIBYPHGUqCFKetb3aA-1; Thu,
 08 Aug 2024 07:53:07 -0400
X-MC-Unique: NNcZdIBYPHGUqCFKetb3aA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEDDD1897FC4
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 11:51:11 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.113])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C3181196BBDC;
	Thu,  8 Aug 2024 11:50:49 +0000 (UTC)
From: heinzm@redhat.com
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	teigland@redhat.com
Subject: [PATCH] dm delay: enhance kernel documentation
Date: Thu,  8 Aug 2024 13:50:36 +0200
Message-ID: <bafcd17226a993785c916cfa9ee30c8d432dc3c9.1723117545.git.heinzm@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 .../admin-guide/device-mapper/delay.rst       | 45 ++++++++++++++-----
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/delay.rst b/Documentation/admin-guide/device-mapper/delay.rst
index 917ba8c33359..53d79294e62a 100644
--- a/Documentation/admin-guide/device-mapper/delay.rst
+++ b/Documentation/admin-guide/device-mapper/delay.rst
@@ -3,29 +3,52 @@ dm-delay
 ========
 
 Device-Mapper's "delay" target delays reads and/or writes
-and maps them to different devices.
+and/or flushs and optionally maps them to different devices.
 
-Parameters::
+Arguments::
 
     <device> <offset> <delay> [<write_device> <write_offset> <write_delay>
 			       [<flush_device> <flush_offset> <flush_delay>]]
 
-With separate write parameters, the first set is only used for reads.
+Table line has to either have 3, 6 or 9 arguments:
+
+3: apply offset and delay to read, write and flush operations on device
+
+6: apply offset and delay to device, also apply write_offset and write_delay
+   to write and flush operations on optionally different write_device with
+   optionally different sector offset
+
+9: same as 6 arguments plus define flush_offset and flush_delay explicitely
+   on/with optionally different flush_device/flush_offset.
+
 Offsets are specified in sectors.
+
 Delays are specified in milliseconds.
 
+
 Example scripts
 ===============
 
 ::
-
-	#!/bin/sh
-	# Create device delaying rw operation for 500ms
-	echo "0 `blockdev --getsz $1` delay $1 0 500" | dmsetup create delayed
+        #!/bin/sh
+        #
+	# Create mapped device named "delayed" delaying read, write and flush operations for 500ms.
+        #
+	dmsetup create delayed --table  "0 `blockdev --getsz $1` delay $1 0 500"
 
 ::
+        #!/bin/sh
+        #
+	# Create mapped device delaying write and flush operations for 400ms and
+	# splitting reads to device $1 but writes and flushs to different device $2
+        # to different offsets of 2048 and 4096 sectors respectively.
+        #
+	dmsetup create delayed --table "0 `blockdev --getsz $1` delay $1 2048 0 $2 4096 400"
 
-	#!/bin/sh
-	# Create device delaying only write operation for 500ms and
-	# splitting reads and writes to different devices $1 $2
-	echo "0 `blockdev --getsz $1` delay $1 0 0 $2 0 500" | dmsetup create delayed
+::
+        #!/bin/sh
+        #
+        # Create mapped device delaying reads for 50ms, writes for 100ms and flushs for 333ms
+        # onto the same backing device at offset 0 sectors.
+        #
+        dmsetup create delayed --table "0 `blockdev --getsz $1` delay $1 0 50 $2 0 100 $1 0 333"
-- 
2.45.2

