Received: from csmtpq1-prd-nl1-vfz.edge.unified.services (csmtpq1-prd-nl1-vfz.edge.unified.services [84.116.50.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A105194AD6
	for <dm-devel@lists.linux.dev>; Sun, 20 Oct 2024 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.116.50.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729449720; cv=none; b=V5PGL+9/czTsa4RBE/cQSHChrvivdZ/hXjM4q3B/3EVcTtJKBwtA4SjGcOwELodCGC85TeWaoV2Dlj1/eH6/GUGJ4xEGvTDH805C6XKC7MvW0PFKQif8SZzsY6FSYuVGzPSJj6CB1+1KCjH56cVBjwUmkmP4pNHBBE/TK3/sz30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729449720; c=relaxed/simple;
	bh=gU0+2yl9R1QWLglpAXKIkgM2EHcBvaGbIMs7bPrBHoY=;
	h=MIME-Version:Date:From:To:Subject:Message-ID:Content-Type; b=Tj/gH6lrP8XTuKTg9s8bBemmDird/dMwcqiQq+imBP0xebF+rm0fBW4ba1tyo41JGS0fDiSBSE84UkWxDAhQIcpZpwGIN9b1sbAdUj1RmLvmQS0DT1mpXbbxjLnyZAt1G/k6qhy2t796bJbD99kxUpIQxj+T2Eb8ZKMrrWPbTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org; spf=pass smtp.mailfrom=kngnt.org; dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b=lio0latJ; arc=none smtp.client-ip=84.116.50.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kngnt.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kngnt.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kngnt.org header.i=@kngnt.org header.b="lio0latJ"
Received: from csmtp4-prd-nl1-vfz.nl1.unified.services ([100.107.80.18] helo=csmtp4-prd-nl1-vfz.edge.unified.services)
	by csmtpq1-prd-nl1-vfz.edge.unified.services with esmtp (Exim 4.93)
	(envelope-from <felix@kngnt.org>)
	id 1t2asD-001paI-DT
	for dm-devel@lists.linux.dev; Sun, 20 Oct 2024 20:41:53 +0200
Received: from mail.kngnt.org ([80.115.15.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 256/256 bits)
	(Client did not present a certificate)
	by csmtp4-prd-nl1-vfz.edge.unified.services with ESMTPSA
	id 2asDtSgjP0OfN2asDtr61R; Sun, 20 Oct 2024 20:41:53 +0200
X-Env-Mailfrom: felix@kngnt.org
X-Env-Rcptto: dm-devel@lists.linux.dev
X-SourceIP: 80.115.15.152
X-CNFS-Analysis: v=2.4 cv=B77r0/tM c=1 sm=1 tr=0 ts=67154ef1 cx=a_exe
 a=YXwiZ4wAml67grcSS0vdmg==:117 a=YXwiZ4wAml67grcSS0vdmg==:17
 a=kj9zAlcOel0A:10 a=N9ji3t4waF4A:10 a=k30jgONyZyEWS3cA8usA:9 a=CjuIK1q_8ugA:10
X-Authenticated-Sender: f.rubiodalmau@ziggo.nl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kngnt.org; s=mail;
	t=1729449712;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lGAl4Fq28qYinNzjAcApTgGP5h7cZh3XV87hJ5ofJP4=;
	b=lio0latJWmnLG49zSDj7Gj9ghg5qjOgU20D3gKFpyU0sHzsH1Jo7SNJ5TyB/dNoBoiOTHR
	TppIqNh0QauN1f2f3b1P+2qKuVgtFO4bbWsQQQyqWYJlBVxeO2ygoOcicCxd+y73K3fwct
	KquoDMpArUeLXfmcmWUiiZnX14yCXERq29N9sfjKILPsfaAzMFem3i6tQLUyjMKmJbvzau
	wi9LoU4ZqM/h9z9Fz4CovKaVOcBcRPZcCq+bz2b/TiNOG7uD1JltZ25VL0880w3Iyekwh1
	kmaV3qbVV57D0bgLi8xvxKhnDQi2R5MjqzrKa88Xjh11IHuwD0R+UcDZhgfF4A==
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sun, 20 Oct 2024 20:41:52 +0200
From: Felix Rubio <felix@kngnt.org>
To: dm-devel@lists.linux.dev
Subject: help understanding/fixing low performance of encryption in my machine
Message-ID: <8a9d8d1155887ddee7ac911b83e8b204@kngnt.org>
X-Sender: felix@kngnt.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfAL9O22qtgp8pgNENWmpp51AqElp7ugzA4eCkhIuVnsJugxVECdKyVhOaxQ5jWBdZqV7GE34JKrkbcY9/LPFHX/Rhk5v9/kCRXAwi6uXgd067+yiiLVL
 svj2Ao4euANWM0owqylEcXwrMRO6Cw2OJiw+4V9VIVuoUGOKhZ9gF11ZU92grgHLh4+Wqg3Zk9kMNg==

Good morning,

After creating a detached header by running

     cryptsetup luksFormat /dev/ram0 --cipher aes-xts-plain64 --key-size 
512 --batch-mode --key-file - --header crypthdr.img

I open the LUKS device by running

     cryptsetup luksOpen /dev/ram0 encrypted-ram0 --key-file - --header 
crypthdr.img

now, if I execute two tests to measure the direct access to memory, and 
the encryption:

     fio --filename=/dev/ram0 --readwrite=readwrite --bs=4k --direct=1 
--size 1Gb --name=plain

reports 1.4 GB/s for read and write

     fio --filename=/dev/mapper/encrypted-ram0 --readwrite=readwrite 
--bs=4k --direct=1 --size 1Gb --name=crypt

reports 236 MB/s fore read and write

I have read that prior to kernel 5.x there was a performance issue, but 
that was addressed and I am on kernel 6.11.4.
In case it matters, I am booting from a UKI that I build myself for 
which I do not explicitly include the module aesni_intel. However, I see 
this module loaded now (although I am running on a Ryzen 7 6900H: That 
is weird I guess?).

Might you have any advice on how to improve the performance of 
encryption/decryption? As I am using FDE, a 7x drop in performance in 
seriously impacting me.

Thank you!
-- 
Felix
