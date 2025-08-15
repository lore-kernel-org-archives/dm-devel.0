Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1FE3009D4
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 11:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755257973; cv=none; b=pS8s5mobitw9rAJEbCcMa7opmqWbPfL+3CTBPOLannUPD6xC3BS36DgyWsJkRrlwF42xa3ETZzyCiHF12QeocBuiFkhh4erEq6Xcrb5c5fUoYJ1775Fp5NXa8mswe7gY+Sm8TBkMs3lWR+iIc9x9d+0r8dksoEBuGbkCFuomhIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755257973; c=relaxed/simple;
	bh=YjpQNjPjc9CrHm4DdNhUTaye3vDfs+m/9iWNf4oUD74=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UVJav8MlfAsmBUN46wnrbRNHtzyjEVpbbG9LVvEGeSSRu436DyJVVob40VKOUn8ec6iftzX2gZlDa7PTRV9YhOMJDSB+rPgk54V/bMJpieO9NhVlH5dawJDhk2xzcjgrrGkOG1RA28Wz7GziRF2zWndZr17HuEkOo+jVFRDkywc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D5iNF+a8; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D5iNF+a8"
Message-ID: <20a5b314-773b-4ac8-b053-25825350b2e1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755257968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h0+vgfUiBeWbjbaAPhFd8kwPcyPcN96PpWifqIAdjTQ=;
	b=D5iNF+a8PLtLfYL3UB0Myzbqo8nRhqP++h3hI/Bi9gzMXBFqeVP67xQs88OSfVcUXEuECD
	j72bUUj7NXEUQO+v4uSM9QW/zWwh9h7jirGgIVQHNv2lQNTcYUISHX7bU601PbhmcD1G7+
	GMKYEmvdMcaPEFBMwYPwY/JxDOngj9s=
Date: Fri, 15 Aug 2025 19:39:17 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BPATCH_v5_00/11=5D_dm-pcache_=E2=80=93_persistent?=
 =?UTF-8?Q?-memory_cache_for_block_devices?=
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev,
 cengku@gmail.com
References: <20250812082452.2041767-1-dongsheng.yang@linux.dev>
 <95c4ed1c-6dd6-93e7-af22-ffc27c824b95@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <95c4ed1c-6dd6-93e7-af22-ffc27c824b95@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 8/15/2025 4:58 AM, Mikulas Patocka 写道:
>
> On Tue, 12 Aug 2025, Dongsheng Yang wrote:
>
>> Hi Mikulas,
>> 	This is V5 for dm-pcache, please consider merging.
> Hi
>
> I merged it to the device mapper git.
>
> (there was a problem with the include file linux/pfn_t.h and the type
> pfn_t not being present on Linux 6.17-rc1, but I fixed it)


Thanx for the fix.


Dongsheng

>
> Mikulas
>
