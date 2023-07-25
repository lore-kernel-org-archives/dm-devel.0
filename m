Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363D9C04FDF
	for <dm-devel@archiver.kernel.org>; Tue, 25 Jul 2023 06:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690267379;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TGedNwn1NmhYljp3R61H6ZKs1d7pMYOc1eq2E6F6U5g=;
	b=HTU5Umclv3ckIwyvqgMSM14JaUGPGeAcfy+i8Y1qCRA/2aHWN/HzG6G5zc79hnkveUP4rb
	ZIzBAudRBrTM5JRaL0Oy9HYokJFTJIQ7BR2ORI8nnef+qI3LZq8tCHWqzCIbtpGtIa+SOP
	kAdnoc4+v9B22cQpK69cINkNs2yg2xg=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-23wRxG3gO3G4_fsLWcqmVQ-1; Tue, 25 Jul 2023 02:42:56 -0400
X-MC-Unique: 23wRxG3gO3G4_fsLWcqmVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D8B73C0FCA5;
	Tue, 25 Jul 2023 06:42:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8AC2540D2845;
	Tue, 25 Jul 2023 06:42:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6327919378C2;
	Tue, 25 Jul 2023 06:42:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0AA6E1946589
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Jul 2023 02:43:19 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A476C2014F88; Tue, 25 Jul 2023 02:43:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CAD5200BA7C
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 02:43:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 62BB91C068F9
 for <dm-devel@redhat.com>; Tue, 25 Jul 2023 02:43:19 +0000 (UTC)
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com
 [95.215.58.37]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-fhrHxNEnMPCdBiJ5Oi0ZcA-1; Mon, 24 Jul 2023 22:43:17 -0400
X-MC-Unique: fhrHxNEnMPCdBiJ5Oi0ZcA-1
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20230724094354.90817-2-zhengqi.arch@bytedance.com>
Date: Tue, 25 Jul 2023 10:35:01 +0800
Message-Id: <97E80C37-8872-4C5A-A027-A0B35F39152A@linux.dev>
References: <20230724094354.90817-1-zhengqi.arch@bytedance.com>
 <20230724094354.90817-2-zhengqi.arch@bytedance.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Tue, 25 Jul 2023 06:42:42 +0000
Subject: Re: [dm-devel] [PATCH v2 01/47] mm: vmscan: move shrinker-related
 code into a separate file
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
Cc: kvm@vger.kernel.org, djwong@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, david@fromorbit.com,
 dri-devel@lists.freedesktop.org, virtualization@lists.linux-foundation.org,
 Linux Memory Management List <linux-mm@kvack.org>, dm-devel@redhat.com,
 linux-mtd@lists.infradead.org, cel@kernel.org, x86@kernel.org,
 steven.price@arm.com, cluster-devel@redhat.com, xen-devel@lists.xenproject.org,
 linux-ext4@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 linux-arm-msm@vger.kernel.org, linux-nfs@vger.kernel.org, rcu@vger.kernel.org,
 linux-bcache@vger.kernel.org, yujie.liu@intel.com,
 Vlastimil Babka <vbabka@suse.cz>, linux-raid@vger.kernel.org,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
 Sergey Senozhatsky <senozhatsky@chromium.org>, netdev <netdev@vger.kernel.org>,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org, tkhai@ya.ru
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.dev
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



> On Jul 24, 2023, at 17:43, Qi Zheng <zhengqi.arch@bytedance.com> wrote:
> 
> The mm/vmscan.c file is too large, so separate the shrinker-related
> code from it into a separate file. No functional changes.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
> include/linux/shrinker.h |   3 +
> mm/Makefile              |   4 +-
> mm/shrinker.c            | 707 +++++++++++++++++++++++++++++++++++++++
> mm/vmscan.c              | 701 --------------------------------------
> 4 files changed, 712 insertions(+), 703 deletions(-)
> create mode 100644 mm/shrinker.c
> 
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 224293b2dd06..961cb84e51f5 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -96,6 +96,9 @@ struct shrinker {
>  */
> #define SHRINKER_NONSLAB (1 << 3)
> 
> +unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
> +			   int priority);

A good cleanup, vmscan.c is so huge.

I'd like to introduce a new header in mm/ directory and contains those
declarations of functions (like this and other debug function in
shrinker_debug.c) since they are used internally across mm.

Thanks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

