Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E120F1C281
	for <dm-devel@lists.linux.dev>; Thu,  2 Nov 2023 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-66d190a8f87so6095406d6.0
        for <dm-devel@lists.linux.dev>; Thu, 02 Nov 2023 08:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698937917; x=1699542717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gwdjCz3p054/qfAx418mOQeQ+vkKeZzabw6pnxMbFjw=;
        b=Q45nWm2ayZxZKPcnEHl4QJrfL38YD2Ku4p7C7sBa7K0FY/gMtT6OkKgkao6xFa+lKV
         vWaSfHB32ZIqL6vO5l2uMlANzVdPk83bEnXxCPuB1sG9u7Xp+zBaKI3l4nuylnlbCD/D
         RigtNHq5fyj4X0h7LiTS6mFzswOp5qmaZyEwfrPN7hHgvgOTr928bQcOyaHFC+3teXia
         3JLTWd4mHogBeG1kJDdaa7SExGKK2+3Ojt5qKqdh4J/BqnlooB/Qq2tHP5BzLPysypVV
         ApldqvSTukvrBizF2nHERbU2gZok50c1oVQnvPcjsGBRhUfGrxSatNr+eNukQBmJMazy
         xolw==
X-Gm-Message-State: AOJu0Yx4znKog/D6PFkfJafcNRYVf2R846x8yQV/IKVsdPb0mzbOXYl/
	Yr79AeCmUzTYJpoJsX1lUyXC
X-Google-Smtp-Source: AGHT+IENOaDYT9mgiKPmNf+6N6UadznvVhjZX3tUc303bGU7z17HNCkbaTezjP2F5pHkvNRP2gG2aQ==
X-Received: by 2002:ad4:5f08:0:b0:672:3a8a:b1ab with SMTP id fo8-20020ad45f08000000b006723a8ab1abmr14559493qvb.15.1698937916805;
        Thu, 02 Nov 2023 08:11:56 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id i9-20020a0cfd29000000b0063f88855ef2sm16920qvs.101.2023.11.02.08.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 08:11:55 -0700 (PDT)
Date: Thu, 2 Nov 2023 11:11:54 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Matthew Sakai <msakai@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, dm-devel@lists.linux.dev,
	"J. corwin Coburn" <corwin@hurlbutnet.net>,
	John Wiele <jwiele@redhat.com>, kernel test robot <lkp@intel.com>
Subject: Re: [device-mapper-dm:dm-vdo-wip 55/90]
 drivers/md/dm-vdo/block-map.h:35:37: warning: 'UNMAPPED_BLOCK_MAP_ENTRY'
 defined but not used
Message-ID: <ZUO8OiRFhUNlC2rR@redhat.com>
References: <202311021353.WMMPQspU-lkp@intel.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202311021353.WMMPQspU-lkp@intel.com>

[lkp: please update your scripts to use the new
dm-devel@lists.linux.dev when emailing dm-devel. The MAINTAINERS file
was updated so I don't know why you'd still be using the old
dm-devel@redhat.com address]

On Thu, Nov 02 2023 at  1:43P -0400,
kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-vdo-wip
> head:   d4e7d305aaa9738d9606f986ad8f2f01edbb14b3
> commit: 5a6d19abe1dc27648b64418df24ea0acef0f38d6 [55/90] dm vdo: enable configuration and building of dm-vdo
> config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20231102/202311021353.WMMPQspU-lkp@intel.com/config)
> compiler: alpha-linux-gcc (GCC) 13.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231102/202311021353.WMMPQspU-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202311021353.WMMPQspU-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from drivers/md/dm-vdo-target.c:16:
> >> drivers/md/dm-vdo/block-map.h:35:37: warning: 'UNMAPPED_BLOCK_MAP_ENTRY' defined but not used [-Wunused-const-variable=]
>       35 | static const struct block_map_entry UNMAPPED_BLOCK_MAP_ENTRY = {
>          |                                     ^~~~~~~~~~~~~~~~~~~~~~~~
> >> drivers/md/dm-vdo/block-map.h:34:38: warning: 'NO_PAGE' defined but not used [-Wunused-const-variable=]
>       34 | static const physical_block_number_t NO_PAGE = 0xFFFFFFFFFFFFFFFF;
>          |                                      ^~~~~~~
> 
> 
> vim +/UNMAPPED_BLOCK_MAP_ENTRY +35 drivers/md/dm-vdo/block-map.h
> 
> fd98f3e3ccc645 Matthew Sakai 2023-10-26  33  
> 15deeca3859a19 Matthew Sakai 2023-10-26 @34  static const physical_block_number_t NO_PAGE = 0xFFFFFFFFFFFFFFFF;
> 15deeca3859a19 Matthew Sakai 2023-10-26 @35  static const struct block_map_entry UNMAPPED_BLOCK_MAP_ENTRY = {
> 15deeca3859a19 Matthew Sakai 2023-10-26  36  	.mapping_state = VDO_MAPPING_STATE_UNMAPPED & 0x0F,
> 15deeca3859a19 Matthew Sakai 2023-10-26  37  	.pbn_high_nibble = 0,
> 15deeca3859a19 Matthew Sakai 2023-10-26  38  	.pbn_low_word = __cpu_to_le32(VDO_ZERO_BLOCK & UINT_MAX),
> 15deeca3859a19 Matthew Sakai 2023-10-26  39  };
> 15deeca3859a19 Matthew Sakai 2023-10-26  40  
> 
> :::::: The code at line 35 was first introduced by commit
> :::::: 15deeca3859a19abfaadd333fb3df7a45087ab3e dm vdo: implement the block map page cache
> 
> :::::: TO: Matthew Sakai <msakai@redhat.com>
> :::::: CC: Mike Snitzer <snitzer@kernel.org>
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 

UNMAPPED_BLOCK_MAP_ENTRY isn't defined until commit 15deeca3859a1 but
it is used by the earlier commit fd98f3e3ccc645.  So it needs moving
to that earlier commit.

But that aside, the above warning is correctly complaining about the
definition of static variables that aren't ever used.  We need to
define in block-map.c but declare them as extern in block-map.h

I've fixed this up in linux-dm.git's dm-vdo (and rebased dm-vdo-wip)
