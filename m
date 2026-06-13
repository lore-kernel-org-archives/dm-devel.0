Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD98040D589
	for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 12:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781352602; cv=none; b=A3O9vFsry+oKR0Hn9dkhaWqP3upzU/OqWblHUakTG1wfIk9XtInHl/87Itof5AC6rZ+ESbi+1lgQz+jFFfIfL12hqW/5Acio3kuwfjauwNKTaPtb6nxlOCOcf6lMCgk4r14vZ2Sv8xvmUbqFHOu7I649xrFm8RKhw59lqwbnLx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781352602; c=relaxed/simple;
	bh=KQ5W3ouJfWlzPqV2kmZYj+n86hzDzhp4iaR82BsYwGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GFyfMrM33uyYvnxqRdoOd+t8t0gk/6zA46NQyYPjuRqbRea2gUdfI8P8KFeggPwJuihMyHo4Shz3E2qDbJVKdW4pz3gYaMWfmMiOJKv1cdCp//Krjns7bIZ3nU9daQW6diEYXipi3mIta9kElkWgi7Je98U319qKayan+fcOX2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qhks7r3j; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qhks7r3j"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b8adf813so2388315e9.1
        for <dm-devel@lists.linux.dev>; Sat, 13 Jun 2026 05:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781352599; x=1781957399; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alNV2RRc878JtCohPIPQj3aM33yIJ3ezX1tJ3gF5x7Y=;
        b=qhks7r3jiwbeRGMyAUR3TWigLbTqqGx25LkkvBktx7nL/OvtZ3mToeSvJnK/GuOwk+
         2s8/x8vaPwXdGx/WMlkT4SGYFAFQVo7vB8/07+V/jZOqIJiE6sYlfy/VkemhZU9xwFtO
         NKphlyru2M/1l4doe1B6OylyqmqFQjwjiakbFkWdmsUaNGtGeg7BVsJ7gV4yBzKUTg6b
         nKvjP3rpbshDpezyN0Vv6nPcsCZYKWEK6m7V+bWh9b7tZ/8v2RX1fFYFnjQD7O2GD2/U
         o+qzZg1d9cFS3vqZfPKhwcF0IcVJyKmuJ6XkbLHtaOM+iSm8mP5v15FhoE9cvsoPz0gi
         iAlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781352599; x=1781957399;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=alNV2RRc878JtCohPIPQj3aM33yIJ3ezX1tJ3gF5x7Y=;
        b=jVbjDlD0HFj8pQNBbGJvgRwkoq45UON7c0AJPVriD8ej7m2nbUcqmZ2xcZ2kxwlp6/
         vgrSca4iW7sLAjpd7u0n68rM3pdlxrfSNQ2TJViVkj+0UbKUjNu9ihl/LDlrlXvFwy9+
         f8gOi/cLz1Zbnw1hW5i3MgwLvsO5+KNwMK+zQaG5eQJfho8bfL279U/as7nT4kzV7wwo
         24z8BSrjVEN0LEZg9cMqRV8gLTRfHbl0J+hsf2Do5xBcJSCnlUjz/H9bphmpgK6EWHhJ
         nIpM01mvCh6Rf+EY/aM6H7JyBrGbUkO0PlLcLrO0KJT1Z3ibaPn6voy5bOl+HjSJiaK8
         MveA==
X-Forwarded-Encrypted: i=1; AFNElJ9Rb+mKJdR4g3OP9GsFyzvE4NlyEKfEHmhEoRqRYJavRUigIsROrri5CEVfF6JIm9kZP/HzS7GodQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7rHOEPJmrLMnm4W3QoFEK1bECAley+UniFB3TvCqplIUZ5nPx
	+5OHs3+8jjTY1gLOXz797UFvQa5cJFbHVbOtxTk4lSj8+dVurr8LVx4=
X-Gm-Gg: Acq92OHTh9mfuOBvsvhcZvTImXcwLP0hYEK5atnLLn7k3qcEsO/6cv/7CrbYGOvPDF+
	4svwboWWHDUj1oGcHOgPZKJFOOaM2uAPbtkZN81VwFZBpARy9ojo2ihsOzifiyq7gLu+XZkq71Q
	LIENP+bNNj480SfaiacXi/oVWo9yykK+wmQTliGEt/j+lMwr1js2KN9MsTkbXb8QpM78X9I55n3
	5gOIiDnUGWPGVcOBeF82SV/vGQprci4zkZupwB3eUjf/QGCKLqG3ONCR1d/uAQymbv6LRFpe5tH
	oH+0yjqRiZPSRC9bfiY+YMXoPN/N94GdH3iA8zWvTDH1yyiWtE5kqfzO14djlgKCH2FdvrytQqS
	9iH9PTsYHKZK6CEP9TGlVJjpAiDD8rKK6VO58RyKFJb2d0JaJyYKpL8URp5Ueqwn12ngJm5iCIH
	CW8TAQvuEtzrBC7jPuDBSZkeKII0kkEtQIdoMFgI25VG4r+NJTMMtDn/kBpbKC32pm/ot/r/2hC
	ns=
X-Received: by 2002:a05:600c:a21a:b0:490:b71f:2de with SMTP id 5b1f17b1804b1-490ec4fe4e3mr22422145e9.5.1781352599130;
        Sat, 13 Jun 2026 05:09:59 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea95b274sm156122375e9.1.2026.06.13.05.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jun 2026 05:09:58 -0700 (PDT)
Message-ID: <403580ab-e195-4a9e-a080-9487add2eaaf@gmail.com>
Date: Sat, 13 Jun 2026 14:09:58 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] multipath-tools: add mandoc check to man pages
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
 <20251010092211.57426-2-xose.vazquez@gmail.com>
 <cd074f884f847ed291c2e720657668d6a0523f8f.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <cd074f884f847ed291c2e720657668d6a0523f8f.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/10/25 1:20 PM, Martin Wilck wrote:

> On Fri, 2025-10-10 at 11:22 +0200, Xose Vazquez Perez wrote:
>> Cc: Martin Wilck <mwilck@suse.com>
>> Cc: Benjamin Marzinski <bmarzins@redhat.com>
>> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
>> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
>> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>> ---
>>   kpartx/kpartx.8                                | 1 +
>>   libmpathpersist/mpath_persistent_reserve_in.3  | 1 +
>>   libmpathpersist/mpath_persistent_reserve_out.3 | 1 +
>>   mpathpersist/mpathpersist.8.in                 | 5 +++--
>>   multipath/multipath.8.in                       | 5 +++--
>>   multipath/multipath.conf.5.in                  | 5 +++--
>>   multipathd/multipathc.8                        | 1 +
>>   multipathd/multipathd.8.in                     | 5 +++--
>>   8 files changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
>> index ef8051a5..2a55c96b 100644
>> --- a/kpartx/kpartx.8
>> +++ b/kpartx/kpartx.8
>> @@ -2,6 +2,7 @@
>>   .\" Make sure there are no errors with:
>>   .\" groff -z -wall -b -e -t kpartx/kpartx.8
>>   .\" man --warnings -E UTF-8 -l -Tutf8 -Z  kpartx/kpartx.8 >
>> /dev/null
>> +.\" mandoc -W all -T lint kpartx/kpartx.8

> Nack. We don't need this in every man page. Actually, we don't need the
> other command lines mentioned in the man pages, either. While looking
> at this, I realize that the "groff" command line is wrong. AFAICT it
> should be
> 
>     groff -man -z -wall -b -e -t -Tutf8 $MANPAGE_FILE
> 
> But really, it makes no sense to me to have these reminders in every
> man page. If we want to keep our man pages in order (which is of course
> a worthwhile goal), we should rather write a GitHub workflow to check
> them. That would be a helpful contribution.
> 
> I would still question whether our man pages need to pass 3 different
> commands. AFAICS the "groff" and "man" commands are basically
> equivalent anyway, as "man" simply calls "groff" for the parsing and
> formatting. Wrt mandoc in general, see my reply to patch 1/2.
> 
> Regards,
> Martin


I will withdraw this patch. Instead, I will send a new one to
completely remove those groff/man comment lines from all files
to clean them up.
