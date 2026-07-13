Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A27431E7D
	for <dm-devel@lists.linux.dev>; Mon, 13 Jul 2026 13:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783950569; cv=none; b=BX2Z+ecqS8dHHZoXgeQEjHmpackMalp6ybNJW8Ck2UGYN11F5739KL2YOOhlFfRU/+Dr5U9k8euN1p4vs18zoLGN6wVYbWV9WdJWvhDMXfjXS2zy44/IXswK2Aj532TGO/iB3BS4qpXiXhQ/KSiKZaOYLR5x7oqbs4CsiXkhVHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783950569; c=relaxed/simple;
	bh=GW2hM1CumwnEWA7RGACyAVG6COeR6E7I0agOizXlMI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID; b=HLnKKx23GwqHit2yHZUnfn8VglhlMjkcOXqmLh40aTV1on7WLSzjVcNcB5cGKiOTFvCEWTVPpch6PQF98oFUsq5dqpa/nmxZf/hwqtriPO9anm69VyMdgOzIZWFZs9cziADvYBGsNF6ccprM7wwKeTQCQSwiBv4yN7UETKegXsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=fEmumRLC; arc=none smtp.client-ip=117.135.210.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="fEmumRLC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=GW2hM1CumwnEWA7RGACyAVG6COeR6E7I0agOizXlMI4=; b=f
	EmumRLCXuTJ58xJ14UJhp7RewniVIfFYxbG6es5kvq2iTZGJbAq9XQlcoMcEvt+R
	iQY5ML1Mwk/m2wGYFcpkeMBwkc5awbiQw7Q38z36mDVFguuwesfx5/97nAtkP+aH
	mFRfq3iXHdN48IM4dx8qEnkX3Q+fBfzXDRs8FdzwGQ=
Received: from zhanggenjian$126.com ( [120.228.135.217] ) by
 ajax-webmail-wmsvr-41-108 (Coremail) ; Mon, 13 Jul 2026 21:49:02 +0800
 (CST)
Date: Mon, 13 Jul 2026 21:49:02 +0800 (CST)
From: "genjian zhang" <zhanggenjian@126.com>
To: "Ming Hung Tsai" <mtsai@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	bmarzins@redhat.com, ejt@redhat.com, dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Genjian Zhang" <zhanggenjian@kylinos.cn>
Subject: Re: [PATCH] dm thin metadata: fix superblock refcount leak on
 snapshot shadow failure
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20260511(2e539873) Copyright (c) 2002-2026 www.mailtech.cn 126com
In-Reply-To: <CALjSBEtD00yuLaBJXtJjFG7L0nCLRaGDUVGoN7VZ4wkVRD0CDQ@mail.gmail.com>
References: <20260711100526.835027-1-zhanggenjian@126.com>
 <CALjSBEtD00yuLaBJXtJjFG7L0nCLRaGDUVGoN7VZ4wkVRD0CDQ@mail.gmail.com>
X-NTES-SC: AL_Qu2TAfWev00v5CabZ+kdm0sUguo4Wca4uf8v249Vc/0OqSrj4QYcY0BkBV7o4PK3KiuGsxG6ehxX9+5oQLNSGJ1C8t2hLJ2WTCuVYIOpGQ==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2b682ca7.83e1.19f5bbd072c.Coremail.zhanggenjian@126.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bCkvCgD3_47P7FRqqrQcAA--.41614W
X-CM-SenderInfo: x2kd0wxjhqyxldq6ij2wof0z/xtbBpg8enGpU7M+b5wAA3K
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==

QXQgMjAyNi0wNy0xMyAxMDo0MDo0OCwgIk1pbmcgSHVuZyBUc2FpIiA8bXRzYWlAcmVkaGF0LmNv
bT4gd3JvdGU6Cj5PbiBTYXQsIEp1bCAxMSwgMjAyNiBhdCA2OjE24oCvUE0gR2VuamlhbiA8emhh
bmdnZW5qaWFuQDEyNi5jb20+IHdyb3RlOgo+Pgo+PiBGcm9tOiBHZW5qaWFuIFpoYW5nIDx6aGFu
Z2dlbmppYW5Aa3lsaW5vcy5jbj4KPj4KPj4gX19yZXNlcnZlX21ldGFkYXRhX3NuYXAoKSBpbmNy
ZW1lbnRzIFRISU5fU1VQRVJCTE9DS19MT0NBVElPTiBpbiB0aGUKPj4gbWV0YWRhdGEgc3BhY2Ug
bWFwIGJlZm9yZSBzaGFkb3dpbmcgaXQuIFdoZW4gZG1fdG1fc2hhZG93X2Jsb2NrKCkKPj4gZmFp
bHMsIGEgcmVmZXJlbmNlIGlzIGxlYWtlZCBpbiB0aGUgbWV0YWRhdGEgc3BhY2UgbWFwLgo+Pgo+
PiBGaXggYnkgYWRkaW5nIHRoZSBtaXNzaW5nIGRtX3NtX2RlY19ibG9jaygpLgo+Pgo+PiBGaXhl
czogY2M4Mzk0ZDg2ZjA0ICgiZG0gdGhpbjogcHJvdmlkZSB1c2Vyc3BhY2UgYWNjZXNzIHRvIHBv
b2wgbWV0YWRhdGEiKQo+PiBTaWduZWQtb2ZmLWJ5OiBHZW5qaWFuIFpoYW5nIDx6aGFuZ2dlbmpp
YW5Aa3lsaW5vcy5jbj4KPj4gLS0tCj4KPlRoZSBmaXggbG9va3MgcmVhc29uYWJsZSBhcyBhIGJl
c3QtZWZmb3J0IGNsZWFudXAgZm9yIHRoZSBpbW1lZGlhdGUKPnJlZmNvdW50IGxlYWsuCgpUaGFu
a3MgZm9yIHRoZSByZXZpZXcuCgpUaGFua3MsCkdlbmppYW4K
