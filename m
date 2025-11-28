Received: from artoo.va1der.ca (artoo.va1der.ca [66.70.202.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F101C861D;
	Fri, 28 Nov 2025 01:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.70.202.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764291654; cv=none; b=gYhJuqmFar+l2AWp4TL7ZW6Lvf2aTxTH9hx7oOHSCrulUihpshakr2BiUomqThRk8OQWbnJB+7sKoGDKTkOfVl6B6MWv8R77ROdtCifTfCYzakgeB8mkgfCAgZrb2XDXCzishmt4JVScSRwctjzd6Z59GsC6zjKoclB3TXnEK8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764291654; c=relaxed/simple;
	bh=8ZMHeSGKTe7vN0wMOroGc/AYGvdF48EtzU7jpTtq5Vg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=S1zxK69st30zURD25O7h5NsRQSueIt4ZcDXTL9MhCiqtPsbaNamR5F1E00P1jp3MIYl2QVhjJ3bNLJ4Yl6yZpKKczXuWTEpST68cUnauPyYlNsRA8aiE75JxtTjRayygKlBnFLSArymQa+zn7haMHIvcCWM/s/F7f8XuJ0sL7bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=va1der.ca; spf=pass smtp.mailfrom=va1der.ca; dkim=pass (4096-bit key) header.d=va1der.ca header.i=@va1der.ca header.b=R31b8ACs; arc=none smtp.client-ip=66.70.202.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=va1der.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=va1der.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=va1der.ca header.i=@va1der.ca header.b="R31b8ACs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=va1der.ca;
 i=@va1der.ca; q=dns/txt; s=rsa4k; t=1764291083; h=mime-version : date
 : from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding : from;
 bh=5ehl7XowOsgc/Hdy6CsvYc8pNeY/UToxQM+P3jbw8Rc=;
 b=R31b8ACshIZzZrktnZnDDJEipbXH60inGf6csxDL+9JH+B0UnTulOITG8jgdR/YsP4Mq6
 p5smPfxCWpQol1uZ+E9d7MofkrNx5eUbxbO7RUL0P2Nf9crsSg/Qdj/TzhlzmoLXFomns/G
 fULSPxW8wmxbqVEtSXEW8SKMTvWnEF/nmHh7H9+Ghn0IoNy16GBxpuIWJIF7SyWPS8xctUj
 BnETTMjtowC1XD6bqkRc93KASGl1VfL3ua1Kbr4EOne9cyT+VX45JKCwV5P2RahCPT4rz4e
 d0hCDz3JCwkqdq3rQVcyT/aLHqtWQD2Nwr3GGNVSfXvjgEJkOAP8ohk0X8FHZAB4MOXZ/i9
 VdZSc11M89rVguO87aXQgzMBUAu7A8XUMQICPkJKLpb0CSI8K9kSSutbvr4UTfBP++mj9Xo
 VYcBvV0CToKntXwH4U/rOXq/cULbuqZEp9bx8Rujcfb7J17rg4tXYiusGJ9FEFHkL4sOsrQ
 UkP9Kl2FOEc5RMeiPz59jYThMKQ/GU/PQFGfk/On9Cu73eGJDrx0UsceZKUhmqUb5Edcy5e
 eN7SyeD4jPCjMgen5ecrcJNFKczO/vpmhvsADg8bskVsE4BxNgVsNXEyari1UHmf/ItJgkv
 l/MzRLvaxSK7CZ4ibWFqafCpzQFMFi41oVAmW4exNnQdYE=
Received: from artoo (artoo.va1der.ca [66.70.202.72])
	by artoo.va1der.ca (Postfix) with ESMTPSA id 877083E5B31;
	Thu, 27 Nov 2025 20:51:23 -0400 (AST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 27 Nov 2025 20:51:23 -0400
From: Kurt Fitzner <kurt_cryptsetup@va1der.ca>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Aaron Rainbolt <arraybolt3@gmail.com>, Milan Broz <gmazyland@gmail.com>,
 linux-mm@kvack.org, cryptsetup@lists.linux.dev, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, adrelanos@whonix.org
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
In-Reply-To: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
References: <20251111231835.1232ad8f@kf-m2g5>
 <2b8b83fa-5cf5-4f97-b796-0c738ce3a548@gmail.com>
 <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
Message-ID: <804601778974c504d42f4423d335a94d@va1der.ca>
X-Sender: kurt_cryptsetup@va1der.ca
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2025-11-27 13:54, Mikulas Patocka wrote:

> Encrypted swap file is not supposed to work.

Do you have a reference for this?  The concept of encrypted swap files 
has been a valid workflow for a very long time.

> So, this is what happened to you - the machine runs out of memory, it
> needs to swap out some pages, dm-crypt encrypts the pages and generates
> write bios, the write bios are directed to the loop device, the loop
> device directs them to the filesystem, the filesystem attempts to 
> allocate
> more memory => deadlock.

If it's the filesystem trying to allocate memory on writes to a swap 
file that is causing a memory allocation/swap race, then any write to a 
swap file would engender the same result, regardless of encryption. The 
encryption layer is redundant under the failure mode you propose.

I can confirm I have put kernels up to and including 6.14 under heavy 
memory stress and have never encountered anything that feels like a 
memory allocation race.  All my systems have encrypted swap files.

I can't speak toward later kernels, or any bugs that may or may not be 
presesnt, but I know of nothing to suggest that encrypted swap files 
remain anything other than an intended feature.

     Kurt
