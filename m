Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794849991;
	b=0THCXWbGmlliipwa0/d+phKWWcB2yXn4YUxYyD/o6JSkXy4nVIdfKBZuYkz5nuOA8nLp
	 ov+Or5ChQTzSobURr4rPoQiTw4V0ttnY+BuGMsL2dC3KeusI0MYPu9GVZ3NWHAjWs4jtA
	 0nYzP4Xyx4QdnctY+A/GaqQVaICBkNhczmEQbSB1ucspong55A9b7+S8Sc6D1DCZehkfw
	 1xtd2Zv5MVyP6/IjuH1Yh7zqk9mQqZ5W/8fT5yz04PxZKFCuYCERjR6AcskTVxcCgoXL6
	 3gsqLZu1mgCm2RSHdUb5HRhlgNB66dzc/R6DThtCKD34ej4414vOJFMvDdsbNpfh7BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794849991;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-Reinject:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=BcdHd1taYkaSg30ORbTb8vkzWzgF+yZIQTU8Xg12AEk=;
	b=o7iIb/ozAPHYKB5ooALtHikUrFXvHywgNPcBnaBTX3RHrMcIdFLtNtqKSw7n15l626YJ
	 zkEXfy4TZjbI8GHZSv1+wD3ZpCM7wR/4yloJhhY3/MhZ96B1sbLUdqc9tz9oZ9DiOXMQc
	 9QyPMvn5tfAur/Lu0ES8313mUWjxFQYy8jP6Fpl+qkmTGcLGnD7Mz00UQxKR7eUfHQYe9
	 5ChUFHXB/6rlnhGl7ECtWyLRLvpakeLdUAEECbUBBpjCNgatEPjk3DYu6V6voYq0d/Jnu
	 MEkvAmAC/yRRmlBb5xESR4FRFbW64bqENAdXwlHWmqOudmvJ6XRtBVd4e+v1avQHgHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ZAJSkU+Y;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F121606A31C;
	Mon, 16 Nov 2026 17:26:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7F121606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ZAJSkU+Y
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGGQDIA3730285;
	Mon, 16 Nov 2026 17:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=BcdHd1taYkaSg30ORbTb8vkzWzgF+y
	ZIQTU8Xg12AEk=; b=ZAJSkU+Y+qllip2NvMD4FBPVPq1w1n2KCnE+3TerpnE6IU
	kAYupYcyxWCMYk5EQC83M/LgCWycIbCm2HHCtGR4CnKP2OgxXgL6VZ/RmSvfkVPw
	2eQvRRAWeOk/ZYcuHZn0FX6fs2T61MvZrqu/Ssk410C2UB3Fhh4M6azTCG9HkB/J
	8koyqyPyVjVx+m8OQDv43mf9m4JYOeJtv2K65NQbRURFRBMVdIWG8Db35DZItKdE
	FyKwLqNES8KVJP9mdG7bzYxRCjTC+FAbLcjvGSq/OeXoUJVE+BTIPYx2JhzZGzEg
	jJ4PlQ/FY+teq1okya3xZ+iVUiMgvO7jnODrOGXg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hxd2kxcbe-190
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 17:25:32 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGC4va92416721;
	Mon, 16 Nov 2026 12:07:39 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hy3fghqn1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Nov 2026 12:07:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AGC7PII28574136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Nov 2026 12:07:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 596512004F;
	Mon, 16 Nov 2026 12:07:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5FB52004B;
	Mon, 16 Nov 2026 12:07:23 +0000 (GMT)
Received: from osiris (unknown [9.111.42.169])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Nov 2026 12:07:23 +0000 (GMT)
Date: Mon, 16 Nov 2026 13:07:22 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>, bpf@vger.kernel.org,
        dm-devel@lists.linux.dev, fsverity@lists.linux.dev,
        keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Alasdair Kergon <agk@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>, Alex Shi <alexs@kernel.org>,
        Anastasia Eskova <anastasia.eskova@ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongliang Mu <dzm91@hust.edu.cn>, Eduard Zingerman <eddyz87@gmail.com>,
        Emil Tsalapatis <emil@etsalapatis.com>,
        Eric Biggers <ebiggers@kernel.org>, Ignat Korchagin <ignat@linux.win>,
        Ihor Solodrai <ihor.solodrai@linux.dev>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        James Morris <jmorris@namei.org>, Jiri Olsa <jolsa@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Shuah Khan <skhan@linuxfoundation.org>, Song Liu <song@kernel.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Vasily Gorbik <gor@linux.ibm.com>,
        Yanteng Si <si.yanteng@linux.dev>,
        Yonghong Song <yonghong.song@linux.dev>
Subject: Re: [PATCH v13 0/7] KEYS: Replace assoc_array with rhashtable
Message-ID: <20261116120722.99807Ac6-hca@linux.ibm.com>
References: <20261114193631.731615-1-jarkko@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114193631.731615-1-jarkko@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=B6UsQ+tM c=1 sm=1 tr=0 ts=6afb3c8d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=oqTggi8YXqEucMIkv7cA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 9SDoFU1xBjlY7T5jqlYkE5NvUgSVvYAZ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA2NyBTYWx0ZWRfXySetjeLiQBKc
 EAdDHNo72O0OksGdsYjL29Vj0sRRwrd7OAt5trA1PAwA9aCZfjkM1wyE389OTKCAW2ejtNsE+5n
 nmv1x+D2McOwEqkVjobRnrbZLE0nNEs=
X-Proofpoint-ORIG-GUID: j8IPWo5Dc6zrl5qOvKGqoXraeULv805I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA2NyBTYWx0ZWRfX4VweZfbjaATF
 80VGoO/6yW/fNkdJQsV+sfNFohbcoS5tetUDVqFWEPJiRpSgYeb1gFoIhjybiYhoUpjsbrOpguT
 nJ24xMw06y0g4wE14eCuauXZTJn9AZwwyYBI1k4BCMVFgKGxde/2feOszhdxhJWCfvsm00h19SV
 RGQ8YVOjbOKM6Y7UNiotIukHOITLKdhsNHw8xBNnkoFI68IMoAKfRPPf8peWtX4hCR2N7zoPPDO
 95y9f++8XyBTHhdOSkcL8XIsukigqteYd5RBMNEWRmw+53h4/wij8XynGcOxLR2rWrt4GH2n0TD
 x9IZtuh2/1dFiROi58yACUWhEbZaLyGBhWXrAbp1+4/xgUSgCYjpxNRet14nqri4v4qXQ0akzDq
 WT73N7jRe8uQmpCEqjKkld/VLQPIfzrY0Z+Np6BGIJFladspqVhO9ijj/xcZ5C2VmOAODw0S02F
 XH99IWVypDD8hK/nUEQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_05,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160067

Hi Jarkko,

On Sat, Nov 14, 2026 at 09:36:24PM +0200, Jarkko Sakkinen wrote:
> The keyrings subsystem is the sole user of assoc_array. It has over 1700
> lines of code, no test suite, and a long history of bugs, with LLMs now
> finding more.
> 
> This unfortunate outcome has evolved over time by large from the shortage
> of in-kernel callers, time bandwidth and 3rd party contributors.  What the
> keyrings subsystem needs is just a generic key-value store, which performs
> well with sparse key sets. Replace assoc_array with an rhashtable-backed
> keyring index and remove assoc_array from the kernel.

...

> v13:
> - s390/cert_store: Hold key reference across key_unlink(), and ignore -ENOENT.
> - s390/cert_store: Add "s390/cert_store: Read-lock keyring semaphore in
>   invalidate_keyring_keys()".

Actually I had / have a patch series of 15 small patches ready to address
various bugs in certstore, including yours. I'll send them later - a few
(or many) collide with your patches. Not sure how we coordinate this.
