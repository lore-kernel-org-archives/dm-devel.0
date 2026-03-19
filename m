Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA3739FCC6
	for <dm-devel@lists.linux.dev>; Thu, 19 Mar 2026 10:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.193.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773917649; cv=none; b=UZPRA4RZ4/IKnVaxXCXnY4xSxIAk7gpHYvF6d5ogGLo8V+CF95ZkwnomoaYTofZOCH0/H3RXV3FBE5jlhyf290C9ccKszGASD7kwPDzsK56pary/bdrXMkk5S+Nszjx36yFv+S/40eGjzI0InBDUUCWNH/xvXwYtpQml8ULCaSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773917649; c=relaxed/simple;
	bh=OH95YwyO6vmiYlWPK79PYyKfAz3qPAVN1586YDIJ/nc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CGKyeGTYelvYidfzl8UZegGP7XqL4qyfwVRHNkU5Wn0G/4Gs2M/saVWdK1/TxNi3Gm/0a6mgsrtA3kISP+K3Lk3+/m4CAoDwIz5no5PkA/pXGZMdOBwyjIWhVfbx8/bZP03KcNIGhdY01yTsFZc4leWvdR6FT5S56BKmb/iGUV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=korsgaard.com; spf=pass smtp.mailfrom=korsgaard.com; dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b=QoaB7M+e; arc=none smtp.client-ip=34.202.193.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=korsgaard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=korsgaard.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b="QoaB7M+e"
DKIM-Signature: a=rsa-sha256; b=QoaB7M+eMJneeHmDw/BkYSOhH1LxyJLb80t5wkgItPX7Fr00Z9qVMpFTZ+DIgNPjLTmwpgwc9tBPp8ukkPSHhWk1vXNEMsJeWGauwQTs7vAIHQjDqdSsB6IgxM0DUPD+oJVPkfzGZS8NYYN3Q/tGv+foolOjqVIKye5hkqAbPCTlK1gTe7cLJmsZvjGxqc9ApINcJ9v+Yh4CA6EMs68g3DpXG4GQJKa2wOF5E0UxJw7Piu5e7xZg03RHhDvpYnElfbXdpgqNz7ZeNJb2dBvDzQBfPMJ3Ja+XJuLLqCjKECUpuzXp2XOBp1MTqnWtXWpB6+SD80yQfev+5qHKh9fxOg==; s=purelymail3; d=purelymail.com; v=1; bh=OH95YwyO6vmiYlWPK79PYyKfAz3qPAVN1586YDIJ/nc=; h=Feedback-ID:Received:Received:From:To:Subject:Date;
Feedback-ID: 21632:4007:null:purelymail
X-Pm-Original-To: dm-devel@lists.linux.dev
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id 428043683;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Thu, 19 Mar 2026 10:53:40 +0000 (UTC)
Received: from peko by dell.be.48ers.dk with local (Exim 4.98.2)
	(envelope-from <peter@korsgaard.com>)
	id 1w3B0T-00000009JDM-1jTN;
	Thu, 19 Mar 2026 11:53:37 +0100
From: Peter Korsgaard <peter@korsgaard.com>
To: "Guillaume Gonnet" <ggonnet.linux@gmail.com>
Cc: "Mikulas Patocka" <mpatocka@redhat.com>,  "Alasdair Kergon"
 <agk@redhat.com>,  "Mike Snitzer" <snitzer@kernel.org>,  "Benjamin
 Marzinski" <bmarzins@redhat.com>,  <dm-devel@schwermer.no>,
  <chanho.min@lge.com>,  <jaeyuel.im@lge.com>,  <dm-devel@lists.linux.dev>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
In-Reply-To: <DH6MMYX3TX5Y.R3N3IX6370ED@gmail.com> (Guillaume Gonnet's message
	of "Thu, 19 Mar 2026 09:47:47 +0100")
References: <20260317213229.18371-1-ggonnet.linux@gmail.com>
	<46a69472-84a8-c02b-1879-af30da13523c@redhat.com>
	<87y0jpf2ar.fsf@dell.be.48ers.dk>
	<DH6MMYX3TX5Y.R3N3IX6370ED@gmail.com>
Date: Thu, 19 Mar 2026 11:53:37 +0100
Message-ID: <87cy10dr9q.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

>>>>> "Guillaume" == Guillaume Gonnet <ggonnet.linux@gmail.com> writes:

 > Hello Peter,
 > Here are my answers to your questions.

Thanks for the details.

 >> This looks nontrivial, a comment would be helpful.

 > I think the commit message contains enough information to understand why
 > the second wait_for_device_probe() call is required, a comment would
 > contain less information so I prefer letting the code like that.

OK. Ideally the above description would have made it into the commit
message, but fine.

-- 
Bye, Peter Korsgaard
