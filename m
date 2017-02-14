From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v4 1/1] DM: inplace compressed DM target (fwd)
Date: Tue, 14 Feb 2017 07:09:04 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1702140707530.2033@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, corbet@lwn.net, shli@kernel.org, hbabu@us.ibm.com, linuxram@us.ibm.comagk@redhat.comsnitzer@redhat.comcorbet@lwn.netshli@kernel.orghbabu@us.ibm.comlinuxram@us.ibm.com
List-Id: dm-devel.ids

On line 1759, since ret is unsigned it will not be less than 0.

julia

---------- Forwarded message ----------
Date: Tue, 14 Feb 2017 09:00:39 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v4 1/1] DM: inplace compressed DM target

CC: kbuild-all@01.org
In-Reply-To: <1487018545-5061-2-git-send-email-linuxram@us.ibm.com>

Hi Ram,

[auto build test WARNING on dm/for-next]
[also build test WARNING on v4.10-rc8 next-20170213]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ram-Pai/DM-inplace-compressed-DM-target/20170214-055727
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
:::::: branch date: 3 hours ago
:::::: commit date: 3 hours ago

>> drivers/md/dm-inplace-compress.c:1759:5-8: WARNING: Unsigned expression compared with zero: ret < 0

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout e7924efaaba5efdcd28f32efbb949ed1153c932c
vim +1759 drivers/md/dm-inplace-compress.c

e7924efa Ram Pai 2017-02-13  1743   * @io : io range
e7924efa Ram Pai 2017-02-13  1744   * @sector_start : the sector on backing storage to which the
e7924efa Ram Pai 2017-02-13  1745   *	compressed data needs to be written.
e7924efa Ram Pai 2017-02-13  1746   * @meta_start: the page index of the bits corresponding to
e7924efa Ram Pai 2017-02-13  1747   * @meta_end  : start and end blocks.
e7924efa Ram Pai 2017-02-13  1748   */
e7924efa Ram Pai 2017-02-13  1749  static int dm_icomp_compress_write(struct dm_icomp_io_range *io,
e7924efa Ram Pai 2017-02-13  1750  		sector_t sector_start, u64 *meta_start, u64 *meta_end)
e7924efa Ram Pai 2017-02-13  1751  {
e7924efa Ram Pai 2017-02-13  1752  	struct dm_icomp_req *req = io->req;
e7924efa Ram Pai 2017-02-13  1753  	sector_t count = DMCP_BYTES_TO_SECTOR(io->decomp_len);
e7924efa Ram Pai 2017-02-13  1754  	unsigned int comp_len, ret;
e7924efa Ram Pai 2017-02-13  1755  	u64 page_index;
e7924efa Ram Pai 2017-02-13  1756
e7924efa Ram Pai 2017-02-13  1757  	/* comp_data must be able to accommadate a larger compress buffer */
e7924efa Ram Pai 2017-02-13  1758  	ret = dm_icomp_io_range_compress(req->info, io, &comp_len);
e7924efa Ram Pai 2017-02-13 @1759  	if (ret < 0) {
e7924efa Ram Pai 2017-02-13  1760  		req->result = -EIO;
e7924efa Ram Pai 2017-02-13  1761  		return -EIO;
e7924efa Ram Pai 2017-02-13  1762  	}
e7924efa Ram Pai 2017-02-13  1763  	WARN_ON(comp_len > io->comp_len);
e7924efa Ram Pai 2017-02-13  1764
e7924efa Ram Pai 2017-02-13  1765  	dm_icomp_get_req(req);
e7924efa Ram Pai 2017-02-13  1766
e7924efa Ram Pai 2017-02-13  1767  	io->io_req.bi_op = REQ_OP_WRITE;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
