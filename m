Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794132110;
	b=UmhvIqeZh0aX198l5NqqalnxK4XTcim+oHw/NP88tIuQbj9x0cxuKcJq0lc6Z5WqivIU
	 hCseB/eUugRNnzC2126H7eaZBxUP5O2Ebq/Detn1e8JlUJOKeVqHPRrQusYgM346zVsNs
	 DiNB4xHtTF1dfxx7mYDjpHt/1WX+0qdXQAM6r9f8nAH2lUkx866kc6yDQCuk74ERgtYFv
	 16TEiYEMUQ7fJK5DUrLeElz/76bRl/H0KaHTF7jFI9ftRGtj8ZJwZxMNHQOdFGFnWmYm3
	 WL6u589m3F5mzttxTnQbdone5IX49xBzMXkNdhLUPHU0pzFNAOD2mLd+p42Jz35hUEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794132110;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=MOmLyDgIbQO7M8uzopRbwQ0bFLjFrWThanlQ5mPH0IA=;
	b=jzaRXMQV21DnhiOcNGjWYvHDchJl7dIn+uHL8/5AxoV7iKxiyfSKraFe/TkSg10T6+N7
	 310YKsZl0+0LLqfeN7cCVksSnmiDkZw/Skzfi8oEv1IvbsN0U8Qy2MDT6AkI7icPFC716
	 Je8KsosIOuUEr1h+O6DK/EgdB8gtly3HPVztLcbN84qUybIpAEtbu87cGo12u3ZAtiimw
	 K9BCxWFnkZ37Q3BJguIEUa6g3DTFgoO93PPfoCucT2TQZjn+qVrgBYjV3+C5VoWdh+emt
	 vCwIBNPlgtewhzbmch3hBrrMA6n5j4Ysm0cS+ZIa0qX/WoOkrlV0IErXX8Nqd/RK6Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.25
Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB71606A31C
	for <dm-devel@lists.linux.dev>; Sun,  8 Nov 2026 10:01:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8CB71606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [172.100.0.8] (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADngbeJSPBqEhaZAA--.37845S2;
	Sun, 08 Nov 2026 18:01:45 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: cengku@gmail.com,
 dm-devel@lists.linux.dev,
 dongsheng.yang@linux.dev,
 Jianyun Gao <jianyungao89@gmail.com>,
 linux-kernel@vger.kernel.org,
 vulab@iscas.ac.cn
Subject: Re: [PATCH] dm-pcache: Fix use-after-free in kset_replay()
Date: Sun, 08 Nov 2026 10:01:45 +0000
Message-ID: <20261108100145.3182096-1-vulab@iscas.ac.cn>
In-Reply-To: <ab890e71-8075-76f8-a91b-0beb78a0d3b7@redhat.com>
References: <20260917094133.2145340-1-vulab@iscas.ac.cn>
 <ab890e71-8075-76f8-a91b-0beb78a0d3b7@redhat.com>
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
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:zQCowADngbeJSPBqEhaZAA--.37845S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF4UGr4rtrW3Zr13CryUWrg_yoW8GFy7pF
	WrK3WYqrsrKrykAayIva1Iqa4xurZ3Ja98Wry7GrWkA3W5GFyxKrWfCw47ua17Ars3Xr42
	qF45t3Z3WayqyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvS1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
	I48JMxAIw28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2
	IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v2
	6r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2
	IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv
	67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43
	ZEXa7VU1K9aJUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAEFA2rv4qifOQAAsi

Hi Mikulas,

Sorry for the very late reply.

Thank you for the pointer to c2e894eac398. I checked the latest tree
(7.4-rc1), and the bug is already gone there. In kset_replay() the
generation check now reads

		if (key->seg_gen < key->cache_pos.cache_seg->gen) {
			cache_key_put(key);
			continue;
		}

so the stale key is dropped and never touched again, and __set_bit() and
cache_seg_get() only run for valid keys. The fix has been there since
v7.3-rc1, so no current tree is affected. I also see that the commit
already carries a Cc: stable tag, so nothing is missing there either.

There is nothing left to fix, so please disregard my patch and feel free
to mark the patchwork entry as superseded. I should add that the approach
in it was wrong as well: pinning the segment before the generation check
takes a reference on the segment of a stale key, and since that key is
freed and never inserted into the tree, the reference would never be
dropped.

The patch was generated against an older tree and I did not recheck the
current one before sending it, which is what I got wrong here. For
transparency about how it was produced: the candidate came from our
static analysis tooling, and DeepSeek and GPT-6.1 Sol were used to audit
it and help write the change. I reviewed it and I am responsible for it.

I am going through the rest of the outstanding feedback by hand and
answering it one thread at a time.

Thanks,
Wentao

