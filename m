Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602285;
	b=IiBaLDtcSUFUaJqsApwezpZy3ItaFCtcbEcahby9YreRypbXr7uINjHE64CZF0e3wfya
	 lWtAodL0smriB8obDGRByCVxnY3B2GdUG1aQYnwSOFuiOA+nM40QTPVW/ckn0KTzOozXy
	 8S/65Memh9lrwK2i01waKSs/MsYVz+C6KjfusLoywDhWJDcjhULQBMOZOwIDj13ghoPQw
	 mWPa7PpvSZd/cZL4nZ+leLK9/Ki48e6poYeqBj2HouA3E5p36PmsiPg86wH8re+teZh6y
	 Rvsi7PMv+ma8l0h4Rvm0CFA2az6lTvaHCiCykE6vvIIyCrgLL0yjKbfLK3TY0bqiSng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602285;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=45hMqaEBPxg+g8DS11BxGugeTkXLlNWrZW0d8VdOEMc=;
	b=zaGDMFPmnDuxa6ccUeJElTzSjIniL0fWFm3mKF1t2K2KmHdofz195DmZRQ6vBswS9M95
	 HDj/u13Mhcbg4wRZ8T6e0Al85z+YlUWKErLyArks+ACB2Y+FfS6AdahJ4SRvJeYTj2odD
	 o31Bie4ZtYyLKisP4fSDeDen/1cLeMhSvyEVQZOi66xvJirNHIdJLpYHDxTj0VoDtacr2
	 PqMzXIZDXfcvd7f2OSKBGvZVgDK8qhjhigLanItTo9wS3TjGMLFwB2K+kad60GVGiBEci
	 QkF12JZrAGeSVMAzqdHbnTnlx3iWUGSFkQJ+jtM5pEpbaNWMZrDGnwOtbNiTsuCykvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lIBgBHM3;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B21606A33C
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89B21606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lIBgBHM3
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a68f888a41so5116855e9.0
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 02:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795602282; x=1796207082; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=45hMqaEBPxg+g8DS11BxGugeTkXLlNWrZW0d8VdOEMc=;
        b=lIBgBHM3DWFnd3kKOaMccb8Q8AKII0uVk+UXCzWZACAlyhN7r+wcSft2tNp/NycRVG
         s5fc1nB/jYY2CffsJ//zZTyYeGYeFMnfcC8scBFwlqwrm6MFYkVE77YiPKtAxj39YvI/
         dNHDyRG21FdTwTFInohHYDk+MAHCFrKCy7tR1yUQq99RktLwQZcOIjV5QG6Wcdoc8/rT
         oyKPs2FNBO+PtQHDOxaNzDK5JFmkUSR5gL3tGDXdayqQ5dVYmJw5o/qX+eAMp5unw0XC
         UjN8lyZOpSTAxMijZeQPp70/oem3rj0Qi4ey+FrJ3+aX6qhQLyUS1keBUoqG8YN94cKX
         NFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795602282; x=1796207082;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=45hMqaEBPxg+g8DS11BxGugeTkXLlNWrZW0d8VdOEMc=;
        b=OZP8uUioBLE0JbZxVVjbk9JWqGB9omGnI9xTWHuAdpXGSUxPNHlNd+2/tHNdXsaEeU
         kEK2U+wUSpiek4o/D9Nx+Ft8AO51nfoVpC1YdsH2lgrsmPAex1shadQw2RMdJO9yfv2S
         QGg/e7OdB0Nh9EVAW6j/ul+3UpJSLZwFCJ6RHy1dmkivUlxl2Ytcc8YlsFRyWHL7X9Mu
         pEuEzSrJpLwc6DC1M2UUbqVdBJCVmpsU+55T1BuKVREx3lM43+OWjWwVcgbNk6mcZZKY
         i6O+Gbobw9OeCKfw39GM6ABoZ/4OECmEUvI2OUpcY10BXHYJ6ktjQvL5VtXbiR6qKooy
         Z/DA==
X-Forwarded-Encrypted: i=1; AL+hErE6SCVQAtZbwMIb50zQepBRWLb2RWTP2KYSrgQrEmRbFg0YurwqA+8w0rLlUXqZgQ7AqAXodsPp5A==@lists.linux.dev
X-Gm-Message-State: APuU4Z+zJWRIdgA/EOoqDXHu6vtu8RvKPv17TZYw1/8wroBS47HNzYnn
	91bciq7xmX6PnyUE5cCp2Mcns7mLt9OLsFCeklNEprKxB405hvvjVIFwNbTDr70=
X-Gm-Gg: AZFdTZfz52hM5LiVBiVydzhWFOghd3ghP8JHshOSqea6NpxsnAO1L7NflGpKIFBK20a
	crtPyN42dYDoJ6nCn4SJTh7wEDvwea395p9A42dKoK5Ka7kLKnoXDnONNfGXAMbcSX28jM3QKvu
	pf4DwIh6al4QhopRs/NoInYB3f858B0FrgdbqrYv6+XjSh8tBdOhZ+Adt/IAnqbQOJRpeVlD5WR
	582ScrEIBDE6pWaP0ypthNccELacIY1cGGDeLjK5E/Oo4id7BRK5PiMH3EZIoJwZ7nqcy9IGnq8
	YI9/teXDItFYQ9a16SvC7gSvIRyGk4/2O0ivAA7wQAG/LzpNd61Tq7zUz+GjPKKkRNFL5lWp0Y7
	gaqsXcq3V9YB/iwfWi3nMnSFew0qPESQ4SB2bjp0GnZYpAv1cm9ZEswRFtRGBWr1IHxX3H5FhUM
	7EuKzQKvZvXLrMunKrM0NvDg2gPl8xr47xuVKz/nwK0YuZM/EUMLTEno+MogWU9pRcNux5/ZyZ7
	/4WaOCWgIazWKhBVtkVXBlHbv9wQfGCGRh3A3zUk6Qyl1pOnTgRjTl/BcbTDvTQFPGS0zSSmK+F
	SnxCPEI7Xuof6ux/I/FWynaFbjSSdDgZveQ5Jc4rFX6hVWU1o0kWxC26Wumz0sBKLQ==
X-Received: by 2002:a05:600c:2059:b0:4bb:7ae0:30bf with SMTP id 5b1f17b1804b1-4bb887fd0f1mr239558485e9.2.1795602281809;
        Wed, 25 Nov 2026 02:24:41 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442693sm450913995e9.1.2026.11.25.02.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 02:24:41 -0800 (PST)
Message-ID: <e35c05f4-e5d4-4394-b4a0-7222d3bb0753@gmail.com>
Date: Wed, 25 Nov 2026 11:24:40 +0100
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Subject: Re: [PATCH 01/13] multipath-tools: multipathd.8.in: fix mandoc
 WARNINGs
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
 <20261113125549.504780-2-xose.vazquez@gmail.com>
 <avt3vc307mk4FHZK@redhat.com>
 <ac29a29d-9932-495a-b75f-1fe4fe7948c7@gmail.com>
 <av80EsBawOfxfHXK@redhat.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <av80EsBawOfxfHXK@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 6:38 PM, Benjamin Marzinski wrote:

> On Wed, Nov 18, 2026 at 04:02:58PM +0100, Xose Vazquez Perez wrote:
>> On 11/16/26 10:38 PM, Benjamin Marzinski wrote:
>>
>>> On Fri, Nov 13, 2026 at 01:55:33PM +0100, Xose Vazquez Perez wrote:
>>
>>>> @@ -77,7 +77,7 @@ multipathd executes the given command (see \fBCOMMANDS\fR below). If the
>>>>    command contains whitespace or shell special characters, it needs to be quoted
>>>>    like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
>>>>    the \fB-k\fR and the command string.
>>>> -
>>>> +.br
>>
>>> Nitpick: If we don't want an actual blank line in the option
>>> description, I'm not sure the line break really matters here.
>> My intention was simply to replace the blank line that mandoc was
>> complaining about and remove the visible empty line while keeping the
>> rest of the formatting as is.
>>
>> That said, if you prefer merging it into a single continuous paragraph,
>> I have no objection to dropping the .br in v2.
> 
> IMO, it's not worth doing a v2 just for this. But if you are already, then I
> think dropping the .br makes sense.

Restoring the previous layout, as I think it reads better.

 From c7ea74917499f61f5bc44a32d5ba6c7eb6bd83a9 Mon Sep 17 00:00:00 2001
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Tue, 24 Nov 2026 23:04:24 +0100
Subject: [PATCH 7/7] multipath-tools: multipathd.8.in: restore the original layout
X-Patchwork-Bot: notify

Add a blank line between paragraphs.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
from :
  -kcommand
         multipathd executes the given command (see COMMANDS below). If the
         command contains whitespace or shell special characters, it needs
         to be quoted like in multipathd -k'show topology'. No whitespace
         is allowed between the -k and the command string.
         Commands can also be issued without using -k. In this case, the
         command string should not be quoted. Command arguments that
         contain whitespace or special characters still need to be quoted,
         like in multipathd show paths format "%n %w"

to : (as it was before)
  -kcommand
         multipathd executes the given command (see COMMANDS below). If the
         command contains whitespace or shell special characters, it needs
         to be quoted like in multipathd -k'show topology'. No whitespace
         is allowed between the -k and the command string.

         Commands can also be issued without using -k. In this case, the
         command string should not be quoted. Command arguments that
         contain whitespace or special characters still need to be quoted,
         like in multipathd show paths format "%n %w"
---
  multipathd/multipathd.8.in | 2 +-
  1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 461e960d..71228fac 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -77,7 +77,7 @@ multipathd executes the given command (see \fBCOMMANDS\fR below). If the
  command contains whitespace or shell special characters, it needs to be quoted
  like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
  the \fB-k\fR and the command string.
-.br
+.IP
  Commands can also be issued without using \fB-k\fR. In this case, the command
  string should not be quoted. Command arguments that contain whitespace or
  special characters still need to be quoted, like in \fImultipathd show paths
-- 
2.56.1


