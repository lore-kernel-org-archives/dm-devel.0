Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427AE50AC04
	for <dm-devel@lists.linux.dev>; Thu,  3 Sep 2026 19:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788463899; cv=none; b=SG2rxEozu6deMbTb5oYqwFeeIFtR5bfalR1NytaMOnCSzazL8kTLl224VMprX5WqvQHNY0aH/uCEK+aPwgGVL+GylEfgq3wL/B3bomdo1Q8lnfLkUKdHYWRh6iAG3d/sMLF+H7e1fzCXvCQUHM+0xHGIt1/3OFoQSRc/0WSTdR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788463899; c=relaxed/simple;
	bh=Ih9leD956J6d4ZrWAgzKX6hjO9je2M/Bu0DEpbOSkck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o7dYASXK8i3doE8GlQk9d3zsWK3nxuBbUNTtvlPb+4L9pUIvAhMl+f/LYr4slQHO9r/bmNgV3U3QTC84skXlbWymsDTFNh/c9yfqycmR+5TPjC97ni0CWTW9lluF4kDFWpbxRT47Zq1n5sYyNxHmu7RfAgPy6o1l7jb5JEwC8oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bm2ohYaj; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bm2ohYaj"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4858595f997so164053f8f.1
        for <dm-devel@lists.linux.dev>; Thu, 03 Sep 2026 12:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788463886; x=1789068686; darn=lists.linux.dev;
        h=content-type:in-reply-to:autocrypt:content-language:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Ih9leD956J6d4ZrWAgzKX6hjO9je2M/Bu0DEpbOSkck=;
        b=Bm2ohYajbb4JQgpk1campPJgTeQRNtdU4OidBvxJVNuzkirNHJbViTZNFddUSMJK8f
         aD6NMn5qR3WodegISaMl1/C7T3PMmWbRiXqXEf0VVJBKLhA0m5AJE0FsM+alcwSxYNhU
         sgqKcXziM63D2TsyJ0tuFAjZBp9TaqWpRPmZ3IRv4xuHuEd27qDqHnoEwfPNMWcpfw0I
         vglkEiixa9FcHbzYdPWEQjrVb3x2BItQ6LVVBms8jemVQvywg7tjntdqpcTNKfPlNT+c
         ZbdWnwXvEeCJcNZwztDmSZIF5MnXHiq9ks9haOhYVvnwPQgMGwwO4HtgQ63bMbT00FsR
         smFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788463886; x=1789068686;
        h=content-type:in-reply-to:autocrypt:content-language:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ih9leD956J6d4ZrWAgzKX6hjO9je2M/Bu0DEpbOSkck=;
        b=UFnp3v/2irOo5TZsagRQmjmLtKbw9MMGJ/7LQXDgLFh58AydN+LQr1xmwFpde5Vqhp
         s7VYL7F/ApB419Oz4jLOgfPkZgVUSRbGWQyZc7FlQiCnnl2FPEJ5x0ojcsvQVZzFo2qX
         ldLlok3ff1fGnvXYgF8RwPB3+94B1gaMvdrbagQ3zAsTgelMf/Cah3QGy/EDbbpMGgQp
         n+jEapevKqg0Yh9TrrVAtJ5L7Sb9z9wgEIAtyNp23sDr+0jwsHmPCSyzabv4IWoNffzz
         uDBAeepCihMJShnEOjJj+9RHsK9BreD7ULhiGU65h0uXM4ShCScj0CbblRZvVVrmtPet
         q2Iw==
X-Gm-Message-State: AFuF++mVs4fXu9rMWRkOIhnIh6JsT3i1eaziZUxozpqdt46AQepJxmCm
	xwIEl6u/J+zB93xZGpnBwmqu2WQ+20PhOaXgK0q9j1YECNRlxncBTE3M
X-Gm-Gg: AYBFou02qHI+d4Vzf+L+c1Tfl9PEYesQgYTT39RTXdYOr+RKYLYf3eAEm7Dc4zj7cVT
	Aq1CbGoujWWb92QlgPi/l3AWha2Dx+Un56BWGtoNClhEkDONRt9UB3PpVtpQHD/rpjeJ50fZPoq
	DyABBqTrz/lSGVmCNHXJhGEOfAyV4JFx6et9pMQ880utoeBMJ+ExIQYRuoyRF4LzCvkKkT01IoQ
	aAGEc8ebA3RZhRL5zg/s/xrS/baE4RTPCZdCnaRyl/RT4x0VD2KUhZJTYOf4JyxuJqw7IJakkrD
	5zdIH3yP2tJTIQuCEC3F7yAJ2PnujlJXKuGc6xId4yUudOKReBniXOCickfNn8Kfl313CNx4814
	t3v4mASS2xcSvywlhoNiX+q2j80q7BAR3vKALvSpq1kBi9bB+tMwjXgNLgA7mKNpalrIOJl/KgJ
	bcy4gl3vE0yXACK9Qjp/9t776I9Ro0y1rPCD063h9KuZ4BLzQM1MQoiED9e2ctbHqh4rylWikIP
	qJQsDBZ
X-Received: by 2002:a05:6000:4819:b0:482:fc30:a1b4 with SMTP id ffacd0b85a97d-4858704686dmr2758738f8f.5.1788463885810;
        Thu, 03 Sep 2026 12:31:25 -0700 (PDT)
Received: from [192.168.1.201] ([5.83.201.220])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-485885b7bfasm700636f8f.29.2026.09.03.12.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 12:31:24 -0700 (PDT)
Message-ID: <d12c133f-2caf-4c9d-928b-b8372dd1c7dc@gmail.com>
Date: Thu, 3 Sep 2026 20:29:19 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] dm vdo: Fix spelling mistake "postive" ->
 "positive"
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
 Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260903152325.16304-1-colin.i.king@gmail.com>
 <1d2cd544-97a6-4ddd-8758-048bbd104eb5@redhat.com>
 <ae8b93d1-2967-d4bf-4c2d-2b110b9d2fc4@crashcourse.ca>
From: "Colin King (gmail)" <colin.i.king@gmail.com>
Content-Language: en-US
Autocrypt: addr=colin.i.king@gmail.com; keydata=
 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
 FVPMkxl2UyaayDvhrO9kNXvl1SKCpdzCMQ==
In-Reply-To: <ae8b93d1-2967-d4bf-4c2d-2b110b9d2fc4@crashcourse.ca>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------i5HxVvt0i5kRiqT0Y2vUpJac"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------i5HxVvt0i5kRiqT0Y2vUpJac
Content-Type: multipart/mixed; boundary="------------slTGuE0NC8aJ16V6JfFbnZz1";
 protected-headers="v1"; hp="clear"
Message-ID: <d12c133f-2caf-4c9d-928b-b8372dd1c7dc@gmail.com>
Date: Thu, 3 Sep 2026 20:29:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] dm vdo: Fix spelling mistake "postive" ->
 "positive"
To: "Robert P. J. Day" <rpjday@crashcourse.ca>,
 Matthew Sakai <msakai@redhat.com>
Cc: dm-devel@lists.linux.dev, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260903152325.16304-1-colin.i.king@gmail.com>
 <1d2cd544-97a6-4ddd-8758-048bbd104eb5@redhat.com>
 <ae8b93d1-2967-d4bf-4c2d-2b110b9d2fc4@crashcourse.ca>
From: "Colin King (gmail)" <colin.i.king@gmail.com>
Content-Language: en-US
Autocrypt: addr=colin.i.king@gmail.com; keydata=
 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
 FVPMkxl2UyaayDvhrO9kNXvl1SKCpdzCMQ==
In-Reply-To: <ae8b93d1-2967-d4bf-4c2d-2b110b9d2fc4@crashcourse.ca>

--------------slTGuE0NC8aJ16V6JfFbnZz1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDMvMDkvMjAyNiAyMDoyNSwgUm9iZXJ0IFAuIEouIERheSB3cm90ZToNCj4gT24gVGh1
LCAzIFNlcCAyMDI2LCBNYXR0aGV3IFNha2FpIHdyb3RlOg0KPiANCj4+IEkgaGFkIHRvIGxv
b2sgYXQgdGhpcyBmb3IgcXVpdGUgYSB3aGlsZSB0byBmaWd1cmUgb3V0IHdoYXQgd2FzIGdv
aW5nIG9uLg0KPj4gV2UgbWFkZSB0aGUgc2FtZSBzcGVsbGluZyBlcnJvciB0d2ljZSBpbiB0
aGUgc2FtZSBmdW5jdGlvbiBhbmQgc29tZWhvdyBvbmx5DQo+PiBub3RpY2VkIHRoZSBmaXJz
dCBvbmUgcHJldmlvdXNseT8gQW55d2F5LA0KPj4NCj4+IFJldmlld2VkLWJ5OiBNYXR0aGV3
IFNha2FpIDxtc2FrYWlAcmVkaGF0LmNvbT4NCj4+DQo+PiBPbiA5LzMvMjYgMTE6MjMgQU0s
IENvbGluIElhbiBLaW5nIHdyb3RlOg0KPj4+IFRoZXJlIGlzIGFub3RoZXIgc3BlbGxpbmcg
bWlzdGFrZSBpbiBhIHZkb19sb2dfZXJyb3IgbWVzc2FnZSB0aGF0DQo+Pj4gSSBzb21laG93
IG92ZXJsb29rZWQgbGFzdCB0aW1lLiBGaXggaXQuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5
OiBDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNvbT4NCj4+PiAtLS0NCj4+
PiAgICBkcml2ZXJzL21kL2RtLXZkby9kbS12ZG8tdGFyZ2V0LmMgfCAyICstDQo+Pj4gICAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+Pj4NCj4+
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9kbS12ZG8vZG0tdmRvLXRhcmdldC5jDQo+Pj4g
Yi9kcml2ZXJzL21kL2RtLXZkby9kbS12ZG8tdGFyZ2V0LmMNCj4+PiBpbmRleCAxZDgzNzVj
YzNjM2UuLjA0MzU0OWIxZmMyZSAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL21kL2RtLXZk
by9kbS12ZG8tdGFyZ2V0LmMNCj4+PiArKysgYi9kcml2ZXJzL21kL2RtLXZkby9kbS12ZG8t
dGFyZ2V0LmMNCj4+PiBAQCAtNDQzLDcgKzQ0Myw3IEBAIHN0YXRpYyBpbnQgX19tdXN0X2No
ZWNrIHBhcnNlX3NsYWJfc2l6ZShjb25zdCBjaGFyDQo+Pj4gKnNsYWJfc3RyLCBibG9ja19j
b3VudF90ICpzbGENCj4+PiAgICAgIAlyZXN1bHQgPSBrc3RydG91bGwoc2xhYl9zdHIsIDEw
LCAmdmFsdWUpOw0KPj4+ICAgIAlpZiAocmVzdWx0KSB7DQo+Pj4gLQkJdmRvX2xvZ19lcnJv
cigib3B0aW9uYWwgcGFyYW1ldGVyIGVycm9yOiBpbnZhbGlkIHNsYWIgc2l6ZSwNCj4+PiBt
dXN0IGJlIGEgcG9zdGl2ZSBpbnRlZ2VyIik7DQo+Pj4gKwkJdmRvX2xvZ19lcnJvcigib3B0
aW9uYWwgcGFyYW1ldGVyIGVycm9yOiBpbnZhbGlkIHNsYWIgc2l6ZSwNCj4+PiBtdXN0IGJl
IGEgcG9zaXRpdmUgaW50ZWdlciIpOw0KPj4+ICAgIAkJcmV0dXJuIC1FSU5WQUw7DQo+Pj4g
ICAgCX0NCj4gDQo+ICAgIE15IHJ1bGUgZnJvbSB5ZWFycyBiYWNrIHdhcyAuLi4geW91IGZp
bmQgb25lIHR5cG8sIHlvdSAiZ3JlcCAtcnciDQo+IHRoZSBlbnRpcmUga2VybmVsIHRyZWUu
DQoNCll1cCwgbm9ybWFsbHkgZG8sIHNvbWVob3cgdGhpcyBzbGlwcGVkIHRocm91Z2ggOi0o
DQoNCj4gDQo+IHJkYXkNCg0K

--------------slTGuE0NC8aJ16V6JfFbnZz1--

--------------i5HxVvt0i5kRiqT0Y2vUpJac
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEcGLapPABucZhZwDPaMKH38aoAiYFAmqZyo8FAwAAAAAACgkQaMKH38aoAiZP
bw//TO5nXKrr20hpQzk0ssXF4eCNH33cehKEE8/6MwxP/WIFGaX89WPrkyIAZL7AUxUIt7MDGjvx
oP5osscmfcmYLr2M1gLfKkyBekScGnn7ZRsx1DmD+f7dhmn9HAYm056PmhI1/lqUiukPO2I5Ldg9
5e/+lfdqvVvmByko2zxz33CYfMKSgtMcol08YrA3gdoTHC4GY0fkKPJGtjFOu2i1L9CgdbEx+z7N
Hr7ZTgEBtg4irX4OI66ihk2k1Rc/rCXXqLOQTzVUBV0KKSgFqlpy0JTQn9oEtd1yFx7Hi83B+cUf
Orvuk63XRlupdYWDHa84/PkRkbFqEriAevSDliXz1bQhMdrKCe5Qm+8EcK9J29QIvE/YcEJWLNrc
tzeMOXL4GZiRWrVgDKGkB2szAZwbjmX4JNHb8Y6PcVrMUoWAnqxjT/iNh8C4j2nbn2RasFjsGZHf
+KquYF5RNIiYmZsLkqWbwUur7BC/b8JIePWod59kTubAoT3xltDd0jgVIfrBofsjJtvL5GN4Yagq
TImb5tBcIYOB4kTO8TO1qnaIObGhRNNPopfHt092FLCmvGou2iIWR/x2JNZTeIKRxnv3gWjQEc0n
eGeiR32C33PY2lCK0EhIbK9i4RUnqS8SIA9kzO40ZrBER9ieQyThn5yjH5Kzd9HPsZse/heiNUWv
YG8=
=9lh5
-----END PGP SIGNATURE-----

--------------i5HxVvt0i5kRiqT0Y2vUpJac--
