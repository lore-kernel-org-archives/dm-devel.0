Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB34C385D9D
	for <dm-devel@lists.linux.dev>; Wed, 12 Aug 2026 16:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786552114; cv=none; b=jp8hfBzUDenCAUv4KuvPK+K0CPs4yfdla+Mf2h4VmemUzwEviQlByv5sa9CqKP/Qjig+IahC9nfnXxounCzvbuaJT1qyGubwIem0h4/GMi521mQvnEoGtA2Vn43BL+VJxwpNCtOd9O4pC3yuCONEiRm+5qbiwzp5EbNXoeBbdvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786552114; c=relaxed/simple;
	bh=IRKaYTME0NAFSEA6vxtAJnfjN59D0SaMzD9J+hca/RA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ossF9SXPl5B6C1QmIMAHX+vgSt9OiB+OWxjnxjDvASMtXQxmgCKneNF+622Az6AX+XQRAL+e37uJQpOlN9Osa8mrRievDVKlCAE1KUTKG9aUTJzYGXJWo6fZ8f8mPuU1tQpQKDAh6O3yBhL1m5LqWgjash2GpUaF5Y/c7+8A0H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VJKbD0t0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VJKbD0t0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786552111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEDAKd74YzBC5PRmR4ZCJYiwpSlOgan4l52JFv3YMMU=;
	b=VJKbD0t0NnWi+Tji8YYnqzmFbu9pBkn2ywZRa2Zx04Gpej0+TLUxFLpS542Ubpx0ehU+V0
	3gArbLQobxVOt/OwpLfW3XjtN2XCVswd9W4jADuniCg5lWWqYP9IOrcrdhL58AV6pOh7xK
	mrUbtHZ4+2ogRRykboPKC2i0l5f0XEs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-IYB6cBC2OQ-i28s3JuTSpw-1; Wed,
 12 Aug 2026 12:28:30 -0400
X-MC-Unique: IYB6cBC2OQ-i28s3JuTSpw-1
X-Mimecast-MFC-AGG-ID: IYB6cBC2OQ-i28s3JuTSpw_1786552109
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6ADD3195608A;
	Wed, 12 Aug 2026 16:28:29 +0000 (UTC)
Received: from fweimer-oldenburg.csb.redhat.com (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3EEF422;
	Wed, 12 Aug 2026 16:28:26 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Cristian Rodriguez <yo@cristianrodriguez.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>,  libc-alpha@sourceware.org,
  Zdenek Kabelac <zkabelac@redhat.com>,  Ondrej Kozina
 <okozina@redhat.com>,  Milan Broz <gmazyland@gmail.com>,
  dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
In-Reply-To: <CAPBLoAdgefcQ=otsy4GMsCCAgzY=7E1bDBtZsKMFy+Af0nPVfQ@mail.gmail.com>
	(Cristian Rodriguez's message of "Wed, 12 Aug 2026 10:04:02 -0400")
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
	<CAPBLoAdgefcQ=otsy4GMsCCAgzY=7E1bDBtZsKMFy+Af0nPVfQ@mail.gmail.com>
Date: Wed, 12 Aug 2026 18:28:24 +0200
Message-ID: <lhupkznjobb.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yA_Y73aPo8vwF5neFFiNY87f9Krlm--tRMQ0uxW3p3Y_1786552109
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

* Cristian Rodriguez:

> c
>
> On Fri, Apr 19, 2024 at 10:08=E2=80=AFAM Mikulas Patocka <mpatocka@redhat=
.com> wrote:
>>
>> Hi
>>
>> As a part of LVM2, we are developing the libdevmapper library. The libra=
ry
>> may be used to load cryptographic keys to the kernel, so it avoids leaki=
ng
>> the data to kernel memory and to the swap partition.
>>
>> After the use of cryptographic data, the libdevmapper library clears the=
m
>> with memset and frees them afterwards. It executes __asm__ volatile("" :=
::
>> "memory") to thwart some compiler optimization regarding writing to
>> to-be-freed memory.
>>
>> We have a test "dmsecuretest.sh" that loads cryptographic keys into the
>> kernel, dumps a core, the core file is analyzed and if it contains the
>> key, the test fails.
>>
>> This test fails on AMD Zen 4 - the reason for the failure is that the
>> "memcpy" function uses ZMM registers for data copying. When memcpy exits=
,
>> the encryption key is present in the ZMM registers and the key remains
>> there even after both source and destination buffers of memcpy were
>> cleared.
>
> Isn't this what  -fzero-call-used-regs thing is all about? can-t you
> just apply the same technique in the memcpy implementation and zero
> them out on return?
> vector registers are volatile after all.

The application might not know which vector registers glibc uses.

Ideally, we would zap the registers that we know we use in memset.  It's
probably most straightforward to do in the memset assembler
implementation, as a build variant, but I haven't tried actually
implementing it.

Thanks,
Florian

