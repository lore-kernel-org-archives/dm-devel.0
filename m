Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C696F2DEA75
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.193.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773856701; cv=none; b=f1nl2eWyGi0fifOn8eLh43jnG7DhvI3D3da1j45XKTgtU535qJ+932d0VglW9v2/QCb+3dttYNSM/1vclo+JOqNOW40vDQ882p5zXSadz78Pv10MSQjl1zLWBC6mOBrukbp0T+yVY6uKSWzjha9JiGmhLQflWCwlIhdwlyiheTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773856701; c=relaxed/simple;
	bh=3oPYuZYcXSax5GlDz3u/PFJeUVZYAljHZ+1t9fgJwXs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BBD77I9weg9r9n3YVYWfl2pIxFra4rIlIKTQt0VNiujSREK8X1dByVZ2NVmFQfqnbe5KHyN/hVBhoFF7frolVPYNsx4jnNfuPAF4W2X3C6YL2Zmey6tnC7QBl0OOwLledmATZZv6E7g7Dk464Ang7MYcMxsF1VxryOZcrXDSyv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=korsgaard.com; spf=pass smtp.mailfrom=korsgaard.com; dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b=FLt9tjj6; arc=none smtp.client-ip=34.202.193.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=korsgaard.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=korsgaard.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b="FLt9tjj6"
DKIM-Signature: a=rsa-sha256; b=FLt9tjj6cL/i8jSb0L/4ZPTVPNzq6i8+VMq3OP1Bfg3gI3a8TX0ymC8xLThq6LSEuFpco44Xf1uxKnsBcE8YORMLtTEzPH7a4PbeMrrqZwjYcFvXOekuQyHZSpMGqqhoDXDDqZhM6vXJITJpQMh9xH+FRXpaxmx9amSJSSK5ijw5LY5KCoDeN/MEDy42512OG7S5sWxG4tBXXgsgWntXPVrTBEpv3LkxCR6ueTV/5KRfTXQOXlielgbfbFrBGOV/Qx/zllCrnPY77Mot36dRE/rUZkv68WNMXcJJlNefhl6cDeQK9bAwofoSN+uMXVE5Aq2FRXIf6n2s7bQdwAENaA==; s=purelymail3; d=purelymail.com; v=1; bh=3oPYuZYcXSax5GlDz3u/PFJeUVZYAljHZ+1t9fgJwXs=; h=Feedback-ID:Received:Received:From:To:Subject:Date;
Feedback-ID: 21632:4007:null:purelymail
X-Pm-Original-To: dm-devel@lists.linux.dev
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id 302637028;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Wed, 18 Mar 2026 17:57:50 +0000 (UTC)
Received: from peko by dell.be.48ers.dk with local (Exim 4.98.2)
	(envelope-from <peter@korsgaard.com>)
	id 1w2v9Q-0000000873l-3eiI;
	Wed, 18 Mar 2026 18:57:48 +0100
From: Peter Korsgaard <peter@korsgaard.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Guillaume Gonnet <ggonnet.linux@gmail.com>,  Alasdair Kergon
 <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,  Benjamin Marzinski
 <bmarzins@redhat.com>,  dm-devel@schwermer.no,  chanho.min@lge.com,
  jaeyuel.im@lge.com,  dm-devel@lists.linux.dev,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm init: ensure device probing has finished in
 dm-mod.waitfor=
In-Reply-To: <46a69472-84a8-c02b-1879-af30da13523c@redhat.com> (Mikulas
	Patocka's message of "Wed, 18 Mar 2026 17:36:25 +0100 (CET)")
References: <20260317213229.18371-1-ggonnet.linux@gmail.com>
	<46a69472-84a8-c02b-1879-af30da13523c@redhat.com>
Date: Wed, 18 Mar 2026 18:57:48 +0100
Message-ID: <87y0jpf2ar.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

 > Hi
 > I staged the patch, thanks.

But how does it work? Do we still need the other wait_for_device_probe()
call? This looks nontrivial, a comment would be helpful.

-- 
Bye, Peter Korsgaard
