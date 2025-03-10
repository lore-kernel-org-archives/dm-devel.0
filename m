Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0710A1DF72D
	for <dm-devel@lists.linux.dev>; Mon, 10 Mar 2025 21:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741641897; cv=none; b=PSR/8lcqUW1YDN6Hs9LklJa+jt536fDeZoqYq6nYZZcvIoiOzi67gOLBmJWR+jSwAjqnYgKCpHIGFsXJrWnlUQBjyIHEQ+il8UBTqh/YbTUBytWS5U4Oeqr+IX2e2sEG2UnzaXKqMWuVatk8J1RFiP+bQ0lsymhjiQIC3CYjVJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741641897; c=relaxed/simple;
	bh=6gKm3cDYlZkS44vV5VvqXJfrlw0dTtNzRpW7jfAnRUM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=j1CjCVHNv224OEIknSQxCjfC+999WucIH/VReQkE1MM0r6ohrwLeGtDVGVoJRAIYh9k2tSUfxzTS1CYLHETw2ERCfqVgdz1Gq+m7+b5WT+c3vkk8hvYK+ufwmDvXU53YhyYLAP1d3oeHpc/2FxhD8NAnJTTSU15vpzOPrjT8RiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MaAoY7jd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MaAoY7jd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741641894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LEnlNaswidzUugJbJ7UhbKuL7xpkOPT1NVdOljaiZuA=;
	b=MaAoY7jdacVJqZ5tnbeohtxudt2MNT4Dk5Fv8txdHTYQ6N+PQske9BFREhQ0nhiqHdRzDe
	vtAzO8eA2wlvVLvThlbSIoOMurVsBwJZ5mmUNWtxlNtK24ZelYGVZuoZ49z9ReO1mnQz9D
	+rN1x8KfshYObEIsIgquz2tkjVr5Vss=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-6asTICabPMu0sV_96wP1lQ-1; Mon,
 10 Mar 2025 17:24:51 -0400
X-MC-Unique: 6asTICabPMu0sV_96wP1lQ-1
X-Mimecast-MFC-AGG-ID: 6asTICabPMu0sV_96wP1lQ_1741641890
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 66618180049D;
	Mon, 10 Mar 2025 21:24:50 +0000 (UTC)
Received: from [10.22.82.75] (unknown [10.22.82.75])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55C6A1956094;
	Mon, 10 Mar 2025 21:24:49 +0000 (UTC)
Date: Mon, 10 Mar 2025 22:24:44 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Zack Weinberg <zack@owlfolio.org>
cc: dm-devel@lists.linux.dev
Subject: Re: Allowed characters in strings passed to/from device-mapper
 APIs
In-Reply-To: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com>
Message-ID: <a81665e6-8516-2c98-1f89-cbfc11774f14@redhat.com>
References: <0211b995-d844-4a0d-a02f-2f9bd2a4215e@app.fastmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JmDkZ3GD40cpqGPqtZmbhqHq5b08k5-htYIJSii29qg_1741641890
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-999599827-1741641890=:646484"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-999599827-1741641890=:646484
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

Hi

On Sun, 9 Mar 2025, Zack Weinberg wrote:

> I am developing a device-mapper client library in Rust.  The language is
> relevant here because Rust's standard library makes a strong distinction
> between strings that are known to be encoded in UTF-8 and strings whose
> encoding is not known (`str` vs `OsStr`), with the latter being awkward
> to use compared to the former.
> 
> The device-mapper ioctls use a lot of strings, and it's not clear
> to me from either the documentation or the kernel's source code
> what expectations the *kernel* has of the character encoding of these
> strings.  I don't expect the kernel to care about UTF-8 versus
> ISO-8859-n or whatever, but it is plausible to me that at least some
> of the strings used in device-mapper ioctls can be expected always to
> be ASCII, in which case I can safely use `str` for them on the library
> side and it'll be more ergonomic for end users.
> 
> There are, I think, four different kinds of strings used in device-
> mapper ioctls: target names, device names and UUIDs, table parameters,
> and target messages.  For each of these, I would like to ask:
> 
> * Are there any circumstances where non-ASCII bytes *should* be
> used in this type of string *when supplied to the kernel*?

I think there's no reason to use non-ASCII characters in device mapper.

> * Are there any circumstances where a client library should expect
> non-ASCII bytes to *appear* in this type of string *when reported
> back to the client by the kernel*?

If the user creates a device name with non-ascii characters, it will be 
reported as such in the kernel ioctls.

> * If there are any such circumstances (either way), does the kernel
> try to interpret non-ASCII bytes in this type of string as characters
> in a specific encoding, or does it just treat them as an opaque
> token (as is typical e.g. for pathname components)?

The kernel just passes non-ascii characters as opaque tokens. It doesn't 
attempt to interpret them.

But udev mangles non-ascii characters - i.e. if you create
dmsetup create ì¹èø¾ýáíé --table '0 3951256 zero'
you get
ls -la /dev/mapper/
'\xc4\x9b\xc5\xa1\xc4\x8d\xc5\x99\xc5\xbe\xc3\xbd\xc3\xa1\xc3\xad\xc3\xa9' -> ../dm-0
ls -al /dev/disk/by-id/
'dm-name-\xc4\x9b\xc5\xa1\xc4\x8d\xc5\x99\xc5\xbe\xc3\xbd\xc3\xa1\xc3\xad\xc3\xa9' -> ../../dm-0

dmsetup table will show
ì¹èø¾ýáíé: 0 3951256 zero

dmsetup remove ì¹èø¾ýáíé will remove the device

Mikulas

> Thanks,
> zw
> 
> please cc: me directly on all responses, I'm not subscribed to the list
> 
---1463811712-999599827-1741641890=:646484--

