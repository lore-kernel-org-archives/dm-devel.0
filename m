Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924786CDAF
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 01:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730425995; cv=none; b=CN/x+NEnIHISsu301s3hXCXpEcsBYPGRLULrw7FSR5HH75XYWll6RkbTOU7TOJJI1Ar1BX786QnT2rof+8LqdMzGyIaOOJhmbWITpqELouUCfI7/N4PaKXEq9XNv0SH23fPg5yhkqqmRzEhISvkrj+KF1nApQ5Htf/zMNwyKIe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730425995; c=relaxed/simple;
	bh=U6iD8BqayoD7dkewbVzDzXBvnGw3AsYJHnkMtW2EnmA=;
	h=MIME-Version:Subject:From:To:Message-ID:Date:Content-Type; b=Vv04+vPGlOcc7Cv8w6Cosv4n9cFAc7RMEyya3IdeyAlUa7nFiGLYEEWGgJHDtsRhf7x0NDQ8YPh2UU/JwXzwRMv3hRdej1cEAPNMlBcVlMet0vh7Emmw8ygSaGeDabat2kUk4aLlsIHs/Ih9kb7RS8pZ2u1ffTB3U8gSUzK7bME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYal+xFI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYal+xFI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730425987;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id;
	bh=iViixA0rFUvM0VzeVqbcM65kjhRta2oIAgw1BcM/15M=;
	b=NYal+xFIJhMFARHLcM3UDKCmOUOcHb4wPCWkBZvYVa1LupqfuOmuivVvvjsJ4231CNCR1D
	zvkxXLmt1ld6cBIvtggnrSu1w9hRu90Nc3NpYiQnPdkNpk2+L4+/tHFVJ8O4rI0acGuu24
	+qOTWjSJWaotXCqtJJY5J5CRds5iphQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-azmbHzlhPni7cTD_6A94OA-1; Thu,
 31 Oct 2024 21:53:05 -0400
X-MC-Unique: azmbHzlhPni7cTD_6A94OA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08F15195609D
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 01:53:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E750319560A2
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 01:53:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 77F3C1946586
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 01:53:04 +0000 (UTC)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: dm-devel@redhat.com mailing list reminder
From: dm-devel-bounces@redhat.com
To: dm-devel@lists.linux.dev
X-No-Archive: yes
Message-ID: <mailman.0.1730425982.36668.dm-devel@redhat.com>
Date: Fri, 01 Nov 2024 01:53:02 +0000
Precedence: bulk
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.30
X-List-Administrivia: yes
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

You, or someone posing as you, has requested a password reminder for
your membership on the mailing list dm-devel@redhat.com.  You will
need this password in order to change your membership options (e.g. do
you want regular delivery or digest delivery), and having this
password makes it easier for you to unsubscribe from the mailing list.

You are subscribed with the address: dm-devel@lists.linux.dev

Your dm-devel password is:
YSprWmp4NF<soyj<=PP4Nh=>PC!MyePcoS?zSou*aTaCv5r+oFg!

To make changes to your membership options, log in and visit your
options web page:

    https://listman.redhat.com/mailman/options/dm-devel/dm-devel%40lists.linux.dev


You can also make such changes via email by sending a message to:

    dm-devel-request@redhat.com

with the text "help" in the subject or body.  The automatic reply will
contain more detailed instructions.

Questions or comments?  Please send them to the dm-devel mailing list
administrator at dm-devel-owner@redhat.com.

