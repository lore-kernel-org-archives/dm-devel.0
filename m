Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1627F21421A
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753118933; cv=none; b=bpKkxwlT1v03e1HkyNxZfnCCRWoe8uft5yoUQLQdPRSUoVmoQCFljxpcCDvUuQDXQRli+XUOgSm3j6U/4zcr0BSiwmYq2bI2/z7crJSNJg+9fw0E9NLEKq/xhcjxpyCdlypUsAf+fgZRIsv5IeAx7zV/90c5euen+gQ8z5huB1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753118933; c=relaxed/simple;
	bh=iR7rxQGYBdkqDIrf6TwL2CvOEG/ndPYTLhHynHJxuvY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=AiviqUpQoRvQ55CfbQlDwV24n6lTDvWXx+fTKd7Nn8NDUd2UPubczuzwoM9ClHlLkyGYOY2z1VvAkHxHxqUZQpGmSBgBMpKYQKc3fa9ez86aFaIAe+S47UbVGdME+nhzJSL+gzxzIylCyNsMl6Z72oAaqatjvHMgBvPRWkJoBw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h4wR86hC; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h4wR86hC"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b31f0ef5f7aso2370596a12.3
        for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 10:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753118931; x=1753723731; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=n03uIK1M5rvvptuPRnX/++iHtWfKS7iSWsrH9sK3zmk=;
        b=h4wR86hCmUmP5BFOUMZkl539EP+b8xPNFNyFBJ5qE4HGcl7PrsFprNrH0vKAko3MCy
         sll7UTiQnAiLVVAftGES5qqbmOjzuaCN98R7rtc4kVSyYrxw2+Mis7RUMjeD6r3OBtZ/
         ujr4UfSQzaiU3N0TMvT52qnuN2Dj3oss8hbxmOeSqZPNEaG37Lqtl0n2yzSzZtYvfdP8
         ywrpSho+7xkpCP3cPcd01KwNtwkJNMrHgFQwoAuKRU1FrXX8SSOdINnXJgVsnPHx8sih
         qebjhxvx2Ks3+kG7uu5azv5FeTFtfc5hfQcnMRmmXPYDBbNe3BI2X8JW5zhQd3Bng+/G
         iCsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753118931; x=1753723731;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n03uIK1M5rvvptuPRnX/++iHtWfKS7iSWsrH9sK3zmk=;
        b=dWadInUJ8wpSTfdTjwrnx6sSDKKMGts91i70LiZoLGO/wOZ5GQkxP2qUcJQt+w3EZZ
         18US/BS8ABq5E1YvX2bhotdtGn8Ra5uKWFwQfnuUffqVM/hpL/sLu8s0G0pEp5BAGQHz
         BQZ1EmMvwFVW+gUPkjwckFYogjiMx63MRisvCbaDwW0TnKx+cQD8NyUbRrHtkm/qo6C9
         EWm6sHRg+x9wuTMoj0NzYT841Xw0gI5Ob1zTqmTba0cWPVb4OVG8EGybcRKhlEDoWQGl
         n1+q2WY2OGcMstXJ2g9JA5kw9i8AGD4pf5uTLYQvG4x1MrU7KTOuofWxOPzhBiBaSp10
         5gpA==
X-Gm-Message-State: AOJu0Yz110IlFEd1vc9UZs9dtxz9X8aVXlHPi+XPFb6a5j5hd+WEgS/e
	rYnYlgL3l5uzWa4ybzR3juDCIS6jRL7suPL6jSYZ1E9ovsK2J1btPh1ABqtM2g96r8TH19MBz95
	4UJSRsW6VMO+eUNFqWQZiFuBljNzyBN/ISThI/ZlELw==
X-Gm-Gg: ASbGncvxNQmrk+AkSQ6InGvtwpA6Q/k0T3Agqo4ML0/W6Jps7SMhE2vE7F+zj4winZ3
	mRDgtQgUM0UsyvbM5nPVIHgfvj5FO5qHb4TsxqPvpveMmFaZcLB7Gye4w2DLQM8GSsdiptWb/2B
	jK8BdeO8ij7SwrZN3RLX6riVdzv/6Ur4s8BUlPgvgRZKrAZLIOct3mtGqsO933r1Kfzoy52+E0C
	YXv9DrnKxv/eA==
X-Google-Smtp-Source: AGHT+IEkrzxHlkwVyokHzITS9by/9Eqt2w0YUwulfytua11qKL4qkMBVHy9XnICoi4jQUFXDUgRJZZz8ALYbLa/t5wI=
X-Received: by 2002:a17:90b:3e47:b0:315:cbe0:13b3 with SMTP id
 98e67ed59e1d1-31c9f399399mr27542290a91.7.1753118931006; Mon, 21 Jul 2025
 10:28:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Funda Wang <fundawang@gmail.com>
Date: Tue, 22 Jul 2025 01:28:33 +0800
X-Gm-Features: Ac12FXyBl6r07W0d-qxzqBeLxqRAjSLAViDgbgrNj_y0qe1jNqYYjOgBY_VLCUs
Message-ID: <CAOfq2QS2rh7_+rbqeDMa1gjEFht2QThnLqfes_kzwt02uafbvg@mail.gmail.com>
Subject: [PATCH] multipath-tools test: add missing include for stdint.h
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, mwilck@suse.com
Content-Type: multipart/mixed; boundary="00000000000021d65e063a73cfd6"

--00000000000021d65e063a73cfd6
Content-Type: multipart/alternative; boundary="00000000000021d65c063a73cfd4"

--00000000000021d65c063a73cfd4
Content-Type: text/plain; charset="UTF-8"

When building multipath-tools with cmocka 1.1.8. it produces following
error when make test:

In file included from test-log.c:6:
test-log.c: In function '__wrap_dlog':
test-log.c:24:20: error: 'uintptr_t' undeclared (first use in this function)
   24 |         expected = mock_ptr_type(char *);
      |                    ^~~~~~~~~~~~~
test-log.c:10:1: note: 'uintptr_t' is defined in header '<stdint.h>'; did
you forget to '#include <stdint.h>'?
    9 | #include "debug.h"
  +++ |+#include <stdint.h>
   10 |
test-log.c:24:20: note: each undeclared identifier is reported only once
for each function it appears in
   24 |         expected = mock_ptr_type(char *);
      |                    ^~~~~~~~~~~~~
test-log.c:24:20: error: expected ')' before '_mock'
   24 |         expected = mock_ptr_type(char *);
      |                    ^~~~~~~~~~~~~
test-log.c:24:20: note: to match this '('
   24 |         expected = mock_ptr_type(char *);
      |                    ^~~~~~~~~~~~~
make[1]: *** [Makefile:74: test-log.o] Error 1
rm parser.o.wrap dmevents.o.wrap hwtable.o.wrap uevent.o.wrap
blacklist.o.wrap util.o.wrap
make[1]: Leaving directory
'/home/lkp/rpmbuild/BUILD/multipath-tools-0.9.5/tests'
make: *** [Makefile:121: test] Error 2
error: Bad exit status from /var/tmp/rpm-tmp.7qc9Bd (%check)

The attached patch solved this issue. Thanks.

GitHub pull request: https://github.com/opensvc/multipath-tools/pull/117

--00000000000021d65c063a73cfd4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">When building multipath-tools with cmocka 1.1.8. it produc=
es following error when make test:<div><br></div><div>In file included from=
 test-log.c:6:<br>test-log.c: In function &#39;__wrap_dlog&#39;:<br>test-lo=
g.c:24:20: error: &#39;uintptr_t&#39; undeclared (first use in this functio=
n)<br>=C2=A0 =C2=A024 | =C2=A0 =C2=A0 =C2=A0 =C2=A0 expected =3D mock_ptr_t=
ype(char *);<br>=C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^~~~~~~~~~~~~<br>test-log.c:10:1: note: &=
#39;uintptr_t&#39; is defined in header &#39;&lt;stdint.h&gt;&#39;; did you=
 forget to &#39;#include &lt;stdint.h&gt;&#39;?<br>=C2=A0 =C2=A0 9 | #inclu=
de &quot;debug.h&quot;<br>=C2=A0 +++ |+#include &lt;stdint.h&gt;<br>=C2=A0 =
=C2=A010 | <br>test-log.c:24:20: note: each undeclared identifier is report=
ed only once for each function it appears in<br>=C2=A0 =C2=A024 | =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 expected =3D mock_ptr_type(char *);<br>=C2=A0 =C2=A0 =
=C2=A0 | =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0^~~~~~~~~~~~~<br>test-log.c:24:20: error: expected &#39;)&#39; before &#=
39;_mock&#39;<br>=C2=A0 =C2=A024 | =C2=A0 =C2=A0 =C2=A0 =C2=A0 expected =3D=
 mock_ptr_type(char *);<br>=C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^~~~~~~~~~~~~<br>test-log.c:24=
:20: note: to match this &#39;(&#39;<br>=C2=A0 =C2=A024 | =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 expected =3D mock_ptr_type(char *);<br>=C2=A0 =C2=A0 =C2=A0 | =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^~~~~~=
~~~~~~~<br>make[1]: *** [Makefile:74: test-log.o] Error 1<br>rm parser.o.wr=
ap dmevents.o.wrap hwtable.o.wrap uevent.o.wrap blacklist.o.wrap util.o.wra=
p<br>make[1]: Leaving directory &#39;/home/lkp/rpmbuild/BUILD/multipath-too=
ls-0.9.5/tests&#39;<br>make: *** [Makefile:121: test] Error 2<br>error: Bad=
 exit status from /var/tmp/rpm-tmp.7qc9Bd (%check)</div><div><br></div><div=
>The attached patch solved this issue. Thanks.</div><div><br></div><div>Git=
Hub pull request:=C2=A0<a href=3D"https://github.com/opensvc/multipath-tool=
s/pull/117">https://github.com/opensvc/multipath-tools/pull/117</a></div></=
div>

--00000000000021d65c063a73cfd4--
--00000000000021d65e063a73cfd6
Content-Type: application/octet-stream; 
	name="multipath-tools-add-missing-include-for-cmocka.patch"
Content-Disposition: attachment; 
	filename="multipath-tools-add-missing-include-for-cmocka.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mdddogz00>
X-Attachment-Id: f_mdddogz00

RnJvbSAxMGUxMDEwYmZjN2Y2ODNkZGFjNjY4MGYzMzQ5MWM2YjU5YTE4NDFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGdW5kYSBXYW5nIDxmdW5kYXdhbmdAeWVhaC5uZXQ+CkRhdGU6
IE1vbiwgMjEgSnVsIDIwMjUgMTE6MjY6MDggKzA4MDAKU3ViamVjdDogW1BBVENIXSBtdWx0aXBh
dGgtdG9vbHMgdGVzdDogYWRkIG1pc3NpbmcgaW5jbHVkZSBmb3Igc3RkaW50LmgKCi0tLQogdGVz
dHMvdGVzdC1sb2cuYyB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZm
IC0tZ2l0IGEvdGVzdHMvdGVzdC1sb2cuYyBiL3Rlc3RzL3Rlc3QtbG9nLmMKaW5kZXggNjM1MTY5
OTk0Li40ZjY2OTk1NjggMTAwNjQ0Ci0tLSBhL3Rlc3RzL3Rlc3QtbG9nLmMKKysrIGIvdGVzdHMv
dGVzdC1sb2cuYwpAQCAtMiw2ICsyLDcgQEAKICNpbmNsdWRlIDxzdGRkZWYuaD4KICNpbmNsdWRl
IDxzdGRhcmcuaD4KICNpbmNsdWRlIDxzdGRpby5oPgorI2luY2x1ZGUgPHN0ZGludC5oPgogI2lu
Y2x1ZGUgPHN0cmluZy5oPgogI2luY2x1ZGUgPGNtb2NrYS5oPgogI2luY2x1ZGUgImxvZy5oIgo=
--00000000000021d65e063a73cfd6--
