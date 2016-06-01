From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Subject: super-block written got dislocation while 64K PAGE_SIZE enable.
Date: Wed, 1 Jun 2016 16:20:47 +0800
Message-ID: <CAOOPZo6+dtw9VWHnMhR8LEeFxEdNGOMthCw-PqRNmnLP2eAq1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, kent.overstreet@gmail.com, dm-devel@redhat.com
Cc: huhai@kylinos.cn
List-Id: dm-devel.ids

Hi, I have created a mapped block device (bcach0) using make-bcache on
ARM64 server which has kernel enable 64K page size. However, the
bcach0 disappeared after the server reboot and there is no or dirty
metadata on super block of both cache device and back device . The
output of command  bcache-super-show was as bellow showed:
   [root@master Linux-4.4-LTS-storage]# bcache-super-show  /dev/sdb
   sb.magic bad magic
   Invalid superblock (bad magic)
/dev/sdb was the backing device and cache device got bad magic too.

I tried to traced the written process of super block in bcache source
code and found that is the issue of PAGE_SIZE. It seems that the
bcache  was designed only considering for 4K PAGE_SIZE and it works
right only on 4K PAGE_SIZE exactly. To make bcache work correctly on
64K PAGE_SIZE, I committed a patch as bellow showd:
    diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
    index 330cd6e..ef567cd 100644
    --- a/drivers/md/bcache/super.c
    +++ b/drivers/md/bcache/super.c
    @@ -224,6 +224,12 @@ static void __write_super(struct cache_sb
*sb, struct bio     *bio
        bio->bi_iter.bi_size    = SB_SIZE;
        bch_bio_map(bio, NULL);

    +#ifdef CONFIG_ARM64_64K_PAGES
    +       out = (struct cache_sb *)((char *)out + (SB_SECTOR<<9));
    +       pr_debug("sb_page_adress %x, sb_address %x,page_size
          %d\n",page_address(bio
    +       bio->bi_io_vec[0].bv_offset = (SB_SECTOR<<9);
    +#endif

        out->offset             = cpu_to_le64(sb->offset);
        out->version            = cpu_to_le64(sb->version);

Does it not recommend to use bcache on 64K PAGE_SIZE? or it only
considers for 4K PAGE_SIZE for bcache currently?
Maybe it is more suitable  for me to redefine some macro such as
SB_SECTOR, BDEV_DATA_START_DEFAULT to make bcache work correctly on
both 64K PAGE_SIZE and 4K PAGE_SIZE.
