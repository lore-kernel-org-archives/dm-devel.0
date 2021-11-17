Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09E8C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:20:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5C5B261BD3
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 18:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C5B261BD3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637173252;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FasnvrRqb3OuxmVggxdK5lLfWrXJSEnGceDhhjmqOTw=;
	b=alo5pM3xyCyRO2Gt0p7N5muzEEH5SO2cUQw5OcbFU73pusvBFnnMy3VwOsE3uqDT3llt+i
	Zk/CcjV1cVtxZhmVhdXflJZVtHLvRVJn+XiYo/YDAWvP24y0Ja+VXZlqzAEMhV5ODyYmUk
	5eyy2NgDzTg2WZQ+TQWxO0ORMTmsxt8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-129-grrbMLeoPnm-CtjJMnHU5A-1; Wed, 17 Nov 2021 13:20:48 -0500
X-MC-Unique: grrbMLeoPnm-CtjJMnHU5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86398A40C0;
	Wed, 17 Nov 2021 18:20:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E07F100763D;
	Wed, 17 Nov 2021 18:20:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 55213180BAD2;
	Wed, 17 Nov 2021 18:20:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHIKcBn005914 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 13:20:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 88BB05F4EE; Wed, 17 Nov 2021 18:20:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E725D56A87;
	Wed, 17 Nov 2021 18:20:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHIKVRD003774; 
	Wed, 17 Nov 2021 12:20:31 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHIKUSK003773;
	Wed, 17 Nov 2021 12:20:30 -0600
Date: Wed, 17 Nov 2021 12:20:30 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20211117182030.GZ19591@octiron.msp.redhat.com>
References: <20211112210551.12744-1-mwilck@suse.com>
	<20211112210551.12744-2-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20211112210551.12744-2-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 2/3] multipath-tools: add github workflow to
 save and check ABI
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 12, 2021 at 10:05:50PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> This adds a workflow that saves the ABI of libmultipath and the
> other libraries, and optionally tests it against a known-good state,
> which is taken from the configurable ABI_BRANCH. If the ABI differs,
> the workflow fails, and the abidiff output is saved in GH actions
> as artifact "abi-test".
> 
> To configure the reference branch, set the repository secret ABI_BRANCH to the
> name of the branch that contains the ABI reference. The default is "master".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  .github/workflows/abi.yaml | 54 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
>  create mode 100644 .github/workflows/abi.yaml
> 
> diff --git a/.github/workflows/abi.yaml b/.github/workflows/abi.yaml
> new file mode 100644
> index 0000000..53f10d4
> --- /dev/null
> +++ b/.github/workflows/abi.yaml
> @@ -0,0 +1,54 @@
> +name: check-abi
> +on:
> +  - push
> +  - pull_request
> +env:
> +  ABI_BRANCH: ${{ secrets.ABI_BRANCH }}
> +
> +jobs:
> +  save-and-test-ABI:
> +    runs-on: ubuntu-20.04
> +    steps:
> +      - name: set ABI branch
> +        if: ${{ env.ABI_BRANCH == '' }}
> +        run: echo "ABI_BRANCH=master" >> $GITHUB_ENV
> +      - name: checkout
> +        uses: actions/checkout@v2
> +      - name: get reference ABI
> +        id: reference
> +        continue-on-error: true
> +        uses: dawidd6/action-download-artifact@v2
> +        with:
> +          workflow: abi.yaml
> +          branch: ${{ env.ABI_BRANCH }}
> +          name: abi
> +          path: reference-abi
> +      - name: update
> +        run: sudo apt-get update
> +      - name: dependencies
> +        run: >
> +          sudo apt-get install --yes gcc
> +          gcc make pkg-config abigail-tools
> +          libdevmapper-dev libreadline-dev libaio-dev libsystemd-dev
> +          libudev-dev libjson-c-dev liburcu-dev libcmocka-dev
> +      - name: create ABI
> +        run: make -O -j$(grep -c ^processor /proc/cpuinfo) abi.tar.gz
> +      - name: save ABI
> +        uses: actions/upload-artifact@v1
> +        with:
> +          name: abi
> +          path: abi
> +      - name: compare ABI against reference
> +        id: compare
> +        continue-on-error: true
> +        if: ${{ steps.reference.outcome == 'success' }}
> +        run: make abi-test
> +      - name: save differences
> +        if: ${{ steps.compare.outcome == 'failure' }}
> +        uses: actions/upload-artifact@v1
> +        with:
> +          name: abi-test
> +          path: abi-test
> +      - name: fail
> +        if: ${{ steps.compare.outcome == 'failure' }}
> +        run: false
> -- 
> 2.33.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

