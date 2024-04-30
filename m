Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1705117B4E1
	for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 17:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714496790; cv=none; b=R38GEPls7KTPP4qHFF8nNDzhlv3hOIDT7I915+G2lrB5FF3m8pgx7q/52e34pAME1y/kHzTRiBFZyHfd0K7B67hHavgZ7dzIK+NLmzrTFYRpVDloDTJoJ+hh6WeVScwhISCscrK+A2qTxXik7ZlQO9BlokMrumLtsVMSsIncgDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714496790; c=relaxed/simple;
	bh=QA3yJfMkHJZeNchXEONBddHFGXIkDVHMf5QdiqQRkXM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ffW7oD8GJQ+c4/hN71IHycbo/xvnIrEMhYtU0wMRLdSRIPKSVLbXd7cKPFi9zzBHCEGJo4dBRHjDStm4DxMbysHZJSZSBieIiqe9hptgdvQG8K0TWwzycju0czivzwbZlejdK40aSj4XYf1A9hm2/aaIlHbOPCBRwHE6h/q5Odo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BmI+cz5r; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BmI+cz5r"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a587831809eso718007866b.1
        for <dm-devel@lists.linux.dev>; Tue, 30 Apr 2024 10:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714496786; x=1715101586; darn=lists.linux.dev;
        h=mime-version:user-agent:references:in-reply-to:date:cc:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TLgNfdR/XhSVw0ckC1J52p7G9K5ePVYRrWHdYiar3Oo=;
        b=BmI+cz5r7KdzAfjwqMGoD1VoC4F0nger/JLO8BnAHdo3TGM7od2jsx9E0EuFTTtr0a
         LN5FOQTTTrigXOfx/9hlJbR7IMSQ5zqvQ+IiErdMspob2FwfVP8VjLLK99jE3NZNEjc0
         EmlYs8XZdG5Q15HRRF/g/Am+TprV+4IzKBs3C6j+sApw9cPopUMGVO3YTip/PRz4UAzQ
         IWHz2Mr9EN6ORWBCm6ncZdyrz4Mj5X3IGhfz6s0CEPqdc9cD8ZADPJAZIh61686ayiKw
         d9EyAFhOzcteH440o1B6zYEwCZVqabjndgBe3wY+Su05+WJS9u4H5WVYjgb90PPkFkXI
         GN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714496786; x=1715101586;
        h=mime-version:user-agent:references:in-reply-to:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLgNfdR/XhSVw0ckC1J52p7G9K5ePVYRrWHdYiar3Oo=;
        b=Su/xxKSNR2YUvGLy+46fxfwkSKN7X6ihwqCJ6y4WP1roxXItPaxZdGVO2AJbvtjwZN
         3x1/243uYZojSBTxZaaZGZ82vZQhgrgfpEUuwmSo9ZgkCfI/I8SVT/QeMllvrT1EiAtd
         GW1VJr1AuAg5WwUrHNvrKhn/Wq/ZjeqwUVpqsubdJT7KmBMnGYh+VAhjJWbIXu24cTuM
         rxxgyMGsMSPO3SbepqgIjXwLQUg3ErhHl0hPxBYIuosktlZE0EEZzbR8YcRlId5eim9B
         vhoWnlkvoDF+dio2dZgG84VgJkhvC3Qw5wkzIBuzB1PwGcwDZmnNoLZBbzdJjrWRMUsE
         xOAA==
X-Gm-Message-State: AOJu0YwaYAoSwUQVULGeWxqvzfgxGGPyR711k+E3AlKae7plyy5sQo+r
	ZIfxAS/ViR2Ya+43mUH1gyqGUi/BSadFIrxrwcFgQEtM38tTONCKUZfCcqazcLg=
X-Google-Smtp-Source: AGHT+IE4gfvNX0bSLM1xddBSZAU6xuCL5u1l8viwqkWEw1lejJ/vyUE8m9KjxKuWGKy0MpBSVLP1AA==
X-Received: by 2002:a17:906:880e:b0:a51:8145:6877 with SMTP id zh14-20020a170906880e00b00a5181456877mr222044ejb.37.1714496786258;
        Tue, 30 Apr 2024 10:06:26 -0700 (PDT)
Received: from ?IPv6:2003:de:3704:5300:598:abc6:3a7d:9368? (p200300de370453000598abc63a7d9368.dip0.t-ipconnect.de. [2003:de:3704:5300:598:abc6:3a7d:9368])
        by smtp.gmail.com with ESMTPSA id r6-20020a170906704600b00a58e0d1d5bfsm4563613ejj.221.2024.04.30.10.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 10:06:25 -0700 (PDT)
Message-ID: <5a5aa59a1b60ee0e91abeec292ef3d591d55a7e7.camel@suse.com>
Subject: Re: [PATCH v2 2/5] libmultipath: change flush_on_last_del to fix a
 multipathd hang
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Tue, 30 Apr 2024 19:06:24 +0200
In-Reply-To: <20240425233517.2125142-3-bmarzins@redhat.com>
References: <20240425233517.2125142-1-bmarzins@redhat.com>
	 <20240425233517.2125142-3-bmarzins@redhat.com>
Content-Type: multipart/mixed; boundary="=-tDHlagygPDiWJ2QlMKav"
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

--=-tDHlagygPDiWJ2QlMKav
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2024-04-25 at 19:35 -0400, Benjamin Marzinski wrote:
>=20
> 1. create a multipath device with a kpartx partition on top of it and
> no_path_retry set to either "queue" or something long enough to run
> all
> the commands in the reproducer before it disables queueing.
> 2. disable all the paths to the device with something like:
> =C2=A0# echo offline > /sys/block/<path_dev>/device/state
> 3. Write directly to the multipath device with something like:
> =C2=A0# dd if=3D/dev/zero of=3D/dev/mapper/<mpath_dev> bs=3D4K count=3D1
> 4. delete all the paths to the device with something like:
> =C2=A0# echo 1 > /sys/block/<path_dev>/device/delete

I've tried to reproduce the issue with these commands. Test system was
using a LIO iSCSI target with 2 paths. I created a  test script
(attached) to try the offline / IO / delete procedure repeatedly.
I haven't been able to make multipathd hang even once.

I also played around with dd options. If I use oflag=3Dsync or
oflag=3Ddirect, the dd command itself hangs.

Did I set up anything wrongly, or does the behavior perhaps depend on
the kernel, or something else perhaps? Mine was a 6.4 kernel. This is
not to say there's something wrong with your patch, but I'd like to
understand the error situation better, as it doesn't seem to be
trigger-able on my test system.

multipath.conf:

defaults {
	verbosity 3
	flush_on_last_del yes
}

blacklist {
	wwid QEMU
}

overrides {
	no_path_retry queue
}

Regards,
Martin




--=-tDHlagygPDiWJ2QlMKav
Content-Type: application/x-shellscript; name="flush-0-paths.sh"
Content-Disposition: attachment; filename="flush-0-paths.sh"
Content-Transfer-Encoding: base64

IyEgL2Jpbi9iYXNoCgpyZXNjYW5faG9zdHMoKSB7CiAgICBsb2NhbCBpCgogICAgZWNobyAiPT09
IHNjYW5uaW5nICRAID09PSIgPiYyCiAgICBmb3IgaSBpbiAiJEAiOyBkbwoJZWNobyAtIC0gLSA+
Ii9zeXMvY2xhc3Mvc2NzaV9ob3N0LyRpL3NjYW4iCiAgICBkb25lCiAgICBzbGVlcCAxCiAgICBt
dWx0aXBhdGhkIHNob3cgdG9wb2xvZ3kgPiYyCiAgICAjIHNob3cgcGFydGl0aW9uIGRldmljZXMK
ICAgIGRtc2V0dXAgbHMKfQoKc2V0X29mZmxpbmUoKSB7CiAgICBsb2NhbCBpCgogICAgZWNobyAi
PT09IHNldHRpbmcgJEAgb2ZmbGluZSA9PT0iID4mMgogICAgZm9yIGkgaW4gIiRAIjsgZG8KCWVj
aG8gb2ZmbGluZSA+Ii9zeXMvY2xhc3MvYmxvY2svJGkvZGV2aWNlL3N0YXRlIgogICAgZG9uZQog
ICAgc2xlZXAgNQogICAgbXVsdGlwYXRoZCBzaG93IHRvcG9sb2d5ID4mMgp9Cgpkb19pbygpIHsK
ICAgIGVjaG8gIj09PSBkb2luZyBJL08gPT09IiA+JjIKICAgIGRkIGlmPS9kZXYvemVybyBvZj0i
L2Rldi8kMSIgYnM9NGsgY291bnQ9JHsyOi0xfSBjb252PW5vdHJ1bmMKfQoKZGVsZXRlX2RldnMo
KSB7CiAgICBsb2NhbCBpCgogICAgZWNobyAiPT09IGRlbGV0aW5nICRAID09PSIgPiYyCiAgICBm
b3IgaSBpbiAiJEAiOyBkbwplY2hvIDEgPiIvc3lzL2NsYXNzL2Jsb2NrLyRpL2RldmljZS9kZWxl
dGUiCiAgICBkb25lCiAgICBzbGVlcCAxCiAgICBtdWx0aXBhdGhkIHNob3cgdG9wb2xvZ3kgPiYy
Cn0KCkhPU1RTPShob3N0NyBob3N0OCkKU0RTPShzZGMgc2RkKQpNUD1kbS0wCk49MTAKQ09VTlQ9
OAp3aGlsZSBbWyAkKChOLS0pKSAtZ3QgMCBdXTsgZG8KICAgIGVjaG8gIj09PSBOPSROID09PSIg
PiYyCiAgICByZXNjYW5faG9zdHMgIiR7SE9TVFNbQF19IgogICAgc2V0X29mZmxpbmUgIiR7U0RT
W0BdfSIKICAgIGRvX2lvICIkTVAiICIkQ09VTlQiCiAgICBkZWxldGVfZGV2cyAiJHtTRFNbQF19
IgogICAgc2xlZXAgNQpkb25lCg==


--=-tDHlagygPDiWJ2QlMKav--
