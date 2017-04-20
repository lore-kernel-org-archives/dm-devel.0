From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] dcssblk: add dax_operations support
Date: Thu, 20 Apr 2017 11:29:49 +0800
Message-ID: <201704201130.JVRSEa6Y%fengguang.wu@intel.com>
References: <149264113824.36586.1220609927071019352.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <149264113824.36586.1220609927071019352.stgit-p8uTFz9XbKj2zm6wflaqv1nYeNYlB/vhral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, Gerald Schaefer <gerald.schaefer-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hi Dan,

[auto build test ERROR on linus/master]
[also build test ERROR on v4.11-rc7 next-20170419]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dcssblk-add-dax_operations-support/20170420-090408
config: s390-defconfig (attached as .config)
compiler: s390x-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=s390 

All error/warnings (new ones prefixed by >>):

>> drivers/s390/block/dcssblk.c:36:46: warning: 'struct dax_device' declared inside parameter list will not be visible outside of this definition or declaration
    static long dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
                                                 ^~~~~~~~~~
>> drivers/s390/block/dcssblk.c:49:21: error: variable 'dcssblk_dax_ops' has initializer but incomplete type
    static const struct dax_operations dcssblk_dax_ops = {
                        ^~~~~~~~~~~~~~
>> drivers/s390/block/dcssblk.c:50:2: error: unknown field 'direct_access' specified in initializer
     .direct_access = dcssblk_dax_direct_access,
     ^
>> drivers/s390/block/dcssblk.c:50:19: warning: excess elements in struct initializer
     .direct_access = dcssblk_dax_direct_access,
                      ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/s390/block/dcssblk.c:50:19: note: (near initialization for 'dcssblk_dax_ops')
   drivers/s390/block/dcssblk.c: In function 'dcssblk_shared_store':
>> drivers/s390/block/dcssblk.c:400:2: error: implicit declaration of function 'kill_dax' [-Werror=implicit-function-declaration]
     kill_dax(dev_info->dax_dev);
     ^~~~~~~~
>> drivers/s390/block/dcssblk.c:401:2: error: implicit declaration of function 'put_dax' [-Werror=implicit-function-declaration]
     put_dax(dev_info->dax_dev);
     ^~~~~~~
   drivers/s390/block/dcssblk.c: In function 'dcssblk_add_store':
>> drivers/s390/block/dcssblk.c:667:22: error: implicit declaration of function 'alloc_dax' [-Werror=implicit-function-declaration]
     dev_info->dax_dev = alloc_dax(dev_info, dev_info->gd->disk_name,
                         ^~~~~~~~~
>> drivers/s390/block/dcssblk.c:667:20: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
     dev_info->dax_dev = alloc_dax(dev_info, dev_info->gd->disk_name,
                       ^
   drivers/s390/block/dcssblk.c: At top level:
   drivers/s390/block/dcssblk.c:932:1: error: conflicting types for 'dcssblk_dax_direct_access'
    dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
    ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/s390/block/dcssblk.c:36:13: note: previous declaration of 'dcssblk_dax_direct_access' was here
    static long dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
                ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/s390/block/dcssblk.c: In function 'dcssblk_dax_direct_access':
>> drivers/s390/block/dcssblk.c:935:38: error: implicit declaration of function 'dax_get_private' [-Werror=implicit-function-declaration]
     struct dcssblk_dev_info *dev_info = dax_get_private(dax_dev);
                                         ^~~~~~~~~~~~~~~
>> drivers/s390/block/dcssblk.c:935:38: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
   drivers/s390/block/dcssblk.c: At top level:
>> drivers/s390/block/dcssblk.c:49:36: error: storage size of 'dcssblk_dax_ops' isn't known
    static const struct dax_operations dcssblk_dax_ops = {
                                       ^~~~~~~~~~~~~~~
   drivers/s390/block/dcssblk.c:36:13: warning: 'dcssblk_dax_direct_access' used but never defined
    static long dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
                ^~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/s390/block/dcssblk.c:932:1: warning: 'dcssblk_dax_direct_access' defined but not used [-Wunused-function]
    dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
    ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +/dcssblk_dax_ops +49 drivers/s390/block/dcssblk.c

    30	static int dcssblk_open(struct block_device *bdev, fmode_t mode);
    31	static void dcssblk_release(struct gendisk *disk, fmode_t mode);
    32	static blk_qc_t dcssblk_make_request(struct request_queue *q,
    33							struct bio *bio);
    34	static long dcssblk_blk_direct_access(struct block_device *bdev, sector_t secnum,
    35				 void **kaddr, pfn_t *pfn, long size);
  > 36	static long dcssblk_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
    37			long nr_pages, void **kaddr, pfn_t *pfn);
    38	
    39	static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
    40	
    41	static int dcssblk_major;
    42	static const struct block_device_operations dcssblk_devops = {
    43		.owner   	= THIS_MODULE,
    44		.open    	= dcssblk_open,
    45		.release 	= dcssblk_release,
    46		.direct_access 	= dcssblk_blk_direct_access,
    47	};
    48	
  > 49	static const struct dax_operations dcssblk_dax_ops = {
  > 50		.direct_access = dcssblk_dax_direct_access,
    51	};
    52	
    53	struct dcssblk_dev_info {

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
