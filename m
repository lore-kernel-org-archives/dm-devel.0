Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=43.163.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795773543;
	b=Y53RoG6gNvjuahhLwyRLs8oysHSSxScEvT60tIKCpwbaCsHho6Zlq3OtuhNpnPvt6Rsc
	 nhIWifX4cPSTjWWO4acMLeF+6RB+or9TDSkFUh1pJHV9+90JkTolsWsKBVHGlhxfRwN6n
	 jaDVHPvw1NogfvJNxEqW4/ELxFTNAz7ee2CesV0/x7sdIL29AkGEo58fZu5gCv0pDnkMi
	 YQOFnktCx37w/sWQAxhDG5P/LP628BXGPqg/jYEpsqpEEbE+0P7yg5ZGrdIdydazOSXrC
	 eSeSDlrH/+IFh6gDjRGDDcMu7AYwGnO6qEWGnMrpN3MvFOs0VNtbuyxDCGifLDpT2IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795773543;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=HS1h1bZTmMeyGAoFJ9k7WiesLziPXfI0iGAFPkyd0U8=;
	b=cOH58Wq7HwsGeO6TtG/7AveLnuexcL6o9B/e/qQe5+5rwxQ8QvcI9DR/9pp6YaVsFF51
	 R+//h5HJlrYhnQqF61FjVVXhkiOOE+zAQcn0X4w3g+mEz+7ifbkjz6iXDbjl8PrOHf5sA
	 SKmhdLBPSMQ9ILcLlpHeegnLCM/T7leOMriXK0x8pzX51mOT9cR4ykZdcIA/taXWSTpeG
	 QU49WwEapA8uHNoJGQBXnuxY+85Xdrk00l0BXiu8fputhacme6hjhT5WfubPhd8PhiJyj
	 9I9imlJqsu2GtmFSj2lgFsPCbI4a+kbiDGK4gwOffpWMbiIHcm0UJvazRYN3KqtMdig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b="R/X+MprA";
	arc=none smtp.remote-ip=43.163.128.43
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.43])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB341606A69E
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 09:58:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB341606A69E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=R/X+MprA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795773531; bh=HS1h1bZTmMeyGAoFJ9k7WiesLziPXfI0iGAFPkyd0U8=;
	h=From:To:Cc:Subject:Date;
	b=R/X+MprA1iiYsbVn2QorYQD4I5+6eLG6x84toLp/nIL/uCoJ7IiQsU5MqGVGgEpzC
	 BUB9O/51DNOMUYPwuyK2pL3ZGiU0nzWZqSNlHsRKVae5gDi+O2XAfpSZuRshYyuQFt
	 mrWA/yHrEjVX42dh+3MTsUcndbyEOeFcXI+CAhvk=
Received: from shuai-VMware-Virtual-Platform.. ([39.165.245.102])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id EB0908DD; Fri, 27 Nov 2026 17:58:48 +0800
X-QQ-mid: xmsmtpt1795773528tjyzhcp99
Message-ID: <tencent_D498CB0489BB9C74184B927C7393282E9806@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3JuK4QQFK/DEJQKnRWlXqelqaw1sONkFVjW2acjdeHZTr0FvYhkqq
	 i7lx3s3jTO+kfSEOwXC/dh5zINJKrdRKazWcucLlzXiT7w/7UtpiujZzBbjpaNJnQxPye1e3CX7l
	 V8wBP5rfOYSLdtwgR6+vUWXXd2x/lSb9Yv7mm1bh2BuhCsE599cLNgk33ZUf9fkeeBOIVArml+xY
	 9eoc+4DRsOxYTxJfF5iylk/pu+8kA3oP4VglMi+H3wlB7cPhIBOkH4tUYW7qd3kWpEddhmaLLHkU
	 mfdQNrBRhH7Qdn0fWfTMHBx/eXvCygrjMrDNu1x+zPyq+tO67HjmpZAyq9OKYZWAdullKfr8CSED
	 2in8tWCNRnvh9Sp6yVeeZnLnUkWmVgQrSGlAh55AP0ZNcyQL4JkfqzDmgiHPTcbDn8y/prMeZ9NC
	 75ZrWKuFeQvs6oKWzPmIT1bPEOjy4v1fstbfxTSHQRmgd9uBEgvi7N/ni5S1TSKKlWzzARNXX/Ai
	 W05N1vXgAwvr1cm5NjAZ2pM5uVx7TvAK8OJ67jf4v4gn0yVCjx9hYkoxSISmXs6v30TIJz+Z7IC6
	 L5RDTVV0d/5GKiz7U34iVr4iOY8KVcwdVMXdS1CZKJgAo5sbdlqqTLWKwjrv4tSVHbAoLKBhLlLo
	 7vrZvmEPabxaUsvQnpKBm3qT339DQ8GhpN9Ztnv2XEWdpXiYVuOtrWBAwBR/2hJakQgpKXjdjPX1
	 pQE97mu5V0lf6u3dYnhVr3M4eGnxBhFbsiUkRbbWKNSWjQ6mm6ohDFBIZxgWhxfNrVUcjR9/KhI6
	 q7FHppxkYynwxtdtXjNp3x1DSoQlT1AJm+Pz0LedBXnXdWGLcNKHYYKff+3jHb1hE9xvYp0AFYbl
	 9l2N0d56NfStC+d0NHIiJPG6MqxL/af8zru88V6ENuVoWdVYEfuULc6YRRHMPDjAg6dasMCX6yLc
	 09nxnPI6pjLCSh+K627UKGBDzaXDr9Psw/NyDUsqAh5gMinYoO4p1KotP0gBrfXeHmFIInHlOq+x
	 vAlZnDlMJuVc7j/76GsNAZcNWAUnznlExBMoQcJG5POV02Eo83hvvsuNwtI2o=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Shuai Liu <847807867@qq.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org,
	syzbot+1eda626824b6334f5ad3@syzkaller.appspotmail.com,
	Shuai Liu <847807867@qq.com>
Subject: [PATCH] dm snap: clear pointers in alloc_area() error paths
Date: Fri, 27 Nov 2026 17:58:48 +0800
X-OQ-MSGID: <20261127095848.769985-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_area() vfrees ps->zero_area and ps->area on allocation failure
but leaves the dangling pointers.  When the snapshot constructor then
calls free_area() as part of teardown, it vfrees the same buffers
again, triggering a WARNING in vfree().

Set those pointers to NULL after vfree().  vfree(NULL) is a no-op,
so free_area() is safe to call multiple times.

Reported-by: syzbot+1eda626824b6334f5ad3@syzkaller.appspotmail.com
Fixes: 7c9e6c17325f ("dm exception store: refactor zero_area")
Signed-off-by: Shuai Liu <847807867@qq.com>
---
 drivers/md/dm-snap-persistent.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index b587ee7330562..9f5ade4f51cec 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -194,9 +194,11 @@ static int alloc_area(struct pstore *ps)
 
 err_header_area:
 	vfree(ps->zero_area);
+	ps->zero_area = NULL;
 
 err_zero_area:
 	vfree(ps->area);
+	ps->area = NULL;
 
 err_area:
 	return r;
-- 
2.43.0

