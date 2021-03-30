Return-Path: <SRS0=BXbM=I4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD7BC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 03:30:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E859561490
	for <dm-devel@archiver.kernel.org>; Tue, 30 Mar 2021 03:30:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E859561490
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1617075031;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YgaO8UMfIs4CiTXnxcUUPUDxDEpcMy2HtQInwWp6BPc=;
	b=SDsQw3FFsOGDGLUc5o3A5t6s54kDEMYbtSOfAVuQumrc1J/Krr69PGWIOyPeHMVVRjQeK2
	boYCoAptkVE/0D3XjF8Lct9O7TJDHmklTUEdLYWDVgXwww7jHBb5IvMRF+SMvcBU1Yoeur
	1zfFXsQuZTzztWzSZidpEVfJ3pUeUrc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-i1GIfNQsP6GBwtaiBFPDyw-1; Mon, 29 Mar 2021 23:30:29 -0400
X-MC-Unique: i1GIfNQsP6GBwtaiBFPDyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDEF29CDA3;
	Tue, 30 Mar 2021 03:30:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A7245D768;
	Tue, 30 Mar 2021 03:30:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AEB371809C83;
	Tue, 30 Mar 2021 03:30:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12U3NZ6Z022249 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 23:23:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1F49A100239A; Tue, 30 Mar 2021 03:23:35 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9B5610023BE;
	Tue, 30 Mar 2021 03:23:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12U3NU91006652; 
	Mon, 29 Mar 2021 22:23:30 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12U3NTGG006651;
	Mon, 29 Mar 2021 22:23:29 -0500
Date: Mon, 29 Mar 2021 22:23:29 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20210330032329.GM15006@octiron.msp.redhat.com>
References: <20210326212944.3136-1-mwilck@suse.com>
	<20210326212944.3136-4-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20210326212944.3136-4-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [dm-devel] [PATCH 3/7] github workflows: add containerized /
 multi-arch tests
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 26, 2021 at 10:29:40PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Until now, our CI only tested builds on Ubuntu, the default github
> runner. This commit adds containerized build/test workflows, which can cover a
> much larger range of distributions and environments.
> 
> I've distinguished "native" runs, where the architecture is compatible with
> the architecture of the runners (assumed to be x86_64), and "foreign" runs
> with different architectures. The former can run "make test" just like in
> any ordinary environment. To run tests in "foreign arch" environments,
> I use qemu-user for runtime emulation. That's done with the help of the
> "multiarch/qemu-user-static" container. Runtime containers for testing need
> to have the qemu-user-static binary (compiled for x86_64) for their target
> architecture built in. In theory, we could do the same thing for build
> containers too, but it would be grossly inefficient. Instead, I've focused
> on Debian environments for the foreign architectures, relying on Debian's
> nice multiarch / cross-compilation features. Compilation is run in a dedicated
> cross-build container, and only the test runs are carried out in the emulation.
> 
> The set of tests currently includes:
> 
> native:
>  - Debian Jessie, x86_64/i386 (gcc 4.9, clang 3.5, glibc 2.19)
>  - Debian Buster, x86_64/i386 (gcc 8.3, clang 7.0, glibc 2.28)
>  - Debian Sid, x86_64/i386 (gcc 10.2, clang 11.0, glibc 2.31)
>  - Alpine, x86_64/i386 (gcc 10.2, clang 10.0, musl libc 1.2)
>  - Fedora 34, x86_64 (gcc 11.0, clang 12.0, glibc 2.33)
> 
> foreign:
>  - Debian Buster, ppc64le/aarch64/s390x
> 
> This covers a rather broad range of compiler and C library versions and
> should be fine for some time to come.
> 
> Note: In theory, it would be possible to just fetch base containers
> via github actions, and install the dependencies as part of the build
> procedure. But that would be quite resource-intensive and slow. Therefore
> I've decided to use pre-built containers. The current container setup
> fetches containers from my docker hub repository. The containers there
> (multipath-build-$os-$arch and multipath-run-$os-$arch) come from my
> "build-multipath" repository (https://github.com/mwilck/build-multipath),
> and are created via github actions, too. The upload of the built container
> images to docker hub requires the use of tokens and secrets.
> 
> I'd considered adding these container definitions and workflows to the
> multipath-tools repository. We'd just need to create reasonable rules
> for running the respective workflows. I expect these container images
> to remain relatively stable; it makes no sense to rebuild the images
> for every multipath-tools commit.
> 
> Tell me if you want this in the multipath-tools repo, and if you're ok
> with hosting the images in my docker hub repo.

I don't have problems with this setup. I haven't really looked into
github actions, and so really don't know how easy it setup rules to run
actions on events other that pushes, pull requests, etc. It seems
reasonable to store those in a seperate repository. It would probably be
good to have Christophe weigh in as well before adding these. Although I
suppose it's always possible to disable these actions in other repos.

-Ben
 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  .github/workflows/build-and-unittest.yaml |  4 +-
>  .github/workflows/foreign.yaml            | 65 +++++++++++++++++++++++
>  .github/workflows/native.yaml             | 31 +++++++++++
>  3 files changed, 99 insertions(+), 1 deletion(-)
>  create mode 100644 .github/workflows/foreign.yaml
>  create mode 100644 .github/workflows/native.yaml
> 
> diff --git a/.github/workflows/build-and-unittest.yaml b/.github/workflows/build-and-unittest.yaml
> index 4173576..bf37b13 100644
> --- a/.github/workflows/build-and-unittest.yaml
> +++ b/.github/workflows/build-and-unittest.yaml
> @@ -1,5 +1,7 @@
>  name: basic-build-and-ci
> -on:   [push]
> +on:
> +  push:
> +    branches: [master queue tip]
>  jobs:
>    bionic:
>      runs-on: ubuntu-18.04
> diff --git a/.github/workflows/foreign.yaml b/.github/workflows/foreign.yaml
> new file mode 100644
> index 0000000..505a777
> --- /dev/null
> +++ b/.github/workflows/foreign.yaml
> @@ -0,0 +1,65 @@
> +name: compile and unit test on foreign arch
> +on:
> +  push:
> +    branches:
> +      - master
> +      - queue
> +      - tip
> +
> +jobs:
> +
> +  build:
> +    runs-on: ubuntu-20.04
> +    strategy:
> +      matrix:
> +        os: [buster]
> +        arch: ['ppc64le', 'aarch64', 's390x']
> +    container: mwilck/multipath-build-${{ matrix.os }}-${{ matrix.arch }}
> +    steps:
> +      - name: checkout
> +        uses: actions/checkout@v1
> +      - name: build and test
> +        if: ${{ matrix.arch == '' || matrix.arch == '-i386' }}
> +        run: make test
> +      - name: build
> +        if: ${{ matrix.arch != '' && matrix.arch != '-i386' }}
> +        run: make test-progs
> +      - name: archive
> +        if: ${{ matrix.arch != '' && matrix.arch != '-i386' }}
> +        run: >
> +          tar cfv binaries.tar
> +          Makefile*
> +          libmpathcmd/*.so* libmultipath/*.so*
> +          tests/lib tests/*-test tests/Makefile tests/*.so*
> +      - uses: actions/upload-artifact@v1
> +        if: ${{ matrix.arch != '' && matrix.arch != '-i386' }}
> +        with:
> +          name: multipath-${{ matrix.os }}-${{ matrix.arch }}
> +          path: binaries.tar
> +
> +  test:
> +    runs-on: ubuntu-20.04
> +    needs: build
> +    strategy:
> +      matrix:
> +        os: [buster]
> +        arch: ['ppc64le', 'aarch64', 's390x']
> +    steps:
> +      - name: get binaries
> +        uses: actions/download-artifact@v1
> +        with:
> +          name: multipath-${{ matrix.os }}-${{ matrix.arch }}
> +      - name: unpack
> +        run: tar xfv multipath-${{ matrix.os }}-${{ matrix.arch }}/binaries.tar
> +      - name: enable foreign arch
> +        run: sudo docker run --rm --privileged multiarch/qemu-user-static:register --reset
> +      - name: run tests
> +        # Github actions doesn't support referencing docker images with
> +        # context variables. Workaround: use mosteo-actions/docker-run action
> +        # See https://github.community/t/expressions-in-docker-uri/16271
> +        uses: mosteo-actions/docker-run@v1
> +        with:
> +          image: mwilck/multipath-run-${{ matrix.os }}-${{ matrix.arch }}
> +          # The runner is an image that has "make" as entrypoint
> +          # So run "make -C tests" here
> +          command: -C tests
> diff --git a/.github/workflows/native.yaml b/.github/workflows/native.yaml
> new file mode 100644
> index 0000000..abd39a0
> --- /dev/null
> +++ b/.github/workflows/native.yaml
> @@ -0,0 +1,31 @@
> +name: compile and unit test on native arch
> +on:
> +  push:
> +    branches:
> +      - master
> +      - queue
> +      - tip
> +
> +jobs:
> +  build-and-test:
> +    runs-on: ubuntu-20.04
> +    strategy:
> +      matrix:
> +        os: [buster, jessie, sid, alpine, fedora-34]
> +        arch: ['', '-i386']
> +        exclude:
> +          - os: fedora-34
> +            arch: '-i386'
> +    container: mwilck/multipath-build-${{ matrix.os }}${{ matrix.arch }}
> +    steps:
> +      - name: checkout
> +        uses: actions/checkout@v1
> +      - name: build and test
> +        run: make test
> +      - name: clean
> +        run: make clean
> +      - name: clang
> +        env:
> +          CC: clang
> +        run: make test
> +
> -- 
> 2.30.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

