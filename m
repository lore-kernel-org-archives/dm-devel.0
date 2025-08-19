Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4F026B777
	for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 07:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755587682; cv=none; b=JEeg9JpoMDEKW36YoXoZwOdR0FcMIz9Okry+cjS7aNsDH35/MQJg6HRk3bKOLptLLGfdWZSGpQxjqthmh/j4xq1w+f4cR1TLQ/HOARCG4fF4r9o2VYr4OiRS0xBJ2SEd5CnKnVT+Mu53BStPyPmno9ZkTZ4znU7iKgyQ/W3onsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755587682; c=relaxed/simple;
	bh=f0ub/InuOgy6449YiKc8xhpRb41q1FFGGc6RZpwwfYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZWIMTSzeABmB5Ga0611FxFhgMEG4vztyaRSKNMr/5udqZ2ILLVfSQmzF4MpAb9PwCaFzrGJZq/Ba4/hueYcOVMjSTEFeOoLiHV4GjtVkTlkQqvplFZ1azcvXVXF4FwWW/BIJ/1xFJPge431xumNX5d8HdoSv5+SPmljdovRSLj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XsspynAZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XsspynAZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755587679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YB67Kf0iC+sqlWYpOqUJTReJnzcfW+maMcIr49QKTaE=;
	b=XsspynAZTfw6CxVj9TCO9mn98Otoh8kbGivkmvGHCxXSn7TIixmi3Q0EVVW9zK6LVu41Nm
	dzUReXqxwOBgyxKOy9iv1ISqk91fHg0ErwqGR9lFxIffU1HUP67quMKJ2tFBsFR2GDn1BE
	5IDlxJ0PDVuugW6Qo6xOQnAsXtPVqeY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-oES8X4T8NhOX8Lq_lN0xDw-1; Tue, 19 Aug 2025 03:14:38 -0400
X-MC-Unique: oES8X4T8NhOX8Lq_lN0xDw-1
X-Mimecast-MFC-AGG-ID: oES8X4T8NhOX8Lq_lN0xDw_1755587677
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-afcb79a761cso352981566b.2
        for <dm-devel@lists.linux.dev>; Tue, 19 Aug 2025 00:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755587677; x=1756192477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YB67Kf0iC+sqlWYpOqUJTReJnzcfW+maMcIr49QKTaE=;
        b=xMucMm7yvx0ewgsGkHNPlQY6m6pPTcG7/DDpOqPqZu3uJnEnTj0yPzr2FbxhDIPoMX
         ECnmlM3oPJ0QWIgFSMD5AwvIdHCX3Kcg9GgmtRWUk3mPXNe3ySwMPtuZac9ojllpNqFT
         EGLSupVuRMKtuTxFMbVul2BHvFgnUNvW1u75mQgAAQIqnMbJeuMrS9cIKWc8uZM1JR+s
         3Eb0HZIlbeGuQBZsj+nF3H9N83GNBxZD0u8YAB5/lLqfjijGY77meDbzjQIJDuWfjzBn
         L8vztY1IIWPfVQWTdRXgHYK+20WYuGg2HEg0UNK1rA8GhgceLz8W7WDUBVjwcvj0puA5
         PRoQ==
X-Gm-Message-State: AOJu0YyoSoJf1BFsYk61xzXSL8XYfJFq4QXIjYuNbOhychUe/cXvNf0Y
	lMR7yNw8HaWOFNH1JG5/POxUDBhJpyK4COiBtvJxBEEO4ZG1xPR0eUxE2m8HQnqRm6FdiA0RTkj
	c7CJbJh7d8Kiuu6Phw1Zz4tMF63E3FkbLvJ5TXIrgaA+t7XzNZY228W8gizs5tdlqEuitdsMJn+
	HdJkfgmbe8g2emFpU0nSpz/IJIWnbUNdEtvFk=
X-Gm-Gg: ASbGnctf/9+KqSgC1XQC4SASFFzu3UgviYfpTohy3RZtGTTRw+wdw8QwoO8h9mEcW8A
	TCEwmY47fFqcdunOoE/wQSctB1J3408MK70jwWMq3t3YEksl559RC+d5yZbGTIubPHHdIZNWxeF
	I0QeOqzpDZr9vEYLVaCV1E
X-Received: by 2002:a17:906:6a17:b0:ae6:d47a:105d with SMTP id a640c23a62f3a-afddd208983mr145345066b.55.1755587676744;
        Tue, 19 Aug 2025 00:14:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGS/UxeNVwfiglWrnccTzYyPBKThwF/kxa2t30RBxZG9L9lmhwRi9rGzkBXiLhz5JtObaKcnjMJG8RcH6v4q1c=
X-Received: by 2002:a17:906:6a17:b0:ae6:d47a:105d with SMTP id
 a640c23a62f3a-afddd208983mr145342266b.55.1755587676179; Tue, 19 Aug 2025
 00:14:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250817194923.307911-1-akalenyu@redhat.com> <aKNgpm9XllLUyEiJ@redhat.com>
In-Reply-To: <aKNgpm9XllLUyEiJ@redhat.com>
From: Alex Kalenyuk <akalenyu@redhat.com>
Date: Tue, 19 Aug 2025 10:14:25 +0300
X-Gm-Features: Ac12FXxMo_qznrcx2Pa6jT-jeMKEQC8z5IvytRIdeaXdpGietH3UPLzSAcuYbt0
Message-ID: <CAHahevfeZFZdm3qY_-=cr4U940oqz0EaWxTQQKoGOw5Nn_E=rA@mail.gmail.com>
Subject: Re: [PATCH] Take undef enum into account for correct array index comparison
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, mwilck@suse.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0GZBHtnJKU7YR9ZhogjqeaFVtTd4pTp3YEGFuH_AkOQ_1755587677
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You're totally right, I had an older multipath running on my system,
and I did not realize (only yes/no in flush_last_del).
This commit can be safely ignored, everything is working as expected, thank=
 you!


On Mon, Aug 18, 2025 at 8:19=E2=80=AFPM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> On Sun, Aug 17, 2025 at 10:49:23PM +0300, Alex Kalenyuk wrote:
> > Previously this would compare to the wrong index
> > since the enum has an additional UNDEF entry
>
> Are you actually seeing multipath getting misconfigured here, because
> the code doesn't look wrong to me.  We didn't and the "undef" elements
> because we don't want to accept "undef" as a valid value from the config
> file.
>
> This code is admittedly a little confusing.  We aren't looping from 0 to
> the last value, we are looping from FIND_MULTIPATHS_OFF or FLUSH_NEVER
> (which have the value of 1). The way the loop works, we won't even check
> the config text against the array elements you added. We intentionally
> only set elements in those arrays at the values we want to start
> checking at: FIND_MULTIPATHS_OFF and FLUSH_NEVER. As long as the text in
> the optvals array is correct for the value we are using as its index, if
> we match the config text with the optvals text, 'i' must be equal to the
> value we want (since the value we want is array index of the matching
> text).
>
> If you are seeing a configuration issue, we do want to hear about it.
> I'm not saying there isn't a bug, but unless I'm missing something, I
> don't think that this is it. Also multipath's configuration priority
> isn't always super intuitive, so sometimes it is working as designed,
> but not you might intuitively expect.
>
> -Ben
>
> >
> > Signed-off-by: Alex Kalenyuk <akalenyu@redhat.com>
> > ---
> >  libmultipath/dict.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> > index a06a6138..2e820b2e 100644
> > --- a/libmultipath/dict.c
> > +++ b/libmultipath/dict.c
> > @@ -550,6 +550,7 @@ static int snprint_def_partition_delim(struct confi=
g *conf, struct strbuf *buff,
> >  }
> >
> >  static const char * const find_multipaths_optvals[] =3D {
> > +     [FIND_MULTIPATHS_UNDEF] =3D "undef",
> >       [FIND_MULTIPATHS_OFF] =3D "off",
> >       [FIND_MULTIPATHS_ON] =3D "on",
> >       [FIND_MULTIPATHS_STRICT] =3D "strict",
> > @@ -793,6 +794,7 @@ declare_def_snprint(allow_usb_devices, print_yes_no=
)
> >
> >
> >  static const char * const flush_on_last_del_optvals[] =3D {
> > +     [FLUSH_UNDEF] =3D "undef",
> >       [FLUSH_NEVER] =3D "never",
> >       [FLUSH_ALWAYS] =3D "always",
> >       [FLUSH_UNUSED] =3D "unused",
> > --
> > 2.50.1
>

