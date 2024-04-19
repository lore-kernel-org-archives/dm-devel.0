Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EBC64D
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 23:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713569287; cv=none; b=QziNykNEmTNgY8CdxwkjOsaU2PR3PDJ/cXRX3cDgGEtvcYRXGvApczp/h5Ql9vIPzkhZbCdUsAzOX99mbwIUX7pL/b3tKkQR+uJhDPbRcLgrOZzBXSYsVXIzv2aCYkXqeVsOlYGw1E3EgF50SPi6ivNTviNWNwjoCyzxhQOtsIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713569287; c=relaxed/simple;
	bh=Jvp3De7Po/YZgJvraEyMsU6TUn/tKWa+wwbzwG04jdY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=aRIuf56ll3cvgnERXvMOMFZBT2PlG3ndAboi0rPAQ9EV8NFA3153Kjw8amcyXTdPcSl4FauW0fRwSRV/8l4/0Zi6aynzqQR4Ms81MxFEa1HKOLoi9hF7OPTNTsZKLmeGFvPKPlUJ+uGTcXSzINj7kWd3aevFW+XN7cv9qmBCr58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b80BiUxC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b80BiUxC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713569285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1n3WJuPHRSnueJ7aNYZcbc67rJRsuxirxxZjycOPRek=;
	b=b80BiUxCM314migjZTxgHnQnQpo10kkegkBzkDcJPgVN1WB14YhNdHjd1NDa1WUvs3RcpN
	Ty/U4sc5CW9+PfN+/XTcb1VmUc3xKHZTK8ZP/FEFNnEwSUXuMIzQJqVESV+4PCrPbGZ7D2
	gjb7oRRFvI0bSW+A/lOGO0PungWyVpU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-poI1QuLPPzOM7cEATTp1_w-1; Fri, 19 Apr 2024 19:28:02 -0400
X-MC-Unique: poI1QuLPPzOM7cEATTp1_w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E74D1044573;
	Fri, 19 Apr 2024 23:28:01 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.192.63])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA2F840005B;
	Fri, 19 Apr 2024 23:27:58 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Zack Weinberg <zack@owlfolio.org>,  Alexander Monakov
 <amonakov@ispras.ru>,  Paul Eggert <eggert@cs.ucla.edu>,  "H . J . Lu"
 <hjl.tools@gmail.com>,  GNU libc development <libc-alpha@sourceware.org>,
  Zdenek Kabelac <zkabelac@redhat.com>,  Ondrej Kozina
 <okozina@redhat.com>,  Milan Broz <gmazyland@gmail.com>,
  dm-devel@lists.linux.dev
Subject: Re: memcpy is leaking secret data through ZMM vector registers
In-Reply-To: <c5ac58cf-3e2e-3cc4-5a18-32c9acdef82d@redhat.com> (Mikulas
	Patocka's message of "Fri, 19 Apr 2024 23:11:54 +0200 (CEST)")
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
	<CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
	<a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
	<CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
	<e35dccca-a1e7-93c4-f797-b89246877370@redhat.com>
	<9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu>
	<d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com>
	<ae79e84e-5a69-dc3a-08da-ef03f6d17c34@ispras.ru>
	<a2369edc-7159-4f0d-8f89-9d41a79d7f7e@app.fastmail.com>
	<4f9517c-46e-367c-8891-e452d7983b67@redhat.com>
	<df151cf3-fb22-4465-81dc-34e0172a4fcb@app.fastmail.com>
	<c5ac58cf-3e2e-3cc4-5a18-32c9acdef82d@redhat.com>
Date: Sat, 20 Apr 2024 01:27:57 +0200
Message-ID: <878r196igy.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

* Mikulas Patocka:

> On Fri, 19 Apr 2024, Zack Weinberg wrote:
>
>> On Fri, Apr 19, 2024, at 4:15 PM, Mikulas Patocka wrote:
>> > On Fri, 19 Apr 2024, Zack Weinberg wrote:
>> >> ... the copy
>> >> of round_keys in the vector registers *won't* get erased -- the exact
>> >> problem being discussed in this thread.
>> >
>> > On the SYSV ABI, all the vector registers are volatile, so you can erase 
>> > them in explicit_bzero.
>> >
>> > On Windows 64-bit ABI, it is more problematic, because some of the vector 
>> > registers must be preserved.
>> 
>> Oh, huh. Yes, that would work.
>
> I've just realized that this wouldn't work - if the function 
> explicit_bzero is lazily resolved, the dynamic linker would spill the 
> vector registers to the stack prior to calling explicit_bzero.

No, the dynamic linker makes a tail call to explicit_bzero.  There's no
register restore on the return path, all that happens before the tail
call.

Thanks,
Florian

