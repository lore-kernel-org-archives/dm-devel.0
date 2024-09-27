Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97ABF18DF9E
	for <dm-devel@lists.linux.dev>; Fri, 27 Sep 2024 14:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727448934; cv=none; b=EeIjU9AlOcVEk5Ayc6eFrcEgYqPSf9HrHufBRtGUftSgLysgWySbIPpjonIqFt2J8QLPq1y0JFM8MvFZ1rTZeXCz4XG5bmbYMKNiRTqdGGrmYBU7mNaavtuOSfhsXHLacH+4GxYurXnndq/Wk7qsRmbASHlft49CJSM/ZDLzE1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727448934; c=relaxed/simple;
	bh=0EVepbn+bVVSpEU+e8lsjJdWhXyK12vHg3Bb0EdwGKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mdUyhd97aK38WlOrZ0UJZlD0hdlpBj/Kna191wrng3GbCyCIBcfCjScBEpg4RV98yV94nQPuffiY/Ndo7LY2YdOLcCRzLSk8UCAl8rVrYhRTwJisTAm4xxkMoCxweexUy3J4F/zpcolblNC115bBJjXdwM9ab9oRjOPNyHpBkq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cYfXbFcc; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cYfXbFcc"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4581cec6079so249421cf.0
        for <dm-devel@lists.linux.dev>; Fri, 27 Sep 2024 07:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727448930; x=1728053730; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Odqifz+Dyhn6BLCOyjrRmY5ol1zncEXDXvRmlscksU=;
        b=cYfXbFccEL+O7O8A//sAvdmlZJcF0ptbiIO6aUXhcnOqkGAdIdwNwrTM4K90Tn5/Av
         Yhra9aq4rHfpChtU1jNAo1+U45Tif4WPyqjrhNegGJks1ZWY1UV9uNb1l5leYj+d9D6+
         fKzoD/GTM/jQSkvVl/biKm4HfyB3M/yBkN18Ts7hX8U/MxqM6+KS7/6/4q0KjWR/Knj4
         7Mf3uOjoQQbX1TcZEYJdnAvNOC19+vrirBARnIdCGEHVCL9Vo3Gwduy+IDYg4CaDXVzD
         3ZyZ5UTVZ+C6lRqgeBCeu3EhA5oIAyULzrRhludV7BJlgQrhZLfcHzQRIj3XjU5Iyd+8
         pY2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727448930; x=1728053730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Odqifz+Dyhn6BLCOyjrRmY5ol1zncEXDXvRmlscksU=;
        b=MvjqBWeFG98UZp74kNYGXW5tnl12+t3Q91ObaBN0L49ShIBtGwJQhe6mbogosbiH/g
         A4la81157HtfadeAcKv91srYayfe+CPCxsHKOR9XNdbVaOsGyqaVx9X+RlQ2d0AxB0xN
         0iC4mFjnD0LY85i/YP5buFabLzt2Gz0LTr+mJ0WmdSfX0PVcuJ3MbqIK0EPq7jjWnh4w
         UpKQ1QY6VvxYiFVtwccZFzyHhKF/+PBIlPcIxbNb+gmrNzR8C9UTtsGIFglPgek0ZTZq
         JOaRT6dgwFFq+LREGsqu3u9swNT7heWoN/tKuOe1hhAoQlaor0lsonghbUGEJeH82R/i
         Xc5w==
X-Forwarded-Encrypted: i=1; AJvYcCUUWn5SOiUua85gj9+YzK9GGsCBVNKoN+KDaSCJoVlSX6xiZyfLiISOOc+6fQ79DxNBg96GTILECQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyCu6LrMFSnB7fP0lkHE2UxG3+y+bEEcdq9wxHK9uzJskxwRSaZ
	8FRnWn1XAjkX/PyRCkoG0AsCbP/D7gMc9G7acaWYp2dk56S642OT/kBYo9rOeH7J54h9PfG/EIl
	NdzdXz7CHWCz358w0DR+3G8wPVlnk79HIOk/o
X-Google-Smtp-Source: AGHT+IG4JYPGU3pRiTrbLvUgpfzi065M1ItnSDmUQVRBu4ylg9JiCHc7Y9AIHoobTfeo69eg+AacnOVN0XLaMKVxsLA=
X-Received: by 2002:a05:622a:4393:b0:44f:9db1:7fca with SMTP id
 d75a77b69052e-45ca025ff63mr3542841cf.28.1727448930023; Fri, 27 Sep 2024
 07:55:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cad3f86f-09bf-bc5f-c086-fc623ad223f4@redhat.com>
 <CABCJKudRQuA_kv8Gyu_9-1grZmVR=c=oywrPuUFprnQ1v_+Byg@mail.gmail.com>
 <CABSDvDLu9-uzbd9z-avUu-iLV9rgyy=LKzaOwdWnD0f7ruBizg@mail.gmail.com>
 <9dee84e8-6c94-7450-a0c4-a95cab8f66d4@redhat.com> <b65d67cf-9904-4182-a113-2d9a241dd668@gmail.com>
 <CAKeu6dUEC-j5G+KOTFUdfinMe+HTBSm6idxhHQzwVr8Sp_MfMg@mail.gmail.com>
 <3d31625f-3b26-47d7-b933-0bd6a89b748b@gmail.com> <CABCJKuf3bkJXS2dzud5w7MrfEcYa21mbKa=ssEOQxPzfDtzE2g@mail.gmail.com>
 <1229c48a-a225-e426-7f39-465146754975@redhat.com>
In-Reply-To: <1229c48a-a225-e426-7f39-465146754975@redhat.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 27 Sep 2024 07:54:50 -0700
Message-ID: <CABCJKudUHS_vzW1G08_24JxLbSmZwKUUUtaWkFSjv6gFz6+GXw@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: restart or panic on an I/O error
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>, Maxim Suhanov <dfirblog@gmail.com>, 
	Akilesh Kailash <akailash@google.com>, Alasdair G Kergon <agk@redhat.com>, 
	Greg KH <gregkh@linuxfoundation.org>, Mike Snitzer <snitzer@kernel.org>, security@kernel.org, 
	dm-devel@lists.linux.dev, Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2024 at 1:44=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
>
>
> On Thu, 26 Sep 2024, Sami Tolvanen wrote:
>
> > On Tue, Sep 24, 2024 at 11:35=E2=80=AFPM Milan Broz <gmazyland@gmail.co=
m> wrote:
> > >
> > > On 9/25/24 8:09 AM, Maxim Suhanov wrote:
> > > > Hello.
> > > >
> > > >> This is a very strange reasoning. I can say that restarting on an =
IO error
> > > >> (that can happen in normal situations) could cause another securit=
y issue,
> > > >> such as DoS. EIO is not a data integrity error; it can happen even=
 higher
> > > >> in the storage stack... and the application should handle it anywa=
y.
> > > >
> > > > In the default mode of operation, there should be no panic/reboot o=
n
> > > > an I/O error.
> > > >
> > > > The issue and the proposed patch affect the non-default modes:
> > > > panic_on_corruption and restart_on_corruption.
> > > > Users relying on one of those two modes expect the system to crash =
if
> > > > something goes wrong [1]. So, DoS is expected here. Returning I/O
> > > > errors to the reader isn't something that is expected here (see [1]=
).
> > > >
> > > > The issue allows the attacker to "downgrade" the "panic_on_corrupti=
on"
> > > > and "restart_on_corruption" modes to the default one by creating
> > > > unreadable sectors on the underlying media (e.g., through the Write
> > > > Uncorrectable command).
> > >
> > > Sorry, but I do agree with this.
> > >
> > > Panic/Restart should happen on data corruption (or failed Reed-Solomo=
n
> > > FEC data recovery fail). IO error (and other errors that basically tr=
anslates
> > > to this) can mean something else and userspace application must proce=
ss
> > > it in error path (think about network failure).
> > >
> > > This is how is the dm-verity flag is documented:
> > >
> > > restart_on_corruption
> > >      Restart the system when a corrupted block is discovered. This op=
tion is
> > >      not compatible with ignore_corruption and requires user space su=
pport to
> > >      avoid restart loops.
> > >
> > > It says nothing about restart on other error, that can come from cryp=
to, network
> > > or whatever. You are redefining the policy here.
> >
> > I thought about this a bit more, and I agree with Milan. I/O errors
> > can be temporary and applications should be expected to handle them.
> > IMO we should trigger a restart/panic only if the underlying device
> > has corrupted data. If there's a use case for restarting on I/O errors
> > too, there should be a separate flag for that.
>
> See for example openssh, the function read_config_file_depth. There is:
>
> while (getline(&line, &linesize, f) !=3D -1) {
>         ... process_config_line_depth
> }
> free(line);
> fclose(f)
> if (bad_options > 0)
>         fatal("%s: terminating, %d bad configuration options",
>                 filename, bad_options);A
> return 1;
>
> So, the function doesn't distinguish between error and eof. If reading th=
e
> config file returns -EIO, the function exits with 1 as if the file was
> empty.

Sounds like OpenSSH's threat model doesn't include an attacker who can
trigger arbitrary I/O errors. If you want dm-verity to protect against
this, why not add a new restart_on_errors flag instead of changing the
semantics of the restart_on_corruption flag and risk breaking existing
users?

Sami
