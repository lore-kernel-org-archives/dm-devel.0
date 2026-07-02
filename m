Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59C23C1F43
	for <dm-devel@lists.linux.dev>; Thu,  2 Jul 2026 11:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992002; cv=pass; b=sHvZcP3vhn2B/ga7ClxdpM1nR+vk0udN602j1OrGnV73QDQT6Xm4+H6wStGsQWsnz/f0WXaV0A+eB/cCOGV5TfUkFOe5pXwdIgFgnIfCp7FZRm1IfNhEGsQyQ+jzV4iNITrWluhJhwlJ0eHeoqGtFVP48P8kRPzktIKkB5vG3+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992002; c=relaxed/simple;
	bh=mB6dT1sg2Ybaa5Hs7LVNjTaOvI0XuElN0JvSfPFbp8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GquDz1ycWeBhB6BeJGr7fYhP22ZIGlPvfvGh1QCfSpfuV9gwzbnIux0/4VH9gDo+7i+jOEEbDsT1geAw0JLf61O4toOmqFqXdd8fWi1bneVrFNFMwO77XgdlLFXNLWqx9RZv8O065aSeHeyj5IUCXnGhkLCMPr8+NLd59Os6AUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=R1t1swOf; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="R1t1swOf"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aeb2b17167so494934e87.0
        for <dm-devel@lists.linux.dev>; Thu, 02 Jul 2026 04:33:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782992000; cv=none;
        d=google.com; s=arc-20260327;
        b=RdUCN9rTbOMa9PwoFbH4JyWAATP+MV+jLlIc198FQs8ColloyKgKwEi9OnLvVuIvMb
         CmFz0KIUqzhd983q57LIGNCE+jGce1AhvGOYeqpd5VfSqmBcpaKdETOKaWR0YbasTP9e
         tQTzgJIQyvj1Olq/HdscP5dRzyNLQXDyflphA4d/Hi/EESE9aUPrQ8BFFmUzg3TGW0kx
         oxpX8wffKB8DO4LVjB1O6FEINk0ws1CWydfplzXDbAimNA26Lkgmk3u2lt74Cswuvrma
         msU3wxCqRCOcH8adNvtWVXz6GcMkGIsTzbMloeXsohARlRJdyxz5d/tJs+SrNT3vd3BN
         rFnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mB6dT1sg2Ybaa5Hs7LVNjTaOvI0XuElN0JvSfPFbp8Y=;
        fh=CKD2YGlPyJK2Dog7ZQxjs/HGMKb9h3+aSIdI6BZDRtM=;
        b=dP7dyUJA1AzxdkwGclnAdM5hAQDcpqezyUm9Ws11RMex8vOP+/Zk/SI9SFZbfcGjp/
         K+42uYQoy+bAhQMnAdj05kI02VOPBfw32Z1JCr/R2qrOqT86heVHnKCgTBYA32txhXJx
         9j9VAiubaql3xuD31QaB8u6V/nW/H6RK+R+iY6B1tjswgGjvH4g7soVaTTx/CaqaaUxs
         SIJC2W+0Zsq+NLxY1q4CsDWRsBIxpOipVq1CeLYhy/okzIbAoE6y/38J20+zn6JGdfdw
         um1cmF6OioJGKzoq5YjUGPcZdwpwKStrOABElfL+Z+vPVJqM8qGDxEiZKj0LsjYPCIpc
         Pe8A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1782992000; x=1783596800; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mB6dT1sg2Ybaa5Hs7LVNjTaOvI0XuElN0JvSfPFbp8Y=;
        b=R1t1swOfLGfRpGp42TDAhdgNMCb4UMzZd02PBg4AqfcAF9xIPXjAP6MGyKDB/fOU6X
         00UZ4Y1R/GWjuY0bZSQ49NeeD1hAcEZLEbvN+j54pn5Bacxhv+4FUoQV1r7EmHBRaX88
         eqe6mD18rcoPOPj9PzcgTWL71GKCcob796yU2IY0A9mjOegC9ADaTnww9Fx6GXj0XKRG
         JLLuBPLe7qcxGg53wqpukfEL/5efWAgejSsuR/gzdVk6dNt2DIH9sDSnYaEpeovRSIde
         oCnbcyRpnxGjeCYwahrLqWm6t4tBE7FFbS1bSC+eumAyKUaW/ZHbW/vQRG4I5KwzdsIz
         sbXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992000; x=1783596800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mB6dT1sg2Ybaa5Hs7LVNjTaOvI0XuElN0JvSfPFbp8Y=;
        b=D5efuTFeoYnbRmib3ddIb9eLv8eHXusVJlZDPbpsXcdamEV2TWSEal/K3enRS/sEnR
         3iURSThN8TgsyNEgfnryGByL0F2yo0FzsAkZbcnA5ahgtQWDWjAlXFR5+QSaT/I2ortd
         2MZJbNRbV/sVGxehFDI8BN6qos/RHBj5CxElU5D8j8O9P1vTqYTI+0VsIJWZjTUph0fl
         Jh/9beKgDbsKNNmZgH30i/rL/vmUWZ5i+npj2kSbXv+Up8zsSvcJBeDceat1kbah76cQ
         idX6qFlxRs/Dindh6Db8gaMHXPBSPnGLQEvfFr5Eekq6VPIHU4F+trS2LztRLwssacXV
         kE3g==
X-Forwarded-Encrypted: i=1; AHgh+RprixAVjgFjVMSWImc+0pDWUBvEZuhng/9wxKxWcOjXw6hObA48ntQNf+ZKR2b4RFJxlksnyEmAoA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwYEdkRTpksHLZ1weYxZGPbrguKyW2SnzkmyhMfrdLJZkQMG4Gv
	vNZdvvM5elwzpWZR6BeAoBRIySoQUYagjjLr1Gji4HVE+V66ukLVqn9BHn/TFbug+mAMe9M9xWf
	4x6p3BL6irfPqDRihjQP6gAcXS/CImHMcEEuTGzcqoA==
X-Gm-Gg: AfdE7ck6VXUixYN0u3K9IDpvGGKmNAEj6Ivt7GilK17hiIv7kikKCMV4P1TKQN7vP/9
	SCfoDaTQ1F0wOrEB0TEiAyAHhkr/w9Y5iGx4PcwL5L3JN2CO1hnM3e5eGlZnHSY4WBG4HGgNvKt
	rTxMAdcGhluP7mLyX7c1ZQIb7l+8XuunDnE50oubNoT8GrVZszzii+JEOy2I9MZkm3e2ZGr+Nl6
	tm9vT/iXEy3L2iyjBNUDoHexlDucD8j2tZYqpygLJP89tn2b5LfxhZp+ttvIwF+golaVA8=
X-Received: by 2002:a05:6512:3190:b0:5ae:b764:3b91 with SMTP id
 2adb3069b0e04-5aec62df20dmr1373238e87.13.1782991999979; Thu, 02 Jul 2026
 04:33:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260608160606.1134881.c0f6c631029b.dm-ebs-discard-dirty-buffer-resurrection@trailofbits.com>
 <06985f1d-436a-9dae-b984-65e95dd0572b@redhat.com>
In-Reply-To: <06985f1d-436a-9dae-b984-65e95dd0572b@redhat.com>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Thu, 2 Jul 2026 07:33:08 -0400
X-Gm-Features: AVVi8CcZkWqQ74c7lhQOcCHYloOJ5kfCzYM5EHYQUZkABQH_SoQAa5KYdB77I-I
Message-ID: <CAE+C+DbvRB_-wFEGE_LVRPc2KC9-2XjOa+zFOGiFqoFjJF6aDw@mail.gmail.com>
Subject: Re: [PATCH v2] dm ebs: drop dirty bufio state when discarding blocks
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, 
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2026 at 3:54=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> Hi
>
> I will accept this (and the other patches) after the upcoming merge windo=
w
> ends.

If I am not mistaken, the merge window has closed. Should I resend the patc=
h?
