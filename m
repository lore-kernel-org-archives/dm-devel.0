From: Ed Cashin <ecashin@coraid.com>
Subject: Re: [PATCH 04/22] block: Abstract out bvec iterator
Date: Fri, 9 Aug 2013 16:16:01 -0400
Message-ID: <FEE91CF1-7CDE-45E5-B7BA-DA8522E7DFFE@coraid.com>
References: <1375912471-5106-1-git-send-email-kmo@daterainc.com> <1375912471-5106-5-git-send-email-kmo@daterainc.com> <2D8F228B-65AE-4046-A910-6B354AF0058E@coraid.com> <20130809000943.GC15409@kmo-pixel> <F14F555B-1B1C-4E73-8AF8-DE57D77C610D@coraid.com> <20130809010530.GG15409@kmo-pixel>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130809010530.GG15409@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "neilb@suse.de" <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

On Aug 8, 2013, at 9:05 PM, Kent Overstreet wrote:
...
> It's in the for-jens branch now.


Just examining the patches, I like the way it cleans up the aoe code.  I had a question about a new BUG added by the for-jens branch the read-response handling path of the aoe driver.

It looks like if a misbehaving AoE target has a bad (too high compared to the request) sector count, but sends a packet large enough for that sector count to seem legit in ktiocomplete, then the patched bvcpy will BUG.  An example would be the case where 1024 bytes was requested but a (bad but possible) AoE read response comes back with 4096 bytes in a jumbo frame.  Here's an excerpt from ktiocomplete:

     n = ahout->scnt << 9;
     switch (ahout->cmdstat) {
     case ATA_CMD_PIO_READ:
     case ATA_CMD_PIO_READ_EXT:
          if (skb->len < n) {
               pr_err("%s e%ld.%d.  skb->len=%d need=%ld\n",
                    "aoe: runt data size in read from",
                    (long) d->aoemajor, d->aoeminor,
                      skb->len, n);
               clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
               break;
          }
          bvcpy(skb, f->buf->bio, f->iter, n);

... and earlier in linux-bcache/for-jens aoecmd.c there's bvcpy ...

static void
bvcpy(struct sk_buff *skb, struct bio *bio, struct bvec_iter iter, long cnt)
{
     int soff = 0;
     struct bio_vec bv;

     BUG_ON(cnt > iter.bi_size);

It seems like it would be better to treat that case as another indication of a problem with the target that gets logged when the AoE response is ignored, just as happens for "runt data size".  That way people working on or trying out experimental AoE targets don't panic the initiator system.

-- 
  Ed Cashin
  ecashin@coraid.com
