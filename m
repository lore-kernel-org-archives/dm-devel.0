Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D62C05027
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 15:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675871570;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8vkp6VwZgononiHnrxheiMjHgAsophH/gF+aowHBU8g=;
	b=QeK5nKtB+Gys3oV7I87RZHPOPpnILMFujy3aPu9gn9vVwMFVHlF1dSOfF1KkJcTs8Z5sLB
	cXUF75KuEUMoNTAwaxrjl1XVNqGBbOKhRYqvWngQoRn+RV2LPLEA+1q9iOxjpAyRI8WN8N
	Fj+juERxQUXvpHarhjmi2LeTDPvfLVo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-StPfNEJ4Odypdmz_rlP2_Q-1; Wed, 08 Feb 2023 10:52:47 -0500
X-MC-Unique: StPfNEJ4Odypdmz_rlP2_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 649F4800B24;
	Wed,  8 Feb 2023 15:52:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 43427175A2;
	Wed,  8 Feb 2023 15:52:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 347BF194658D;
	Wed,  8 Feb 2023 15:52:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 109EE194658D
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Feb 2023 15:52:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6E05D175AD; Wed,  8 Feb 2023 15:52:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 46E0E175A2;
 Wed,  8 Feb 2023 15:52:38 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 318Fqaa1029536;
 Wed, 8 Feb 2023 09:52:37 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 318FqaNC029535;
 Wed, 8 Feb 2023 09:52:36 -0600
Date: Wed, 8 Feb 2023 09:52:36 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20230208155236.GE17327@octiron.msp.redhat.com>
References: <1675816336-24371-1-git-send-email-bmarzins@redhat.com>
 <c9bb45183e47591f9a6fe1bca9f695a697e7fd62.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <c9bb45183e47591f9a6fe1bca9f695a697e7fd62.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] multipath.rules: fix "smart" bug with failed
 valid path check
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 08, 2023 at 07:35:36AM +0000, Martin Wilck wrote:
> Hello Ben,
> 
> On Tue, 2023-02-07 at 18:32 -0600, Benjamin Marzinski wrote:
> > If "multipath -u" fails, udev doesn't import any values from the
> > program. This means that multipath.rules will continue to use the
> > values
> > for DM_MULTIPATH_DEVICE_PATH and FIND_MULTIPATHS_WAIT_UNTIL that it
> > has
> > already imported from the database. This is the correct thing to do
> > for
> > every case except the MAYBE case for "find_multipaths smart". In that
> > case, DM_MULTIPATH_DEVICE_PATH will be set to 1, and the rules will
> > assume that the device has been definitively claimed.
> > 
> > In this case, we know that the device shouldn't have been claimed
> > before, but we don't know if it should be claimed now, or if we have
> > hit
> > the timeout and it should be released, since we didn't get any
> > information from multipath. The safest thing to do is assume that
> > this
> > was the timeout, and the device shouldn't be claimed. The only time
> > when
> > this could be the wrong answer is when we first see a new multipath
> > device, and it could only cause problems if there is metadata on the
> > device that will cause it to get autoassembled by something else,
> > before
> > multipathd can autoassemble it. If we assume that it is a multipath
> > device, or we assume that this wasn't actually the timeout uevent, we
> > can keep a necessary device from getting released to the reset of the
> > system.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> We have this code in check_path_valid():
> 
> 	/*
> 	 * multipath -u must exit with status 0, otherwise udev won't
> 	 * import its output.
> 	 */
> 	if (!is_uevent && r == PATH_IS_NOT_VALID)
> 		r = RTVL_FAIL;
> 	else
> 		r = RTVL_OK;
> 
> 
> AFAICS about the only condition I can imagine in which "multipath -u"
> would return an exit status other than 0 would be failure of
> init_config(). If that's the case you're concerned about, the issue
> might be easier to fix in main.c directly. 

I'm tracking down a bug where it appears that either "multpath -u"
failed and caused this issue or incorrectly returned
DM_MULTIPATH_DEVICE_PATH=1. I'm still not sure what exactly happened,
but when going over the code I noticed this issue was possible and it
doesn't seem like it should be. I don't think it's very likely that this
is the issue that occurred in the bug I'm looking into, but I do think
that this is possible for errors other than a config problem.  First,
any memory issue would cause this. Obviously, there's a good chance
that the whole system has bigger issues in that case. Second, we do rely
on the udev library to not fail in a number of places, notably
path_discovery(). Third, we rely on filesystem code in places like
is_failed_wwid(). None of these issue individually bothers me, but since
we can protect the system from an unexpected failure here, it seems
reasonable to do so. Obviously we can solve all of them except a memory
failure or an init_config() issue by making sure check_path_valid() never
returns failure in the uevent case, but it seems more reasonable to me
to actually fail, and have udev handle that. But like I said, I don't
think I've actually seen this issue in practice.

I don't think the udev changes are that intrusive, they only happen in
case where you are running with "find_multipaths smart" and getting a
uevent for a MAYBE path, and aside from changing

ENV{FIND_MULTIPATHS_WAIT_CANCELLED}!="?*", \
        ENV{FIND_MULTIPATHS_WAIT_UNTIL}=="?*", \
        ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="0", \
        ENV{FIND_MULTIPATHS_WAIT_CANCELLED}="1", \
        RUN+="/usr/bin/systemctl stop cancel-multipath-wait-$kernel.timer"

Into:

ENV{FIND_MULTIPATHS_WAIT_CANCELLED}=="?*", GOTO="end_mpath"
ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="?*", GOTO="end_mpath"
ENV{FIND_MULTIPATHS_WAIT_UNTIL}=="0", GOTO="end_mpath"

ENV{FIND_MULTIPATHS_WAIT_CANCELLED}="1"
RUN+="/usr/bin/systemctl stop cancel-multipath-wait-$kernel.timer"

which is functionally the same, the only change is to check if
"multipath -u" failed, and if so, set DM_MULTIPATH_DEVICE_PATH=0,
instead of what we are currently doing implicitly with the

IMPORT{db}="DM_MULTIPATH_DEVICE_PATH"

which is to set DM_MULTIPATH_DEVICE_PATH=1 if "multipath -u" failed.

Unless it turns out that my bug was acutally caused by this, I'm not
super invested in these changes, but I do think they are a reasonable
way to catch an unlikely issue, without having to design the multipath
code around the possibility.

-Ben

> 
> Regards,
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

