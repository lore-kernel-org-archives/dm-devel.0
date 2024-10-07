Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FE9101C4
	for <dm-devel@lists.linux.dev>; Mon,  7 Oct 2024 11:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728301105; cv=none; b=Fu1qcoj2uoVR2+mZ5AHauzC5fWsHWlnR3uCi+00o8+hpUrFOKR0HZG2BMpUayEL72wsFX66wrcuMboBnSEfnOLfOlCzvYv+hZrqf9yiJwKw2/zHuFOIDGjszzECLrdmbNLjE3grpbsx+GSAFlpshVcTy3R0HFTQKVBCUV1Uam2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728301105; c=relaxed/simple;
	bh=/wsRLnEjanUm/zzzr/pxwF1qJ/NNWIXYKSEavIjgAyQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qjcjPkKacXeqigAUtnvHa2s2bMHNXdW51WPMJ5cDkwQsoBzRjrTWQkvN6kZ6fWnUoh+46NOZvZ4EGSqpsSkSrGGA+uh0SrfOwauxlOCXvnJmkUYrzVn1d6uHFPIMF1Epu8ejofeloXGxiBXNUCQLoircusqGOesXW3f3FzLIE3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RAur/VRP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RAur/VRP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728301101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uXvunVyytdZMOqYsf1u6Uqw4XrsVQP3pD2JmmJ6aowk=;
	b=RAur/VRPmPhZuUGmtVx3quPpBW/Gb6cZBAsCh06Zhr5F64Y4Pr8lOQmSV6O5jkdd5iEIxB
	2n/k3IGpKxFePdcn8aY3J/7H1zD7WghN6hM5GuRJnCJ4t7vG+c5VK2Dakf3gp+Ob+y0xfM
	0FkGW72a0fBoejbmSTw5Y63Y/1cCcb8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-JKTJSLNXPh-Ve3fQDmuWwQ-1; Mon,
 07 Oct 2024 07:38:20 -0400
X-MC-Unique: JKTJSLNXPh-Ve3fQDmuWwQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7EDE1944A82;
	Mon,  7 Oct 2024 11:38:18 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 41C961956052;
	Mon,  7 Oct 2024 11:38:16 +0000 (UTC)
Date: Mon, 7 Oct 2024 13:38:12 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Chenyuan Yang <chenyuan0y@gmail.com>
cc: agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, 
    Zijie Zhao <zzjas98@gmail.com>, syzkaller@googlegroups.com, 
    secalert@redhat.com
Subject: [PATCH] dm: fix a crash if blk_alloc_disk fails
In-Reply-To: <CALGdzuo-1QZgk4ZmNXf8_Nyb+d9JLRktCR-3pJZsdVUmKjaXhQ@mail.gmail.com>
Message-ID: <16e9030d-e55c-47eb-1a2a-dff8a50e6627@redhat.com>
References: <CALGdzuo-1QZgk4ZmNXf8_Nyb+d9JLRktCR-3pJZsdVUmKjaXhQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:cleanup_mapped_device+0x202/0x580 drivers/md/dm.c:2198
> Code: 03 80 3c 02 00 0f 85 28 03 00 00 48 8b 9d 08 02 00 00 48 b8 00
> 00 00 00 00 fc ff df 48 8d bb 98 00 00 00 48 89 fa 48 c1 ea 03 <80> 3c
> 02 00 0f 85 19 03 00 00 48 c7 c7 00 57 39 8f 48 c7 83 98 00
> RSP: 0018:ffffc9000e5f7b80 EFLAGS: 00010217
> RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: ffffffff8169176c
> RDX: 0000000000000011 RSI: 0000000000000004 RDI: 000000000000008c
> RBP: ffff888047717000 R08: 0000000000000001 R09: fffff52001cbef62
> R10: 0000000000000003 R11: 0000000000000000 R12: ffff888047717208
> R13: ffff888047717090 R14: ffff888047717208 R15: ffff88802ba3d9e8
> FS:  00005555642a83c0(0000) GS:ffff88802ba00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe48631f1f8 CR3: 0000000000c22000 CR4: 0000000000750ef0
> PKRU: 55555554
> ----------------
> Code disassembly (best guess):
>    0: 03 80 3c 02 00 0f     add    0xf00023c(%rax),%eax
>    6: 85 28                 test   %ebp,(%rax)
>    8: 03 00                 add    (%rax),%eax
>    a: 00 48 8b             add    %cl,-0x75(%rax)
>    d: 9d                   popf
>    e: 08 02                 or     %al,(%rdx)
>   10: 00 00                 add    %al,(%rax)
>   12: 48 b8 00 00 00 00 00 movabs $0xdffffc0000000000,%rax
>   19: fc ff df
>   1c: 48 8d bb 98 00 00 00 lea    0x98(%rbx),%rdi
>   23: 48 89 fa             mov    %rdi,%rdx
>   26: 48 c1 ea 03           shr    $0x3,%rdx
> * 2a: 80 3c 02 00           cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
>   2e: 0f 85 19 03 00 00     jne    0x34d
>   34: 48 c7 c7 00 57 39 8f mov    $0xffffffff8f395700,%rdi
>   3b: 48                   rex.W
>   3c: c7                   .byte 0xc7
>   3d: 83                   .byte 0x83
>   3e: 98                   cwtl
> 
> 
> Syzkaller reproducer:
> # {Threaded:false Repeat:true RepeatTimes:0 Procs:1 Slowdown:1
> Sandbox: SandboxArg:0 Leak:false NetInjection:false NetDevices:false
> NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false
> KCSAN:false DevlinkPCI:false NicVF:false USB:false VhciInjection:false
> Wifi:false IEEE802154:false Sysctl:false Swap:false UseTmpDir:false
> HandleSegv:false Trace:false LegacyOptions:{Collide:false Fault:false
> FaultCall:0 FaultNth:0}}
> ioctl$KGPT_CEC_ADAP_S_LOG_ADDRS(0xffffffffffffffff, 0xc05c6104,
> &(0x7f0000000080)={"8072609d", 0x4, 0x6, 0x8, 0xffff, 0x6,
> "000780427bee50eb00", '\x00\a\x00', "8529b501", "3bf5c9d5",
> ["f1c758509a071a2ded4470ab", "fe1285a1e9c9879d543c15d2",
> "d6de4e2d5ae55cebb6bac1e1", "dd8866305b4f75e67daa6d8b"]})
> r0 = openat$KGPT_SYZKALM_dm_ctl(0xffffffffffffff9c, &(0x7f0000000040), 0x2, 0x0)
> ioctl$KGPT_DM_DEV_STATUS(r0, 0xc138fd07,
> &(0x7f0000000080)="58c18237165e55872d5dacbed6a0")
> ioctl$KGPT_DM_DEV_CREATE(r0, 0xc138fd03, &(0x7f0000000080)) (fail_nth: 8)

Hi

Here I'm submitting a patch for this bug.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

If blk_alloc_disk fails, the variable md->disk is set to an error value. 
cleanup_mapped_device will see that md->disk is non-NULL and it will 
attempt to access it, causing a crash on this statement 
"md->disk->private_data = NULL;".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
Closes: https://marc.info/?l=dm-devel&m=172824125004329&w=2
Cc: stable@vger.kernel.org

---
 drivers/md/dm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2024-09-30 16:40:54.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2024-10-07 13:23:40.000000000 +0200
@@ -2290,8 +2290,10 @@ static struct mapped_device *alloc_dev(i
 	 * override accordingly.
 	 */
 	md->disk = blk_alloc_disk(NULL, md->numa_node_id);
-	if (IS_ERR(md->disk))
+	if (IS_ERR(md->disk)) {
+		md->disk = NULL;
 		goto bad;
+	}
 	md->queue = md->disk->queue;
 
 	init_waitqueue_head(&md->wait);

