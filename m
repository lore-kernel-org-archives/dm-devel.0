Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4025154442
	for <dm-devel@lists.linux.dev>; Sat, 21 Sep 2024 22:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726958031; cv=none; b=vDWbap31Bn062+KRKFupdfEMYBbjHNGkSbsf+cAxA97dAyQ7xwepyneNYupl540TyAGe9krvx5PbEvnLDX4C3PVciMAcdwonoaBB/Q5ORxOHre9mwAb/o5f5eyQTKZfDJ3qbg8NN4/rGqMd4QUp9IEw3Ag6rHVRBxjqQirBxkjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726958031; c=relaxed/simple;
	bh=Tp0FNXrk2yEfqUnoYGkY4MsSg6rdyB04bZgqohgoAbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kld2Y5pbtumibJCwG6aia/bJbBJQoNAuGXsezLv5q5KXwhd3Nsr1sWDrqz1e3fv1OUlqCV83r+fykhBuO87kWfGSCruBEHXnnsi3I1VeRkYrd4m4c6B1Cos+w5YOuJ7x2yxFinPo36SXAzJRYU4E7Hucz7oa24LOlRSz5sYPxwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=t1KuHiLa; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="t1KuHiLa"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-535dc4ec181so3152715e87.3
        for <dm-devel@lists.linux.dev>; Sat, 21 Sep 2024 15:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726958028; x=1727562828; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gX86j39e02j/mMJI41SFOhgjLK0jANOAafMy+BuLlM8=;
        b=t1KuHiLaCHLFuv8quwlHigRSuzxp6YJZW0/i2hAWaosnDgDJveEUtqenlj5Yzobr8g
         TwxPTsxZ/SAA5Jr4UMVXfoDADPgfQTmtOhGDIDJiCNHZzdrYczyQONjrKU/5wBon/dKq
         yyQ/v7htnxIpXL47sHY/P22ufQTP+YzGgYDiE0xpcoZ0jBEr4OUvbYjFbEhox+6ciOpv
         Qh9opawB+UcMo84KfTbXt+fTsZbbc7L6KfElCBnmUplRDbdxb6bBb3uXRuy830SyGNuc
         xnxWLFuDMjvPChrkl3aQ9urw6+ABGzqK2yPJ0zExyieQdLnXDwaTOG5NP7ZEhrwgtAMf
         9bkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726958028; x=1727562828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gX86j39e02j/mMJI41SFOhgjLK0jANOAafMy+BuLlM8=;
        b=WmI6Sg42Q1s/kH7A6tu0KG7Q65+DQKvnOS6GEx1/a4wFhJ4PTphJACL1gSdj+3d2mC
         SM524Jww5Y/qarg5RRk7SU1XuQl0u8gzgs9bytSuZmsCtN3tNwYYTOpkJ2kK4SixR9lf
         I1LzFu8wS7NHY+uPRPFtIgwzVlDoht1gGgaIccDPRIjRSET3LVP6oVM+8E2Bgz8OBJeE
         nureZPKK2bQc0wr0Edx5e9B3iHISUCZYy6fhpmWv0xkSjuI1u+wV133thqWRxOUkIa+i
         AIYzHXeNvpM3+e+r2xnsdlvQFIH+6cGlb7ou7ThIgpmKl32UdzQeL8D8dD5F8aTKaGyF
         scTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNWzv4aIAcP8RRnlMx+VNkTJXLx1tnqdCu3mPZxNA7/aGauM98z5D/+j2lRkQaTXknBlqwT/ZR6A==@lists.linux.dev
X-Gm-Message-State: AOJu0YyWZgwlLiqiDbUHP+LaIHnmgSaU+mEsge3wqmb9SltnPEwaD8rp
	D3eJEV5Ld0MDTi/Qi5KtCbq9xvXZ73/t9a5mQfc+sci7Enrl/Yvu4q2FLGILWpc=
X-Google-Smtp-Source: AGHT+IEQg2tUTFCeWCDOw+B1mlFRNoo51OtcNliubEi2LO0DCWuhnyqKCtGXKESfuGiyNwvVThuwYg==
X-Received: by 2002:a05:6512:ba4:b0:530:ba4b:f65d with SMTP id 2adb3069b0e04-536ad180176mr3632234e87.28.1726958027223;
        Sat, 21 Sep 2024 15:33:47 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-536870ad17dsm2741416e87.241.2024.09.21.15.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2024 15:33:46 -0700 (PDT)
Date: Sun, 22 Sep 2024 01:33:44 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Asutosh Das <quic_asutoshd@quicinc.com>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, 
	"bartosz.golaszewski" <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v6 09/17] soc: qcom: ice: add HWKM support to the ICE
 driver
Message-ID: <sgq72p6hkebkv6r5vsyvxsasojkhzlmwqravynpnwjkozwb7g7@6ml3vlkigxoh>
References: <66953e65-2468-43b8-9ccf-54671613c4ab@linaro.org>
 <ivibs6qqxhbikaevys3iga7s73xq6dzq3u43gwjri3lozkrblx@jxlmwe5wiq7e>
 <98cc8d71d5d9476297a54774c382030d@quicinc.com>
 <CAA8EJpp_HY+YmMCRwdteeAHnSHtjuHb=nFar60O_PwLwjk0mNA@mail.gmail.com>
 <9bd0c9356e2b471385bcb2780ff2425b@quicinc.com>
 <20240912231735.GA2211970@google.com>
 <CAA8EJpq3sjfB0BsJTs3_r_ZFzhrrpy-A=9Dx9ks2KrDNYCntdg@mail.gmail.com>
 <20240913045716.GA2292625@google.com>
 <egtwyk2rp3mtnw2ry6npq5xjfhjvtnymbxy66zevtdi7yvaav4@gcnmrmtqro4b>
 <20240921194939.GB2187@quark.localdomain>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240921194939.GB2187@quark.localdomain>

On Sat, Sep 21, 2024 at 12:49:39PM GMT, Eric Biggers wrote:
> Hi Dmitry,
> 
> On Fri, Sep 13, 2024 at 03:21:07PM +0300, Dmitry Baryshkov wrote:
> > > > > > > > Once ICE has moved to a HWKM mode, the firmware key programming
> > > > > > > currently does not support raw keys.
> > > > > > > > This support is being added for the next Qualcomm chipset in Trustzone to
> > > > > > > support both at he same time, but that will take another year or two to hit
> > > > > > > the market.
> > > > > > > > Until that time, due to TZ (firmware) limitations , the driver can only
> > > > > > > support one or the other.
> > > > > > > >
> > > > > > > > We also cannot keep moving ICE modes, due to the HWKM enablement
> > > > > > > being a one-time configurable value at boot.
> > > > > > >
> > > > > > > So the init of HWKM should be delayed until the point where the user tells if
> > > > > > > HWKM or raw keys should be used.
> > > > > >
> > > > > > Ack.
> > > > > > I'll work with Bartosz to look into moving to HWKM mode only during the first key program request
> > > > > >
> > > > >
> > > > > That would mean the driver would have to initially advertise support for both
> > > > > HW-wrapped keys and raw keys, and then it would revoke the support for one of
> > > > > them later (due to the other one being used).  However, runtime revocation of
> > > > > crypto capabilities is not supported by the blk-crypto framework
> > > > > (Documentation/block/inline-encryption.rst), and there is no clear path to
> > > > > adding such support.  Upper layers may have already checked the crypto
> > > > > capabilities and decided to use them.  It's too late to find out that the
> > > > > support was revoked in the middle of an I/O request.  Upper layer code
> > > > > (blk-crypto, fscrypt, etc.) is not prepared for this.  And even if it was, the
> > > > > best it could do is cleanly fail the I/O, which is too late as e.g. it may
> > > > > happen during background writeback and cause user data to be thrown away.
> > > > 
> > > > Can we check crypto capabilities when the user sets the key?
> > > 
> > > I think you mean when a key is programmed into a keyslot?  That happens during
> > > I/O, which is too late as I've explained above.
> > > 
> > > > Compare this to the actual HSM used to secure communication or
> > > > storage. It has certain capabilities, which can be enumerated, etc.
> > > > But then at the time the user sets the key it is perfectly normal to
> > > > return an error because HSM is out of resources. It might even have
> > > > spare key slots, but it might be not enough to be able to program the
> > > > required key (as a really crazy example, consider the HSM having at
> > > > this time a single spare DES key slot, while the user wants to program
> > > > 3DES key).
> > > 
> > > That isn't how the kernel handles inline encryption keyslots.  They are only
> > > programmed as needed for I/O.  If they are all in-use by pending I/O requests,
> > > then the kernel waits for an I/O request to finish and reprograms the keyslot it
> > > was using.  There is never an error reported due to lack of keyslots.
> > 
> > Does that mean that the I/O can be outstanding for the very long period
> > of time? Or that if the ICE hardware has just a single keyslot, but
> > there are two concurrent I/O processes using two different keys, the
> > framework will be constantly swapping the keys programmed to the HW?
> 
> Yes for both.  Of course, system designers are supposed to put in enough
> keyslots for this to not be much of a problem.
> 
> So, the "wait for a keyslot" logic in the block layer is necessary in general so
> that applications don't unnecessarily get I/O errors.  But in a properly tuned
> system this logic should be rarely executed.
> 
> And in cases where the keyslots really are a bottleneck, users can of course
> just use software encryption instead.
> 
> Note that the number of keyslots is reported in sysfs.
> 
> > I think it might be prefereable for the drivers and the framework to
> > support "preprogramming" of the keys, when the key is programmed to the
> > hardware when it is set by the user.
> 
> This doesn't sound particularly useful.  If there are always enough keyslots,
> then keyslots never get evicted and there is no advantage to this.  If there are
> *not* always enough keyslots, then it's sometimes necessary to evict keyslots,
> so it would not be desirable to have them permanently reserved.

I'm still trying to propose solutions for the hwkm-or-raw keys problem,
trying to find a way to return an error early enough. So it's not about
the hints for frequently-used keys, but for returning an error if the
user tries to program key type which became unusupported after a
previous call.

> It could make sense to have some sort of hints mechanism, where frequently-used
> keys can be marked as high-priority to keep programmed in a keyslot.  I don't
> see much of a need for this though, given that the eviction policy is already
> LRU, so it already prefers to keep frequently-used keys in a keyslot.
> 
> > Another option might be to let the drivers validate the keys being set
> > by userspace. This way in our case the driver might report that it
> > supports both raw and wrapped keys, but start rejecting the keys once
> > it gets notified that the user has programmed other kind of keys. This
> > way key setup can fail, but the actual I/O can not. WDYT?
> 
> Well, that has the same effect as the crypto capabilities check which is already
> done.  The problem is that your proposal effectively revokes a capability, and
> that is racy.
> 
> - Eric

-- 
With best wishes
Dmitry
