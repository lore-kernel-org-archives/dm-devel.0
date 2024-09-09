Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A66B125DE;
	Mon,  9 Sep 2024 02:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725849447; cv=none; b=QGQzYcom74CszF3cnvypQyC0g9QZaJgtN6H8lVy30QQrnvTpJvmQP4R5MfSZpwB+qd/qZc/GWFVrefrtmxOKK7fviCUbjIYHkQohLFSZWepAqZSTWGmpXgTpub/o+Y9oyB4wZ0lMnpyMMDt1LAkZlzM83LxjP3p1ttEKJylCclI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725849447; c=relaxed/simple;
	bh=O+0mjkCthsATG7MeX0u3pNw32ndnergdq01LWGku7oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8HodNDqIOpcnRfdLGtB2R2yCNHVaUVIhq/pWL7yNu0OrjRwXtw99eWpDhkc/jw7UGEdy7RPfuscdVjBMPWqV78L0T0C0zy+CM1dYZYZUCYag6gtrNShYASIsaYf2RuV+QNTkuzIyM9PZVkFeCFrKR7G1F08vHUP8bNkG4SLATI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gTC7grNA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gTC7grNA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725849446; x=1757385446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O+0mjkCthsATG7MeX0u3pNw32ndnergdq01LWGku7oo=;
  b=gTC7grNA1vlB7yNoIYi7KwZCIY0kArnqzQxt9y+wO6LYv1YXkTc1R5fg
   TLiNtMPUYhMKvlTQK6qjwxdCmDxga9tdfNe+NmrWJzmChC3v0mX+Ue2PH
   RAt/58rq2m1AgOgwpquzRYxKY+yl5FujZ8SK9nA6UPgqB8roFWE61O+Fh
   ajtLZro3jXyKA4cnpLkTfVfcw4ewNhRf8pvXF139kBndjjBNvUz4aSy5m
   +9FJtYgG4xQGRMRJ79uU9CXgzg+Wclze2RzfS3HVmTKCvR2AWwqM34va3
   dGxS66Y4/FufdX5A47sxKt5lVfkW5VkXs7a/xRKt7OrTpzZw2KrgQo8kN
   A==;
X-CSE-ConnectionGUID: XBoHTZXQQMK67r9LBapBew==
X-CSE-MsgGUID: H8j2DBCqR66a1wyn27fFzg==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="35116341"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="35116341"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 19:37:25 -0700
X-CSE-ConnectionGUID: Hn3HVCeLScqiIBMtNxxKEQ==
X-CSE-MsgGUID: 12+elI1BSBqCKsDT8dkM9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="66511125"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 08 Sep 2024 19:37:18 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1snUHE-000EDZ-1I;
	Mon, 09 Sep 2024 02:37:16 +0000
Date: Mon, 9 Sep 2024 10:36:49 +0800
From: kernel test robot <lkp@intel.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH v6 11/17] soc: qcom: ice: add support for generating,
 importing and preparing keys
Message-ID: <202409091043.FwxHoaRd-lkp@intel.com>
References: <20240906-wrapped-keys-v6-11-d59e61bc0cb4@linaro.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906-wrapped-keys-v6-11-d59e61bc0cb4@linaro.org>

Hi Bartosz,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ad40aff1edffeccc412cde93894196dca7bc739e]

url:    https://github.com/intel-lab-lkp/linux/commits/Bartosz-Golaszewski/blk-crypto-add-basic-hardware-wrapped-key-support/20240907-023147
base:   ad40aff1edffeccc412cde93894196dca7bc739e
patch link:    https://lore.kernel.org/r/20240906-wrapped-keys-v6-11-d59e61bc0cb4%40linaro.org
patch subject: [PATCH v6 11/17] soc: qcom: ice: add support for generating, importing and preparing keys
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20240909/202409091043.FwxHoaRd-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240909/202409091043.FwxHoaRd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409091043.FwxHoaRd-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/soc/qcom/ice.c:470: warning: Function parameter or struct member 'ice' not described in 'qcom_ice_generate_key'
>> drivers/soc/qcom/ice.c:495: warning: Function parameter or struct member 'ice' not described in 'qcom_ice_prepare_key'
>> drivers/soc/qcom/ice.c:519: warning: Function parameter or struct member 'ice' not described in 'qcom_ice_import_key'

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OMAP2PLUS_MBOX
   Depends on [n]: MAILBOX [=y] && (ARCH_OMAP2PLUS || ARCH_K3)
   Selected by [y]:
   - TI_K3_M4_REMOTEPROC [=y] && REMOTEPROC [=y] && (ARCH_K3 || COMPILE_TEST [=y])


vim +470 drivers/soc/qcom/ice.c

   457	
   458	/**
   459	 * qcom_ice_generate_key() - Generate a wrapped key for inline encryption
   460	 * @lt_key: long-term wrapped key to be generated, which is
   461	 *          BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
   462	 *
   463	 * Make a scm call into trustzone to generate a wrapped key for storage
   464	 * encryption using hwkm.
   465	 *
   466	 * Returns: 0 on success, -errno on failure.
   467	 */
   468	int qcom_ice_generate_key(struct qcom_ice *ice,
   469				  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
 > 470	{
   471		size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
   472	
   473		if (!qcom_scm_generate_ice_key(lt_key, wk_size))
   474			return wk_size;
   475	
   476		return 0;
   477	}
   478	EXPORT_SYMBOL_GPL(qcom_ice_generate_key);
   479	
   480	/**
   481	 * qcom_ice_prepare_key() - Prepare a long-term wrapped key for inline encryption
   482	 * @lt_key: longterm wrapped key that was generated or imported.
   483	 * @lt_key_size: size of the longterm wrapped_key
   484	 * @eph_key: wrapped key returned which has been wrapped with a per-boot ephemeral key,
   485	 *           size of which is BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
   486	 *
   487	 * Make a scm call into trustzone to prepare a wrapped key for storage
   488	 * encryption by rewrapping the longterm wrapped key with a per boot ephemeral
   489	 * key using hwkm.
   490	 *
   491	 * Return: 0 on success; -errno on failure.
   492	 */
   493	int qcom_ice_prepare_key(struct qcom_ice *ice, const u8 *lt_key, size_t lt_key_size,
   494				 u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
 > 495	{
   496		size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
   497	
   498		if (!qcom_scm_prepare_ice_key(lt_key, lt_key_size, eph_key, wk_size))
   499			return wk_size;
   500	
   501		return 0;
   502	}
   503	EXPORT_SYMBOL_GPL(qcom_ice_prepare_key);
   504	
   505	/**
   506	 * qcom_ice_import_key() - Import a raw key for inline encryption
   507	 * @imp_key: raw key that has to be imported
   508	 * @imp_key_size: size of the imported key
   509	 * @lt_key: longterm wrapped key that is imported, which is
   510	 *          BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE in size.
   511	 *
   512	 * Make a scm call into trustzone to import a raw key for storage encryption
   513	 * and generate a longterm wrapped key using hwkm.
   514	 *
   515	 * Return: 0 on success; -errno on failure.
   516	 */
   517	int qcom_ice_import_key(struct qcom_ice *ice, const u8 *imp_key, size_t imp_key_size,
   518				u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
 > 519	{
   520		size_t wk_size = QCOM_ICE_HWKM_WRAPPED_KEY_SIZE(ice->hwkm_version);
   521	
   522		if (!qcom_scm_import_ice_key(imp_key, imp_key_size, lt_key, wk_size))
   523			return wk_size;
   524	
   525		return 0;
   526	}
   527	EXPORT_SYMBOL_GPL(qcom_ice_import_key);
   528	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
