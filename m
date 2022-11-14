Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4A8C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 14 Nov 2022 10:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668422744;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=wsdrEgps7yZP4xEx9K1hv8hPORea66FjrcDMugEzxdI=;
	b=NGxdzrmgK69A1DGz+RXBTrSa7XFoamQE/KsFdQQm8DaBYduDphKBORn1QbFWpjYUdM0Pg+
	jijDhxp2vKoxXYiQVvtmLnZDJsQ8pAxCBHC9uhMHBmq5cnkwZqRYg52Wt4FZD5Kib4Sdrs
	JtFxw4jzYFaqhekuqZiFyN27UT3wLvY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-nkggGMG5NF2CkTJ6janZKg-1; Mon, 14 Nov 2022 05:45:41 -0500
X-MC-Unique: nkggGMG5NF2CkTJ6janZKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 933E83C16E61;
	Mon, 14 Nov 2022 10:45:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B730C2166B2B;
	Mon, 14 Nov 2022 10:45:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 90677194658C;
	Mon, 14 Nov 2022 10:45:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 81EFF1946589
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Nov 2022 10:45:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6E3DA422A9; Mon, 14 Nov 2022 10:45:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 64E724EA4E
 for <dm-devel@redhat.com>; Mon, 14 Nov 2022 10:45:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24B503C025BF
 for <dm-devel@redhat.com>; Mon, 14 Nov 2022 10:45:36 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-SOt2o3CJPUOx2cccyEldtg-1; Mon, 14 Nov 2022 05:45:33 -0500
X-MC-Unique: SOt2o3CJPUOx2cccyEldtg-1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="313085070"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; d="scan'208";a="313085070"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
 by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 14 Nov 2022 02:45:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="813208178"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; d="scan'208";a="813208178"
Received: from lkp-server01.sh.intel.com (HELO ebd99836cbe0) ([10.239.97.150])
 by orsmga005.jf.intel.com with ESMTP; 14 Nov 2022 02:45:28 -0800
Received: from kbuild by ebd99836cbe0 with local (Exim 4.96)
 (envelope-from <lkp@intel.com>) id 1ouWxz-0000Gh-0y;
 Mon, 14 Nov 2022 10:45:27 +0000
Date: Mon, 14 Nov 2022 18:45:19 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Message-ID: <202211141806.JxbLjy2R-lkp@intel.com>
References: <20221114042944.1009870-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20221114042944.1009870-4-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 3/3] blk-crypto: move internal only
 declarations to blk-crypto-internal.h
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
Cc: linux-block@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
 llvm@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 linux-fscrypt@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
 dm-devel@redhat.com, oe-kbuild-all@lists.linux.dev,
 Jaegeuk Kim <jaegeuk@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="xqM25QzY7bQb4GsA"
Content-Disposition: inline

--xqM25QzY7bQb4GsA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Christoph,

I love your patch! Perhaps something to improve:

[auto build test WARNING on axboe-block/for-next]
[also build test WARNING on linus/master v6.1-rc5 next-20221114]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/blk-crypto-don-t-use-struct-request_queue-for-public-interfaces/20221114-133034
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20221114042944.1009870-4-hch%40lst.de
patch subject: [PATCH 3/3] blk-crypto: move internal only declarations to blk-crypto-internal.h
config: s390-randconfig-r044-20221114
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 463da45892e2d2a262277b91b96f5f8c05dc25d0)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/981a7e9db6818db7a9a2395da9a36551b025078f
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Christoph-Hellwig/blk-crypto-don-t-use-struct-request_queue-for-public-interfaces/20221114-133034
        git checkout 981a7e9db6818db7a9a2395da9a36551b025078f
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   In file included from block/blk-crypto-profile.c:34:
   In file included from include/linux/blk-integrity.h:5:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from block/blk-crypto-profile.c:34:
   In file included from include/linux/blk-integrity.h:5:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from block/blk-crypto-profile.c:34:
   In file included from include/linux/blk-integrity.h:5:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> block/blk-crypto-profile.c:241:14: warning: no previous prototype for function 'blk_crypto_get_keyslot' [-Wmissing-prototypes]
   blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
                ^
   block/blk-crypto-profile.c:241:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
   ^
   static 
>> block/blk-crypto-profile.c:318:6: warning: no previous prototype for function 'blk_crypto_put_keyslot' [-Wmissing-prototypes]
   void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot)
        ^
   block/blk-crypto-profile.c:318:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot)
   ^
   static 
>> block/blk-crypto-profile.c:344:6: warning: no previous prototype for function '__blk_crypto_cfg_supported' [-Wmissing-prototypes]
   bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
        ^
   block/blk-crypto-profile.c:344:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
   ^
   static 
>> block/blk-crypto-profile.c:373:5: warning: no previous prototype for function '__blk_crypto_evict_key' [-Wmissing-prototypes]
   int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
       ^
   block/blk-crypto-profile.c:373:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
   ^
   static 
   16 warnings generated.


vim +/blk_crypto_get_keyslot +241 block/blk-crypto-profile.c

1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  223  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  224  /**
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  225   * blk_crypto_get_keyslot() - Get a keyslot for a key, if needed.
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  226   * @profile: the crypto profile of the device the key will be used on
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  227   * @key: the key that will be used
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  228   * @slot_ptr: If a keyslot is allocated, an opaque pointer to the keyslot struct
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  229   *	      will be stored here; otherwise NULL will be stored here.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  230   *
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  231   * If the device has keyslots, this gets a keyslot that's been programmed with
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  232   * the specified key.  If the key is already in a slot, this reuses it;
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  233   * otherwise this waits for a slot to become idle and programs the key into it.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  234   *
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  235   * This must be paired with a call to blk_crypto_put_keyslot().
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  236   *
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  237   * Context: Process context. Takes and releases profile->lock.
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  238   * Return: BLK_STS_OK on success, meaning that either a keyslot was allocated or
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  239   *	   one wasn't needed; or a blk_status_t error on failure.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  240   */
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18 @241  blk_status_t blk_crypto_get_keyslot(struct blk_crypto_profile *profile,
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  242  				    const struct blk_crypto_key *key,
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  243  				    struct blk_crypto_keyslot **slot_ptr)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  244  {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  245  	struct blk_crypto_keyslot *slot;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  246  	int slot_idx;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  247  	int err;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  248  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  249  	*slot_ptr = NULL;
7bdcc48f4e80b0 block/keyslot-manager.c    Satya Tangirala 2021-02-01  250  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  251  	/*
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  252  	 * If the device has no concept of "keyslots", then there is no need to
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  253  	 * get one.
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  254  	 */
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  255  	if (profile->num_slots == 0)
7bdcc48f4e80b0 block/keyslot-manager.c    Satya Tangirala 2021-02-01  256  		return BLK_STS_OK;
7bdcc48f4e80b0 block/keyslot-manager.c    Satya Tangirala 2021-02-01  257  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  258  	down_read(&profile->lock);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  259  	slot = blk_crypto_find_and_grab_keyslot(profile, key);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  260  	up_read(&profile->lock);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  261  	if (slot)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  262  		goto success;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  263  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  264  	for (;;) {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  265  		blk_crypto_hw_enter(profile);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  266  		slot = blk_crypto_find_and_grab_keyslot(profile, key);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  267  		if (slot) {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  268  			blk_crypto_hw_exit(profile);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  269  			goto success;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  270  		}
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  271  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  272  		/*
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  273  		 * If we're here, that means there wasn't a slot that was
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  274  		 * already programmed with the key. So try to program it.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  275  		 */
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  276  		if (!list_empty(&profile->idle_slots))
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  277  			break;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  278  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  279  		blk_crypto_hw_exit(profile);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  280  		wait_event(profile->idle_slots_wait_queue,
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  281  			   !list_empty(&profile->idle_slots));
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  282  	}
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  283  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  284  	slot = list_first_entry(&profile->idle_slots, struct blk_crypto_keyslot,
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  285  				idle_slot_node);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  286  	slot_idx = blk_crypto_keyslot_index(slot);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  287  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  288  	err = profile->ll_ops.keyslot_program(profile, key, slot_idx);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  289  	if (err) {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  290  		wake_up(&profile->idle_slots_wait_queue);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  291  		blk_crypto_hw_exit(profile);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  292  		return errno_to_blk_status(err);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  293  	}
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  294  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  295  	/* Move this slot to the hash list for the new key. */
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  296  	if (slot->key)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  297  		hlist_del(&slot->hash_node);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  298  	slot->key = key;
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  299  	hlist_add_head(&slot->hash_node,
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  300  		       blk_crypto_hash_bucket_for_key(profile, key));
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  301  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  302  	atomic_set(&slot->slot_refs, 1);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  303  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  304  	blk_crypto_remove_slot_from_lru_list(slot);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  305  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  306  	blk_crypto_hw_exit(profile);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  307  success:
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  308  	*slot_ptr = slot;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  309  	return BLK_STS_OK;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  310  }
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  311  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  312  /**
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  313   * blk_crypto_put_keyslot() - Release a reference to a keyslot
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  314   * @slot: The keyslot to release the reference of (may be NULL).
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  315   *
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  316   * Context: Any context.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  317   */
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18 @318  void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  319  {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  320  	struct blk_crypto_profile *profile;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  321  	unsigned long flags;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  322  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  323  	if (!slot)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  324  		return;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  325  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  326  	profile = slot->profile;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  327  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  328  	if (atomic_dec_and_lock_irqsave(&slot->slot_refs,
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  329  					&profile->idle_slots_lock, flags)) {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  330  		list_add_tail(&slot->idle_slot_node, &profile->idle_slots);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  331  		spin_unlock_irqrestore(&profile->idle_slots_lock, flags);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  332  		wake_up(&profile->idle_slots_wait_queue);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  333  	}
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  334  }
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  335  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  336  /**
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  337   * __blk_crypto_cfg_supported() - Check whether the given crypto profile
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  338   *				  supports the given crypto configuration.
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  339   * @profile: the crypto profile to check
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  340   * @cfg: the crypto configuration to check for
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  341   *
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  342   * Return: %true if @profile supports the given @cfg.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  343   */
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18 @344  bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  345  				const struct blk_crypto_config *cfg)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  346  {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  347  	if (!profile)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  348  		return false;
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  349  	if (!(profile->modes_supported[cfg->crypto_mode] & cfg->data_unit_size))
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  350  		return false;
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  351  	if (profile->max_dun_bytes_supported < cfg->dun_bytes)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  352  		return false;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  353  	return true;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  354  }
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  355  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  356  /**
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  357   * __blk_crypto_evict_key() - Evict a key from a device.
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  358   * @profile: the crypto profile of the device
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  359   * @key: the key to evict.  It must not still be used in any I/O.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  360   *
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  361   * If the device has keyslots, this finds the keyslot (if any) that contains the
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  362   * specified key and calls the driver's keyslot_evict function to evict it.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  363   *
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  364   * Otherwise, this just calls the driver's keyslot_evict function if it is
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  365   * implemented, passing just the key (without any particular keyslot).  This
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  366   * allows layered devices to evict the key from their underlying devices.
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  367   *
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  368   * Context: Process context. Takes and releases profile->lock.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  369   * Return: 0 on success or if there's no keyslot with the specified key, -EBUSY
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  370   *	   if the keyslot is still in use, or another -errno value on other
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  371   *	   error.
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  372   */
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18 @373  int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  374  			   const struct blk_crypto_key *key)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  375  {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  376  	struct blk_crypto_keyslot *slot;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  377  	int err = 0;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  378  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  379  	if (profile->num_slots == 0) {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  380  		if (profile->ll_ops.keyslot_evict) {
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  381  			blk_crypto_hw_enter(profile);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  382  			err = profile->ll_ops.keyslot_evict(profile, key, -1);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  383  			blk_crypto_hw_exit(profile);
7bdcc48f4e80b0 block/keyslot-manager.c    Satya Tangirala 2021-02-01  384  			return err;
7bdcc48f4e80b0 block/keyslot-manager.c    Satya Tangirala 2021-02-01  385  		}
7bdcc48f4e80b0 block/keyslot-manager.c    Satya Tangirala 2021-02-01  386  		return 0;
7bdcc48f4e80b0 block/keyslot-manager.c    Satya Tangirala 2021-02-01  387  	}
7bdcc48f4e80b0 block/keyslot-manager.c    Satya Tangirala 2021-02-01  388  
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  389  	blk_crypto_hw_enter(profile);
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  390  	slot = blk_crypto_find_keyslot(profile, key);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  391  	if (!slot)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  392  		goto out_unlock;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  393  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  394  	if (WARN_ON_ONCE(atomic_read(&slot->slot_refs) != 0)) {
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  395  		err = -EBUSY;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  396  		goto out_unlock;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  397  	}
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  398  	err = profile->ll_ops.keyslot_evict(profile, key,
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  399  					    blk_crypto_keyslot_index(slot));
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  400  	if (err)
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  401  		goto out_unlock;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  402  
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  403  	hlist_del(&slot->hash_node);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  404  	slot->key = NULL;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  405  	err = 0;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  406  out_unlock:
cb77cb5abe1f4f block/blk-crypto-profile.c Eric Biggers    2021-10-18  407  	blk_crypto_hw_exit(profile);
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  408  	return err;
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  409  }
1b2628397058eb block/keyslot-manager.c    Satya Tangirala 2020-05-14  410  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp

--xqM25QzY7bQb4GsA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated file; DO NOT EDIT.
# Linux/s390 6.1.0-rc3 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="clang version 16.0.0 (git://gitmirror/llvm_project 463da45892e2d2a262277b91b96f5f8c05dc25d0)"
CONFIG_GCC_VERSION=0
CONFIG_CC_IS_CLANG=y
CONFIG_CLANG_VERSION=160000
CONFIG_AS_IS_LLVM=y
CONFIG_AS_VERSION=160000
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23800
CONFIG_LLD_VERSION=0
CONFIG_RUST_IS_AVAILABLE=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=123
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_WERROR is not set
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_HAVE_KERNEL_UNCOMPRESSED=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
# CONFIG_KERNEL_UNCOMPRESSED is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_WATCH_QUEUE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_ARCH_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_TIME_KUNIT_TEST=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_CONTEXT_TRACKING_IDLE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
# CONFIG_BPF_SYSCALL is not set
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_DEFAULT_ON=y
# end of BPF subsystem

CONFIG_PREEMPT_VOLUNTARY_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_NATIVE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
# CONFIG_TASK_XACCT is not set
CONFIG_PSI=y
# CONFIG_PSI_DEFAULT_DISABLED is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
# end of RCU Subsystem

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_IKHEADERS=y

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough"
CONFIG_GCC12_NO_ARRAY_BOUNDS=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_FAVOR_DYNMODS is not set
# CONFIG_MEMCG is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_CGROUP_MISC=y
CONFIG_CGROUP_DEBUG=y
CONFIG_SOCK_CGROUP_DATA=y
# CONFIG_NAMESPACES is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_RD_GZIP is not set
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
CONFIG_RD_ZSTD=y
CONFIG_BOOT_CONFIG=y
CONFIG_BOOT_CONFIG_EMBED=y
CONFIG_BOOT_CONFIG_EMBED_FILE=""
CONFIG_INITRAMFS_PRESERVE_MTIME=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_EXPERT=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_FHANDLE is not set
CONFIG_POSIX_TIMERS=y
# CONFIG_PRINTK is not set
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
CONFIG_BASE_FULL=y
# CONFIG_FUTEX is not set
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
# CONFIG_EVENTFD is not set
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_IO_URING=y
# CONFIG_ADVISE_SYSCALLS is not set
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
CONFIG_DEBUG_RSEQ=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
# CONFIG_PERF_EVENTS is not set
# end of Kernel Performance Events And Counters

CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_MMU=y
CONFIG_CPU_BIG_ENDIAN=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_AUDIT_ARCH=y
CONFIG_NO_IOPORT_MAP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_KASAN_SHADOW_OFFSET=0x1C000000000000
CONFIG_S390=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_HAVE_LIVEPATCH=y

#
# Processor type and features
#
CONFIG_HAVE_MARCH_Z10_FEATURES=y
CONFIG_HAVE_MARCH_Z196_FEATURES=y
# CONFIG_MARCH_Z10 is not set
CONFIG_MARCH_Z196=y
# CONFIG_MARCH_ZEC12 is not set
# CONFIG_MARCH_Z13 is not set
# CONFIG_MARCH_Z14 is not set
# CONFIG_MARCH_Z15 is not set
# CONFIG_MARCH_Z16 is not set
CONFIG_MARCH_Z15_TUNE=y
# CONFIG_TUNE_DEFAULT is not set
# CONFIG_TUNE_Z10 is not set
# CONFIG_TUNE_Z196 is not set
# CONFIG_TUNE_ZEC12 is not set
# CONFIG_TUNE_Z13 is not set
# CONFIG_TUNE_Z14 is not set
CONFIG_TUNE_Z15=y
# CONFIG_TUNE_Z16 is not set
CONFIG_64BIT=y
CONFIG_COMMAND_LINE_SIZE=4096
CONFIG_SMP=y
CONFIG_NR_CPUS=64
CONFIG_HOTPLUG_CPU=y
# CONFIG_SCHED_TOPOLOGY is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_KEXEC_FILE is not set
# CONFIG_KERNEL_NOBP is not set
# CONFIG_RELOCATABLE is not set
# end of Processor type and features

#
# Memory setup
#
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_MAX_PHYSMEM_BITS=46
# end of Memory setup

#
# I/O subsystem
#
# CONFIG_QDIO is not set
# CONFIG_CHSC_SCH is not set
# CONFIG_SCM_BUS is not set
# end of I/O subsystem

#
# Dump support
#
CONFIG_CRASH_DUMP=y
# end of Dump support

CONFIG_CCW=y

#
# Virtualization
#
CONFIG_PROTECTED_VIRTUALIZATION_GUEST=y
# CONFIG_PFAULT is not set
# CONFIG_CMM is not set
CONFIG_S390_HYPFS_FS=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_S390_GUEST is not set
# end of Virtualization

CONFIG_S390_MODULES_SANITY_TEST_HELPERS=y

#
# Selftests
#
# CONFIG_S390_UNWIND_SELFTEST is not set
CONFIG_S390_MODULES_SANITY_TEST=y
# end of Selftests

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_GENERIC_ENTRY=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_ARCH_32BIT_USTAT_F_TINODE=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_MMU_GATHER_MERGE_VMAS=y
CONFIG_MMU_GATHER_NO_GATHER=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_LTO_NONE=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_IDLE=y
CONFIG_ARCH_HAS_SCALED_CPUTIME=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ALTERNATE_USER_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_CLONE_BACKWARDS2=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
# CONFIG_RANDOMIZE_KSTACK_OFFSET is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_LOCK_EVENT_COUNTS=y
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_ARCH_HAS_VDSO_DATA=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODULE_UNLOAD_TAINT_TRACKING=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_MODULE_SIG=y
CONFIG_MODULE_SIG_FORCE=y
# CONFIG_MODULE_SIG_ALL is not set

#
# Do not forget to sign required modules with scripts/sign-file
#
# CONFIG_MODULE_SIG_SHA1 is not set
CONFIG_MODULE_SIG_SHA224=y
# CONFIG_MODULE_SIG_SHA256 is not set
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha224"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS=y
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=y
CONFIG_BLK_DEV_ZONED=y
# CONFIG_BLK_WBT is not set
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
CONFIG_BLK_SED_OPAL=y
CONFIG_BLK_INLINE_ENCRYPTION=y
CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_IBM_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_CMDLINE_PARTITION=y
# end of Partition Types

CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=m
CONFIG_IOSCHED_BFQ=y
# end of IO Schedulers

CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_ARCH_INLINE_SPIN_TRYLOCK=y
CONFIG_ARCH_INLINE_SPIN_TRYLOCK_BH=y
CONFIG_ARCH_INLINE_SPIN_LOCK=y
CONFIG_ARCH_INLINE_SPIN_LOCK_BH=y
CONFIG_ARCH_INLINE_SPIN_LOCK_IRQ=y
CONFIG_ARCH_INLINE_SPIN_LOCK_IRQSAVE=y
CONFIG_ARCH_INLINE_SPIN_UNLOCK=y
CONFIG_ARCH_INLINE_SPIN_UNLOCK_BH=y
CONFIG_ARCH_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE=y
CONFIG_ARCH_INLINE_READ_TRYLOCK=y
CONFIG_ARCH_INLINE_READ_LOCK=y
CONFIG_ARCH_INLINE_READ_LOCK_BH=y
CONFIG_ARCH_INLINE_READ_LOCK_IRQ=y
CONFIG_ARCH_INLINE_READ_LOCK_IRQSAVE=y
CONFIG_ARCH_INLINE_READ_UNLOCK=y
CONFIG_ARCH_INLINE_READ_UNLOCK_BH=y
CONFIG_ARCH_INLINE_READ_UNLOCK_IRQ=y
CONFIG_ARCH_INLINE_READ_UNLOCK_IRQRESTORE=y
CONFIG_ARCH_INLINE_WRITE_TRYLOCK=y
CONFIG_ARCH_INLINE_WRITE_LOCK=y
CONFIG_ARCH_INLINE_WRITE_LOCK_BH=y
CONFIG_ARCH_INLINE_WRITE_LOCK_IRQ=y
CONFIG_ARCH_INLINE_WRITE_LOCK_IRQSAVE=y
CONFIG_ARCH_INLINE_WRITE_UNLOCK=y
CONFIG_ARCH_INLINE_WRITE_UNLOCK_BH=y
CONFIG_ARCH_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_ELF_KUNIT_TEST=y
CONFIG_ARCH_BINFMT_ELF_STATE=y
CONFIG_ELFCORE=y
# CONFIG_BINFMT_SCRIPT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_ZPOOL=y
CONFIG_SWAP=y
CONFIG_ZSWAP=y
CONFIG_ZSWAP_DEFAULT_ON=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD=y
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="zstd"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
CONFIG_ZBUD=y
CONFIG_Z3FOLD=m
CONFIG_ZSMALLOC=m
CONFIG_ZSMALLOC_STAT=y

#
# SLAB allocator options
#
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_SLAB_MERGE_DEFAULT is not set
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
# end of SLAB allocator options

# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK_PHYS_MAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTPLUG=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_COMPACT_UNEVICTABLE_DEFAULT=1
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
CONFIG_CMA_DEBUGFS=y
CONFIG_CMA_SYSFS=y
CONFIG_CMA_AREAS=7
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ZONE_DMA=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PERCPU_STATS=y
# CONFIG_GUP_TEST is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_USERFAULTFD=y
# CONFIG_LRU_GEN is not set

#
# Data Access Monitoring
#
# CONFIG_DAMON is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=y
CONFIG_IUCV=y
# CONFIG_AFIUCV is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_ATM=m
CONFIG_ATM_LANE=m
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=m
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_BATMAN_V=y
# CONFIG_BATMAN_ADV_NC is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_BATMAN_ADV_TRACING=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
# CONFIG_NET_MPLS_GSO is not set
# CONFIG_NET_NSH is not set
# CONFIG_HSR is not set
# CONFIG_QRTR is not set
# CONFIG_PCPU_DEV_REFCNT is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# end of Network testing
# end of Networking options

CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=y
CONFIG_CAN_J1939=m
CONFIG_CAN_ISOTP=m
# CONFIG_MCTP is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=m
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=m
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN544=m
CONFIG_NFC_PN544_I2C=m
CONFIG_NFC_PN533=m
# CONFIG_NFC_PN533_I2C is not set
CONFIG_NFC_PN532_UART=m
CONFIG_NFC_MICROREAD=m
CONFIG_NFC_MICROREAD_I2C=m
CONFIG_NFC_ST21NFCA=m
CONFIG_NFC_ST21NFCA_I2C=m
# end of Near Field Communication (NFC) devices

CONFIG_PSAMPLE=m
CONFIG_NET_IFE=y
# CONFIG_LWTUNNEL is not set
CONFIG_FAILOVER=m
# CONFIG_ETHTOOL_NETLINK is not set
CONFIG_NETDEV_ADDR_LIST_TEST=y

#
# Device Drivers
#
CONFIG_HAVE_PCI=y
# CONFIG_PCI is not set
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y

#
# PC-card bridges
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_FW_LOADER_SYSFS=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_UPLOAD=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
CONFIG_PM_QOS_KUNIT_TEST=y
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_DRIVER_PE_KUNIT_TEST=y
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPMI=m
CONFIG_REGMAP_MMIO=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
CONFIG_MHI_BUS=m
# CONFIG_MHI_BUS_DEBUG is not set
CONFIG_MHI_BUS_EP=y
# end of Bus devices

CONFIG_CONNECTOR=m

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_FIRMWARE_MEMMAP=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_GNSS=y
CONFIG_GNSS_SERIAL=m
CONFIG_GNSS_MTK_SERIAL=m
# CONFIG_GNSS_SIRF_SERIAL is not set
CONFIG_GNSS_UBX_SERIAL=m
CONFIG_MTD=y
CONFIG_MTD_TESTS=m

#
# Partition parsers
#
CONFIG_MTD_AR7_PARTS=y
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_OF_PARTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
CONFIG_MTD_REDBOOT_PARTS_READONLY=y
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y

#
# Note that in some cases UBI block is preferred. See MTD_UBI_BLOCK.
#
CONFIG_FTL=m
CONFIG_NFTL=y
# CONFIG_NFTL_RW is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
CONFIG_MTD_SWAP=m
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
# CONFIG_MTD_CFI_I1 is not set
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
CONFIG_MTD_CFI_I8=y
# CONFIG_MTD_OTP is not set
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m
# end of RAM/ROM/Flash chip drivers

#
# NAND
#
CONFIG_MTD_NAND_CORE=y
# CONFIG_MTD_RAW_NAND is not set

#
# ECC engine support
#
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SW_HAMMING=y
CONFIG_MTD_NAND_ECC_SW_HAMMING_SMC=y
# CONFIG_MTD_NAND_ECC_SW_BCH is not set
# end of ECC engine support
# end of NAND

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_UBI is not set
CONFIG_DTC=y
CONFIG_OF=y
CONFIG_OF_UNITTEST=y
CONFIG_OF_FLATTREE=y
CONFIG_OF_EARLY_FLATTREE=y
CONFIG_OF_KOBJ=y
CONFIG_OF_DYNAMIC=y
CONFIG_OF_IRQ=y
CONFIG_OF_RESERVED_MEM=y
CONFIG_OF_RESOLVE=y
# CONFIG_OF_OVERLAY is not set
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_CDROM=m
CONFIG_ZRAM=m
# CONFIG_ZRAM_DEF_COMP_LZORLE is not set
# CONFIG_ZRAM_DEF_COMP_ZSTD is not set
# CONFIG_ZRAM_DEF_COMP_LZ4 is not set
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP_LZ4HC=y
# CONFIG_ZRAM_DEF_COMP_842 is not set
CONFIG_ZRAM_DEF_COMP="lz4hc"
# CONFIG_ZRAM_WRITEBACK is not set
CONFIG_ZRAM_MEMORY_TRACKING=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8

#
# DRBD disabled because PROC_FS or INET not selected
#
# CONFIG_BLK_DEV_NBD is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set

#
# S/390 block device drivers
#
# CONFIG_DCSSBLK is not set
# CONFIG_DASD is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_UBLK is not set

#
# NVME Support
#
CONFIG_NVME_COMMON=y
CONFIG_NVME_CORE=y
# CONFIG_NVME_MULTIPATH is not set
# CONFIG_NVME_VERBOSE_ERRORS is not set
CONFIG_NVME_FABRICS=y
# CONFIG_NVME_FC is not set
CONFIG_NVME_AUTH=y
CONFIG_NVME_TARGET=y
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=y
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_AUTH=y
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_OPEN_DICE is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=y
# CONFIG_EEPROM_IDT_89HPESX is not set
CONFIG_EEPROM_EE1004=m
# end of EEPROM support

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=y
# CONFIG_ECHO is not set
CONFIG_UACCE=m
CONFIG_PVPANIC=y
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
# CONFIG_MD_LINEAR is not set
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
# CONFIG_BCACHE_ASYNC_REGISTRATION is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=m
CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING=y
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
CONFIG_DM_UNSTRIPED=m
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
# CONFIG_DM_WRITECACHE is not set
# CONFIG_DM_EBS is not set
# CONFIG_DM_ERA is not set
CONFIG_DM_CLONE=m
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_MULTIPATH_HST=m
# CONFIG_DM_MULTIPATH_IOA is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_DUST=m
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
# CONFIG_DM_LOG_WRITES is not set
CONFIG_DM_INTEGRITY=m
CONFIG_DM_ZONED=m
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=y
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=m
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=y
CONFIG_INPUT_VIVALDIFMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADC=m
CONFIG_KEYBOARD_ADP5588=m
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=m
# CONFIG_KEYBOARD_QT1050 is not set
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=m
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=m
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
CONFIG_KEYBOARD_LM8333=m
CONFIG_KEYBOARD_MAX7359=m
CONFIG_KEYBOARD_MCS=m
CONFIG_KEYBOARD_MPR121=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_PINEPHONE=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=m
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_KEYBOARD_CAP11XX=m
CONFIG_KEYBOARD_CYPRESS_SF=m
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_SERIAL_WACOM4=m
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_ATMEL_CAPTOUCH=y
CONFIG_INPUT_BMA150=m
CONFIG_INPUT_E3X0_BUTTON=m
CONFIG_INPUT_MMA8450=y
# CONFIG_INPUT_GPIO_BEEPER is not set
CONFIG_INPUT_GPIO_DECODER=m
CONFIG_INPUT_GPIO_VIBRA=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_REGULATOR_HAPTIC=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_PWM_VIBRA=m
# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
CONFIG_INPUT_DA7280_HAPTICS=y
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
CONFIG_INPUT_IBM_PANEL=y
CONFIG_INPUT_IQS269A=m
CONFIG_INPUT_IQS626A=m
# CONFIG_INPUT_IQS7222 is not set
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
CONFIG_INPUT_DRV260X_HAPTICS=y
CONFIG_INPUT_DRV2665_HAPTICS=y
CONFIG_INPUT_DRV2667_HAPTICS=m
CONFIG_RMI4_CORE=y
CONFIG_RMI4_I2C=m
# CONFIG_RMI4_SMB is not set
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
# CONFIG_RMI4_F11 is not set
# CONFIG_RMI4_F12 is not set
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_LIBPS2=m
CONFIG_SERIO_RAW=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
# CONFIG_CONSOLE_TRANSLATIONS is not set
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_LDISC_AUTOLOAD is not set
# CONFIG_N_GSM is not set
CONFIG_NULL_TTY=y
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IUCV=y
# CONFIG_RPMSG_TTY is not set
CONFIG_SERIAL_DEV_BUS=m
CONFIG_TTY_PRINTK=m
CONFIG_TTY_PRINTK_LEVEL=6
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMB_DEVICE_INTERFACE is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_S390 is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
CONFIG_SCR24X=m
# end of PCMCIA character devices

# CONFIG_DEVMEM is not set
CONFIG_HANGCHECK_TIMER=m

#
# S/390 character device drivers
#
CONFIG_TN3270=y
CONFIG_TN3270_TTY=y
CONFIG_TN3270_FS=y
# CONFIG_TN3270_CONSOLE is not set
# CONFIG_TN3215 is not set
CONFIG_SCLP_TTY=y
# CONFIG_SCLP_CONSOLE is not set
# CONFIG_SCLP_VT220_TTY is not set
CONFIG_HMC_DRV=y
# CONFIG_SCLP_OFB is not set
# CONFIG_S390_UV_UAPI is not set
CONFIG_S390_TAPE=m

#
# S/390 tape hardware support
#
CONFIG_S390_TAPE_34XX=m
# CONFIG_S390_TAPE_3590 is not set
# CONFIG_VMLOGRDR is not set
# CONFIG_VMCP is not set
CONFIG_MONREADER=y
CONFIG_MONWRITER=m
# CONFIG_S390_VMUR is not set
CONFIG_XILLYBUS_CLASS=m
CONFIG_XILLYBUS=m
CONFIG_XILLYBUS_OF=m
CONFIG_RANDOM_TRUST_CPU=y
CONFIG_RANDOM_TRUST_BOOTLOADER=y
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_ARB_GPIO_CHALLENGE=y
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_GPMUX is not set
CONFIG_I2C_MUX_LTC4306=m
# CONFIG_I2C_MUX_PCA9541 is not set
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_MUX_PINCTRL=y
CONFIG_I2C_DEMUX_PINCTRL=m
CONFIG_I2C_MUX_MLXCPLD=y
# end of Multiplexer I2C Chip support

# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=m
# end of I2C Algorithms

CONFIG_I2C_STUB=m
CONFIG_I2C_SLAVE=y
# CONFIG_I2C_SLAVE_EEPROM is not set
CONFIG_I2C_SLAVE_TESTUNIT=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# end of I2C support

CONFIG_I3C=y
CONFIG_SPMI=y
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI controllers
#

#
# HSI clients
#
# CONFIG_HSI_CHAR is not set
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m
CONFIG_PTP_1588_CLOCK_OPTIONAL=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_IDT82P33=m
CONFIG_PTP_1588_CLOCK_IDTCM=m
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
CONFIG_DEBUG_PINCTRL=y
CONFIG_PINCTRL_CY8C95X0=m
CONFIG_PINCTRL_MCP23S08_I2C=m
CONFIG_PINCTRL_MCP23S08=m
# CONFIG_PINCTRL_SX150X is not set

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y

#
# I2C GPIO expanders
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
CONFIG_GPIO_PCA953X=y
CONFIG_GPIO_PCA953X_IRQ=y
CONFIG_GPIO_PCA9570=y
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_TPIC2810=m
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# Virtual GPIO drivers
#
CONFIG_GPIO_AGGREGATOR=m
# CONFIG_GPIO_MOCKUP is not set
# CONFIG_GPIO_VIRTIO is not set
CONFIG_GPIO_SIM=y
# end of Virtual GPIO drivers

# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_IP5XXX_POWER is not set
CONFIG_TEST_POWER=m
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_CHARGER_SBS=y
CONFIG_MANAGER_SBS=m
# CONFIG_BATTERY_BQ27XXX is not set
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=m
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_LT3651=y
CONFIG_CHARGER_LTC4162L=m
# CONFIG_CHARGER_DETECTOR_MAX14656 is not set
CONFIG_CHARGER_MAX77976=y
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24257=y
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
CONFIG_CHARGER_BQ25890=y
CONFIG_CHARGER_BQ25980=m
CONFIG_CHARGER_BQ256XX=m
CONFIG_CHARGER_SMB347=m
CONFIG_BATTERY_GAUGE_LTC2941=y
# CONFIG_BATTERY_RT5033 is not set
CONFIG_CHARGER_RT9455=y
# CONFIG_CHARGER_UCS1002 is not set
# CONFIG_CHARGER_BD99954 is not set
CONFIG_BATTERY_UG3105=y
# CONFIG_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y
# CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED is not set
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
# CONFIG_WATCHDOG_SYSFS is not set
CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT=y

#
# Watchdog Pretimeout Governors
#
CONFIG_WATCHDOG_PRETIMEOUT_GOV=y
CONFIG_WATCHDOG_PRETIMEOUT_GOV_SEL=m
# CONFIG_WATCHDOG_PRETIMEOUT_GOV_NOOP is not set
CONFIG_WATCHDOG_PRETIMEOUT_GOV_PANIC=m
CONFIG_WATCHDOG_PRETIMEOUT_DEFAULT_GOV_PANIC=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_SOFT_WATCHDOG_PRETIMEOUT=y
CONFIG_ZIIRAVE_WATCHDOG=y
CONFIG_MEN_A21_WDT=y
CONFIG_DIAG288_WATCHDOG=m
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PG86X=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_DA9121=m
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_FAN53880=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=m
# CONFIG_REGULATOR_ISL6271A is not set
CONFIG_REGULATOR_LP3971=m
# CONFIG_REGULATOR_LP3972 is not set
CONFIG_REGULATOR_LP872X=m
CONFIG_REGULATOR_LP8755=m
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_LTC3676=y
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8893=m
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX20086=y
# CONFIG_REGULATOR_MAX77826 is not set
CONFIG_REGULATOR_MCP16502=y
CONFIG_REGULATOR_MP5416=m
# CONFIG_REGULATOR_MP8859 is not set
CONFIG_REGULATOR_MP886X=y
CONFIG_REGULATOR_MPQ7920=m
CONFIG_REGULATOR_MT6311=y
CONFIG_REGULATOR_MT6315=m
CONFIG_REGULATOR_PCA9450=m
CONFIG_REGULATOR_PF8X00=m
CONFIG_REGULATOR_PFUZE100=m
# CONFIG_REGULATOR_PV88060 is not set
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=y
CONFIG_REGULATOR_PWM=y
CONFIG_REGULATOR_QCOM_SPMI=y
CONFIG_REGULATOR_QCOM_USB_VBUS=y
# CONFIG_REGULATOR_RT4801 is not set
CONFIG_REGULATOR_RT5190A=m
# CONFIG_REGULATOR_RT5759 is not set
CONFIG_REGULATOR_RT6160=m
CONFIG_REGULATOR_RT6245=y
CONFIG_REGULATOR_RTQ2134=m
CONFIG_REGULATOR_RTMV20=m
CONFIG_REGULATOR_RTQ6752=m
CONFIG_REGULATOR_SLG51000=m
CONFIG_REGULATOR_SY8106A=m
CONFIG_REGULATOR_SY8824X=y
# CONFIG_REGULATOR_SY8827N is not set
CONFIG_REGULATOR_TPS51632=m
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS6286X is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=m
# CONFIG_REGULATOR_TPS65132 is not set
# CONFIG_REGULATOR_VCTRL is not set
# CONFIG_REGULATOR_QCOM_LABIBB is not set
CONFIG_RC_CORE=m
# CONFIG_LIRC is not set
CONFIG_RC_MAP=m
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
CONFIG_IR_GPIO_CIR=m
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
CONFIG_RC_LOOPBACK=m

#
# CEC support
#
CONFIG_MEDIA_CEC_SUPPORT=y
# CONFIG_CEC_CH7322 is not set
# end of CEC support

#
# Graphics support
#

#
# Console display driver support
#
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
# end of Console display driver support
# end of Graphics support

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_COUGAR=y
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=y
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
# CONFIG_HID_EZKEY is not set
CONFIG_HID_GEMBIRD=m
# CONFIG_HID_GFRM is not set
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_VIVALDI is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_VRC2 is not set
CONFIG_HID_XIAOMI=y
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_ICADE is not set
# CONFIG_HID_ITE is not set
CONFIG_HID_JABRA=y
CONFIG_HID_TWINHAN=m
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LED is not set
# CONFIG_HID_LENOVO is not set
CONFIG_HID_MAGICMOUSE=y
CONFIG_HID_MALTRON=m
CONFIG_HID_MAYFLASH=m
CONFIG_HID_REDRAGON=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NINTENDO=m
# CONFIG_NINTENDO_FF is not set
# CONFIG_HID_NTI is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
# CONFIG_HID_PICOLCD_LEDS is not set
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
CONFIG_HID_PLAYSTATION=m
CONFIG_PLAYSTATION_FF=y
CONFIG_HID_PXRC=m
CONFIG_HID_RAZER=m
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SEMITEK=y
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEAM=y
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=m
# CONFIG_HID_RMI is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=m
CONFIG_HID_TOPRE=m
# CONFIG_HID_THINGM is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_HID_ALPS=y
# end of Special HID drivers

#
# I2C HID support
#
CONFIG_I2C_HID_OF=m
CONFIG_I2C_HID_OF_ELAN=m
CONFIG_I2C_HID_OF_GOODIX=m
# end of I2C HID support

CONFIG_I2C_HID_CORE=m
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_SCSI_UFSHCD is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m
CONFIG_LEDS_CLASS_FLASH=m
CONFIG_LEDS_CLASS_MULTICOLOR=m
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
CONFIG_LEDS_AN30259A=m
CONFIG_LEDS_AW2013=m
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
CONFIG_LEDS_LM3692X=m
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP3952=m
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
# CONFIG_LEDS_LP8860 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_TLC591XX=m
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_IS31FL319X=m
CONFIG_LEDS_IS31FL32XX=m

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_MLXREG is not set
CONFIG_LEDS_USER=m
CONFIG_LEDS_TI_LMU_COMMON=m
# CONFIG_LEDS_LM3697 is not set

#
# Flash and Torch LED drivers
#
CONFIG_LEDS_AAT1290=m
CONFIG_LEDS_AS3645A=m
CONFIG_LEDS_KTD2692=m
# CONFIG_LEDS_LM3601X is not set
# CONFIG_LEDS_RT4505 is not set
CONFIG_LEDS_RT8515=m
# CONFIG_LEDS_SGM3140 is not set

#
# RGB LED drivers
#
CONFIG_LEDS_PWM_MULTICOLOR=m
CONFIG_LEDS_QCOM_LPG=m

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_DMADEVICES is not set

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_DMABUF_MOVE_NOTIFY=y
# CONFIG_DMABUF_DEBUG is not set
CONFIG_DMABUF_SELFTESTS=m
# CONFIG_DMABUF_HEAPS is not set
# CONFIG_DMABUF_SYSFS_STATS is not set
# end of DMABUF options

CONFIG_AUXDISPLAY=y
CONFIG_CHARLCD=y
# CONFIG_HD44780 is not set
CONFIG_LCD2S=y
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_CHARLCD_BL_OFF is not set
# CONFIG_CHARLCD_BL_ON is not set
CONFIG_CHARLCD_BL_FLASH=y
CONFIG_UIO=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
CONFIG_VFIO=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_MDEV=m
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO_ANCHOR=y
CONFIG_VIRTIO=y
# CONFIG_VIRTIO_MENU is not set
CONFIG_VDPA=y
CONFIG_VDPA_SIM=m
CONFIG_VDPA_SIM_NET=m
# CONFIG_VDPA_SIM_BLOCK is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST_RING=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y

#
# Microsoft Hyper-V guest support
#
# end of Microsoft Hyper-V guest support

CONFIG_GREYBUS=m
# CONFIG_COMEDI is not set
# CONFIG_STAGING is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_COMMON_CLK_MAX9485 is not set
CONFIG_COMMON_CLK_SI5341=y
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_SI514=m
# CONFIG_COMMON_CLK_SI544 is not set
CONFIG_COMMON_CLK_SI570=m
# CONFIG_COMMON_CLK_CDCE706 is not set
CONFIG_COMMON_CLK_CDCE925=m
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_COMMON_CLK_RS9_PCIE is not set
CONFIG_COMMON_CLK_VC5=m
# CONFIG_COMMON_CLK_VC7 is not set
# CONFIG_COMMON_CLK_FIXED_MMIO is not set
CONFIG_CLK_KUNIT_TEST=y
CONFIG_CLK_GATE_KUNIT_TEST=y
# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_TIMER_OF=y
CONFIG_TIMER_PROBE=y
CONFIG_MICROCHIP_PIT64B=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_IOMMU_IOVA=m
CONFIG_IOMMU_API=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y
CONFIG_REMOTEPROC_CDEV=y
# end of Remoteproc drivers

#
# Rpmsg drivers
#
CONFIG_RPMSG=m
# CONFIG_RPMSG_CHAR is not set
CONFIG_RPMSG_CTRL=m
CONFIG_RPMSG_NS=m
CONFIG_RPMSG_VIRTIO=m
# end of Rpmsg drivers

CONFIG_SOUNDWIRE=m

#
# SoundWire Devices
#

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# fujitsu SoC drivers
#
# end of fujitsu SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

CONFIG_SOC_TI=y

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=m
CONFIG_IIO_BUFFER_DMA=m
# CONFIG_IIO_BUFFER_DMAENGINE is not set
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_CONFIGFS=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
CONFIG_IIO_SW_DEVICE=m
CONFIG_IIO_SW_TRIGGER=m
# CONFIG_IIO_TRIGGERED_EVENT is not set

#
# Accelerometers
#
# CONFIG_ADXL313_I2C is not set
CONFIG_ADXL355=m
CONFIG_ADXL355_I2C=m
# CONFIG_ADXL367_I2C is not set
CONFIG_ADXL372=m
CONFIG_ADXL372_I2C=m
# CONFIG_BMA400 is not set
CONFIG_BMC150_ACCEL=m
CONFIG_BMC150_ACCEL_I2C=m
# CONFIG_DA280 is not set
CONFIG_DA311=m
CONFIG_DMARD06=m
CONFIG_DMARD09=m
CONFIG_DMARD10=m
CONFIG_FXLS8962AF=m
CONFIG_FXLS8962AF_I2C=m
CONFIG_IIO_ST_ACCEL_3AXIS=m
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=m
# CONFIG_KXSD9 is not set
CONFIG_KXCJK1013=m
# CONFIG_MC3230 is not set
CONFIG_MMA7455=m
CONFIG_MMA7455_I2C=m
# CONFIG_MMA7660 is not set
CONFIG_MMA8452=m
CONFIG_MMA9551_CORE=m
CONFIG_MMA9551=m
CONFIG_MMA9553=m
CONFIG_MSA311=m
CONFIG_MXC4005=m
# CONFIG_MXC6255 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7091R5 is not set
CONFIG_AD7291=m
CONFIG_AD799X=m
CONFIG_ENVELOPE_DETECTOR=m
CONFIG_HX711=m
# CONFIG_INA2XX_ADC is not set
CONFIG_LTC2471=m
CONFIG_LTC2485=m
CONFIG_LTC2497=m
CONFIG_MAX1363=m
CONFIG_MAX9611=m
CONFIG_MCP3422=m
CONFIG_NAU7802=m
CONFIG_QCOM_VADC_COMMON=m
CONFIG_QCOM_SPMI_IADC=m
CONFIG_QCOM_SPMI_VADC=m
CONFIG_QCOM_SPMI_ADC5=m
# CONFIG_RICHTEK_RTQ6056 is not set
CONFIG_SD_ADC_MODULATOR=m
CONFIG_TI_ADC081C=m
CONFIG_TI_ADS1015=m
# end of Analog to digital converters

#
# Analog to digital and digital to analog converters
#
# end of Analog to digital and digital to analog converters

#
# Analog Front Ends
#
CONFIG_IIO_RESCALE=m
# end of Analog Front Ends

#
# Amplifiers
#
CONFIG_HMC425=m
# end of Amplifiers

#
# Capacitance to digital converters
#
CONFIG_AD7150=m
CONFIG_AD7746=m
# end of Capacitance to digital converters

#
# Chemical Sensors
#
CONFIG_ATLAS_PH_SENSOR=m
# CONFIG_ATLAS_EZO_SENSOR is not set
CONFIG_BME680=m
CONFIG_BME680_I2C=m
# CONFIG_CCS811 is not set
# CONFIG_IAQCORE is not set
# CONFIG_PMS7003 is not set
CONFIG_SCD30_CORE=m
CONFIG_SCD30_I2C=m
CONFIG_SCD30_SERIAL=m
CONFIG_SCD4X=m
CONFIG_SENSIRION_SGP30=m
CONFIG_SENSIRION_SGP40=m
# CONFIG_SPS30_I2C is not set
# CONFIG_SPS30_SERIAL is not set
CONFIG_SENSEAIR_SUNRISE_CO2=m
CONFIG_VZ89X=m
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
# end of Hid Sensor IIO Common

CONFIG_IIO_MS_SENSORS_I2C=m

#
# IIO SCMI Sensors
#
# end of IIO SCMI Sensors

#
# SSP Sensor Common
#
# end of SSP Sensor Common

CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5380=m
CONFIG_AD5446=m
CONFIG_AD5592R_BASE=m
CONFIG_AD5593R=m
CONFIG_AD5686=m
CONFIG_AD5696_I2C=m
# CONFIG_DPOT_DAC is not set
# CONFIG_DS4424 is not set
CONFIG_M62332=m
CONFIG_MAX517=m
CONFIG_MAX5821=m
CONFIG_MCP4725=m
CONFIG_TI_DAC5571=m
# end of Digital to analog converters

#
# IIO dummy driver
#
# CONFIG_IIO_SIMPLE_DUMMY is not set
# end of IIO dummy driver

#
# Filters
#
# end of Filters

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
CONFIG_BMG160=m
CONFIG_BMG160_I2C=m
# CONFIG_FXAS21002C is not set
# CONFIG_MPU3050_I2C is not set
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
CONFIG_AFE4404=m
CONFIG_MAX30100=m
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
CONFIG_DHT11=m
CONFIG_HDC100X=m
CONFIG_HDC2010=m
CONFIG_HTS221=m
CONFIG_HTS221_I2C=m
CONFIG_HTU21=m
# CONFIG_SI7005 is not set
CONFIG_SI7020=m
# end of Humidity sensors

#
# Inertial measurement units
#
CONFIG_BMI160=m
CONFIG_BMI160_I2C=m
CONFIG_BOSCH_BNO055=m
CONFIG_BOSCH_BNO055_SERIAL=m
CONFIG_BOSCH_BNO055_I2C=m
# CONFIG_FXOS8700_I2C is not set
CONFIG_KMX61=m
CONFIG_INV_ICM42600=m
CONFIG_INV_ICM42600_I2C=m
CONFIG_INV_MPU6050_IIO=m
CONFIG_INV_MPU6050_I2C=m
# CONFIG_IIO_ST_LSM6DSX is not set
# CONFIG_IIO_ST_LSM9DS0 is not set
# end of Inertial measurement units

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_ADUX1020 is not set
CONFIG_AL3010=m
# CONFIG_AL3320A is not set
CONFIG_APDS9300=m
# CONFIG_APDS9960 is not set
CONFIG_AS73211=m
CONFIG_BH1750=m
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
CONFIG_CM3232=m
CONFIG_CM3323=m
CONFIG_CM3605=m
CONFIG_CM36651=m
# CONFIG_GP2AP002 is not set
CONFIG_GP2AP020A00F=m
CONFIG_SENSORS_ISL29018=m
CONFIG_SENSORS_ISL29028=m
# CONFIG_ISL29125 is not set
# CONFIG_JSA1212 is not set
CONFIG_RPR0521=m
CONFIG_LTR501=m
CONFIG_LTRF216A=m
CONFIG_LV0104CS=m
# CONFIG_MAX44000 is not set
CONFIG_MAX44009=m
CONFIG_NOA1305=m
# CONFIG_OPT3001 is not set
CONFIG_PA12203001=m
# CONFIG_SI1133 is not set
CONFIG_SI1145=m
CONFIG_STK3310=m
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
CONFIG_TCS3472=m
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL2583=m
# CONFIG_TSL2591 is not set
CONFIG_TSL2772=m
CONFIG_TSL4531=m
CONFIG_US5182D=m
CONFIG_VCNL4000=m
CONFIG_VCNL4035=m
# CONFIG_VEML6030 is not set
CONFIG_VEML6070=m
CONFIG_VL6180=m
CONFIG_ZOPT2201=m
# end of Light sensors

#
# Magnetometer sensors
#
CONFIG_AK8974=m
CONFIG_AK8975=m
CONFIG_AK09911=m
CONFIG_BMC150_MAGN=m
CONFIG_BMC150_MAGN_I2C=m
# CONFIG_MAG3110 is not set
CONFIG_MMC35240=m
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
CONFIG_SENSORS_RM3100=m
CONFIG_SENSORS_RM3100_I2C=m
CONFIG_YAMAHA_YAS530=m
# end of Magnetometer sensors

#
# Multiplexers
#
# CONFIG_IIO_MUX is not set
# end of Multiplexers

#
# Inclinometer sensors
#
# end of Inclinometer sensors

CONFIG_IIO_RESCALE_KUNIT_TEST=m
CONFIG_IIO_FORMAT_KUNIT_TEST=m

#
# Triggers - standalone
#
CONFIG_IIO_HRTIMER_TRIGGER=m
CONFIG_IIO_INTERRUPT_TRIGGER=m
# CONFIG_IIO_TIGHTLOOP_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Linear and angular position sensors
#
# end of Linear and angular position sensors

#
# Digital potentiometers
#
CONFIG_AD5110=m
CONFIG_AD5272=m
# CONFIG_DS1803 is not set
CONFIG_MAX5432=m
CONFIG_MCP4018=m
CONFIG_MCP4531=m
CONFIG_TPL0102=m
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
CONFIG_ABP060MG=m
CONFIG_BMP280=m
CONFIG_BMP280_I2C=m
# CONFIG_DLHL60D is not set
# CONFIG_DPS310 is not set
# CONFIG_HP03 is not set
CONFIG_ICP10100=m
CONFIG_MPL115=m
CONFIG_MPL115_I2C=m
# CONFIG_MPL3115 is not set
# CONFIG_MS5611 is not set
CONFIG_MS5637=m
CONFIG_IIO_ST_PRESS=m
# CONFIG_IIO_ST_PRESS_I2C is not set
CONFIG_T5403=m
CONFIG_HP206C=m
CONFIG_ZPA2326=m
CONFIG_ZPA2326_I2C=m
# end of Pressure sensors

#
# Lightning sensors
#
# end of Lightning sensors

#
# Proximity and distance sensors
#
CONFIG_ISL29501=m
# CONFIG_LIDAR_LITE_V2 is not set
CONFIG_MB1232=m
CONFIG_PING=m
CONFIG_RFD77402=m
# CONFIG_SRF04 is not set
CONFIG_SX_COMMON=m
CONFIG_SX9310=m
# CONFIG_SX9324 is not set
CONFIG_SX9360=m
CONFIG_SX9500=m
CONFIG_SRF08=m
# CONFIG_VCNL3020 is not set
CONFIG_VL53L0X_I2C=m
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_MLX90614 is not set
CONFIG_MLX90632=m
CONFIG_TMP006=m
CONFIG_TMP007=m
CONFIG_TMP117=m
# CONFIG_TSYS01 is not set
CONFIG_TSYS02D=m
# end of Temperature sensors

CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
CONFIG_PWM_ATMEL_TCB=y
CONFIG_PWM_CLK=y
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
CONFIG_IRQCHIP=y
CONFIG_AL_FIC=y
# end of IRQ chip support

CONFIG_RESET_CONTROLLER=y
CONFIG_RESET_TI_TPS380X=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_CAN_TRANSCEIVER=m

#
# PHY drivers for Broadcom platforms
#
# end of PHY drivers for Broadcom platforms
# end of PHY Subsystem

CONFIG_POWERCAP=y
# CONFIG_DTPM is not set
CONFIG_RAS=y

#
# Android
#
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_DAX=m
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
# CONFIG_NVMEM_SYSFS is not set
CONFIG_NVMEM_SPMI_SDAM=m
CONFIG_NVMEM_U_BOOT_ENV=y

#
# HW tracing support
#
CONFIG_STM=m
CONFIG_STM_PROTO_BASIC=m
CONFIG_STM_PROTO_SYS_T=m
CONFIG_STM_DUMMY=m
# CONFIG_STM_SOURCE_CONSOLE is not set
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
# end of HW tracing support

CONFIG_FPGA=y
CONFIG_ALTERA_PR_IP_CORE=y
# CONFIG_FPGA_BRIDGE is not set
CONFIG_FSI=y
# CONFIG_FSI_NEW_DEV_NODE is not set
CONFIG_FSI_MASTER_GPIO=m
CONFIG_FSI_MASTER_HUB=m
CONFIG_FSI_SCOM=y
CONFIG_MULTIPLEXER=m

#
# Multiplexer drivers
#
CONFIG_MUX_ADG792A=m
# CONFIG_MUX_GPIO is not set
CONFIG_MUX_MMIO=m
# end of Multiplexer drivers

# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
CONFIG_INTERCONNECT=y
CONFIG_COUNTER=y
# CONFIG_INTERRUPT_CNT is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# CONFIG_HTE is not set
# end of Device Drivers

#
# File systems
#
CONFIG_VALIDATE_FS_PARSER=y
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_EXT4_KUNIT_TESTS=m
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=y
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_ONLINE_SCRUB is not set
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=y
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
# CONFIG_BTRFS_FS_REF_VERIFY is not set
CONFIG_NILFS2_FS=m
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
CONFIG_F2FS_FS_COMPRESSION=y
# CONFIG_F2FS_FS_LZO is not set
CONFIG_F2FS_FS_LZ4=y
CONFIG_F2FS_FS_LZ4HC=y
# CONFIG_F2FS_FS_ZSTD is not set
CONFIG_F2FS_IOSTAT=y
CONFIG_ZONEFS_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_EXPORTFS_BLOCK_OPS is not set
CONFIG_FILE_LOCKING=y
# CONFIG_FS_ENCRYPTION is not set
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
CONFIG_AUTOFS_FS=m
CONFIG_FUSE_FS=m
# CONFIG_CUSE is not set
CONFIG_VIRTIO_FS=m
# CONFIG_OVERLAY_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_KUNIT_TEST=m
CONFIG_EXFAT_FS=m
CONFIG_EXFAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y
CONFIG_NTFS3_FS=m
# CONFIG_NTFS3_64BIT_CLUSTER is not set
# CONFIG_NTFS3_LZX_XPRESS is not set
CONFIG_NTFS3_FS_POSIX_ACL=y
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
# CONFIG_PROC_SYSCTL is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_ARCH_SUPPORTS_HUGETLBFS=y
# CONFIG_HUGETLBFS is not set
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
# end of Pseudo filesystems

# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=m
CONFIG_UNICODE=m
CONFIG_UNICODE_NORMALIZATION_SELFTEST=m
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_REQUEST_CACHE=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=m

#
# No trust source selected!
#
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_KEY_NOTIFICATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set
CONFIG_FORTIFY_SOURCE=y
CONFIG_STATIC_USERMODEHELPER=y
CONFIG_STATIC_USERMODEHELPER_PATH="/sbin/usermode-helper"
# CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_CC_HAS_AUTO_VAR_INIT_PATTERN=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO_BARE=y
CONFIG_CC_HAS_AUTO_VAR_INIT_ZERO=y
# CONFIG_INIT_STACK_NONE is not set
# CONFIG_INIT_STACK_ALL_PATTERN is not set
CONFIG_INIT_STACK_ALL_ZERO=y
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization

CONFIG_CC_HAS_RANDSTRUCT=y
CONFIG_RANDSTRUCT_NONE=y
# CONFIG_RANDSTRUCT_FULL is not set
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
# end of Crypto core or helper

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_DH_RFC7919_GROUPS=y
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
CONFIG_CRYPTO_SM2=y
CONFIG_CRYPTO_CURVE25519=y
# end of Public-key cryptography

#
# Block ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_TI=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARIA=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SM4_GENERIC is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# end of Block ciphers

#
# Length-preserving ciphers and modes
#
CONFIG_CRYPTO_ADIANTUM=m
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_CHACHA20=m
# CONFIG_CRYPTO_CBC is not set
CONFIG_CRYPTO_CFB=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=m
# CONFIG_CRYPTO_HCTR2 is not set
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_OFB=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=m
CONFIG_CRYPTO_NHPOLY1305=m
# end of Length-preserving ciphers and modes

#
# AEAD (authenticated encryption with associated data) ciphers
#
CONFIG_CRYPTO_AEGIS128=m
CONFIG_CRYPTO_CHACHA20POLY1305=m
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_SEQIV is not set
CONFIG_CRYPTO_ECHAINIV=m
CONFIG_CRYPTO_ESSIV=y
# end of AEAD (authenticated encryption with associated data) ciphers

#
# Hashes, digests, and MACs
#
CONFIG_CRYPTO_BLAKE2B=y
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
CONFIG_CRYPTO_SM3=y
# CONFIG_CRYPTO_SM3_GENERIC is not set
# CONFIG_CRYPTO_STREEBOG is not set
# CONFIG_CRYPTO_VMAC is not set
CONFIG_CRYPTO_WP512=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_XXHASH=m
# end of Hashes, digests, and MACs

#
# CRCs (cyclic redundancy checks)
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRC64_ROCKSOFT=y
# end of CRCs (cyclic redundancy checks)

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_842=m
CONFIG_CRYPTO_LZ4=m
CONFIG_CRYPTO_LZ4HC=m
CONFIG_CRYPTO_ZSTD=y
# end of Compression

#
# Random number generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
# CONFIG_CRYPTO_DRBG_CTR is not set
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
# end of Random number generation

#
# Userspace interface
#
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_USER_API_RNG is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
CONFIG_CRYPTO_STATS=y
# end of Userspace interface

CONFIG_CRYPTO_HASH_INFO=y

#
# Accelerated Cryptographic Algorithms for CPU (s390)
#
# CONFIG_CRYPTO_CRC32_S390 is not set
CONFIG_CRYPTO_SHA512_S390=m
CONFIG_CRYPTO_SHA1_S390=m
CONFIG_CRYPTO_SHA256_S390=m
CONFIG_CRYPTO_SHA3_256_S390=y
CONFIG_CRYPTO_SHA3_512_S390=m
CONFIG_CRYPTO_GHASH_S390=m
CONFIG_CRYPTO_AES_S390=m
CONFIG_CRYPTO_DES_S390=y
CONFIG_CRYPTO_CHACHA_S390=m
# end of Accelerated Cryptographic Algorithms for CPU (s390)

# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
CONFIG_PKCS7_MESSAGE_PARSER=y
CONFIG_PKCS7_TEST_KEY=m
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
CONFIG_FIPS_SIGNATURE_SELFTEST=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_EXTRA_CERTIFICATE=y
CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE=4096
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
CONFIG_LINEAR_RANGES=y
CONFIG_PACKING=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=y
# CONFIG_PRIME_NUMBERS is not set
CONFIG_RATIONAL=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_UTILS=y
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=y
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
CONFIG_CRYPTO_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CURVE25519_GENERIC=y
CONFIG_CRYPTO_LIB_CURVE25519=y
CONFIG_CRYPTO_LIB_DES=y
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=1
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=y
CONFIG_CRYPTO_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_CHACHA20POLY1305=m
CONFIG_CRYPTO_LIB_SHA1=y
CONFIG_CRYPTO_LIB_SHA256=y
# end of Crypto library routines

CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=y
CONFIG_CRC4=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_XXHASH=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=m
CONFIG_842_DECOMPRESS=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
# CONFIG_ZLIB_DFLTCC is not set
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMMON=y
CONFIG_ZSTD_COMPRESS=y
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC16=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DMA_DECLARE_COHERENT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_SWIOTLB=y
# CONFIG_DMA_RESTRICTED_POOL is not set
CONFIG_DMA_CMA=y
CONFIG_DMA_PERNUMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_DMA_API_DEBUG=y
# CONFIG_DMA_API_DEBUG_SG is not set
# CONFIG_DMA_MAP_BENCHMARK is not set
CONFIG_SGL_ALLOC=y
# CONFIG_CPUMASK_OFFSTACK is not set
# CONFIG_FORCE_NR_CPUS is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=m
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_LIBFDT=y
CONFIG_OID_REGISTRY=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_SG_POOL=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_REF_TRACKER=y
CONFIG_SBITMAP=y
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_SYMBOLIC_ERRNAME=y
# CONFIG_DEBUG_BUGVERBOSE is not set
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_MISC is not set

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_AS_HAS_NON_CONST_LEB128=y
# CONFIG_DEBUG_INFO_NONE is not set
CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_DWARF5 is not set
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_PAHOLE_HAS_BTF_TAG=y
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
CONFIG_HEADERS_INSTALL=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_VMLINUX_MAP is not set
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
CONFIG_UBSAN_TRAP=y
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_CC_HAS_UBSAN_ARRAY_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ARRAY_BOUNDS=y
# CONFIG_UBSAN_LOCAL_BOUNDS is not set
CONFIG_UBSAN_SHIFT=y
CONFIG_UBSAN_UNREACHABLE=y
CONFIG_UBSAN_BOOL=y
# CONFIG_UBSAN_ENUM is not set
CONFIG_UBSAN_SANITIZE_ALL=y
CONFIG_TEST_UBSAN=m
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
CONFIG_NET_NS_REFCNT_TRACKER=y
# CONFIG_DEBUG_NET is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
CONFIG_DEBUG_PAGEALLOC=y
# CONFIG_DEBUG_PAGEALLOC_ENABLE_DEFAULT is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_PAGE_OWNER=y
CONFIG_PAGE_POISONING=y
CONFIG_DEBUG_PAGE_REF=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
CONFIG_PTDUMP_CORE=y
CONFIG_PTDUMP_DEBUGFS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_SHRINKER_DEBUG=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_SCHED_STACK_END_CHECK=y
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
CONFIG_DEBUG_VM_IRQSOFF=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_MAPLE_TREE=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VM_PGFLAGS=y
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
CONFIG_KASAN_KUNIT_TEST=y
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_WQ_WATCHDOG=y
CONFIG_TEST_LOCKUP=m
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

CONFIG_DEBUG_TIMEKEEPING=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RAW_LOCK_NESTING=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
CONFIG_DEBUG_LOCKDEP=y
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=y
CONFIG_SCF_TORTURE_TEST=y
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
CONFIG_DEBUG_KOBJECT=y

#
# Debug kernel data structures
#
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PLIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
CONFIG_DEBUG_MAPLE_TREE=y
# end of Debug kernel data structures

CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_SCALE_TEST=m
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
CONFIG_RCU_TRACE=y
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_NOP_MCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y

#
# s390 Debugging
#
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_ENTRY=y
CONFIG_CIO_INJECT=y
# end of s390 Debugging

#
# Kernel Testing and Coverage
#
CONFIG_KUNIT=y
CONFIG_KUNIT_DEBUGFS=y
CONFIG_KUNIT_TEST=y
CONFIG_KUNIT_EXAMPLE_TEST=y
CONFIG_KUNIT_ALL_TESTS=y
# CONFIG_KUNIT_DEFAULT_ENABLED is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
CONFIG_KCOV=y
# CONFIG_KCOV_ENABLE_COMPARISONS is not set
CONFIG_KCOV_INSTRUMENT_ALL=y
CONFIG_KCOV_IRQ_AREA_SIZE=0x40000
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=y
CONFIG_CPUMASK_KUNIT_TEST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_TEST_MIN_HEAP=m
CONFIG_TEST_SORT=y
# CONFIG_TEST_DIV64 is not set
CONFIG_BACKTRACE_SELF_TEST=m
CONFIG_TEST_REF_TRACKER=m
# CONFIG_RBTREE_TEST is not set
CONFIG_REED_SOLOMON_TEST=m
CONFIG_INTERVAL_TREE_TEST=y
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_HEXDUMP=y
CONFIG_STRING_SELFTEST=y
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_TEST_PRINTF is not set
CONFIG_TEST_SCANF=y
CONFIG_TEST_BITMAP=y
CONFIG_TEST_UUID=y
# CONFIG_TEST_XARRAY is not set
CONFIG_TEST_RHASHTABLE=y
CONFIG_TEST_SIPHASH=y
CONFIG_TEST_IDA=m
CONFIG_TEST_LKM=m
CONFIG_TEST_BITOPS=m
# CONFIG_TEST_VMALLOC is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_TEST_BPF is not set
CONFIG_TEST_BLACKHOLE_DEV=m
CONFIG_FIND_BIT_BENCHMARK=m
CONFIG_TEST_FIRMWARE=y
CONFIG_BITFIELD_KUNIT=y
CONFIG_HASH_KUNIT_TEST=y
CONFIG_RESOURCE_KUNIT_TEST=y
CONFIG_SYSCTL_KUNIT_TEST=y
CONFIG_LIST_KUNIT_TEST=y
CONFIG_LINEAR_RANGES_TEST=y
CONFIG_CMDLINE_KUNIT_TEST=y
CONFIG_BITS_TEST=y
CONFIG_RATIONAL_KUNIT_TEST=y
CONFIG_MEMCPY_KUNIT_TEST=y
CONFIG_IS_SIGNED_TYPE_KUNIT_TEST=y
CONFIG_OVERFLOW_KUNIT_TEST=y
CONFIG_STACKINIT_KUNIT_TEST=y
CONFIG_FORTIFY_KUNIT_TEST=y
CONFIG_TEST_UDELAY=m
CONFIG_TEST_STATIC_KEYS=m
# CONFIG_TEST_MEMCAT_P is not set
# CONFIG_TEST_MEMINIT is not set
CONFIG_TEST_FREE_PAGES=m
# end of Kernel Testing and Coverage

#
# Rust hacking
#
# end of Rust hacking
# end of Kernel hacking

--xqM25QzY7bQb4GsA
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--xqM25QzY7bQb4GsA--

