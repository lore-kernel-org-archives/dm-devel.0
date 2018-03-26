From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm:dm-4.17 25/25]
 drivers//md/dm-verity-target.c:560:22: error: assignment from incompatible
 pointer type
Date: Mon, 26 Mar 2018 19:06:37 -0400
Message-ID: <20180326230637.GA23361@redhat.com>
References: <201803270618.KWQb6Ye5%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <201803270618.KWQb6Ye5%fengguang.wu@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, kbuild-all@01.org, yaeceh01 <yael.chemla@foss.arm.com>
List-Id: dm-devel.ids

I've since fixed this up.. but I'll respond to the previous posted
patches with additional context on what I changed.

I also have a request about how the sg array is freed on the error path.

Mike

On Mon, Mar 26 2018 at  6:34pm -0400,
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git dm-4.17
> head:   8702a90d3c773f590c875d4300e751fce1780bbc
> commit: 8702a90d3c773f590c875d4300e751fce1780bbc [25/25] dm verity: allow parallel processing of blocks
> config: i386-randconfig-x016-201812 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         git checkout 8702a90d3c773f590c875d4300e751fce1780bbc
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers//md/dm-verity-target.c: In function 'verity_verify_io':
> >> drivers//md/dm-verity-target.c:560:22: error: assignment from incompatible pointer type [-Werror=incompatible-pointer-types]
>      iodata->reqdata_arr = reqdata_arr;
>                          ^
>    cc1: some warnings being treated as errors
> 
> vim +560 drivers//md/dm-verity-target.c
> 
>    533	
>    534	static void verity_release_req(struct dm_verity_io_data *iodata)
>    535	{
>    536		kfree(iodata->reqdata_arr);
>    537		kfree(iodata);
>    538	}
>    539	/*
>    540	 * Verify one "dm_verity_io" structure.
>    541	 */
>    542	static void verity_verify_io(struct dm_verity_io *io)
>    543	{
>    544		bool is_zero;
>    545		struct dm_verity *v = io->v;
>    546		unsigned int b = 0, blocks = 0;
>    547		struct dm_verity_io_data *iodata = NULL;
>    548		struct dm_verity_req_data *reqdata_arr = NULL;
>    549		struct scatterlist *sg = NULL;
>    550		int r;
>    551	
>    552		iodata = kmalloc(sizeof(*iodata), GFP_NOIO);
>    553		reqdata_arr = kmalloc_array(io->n_blocks,
>    554					    sizeof(struct dm_verity_req_data), GFP_NOIO);
>    555		if (unlikely((iodata == NULL) || (reqdata_arr == NULL))) {
>    556			WARN_ON((iodata == NULL) || (reqdata_arr == NULL));
>    557			goto err_memfree;
>    558		}
>    559		atomic_set(&iodata->expected_reqs, io->n_blocks);
>  > 560		iodata->reqdata_arr = reqdata_arr;
>    561		iodata->io = io;
>    562		iodata->total_reqs = blocks = io->n_blocks;
>    563	
>    564		for (b = 0; b < blocks; b++) {
>    565			unsigned int nents;
>    566			unsigned int total_len = 0;
>    567			unsigned int num_of_buffs = 0;
>    568			sector_t cur_block = io->block + b;
>    569	
>    570			if (v->validated_blocks &&
>    571			    likely(test_bit(cur_block, v->validated_blocks))) {
>    572				verity_bv_skip_block(v, io, &io->iter);
>    573				continue;
>    574			}
>    575	
>    576			reqdata_arr[b].req = ahash_request_alloc(v->tfm, GFP_NOIO);
>    577			if (unlikely(reqdata_arr[b].req == NULL))
>    578				goto err_memfree;
>    579			ahash_request_set_tfm(reqdata_arr[b].req, v->tfm);
>    580	
>    581			/* +1 for the salt buffer */
>    582			num_of_buffs = verity_calc_buffs_for_bv(v, io, &io->iter) + 1;
>    583			WARN_ON(num_of_buffs < 1);
>    584			sg = kmalloc_array(num_of_buffs, sizeof(struct scatterlist),
>    585					   GFP_NOIO);
>    586			if (!sg) {
>    587				DMERR_LIMIT("%s: kmalloc_array failed", __func__);
>    588				goto err_memfree;
>    589			}
>    590			sg_init_table(sg, num_of_buffs);
>    591			// FIXME: if we 'err_memfree' (or continue;) below how does this sg get kfree()'d?
>    592	
>    593			r = verity_hash_for_block(v, io, cur_block,
>    594						  reqdata_arr[b].want_digest,
>    595						  &reqdata_arr[b].fec_io, &is_zero);
>    596			if (unlikely(r < 0))
>    597				goto err_memfree;
>    598	
>    599			if (is_zero) {
>    600				/*
>    601				 * If we expect a zero block, don't validate, just
>    602				 * return zeroes.
>    603				 */
>    604				r = verity_for_bv_block(v, io, &io->iter,
>    605							verity_bv_zero);
>    606				if (unlikely(r < 0))
>    607					goto err_memfree;
>    608				verity_cb_complete(iodata, r);
>    609				continue;
>    610			}
>    611	
>    612			nents = 0;
>    613			total_len = 0;
>    614			if (verity_is_salt_required(v, START_SG))
>    615				verity_add_salt(v, sg, &nents, &total_len);
>    616	
>    617			verity_for_io_block(v, io, &io->iter, sg, &nents, &total_len);
>    618			if (verity_is_salt_required(v, END_SG))
>    619				verity_add_salt(v, sg, &nents, &total_len);
>    620	
>    621			reqdata_arr[b].iodata = iodata;
>    622			reqdata_arr[b].sg = sg;
>    623			reqdata_arr[b].digest_size = v->digest_size;
>    624			reqdata_arr[b].iblock = b;
>    625			/*
>    626			 * Need to mark end of chain, since we might
>    627			 * have allocated more than we actually use.
>    628			 */
>    629			sg_mark_end(&sg[nents-1]);
>    630	
>    631			ahash_request_set_tfm(reqdata_arr[b].req, v->tfm);
>    632			ahash_request_set_callback(reqdata_arr[b].req,
>    633						   CRYPTO_TFM_REQ_MAY_SLEEP |
>    634						   CRYPTO_TFM_REQ_MAY_BACKLOG,
>    635						   single_block_req_done, &reqdata_arr[b]);
>    636			ahash_request_set_crypt(reqdata_arr[b].req, sg,
>    637						reqdata_arr[b].real_digest, total_len);
>    638			r = crypto_ahash_digest(reqdata_arr[b].req);
>    639			if (r == 0) {
>    640				/* digest completed already, callback won't be called. */
>    641				__single_block_req_done(&reqdata_arr[b], r);
>    642			}
>    643		}
>    644		return;
>    645	
>    646	err_memfree:
>    647		/*
>    648		 * reduce expected requests by the number of unsent
>    649		 * requests, -1 accounting for the current block
>    650		 */
>    651		atomic_sub(blocks - b - 1, &iodata->expected_reqs);
>    652		verity_cb_complete(iodata, -EIO);
>    653	}
>    654	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
