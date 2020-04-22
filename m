From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:for-next 27/28] drivers/md/dm-crypt.c:2281:
 undefined reference to `key_type_encrypted'
Date: Wed, 22 Apr 2020 17:25:38 -0400
Message-ID: <20200422212538.GA10422@redhat.com>
References: <202004230513.auAlcg7E%lkp@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <202004230513.auAlcg7E%lkp@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: kbuild test robot <lkp@intel.com>
Cc: Dmitry Baryshkov <dmitry_baryshkov@mentor.com>, dm-devel@redhat.com, kbuild-all@lists.01.org
List-Id: dm-devel.ids


I fixed this ~3 minutes after pushing.. amazing how quick the kbuild test robot is!

But thanks,
Mike

On Wed, Apr 22 2020 at  5:21pm -0400,
kbuild test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
> head:   2d56364c7c7ba64576c37a16c8af98f66b4bb16b
> commit: 5cacab0334b940164ad6aac39712f4d3b06076bc [27/28] dm crypt: support using encrypted keys
> config: i386-randconfig-e001-20200421 (attached as .config)
> compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
> reproduce:
>         git checkout 5cacab0334b940164ad6aac39712f4d3b06076bc
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    ld: drivers/md/dm-crypt.o: in function `crypt_set_keyring_key':
> >> drivers/md/dm-crypt.c:2281: undefined reference to `key_type_encrypted'
> 
> vim +2281 drivers/md/dm-crypt.c
> 
>   2251	
>   2252	static int crypt_set_keyring_key(struct crypt_config *cc, const char *key_string)
>   2253	{
>   2254		char *new_key_string, *key_desc;
>   2255		int ret;
>   2256		struct key_type *type;
>   2257		struct key *key;
>   2258		int (*set_key)(struct crypt_config *cc, struct key *key);
>   2259	
>   2260		/*
>   2261		 * Reject key_string with whitespace. dm core currently lacks code for
>   2262		 * proper whitespace escaping in arguments on DM_TABLE_STATUS path.
>   2263		 */
>   2264		if (contains_whitespace(key_string)) {
>   2265			DMERR("whitespace chars not allowed in key string");
>   2266			return -EINVAL;
>   2267		}
>   2268	
>   2269		/* look for next ':' separating key_type from key_description */
>   2270		key_desc = strpbrk(key_string, ":");
>   2271		if (!key_desc || key_desc == key_string || !strlen(key_desc + 1))
>   2272			return -EINVAL;
>   2273	
>   2274		if (!strncmp(key_string, "logon:", key_desc - key_string + 1)) {
>   2275			type = &key_type_logon;
>   2276			set_key = set_key_user;
>   2277		} else if (!strncmp(key_string, "user:", key_desc - key_string + 1)) {
>   2278			type = &key_type_user;
>   2279			set_key = set_key_user;
>   2280		} else if (!strncmp(key_string, "encrypted:", key_desc - key_string + 1)) {
> > 2281			type = &key_type_encrypted;
>   2282			set_key = set_key_encrypted;
>   2283		} else {
>   2284			return -EINVAL;
>   2285		}
>   2286	
>   2287		new_key_string = kstrdup(key_string, GFP_KERNEL);
>   2288		if (!new_key_string)
>   2289			return -ENOMEM;
>   2290	
>   2291		key = request_key(type, key_desc + 1, NULL);
>   2292		if (IS_ERR(key)) {
>   2293			kzfree(new_key_string);
>   2294			return PTR_ERR(key);
>   2295		}
>   2296	
>   2297		down_read(&key->sem);
>   2298	
>   2299		ret = set_key(cc, key);
>   2300		if (ret < 0) {
>   2301			up_read(&key->sem);
>   2302			key_put(key);
>   2303			kzfree(new_key_string);
>   2304			return ret;
>   2305		}
>   2306	
>   2307		up_read(&key->sem);
>   2308		key_put(key);
>   2309	
>   2310		/* clear the flag since following operations may invalidate previously valid key */
>   2311		clear_bit(DM_CRYPT_KEY_VALID, &cc->flags);
>   2312	
>   2313		ret = crypt_setkey(cc);
>   2314	
>   2315		if (!ret) {
>   2316			set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
>   2317			kzfree(cc->key_string);
>   2318			cc->key_string = new_key_string;
>   2319		} else
>   2320			kzfree(new_key_string);
>   2321	
>   2322		return ret;
>   2323	}
>   2324	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
