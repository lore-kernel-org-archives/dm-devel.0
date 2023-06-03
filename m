Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA84C7EE24
	for <dm-devel@archiver.kernel.org>; Sat,  3 Jun 2023 11:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685790745;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=H2vrqpAEOa2VyAKzxjEbe68QNIaUZvfso3k6sE49IcA=;
	b=Ybs4uM+KIAGqOqVpPa+27vuK7ixiNWGF5JgIOpTKOA6WXHpfPy4NZ7MFCgeGwDr0V4rRRf
	zjZQtHGAtU3X3YHQ/szt2Jqbj3JMPou9sdutHXcr/YQKaHb4kdjB+TT9Rmhw3bq381a0da
	wWZ+R5IPYGlDc5uW3ClriyNYbA9glAE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-5EjKczXsPZ-ASs0lyie11A-1; Sat, 03 Jun 2023 07:12:22 -0400
X-MC-Unique: 5EjKczXsPZ-ASs0lyie11A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 632881C05AE5;
	Sat,  3 Jun 2023 11:12:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 001392166B27;
	Sat,  3 Jun 2023 11:12:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C64219465A0;
	Sat,  3 Jun 2023 11:12:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 65B521946595
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Jun 2023 11:12:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1FBD61121315; Sat,  3 Jun 2023 11:12:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 18C611121314
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 11:12:15 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE9EC3C025B3
 for <dm-devel@redhat.com>; Sat,  3 Jun 2023 11:12:14 +0000 (UTC)
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com
 [209.85.221.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-l1jp36O1NUe_PaOoK8jAaA-1; Sat, 03 Jun 2023 07:12:13 -0400
X-MC-Unique: l1jp36O1NUe_PaOoK8jAaA-1
Received: by mail-wr1-f43.google.com with SMTP id
 ffacd0b85a97d-30ae61354fbso2834457f8f.3; 
 Sat, 03 Jun 2023 04:12:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685790732; x=1688382732;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=ihkMmQOYGbz7VgIDw4gmn+P+HLeTxRdmojf2ZtV0iV8=;
 b=FkNouOUHPyt4Jxq9wfMgYhumbT+gncR+t/+XQzvWQbNNulI4LXbV4mTEaz/jMn7FXm
 oGc85fQsZGQa/28qwCdyKBlAxrYOYL2aBYnzWfNBcGW5NcG3VU83vdHIfm5wkg4B/5o7
 7HQICfwnpOXRZ93kQxfWYE6mSg8vBjR29SJUmeBOmgZTe+bAGgkbsjaQ641Uqo5F+x/7
 L13oKIuphCAVqPl6e98uql6poWC2M5/dAx++1Wr4uDA15hk0eiVsdDKj8qPal2lfJ3n9
 GSFMAVWbM/4LEIu1UDSx2xw1DYnSD7rLvUy5lvQXOF2Uyok5pd5xpXA+G2Xd2UddLbpb
 ahVw==
X-Gm-Message-State: AC+VfDzU0faQksl+k0CQlDe8Qcu7k4pjugo3Eb65OgYGjhL8B+uZneDw
 6XmfIi/GN3Ep56h6OuyUh7JyO2xI1A==
X-Google-Smtp-Source: ACHHUZ4h4cfT1K3hsVTADqW/UGlFv1KTzfQSB5f70dfZOpKU5ZwJcMApzDxlQdlvwSPsBptIVM83SA==
X-Received: by 2002:a5d:6304:0:b0:30a:ecf3:c9e9 with SMTP id
 i4-20020a5d6304000000b0030aecf3c9e9mr1857509wru.5.1685790731385; 
 Sat, 03 Jun 2023 04:12:11 -0700 (PDT)
Received: from localhost (245.red-81-44-183.dynamicip.rima-tde.net.
 [81.44.183.245]) by smtp.gmail.com with ESMTPSA id
 q25-20020a7bce99000000b003f182a10106sm4740598wmj.8.2023.06.03.04.12.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 03 Jun 2023 04:12:10 -0700 (PDT)
Message-ID: <8a1a8cb2-565c-6647-0424-548eaca34a78@gmail.com>
Date: Sat, 3 Jun 2023 13:12:09 +0200
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>
References: <20230531135713.13914-1-xose.vazquez@gmail.com>
 <38c4b77c419ca811a839f8eb24e6425d74eef1ab.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <38c4b77c419ca811a839f8eb24e6425d74eef1ab.camel@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH] multipath-tools: adapt HITACHI/OPEN- config
 to work with alua and multibus
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
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 5/31/23 17:49, Martin Wilck wrote:

> On Wed, 2023-05-31 at 15:57 +0200, Xose Vazquez Perez wrote:
>> ALUA is needed by Hitachi Global-Active Device (GAD):
>> https://knowledge.hitachivantara.com/Documents/Management_Software/SVOS/8.1/Global-Active_Device/Overview_of_global-active_device

> Thanks, but where exactly did you find this information in the linked
> document? I don't see ALUA mentioned. Unfortunately Hitachi chose to
> use non-standard terminology... 

No public info, personal e-mail from Matthias:

"We have also a config for ALUA. It is used for hardware copy between two
arrays and the server should only use the local paths:

SLES 12 SP2 ALUA:

device {
            vendor               "HITACHI"
            product              "OPEN-.*"
            features             "0"
            path_grouping_policy group_by_prio
            prio                 alua
            path_selector        "round-robin 0"
            rr_weight            uniform
            no_path_retry        1
            rr_min_io            100
            path_checker         directio
            failback             immediate
      }
"

 > Is ALUA always active / supported in these arrays?

Disable by default. And it is only needed with GAD setup:

Array settings:
"ALUA Mode" Enabled
"Path Mode" ALUA
"ALUA Permitted" YES
"ALUA Settable" YES
"Target Port Asymmetric Access State" Active/Optimized

Same case as HUAWEI https://github.com/opensvc/multipath-tools/commit/9283fa6663ad908fd0419edcef4795fbbbe9f09d

"no_path_retry 10" comes from: 
https://knowledge.hitachivantara.com/Documents/Management_Software/SVOS/9.8.6/Volume_Management_-_VSP_5000_Series/Host_Attachment/05_Red_Hat_Linux_configuration_and_attachment#Device_Mapper_(DM)_Multipath_configuration.0D.0A____for_Red_Hat_Linux

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

