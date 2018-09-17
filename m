From: kbuild test robot <lkp@intel.com>
Subject: [dm:for-next 2/3] drivers/md/dm-mpath.c:821:37: error:
 passing argument 1 of 'strcmp' from incompatible pointer type
Date: Tue, 18 Sep 2018 00:16:19 +0800
Message-ID: <201809180017.4eexn37t%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, kbuild-all@01.org
List-Id: dm-devel.ids


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
head:   9c01fc7e4f3b269a5550014c16ba2fa15b90fc45
commit: 560e9814d061de1dce3328630846025d653dea7d [2/3] dm mpath: fix attached_handler_name leak and dangling hw_handler_name pointer
config: x86_64-randconfig-x019-201837 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        git checkout 560e9814d061de1dce3328630846025d653dea7d
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All error/warnings (new ones prefixed by >>):

   drivers/md/dm-mpath.c: In function 'setup_scsi_dh':
>> drivers/md/dm-mpath.c:821:37: error: passing argument 1 of 'strcmp' from incompatible pointer type [-Werror=incompatible-pointer-types]
       if (m->hw_handler_name && strcmp(attached_handler_name, m->hw_handler_name)) {
                                        ^~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/bitmap.h:9:0,
                    from include/linux/cpumask.h:12,
                    from arch/x86/include/asm/cpumask.h:5,
                    from arch/x86/include/asm/msr.h:11,
                    from arch/x86/include/asm/processor.h:21,
                    from arch/x86/include/asm/cpufeature.h:5,
                    from arch/x86/include/asm/thread_info.h:53,
                    from include/linux/thread_info.h:38,
                    from arch/x86/include/asm/preempt.h:7,
                    from include/linux/preempt.h:81,
                    from include/linux/spinlock.h:51,
                    from include/linux/wait.h:9,
                    from include/linux/wait_bit.h:8,
                    from include/linux/fs.h:6,
                    from include/linux/highmem.h:5,
                    from include/linux/bio.h:21,
                    from include/linux/device-mapper.h:11,
                    from drivers/md/dm-mpath.c:8:
   include/linux/string.h:44:12: note: expected 'const char *' but argument is of type 'char **'
    extern int strcmp(const char *,const char *);
               ^~~~~~
   drivers/md/dm-mpath.c: In function 'parse_path':
>> drivers/md/dm-mpath.c:891:24: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
                           ^
   cc1: some warnings being treated as errors

vim +/strcmp +821 drivers/md/dm-mpath.c

^1da177e Linus Torvalds      2005-04-16  807  
e8f74a0f Mike Snitzer        2018-03-12  808  static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
560e9814 Mike Snitzer        2018-09-17  809  			 char **attached_handler_name, char **error)
^1da177e Linus Torvalds      2005-04-16  810  {
848b8aef Mike Snitzer        2017-12-10  811  	struct request_queue *q = bdev_get_queue(bdev);
848b8aef Mike Snitzer        2017-12-10  812  	int r;
a58a935d Mike Snitzer        2012-07-27  813  
518257b1 Mike Snitzer        2016-03-17  814  	if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags)) {
1bab0de0 Christoph Hellwig   2015-08-27  815  retain:
560e9814 Mike Snitzer        2018-09-17  816  		if (*attached_handler_name) {
a58a935d Mike Snitzer        2012-07-27  817  			/*
54cd640d tang.junhui         2016-11-24  818  			 * Clear any hw_handler_params associated with a
54cd640d tang.junhui         2016-11-24  819  			 * handler that isn't already attached.
54cd640d tang.junhui         2016-11-24  820  			 */
54cd640d tang.junhui         2016-11-24 @821  			if (m->hw_handler_name && strcmp(attached_handler_name, m->hw_handler_name)) {
54cd640d tang.junhui         2016-11-24  822  				kfree(m->hw_handler_params);
54cd640d tang.junhui         2016-11-24  823  				m->hw_handler_params = NULL;
54cd640d tang.junhui         2016-11-24  824  			}
54cd640d tang.junhui         2016-11-24  825  
54cd640d tang.junhui         2016-11-24  826  			/*
a58a935d Mike Snitzer        2012-07-27  827  			 * Reset hw_handler_name to match the attached handler
a58a935d Mike Snitzer        2012-07-27  828  			 *
a58a935d Mike Snitzer        2012-07-27  829  			 * NB. This modifies the table line to show the actual
a58a935d Mike Snitzer        2012-07-27  830  			 * handler instead of the original table passed in.
a58a935d Mike Snitzer        2012-07-27  831  			 */
a58a935d Mike Snitzer        2012-07-27  832  			kfree(m->hw_handler_name);
560e9814 Mike Snitzer        2018-09-17  833  			m->hw_handler_name = *attached_handler_name;
560e9814 Mike Snitzer        2018-09-17  834  			*attached_handler_name = NULL;
a58a935d Mike Snitzer        2012-07-27  835  		}
a58a935d Mike Snitzer        2012-07-27  836  	}
a0cf7ea9 Hannes Reinecke     2009-06-22  837  
a58a935d Mike Snitzer        2012-07-27  838  	if (m->hw_handler_name) {
a0cf7ea9 Hannes Reinecke     2009-06-22  839  		r = scsi_dh_attach(q, m->hw_handler_name);
a0cf7ea9 Hannes Reinecke     2009-06-22  840  		if (r == -EBUSY) {
1bab0de0 Christoph Hellwig   2015-08-27  841  			char b[BDEVNAME_SIZE];
a0cf7ea9 Hannes Reinecke     2009-06-22  842  
1bab0de0 Christoph Hellwig   2015-08-27  843  			printk(KERN_INFO "dm-mpath: retaining handler on device %s\n",
848b8aef Mike Snitzer        2017-12-10  844  			       bdevname(bdev, b));
1bab0de0 Christoph Hellwig   2015-08-27  845  			goto retain;
1bab0de0 Christoph Hellwig   2015-08-27  846  		}
ae11b1b3 Hannes Reinecke     2008-07-17  847  		if (r < 0) {
848b8aef Mike Snitzer        2017-12-10  848  			*error = "error attaching hardware handler";
848b8aef Mike Snitzer        2017-12-10  849  			return r;
ae11b1b3 Hannes Reinecke     2008-07-17  850  		}
2bfd2e13 Chandra Seetharaman 2009-08-03  851  
2bfd2e13 Chandra Seetharaman 2009-08-03  852  		if (m->hw_handler_params) {
2bfd2e13 Chandra Seetharaman 2009-08-03  853  			r = scsi_dh_set_params(q, m->hw_handler_params);
2bfd2e13 Chandra Seetharaman 2009-08-03  854  			if (r < 0) {
848b8aef Mike Snitzer        2017-12-10  855  				*error = "unable to set hardware handler parameters";
848b8aef Mike Snitzer        2017-12-10  856  				return r;
848b8aef Mike Snitzer        2017-12-10  857  			}
848b8aef Mike Snitzer        2017-12-10  858  		}
848b8aef Mike Snitzer        2017-12-10  859  	}
848b8aef Mike Snitzer        2017-12-10  860  
848b8aef Mike Snitzer        2017-12-10  861  	return 0;
848b8aef Mike Snitzer        2017-12-10  862  }
848b8aef Mike Snitzer        2017-12-10  863  
848b8aef Mike Snitzer        2017-12-10  864  static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps,
848b8aef Mike Snitzer        2017-12-10  865  				 struct dm_target *ti)
848b8aef Mike Snitzer        2017-12-10  866  {
848b8aef Mike Snitzer        2017-12-10  867  	int r;
848b8aef Mike Snitzer        2017-12-10  868  	struct pgpath *p;
848b8aef Mike Snitzer        2017-12-10  869  	struct multipath *m = ti->private;
e8f74a0f Mike Snitzer        2018-03-12  870  	struct request_queue *q;
560e9814 Mike Snitzer        2018-09-17  871  	char *attached_handler_name = NULL;
848b8aef Mike Snitzer        2017-12-10  872  
848b8aef Mike Snitzer        2017-12-10  873  	/* we need at least a path arg */
848b8aef Mike Snitzer        2017-12-10  874  	if (as->argc < 1) {
848b8aef Mike Snitzer        2017-12-10  875  		ti->error = "no device given";
848b8aef Mike Snitzer        2017-12-10  876  		return ERR_PTR(-EINVAL);
848b8aef Mike Snitzer        2017-12-10  877  	}
848b8aef Mike Snitzer        2017-12-10  878  
848b8aef Mike Snitzer        2017-12-10  879  	p = alloc_pgpath();
848b8aef Mike Snitzer        2017-12-10  880  	if (!p)
848b8aef Mike Snitzer        2017-12-10  881  		return ERR_PTR(-ENOMEM);
848b8aef Mike Snitzer        2017-12-10  882  
848b8aef Mike Snitzer        2017-12-10  883  	r = dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
848b8aef Mike Snitzer        2017-12-10  884  			  &p->path.dev);
848b8aef Mike Snitzer        2017-12-10  885  	if (r) {
848b8aef Mike Snitzer        2017-12-10  886  		ti->error = "error getting device";
2bfd2e13 Chandra Seetharaman 2009-08-03  887  		goto bad;
2bfd2e13 Chandra Seetharaman 2009-08-03  888  	}
848b8aef Mike Snitzer        2017-12-10  889  
e8f74a0f Mike Snitzer        2018-03-12  890  	q = bdev_get_queue(p->path.dev->bdev);
e8f74a0f Mike Snitzer        2018-03-12 @891  	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
e457edf0 Mike Snitzer        2018-03-29  892  	if (attached_handler_name || m->hw_handler_name) {
848b8aef Mike Snitzer        2017-12-10  893  		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
560e9814 Mike Snitzer        2018-09-17  894  		r = setup_scsi_dh(p->path.dev->bdev, m, &attached_handler_name, &ti->error);
848b8aef Mike Snitzer        2017-12-10  895  		if (r) {
848b8aef Mike Snitzer        2017-12-10  896  			dm_put_device(ti, p->path.dev);
848b8aef Mike Snitzer        2017-12-10  897  			goto bad;
2bfd2e13 Chandra Seetharaman 2009-08-03  898  		}
ae11b1b3 Hannes Reinecke     2008-07-17  899  	}
ae11b1b3 Hannes Reinecke     2008-07-17  900  
^1da177e Linus Torvalds      2005-04-16  901  	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
^1da177e Linus Torvalds      2005-04-16  902  	if (r) {
^1da177e Linus Torvalds      2005-04-16  903  		dm_put_device(ti, p->path.dev);
^1da177e Linus Torvalds      2005-04-16  904  		goto bad;
^1da177e Linus Torvalds      2005-04-16  905  	}
^1da177e Linus Torvalds      2005-04-16  906  
^1da177e Linus Torvalds      2005-04-16  907  	return p;
^1da177e Linus Torvalds      2005-04-16  908   bad:
560e9814 Mike Snitzer        2018-09-17  909  	kfree(attached_handler_name);
^1da177e Linus Torvalds      2005-04-16  910  	free_pgpath(p);
01460f35 Benjamin Marzinski  2008-10-10  911  	return ERR_PTR(r);
^1da177e Linus Torvalds      2005-04-16  912  }
^1da177e Linus Torvalds      2005-04-16  913  

:::::: The code at line 821 was first introduced by commit
:::::: 54cd640d20de46bb54747286ca19f3995be921f2 dm mpath: use hw_handler_params if attached hw_handler is same as requested

:::::: TO: tang.junhui <tang.junhui@zte.com.cn>
:::::: CC: Mike Snitzer <snitzer@redhat.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--ZGiS0Q5IWpPtfppv
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
/B+t/d9LyX0BAA==

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--ZGiS0Q5IWpPtfppv--
