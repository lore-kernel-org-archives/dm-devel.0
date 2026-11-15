Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.205
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794769184;
	b=rdghDfSjVvx4E7bVp6UHHK7AigN6Z3juvEGXGl82lbzwuIk8YShtJb+uN5OuKeednEIM
	 1udfFn/vJPkZ2/9pDHFqcKsakxw/G9BlTL22mnMzhq/cIvBp2U41yTfJSKSF1+27Jmyzs
	 c6fvjNtXyoyTDMu+9WD+j1svGNSMskyqckZsLcxazgUctQkCor9kxYAFkKdmkZWCfayLT
	 hEbLSjqByAK/RGbJpuMSSaRkYaAnEwz18W3O7O9K1kEvYUjE7JPldQp7hCq1NN6SAnm1s
	 /VByGcLYIzgPOysmOtzIOpMk7R5MJ8c+FRfpWCpV0B0VKUxgWTl+qjmxoatFpMzEovg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794769184;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=/ObX0z92vMMwlVFIRqUffs3xnTOINmuVmFY1k0W8fVs=;
	b=NtlTJ28D5a8Os/cs1bqGmhYzqxw1kKFcJ9Q/dvqRTtiIOFkSM28GQqDVCQNicUAjwMGL
	 C2HXKnHltrWWQ4UPmxfWUKpJu6z7CoYCLa+nurUwF7vdBBXTGR1WD6AMz2deuJzoLl6Xz
	 e2pkO0S/w3/C66f8Eun5nOEroZ+ucrPBx8mRBEHhyCzosVXMCVIx8fwgVtLcaWePvo+tf
	 kTSFN6b5Qv57PcLbyLmyaFfX5pdxnkqN1ZSow4MV/HO0AdFZGWv3FWpyhkh5OwnKyIJiG
	 pVPNoOc7n3pMCrabkjQ1sdxbiw55hfknGiXFzJH3UGa1DmGjE7/9mSi5BDZOqyE6nBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m+b548ra;
	arc=none smtp.remote-ip=91.218.175.205
Received: from mta0.migadu.com (out-205.mta0.migadu.com [91.218.175.205])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C67606A31F
	for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 18:59:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2C67606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m+b548ra
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=r3KwoUnK5Cpd0P3vAYLdMdF/mK6lClj/XHu1EZl9IQk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794769181; v=1; x=1795373981;
 b=m+b548raxrJiL5rD83zD7iSPQgSwYvP9WuI3cFiQTKBr3XJHYP/FHz5KmuWZu1gJvkA8UAT4
 vu9H4hYculmihRzuin0ZLl5mZUFsDx75A3Kds86gWoNoOgCYctsPIDwkOf4c8gNX/k8lwDXPHbN
 9+yv061U0MSvBjdwchDItkzg=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by mta10.migadu.com with ESMTPS id 6c594d68444740c8;
	Sun, 15 Nov 2026 18:59:41 +0000
X-Mizu-Trace-ID: 6c594d68444740c8
X-Migadu-Flow: FLOW_OUT
Message-ID: <01eac6bf-8df7-4e7a-8cc6-93e013750bce@linux.dev>
Date: Sun, 15 Nov 2026 18:59:37 +0000
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 00/29] Native SCSI Multipath support
To: Laurence Oberman <loberman@redhat.com>,
 james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de,
 michael.christie@oracle.com
References: <20261108204733.557995-1-john.garry@linux.dev>
 <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <9b90edc29d5b3be49f5bd0e0ecec5f1701e089bf.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/26 20:19, Laurence Oberman wrote:
> 2. ANO paths are ranked the same as AO paths
> 
> With the ALUA state corrected (by writing "activate" to dh_state, or
> with the fix above), I/O still went to active/non-optimized paths.
> scsi_multipath_sdev_init() sets mpath_device->access_state to
> MPATH_STATE_OPTIMIZED and nothing updates it, while
> __mpath_find_path(), mpath_round_robin_path() and
> mpath_queue_depth_path() rank paths by that field. Only
> scsi_mpath_is_optimized()/is_disabled() read sdev->access_state.
> 
> With numa, the first path in dev_list wins for every node, and
> dev_list order follows sd probe completion, so for about a third of
> the LUNs the current path was an ANO path. Example, LUN sdn, reads
> completed per path for a 2000 x 1M O_DIRECT dd (:0/:3 AO, :1/:2 ANO
> at the time):
> 
>    sdn:0 0sdn:1 2000sdn:2 0sdn:3 0
> 
> Every read went through the non-owning controller. From the code, for
> these LUNs the numa recheck of is_optimized() fails on every I/O and
> __mpath_find_path() picks the same ANO path again.
> 
> With the change below (a template callback so the selectors use the
> live state), plus the scsi_dh_alua fix, all 30 LUNs pick an AO
> current path at boot, and on LUN sdl (:0/:2 AO, :1/:3 ANO):
> 
>    numa         2000     0     0     0
>    round-robin  1000     0  1000     0
>    queue-depth 18039     0 13961     0   (8 parallel dd, 64k)
> 
> No I/O reached the ANO paths under any policy. This is a test patch to
> show the problem, not a polished change - feel free to fold it in or
> do it differently.


JFYI, the work which I did for ALUA support a while ago is here:
#https://github.com/johnpgarry/linux/commits/scsi-multipath-v7.3-v7-alua/

I don't think that I shared this previously.

I do notice that it would conflict with your work to do some 
centralising of the ALUA RTPG support.

About the NUMA iopolicy - apart from issues in this series with not 
checking optimised/access_state properly - it does seem less than 
optimal to we only favour one device per NUMA node (when all in same 
optimized + enabled state). NVMe multipath support does the same. I 
suppose that this iopolicy relies on us having one device/path per NUMA 
node.

Thanks,
John
