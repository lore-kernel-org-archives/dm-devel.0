Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794439997;
	b=262py4sw0QhSjEXsUN2PFyD0V6BS2UtKv17UhiKxglP76S1BaQOLP3MaUMJoAGmjr1b2
	 +eRdJtXXVBkXWH5AAwq5e+E5aUJcTEf+8KpNF1VwfoNujwqUvScDlWvusi9bo1kDoSwZx
	 JIYIuqp+lqj0TjNZomxpM/B/nWTPWEnmTh9HKHOtSsYtsGJ8DmCUAFOKxApjdQBnxnpkB
	 D3CWsbvOmUgZ9xbnSk9Un4n27s1+M2bfs2z/jlPMEG7OuWmejE2pfv9MeZIFmgGiiFSpC
	 LrCKAWyU6BAnKFfDmk8qi3rglelzx9DvwN6jcwYD9oZyXMx1bUIxQg09c2LpVtWF/kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794439997;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:
	 Content-Type:Content-ID;
	bh=wFa+6PYdEnwYcfWZqs2W0fqSZLArJ7HSAU8oXuewFKU=;
	b=zcHlMPgaOz2SrQHe91Zvnx2XuPN9GK+uvuLWHolsZmdTY08T6kPnFkGfIJYYEVdH/IR0
	 zVhxHSL96DtJkqcRsVfDdpwHUP2osup0yb6AYBRqPGTEth2BqAThOcVKlefcJnccTZLhd
	 z5oWEiIPo8pC0RzXAabYC40P0gvY/dYdCs+FjD0biz7hNJ88W8DELZe19Sg3s+/5IrxsR
	 OZS19lCR9HzH5T+yYj2o2pWxkI+M1+9x8wAEVMFHZqy+CGw+6Vv0fbjFycEDLzqXfz3+n
	 FBimRy0h8yNEQuNCsIXJutCilRxyaf41PQ/TfiaOV6TTLLw4UBGG4a7Avm20D39m3HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IyoptMf1;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC61606A31C
	for <dm-devel@lists.linux.dev>; Wed, 11 Nov 2026 23:33:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8DC61606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IyoptMf1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794439995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wFa+6PYdEnwYcfWZqs2W0fqSZLArJ7HSAU8oXuewFKU=;
	b=IyoptMf1usAimejNXoqxo+gneTch34j2E6oDwlDyLPQFKS9dwyhMpQpzXQUs/lIL06G05X
	035n4Xt+UOybpDAWzvPF2lGCcUAZdzhZVd8lRxizPEORzp3xJZvDQNEMKDG51/dCTbZhvf
	Dh1v5jGjDte9+SsjsC5Zlb1o0NSqVEQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-163-rFsKf73-NJKeDJqNoD_qpQ-1; Wed,
 11 Nov 2026 18:33:12 -0500
X-MC-Unique: rFsKf73-NJKeDJqNoD_qpQ-1
X-Mimecast-MFC-AGG-ID: rFsKf73-NJKeDJqNoD_qpQ_1794439990
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4263D1955F1E;
	Wed, 11 Nov 2026 23:33:10 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E848930000E8;
	Wed, 11 Nov 2026 23:33:06 +0000 (UTC)
Date: Thu, 12 Nov 2026 00:33:04 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: =?GB2312?Q?=D6=DC=CE=B0=BD=AD_=28Weijiang_Zhou=29?= <weijiang.zhou@unisoc.com>
cc: "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Sami Tolvanen <samitolvanen@google.com>, 
    =?GB2312?Q?=BD=F0=BA=EC=D3=EE_=28Hongyu_Jin=29?= <hongyu.jin@unisoc.com>, 
    =?GB2312?Q?=CE=E2=CF=E9=C2=BB_=28Xianglu_Wu=29?= <Xianglu.Wu@unisoc.com>, 
    =?GB2312?Q?=CE=E2=D6=DC=BE=B5_=28Justin_Wu=29?= <Justin.Wu@unisoc.com>, 
    "dhavale@google.com" <dhavale@google.com>, 
    "ebiggers@google.com" <ebiggers@google.com>
Subject: Re: [RFC PATCH 1/2] dm-verity: don't decode FEC into a dm_bufio page
 that is already in the cache
In-Reply-To: <179436615557.34024.8414792860115638345@unisoc.com>
Message-ID: <c610cc13-cffb-45eb-6750-40a814d60efd@redhat.com>
References: <8048c93b8cf24d83aa6aa536c2518201@zeshmbx08.spreadtrum.com> <27b2dc50d3bb497ea3f3f84e7e4b271c@zeshmbx08.spreadtrum.com> <5188c1e8-c08a-2a56-7e4c-1d84aba4df35@redhat.com> <179436615557.34024.8414792860115638345@unisoc.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B_h66KzwGPn1VwJ7L2rFNF0XzeNfnmEXdpUbi8bMc6c_1794439990
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463801984-1877310339-1794439735=:1158755"
Content-ID: <ba80d8e5-3d6c-4dbf-2f31-1c6c0b5541c4@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463801984-1877310339-1794439735=:1158755
Content-Type: text/plain; CHARSET=GB2312
Content-Transfer-Encoding: 8BIT
Content-ID: <9665e929-c813-fb35-96a2-4fe7265388e1@redhat.com>

Hi


On Wed, 11 Nov 2026, 周伟江 (Weijiang Zhou) wrote:

> Hi Mikulas,
> 
> thank you for the careful review, and for pointing straight at what
> needs to be fixed.  We agree with you: the 1/2 sent earlier only hides
> the symptom, please ignore it.
> 
> To make sure we read the defect the same way: in fec_read_bufs() a block
> whose read fails is recorded as an erasure outright; a block that reads
> back fine and lives on the data device is judged by fec_is_erasure(),
> which compares it against the digest verity_hash_for_block() produced
> for it.  Getting that digest can walk the hash tree and read, level by
> level, the hash block covering that data block.  When the block being
> recovered is itself a metadata block, a data block of the same codeword
> can have its hash path run through it - at level 0 one of the data
> blocks it covers, above level 0 one of the hash blocks below it.  So
> the walk asks for exactly the block we are rebuilding: the one
> dm_bufio_new() put in the cache holding allocator leftovers, with no
> read ever issued for it.  The digest cannot match, recursion into FEC
> is blocked by fio->level, and the walk ends in verity_handle_err() -
> the "metadata block N is corrupted" from our devices, which under
> restart_on_corruption means a reboot on a single transient read error.
> This is only reachable on the second try, the one that asks for
> erasures: the first try recovers the block without searching for them.
> 
> Rather than defending a patch of our own, what we would really
> appreciate is your help with the complete fix.  This is a path where a

I think that the correct fix would be to ensure that the erasure blocks 
for a given tree level are stored at the same level as the blocks that 
they protect. Then, you will never hit the situation where the correction 
recurses into the same block that it attempts to correct. You would need 
to modify the veritysetup tool for that and maybe it would also need to 
introduce a new on-disk format.

The forward error correction was written by Sami Tolvanen, so maybe he can 
help with that.

Mikulas

> partial change worries us: the erasure search, the recursion guard in
> verity_fec_decode() and the hash_verified state are all involved, and
> from the outside we cannot judge which of them a correct fix has to
> touch.  Our concern is that we close the case we can see and open
> another risk somewhere we cannot.
> 
> Would you describe the fix you would consider correct - where the
> change belongs, and what else it has to cover?  We will implement it
> exactly as you specify, verify it on the configuration that reproduces
> the problem, and send it to you for review before it goes any further.
> 
> Thanks again for your time,
> Weijiang
> ________________________________
>  This email (including its attachments) is intended only for the person or entity to which it is addressed and may contain information that is privileged, confidential or otherwise protected from disclosure. Unauthorized use, dissemination, distribution or copying of this email or the information herein or taking any action in reliance on the contents of this email or the information herein, by anyone other than the intended recipient, or an employee or agent responsible for delivering the message to the intended recipient, is strictly prohibited. If you are not the intended recipient, please do not read, copy, use or disclose any part of this e-mail to others. Please notify the sender immediately and permanently delete this e-mail and any attachments if you received it in error. Internet communications cannot be guaranteed to be timely, secure, error-free or virus-free. The sender does not accept liability for any errors or omissions.
> 本邮件及其附件具有保密性质，受法律保护不得泄露，仅发送给本邮件所指特定收件人。严禁非经授权使用、宣传、发布或复制本邮件或其内容。若非该特定收件人，请勿阅读、复制、 使用或披露本邮件的任何内容。若误收本邮件，请从系统中永久性删除本邮件及所有附件，并以回复邮件的方式即刻告知发件人。无法保证互联网通信及时、安全、无误或防毒。发件人对任何错漏均不承担责任。
> 

---1463801984-1877310339-1794439735=:1158755--

