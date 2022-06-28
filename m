Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE3D9CCA47E
	for <dm-devel@archiver.kernel.org>; Tue, 28 Jun 2022 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656438910;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=s0eaMDOU7P9oUaR+hhTfJiNyu6GfRMLAM1aNwIjPp6c=;
	b=JYl/LcfAw87W8Sl4a3Oa8Zhs1iYYmIcZq0OIQEivcdyZE2zBm2tFioucvk+3uWaw+5xBn+
	W3nIX9iwQKIlCJwbYHwGXw8Ra9qAMinxk5WpxMVwxkYSx5g88NQde6yiOxUdkHjXypVdbx
	mWtf5I4ukYEhU00SgxcKkWThafaKYkI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-HhZnnMlENgW1_xzKCi2ucw-1; Tue, 28 Jun 2022 13:55:07 -0400
X-MC-Unique: HhZnnMlENgW1_xzKCi2ucw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 857F2101AA4E;
	Tue, 28 Jun 2022 17:55:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 30DFC40C1289;
	Tue, 28 Jun 2022 17:55:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B14AC1947056;
	Tue, 28 Jun 2022 17:55:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 479F319466DF
 for <dm-devel@listman.corp.redhat.com>; Tue, 28 Jun 2022 17:55:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 157D741616B; Tue, 28 Jun 2022 17:55:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10F2C41615A
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 17:55:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED32A800971
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 17:55:02 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-zBKeO-vCOrCcbCD_N2zYsg-1; Tue, 28 Jun 2022 13:55:00 -0400
X-MC-Unique: zBKeO-vCOrCcbCD_N2zYsg-1
Received: by mail-pj1-f53.google.com with SMTP id
 g16-20020a17090a7d1000b001ea9f820449so16701163pjl.5
 for <dm-devel@redhat.com>; Tue, 28 Jun 2022 10:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=Ifakbg1KSXljeCc2KlqlOz+XfzIBohlTVCEx+b5hm2Y=;
 b=ImdZO/7QQwVIMZLwbKsz0e8kitExPkSq17Qn1eK2rbt24DAt3kJcJPWpNxAWzrMNzR
 sRtf2aBQsPriJ4zpCuvTOWGozQWTlhG/65FzxJN1iWjyvN1huhKHycc0kiK9USMyIOiv
 gO3lKkw7vR+4pLIdCZmnsQ0FCMXl+TxqygNmJPdMo5hfGNOrZ4wtOknuPvGav1G2/l0n
 HeMnWhLAb4InW9ugSa1p9drDlrUCoCjKuXehVLTG5TodC0+bKPkJYje8ZPpjGh2O7wLU
 AGM44ZtbXzvOolRTDf6XWs8bL54azZL0WSj69Om/gmK+pNcRzGeiBXVsKV2If2hsrMA7
 /j0g==
X-Gm-Message-State: AJIora8zbR6uKuTW63JlUyZWPJTpi7N5JpFgz0v9qHM2qxpfVhwIvtl+
 gh+mqsg6xVwJy5v/3p97pVNVwg==
X-Google-Smtp-Source: AGRyM1vNNODoy68cNcew+BOwykVJS5AyiEbndqdKVVh3DpwTH+wUBJ1HcGxnO6zSsyx2Hva19xbd8w==
X-Received: by 2002:a17:90b:3b52:b0:1ec:db2a:b946 with SMTP id
 ot18-20020a17090b3b5200b001ecdb2ab946mr838564pjb.229.1656438899502; 
 Tue, 28 Jun 2022 10:54:59 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 f15-20020a170902ff0f00b0016a84d232a6sm5432810plj.46.2022.06.28.10.54.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 28 Jun 2022 10:54:59 -0700 (PDT)
Date: Tue, 28 Jun 2022 10:54:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Message-ID: <202206281009.4332AA33@keescook>
References: <20220627180432.GA136081@embeddedor>
 <6bc1e94c-ce1d-a074-7d0c-8dbe6ce22637@iogearbox.net>
 <20220628004052.GM23621@ziepe.ca>
MIME-Version: 1.0
In-Reply-To: <20220628004052.GM23621@ziepe.ca>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH][next] treewide: uapi: Replace zero-length
 arrays with flexible-array members
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
Cc: nvdimm@lists.linux.dev, alsa-devel@alsa-project.org, kvm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 dm-devel@redhat.com, target-devel@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-hardening@vger.kernel.org,
 linux1394-devel@lists.sourceforge.net,
 linux-stm32@st-md-mailman.stormreply.com, linux-s390@vger.kernel.org,
 Daniel Borkmann <daniel@iogearbox.net>, linux-rdma@vger.kernel.org,
 x86@kernel.org, kasan-dev@googlegroups.com, lvs-devel@vger.kernel.org,
 coreteam@netfilter.org, v9fs-developer@lists.sourceforge.net,
 linux-mips@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 linux-can@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, virtualization@lists.linux-foundation.org,
 io-uring@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-sctp@vger.kernel.org,
 netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 bpf@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Jun 27, 2022 at 09:40:52PM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 27, 2022 at 08:27:37PM +0200, Daniel Borkmann wrote:
> > [...]
> > Fyi, this breaks BPF CI:
> > 
> > https://github.com/kernel-patches/bpf/runs/7078719372?check_suite_focus=true
> > 
> >   [...]
> >   progs/map_ptr_kern.c:314:26: error: field 'trie_key' with variable sized type 'struct bpf_lpm_trie_key' not at the end of a struct or class is a GNU extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
> >           struct bpf_lpm_trie_key trie_key;
> >                                   ^

The issue here seems to be a collision between "unknown array size"
and known sizes:

struct bpf_lpm_trie_key {
        __u32   prefixlen;      /* up to 32 for AF_INET, 128 for AF_INET6 */
        __u8    data[0];        /* Arbitrary size */
};

struct lpm_key {
	struct bpf_lpm_trie_key trie_key;
	__u32 data;
};

This is treating trie_key as a header, which it's not: it's a complete
structure. :)

Perhaps:

struct lpm_key {
        __u32 prefixlen;
        __u32 data;
};

I don't see anything else trying to include bpf_lpm_trie_key.

> 
> This will break the rdma-core userspace as well, with a similar
> error:
> 
> /usr/bin/clang-13 -DVERBS_DEBUG -Dibverbs_EXPORTS -Iinclude -I/usr/include/libnl3 -I/usr/include/drm -g -O2 -fdebug-prefix-map=/__w/1/s=. -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wcast-function-type -Wformat-nonliteral -Wdate-time -Wnested-externs -Wshadow -Wstrict-prototypes -Wold-style-definition -Werror -Wredundant-decls -g -fPIC   -std=gnu11 -MD -MT libibverbs/CMakeFiles/ibverbs.dir/cmd_flow.c.o -MF libibverbs/CMakeFiles/ibverbs.dir/cmd_flow.c.o.d -o libibverbs/CMakeFiles/ibverbs.dir/cmd_flow.c.o   -c ../libibverbs/cmd_flow.c
> In file included from ../libibverbs/cmd_flow.c:33:
> In file included from include/infiniband/cmd_write.h:36:
> In file included from include/infiniband/cmd_ioctl.h:41:
> In file included from include/infiniband/verbs.h:48:
> In file included from include/infiniband/verbs_api.h:66:
> In file included from include/infiniband/ib_user_ioctl_verbs.h:38:
> include/rdma/ib_user_verbs.h:436:34: error: field 'base' with variable sized type 'struct ib_uverbs_create_cq_resp' not at the end of a struct or class is a GNU extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
>         struct ib_uverbs_create_cq_resp base;
>                                         ^
> include/rdma/ib_user_verbs.h:644:34: error: field 'base' with variable sized type 'struct ib_uverbs_create_qp_resp' not at the end of a struct or class is a GNU extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
>         struct ib_uverbs_create_qp_resp base;

This looks very similar, a struct of unknown size is being treated as a
header struct:

struct ib_uverbs_create_cq_resp {
        __u32 cq_handle;
        __u32 cqe;
        __aligned_u64 driver_data[0];
};

struct ib_uverbs_ex_create_cq_resp {
        struct ib_uverbs_create_cq_resp base;
        __u32 comp_mask;
        __u32 response_length;
};

And it only gets used here:

                DECLARE_UVERBS_WRITE(IB_USER_VERBS_CMD_CREATE_CQ,
                                     ib_uverbs_create_cq,
                                     UAPI_DEF_WRITE_UDATA_IO(
                                             struct ib_uverbs_create_cq,
                                             struct ib_uverbs_create_cq_resp),
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                     UAPI_DEF_METHOD_NEEDS_FN(create_cq)),

which must also be assuming it's a header. So probably better to just
drop the driver_data field? I don't see anything using it (that I can
find) besides as a sanity-check that the field exists and is at the end
of the struct.

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

