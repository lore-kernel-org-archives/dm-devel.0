Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09C923E320
	for <dm-devel@lists.linux.dev>; Sat, 16 Aug 2025 10:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755339734; cv=none; b=c3CWc/55p8b/exALHr/gO7hb2QvQEaThzobcK3vbT7OUNa9VM39L3zMVKzHllOJsoLJX7PoIGrj8FFHFwPmr4iZRfguz+y+Zg+dIXnGnemSKwFlG2O1+Rii7c/iZLl6su0SBl+F382nFgwSxSNe0Gcjfz0I8I3AWlHasmYcKy7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755339734; c=relaxed/simple;
	bh=pMMqetDiJV89bb9e+B6qQoj1CJY35oI2SphyHEQF8zE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vg6RfSaRmgTBNFHdMah4Toa2M2xKGJBUaI6olYSe5IQDLzGPPobcnDLEoPe3RMUWh3NvPfxHjTMwekbe6SLficJfbm7Jr9jUTGhY7I4yEwHiHbEh73Uo4mjiOYuH0HLxeDfg08p60h6L7vIOdwxx8U8u9rAhNw4hpZZRePQ370I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGYGgOi+; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGYGgOi+"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b9dc5853c8so44302f8f.1
        for <dm-devel@lists.linux.dev>; Sat, 16 Aug 2025 03:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755339731; x=1755944531; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdwD99ZR7r46KZpYwdpxOzAmGPs4N7qtbLZMrAnF8T0=;
        b=LGYGgOi+HPz6cXBucwJWBRQAONlGEGKELwlCoKdwCFBBQS1enr452Oui4bUZsZAAIU
         F8MqwyHdr3z+cD8xV5u6x8MiAxCdExRMHIpMXirrcieITztelrOfiMTylsswgqWSbnP3
         4l3vtfijEALSkzsMQacKXPpKnniIS1V5yFugte1kqRo3dYBXC/VobkSJRegHWQ51FeVk
         Vw+eIxNQCKWBOkApyoUyh0052aGTM29AU6hDAdjOCP5ibvHtbHsftnreZ5smHNsDh+LP
         UoVwLBFEtKUm9yHvIcK3X4x2RrMPxYn5PyKogl+jLBtLqIOXLXlf7f9xbQVmNJU52ZpR
         Eq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755339731; x=1755944531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdwD99ZR7r46KZpYwdpxOzAmGPs4N7qtbLZMrAnF8T0=;
        b=DGpFSRWBJbH/a3Py9eS+Jy8w1S+8sB5VLFyzMDl4w6fFxBev1NhqPd09HCYlIYNumY
         MtL+idpX7KzyVvCg2PJJTqw2i5aPrzFvhWMb+EhB82UusuJ6/yWoX8MxZajm1nbt6cKk
         YQwGfwBCEd2x1UWHQBVlx9aI06bonk786H0HO9I+LjmCAKFpmc8ZLHfuG3icK2IeO4mh
         rUtqoc70D8gn+Mh4DXEy1nid8U2vuZZqeNWtq5WonwFWNA4b9+T2t2J/ChbwiJzaaXX4
         nwgfmYxQcnMWCg/uEfaI86NaX8D12JqV3ZXCEnuOfwq1KN2A5iIh5xtPkJyRT1VtYuyV
         lMQw==
X-Forwarded-Encrypted: i=1; AJvYcCWWW/NP5FeMOPKKNa9NHoY9uD6L+RFTSuNNx7Nv4ZNkJXoORQK0xxoCc2Z0mPb6aU7VDxmPnyYeRA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwZNrM+Pa5YXTjVaTNa9FBwnftD13TyWfwoTUundqAwZtQiq3kN
	9O3LD8bFsPAz1VuQEvr3VSmdIp5QpnY0f81K6nKUbkQsXREoyaqOHXk=
X-Gm-Gg: ASbGncsl8oIAZqtVCTPy792qMSPckN4exEwonpdPIdiSSqLEexnICbWdsS5SFIVo536
	rotStUaepofodemmU1arcz+gAUA3n7actNSpB/f1OrqtGni4oqcb3YZl+3ozSs78WFbAON6rqWs
	/40BS93cAfeEJVIaR/95iUVV6FVN2wx/Le4WP5b/2FgbYKj9ueB434hsJp0h3X0PulMD+MSeq8v
	qUvTtJ7Cl7wKe36I4x5jWU13C0hJUSosf2YGEo1EIpRZ7sS5X/4B0xJryNfHE58M7Jd0xrm0D1L
	i/C05/2uttGqmkwRSWhGHdFQHVMYhG3Ip9xk70Ew1H/Ze1mDF4D7pOz69LBMY1gTIQHTe8XVuuG
	gDTcPVhAVcawJQYqxoK5ecu+n3MDkyoWQKia0EpE2bxh0JPL0NseGDS/RcsyY
X-Google-Smtp-Source: AGHT+IGO1zvnPQWlgG64IIWUQsGj3G0nmPRwCvhJHL7TbyFdaLKKSN4GYpSaEkJBOifboojbIqqiEw==
X-Received: by 2002:a05:6000:18a3:b0:3b7:8f9a:2e2c with SMTP id ffacd0b85a97d-3bb673e5cfbmr1915742f8f.6.1755339730654;
        Sat, 16 Aug 2025 03:22:10 -0700 (PDT)
Received: from localhost (67.red-80-39-24.staticip.rima-tde.net. [80.39.24.67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb68079d3fsm5414593f8f.55.2025.08.16.03.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Aug 2025 03:22:10 -0700 (PDT)
Message-ID: <6c8078a2-4f59-4cc0-9548-eee37f4b0e40@gmail.com>
Date: Sat, 16 Aug 2025 12:22:09 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] multipath-tools: replace round-robin path selector with
 the default for NFINIDAT/InfiniBox
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20250509134459.226640-1-xose.vazquez@gmail.com>
 <085c156c31fcd2fc5da4e889642bd6186c677a7c.camel@suse.com>
 <01c09aff033bdc1ba06c7a3265c1a1a477be1a04.camel@suse.com>
 <aCIr3r6KqyumN4Pt@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <aCIr3r6KqyumN4Pt@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/12/25 7:11 PM, Benjamin Marzinski wrote:

> On Fri, May 09, 2025 at 04:22:40PM +0200, Martin Wilck wrote:
>> On Fri, 2025-05-09 at 16:08 +0200, Martin Wilck wrote:
>>>
>>> This code is from 55da608 ("libmultipath: update INFINIDAT builtin
>>> config"), signed-off by arnony@infinidat.com. We usually don't change
>>> defaults from explicit vendor recommendations without consent from
>>> the
>>> vendor. I've added Arnon to cc, maybe he wants to comment on your
>>> suggestion.
>>
>> Arnon's email address bounces. Unless we find someone else from
>> Infinidat to comment, I think we should keep the current default. Users
>> are free to override the defaults if the aren't happy with the
>> performance.
> 
> I agree. This device config was set to round-robin after we switched the
> default to service-time, so I think it's reasonable to assume that this
> was intentional. Barring an email or updated documentation from
> INFINIDAT that shows it's no longer the recommended config, I feel like
> we should leave it as is.

At Infinidat support site(user required), there are new configs for SLES 15 and RHEL 8, or above:
https://lh3.googleusercontent.com/pw/AP1GczPhlOIUXYWsuCYQJ42ORS_77xnwTmlN02ZkDU4__6jAvQ_6bBLvvcFsQ9luhSMcB887pXZOaVCrCNZUITTl8eEztD7l568BTSNHL2cB9Dh2SfAAXye7K9Tu8nkjCKMkhQM4H7LRiY4Rp0ygQqCrMmM=w0-h0
https://lh3.googleusercontent.com/pw/AP1GczMchJ6bcMIohp_g3Ik5DS6BZv_IW0iwaEXf968sJsR8fr_p3mR4ThRpmHpZE_VMnlcV8j0uuuI2kz-eoqekRCUBxyTBKS7n-4WFMsUiecq8i7nIjEuhfZFrV54DBQLDzGt6ofakAAF1L-ZcAuCWW18=w0-h0

device {
    vendor "NFINIDAT"
    product "InfiniBox"
    path_grouping_policy "group_by_prio"
    path_checker "tur"
    features 0
    hardware_handler "1 alua"
    prio "alua"
    rr_weight "priorities"
    no_path_retry "queue"
    rr_min_io 1
    rr_min_io_rq 1
    flush_on_last_del "yes"
    fast_io_fail_tmo 15
    dev_loss_tmo "infinity"
    path_selector "service-time 0"
    failback "immediate"
    detect_prio "no"
    user_friendly_names "no"
   }

I will send a new patch.
