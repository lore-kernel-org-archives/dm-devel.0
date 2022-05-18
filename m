Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CB2C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 18 May 2022 14:41:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-397-jD5lgRd8PPqNXzrOPO9Rtg-1; Wed, 18 May 2022 10:41:08 -0400
X-MC-Unique: jD5lgRd8PPqNXzrOPO9Rtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D04E93C0D196;
	Wed, 18 May 2022 14:41:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 071291415101;
	Wed, 18 May 2022 14:40:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C227E1947B90;
	Wed, 18 May 2022 14:40:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B577A1947B8F
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 14:40:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A789D492CA4; Wed, 18 May 2022 14:40:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A3709492C3B
 for <dm-devel@redhat.com>; Wed, 18 May 2022 14:40:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A6DF8517F3
 for <dm-devel@redhat.com>; Wed, 18 May 2022 14:40:57 +0000 (UTC)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com
 [209.85.214.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-t2qOwv_9ORS-g6liBYsVEQ-1; Wed, 18 May 2022 10:40:56 -0400
X-MC-Unique: t2qOwv_9ORS-g6liBYsVEQ-1
Received: by mail-pl1-f173.google.com with SMTP id q4so1951959plr.11
 for <dm-devel@redhat.com>; Wed, 18 May 2022 07:40:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=whW5AxATJkNaPhkcMwvHXExGnVFe5uKOgct6URQZl5g=;
 b=wBsONLtUIpmD9tmvqxYFhc89gpyEvlp4nJb2Se+4xee+eAaPI3Je6zr1Fkk6u7a5bO
 BJqubxM49uDJ5m+Q00lKDZAG2hgJXU2leGQd82rpD4UF3BmwyB+TQvqe0isgz55SnvZr
 E4dKbz3NcY8e7Bpu2DO7FVkbKZeWtDKSdnpZgQ4utHmUzOQ5xN6LZEYpc6VmG48pyohs
 DxSl2LW9rYXMcK7Wmdb0ZpDP0k5MI97s9njqLEFNHp8vwAUA47teDbrwmxOPitPqIAP+
 PlCMlkKrHnRNqKk3AJNMctCmqP42wCD9zGMSA3fKRmxSFEobyu4ee9504jejd7n0jxN7
 Yvrg==
X-Gm-Message-State: AOAM533GvKnunpalUNweWCDjV4PhDKsGT4g/V0xZPjpU1abNc8lVzSpl
 JXJ95cZgyZNF6KMSMp2vfaE9kQ==
X-Google-Smtp-Source: ABdhPJxi6BpB2w+x5UbiM0DcD5h4zJd4JLNDZl6PoiWtNEvkeQJsQKjoUIcCxjgfHjR+3VH6nDKcpg==
X-Received: by 2002:a17:903:31d1:b0:159:804:e852 with SMTP id
 v17-20020a17090331d100b001590804e852mr27301661ple.19.1652884855095; 
 Wed, 18 May 2022 07:40:55 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:a14:3166:4b67:b688])
 by smtp.gmail.com with UTF8SMTPSA id
 j11-20020a17090ae60b00b001d95c09f877sm1642073pjy.35.2022.05.18.07.40.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 18 May 2022 07:40:54 -0700 (PDT)
Date: Wed, 18 May 2022 07:40:52 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: kernel test robot <lkp@intel.com>
Message-ID: <YoUFdBbwAvq71fQW@google.com>
References: <20220517163437.v4.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
 <202205181616.3eTP2DaC-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202205181616.3eTP2DaC-lkp@intel.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v4 2/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: Douglas Anderson <dianders@chromium.org>, kbuild-all@lists.01.org,
 Kees Cook <keescook@chromium.org>, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, James Morris <jmorris@namei.org>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, May 18, 2022 at 04:58:06PM +0800, kernel test robot wrote:
> Hi Matthias,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on device-mapper-dm/for-next]
> [also build test WARNING on song-md/md-next kees/for-next/pstore linus/master v5.18-rc7 next-20220517]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Matthias-Kaehlcke/LoadPin-Enable-loading-from-trusted-dm-verity-devices/20220518-073635
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20220518/202205181616.3eTP2DaC-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/intel-lab-lkp/linux/commit/755e5d82e4d054b2b58a54c94681080cc8cb4582
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Matthias-Kaehlcke/LoadPin-Enable-loading-from-trusted-dm-verity-devices/20220518-073635
>         git checkout 755e5d82e4d054b2b58a54c94681080cc8cb4582
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash security/loadpin/
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from security/loadpin/loadpin.c:21:
>    include/linux/dm-verity-loadpin.h:22:1: error: expected identifier or '(' before '{' token
>       22 | {
>          | ^
> >> include/linux/dm-verity-loadpin.h:21:20: warning: 'dm_verity_loadpin_is_sb_trusted' used but never defined
>       21 | static inline bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
>          |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> 
> vim +/dm_verity_loadpin_is_sb_trusted +21 include/linux/dm-verity-loadpin.h
> 
> afd03270f57b8c Matthias Kaehlcke 2022-05-17  17  
> afd03270f57b8c Matthias Kaehlcke 2022-05-17  18  #if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
> afd03270f57b8c Matthias Kaehlcke 2022-05-17  19  bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
> afd03270f57b8c Matthias Kaehlcke 2022-05-17  20  #else
> afd03270f57b8c Matthias Kaehlcke 2022-05-17 @21  static inline bool dm_verity_loadpin_is_sb_trusted(struct super_block *sb);
> afd03270f57b8c Matthias Kaehlcke 2022-05-17 @22  {
> afd03270f57b8c Matthias Kaehlcke 2022-05-17  23  	return false;
> afd03270f57b8c Matthias Kaehlcke 2022-05-17  24  }
> afd03270f57b8c Matthias Kaehlcke 2022-05-17  25  #endif
> afd03270f57b8c Matthias Kaehlcke 2022-05-17  26  

Oops, will fix

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

