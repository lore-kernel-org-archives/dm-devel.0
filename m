Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DFC344036;
	Thu, 30 Jul 2026 02:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785379236; cv=none; b=W3ggMloQxYxnfyMrs8QaiUid03iGYmLahgDSMRLl1C22jY+v5zc6KpzbFdIPawf6xXlVaO60aE3yHe45Gcs8tlc5Z3hnMJEdXfC+XPMzTMq4pj1Kl7x2WrRIebS31tkVI1YvW7did5jRGS1sC9eRRolYRokxr1B1oRC9n/bXags=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785379236; c=relaxed/simple;
	bh=dlVEiGWbVDpLzhHbvzXL7iCBJVRGtApAdTfx7u1wMyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XK1JCMAD2f+YCAa8dd/Ke/jESrj/63IKYBQ/OoIcfrBBKPfRBiYiehJETfsnT6MqA8tdq2yNodHJOvP88jL2ZqBb9vZ/OO0j4zU3TQ5SkW3s9Wogn/d1e9EHrovV6SY27uMwi4Ym8z27HUEXe/zuezOmzDNImD8Xx+IadJIFrcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3gV7g/i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3gV7g/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2964D1F000E9;
	Thu, 30 Jul 2026 02:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785379234;
	bh=+hJQb7xL92cTTVCPfDnbFg/guvenGOByT0A/urmcvCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3gV7g/iCtkGkANiV5+nDKl+USTizG4Fhn6u/FSzHEzIRZNAxrx4KzyS+Pbx7kaTA
	 0O9Qx7mbOPJhtKwNSQTFVY2WRn0P+Ymtqp/yh9txnUeomg60n9wl7X4iizex5/xkGS
	 b7TyNzOUfIJjeNYUf36rsTVAyZ+MVLGVYj5VyxfFVRQqYaf/ocQ47HL0iH2BTxJyg/
	 SM0XWLYOxCAaDsXPTycfCm8qU2iMD55gQRDGhcDGOSzs5r3tSkN6Yn2GXMxwkPejdZ
	 dgJDp14qhHBNx2NNvjc9P2I6ZEtTElSPh3NqJE3ojoyo/g3BLVjuJCEI29SbjMlhut
	 Lf8z95S3dTxEw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	dm-devel@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 6.18 0/4] dm-verity fixes
Date: Wed, 29 Jul 2026 22:40:01 -0400
Message-ID: <20260729223316.stable-0005@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729051909.62106-1-ebiggers@kernel.org>
References: <20260729051909.62106-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 6.18 0/4] dm-verity fixes

Queued the series for 6.18, thanks.

-- 
Thanks,
Sasha
