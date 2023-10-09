Received: from w1.tutanota.de (w1.tutanota.de [81.3.6.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD3239B
	for <dm-devel@lists.linux.dev>; Mon,  9 Oct 2023 00:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="soahkqzA"
Received: from tutadb.w10.tutanota.de (unknown [192.168.1.10])
	by w1.tutanota.de (Postfix) with ESMTP id C132BFBF76D
	for <dm-devel@lists.linux.dev>; Mon,  9 Oct 2023 00:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1696813002;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=bwcZUunJefkQ9vxjJ+ZZTaFS7x7JS6w+m67KJR+erkU=;
	b=soahkqzAJxz4a2NbUHbe8TXfIM3cVQiYiYTzJ8srh5KEyIxmaAf+AmAb+AaK2MXO
	AIfC+LvCwRfvsTpvQK+ikeP4rNQKdbMC68IM2bXFxm38k86XaC/+A5hpitiEh3Bh17o
	N428NlfdiKUTsHE1A65yZO6e+sOFv8m+No0wYlCbwNg2elahnVqMTT6rQg+De4u8yoO
	FAZtYoFVavajusvC7erFNNAEzLoFLiCMhPur0ipOc/mq0wN1jalrKf/1fQLZzgTf+Lf
	ObNFstHtPggP0rPDGriu9mtgLXMceRPvlnuQlm71NFt5qLK+TwFAEngUXX3QGnDFdAN
	RiHvgcw7bA==
Date: Mon, 9 Oct 2023 02:56:42 +0200 (CEST)
From: charlesfdotz@tutanota.com
To: Dm Devel <dm-devel@lists.linux.dev>
Message-ID: <NgGvkdW--3-9@tutanota.com>
Subject: Feature Request: Device Manager Fake Trim / Zero Trim
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

I would like to request a new device manager layer be added that accepts trim requests for sectors and instead writes zeros to those sectors.

This would be useful to deal with SMR (shingled magnetic recording) drives that do not support trim. Currently after an SMR drive has had enough data written to it the performance drops dramatically because the disk must shuffle around data as if it were full and without trim support there is no way to inform the disk which sectors are no longer used. Currently there's no way to "fix" or reset this without doing an ATA secure erase despite many of these disk being sold without informing customers that they were SMR drives (western digital was sued for selling SMR drives as NAS drives).

However it seems that some of these drives are smart enough to mark sectors as unused if a sector is filled with zeros (https://old.reddit.com/r/DataHoarder/comments/g7lqaz/). So I think a device mapper that could emulate trim on these devices by simply accepting trim requests then filling those sectors with zeros. It would make a whole class of hard drives significantly more usable.

Sincerely,
Chuck

P.S. I was directed here after mailing the cryptsetup mailing list so I hope this is the right place to ask about this. Thank you.
