Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAD91862A
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 02:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723515186; cv=none; b=nOtRKm5jrRq5X5JaTsAKP30SPO2mpP4AYkUoyJ1kNvOInDs4kBR6HkGOgpCcn70znifp8bTld/i1jSmH5V6ozVBfi3pTOvkj9Xc3s7whQkPb1kEpIKRrqhdRexttZJJgwF7dPBPW9vBPGG2j6WQ/dBh+Nn8bb2Ha2ktUDYLGAjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723515186; c=relaxed/simple;
	bh=ttgnl92IAANDYNOpO2ElvOSEP7rQWixwkptZL2uPqkg=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=iTPCr3YCpfSOSUiN876GlBjp7lB/Fdk70j505LBiFcr3Z79BemNs4hQjrfyS0eqlfq07ukgFjXd0pkLq/HzM78O84vceBGqk5prIIPa0MMRCwg5odXxyyhUrGmzX0JX7zHQnMTg+szpDiU4bL9ESu4ndMOLMzJ9ahS9UPe2vaUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=G3yZU89+; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="G3yZU89+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1723515162; bh=hjJtuMXhQjs91SMFWx1eQp/A4n0LrrPVA87MoEm2EII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G3yZU89+GMAKzkTdI70KqQ86SS+kMOYMvR3thLSzY0iF9KTl80g+yf+X3vp21cd67
	 78D/5UIUAnUA8P2JM0YwaBxmwgN4YZDBp517WeCm82/omN5ychut0SFG085NLex6Ts
	 YRV3jA0x8X31J7TP+NCOzZboVFUrp3ZAqDIwJcOY=
Received: from localhost.localdomain ([123.150.8.42])
	by newxmesmtplogicsvrszc5-2.qq.com (NewEsmtp) with SMTP
	id 3283D8AA; Tue, 13 Aug 2024 10:12:40 +0800
X-QQ-mid: xmsmtpt1723515160tqhs6b6hf
Message-ID: <tencent_C349DF9EE757FA8936E17CE2F90388B8B909@qq.com>
X-QQ-XMAILINFO: MO96tf8oLeWliar79LxL6AkW42TZvdEp6JejhpBaEeqMUeCxD6P7lixeq7dWhZ
	 U5YslGIk3lpFQCcztXeB11X/sPUIO3YXkKFMDe2jK54kqQRYpUosCPzLYV033ujjqGUYPVjd9hM3
	 K6438AORvGcE2mOWlmzhg0sip4OSIPV1RsNJPGBbbs38ZyLrkeNHCJDnenmmp4OtXnAs2taPzvzM
	 S3/6Xu662RHoMk1dEqwkTTZ4iTykBHnDndmL1Of3ntyarf05IKbKVoJ052FVazyOysTeZutxjHwq
	 v3PSiFuyk8LIc52pf6i9eOymeHr3bwOgG9GK3x2qYtiuBYN+p3s4nNng7zBTHtSeoIbvae7YgvWA
	 I3tZ4eNAb8rXbSODyWKaMlV+Rl7sm0gx1OAFORfVXpybguEh/CDQS08JMBJXWusE6uB1Xj278auU
	 pO5kpHwo94XYqlewqfiwevBvqw/RDd6lkdidiqY5QvGyQfoWw1pfizpzGFU9ecLFJjZfxCziU3zJ
	 5sGITne0oxBUpLATinHvqNF0VTf8lDmkDTEeD12E77dA9ZLpJnVdTbTlHfPkT/snJmn/zBkzGCjJ
	 gVSvQD2/wN4mS6jNIVXWvDLTPR8RWwL0KQHO5UuJswhtyUyWogVbMvvaHDJ6govhwl2o4cncKyPQ
	 DB2b8A2mHpKiv6dWxORMJgF7lVWpc0YL7JIkHiGq2AEzCqaMR7iBBvcSuPQRYPPHXBPgxmJL/QY3
	 CgPRNZth+ZOx+DkXickDV2OPIEyrVAT3EdwxyyMzbS8QR5y2iNZBmXtyWTsBt6+mZsJ+EtIV9KsM
	 W/it0buWG9XLv96OV3VwYnHL52RszdnFBymGR0om5E0+vpD1XoaolBX097bzMrmfGZ7ax7OJZO2k
	 8BeudZgi8+O77LSbHxt03QYkvLMj50zGCy0oN3gPOlQGHCSY/VLyHzfTD7cmz3wOniM88OZU+XR/
	 9nV9MZEfg=
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: 303146950@qq.com
To: mwilck@suse.com,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	Kou Wenqi <kouwenqi@kylinos.cn>
Subject: [PATCH v3] multipath: display the correct configuration when dumpping config
Date: Tue, 13 Aug 2024 10:12:36 +0800
X-OQ-MSGID: <20240813021236.116006-1-303146950@qq.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <26f4b0532302bfff61bac465d9f97b8215c30d78.camel@suse.com>
References: <26f4b0532302bfff61bac465d9f97b8215c30d78.camel@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kou Wenqi <kouwenqi@kylinos.cn>

On Fri, 2024-08-09 at 10:38 +0200, mwilck@suse.com wrote:
> Thanks for the patch! I'd prefer the following, if you agree.
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 4b19d2e..28e3a05 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -853,8 +853,6 @@ main (int argc, char *argv[])
>         if (atexit(uninit_config))
>                 condlog(1, "failed to register cleanup handler for config: %m");
>         conf = get_multipath_config();
> -       conf->retrigger_tries = 0;
> -       conf->force_sync = 1;
>         if (atexit(cleanup_vecs))
>                 condlog(1, "failed to register cleanup handler for vecs: %m");
>         if (atexit(cleanup_bindings))
> @@ -1001,6 +999,11 @@ main (int argc, char *argv[])
>  
>         libmp_udev_set_sync_support(1);
>  
> +       if (cmd != CMD_DUMP_CONFIG) {
> +               conf->retrigger_tries = 0;
> +               conf->force_sync = 1;
> +       }
> +
>         if ((cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG) && enable_foreign)
>                 conf->enable_foreign = strdup("");

Thanks for your review and revised opinion. Here is the new patch.

"multipath -t" and "multipath -T" might show the wrong
multipathd configuration items "retrigger_tries" and
"force_sync". Make sure they don't.

Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
---
 multipath/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index ce702e7f..69552896 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -852,8 +852,6 @@ main (int argc, char *argv[])
 	if (atexit(uninit_config))
 		condlog(1, "failed to register cleanup handler for config: %m");
 	conf = get_multipath_config();
-	conf->retrigger_tries = 0;
-	conf->force_sync = 1;
 	if (atexit(cleanup_vecs))
 		condlog(1, "failed to register cleanup handler for vecs: %m");
 	if (atexit(cleanup_bindings))
@@ -1000,6 +998,11 @@ main (int argc, char *argv[])
 
 	libmp_udev_set_sync_support(1);
 
+	if (cmd != CMD_DUMP_CONFIG) {
+		conf->retrigger_tries = 0;
+		conf->force_sync = 1;
+	}
+
 	if ((cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG) && enable_foreign)
 		conf->enable_foreign = strdup("");
 
-- 
2.27.0

