From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [BUG] BLKZEROOUT on dm-crypt container cause OOM / kernel panic
Date: Thu, 10 Aug 2017 07:27:16 +0800
Message-ID: <CAGnHSEnrD4LkMGLAuehe4yEeyWk9305TFrrdJcPFv7gyqyuGNQ@mail.gmail.com>
References: <CAGnHSEngW1Ugf66V5henR9fMEev0xcJnKVY9MjJb19gy3CkgNA@mail.gmail.com>
 <20170809133833.GA25681@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809133833.GA25681@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, "axboe@fb.com" <axboe@fb.com>, axboe@kernel.dk, linux-block@vger.kernel.org, okozina@redhat.com
List-Id: dm-devel.ids

I haven't really tested but I was aware of the commit before I send my
last email. It doesn't seem relevant to be honest, because it doesn't
change the fact that the inner loop wil only end if the whole request
has been looped over. So still one big bio.

There are a few things that seem suspicious to me. First of all, the
inner loop has an if-break at its end that seem to practically do
nothing, especially in terms of making the inner loop end when the bio
reach its expected size (BIO_MAX_PAGES?).

bi_size = bio_add_page(bio, ZERO_PAGE(0), sz, 0);

If you take a look at bio_add_page():
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/block/bio.c?h=v4.13-rc4#n820

it will basically always return "len", which is "sz" here, unchanged.

if (bi_size < sz)
break;

So this pretty much never happens, with two exceptions:

if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
return 0;

which is most likely irrelevant in this case,

if (bio->bi_vcnt >= bio->bi_max_vecs)
return 0;

which seem to matter in this case. However:

if (page == bv->bv_page &&
offset == bv->bv_offset + bv->bv_len) {
bv->bv_len += len;
goto done;
}
...
if (bio->bi_vcnt >= bio->bi_max_vecs)
return 0;
...
bio->bi_vcnt++;
done:
bio->bi_iter.bi_size += len;
return len;

So if the first condition in the above quote is matched, the exception
would never happen either.

On 9 August 2017 at 21:38, hch@lst.de <hch@lst.de> wrote:
> Does commit 615d22a51c04856efe62af6e1d5b450aaf5cc2c0
> "block: Fix __blkdev_issue_zeroout loop" fix the issue for you?
