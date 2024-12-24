Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EB71946A8
	for <dm-devel@lists.linux.dev>; Tue, 24 Dec 2024 22:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735080153; cv=none; b=GvRZWHUAoERizpTDNZ5fjf2PHXYPpsChou4OqXYv8KX7vJRT7b0VUeF+QADq7wzhDX2aXEsFHdw4GvF0Uxxe7wCiwwk/vqhywGuMA1IlXmrCVQKDz1BkVHHi160knR0eLmWlttzLrAz1lHu/a0B3AnqGWPYeHEutBG3HAaYU1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735080153; c=relaxed/simple;
	bh=K8ig6pkFQ3cnVKESEWnVAmSC4k6wZ/nk6iODVwwKRYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EpJpcr1Zf0n1v/mpaf/BmuyGlB9ocUSLvblynW/IyTvli0EL7LWKlJQoQ3/spS1y1MqnP7s5xrHi0NniiDIkGJECBBLPqQCctjK/8onx2iUSqR9pSfDyRYIqxSsw0lJ+3enX34orsUGjuq/EBPgTLzoxSqqh4fE0hYJDJRv6AuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=wE8KaOf4; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="wE8KaOf4"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id PzbDtL94W09RnQDbctep0q; Tue, 24 Dec 2024 22:42:24 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id QDbbtpOu6827nQDbbtA1eu; Tue, 24 Dec 2024 22:42:23 +0000
X-Authority-Analysis: v=2.4 cv=GeTcnhXL c=1 sm=1 tr=0 ts=676b38cf
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=GtNDhlRIH4u8wNL3EA3KcA==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=NEAV23lmAAAA:8 a=oOqFFZS7AAAA:8 a=8gwe23exSknoF3-mrEwA:9 a=QEXdDO2ut3YA:10
 a=9cHFzqQdt-sA:10 a=PUnBvhIW4WwA:10 a=cEm2zIq8e6p76x6pLsf5:22
 a=Xt_RvD8W3m28Mn_h3AK8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=na2/0I+XXDoadhe2QTikJdF+DpeX36K5jAfWFUya8rQ=; b=wE8KaOf4zXbKZ7yWtXtAWc1EyY
	8TYTKZjfaFU5owzlTFbsimAUHnLnjHKNEQ9THMKMdjskKQG3arjgBiRMuuxO95gjnz7UIVxoS2MPa
	FvmtEWi9J8fDQZJrgwbBaaU/mYwbmsGuhGlSDD5DQ9Mi0WS03bG52w2r3CCA72yXM3MwLvv91xs6/
	jZLrRrSr/5FWinbHIz/nOHwn2fQb2ejpaWeBmFuXw+wDCYf7bMc04PLZV3gUWSr1n2Z0DUvNLI50F
	2X2/v6+x5B8nb6veE4kY9Ma1k5Ev+Vvmlx2SsDcxf9PI56nEPHK+v1X/diMgLB78gqJRVIEi7ZqXo
	w4Suying==;
Received: from [177.238.21.80] (port=33898 helo=[192.168.0.21])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <gustavo@embeddedor.com>)
	id 1tQDba-002hf6-0r;
	Tue, 24 Dec 2024 16:42:22 -0600
Message-ID: <d38e99d7-1f24-4c7b-87de-111c345b02cf@embeddedor.com>
Date: Tue, 24 Dec 2024 16:42:07 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: change kzalloc to kcalloc
To: Ethan Carter Edwards <ethan@ethancedwards.com>,
 "agk@redhat.com" <agk@redhat.com>
Cc: "snitzer@kernel.org" <snitzer@kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 "mpatocka@redhat.com" <mpatocka@redhat.com>
References: <Z7XWRfRi3Fn25wT4Dg19JRN4xrKcCt3TxaxZwsR_0LDR2C6fQxCiLrsMBfJg8f_ZqSAx3u6aPm-TR02dC6bLpMmqSI_jp_ADiJ_qW_27puk=@ethancedwards.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <Z7XWRfRi3Fn25wT4Dg19JRN4xrKcCt3TxaxZwsR_0LDR2C6fQxCiLrsMBfJg8f_ZqSAx3u6aPm-TR02dC6bLpMmqSI_jp_ADiJ_qW_27puk=@ethancedwards.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.21.80
X-Source-L: No
X-Exim-ID: 1tQDba-002hf6-0r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.21]) [177.238.21.80]:33898
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGGlOJ7zhdQrxBL3/jZtCIW7fL17SPae/FaYZpDhBHnPcS+xD0g/w5LCHtJkZp++LtynJAJNXEf16FLEqJuCnZCThwYn4osuKGdAurHszaIwysDLieQp
 TUEgWYRWivdhpgrw5Hh/4eRQTG9DERA4x0bikDQEfNOjQAsHJVBoNvMJ4h4Ol+YU7rJ3ZPc2oAHJUYhXq+5uOb0vwjFkWhbgj4E=



On 24/12/24 16:13, Ethan Carter Edwards wrote:
> Use 2-factor multiplication argument form kcalloc() instead
> of instead of the deprecated kzalloc() [1].

Thanks for the patch - Just note that kzalloc() is by no means
deprecated.

> 
> [1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> Link: https://github.com/KSPP/linux/issues/162
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

-Gustavo

> ---
>   drivers/md/dm-ps-io-affinity.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-ps-io-affinity.c b/drivers/md/dm-ps-io-affinity.c
> index 461ee6b2044d..716807e511ee 100644
> --- a/drivers/md/dm-ps-io-affinity.c
> +++ b/drivers/md/dm-ps-io-affinity.c
> @@ -116,7 +116,7 @@ static int ioa_create(struct path_selector *ps, unsigned int argc, char **argv)
>   	if (!s)
>   		return -ENOMEM;
>   
> -	s->path_map = kzalloc(nr_cpu_ids * sizeof(struct path_info *),
> +	s->path_map = kcalloc(nr_cpu_ids, sizeof(struct path_info *),
>   			     GFP_KERNEL);
>   	if (!s->path_map)
>   		goto free_selector;

