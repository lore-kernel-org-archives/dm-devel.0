Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D88C535A2
	for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 08:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713515278; cv=none; b=ZIyRGo6h/UfDBQANdsBRPAFVZKdWnthGd9jrRA1spIDKXaJr9Yd9HhIgvYid6c0nAaDIUB1Zw0dHXa0TRtq7yQWQiBOJu0/skrE3TewI924tHy7YbPmdngiwCp/bUstkI7MKWSY+Nyc/DryrMaij68gNDADp5oFbHxj1HADrdlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713515278; c=relaxed/simple;
	bh=J09rxLxi86It4PgjVv38Qpy/ZjIJKNE3voqadxsgfgk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RzulVlt7aPactAekkFJ/wc46xKrNaAmacRtzzGIzyYu2HdHkbw6rAsoV8uSns7Omp5+2OlRXr+ulWAC6SZE4m0KKOZ/fkWnk4YjnD0xOUKS8muzksrG0v1iTkdHfXV5DK9H0Bspmp0RfVrjtAL6LGPfVP+WXO+7LD3XJfEDxJ+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G1AJoONl; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G1AJoONl"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-571ba432477so1716953a12.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Apr 2024 01:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1713515275; x=1714120075; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J09rxLxi86It4PgjVv38Qpy/ZjIJKNE3voqadxsgfgk=;
        b=G1AJoONlM9+Yd6xJFr5ITWQRYXULRB1nsNEQiU+4JTQ7VM4eb6ypDBTctJYNnnlGQp
         QOfQsAlxVoQkUIm1+d3PDI6QLcnytRrJ3/b2l/3rYsdiEdorLaKXzNKI+HV/F+BtqPyB
         qNvP5ngslU/jc0VQ4VgVJOV+GY1sC18CtTvw5fSz30E0VqMqZOTvFLXWBGjMyf96oZv9
         vj7Od4ogSdSu40yjAUEklrFjdz5Gto89mcpLzVoz8aiDhs8YIwoZkRuYgBhFN3izH+BD
         FCZDuyKt7nuFEqD13d7erQ7CiiVvjWzV8w5652N5cdjGdywuWNyKbBUXk/SPMaZBCHoH
         fTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713515275; x=1714120075;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J09rxLxi86It4PgjVv38Qpy/ZjIJKNE3voqadxsgfgk=;
        b=WJ1t2q0dVs5+eSgyk+SI54qX1qB1uhDtIJ+33fa/lf7oqt/DFcJvPy5m3pW1AJy4No
         frO4hTQVQjhd+87l1ZF1XSwS9BNtP4IETlfYOLJvmESJNuYgYSZpiEZbWqKPAxy4V98c
         FfXn/M0vPhZ495l/Ef8ewMQSbBqrP5XN5av6OQ2H6MAXDPwlbw+QdlPQjwzxAaotP04u
         5YLJjr/N1wA6mhL0N9wZU6i4Pm5/atM+6nbziYaqBBmSDZBjTGWESlrU/4x16pL/owJw
         3DzvxcPkVjXnADOv72m3bCr4KVFRM2xXJG5WiaAYn1hFZNygFajqekeHkFEUKzwQvwlw
         oWQw==
X-Forwarded-Encrypted: i=1; AJvYcCXtQcYU14wwVcTBZU6BjLcULMTSRqJgec0AGlmYo5M1Es6Y+oDltpo3xqG+JNJv8FTNO8wq2Q3wmAKn5MXLOxHDZf3PBm7FWLs=
X-Gm-Message-State: AOJu0Yw1rrYbTI/1idh/qLByvP/ErYCfiKHAuhZ+IUN42DqAaHkb1pjt
	q1iHk9SUEADHhjqDdbp8SvPBivbwfa5AwNKF7oI20CTXFV/77J6uimu3yQ/dFZA=
X-Google-Smtp-Source: AGHT+IFd/M68aCOdOc4f0YW+896oGJ2oH2Hi/l6QeGg8t6WJC3z2Sk/Z9e2fiIIivBKEHLgzLuEvWQ==
X-Received: by 2002:a17:906:3403:b0:a52:2d83:1483 with SMTP id c3-20020a170906340300b00a522d831483mr885477ejb.53.1713515274769;
        Fri, 19 Apr 2024 01:27:54 -0700 (PDT)
Received: from apollon.wilcks.net (dslb-090-186-231-154.090.186.pools.vodafone-ip.de. [90.186.231.154])
        by smtp.gmail.com with ESMTPSA id jr13-20020a170906a98d00b00a4e03823107sm1882121ejb.210.2024.04.19.01.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 01:27:54 -0700 (PDT)
Message-ID: <be267b46dd6bea6d82334d9d591c9a5054ff3b17.camel@suse.com>
Subject: Re: [PATCH] scsi_lib: Align max_sectors to kb
From: Martin Wilck <martin.wilck@suse.com>
To: Christoph Hellwig <hch@lst.de>, Benjamin Marzinski
 <bmarzins@redhat.com>,  Hannes Reinecke <hare@kernel.org>, Mike Snitzer
 <snitzer@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen"
	 <martin.petersen@oracle.com>, James Bottomley
	 <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, 
	dm-devel@lists.linux.dev
Date: Fri, 19 Apr 2024 10:27:53 +0200
In-Reply-To: <20240419062035.GA12480@lst.de>
References: <20240418070015.27781-1-hare@kernel.org>
	 <20240418070304.GA26607@lst.de>
	 <5707dfc3-f8e2-4050-9bba-029facc32ca9@suse.de>
	 <20240418145129.GA32025@lst.de>
	 <410750a52af76fdc3bcf6265c9036037cb8141da.camel@suse.com>
	 <20240419062035.GA12480@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

(added Mike, Ben, and dm-devel)

On Fri, 2024-04-19 at 08:20 +0200, Christoph Hellwig wrote:
> On Thu, Apr 18, 2024 at 06:46:06PM +0200, Martin Wilck wrote:
> > > Why would we?=C2=A0 It makes absolutly no sense to inherit these
> > > limits,
> > > the lower device will split anyway which is very much the point
> > > of
> > > the immutable bio_vec work.
> > >=20
> >=20
> > Sorry, I don't follow. With (request-based) dm-multipath on top of
> > SCSI, we hit the "over max size limit" condition in
> > blk_insert_cloned_request() [1], which will cause IO to fail at the
> > dm
> > level. So at least in this configuration, it's crucial that the
> > upper
> > device inherit the lower device's limits.
>=20
> Oh, indeed.=C2=A0 Request based multipath is different from everyone else=
.
> I really wish we could spend the effort to convert it to bio based
> and remove this special case..
>=20

Well, it's just a matter of setting "queue_mode" in the multipath
configuration. But request-based has been the default since kernel v3.0
(f40c67f0f7e2 ("dm mpath: change to be request based")). While we
got bio-based dm-multipath back in v4.8 (76e33fe4e2c4 ("dm mpath:
reinstate bio-based support")), making it the default or even
removing request-based dm (in order to free the block layer from limit-
stacking requirements) will obviously require a broad discussion.

Mike has pointed out in 76e33fe4e2c4 that many of the original reasons
for introducing request-based dm-multipath have been obsoleted by
faster hardware and improvements in the generic block layer.=C2=A0

I am open for discussion on this subject, but with my distribution=20
maintainer hat on, I don't expect the default being changed for end
customers soon. Actually,=C2=A0with NVMe rising, I wonder if a major
technology switch for dm-multipath (which is effectively SCSI multipath
these days) makes sense at this point in time.

Thanks,
Martin

