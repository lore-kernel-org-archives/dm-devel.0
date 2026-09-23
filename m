Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53EC41D21F
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790164813; cv=none; b=K1gy6iBOkiSw/+DPuwgjZl5R3DMUzj/RHNAj0aqJVze0HH9qcEWK3CMWZXknC6hUVchlv4vcAFKyQ6JMa+6N2/tsFQrMtcOFPEMt2LaJDr8RmE8m8yqa7gdEa7W7LPjJEjKMQ/hO0lk6AKrYkzpSAuElg5DcGKgDbwixIRPjQ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790164813; c=relaxed/simple;
	bh=1GBcvPzoXm1aMRVXIWh6oM8rHvYTbYsvbTkjmOlRDw8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=L9R2RLpvZcrXIobfW7z1UzGZe624bqIHXgylc4Kskdhnl4cCi8+tLqaJBkleqkP3NtMjgKNSUYSGpUffamXm+AvH540KSZCWRarO/jXek46Rv+EoHEKgrmzX8Zz3KrRthidIxeEuwN6jjncbTNfOp0KZRXO+bfP9zyHFfzl7xWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jG8wSlua; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jG8wSlua"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790164805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wAYZvqG64NWM3pm4lFT7ceYVzZbOVDSNdNkZDkRdins=;
	b=jG8wSluaskioZrF9fn5wNgoXv2lztHdbk2VFxXM7tXg1Z7F1URcJehsGyU/uXHpBmG069m
	QJyslsDRhCdi8uH3nsscvMfjesGjKcDsCotq51xtBV19pPVcVLgZpRTVksduRiwe7FmlgJ
	7I6NOmEedT2MwAVEXVfVYTX7+CYFlnc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-PmcdeM7kNyyeLh-oSWAHvQ-1; Wed,
 23 Sep 2026 08:00:02 -0400
X-MC-Unique: PmcdeM7kNyyeLh-oSWAHvQ-1
X-Mimecast-MFC-AGG-ID: PmcdeM7kNyyeLh-oSWAHvQ_1790164800
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFFE018413A0;
	Wed, 23 Sep 2026 11:59:59 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 299BE180057E;
	Wed, 23 Sep 2026 11:59:54 +0000 (UTC)
Date: Wed, 23 Sep 2026 13:59:52 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Itai Handler <itai.handler@gmail.com>
cc: Eric Biggers <ebiggers@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
    Shuah Khan <skhan@linuxfoundation.org>, 
    Randy Dunlap <rdunlap@infradead.org>, dm-devel@lists.linux.dev, 
    linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to
 PAGE_SIZE
In-Reply-To: <20260923113903.901245-1-itai.handler@gmail.com>
Message-ID: <947ecfba-353b-753e-53d1-30d894822401@redhat.com>
References: <20260922120330.127262-1-itai.handler@gmail.com> <20260922213457.GA3536981@google.com> <CAFpOueSjekxhjEosQGiZ9BiDh5tFOqBPX5w_2PVsrcN6pO+dHw@mail.gmail.com> <9a6c20da-4da9-4a8d-a6d4-f18900228bf6@redhat.com>
 <20260923113903.901245-1-itai.handler@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: oAqglCFpF1LGpIx-NdpcgMiluUHaFjx5uQ-sue8ZXTU_1790164800
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Wed, 23 Sep 2026, Itai Handler wrote:

> A torn sector is possible today
> -------------------------------
> 
> Consumer NVMe are generally shipped with 512-byte logical blocks and
> stay that way in use. Installing Linux does not change it: partitioning
> and mkfs work inside the logical blocks the drive already exposes.
> Changing the block size is a separate low-level operation - nvme format
> with a different LBA format - which is destructive, which no installer
> performs, and which a drive may not offer at all.
> 
> The machine I am writing from is one: a Samsung PM981a carrying a
> complete Ubuntu install - GPT, EFI partition, /boot, and the rest of the
> drive as LUKS over dm-crypt with LVM and ext4 on top - and it still
> reports logical_block_size = physical_block_size = 512, with no
> atomic_write_* attributes at all. The dm-crypt device on it reports a
> 512-byte logical block too.

I did some benchmarking some times ago - and all the SSDs that I tested 
had worse IOPS for sub-4k writes than for 4k-aligned writes. This means 
that the SSDs have 4k sectors internally and do read-modify-write cycle 
for sub-4k writes.

The SATA standard doesn't specify well what 'physical block size' should 
mean on SSD - the result is that some SATA SSDs report physical block size 
512 and some 4k.

The SSDs have remapping table that maps logical blocks to locations in the 
flash chips - and RAM is expensive, so I doubt that any SSD vendor would 
put 8 times more RAM on the SSD in order to map 512-byte sectors 
individually.

Mikulas

