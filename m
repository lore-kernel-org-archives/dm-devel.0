Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD8CC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 20:34:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-VIJMxyBLMQW0Xw6ZXE_iHg-1; Mon, 09 May 2022 16:34:06 -0400
X-MC-Unique: VIJMxyBLMQW0Xw6ZXE_iHg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CCCFE3810D24;
	Mon,  9 May 2022 20:34:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1AA47401E9C;
	Mon,  9 May 2022 20:34:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CB3011947052;
	Mon,  9 May 2022 20:34:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D55161947051
 for <dm-devel@listman.corp.redhat.com>; Mon,  9 May 2022 20:34:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE1A82166B4F; Mon,  9 May 2022 20:34:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA3C32166B4B
 for <dm-devel@redhat.com>; Mon,  9 May 2022 20:33:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE7D829AB409
 for <dm-devel@redhat.com>; Mon,  9 May 2022 20:33:54 +0000 (UTC)
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk
 [46.235.227.227]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-qFB8PSoTMV6Vud2GZjq67A-1; Mon, 09 May 2022 16:33:51 -0400
X-MC-Unique: qFB8PSoTMV6Vud2GZjq67A-1
Received: from [127.0.0.1] (localhost [127.0.0.1])
 (Authenticated sender: krisman) with ESMTPSA id 7465D1F440DE
From: Gabriel Krisman Bertazi <krisman@collabora.com>
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <Ynlv6lyV1OgZe6h5@redhat.com> (Mike Snitzer's message of "Mon, 9
 May 2022 15:47:54 -0400")
Organization: Collabora
References: <20220427165710.225808-1-krisman@collabora.com>
 <Ynlv6lyV1OgZe6h5@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Date: Mon, 09 May 2022 16:33:46 -0400
Message-ID: <875ymela39.fsf@collabora.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] dm: dm-mpath: Provide high-resolution timer to HST
 with bio-mpath
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, kernel@collabora.com, khazhy@google.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Mike Snitzer <snitzer@redhat.com> writes:

> Overall your code was OK, but I nudged it a bit further to be
> inkeeping with how 'features' flags have been implemented elsewhere
> (e.g. dm_target_type's features) -- by using a healer to test the
> flag, etc.
>
> I also tweaked some other small implementation details.  Please see:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.19&id=c06dfd124d46df9c482fbd1319b5fe19bcb1a110

looks good to me.  thanks for the fixups.

-- 
Gabriel Krisman Bertazi

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

