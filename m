Received: from mail-m12786.qiye.163.com (mail-m12786.qiye.163.com [115.236.127.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7861838D01B
	for <dm-devel@lists.linux.dev>; Tue, 11 Aug 2026 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465853; cv=none; b=JIJGRkCM5xeJGsOTj1BqxqxXN5Gz3R7Q/fEoPU1iD0mK+lhQZquedl89OHxsZ3zDqaZ+kVL8FSIkJubF4Q62o5vupXIDAn3MJ/llHQk7BbBr5BwzOf7XlsEDP/eE/sfrFsEdpDJ9u510CfGOHoaTR7om1USolK7fqPTbksIVdzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465853; c=relaxed/simple;
	bh=oWcgKI6TH3SW1uPAdLNf9cMM4djrSH1OqGeKf/nE6MQ=;
	h=Content-Type:Message-ID:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:From:Date; b=FSXM7s0ZHAZ6j4ONZnq2wfO3bWhvIzdMb67M0NuR9TEJgrSvGQIZI4VzY27tamMq+670EO5KeTsss8BpSe+q895QBLJIbyeRTujrLjnPud1C7fHgDl7Jxl2NdjaM1fKtt4+8XaLzWB2w0ReqcakkC5jM2gVVbBMbKJfo9PlQ1nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=VRKpJLqk; arc=none smtp.client-ip=115.236.127.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="VRKpJLqk"
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AKUAOgCbKob6dT5QSeghvqqJ.3.1786457290705.Hmail.220255722@seu.edu.cn>
To: Mikulas Patocka  <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, 
	dm-devel <dm-devel@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: =?UTF-8?B?UmU6UmU6IFtQQVRDSCB2Ml0gZG0tY3J5cHQ6IHJlZmFjdG9yIGJ1ZmZlciBhbGxvY2F0aW9uIHJldHJ5IGhhbmRsaW5n?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com Sirius_WEB_WIN_1.65.3
In-Reply-To: <d7a670e5-ff67-0248-f514-e2e20603739a@redhat.com>
References: <cc5ed697-e769-4f40-aa9c-19c90b79fa7b@acm.org> <20260811031421.319489-1-runyu.xiao@seu.edu.cn> <d7a670e5-ff67-0248-f514-e2e20603739a@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from 220255722@seu.edu.cn( [222.191.246.242] ) by ajax-webmail ( [127.0.0.1] ) ; Tue, 11 Aug 2026 22:08:10 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
Date: Tue, 11 Aug 2026 22:08:10 +0800 (GMT+08:00)
X-HM-Tid: 0a9ff126b2b802f2kunmb2092bd4dce8
X-HM-MType: 1
X-HM-NTES-SC: AL0_4z5B86Wr4Tz9jdMF+bhXMTUS6Y2fHkyPT6dc03QDwVaZPGiA09TnwhbhTj
	hLfuFZO94YXwX6xgvkjGVFFRKj5FTlUp4ibMu3LjbJqkzUirKIkshCL4DwobCwmqEl+iTogoHv9N
	4uH2A5NQyI3qSL01fBjH73Mphs/MUFT8/94Ik=
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGU9DVhpCQ0lCGEJJSxgdH1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVU
	JCSU5LVUpLS1VKQktCWQY+
DKIM-Signature: a=rsa-sha256;
	b=VRKpJLqk10HUuJBrpYlPt1qGaGCGipFjoGb1TOifJE1pIZX3y5Bh9IjL+AJ59/2AK7OMyCWQxG9IKkDgHjdl18aRdIW8Gx/2XXs5PMv9I1d/ex7iIwbB4uyliy0fb8Cukbmheej1/wJrZk7bNh8xpaVnNn7pr2ObhJknekp3En4=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=oWcgKI6TH3SW1uPAdLNf9cMM4djrSH1OqGeKf/nE6MQ=;
	h=date:mime-version:subject:message-id:from;

SGkgTWlrdWxhcywKClRoYW5rcyBmb3IgcmV2aWV3aW5nIHRoaXMuCgpJIGluaXRpYWxseSBpbnRl
cnByZXRlZCB0aGUgZ290byByZXRyeSBwYXRoIGFzIGJlaW5nIHJlYWNoYWJsZSBhZnRlcgpiaW9f
YWxsb2NfbG9jayB3YXMgYWNxdWlyZWQuIEFmdGVyIHJlY2hlY2tpbmcgbWVtcG9vbF9hbGxvYygp
IGluIHY2LjEuNjYsCkkgZm91bmQgdGhhdCBpdCByZXR1cm5zIE5VTEwgb25seSB3aXRob3V0IF9f
R0ZQX0RJUkVDVF9SRUNMQUlNLiBXaXRoIHRoYXQKZmxhZyBzZXQsIGl0IHdhaXRzIGFuZCByZXRy
aWVzIHdoZW4gdGhlIHBvb2wgaXMgZW1wdHkuCgpUaGUgZmlyc3QgYWxsb2NhdGlvbiBmYWlsdXJl
IGhhcHBlbnMgYmVmb3JlIGJpb19hbGxvY19sb2NrIGlzIGFjcXVpcmVkLAp3aGlsZSB0aGUgbGF0
ZXIgYWxsb2NhdGlvbiBpcyBwZXJmb3JtZWQgd2l0aCB0aGUgbXV0ZXggaGVsZCBhbmQgZG9lcyBu
b3QKdGFrZSB0aGUgTlVMTCByZXRyeSBwYXRoIGluIG5vcm1hbCBwcm9jZXNzIGNvbnRleHQuIFRo
ZXJlZm9yZSwgSSBjYW5ub3QKanVzdGlmeSB0aGUgc3VzcGVjdGVkIGRvdWJsZSBhY3F1aXNpdGlv
biwgYW5kIHRoZSByZWZhY3RvcmluZyBwcm92aWRlcyBubwpmdW5jdGlvbmFsIGJlbmVmaXQuCgpJ
IHdpbGwgZHJvcCB0aGlzIHBhdGNoLgoKUmVnYXJkcywKUnVueXU=
