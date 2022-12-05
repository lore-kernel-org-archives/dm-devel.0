Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC33CC4321E
	for <dm-devel@archiver.kernel.org>; Mon,  5 Dec 2022 10:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670237886;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wfnshNh1pz2jaY7Wscw7C02s07ed5uZxSHRSCj+nu8g=;
	b=FTB/7BXQ5/Ch6K7w2VIzxo0OheZN7Ea5wfkfuLhOjM9hmTw3YhrTP0SxhJCSso2WEFZ9iW
	gXAp6h3tHE8spgN7aWlwLULFMf5M5YXcZGNiJVIzz+3yewn+t02vjcqwDc+eqwC2c5HdzY
	AoArUlvgevWgq6ixX1pH5pMQe3xVPL4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-xwIbH8P7NOmQVtUJjteahQ-1; Mon, 05 Dec 2022 05:58:03 -0500
X-MC-Unique: xwIbH8P7NOmQVtUJjteahQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60C7A29AA3B4;
	Mon,  5 Dec 2022 10:58:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4715D40C2089;
	Mon,  5 Dec 2022 10:57:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2367E1946589;
	Mon,  5 Dec 2022 10:57:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 38D6B1946588
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Dec 2022 10:57:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 27AB52024CBF; Mon,  5 Dec 2022 10:57:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F8F52024CBB
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 10:57:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0127485A59D
 for <dm-devel@redhat.com>; Mon,  5 Dec 2022 10:57:56 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-489-I1m2OyUnMEKUx7c3b0yB9Q-1; Mon,
 05 Dec 2022 05:57:54 -0500
X-MC-Unique: I1m2OyUnMEKUx7c3b0yB9Q-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 8E84022809;
 Mon,  5 Dec 2022 10:57:52 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 672B11348F;
 Mon,  5 Dec 2022 10:57:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap1.suse-dmz.suse.de with ESMTPSA id VMOPF7DOjWNcFwAAGKfGzw
 (envelope-from <mwilck@suse.com>); Mon, 05 Dec 2022 10:57:52 +0000
Message-ID: <6c3816eb0aab6c027399cc9e6080a36f438a8ca1.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
 <bmarzins@redhat.com>
Date: Mon, 05 Dec 2022 11:57:51 +0100
In-Reply-To: <20221202234338.2960-1-mwilck@suse.com>
References: <20221202234338.2960-1-mwilck@suse.com>
User-Agent: Evolution 3.46.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v2] libmultipath: is_path_valid(): check if
 device is in use
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sat, 2022-12-03 at 00:43 +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> To check whether we will be able to add a given device can be part
> of a multipath map, we have two tests in check_path_valid():
> released_to_systemd() and the O_EXCL test. The former isn't helpful
> if "multipath -u" is called for the first time for a given device,
> and the latter is only used in the "find_multipaths smart" case,
> because
> actively opening the device with O_EXCL, even for a very short time,
> is prone
> to races with other processes.
> 
> It turns out that this may cause issues in some scenarios. We saw
> problems in
> once case where "find_multipaths greedy" was used with a single
> non-multipahted root disk and a very large number of multipath LUNs.
> The root disk would first be classified as multipath device.
> multipathd
> would try to create a map, fail (because the disk was mounted) and
> trigger another uevent. But because of the very large number of
> multipath
> devices, this event was queued up behind thousands of other events,
> and
> the root device timed out eventually.
> 
> While a simple workaround for the given problem would be proper
> blacklisting
> or using a different find_multipaths mode, I am proposing a different
> solution here. An additional test is added in is_path_valid() which
> checks whether the given device is currently in use by 1. sysfs
> holders,
> 2. mounts (from /proc/self/mountinfo) or 3. swaps (from /proc/swaps).
> 2.
> and 3. are similar to systemd's device detection after switching
> root.
> This must not only be done for the device itself, but also for all
> its
> partitions. For mountinfo and swaps, libmount is utilized.
> 
> With this patch, "multipath -u" will make devices with mounted or
> otherwise
> used partitions available to systemd early, without waiting for
> multipathd
> to fail setting up the map and re-triggering an uevent. This should
> avoid
> the issue described above even without blacklisting. The downside of
> it
> is a longer runtime of "multipath -u" for almost all devices, in
> particular
> for real multipath devices. The runtime required for the new checks
> was in the
> order of 0.1ms-1ms in my tests. Moreover, there is a certain risk
> that devices may
> wrongly classified as non-multipath because of transient mounts or
> holders
> created by other processes.
> 
> To make this code compile on older distributions, we need some
> additional
> checks in create-config.mk.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Sorry, I forgot:

Changes RFC -> v2:

 - only make the in-use check for "smart" and "greedy" setups (Ben
Marzinski)
 - remove wrong "break" statements (Ben)
 - add another malloc NULL check (Ben)
 - Add compatibility checks for older versions of libmount (me)

Martin  

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

