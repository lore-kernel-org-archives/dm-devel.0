From: Eric Wheeler <bcache@lists.ewheeler.net>
Subject: Re: super-block written got dislocation while 64K PAGE_SIZE
 enable.
Date: Wed, 1 Jun 2016 11:05:20 -0700 (PDT)
Message-ID: <alpine.LRH.2.11.1606011057370.9562@mail.ewheeler.net>
References: <CAOOPZo6+dtw9VWHnMhR8LEeFxEdNGOMthCw-PqRNmnLP2eAq1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <CAOOPZo6+dtw9VWHnMhR8LEeFxEdNGOMthCw-PqRNmnLP2eAq1g@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Cc: linux-bcache@vger.kernel.org, kent.overstreet@gmail.com, dm-devel@redhat.com, huhai@kylinos.cn
List-Id: dm-devel.ids

On Wed, 1 Jun 2016, Zhengyuan Liu wrote:

> Hi, I have created a mapped block device (bcach0) using make-bcache on
> ARM64 server which has kernel enable 64K page size. However, the
> bcach0 disappeared after the server reboot and there is no or dirty
> metadata on super block of both cache device and back device . The
> output of command  bcache-super-show was as bellow showed:
>    [root@master Linux-4.4-LTS-storage]# bcache-super-show  /dev/sdb
>    sb.magic bad magic
>    Invalid superblock (bad magic)
> /dev/sdb was the backing device and cache device got bad magic too.
> 
> I tried to traced the written process of super block in bcache source
> code and found that is the issue of PAGE_SIZE. It seems that the
> bcache  was designed only considering for 4K PAGE_SIZE and it works
> right only on 4K PAGE_SIZE exactly. To make bcache work correctly on
> 64K PAGE_SIZE, I committed a patch as bellow showd:
>     diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>     index 330cd6e..ef567cd 100644
>     --- a/drivers/md/bcache/super.c
>     +++ b/drivers/md/bcache/super.c
>     @@ -224,6 +224,12 @@ static void __write_super(struct cache_sb
> *sb, struct bio     *bio
>         bio->bi_iter.bi_size    = SB_SIZE;
>         bch_bio_map(bio, NULL);
> 
>     +#ifdef CONFIG_ARM64_64K_PAGES
>     +       out = (struct cache_sb *)((char *)out + (SB_SECTOR<<9));
>     +       pr_debug("sb_page_adress %x, sb_address %x,page_size
>           %d\n",page_address(bio
>     +       bio->bi_io_vec[0].bv_offset = (SB_SECTOR<<9);
>     +#endif
> 
>         out->offset             = cpu_to_le64(sb->offset);
>         out->version            = cpu_to_le64(sb->version);
> 
> Does it not recommend to use bcache on 64K PAGE_SIZE? or it only
> considers for 4K PAGE_SIZE for bcache currently?
> Maybe it is more suitable  for me to redefine some macro such as
> SB_SECTOR, BDEV_DATA_START_DEFAULT to make bcache work correctly on
> both 64K PAGE_SIZE and 4K PAGE_SIZE.

I think a patch to support arbitrary page size would be great.  Can 
you write the macros in terms of PAGE_SIZE or PAGE_SHIFT?  

(Out of curiosity, what ARM64 hardware are you using?)

Kent, this may affect bcachefs too.  Can you think of any other places 
that might have PAGE_SIZE!=4k issues?

-Eric


--
Eric Wheeler



> --
> To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
