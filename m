Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D3437B400
	for <dm-devel@lists.linux.dev>; Wed, 29 Apr 2026 15:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476313; cv=none; b=MapmmNymDkkdoZAI40qYhgOvIlfeDV67p0wXo2EzQIJdy3r4MVu8cd1fVtoqTdQsCicivkIkvgUYFyOzRRBO7NjKn8jI9nA7ActTKYp3qdthnKg+5ioPWbS0ZM9D2LUWt7RoAfwVwaqOqNR1VC+p71CD5KgvozfMv1JrnH01JtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476313; c=relaxed/simple;
	bh=JvxfV5QjKQbwm7+BOekQVOayYxapWdUNFPLNqt75HHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=PWpp/1yLk5ZGFXDSZ7za583ST+1F9yM59UBMxG+KxUDE5NeYhRx6hJ2H9yM2YEttbe7InHlz2y6qHZIdxPsAbAxjKADCgwWj/yywxuWxUqG4FLjJa6re4P2/Ub5c/tArtU36VLb4RfooOrHuL/cGiWgVH+h4VvcDhCrab5CAsGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dT1NP/sx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dT1NP/sx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777476311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EMT0J2vcJAfTCz/tlata9hzsUiHyRA7lCZ4HpBR0qWg=;
	b=dT1NP/sxT3VGPWsydoGKGl7vNbc0Jdly5UqednVXraLvgIsDXCA+Q95OhvwspK/4idjtBy
	LuvZkx0A6mXOi7u53nldcbQpPQnfUKTXTuWUhncSyiCX8KUhNifCC+bZ2heyuvget2cYRZ
	ApjP16uM34DTe6WEn++8+sMHNBf70Hg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-MwTeSaaBP3KyBOulTq63rQ-1; Wed,
 29 Apr 2026 11:25:09 -0400
X-MC-Unique: MwTeSaaBP3KyBOulTq63rQ-1
X-Mimecast-MFC-AGG-ID: MwTeSaaBP3KyBOulTq63rQ_1777476307
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEE2B1800350;
	Wed, 29 Apr 2026 15:25:06 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F110B300019F;
	Wed, 29 Apr 2026 15:25:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63TFP4Zs2813142
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 29 Apr 2026 11:25:04 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63TFP24c2813132;
	Wed, 29 Apr 2026 11:25:02 -0400
Date: Wed, 29 Apr 2026 11:25:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, linux-kernel@vger.kernel.org,
        adrianvovk@gmail.com, dm-devel@lists.linux.dev,
        quic_mdalam@quicinc.com, israelr@nvidia.com, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v2 2/3] dm-inlinecrypt: add target for inline block
 device encryption
Message-ID: <afIizQA9kVR_u_2j@redhat.com>
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
 <20260410134031.2880675-3-linlin.zhang@oss.qualcomm.com>
 <ae7yzw-5wz9cqZt8@redhat.com>
 <ae_vacHQ75AgZbm_@redhat.com>
 <6390db35-7f8e-4d00-9c1f-43d676007910@oss.qualcomm.com>
 <afDh8XRWW_JgaUP3@redhat.com>
 <7ab5cd97-30b7-42ca-80ce-6d9cd8c45b73@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7ab5cd97-30b7-42ca-80ce-6d9cd8c45b73@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: cnpO3RKhNSjtKC4UTYVW49GVJSQYKkefkLMiVeE-JCU_1777476307
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Apr 29, 2026 at 08:34:00PM +0800, Linlin Zhang wrote:
> 
> 
> On 4/29/2026 12:36 AM, Benjamin Marzinski wrote:
> > On Tue, Apr 28, 2026 at 05:20:07PM +0800, Linlin Zhang wrote:
> >>
> >>
> >> On 4/28/2026 7:21 AM, Benjamin Marzinski wrote:
> >>> On Mon, Apr 27, 2026 at 01:23:27AM -0400, Benjamin Marzinski wrote:
> >>>> On Fri, Apr 10, 2026 at 06:40:30AM -0700, Linlin Zhang wrote:
> >>>>> From: Eric Biggers <ebiggers@google.com>
> >>>>> +	/*
> >>>>> +	 * Since we've added an encryption context to the bio and
> >>>>> +	 * blk-crypto-fallback may be needed to process it, it's necessary to
> >>>>> +	 * use the fallback-aware bio submission code rather than
> >>>>> +	 * unconditionally returning DM_MAPIO_REMAPPED.
> >>>>> +	 *
> >>>>> +	 * To get the correct accounting for a dm target in the case where
> >>>>> +	 * __blk_crypto_submit_bio() doesn't take ownership of the bio (returns
> >>>>> +	 * true), call __blk_crypto_submit_bio() directly and return
> >>>>> +	 * DM_MAPIO_REMAPPED in that case, rather than relying on
> >>>>> +	 * blk_crypto_submit_bio() which calls submit_bio() in that case.
> >>>>> +	 */
> >>>>> +	if (__blk_crypto_submit_bio(bio))
> >>>>
> >>>> This will still double account for fallback writes (which call
> >>>> submit_bio() on the encrypted bios, and return DM_MAPIO_SUBMITTED here). 
> >>>
> >>> Just to clarify, I'm talking about the vmstats accounting. The IO
> >>> originally gets accounted by submit_bio() when the bio is submitted to
> >>> the dm device. For actual inline encryption and fallback reads, dm will
> >>> submit the bio to the underlying device using submit_bio_noacct() to
> >>> avoid double-counting the IO.
> >>>
> >>> For fallback writes, __blk_crypto_submit_bio() will submit the encrypted
> >>> bios to the underlying device with submit_bio(). This adds the IO
> >>> sectors again, even though it's the same IO, only encrypted now.
> >>
> >>
> >> Right, thanks for calling this out.
> >>
> >> For fallback writes, the IO is still double-counted. Given that this only
> >> affects IO accounting in the blk-crypto fallback write slow-path and not
> >> correctness, I think this is an acceptable tradeoff, and we can leave a
> >> TODO to revisit the accounting once a better solution exists.
> >>
> >> Add the bellow to the annotate.
> >>
> >>   /*
> >>    * TODO: blk-crypto fallback write slow-path currently double-accounts
> >>    * IO in vmstat, as encrypted bios are submitted via submit_bio().
> >>    * This does not affect data correctness. Consider fixing this if
> >>    * a cleaner accounting model for derived bios is introduced.
> >>    */
> >>
> >> Do you agree?
> > 
> > You could add an extra argument, for instance "bool need_acct", to
> > __blk_crypto_submit_bio(), and plumb it through to
> > __blk_crypto_fallback_encrypt_bio(), where it could be used to choose
> > between calling submit_bio() and and submit_bio_noacct().
> > 
> > We could even add a flag to cloned bios for stacked devices, that could
> > be checked in submit_bio(), so we didn't need to have
> > submit_bio_noacct(). But this is a pretty niche case with other
> > solutions, so I'm not sure if it warrants adding more checks to
> > submit_bio().
> > 
> > I do agree that people probably aren't using dm-inlinecrypt for devices
> > where they don't actually have inline encryption capabilities, so it's
> > not a major issue. What to you think, Mikulas?
> 
> Thanks for the suggestions.
> 
> Adding a bool need_acct parameter to __blk_crypto_submit_bio() would require
> updating all existing callers, which feels rather intrusive given that the
> accounting issue only affects the blk‑crypto fallback write slow‑path. I’m a
> bit concerned that this would broaden the scope of the change more than
> necessary for the problem at hand.

I get your concern, and I'd like a second opinion on how much we should
care about this, but it doesn't look like there are many other callers
that would be effected here. The only existing caller of
__blk_crypto_submit_bio() is blk_crypto_submit_bio(), which would just
call it with "need_acct=true". Looking at the code path below
__blk_crypto_submit_bio() that would need to change for submitting the
bios:

__blk_crypto_submit_bio() is the only caller of
blk_crypto_fallback_bio_prep()

blk_crypto_fallback_bio_prep() is the only caller of
blk_crypto_fallback_encrypt_bio().

blk_crypto_fallback_encrypt_bio() is the only caller of
__blk_crypto_fallback_encrypt_bio(), which is the function that would
need to choose between submit_bio() and submit_bio_noacct().

Doing this would change the crypto API (by necessity, since we're adding
a new argument to __blk_crypto_submit_bio() for stacking devices to
use), and it is adds a extra argument to a number of functions, just to
handle this corner case. But it is still a relatively contained change.

-Ben 

