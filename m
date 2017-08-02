From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2] dm: allow device-mapper to operate without dax support
Date: Thu, 3 Aug 2017 00:02:57 +0800
Message-ID: <201708022330.WGRl3jzx%fengguang.wu@intel.com>
References: <150162766102.27319.10043964535977848237.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <150162766102.27319.10043964535977848237.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: kbuild-all@01.org, snitzer@redhat.com, Bart Van Assche <Bart.VanAssche@wdc.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, linux-nvdimm@lists.01.org
List-Id: dm-devel.ids


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dan,

[auto build test ERROR on dm/for-next]
[also build test ERROR on v4.13-rc3 next-20170802]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dm-allow-device-mapper-to-operate-without-dax-support/20170802-155255
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
config: s390-defconfig (attached as .config)
compiler: s390x-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=s390 

All errors (new ones prefixed by >>):

   drivers/md/dm.o: In function `cleanup_mapped_device':
>> drivers/md/dm.c:1684: undefined reference to `kill_dax'
>> drivers/md/dm.c:1685: undefined reference to `put_dax'
   drivers/md/dm.o: In function `close_table_device':
   drivers/md/dm.c:651: undefined reference to `put_dax'
   drivers/md/dm.o: In function `open_table_device':
>> drivers/md/dm.c:637: undefined reference to `dax_get_by_host'
   drivers/md/dm.o: In function `dm_dax_flush':
>> drivers/md/dm.c:1003: undefined reference to `dax_get_private'
   drivers/md/dm.o: In function `dm_dax_copy_from_iter':
   drivers/md/dm.c:979: undefined reference to `dax_get_private'
   drivers/md/dm.o: In function `dm_dax_direct_access':
   drivers/md/dm.c:951: undefined reference to `dax_get_private'
   drivers/md/dm.o: In function `alloc_dev':
>> drivers/md/dm.c:1783: undefined reference to `alloc_dax'
   drivers/md/dm-table.o: In function `device_dax_write_cache_enabled':
   drivers/md/dm-table.c:1644: undefined reference to `dax_write_cache_enabled'
   drivers/md/dm-table.o: In function `dm_table_set_restrictions':
   drivers/md/dm-table.c:1822: undefined reference to `dax_write_cache'
   drivers/md/dm-linear.o: In function `linear_dax_flush':
>> drivers/md/dm-linear.c:197: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-linear.c:199: undefined reference to `dax_flush'
   drivers/md/dm-linear.o: In function `linear_dax_copy_from_iter':
   drivers/md/dm-linear.c:183: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-linear.c:185: undefined reference to `dax_copy_from_iter'
   drivers/md/dm-linear.o: In function `linear_dax_direct_access':
   drivers/md/dm-linear.c:168: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-linear.c:171: undefined reference to `dax_direct_access'
   drivers/md/dm-stripe.o: In function `stripe_dax_flush':
>> drivers/md/dm-stripe.c:369: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-stripe.c:371: undefined reference to `dax_flush'
   drivers/md/dm-stripe.o: In function `stripe_dax_copy_from_iter':
   drivers/md/dm-stripe.c:350: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-stripe.c:352: undefined reference to `dax_copy_from_iter'
   drivers/md/dm-stripe.o: In function `stripe_dax_direct_access':
   drivers/md/dm-stripe.c:330: undefined reference to `bdev_dax_pgoff'
>> drivers/md/dm-stripe.c:333: undefined reference to `dax_direct_access'

vim +1684 drivers/md/dm.c

4a0b4ddf2 Mike Snitzer        2010-08-12  1672  
0f20972f7 Mike Snitzer        2015-04-28  1673  static void cleanup_mapped_device(struct mapped_device *md)
0f20972f7 Mike Snitzer        2015-04-28  1674  {
0f20972f7 Mike Snitzer        2015-04-28  1675  	if (md->wq)
0f20972f7 Mike Snitzer        2015-04-28  1676  		destroy_workqueue(md->wq);
0f20972f7 Mike Snitzer        2015-04-28  1677  	if (md->kworker_task)
0f20972f7 Mike Snitzer        2015-04-28  1678  		kthread_stop(md->kworker_task);
0f20972f7 Mike Snitzer        2015-04-28  1679  	mempool_destroy(md->io_pool);
0f20972f7 Mike Snitzer        2015-04-28  1680  	if (md->bs)
0f20972f7 Mike Snitzer        2015-04-28  1681  		bioset_free(md->bs);
0f20972f7 Mike Snitzer        2015-04-28  1682  
f26c5719b Dan Williams        2017-04-12  1683  	if (md->dax_dev) {
f26c5719b Dan Williams        2017-04-12 @1684  		kill_dax(md->dax_dev);
f26c5719b Dan Williams        2017-04-12 @1685  		put_dax(md->dax_dev);
f26c5719b Dan Williams        2017-04-12  1686  		md->dax_dev = NULL;
f26c5719b Dan Williams        2017-04-12  1687  	}
f26c5719b Dan Williams        2017-04-12  1688  
0f20972f7 Mike Snitzer        2015-04-28  1689  	if (md->disk) {
0f20972f7 Mike Snitzer        2015-04-28  1690  		spin_lock(&_minor_lock);
0f20972f7 Mike Snitzer        2015-04-28  1691  		md->disk->private_data = NULL;
0f20972f7 Mike Snitzer        2015-04-28  1692  		spin_unlock(&_minor_lock);
0f20972f7 Mike Snitzer        2015-04-28  1693  		del_gendisk(md->disk);
0f20972f7 Mike Snitzer        2015-04-28  1694  		put_disk(md->disk);
0f20972f7 Mike Snitzer        2015-04-28  1695  	}
0f20972f7 Mike Snitzer        2015-04-28  1696  
0f20972f7 Mike Snitzer        2015-04-28  1697  	if (md->queue)
0f20972f7 Mike Snitzer        2015-04-28  1698  		blk_cleanup_queue(md->queue);
0f20972f7 Mike Snitzer        2015-04-28  1699  
d09960b00 Tahsin Erdogan      2016-10-10  1700  	cleanup_srcu_struct(&md->io_barrier);
d09960b00 Tahsin Erdogan      2016-10-10  1701  
0f20972f7 Mike Snitzer        2015-04-28  1702  	if (md->bdev) {
0f20972f7 Mike Snitzer        2015-04-28  1703  		bdput(md->bdev);
0f20972f7 Mike Snitzer        2015-04-28  1704  		md->bdev = NULL;
0f20972f7 Mike Snitzer        2015-04-28  1705  	}
4cc96131a Mike Snitzer        2016-05-12  1706  
4cc96131a Mike Snitzer        2016-05-12  1707  	dm_mq_cleanup_mapped_device(md);
0f20972f7 Mike Snitzer        2015-04-28  1708  }
0f20972f7 Mike Snitzer        2015-04-28  1709  
^1da177e4 Linus Torvalds      2005-04-16  1710  /*
^1da177e4 Linus Torvalds      2005-04-16  1711   * Allocate and initialise a blank device with a given minor.
^1da177e4 Linus Torvalds      2005-04-16  1712   */
2b06cfff1 Alasdair G Kergon   2006-06-26  1713  static struct mapped_device *alloc_dev(int minor)
^1da177e4 Linus Torvalds      2005-04-16  1714  {
115485e83 Mike Snitzer        2016-02-22  1715  	int r, numa_node_id = dm_get_numa_node();
74f22ed6b Dan Williams        2017-08-01  1716  	struct dax_device *dax_dev = NULL;
115485e83 Mike Snitzer        2016-02-22  1717  	struct mapped_device *md;
ba61fdd17 Jeff Mahoney        2006-06-26  1718  	void *old_md;
^1da177e4 Linus Torvalds      2005-04-16  1719  
115485e83 Mike Snitzer        2016-02-22  1720  	md = kzalloc_node(sizeof(*md), GFP_KERNEL, numa_node_id);
^1da177e4 Linus Torvalds      2005-04-16  1721  	if (!md) {
^1da177e4 Linus Torvalds      2005-04-16  1722  		DMWARN("unable to allocate device, out of memory.");
^1da177e4 Linus Torvalds      2005-04-16  1723  		return NULL;
^1da177e4 Linus Torvalds      2005-04-16  1724  	}
^1da177e4 Linus Torvalds      2005-04-16  1725  
10da4f795 Jeff Mahoney        2006-06-26  1726  	if (!try_module_get(THIS_MODULE))
6ed7ade89 Milan Broz          2008-02-08  1727  		goto bad_module_get;
10da4f795 Jeff Mahoney        2006-06-26  1728  
^1da177e4 Linus Torvalds      2005-04-16  1729  	/* get a minor number for the dev */
2b06cfff1 Alasdair G Kergon   2006-06-26  1730  	if (minor == DM_ANY_MINOR)
cf13ab8e0 Frederik Deweerdt   2008-04-24  1731  		r = next_free_minor(&minor);
2b06cfff1 Alasdair G Kergon   2006-06-26  1732  	else
cf13ab8e0 Frederik Deweerdt   2008-04-24  1733  		r = specific_minor(minor);
^1da177e4 Linus Torvalds      2005-04-16  1734  	if (r < 0)
6ed7ade89 Milan Broz          2008-02-08  1735  		goto bad_minor;
^1da177e4 Linus Torvalds      2005-04-16  1736  
83d5e5b0a Mikulas Patocka     2013-07-10  1737  	r = init_srcu_struct(&md->io_barrier);
83d5e5b0a Mikulas Patocka     2013-07-10  1738  	if (r < 0)
83d5e5b0a Mikulas Patocka     2013-07-10  1739  		goto bad_io_barrier;
83d5e5b0a Mikulas Patocka     2013-07-10  1740  
115485e83 Mike Snitzer        2016-02-22  1741  	md->numa_node_id = numa_node_id;
4cc96131a Mike Snitzer        2016-05-12  1742  	md->use_blk_mq = dm_use_blk_mq_default();
591ddcfc4 Mike Snitzer        2016-01-31  1743  	md->init_tio_pdu = false;
a5664dad7 Mike Snitzer        2010-08-12  1744  	md->type = DM_TYPE_NONE;
e61290a4a Daniel Walker       2008-02-08  1745  	mutex_init(&md->suspend_lock);
a5664dad7 Mike Snitzer        2010-08-12  1746  	mutex_init(&md->type_lock);
86f1152b1 Benjamin Marzinski  2014-08-13  1747  	mutex_init(&md->table_devices_lock);
022c26110 Mikulas Patocka     2009-04-02  1748  	spin_lock_init(&md->deferred_lock);
^1da177e4 Linus Torvalds      2005-04-16  1749  	atomic_set(&md->holders, 1);
5c6bd75d0 Alasdair G Kergon   2006-06-26  1750  	atomic_set(&md->open_count, 0);
^1da177e4 Linus Torvalds      2005-04-16  1751  	atomic_set(&md->event_nr, 0);
7a8c3d3b9 Mike Anderson       2007-10-19  1752  	atomic_set(&md->uevent_seq, 0);
7a8c3d3b9 Mike Anderson       2007-10-19  1753  	INIT_LIST_HEAD(&md->uevent_list);
86f1152b1 Benjamin Marzinski  2014-08-13  1754  	INIT_LIST_HEAD(&md->table_devices);
7a8c3d3b9 Mike Anderson       2007-10-19  1755  	spin_lock_init(&md->uevent_lock);
^1da177e4 Linus Torvalds      2005-04-16  1756  
115485e83 Mike Snitzer        2016-02-22  1757  	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id);
^1da177e4 Linus Torvalds      2005-04-16  1758  	if (!md->queue)
0f20972f7 Mike Snitzer        2015-04-28  1759  		goto bad;
^1da177e4 Linus Torvalds      2005-04-16  1760  
4a0b4ddf2 Mike Snitzer        2010-08-12  1761  	dm_init_md_queue(md);
9faf400f7 Stefan Bader        2006-10-03  1762  
115485e83 Mike Snitzer        2016-02-22  1763  	md->disk = alloc_disk_node(1, numa_node_id);
^1da177e4 Linus Torvalds      2005-04-16  1764  	if (!md->disk)
0f20972f7 Mike Snitzer        2015-04-28  1765  		goto bad;
^1da177e4 Linus Torvalds      2005-04-16  1766  
316d315bf Nikanth Karthikesan 2009-10-06  1767  	atomic_set(&md->pending[0], 0);
316d315bf Nikanth Karthikesan 2009-10-06  1768  	atomic_set(&md->pending[1], 0);
f0b041153 Jeff Mahoney        2006-06-26  1769  	init_waitqueue_head(&md->wait);
53d5914f2 Mikulas Patocka     2009-04-02  1770  	INIT_WORK(&md->work, dm_wq_work);
f0b041153 Jeff Mahoney        2006-06-26  1771  	init_waitqueue_head(&md->eventq);
2995fa78e Mikulas Patocka     2014-01-13  1772  	init_completion(&md->kobj_holder.completion);
2eb6e1e3a Keith Busch         2014-10-17  1773  	md->kworker_task = NULL;
f0b041153 Jeff Mahoney        2006-06-26  1774  
^1da177e4 Linus Torvalds      2005-04-16  1775  	md->disk->major = _major;
^1da177e4 Linus Torvalds      2005-04-16  1776  	md->disk->first_minor = minor;
^1da177e4 Linus Torvalds      2005-04-16  1777  	md->disk->fops = &dm_blk_dops;
^1da177e4 Linus Torvalds      2005-04-16  1778  	md->disk->queue = md->queue;
^1da177e4 Linus Torvalds      2005-04-16  1779  	md->disk->private_data = md;
^1da177e4 Linus Torvalds      2005-04-16  1780  	sprintf(md->disk->disk_name, "dm-%d", minor);
f26c5719b Dan Williams        2017-04-12  1781  
74f22ed6b Dan Williams        2017-08-01  1782  	if (IS_ENABLED(CONFIG_DAX)) {
f26c5719b Dan Williams        2017-04-12 @1783  		dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
f26c5719b Dan Williams        2017-04-12  1784  		if (!dax_dev)
f26c5719b Dan Williams        2017-04-12  1785  			goto bad;
74f22ed6b Dan Williams        2017-08-01  1786  	}
f26c5719b Dan Williams        2017-04-12  1787  	md->dax_dev = dax_dev;
f26c5719b Dan Williams        2017-04-12  1788  
^1da177e4 Linus Torvalds      2005-04-16  1789  	add_disk(md->disk);
7e51f257e Mike Anderson       2006-03-27  1790  	format_dev_t(md->name, MKDEV(_major, minor));
^1da177e4 Linus Torvalds      2005-04-16  1791  
670368a8d Tejun Heo           2013-07-30  1792  	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
304f3f6a5 Milan Broz          2008-02-08  1793  	if (!md->wq)
0f20972f7 Mike Snitzer        2015-04-28  1794  		goto bad;
304f3f6a5 Milan Broz          2008-02-08  1795  
32a926da5 Mikulas Patocka     2009-06-22  1796  	md->bdev = bdget_disk(md->disk, 0);
32a926da5 Mikulas Patocka     2009-06-22  1797  	if (!md->bdev)
0f20972f7 Mike Snitzer        2015-04-28  1798  		goto bad;
32a926da5 Mikulas Patocka     2009-06-22  1799  
3a83f4677 Ming Lei            2016-11-22  1800  	bio_init(&md->flush_bio, NULL, 0);
6a8736d10 Tejun Heo           2010-09-08  1801  	md->flush_bio.bi_bdev = md->bdev;
ff0361b34 Jan Kara            2017-05-31  1802  	md->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
6a8736d10 Tejun Heo           2010-09-08  1803  
fd2ed4d25 Mikulas Patocka     2013-08-16  1804  	dm_stats_init(&md->stats);
fd2ed4d25 Mikulas Patocka     2013-08-16  1805  
ba61fdd17 Jeff Mahoney        2006-06-26  1806  	/* Populate the mapping, nobody knows we exist yet */
f32c10b09 Jeff Mahoney        2006-06-26  1807  	spin_lock(&_minor_lock);
ba61fdd17 Jeff Mahoney        2006-06-26  1808  	old_md = idr_replace(&_minor_idr, md, minor);
f32c10b09 Jeff Mahoney        2006-06-26  1809  	spin_unlock(&_minor_lock);
ba61fdd17 Jeff Mahoney        2006-06-26  1810  
ba61fdd17 Jeff Mahoney        2006-06-26  1811  	BUG_ON(old_md != MINOR_ALLOCED);
ba61fdd17 Jeff Mahoney        2006-06-26  1812  
^1da177e4 Linus Torvalds      2005-04-16  1813  	return md;
^1da177e4 Linus Torvalds      2005-04-16  1814  
0f20972f7 Mike Snitzer        2015-04-28  1815  bad:
0f20972f7 Mike Snitzer        2015-04-28  1816  	cleanup_mapped_device(md);
83d5e5b0a Mikulas Patocka     2013-07-10  1817  bad_io_barrier:
^1da177e4 Linus Torvalds      2005-04-16  1818  	free_minor(minor);
6ed7ade89 Milan Broz          2008-02-08  1819  bad_minor:
10da4f795 Jeff Mahoney        2006-06-26  1820  	module_put(THIS_MODULE);
6ed7ade89 Milan Broz          2008-02-08  1821  bad_module_get:
^1da177e4 Linus Torvalds      2005-04-16  1822  	kfree(md);
^1da177e4 Linus Torvalds      2005-04-16  1823  	return NULL;
^1da177e4 Linus Torvalds      2005-04-16  1824  }
^1da177e4 Linus Torvalds      2005-04-16  1825  

:::::: The code at line 1684 was first introduced by commit
:::::: f26c5719b2d7b00de69eb83eb1c1c831759fdc9b dm: add dax_device and dax_operations support

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Dan Williams <dan.j.williams@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--cNdxnHkX5QqsyA0e
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--cNdxnHkX5QqsyA0e--
