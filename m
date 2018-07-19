From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 4/5] crypto: Add IV generation templates
Date: Fri, 20 Jul 2018 02:14:54 +0800
Message-ID: <201807200243.21tygjmy%fengguang.wu@intel.com>
References: <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1531899055-29362-5-git-send-email-wangxiongfeng2@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: herbert@gondor.apana.org.au, snitzer@redhat.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, broonie@kernel.org, arnd@arndb.de, kbuild-all@01.org, jonathan.cameron@huawei.com, wangxiongfeng2@huawei.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Xiongfeng,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.18-rc5 next-20180719]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Xiongfeng-Wang/crypto-add-IV-generation-templates/20180719-034438
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> crypto/geniv.c:303:9: sparse: Variable length array is used.
   crypto/geniv.c:568:9: sparse: Variable length array is used.
   crypto/geniv.c:729:9: sparse: Variable length array is used.
   include/linux/slab.h:631:13: sparse: undefined identifier '__builtin_mul_overflow'
   include/linux/slab.h:631:13: sparse: not a function <noident>
>> crypto/geniv.c:1482:17: sparse: incorrect type in assignment (different base types) @@    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident> @@    got long] [long long] [usertype] <noident> @@
   crypto/geniv.c:1482:17:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   crypto/geniv.c:1482:17:    got restricted __le64 [usertype] <noident>
>> crypto/geniv.c:1543:17: sparse: cast to restricted __le64
   crypto/geniv.c:1580:17: sparse: incorrect type in assignment (different base types) @@    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident> @@    got long] [long long] [usertype] <noident> @@
   crypto/geniv.c:1580:17:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
   crypto/geniv.c:1580:17:    got restricted __le64 [usertype] <noident>
>> crypto/geniv.c:1912:32: sparse: expression using sizeof(void)
   include/linux/slab.h:631:13: sparse: call with no type!

vim +303 crypto/geniv.c

   298	
   299	/* Initialise ESSIV - compute salt but no local memory allocations */
   300	static int crypt_iv_essiv_init(struct geniv_ctx *ctx)
   301	{
   302		struct geniv_essiv_private *essiv = &ctx->iv_gen_private.essiv;
 > 303		AHASH_REQUEST_ON_STACK(req, essiv->hash_tfm);
   304		struct scatterlist sg;
   305		struct crypto_cipher *essiv_tfm;
   306		int err;
   307	
   308		sg_init_one(&sg, ctx->key, ctx->key_size);
   309		ahash_request_set_tfm(req, essiv->hash_tfm);
   310		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
   311		ahash_request_set_crypt(req, &sg, essiv->salt, ctx->key_size);
   312	
   313		err = crypto_ahash_digest(req);
   314		ahash_request_zero(req);
   315		if (err)
   316			return err;
   317	
   318		essiv_tfm = ctx->iv_private;
   319	
   320		return crypto_cipher_setkey(essiv_tfm, essiv->salt,
   321				    crypto_ahash_digestsize(essiv->hash_tfm));
   322	}
   323	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
