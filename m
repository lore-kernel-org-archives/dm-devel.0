Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE45C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 21 Feb 2022 06:07:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-B0UZBE--P5ySyR8uOoJ9UQ-1; Mon, 21 Feb 2022 01:07:05 -0500
X-MC-Unique: B0UZBE--P5ySyR8uOoJ9UQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A9D0814246;
	Mon, 21 Feb 2022 06:07:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4ED85DBA5;
	Mon, 21 Feb 2022 06:07:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C97F31809CAA;
	Mon, 21 Feb 2022 06:06:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HMCVR7028667 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 17:12:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2535B5361F9; Thu, 17 Feb 2022 22:12:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2176C5361DA
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 22:12:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09CA4811E81
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 22:12:31 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-518-s57KWLYeOt2Z5c14HDnI-Q-1; Thu, 17 Feb 2022 17:12:29 -0500
X-MC-Unique: s57KWLYeOt2Z5c14HDnI-Q-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id E4ABEB82486;
	Thu, 17 Feb 2022 22:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B94EC340E8;
	Thu, 17 Feb 2022 22:07:01 +0000 (UTC)
MIME-Version: 1.0
In-Reply-To: <1644890154-64915-3-git-send-email-wangqing@vivo.com>
References: <1644890154-64915-1-git-send-email-wangqing@vivo.com>
	<1644890154-64915-3-git-send-email-wangqing@vivo.com>
From: Stephen Boyd <sboyd@kernel.org>
To: "Pan, Xinhui" <Xinhui.Pan@amd.com>, Alasdair Kergon <agk@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Christian =?utf-8?q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Daniel Vetter <daniel@ffwll.ch>, David Airlie <airlied@linux.ie>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jikos@kernel.org>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Mike Snitzer <snitzer@redhat.com>, Qing Wang <wangqing@vivo.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Roger Pau =?utf-8?q?Monn=C3=A9?= <roger.pau@citrix.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	amd-gfx@lists.freedesktop.org, dm-devel@redhat.com,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesk.top.org,
	linux-block@vger.kernel.org, linux-clk@vger.kernel.org,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, xen-devel@lists.xenproject.org
Date: Thu, 17 Feb 2022 14:06:58 -0800
User-Agent: alot/0.10
Message-Id: <20220217220701.9B94EC340E8@smtp.kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21HMCVR7028667
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 21 Feb 2022 01:04:54 -0500
Cc: Wang Qing <wangqing@vivo.com>
Subject: Re: [dm-devel] [PATCH V3 2/13] clk: mvebu: use
	time_is_before_eq_jiffies() instead of open coding it
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Quoting Qing Wang (2022-02-14 17:55:39)
> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---

Applied to clk-next


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

