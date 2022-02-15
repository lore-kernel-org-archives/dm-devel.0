Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F04C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 06:28:40 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-noRZN7V6P5a4rcWaF4VEDQ-1; Wed, 16 Feb 2022 01:28:35 -0500
X-MC-Unique: noRZN7V6P5a4rcWaF4VEDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02D3418397B3;
	Wed, 16 Feb 2022 06:28:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D7DB4108BA;
	Wed, 16 Feb 2022 06:28:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A9D051809CB9;
	Wed, 16 Feb 2022 06:28:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21FMxYPq016946 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Feb 2022 17:59:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4A6705361F7; Tue, 15 Feb 2022 22:59:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 46BC0401E37
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 22:59:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DC691800046
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 22:59:34 +0000 (UTC)
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com
	[209.85.216.50]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-32-oHfupT18OHOpz9lML3Kg-g-1; Tue, 15 Feb 2022 17:59:30 -0500
X-MC-Unique: oHfupT18OHOpz9lML3Kg-g-1
Received: by mail-pj1-f50.google.com with SMTP id
	ki18-20020a17090ae91200b001b8be87e9abso2763414pjb.1; 
	Tue, 15 Feb 2022 14:59:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Ydg/QaEHk+YtzGHqWPzjDmBjfyy2f1JmjiAxPzP8crc=;
	b=E/OW3wSrX8JMu5RFVkHdtwu/dk4Uuw1SxtpRfAi0tnU1ItoKL67iWH4g/QRs7bLm7v
	m4IWqbu9Gw0TfEHIvsmXdrR6ihuEbZMiXz0Wu5cplZrDHqILYLWLk7wu6DZIx7Mdg84R
	o0XjPpkhcOGxLM7KxSBQlBKTCjrPBiwG53jjtG3uy9g54ueBLUHoP0rIQ1dpUoyir3dM
	bYv1QrVEKpkvSEJHjb9KqrUaU3TCjm+V3MPxJAqLsTiwL+mUVYetBtQp5Kj7wgkWL8Kd
	s/VWMwUxliRBLyEFAU41/9zmjyRk0iVUnqIgGPYqCTe45n5b7Zy4sjUsjZeeuhDxqQwg
	5Vjw==
X-Gm-Message-State: AOAM530SHvvHAsOa1fbtLFIfQDHNQrPXfmdxYywV9zR5y8ZaaDcmx8a7
	g8Af6hOgJiRaXh08mh1E6Wg=
X-Google-Smtp-Source: ABdhPJzD5VTWuMUJjUi6d0x1rXiN3okRfTcvfy3+tsDIIsH6bfb6SZ+FiyUr2n1wCBp6WTu5fGOOUA==
X-Received: by 2002:a17:902:f686:: with SMTP id l6mr1079179plg.7.1644965965923;
	Tue, 15 Feb 2022 14:59:25 -0800 (PST)
Received: from google.com ([2620:15c:202:201:4e4a:b0ff:e926:40e2])
	by smtp.gmail.com with ESMTPSA id
	n85sm10430319pfd.142.2022.02.15.14.59.23
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 15 Feb 2022 14:59:25 -0800 (PST)
Date: Tue, 15 Feb 2022 14:59:21 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Qing Wang <wangqing@vivo.com>
Message-ID: <YgwwSUlZVakiYF8j@google.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
	<1644890154-64915-7-git-send-email-wangqing@vivo.com>
MIME-Version: 1.0
In-Reply-To: <1644890154-64915-7-git-send-email-wangqing@vivo.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 16 Feb 2022 01:28:09 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, David Airlie <airlied@linux.ie>,
	Michael Turquette <mturquette@baylibre.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	dri-devel@lists.freedesktop.org,
	Hans Verkuil <hverkuil@xs4all.nl>, dm-devel@redhat.com,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	linux-clk@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
	amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-media@vger.kernel.org,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	intel-gfx@lists.freedesktop.org, Jiri Kosina <jikos@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>, linux-block@vger.kernel.org,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Stephen Boyd <sboyd@kernel.org>,
	"Pan, Xinhui" <Xinhui.Pan@amd.com>, linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel@ffwll.ch>, Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Subject: Re: [dm-devel] [PATCH V3 6/13] input: serio: use
 time_is_before_jiffies() instead of open coding it
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Wang,

On Mon, Feb 14, 2022 at 05:55:43PM -0800, Qing Wang wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.

I applied changes by Danilo Krummrich converting the driver to use
ktime_t (see https://lore.kernel.org/r/20220215160208.34826-3-danilokrummrich@dk-develop.de)
which makes this change not applicable.

Thanks.

-- 
Dmitry

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

