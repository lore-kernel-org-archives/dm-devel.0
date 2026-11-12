Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522299;
	b=HhS2PPdsWB5KiASwpuXH4JmFh/Ck9vf0Ov7jOnGYXB7aGOSw9DdnLzcoEyArK2pmYFCC
	 Ycx4NR1gzNYzTnDRz+2d3tIM1K4+U5mObF7q7/ZFDeuWoP+cX6Oe9n77s9U6bJjkQATTf
	 xO1FfPbZyl2OG3gnnH6cNIPNWWp0dohYzf8CGJeTkW9fotYaPEBhKXRWREQy6Ae6aRcmh
	 In1ZGHza/hpPfrPGDBuFCKu7uBu1yNBJojCkIKjoxywL+JMMts2inpzKfyKBJBd4yrCD7
	 JSCmdt5MXrGUPhiziDeBBrUktd4plgxIRYp8WXBnhXdROBd3KVhExjPucdeWffaA/tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522299;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Subject:To:Cc:In-Reply-To:References:Date:
	 Message-Id:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=VgGDPyv9WyT3dI00oZf5vvw5dl9W/ILwa8Xh18WRJ0M=;
	b=fvCE9Ms2wF6bBeG4XblHYbngLWc04+3NE3Rwa0ZrF7A+9xMhWEy5oRg+VfVnOkDCZTrj
	 ikOde4O8kLC3mCbRGlWDlDC7Y2CM2PvsYKr3ffeH+l7omChqtpEtY0fhVt0r97Y8CBgG0
	 XD1SUFfthx/eObtTw0wCCapo4RRybZDVTHARmk6AwdG8bKyl5NocNeQHQvJgBDaPaJtEs
	 UNN3W04721mA4khzOSMSP7y3LtbdpU4U0AEek3Trrecm32/uIPJbzyKBBoka07IbT9oUo
	 M/X4yPytEJKaS0WoIyx0Z5jqPvG516iX3HiF4ITrBzzvGHqDdAOfBZPVBNWURzkDGDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=T626OotL;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132D4606A31C
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 22:24:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 132D4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=T626OotL
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so331380f8f.0
        for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 14:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794522297; x=1795127097; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VgGDPyv9WyT3dI00oZf5vvw5dl9W/ILwa8Xh18WRJ0M=;
        b=T626OotLmX7/6hn/xF/iXoeK8pSeXUZhD75FknUcxB9Xfve/u5QR4icel44uGN2NGB
         prPuMM5KTG0DiO+IL9v5IH8eXUJBuAmF59v84Yt2PF8rNGL+xYDTeKmiBlFFGDDH6cDo
         HWZ7MWzF+ndlmBMYVcGdo1QVxsWL5YiL6/8dRXYPovzYpvqsbV3zJgZyBTPvnMzp6ULg
         5RFKX29qHCHq3ZgqJr1i+M+jB9Rq/EIGiH8qmHKZFEWNBI6HsU5EfwK4xzgqyAm5Qxk2
         h4te9MzldlmEibOwL57tED9psoS+ziB3zWRtAIN6RaJ26wynPf1YJxpoQoigsDHxFdaX
         S+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794522297; x=1795127097;
        h=message-id:date:references:in-reply-to:cc:to:subject
         :content-transfer-encoding:content-type:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VgGDPyv9WyT3dI00oZf5vvw5dl9W/ILwa8Xh18WRJ0M=;
        b=0NIeuvwBoonkVtIBDl+SLtdfjcBT+VzI0/ccZpAaSvZSnCUSoARZ9qM6Dm/Vy+93Qr
         rWB3QRowxgj5MsKaOyWjOdeCrBOq7t5s26lGLQ1RILV+2mojIoMxrQpCjWDZbi8U9Lih
         2ndli8+/JkYIFbbMgAJVIZCpRK5CgrRT94LhlyEQyZBVu+VdLJ7IKbGUvyd0eCnYWkhI
         D+s3Hg6sllpke+REvHx6y24CCIIku+hvHQo8V1jgdMcbtvbATm0fpi2qy5iz/ZldeFrl
         frJq4cq5I94OVRkBauoTG+D20zP2XFy1eNUvdGXshTgNx/UDhWlO+dIzeb0zCi1IHrjw
         HToQ==
X-Forwarded-Encrypted: i=1; AL+hErE9lWCoGy4BlQV59FCXzdVQJy4I46mdrPtduBwoSlbtp1woD97QlZEOqKDfH4REfTere7czO1d5Jw==@lists.linux.dev
X-Gm-Message-State: APuU4Z+ujQeMSlxenoAVqqxzKLYli8vdWIKNWhnPqT9xcgSEo2DuyfaZ
	XA+RZDVqkPh9QwsrrFRfQCpp8jf87GacGJV63tmEzO9T9+emAzoOhk/ZyBZEYrvgMrzrH0z5WbR
	gHXktm5U=
X-Gm-Gg: AYBFou3trk7MTeQF231Q+j0APp3VrUkm2zsMMzhkok6YomJdR+aAR1W1tLGX8ULQDCm
	NlcfX+MRYpfn3ZOgIw6OD2ESyDyjiADCJDYCL6vbit8KVi5Mp3jV84edFjgPjWTONkioDuP1WSv
	+DFw29y50nnuBGZNXejJ0Lio63oi96cpd+Essj/0ZUmuQkoDOnPY65lVyfWDiCil32h0ZZ9FK33
	bmMLAVoYngLV8gxlgOPIOeJgpan2HPkAdl7DO7pHPpe/sE6wJbcrEH2q39l3SnGVcnuWLWohcsX
	7b8tt1oDqVPyGBJ8fa9JIo+s6a5HAX4Vu5MWIVejj0vn/AtNonV5MHRkWYrcn5nWp1XpOnbaW8i
	CEuSSXkV/ELP+/JLt87/CQvzSB9kdiiRJwr7NkRrsgeH1+VKv3FH5vbvLC+peJgHRppET5U++aX
	n3TfeyydV+4wdTZ7WgqVhkerCVVaPhFaeTA7i72eGM5GFvHKcoY/yGp6rrt1mvZMuSwruzA/lVJ
	hqR3eEMbnptLKFAAGEW0NzmqH5sxAbEkVyv1nvUSGoHi65OROayI/N0fCA/nBYLvjIrXJouYUAj
	5PPQ2wFNeR7iXdwA+JzfpayPvrM7nQp/gr4vbyA4XporFwDlkIsgiiz2h8iGJ0A2AO2Hf2sLRLW
	uai6OHjb+t937K/v/3g==
X-Received: by 2002:a5d:64c9:0:b0:48f:bed6:4d79 with SMTP id ffacd0b85a97d-49c72f7b71amr1710175f8f.48.1794522297291;
        Thu, 12 Nov 2026 14:24:57 -0800 (PST)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-49c60bb2a5dsm1438281f8f.50.2026.11.12.14.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 14:24:56 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/1] multipathd: recheck WWIDs of re-added paths
 with the device
To: Brian Bunker <brian@purestorage.com>
Cc: Martin Wilck <mwilck@suse.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, 
 Christophe Varoqui <christophe.varoqui@opensvc.com>, 
 dm-devel@lists.linux.dev
In-Reply-To: <20261111181642.51912-2-brian@purestorage.com>
References: <20261111181642.51912-1-brian@purestorage.com>
 <20261111181642.51912-2-brian@purestorage.com>
Date: Thu, 12 Nov 2026 23:24:32 +0100
Message-Id: <179452227264.147392.9708937185980533136.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7394; i=mwilck@suse.com;
 h=from:subject:message-id; bh=0T4H+IZvbqYQsF2rgCNLI9/8RiJeETtROwuLQaV51Bg=;
 b=owEBCQL2/ZANAwAIAaFOxj0gAPzbAcsmYgBq9jysiLJMjzYFxDnt+MpEkdbey40fIguiFKL2c
 26lBbG++a+JAc8EAAEIADkWIQT9/H021zOM2230IgahTsY9IAD82wUCavY8rBsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQoU7GPSAA/NuEswv+Mn/A5/cOl/v0M8ypqYEbFeDo+CWJQbw
 DYR2zYY+V878C34b3wWtRxHAmUmFASeKvkR2FeRMtZ3hW1kAjD2uiNWpA3DSN8gDWxhaSMPtOuq
 eLYUV3gxjyn+OdcNKil4V5zecY1buEQGoAYl2SYJZ+z2t241k6x4V91o4QQUwjiNIaJ7EzEdgnH
 8vsUm8s8U8KyOU7Kg3ZL18SUV6l7dMFfQZMcwA5kDEvrfCAHHRGLmBJ9EoK0JEQzhH12ysRK8kD
 zKHzYx6dNuOQo5xkp9KbJDjF+wG1BiAtQf7kpxHzt89nRoGGjUdLPUifQXhnqxYCSNuebGIn2vo
 GyCzmTFyT3KcfW5AtEbkn7NE9Q71jNGmaWIAj8UpJaQLc/dk7szJ7+tp+PY5Lyzc3LaOitAtHtF
 Z9TmwfUwHgNl6OwwELR/eg4B2Q9bAn6K2zV5SY4htlDbbyINmzmAYfTIHvpyuo4KPl33g6872Q1
 CukELRKmpBAP7BdkgSUlsfxxsytUyMj
X-Developer-Key: i=mwilck@suse.com; a=openpgp;
 fpr=750EAD4B2EDEB1A545D4F5F467C586E685569754

> multipathd takes a path's WWID from udev. When a change uevent reports
> a different WWID, uev_update_path() removes the path from its map and
> re-adds it through uev_add_path(), which places it in whatever map owns
> the new WWID. The removal can block for seconds while the map is
> suspended, so by the time the path is re-added, the WWID in the uevent
> may no longer be what the device reports. If it is wrong, the path goes
> into the map of a different LUN and I/O for one LUN is silently sent to
> another.
> 
> If recheck_wwid is set, confirm the WWID with the device over SG_IO
> before such a re-add puts the path into a map, as recheck_wwid already
> does when a failed path comes back. If the device doesn't confirm it,
> leave the path out of the map: orphan it, clear its WWID and mark it
> INIT_MISSING_UDEV, so the checker retriggers udev and the path is
> re-added from fresh data.
> 
> To tell re-adds from ordinary adds, turn the need_do_map argument of
> uev_add_path() and ev_add_path() into enum path_add_mode, with a new
> PATH_ADD_REINIT value that behaves like PATH_ADD_MAP and is passed only
> for the re-add at the end of uev_update_path(). Ordinary adds are
> unchanged.
> 
> Document the new case under recheck_wwid in multipath.conf(5).

As Ben pointed out in his previous email:


It may make sense to convert the "recheck_wwid" option from a boolean
to a multi-value option, to make it possible to choose between the old
and new behavior.

@Ben, what do you think?

> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>

I still have some more comments, see below.
(In case you wonder: I used AI to assist with this review).

> diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> index a577dfc..8f35880 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -1382,9 +1382,11 @@ The default is: \fB\(dqNONE\(dq\fR
>  If set to \fIyes\fR, when a failed path is restored, its wwid is rechecked. If
>  the wwid has changed, the path is removed from the current multipath device,
>  and re-added as a new path. Multipathd will also recheck a path's wwid if it is
> -manually re-added. This option only works for SCSI devices that are configured
> -to use the default uid_attribute, \fIID_SERIAL\fR, or sysfs for getting their
> -wwid.
> +manually re-added, and before re-adding a path whose wwid udev reported as
> +changed. If the device doesn't confirm the new wwid, the path is left out of
> +the multipath device and udev is asked to report its wwid again. This option
> +only works for SCSI devices that are configured to use the default
> +uid_attribute, \fIID_SERIAL\fR, or sysfs for getting their wwid.
>  .RS
>  .TP
>  The default is: \fBno\fR
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index f5a13c4..9b4a04c 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -673,7 +673,7 @@ cli_add_path (void *v, struct strbuf *reply, void *data)
>  			return 1;
>  		}
>  	}
> -	return ev_add_path(pp, vecs, 1);
> +	return ev_add_path(pp, vecs, PATH_ADD_MAP);
>  blacklisted:
>  	append_strbuf_str(reply, "blacklisted\n");
>  	condlog(2, "%s: path blacklisted", param);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9bce4d6..fdf5503 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1128,7 +1128,7 @@ check_path_wwid_change(struct path *pp)
>  static int uev_update_path (struct uevent *uev, struct vectors * vecs);
>  
>  static int
> -uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
> +uev_add_path(struct uevent *uev, struct vectors *vecs, enum path_add_mode mode)
>  {
>  	struct path *pp;
>  	int ret = 0, i;
> @@ -1180,7 +1180,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
>  				     DI_ALL | DI_BLACKLIST);
>  			pthread_cleanup_pop(1);
>  			if (r == PATHINFO_OK && !prev_mpp)
> -				ret = ev_add_path(pp, vecs, need_do_map);
> +				ret = ev_add_path(pp, vecs, mode);
>  			else if (r == PATHINFO_OK &&
>  				 !strncmp(pp->wwid, prev_mpp->wwid, WWID_SIZE)) {
>  				/*
> @@ -1255,7 +1255,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
>  		conf = get_multipath_config();
>  		pp->checkint = conf->checkint;
>  		put_multipath_config(conf);
> -		ret = ev_add_path(pp, vecs, need_do_map);
> +		ret = ev_add_path(pp, vecs, mode);
>  	} else {
>  		condlog(0, "%s: failed to store path info, "
>  			"dropping event",
> @@ -1297,8 +1297,7 @@ sysfs_get_ro (struct path *pp)
>   * 0: added
>   * 1: error
>   */
> -int
> -ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
> +int ev_add_path(struct path *pp, struct vectors *vecs, enum path_add_mode mode)
>  {
>  	struct multipath * mpp;
>  	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
> @@ -1315,6 +1314,22 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
>  		condlog(0, "%s: failed to get path uid", pp->dev);
>  		goto fail; /* leave path added to pathvec */
>  	}
> +	/*
> +	 * This path is being re-added because its udev data was missing or
> +	 * changed. The uevent may have been queued long before we got here,
> +	 * and adding a path to the map of a different LUN corrupts data. If
> +	 * recheck_wwid is set, confirm the WWID with the device first. On a
> +	 * mismatch, leave the path out and let the checker retrigger udev
> +	 * to get a fresh WWID.
> +	 */
> +	if (mode == PATH_ADD_REINIT && pp->recheck_wwid == RECHECK_WWID_ON &&
> +	    check_path_wwid_change(pp)) {

check_path_wwid_change() returns false when it fails, is it correct to keep the
path in that case? IMHO we should treat this like the strlen(pp->wwid) == 0 case
above.

> +		condlog(0, "%s: not adding path, wwid '%s' not confirmed by device",
> +			pp->dev, pp->wwid);

check_path_wwid_change() already logs at verbosity 0.
2 or even 3 should be enough here.

> +		memset(pp->wwid, 0, WWID_SIZE);
> +		pp->initialized = INIT_MISSING_UDEV;
> +		goto fail;

In pathinfo(), we also set pp->tick = conf->retrigger_delay. Is there a reason we
don't do it here?

But more generally: as this indicates a possible mismatch between kernel and device
state, should we handle this similar to  handle_path_wwid_change() instead,
i.e. also call rescan_path()? I guess that would need to be done in uev_update_path(),
i.e. it would touch the regular "wwid changed in uevent" path.

> +	}
>  	mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
>  	if (mpp && pp->size && mpp->size != pp->size) {
>  		condlog(0, "%s: failed to add new path %s, device size mismatch", mpp->alias, pp->dev);
> @@ -1375,7 +1390,7 @@ rescan:
>  	if (ro == 1)
>  		mpp->force_readonly = 1;
>  
> -	if (!need_do_map)
> +	if (mode == PATH_ADD_NO_MAP)
>  		return 0;
>  
>  	if (!dm_map_present(mpp->alias)) {
> @@ -1789,7 +1804,7 @@ out:
>  	}
>  	/* pp->initialized must not be INIT_PARTIAL if needs_reinit is set */
>  	if (needs_reinit)
> -		retval = uev_add_path(uev, vecs, 1);
> +		retval = uev_add_path(uev, vecs, PATH_ADD_REINIT);

Is it correct to take this branch also if needs_reinit is set because
INIT_REQUESTED_UDEV was set? I don't think so.

-- 
Martin Wilck <mwilck@suse.com>
