Received: from vimdzmsp-sfwd03.bluewin.ch (vimdzmsp-sfwd03.bluewin.ch [195.186.120.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14751C8C7
	for <dm-devel@lists.linux.dev>; Sat, 16 Nov 2024 16:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.186.120.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731774468; cv=none; b=WA/kxOC9nh1UZ8MCXcxKHm7xqbX6pZbPOVvDbrkFf1b0pFgyxDRyd3INZnqMRu43qWzCTQOtoG5ITobikotD6mZM0i+jJYFRzdGLl3n+fnQE+SBXJDPBT/CpgeaVF04FZMQ5iNhZ5b4eKrbKB9oJscxAttquKMX3BDGNtV+C57I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731774468; c=relaxed/simple;
	bh=Ap1V+flju7WF9n8iu1whLwyE0FC9Y0Mh/AgMESSOg3c=;
	h=Message-ID:Date:Subject:From:To:MIME-Version:Content-Type; b=b3cWg+eCQtt48tpt6/QjQmQECoktInWnZpMqBTvfllXeXgv/JDfGMZJjJZkEukL0RZdMTvCFV/aVaY7ZJonJbon/lAWf9OUzmPHfrZEz1fFvaG96KGdCaUJKASFLd2VoLdjSFZjsx5ZjF6qWYHLPjFrV2ZSK+bM45XLDPg/Dpm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluewin.ch; spf=pass smtp.mailfrom=bluewin.ch; dkim=pass (2048-bit key) header.d=bluewin.ch header.i=@bluewin.ch header.b=dd6CtDHX; arc=none smtp.client-ip=195.186.120.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bluewin.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bluewin.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bluewin.ch header.i=@bluewin.ch header.b="dd6CtDHX"
Received: from main ([84.227.21.131])
	by vimdzmsp-sfwd03.bluewin.ch Swisscom AG with ESMTPA
	id CLc7twZtObRrHCLc7tg9nu; Sat, 16 Nov 2024 17:25:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bluewin.ch;
	s=fxzs-2048-20230414; t=1731774335;
	bh=shkLmTF0qBO9+4Jq+W472rm87HKu5sJsJWF7uc6KS2c=;
	h=Message-ID:Date:Subject:From:To:MIME-Version;
	b=dd6CtDHXyoqs1sRsS93eRlB6uu8wTzt7qLYpSc9SJ9UINq6U754tUT167HrbXbXdn
	 ZSUShubM7c7hxdVLUaNjoj8ld6ZL82GhB8UEwllif14ZzvzDdRGWq+rYvTNaeWNTSW
	 gEo376FKSDPyVKeMy2Gd3ySZZUPiiyp8K4UbJfrmSxsZqNQ+ftNBDZ7d4gzg8Izj1W
	 mdrb2uu8+4q5WK9Q7Fe5unkEQpnUfS/AiauDzzdue9MoNxUzH5FWO/YbtPpSx7+fdi
	 CNb9X3Apez403xNkg4/QJJ1NDTNzRJQc6TB5QLKghOgivmvl+unDUNNnJqvTTxmuVm
	 ON5OIKI9BhVLQ==
X-Bluewin-Spam-Analysis: v=2.4 cv=PrQwbBM3 c=1 sm=1 tr=0 ts=6738c77f
 a=ig9bzvNBGao8Dw96AwO3EA==:117 a=ig9bzvNBGao8Dw96AwO3EA==:17
 a=8nJEP1OIZ-IA:10 a=VlfZXiiP6vEA:10 a=LLPZWm0_0O8A:10
 a=3KyxOFvct3VDziUUCqwA:9 a=wPNLvfGTeEIA:10
X-Bluewin-Spam-Score: 0.00
X-FXIT-IP: IPv4[84.227.21.131] Epoch[1731774335]
X-Bluewin-AuthAs: public0x05bf@bluewin.ch
Received: from 10.235.2.12
        (SquirrelMail authenticated user public0x05bf)
        by main with HTTP;
        Sat, 16 Nov 2024 17:10:53 +0100
Message-ID: <d2d0c5ba9f9d28cdd435e0bbf951de5a.squirrel@main>
Date: Sat, 16 Nov 2024 17:10:53 +0100
Subject: Extending "thin_trim"
From: =?iso-8859-1?Q?=22Thomas_Br=FCcker=22?= <public0x05bf@bluewin.ch>
To: dm-devel@lists.linux.dev
User-Agent: SquirrelMail/1.4.21
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-CMAE-Envelope: MS4xfCAT876bft5GJXPKqPvD8skfM9kNkj5J8mSxR9dBPH40GEEdeiJwa78OgjJ0Y7oKfTT24YGbAzvH00X7PmBJHGXODjDon1lI/898dT86QLxuIzhTWFUq
 gCK1ED9tcQoOBO+sWRH/gG8z2K6Kt7XoHkwWI376GJVDat7qSNRmTFAVlNOpiMQLt3Eu2baqATafZ+8xoLXLj1mgNd2iJlTsLgovD7HDbNiqUaVjQMJhNn/z

Hello developers and others,

Intro:
Lets consider a data device of an thin-provisioning combination. On it, some
data blocks are allocated ('by the metadata'), others not. (By using a thin-
provisioning combination, some data_blocks get allocated, then you write to
them, their content is probably not zero, and later, such a data_block is
disallocated.
"thin_trim" discards such unallocated data_blocks on the data device.

'Extending':
It would be fine, if "thin_trim" would have an option, that instead of
releasing
the blocks, "thin_trim" would write zeroes to these blocks.
--> REASON:
e.g.
* if you backup a data device by copying it to another device e.g. by
"dd", it
  would save time, when unallocated blocks are not copied, but just 'jumped'
  by seek (by specifying "conv=sparse" to dd) ("conv=sparse" does its job
  only, if these unallocated blocks are zeroed).

* I have an utility, that backups a data device clusterwise
  (cluster != data_block) to a cloud. To save space on the cloud, clusters
  which contain only zeroes, are not copied to the cloud. Here too, having
  a data device where every unallocated data_block is zero, would be fine.

Thank you for your generous device-mapper efforts.

Sincerely

Thomas Bruecker
Wydacker 43A
CH-3083 Trimtstein




