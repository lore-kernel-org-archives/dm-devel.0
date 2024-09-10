Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672ED1779BC
	for <dm-devel@lists.linux.dev>; Tue, 10 Sep 2024 06:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725949751; cv=none; b=kZ400U41m5r2lXSB0Hq1nLTNJAUGNa9j4vT2hyiyDeLScgaLzaiTBIvJTKJl2rtPId3hqLeNOzdgJ0fxb+9sxiNnQc0IH7fHFKycizsICfH+kx0LZcbbZK2mgeMCD0QKzkhmaDbDyFTpeoSlQdtdvkuSQgugtGB0jEX4W+DVuMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725949751; c=relaxed/simple;
	bh=XaQZaTfk+la0ZZ6tSTFKn63D4zVyBwKjnuPD291hcIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dBba8o+o5tyKCj/Zy5owmWXkITiPSRYgc4M5pVhzENh9O1C5p1xCvXn12S6Wh3BShx5hjOmqfKNV+x9sECPcWhsiHnRjmYL2N1M7xeonDYgx4bDZla0BRfaO0qQA7ofGUguUhHBMotVyDIznPNjxAregyS03r8pjVaE8WUQ4KAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Bv2Xo9DR; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bv2Xo9DR"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6db2a9da800so37466687b3.0
        for <dm-devel@lists.linux.dev>; Mon, 09 Sep 2024 23:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725949748; x=1726554548; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nEFwTDycDGvgp9HATFRtFGrgCewYQik9kM4B0MY3fOI=;
        b=Bv2Xo9DRMBKQd6hjZObTB0UyFDRJhJ201ZLo9tPQ3e0qQeoXHWZxpEWzhx/vH674Wl
         yJvzqVsQx4Zsrj0+dJ/tgD8LgupkVPKqbRh+yrX+0DiXoXXGcShQdmJVfyOwPwDqwFq/
         OTMwFSKAEBeF+VN3+eA5uITcuGC12DPW6oIkZ8x8Fa547UlVUaAkcq5Pod1OsZWOJQd0
         eERrKNj47EbuDFwVBFTB9RUMToKeswop5uEWZ4WgIR7G99V7t509K6G5cAWB9r34/3JP
         U8LC1i56AiImWt0KkATXDZ3Zijc6EI0/o6q36MOKeRDj51/52aqHPYTgsPXs6j9eXMBU
         afsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725949748; x=1726554548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nEFwTDycDGvgp9HATFRtFGrgCewYQik9kM4B0MY3fOI=;
        b=pMi7S/VQB8r0jCURIaSqApAgCQt9E39R27R8VWWx3MzGsuykht5gdS3RaI97HNI7Jc
         ObXLtuW2eYgW1BuoKtD9LmeC0+b3C3wOaBX8IZ5vrL0wrBF3W4DCHKe5MVY5NEqiOIKx
         7Yq7e4D4AShMfdeeuRDFIJ/jUwXy7yfYZsUmq9sf/ZTvsfknXXyodiu1c/8he0gceRTW
         n/63qHdEYb9iHCMSLuJLWhr2Q/tOENvrJlSils7m8ZAOyn2L8CM6GSQY81ToIfmjDE1B
         b5KigDmUpJuxFyT4z8fWUKoSFqXUdnRctCwPcaTPeIoJjksFQLSkgHL8KzIXfNrsdJ6n
         pV9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVTDQoANSSidqtOWamVLezM47MuH+B9SH1eUwNHqdcsu1HRh7YfEQ2xi0d39NWmQVHGQKKVuOk5Uw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1Vif3bwHBZWlOnZdRHzDe71Y/bMZFderuh52NRK2WLBvsMMxB
	RGPpjn16TasobGN9VJ1n8UmjnpY2kxLxtz1/WfpToibyERKuTJfllX89rco3siX/wD5FOoykaxb
	uXDVyFANiGVs6tf+UWEkIsR0HMur3AQ19ULrjCQ==
X-Google-Smtp-Source: AGHT+IEBZZt2cdxLKZyy+e7siGVV18SEl42Tj+Khn8l0KILxGsWjLsPof0c5bcFrSsgmQWetWJ2qfPyKs0QRrhKeqaY=
X-Received: by 2002:a05:690c:48c8:b0:6ac:3043:168a with SMTP id
 00721157ae682-6db953817a1mr17208177b3.10.1725949748085; Mon, 09 Sep 2024
 23:29:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
 <20240906-wrapped-keys-v6-9-d59e61bc0cb4@linaro.org> <7uoq72bpiqmo2olwpnudpv3gtcowpnd6jrifff34ubmfpijgc6@k6rmnalu5z4o>
 <66953e65-2468-43b8-9ccf-54671613c4ab@linaro.org> <ivibs6qqxhbikaevys3iga7s73xq6dzq3u43gwjri3lozkrblx@jxlmwe5wiq7e>
 <98cc8d71d5d9476297a54774c382030d@quicinc.com>
In-Reply-To: <98cc8d71d5d9476297a54774c382030d@quicinc.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Tue, 10 Sep 2024 09:28:57 +0300
Message-ID: <CAA8EJpp_HY+YmMCRwdteeAHnSHtjuHb=nFar60O_PwLwjk0mNA@mail.gmail.com>
Subject: Re: [PATCH v6 09/17] soc: qcom: ice: add HWKM support to the ICE driver
To: "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Asutosh Das <quic_asutoshd@quicinc.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, 
	"bartosz.golaszewski" <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Sept 2024 at 03:51, Gaurav Kashyap (QUIC)
<quic_gaurkash@quicinc.com> wrote:
>
> Hello Dmitry and Neil
>
> On Monday, September 9, 2024 2:44 AM PDT, Dmitry Baryshkov wrote:
> > On Mon, Sep 09, 2024 at 10:58:30AM GMT, Neil Armstrong wrote:
> > > On 07/09/2024 00:07, Dmitry Baryshkov wrote:
> > > > On Fri, Sep 06, 2024 at 08:07:12PM GMT, Bartosz Golaszewski wrote:
> > > > > From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> > > > >
> > > > > Qualcomm's ICE (Inline Crypto Engine) contains a proprietary key
> > > > > management hardware called Hardware Key Manager (HWKM). Add
> > HWKM
> > > > > support to the ICE driver if it is available on the platform. HWKM
> > > > > primarily provides hardware wrapped key support where the ICE
> > > > > (storage) keys are not available in software and instead protected in
> > hardware.
> > > > >
> > > > > When HWKM software support is not fully available (from
> > > > > Trustzone), there can be a scenario where the ICE hardware
> > > > > supports HWKM, but it cannot be used for wrapped keys. In this
> > > > > case, raw keys have to be used without using the HWKM. We query
> > > > > the TZ at run-time to find out whether wrapped keys support is
> > available.
> > > > >
> > > > > Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> > > > > Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> > > > > Signed-off-by: Bartosz Golaszewski
> > > > > <bartosz.golaszewski@linaro.org>
> > > > > ---
> > > > >   drivers/soc/qcom/ice.c | 152
> > +++++++++++++++++++++++++++++++++++++++++++++++--
> > > > >   include/soc/qcom/ice.h |   1 +
> > > > >   2 files changed, 149 insertions(+), 4 deletions(-)
> > > > >
> > > > >   int qcom_ice_enable(struct qcom_ice *ice)
> > > > >   {
> > > > > + int err;
> > > > > +
> > > > >           qcom_ice_low_power_mode_enable(ice);
> > > > >           qcom_ice_optimization_enable(ice);
> > > > > - return qcom_ice_wait_bist_status(ice);
> > > > > + if (ice->use_hwkm)
> > > > > +         qcom_ice_enable_standard_mode(ice);
> > > > > +
> > > > > + err = qcom_ice_wait_bist_status(ice); if (err)
> > > > > +         return err;
> > > > > +
> > > > > + if (ice->use_hwkm)
> > > > > +         qcom_ice_hwkm_init(ice);
> > > > > +
> > > > > + return err;
> > > > >   }
> > > > >   EXPORT_SYMBOL_GPL(qcom_ice_enable);
> > > > > @@ -150,6 +282,10 @@ int qcom_ice_resume(struct qcom_ice *ice)
> > > > >                   return err;
> > > > >           }
> > > > > + if (ice->use_hwkm) {
> > > > > +         qcom_ice_enable_standard_mode(ice);
> > > > > +         qcom_ice_hwkm_init(ice); }
> > > > >           return qcom_ice_wait_bist_status(ice);
> > > > >   }
> > > > >   EXPORT_SYMBOL_GPL(qcom_ice_resume);
> > > > > @@ -157,6 +293,7 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
> > > > >   int qcom_ice_suspend(struct qcom_ice *ice)
> > > > >   {
> > > > >           clk_disable_unprepare(ice->core_clk);
> > > > > + ice->hwkm_init_complete = false;
> > > > >           return 0;
> > > > >   }
> > > > > @@ -206,6 +343,12 @@ int qcom_ice_evict_key(struct qcom_ice *ice,
> > int slot)
> > > > >   }
> > > > >   EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
> > > > > +bool qcom_ice_hwkm_supported(struct qcom_ice *ice) {  return
> > > > > +ice->use_hwkm; }
> > EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
> > > > > +
> > > > >   static struct qcom_ice *qcom_ice_create(struct device *dev,
> > > > >                                           void __iomem *base)
> > > > >   {
> > > > > @@ -240,6 +383,7 @@ static struct qcom_ice *qcom_ice_create(struct
> > device *dev,
> > > > >                   engine->core_clk = devm_clk_get_enabled(dev, NULL);
> > > > >           if (IS_ERR(engine->core_clk))
> > > > >                   return ERR_CAST(engine->core_clk);
> > > > > + engine->use_hwkm = qcom_scm_has_wrapped_key_support();
> > > >
> > > > This still makes the decision on whether to use HW-wrapped keys on
> > > > behalf of a user. I suppose this is incorrect. The user must be able
> > > > to use raw keys even if HW-wrapped keys are available on the
> > > > platform. One of the examples for such use-cases is if a user
> > > > prefers to be able to recover stored information in case of a device
> > > > failure (such recovery will be impossible if SoC is damaged and HW-
> > wrapped keys are used).
> > >
> > > Isn't that already the case ? the BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
> > size
> > > is here to select HW-wrapped key, otherwise the ol' raw key is passed.
> > > Just look the next patch.
> > >
> > > Or did I miss something ?
> >
> > That's a good question. If use_hwkm is set, ICE gets programmed to use
> > hwkm (see qcom_ice_hwkm_init() call above). I'm not sure if it is expected
> > to work properly if after such a call we pass raw key.
> >
>
> Once ICE has moved to a HWKM mode, the firmware key programming currently does not support raw keys.
> This support is being added for the next Qualcomm chipset in Trustzone to support both at he same time, but that will take another year or two to hit the market.
> Until that time, due to TZ (firmware) limitations , the driver can only support one or the other.
>
> We also cannot keep moving ICE modes, due to the HWKM enablement being a one-time configurable value at boot.

So the init of HWKM should be delayed until the point where the user
tells if HWKM or raw keys should be used.

>
> > >
> > > Neil
> > >
> > > >
> > > > >           if (!qcom_ice_check_supported(engine))
> > > > >                   return ERR_PTR(-EOPNOTSUPP); diff --git
> > > > > a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h index
> > > > > 9dd835dba2a7..1f52e82e3e1c 100644
> > > > > --- a/include/soc/qcom/ice.h
> > > > > +++ b/include/soc/qcom/ice.h
> > > > > @@ -34,5 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
> > > > >                            const struct blk_crypto_key *bkey,
> > > > >                            u8 data_unit_size, int slot);
> > > > >   int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
> > > > > +bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
> > > > >   struct qcom_ice *of_qcom_ice_get(struct device *dev);
> > > > >   #endif /* __QCOM_ICE_H__ */
> > > > >
> > > > > --
> > > > > 2.43.0
> > > > >
> > > >
> > >
> >
> > --
> > With best wishes
> > Dmitry
>
> Regards,
> Gaurav



-- 
With best wishes
Dmitry
