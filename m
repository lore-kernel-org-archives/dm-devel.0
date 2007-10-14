From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: 2.6.23-mm1
Date: Sun, 14 Oct 2007 21:40:34 +0200
Message-ID: <64bb37e0710141240u2db3aa14u6f2e07c66e429e39@mail.gmail.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	 <64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>
	 <64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
	 <47110500.8050503@garzik.org>
	 <64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
	 <20071013111853.7e67c6c3.akpm@linux-foundation.org>
	 <64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com>
	 <20071014113914.7654759d.akpm@linux-foundation.org>
	 <64bb37e0710141212k58c5fc66s620d1f28e80bb40@mail.gmail.com>
	 <20071014122613.5bbe4fc3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760528AbXJNTkr@vger.kernel.org>
In-Reply-To: <20071014122613.5bbe4fc3.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 14 Oct 2007 21:12:08 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> > The first column is the times I found this line in page_owner.
>
> err, take another look at the changelog in
> page-owner-tracking-leak-detector.patch.  It directs you to
> Documentation/page_owner.c which aggregates the contents of
> /proc/page_owner.

Noting the -v on the grep command, now I understand that this program
does in fact what I need.
Not reading this correctly I assumed it collects information only
about the PFN lines.

> > I divided the counts for the duplicate lines (mempool_alloc+83 and
> > kcryptd_do_crypt+0) by two, so normalize them. There still are some
> > false positive counts in there, so it does not match the 354042
> > precisely.
> >
> > 354036 Page allocated via order 0, mask 0x11202
> >             1 (PFN/Block always differ) PFN 3072 Block 6 type 0          Flags
> > 354338 [0xffffffff80266373] mempool_alloc+83
> > 354338 [0xffffffff80266373] mempool_alloc+83
> > 354025 [0xffffffff802bb389] bio_alloc_bioset+185
> > 354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
> > 354052 [0xffffffff804d2cc7] kcryptd_do_crypt+391
> > 354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
> > 354052 [0xffffffff80245d3c] run_workqueue+204
> > 354062 [0xffffffff802467b0] worker_thread+0
> >
> > I'm using dm-crypt with CONFIG_CRYPTO_TWOFISH_X86_64
> >
> > > The other info shows a tremendous memory leak, not via slab.  Looks like
> > > someone is running alloc_pages() directly and isnb't giving them back.
> >
> > Blaming it on dm-crypt looks right, as the leak seems to happens, if
> > there is (heavy) disk activity.
> > (updatedb just ate ~500 Mb)
> >
>
> Yup, it does appear that dm-crypt is leaking.  Let's add some cc's.

Top3 from the page_owner-util:

353978 times:
Page allocated via order 0, mask 0x11202
[0xffffffff80266373] mempool_alloc+83
[0xffffffff80266373] mempool_alloc+83
[0xffffffff802bb389] bio_alloc_bioset+185
[0xffffffff804d2b40] kcryptd_do_crypt+0
[0xffffffff804d2cc7] kcryptd_do_crypt+391
[0xffffffff804d2b40] kcryptd_do_crypt+0
[0xffffffff80245d3c] run_workqueue+204
[0xffffffff802467b0] worker_thread+0

45065 times:
Page allocated via order 0, mask 0x1201d2
[0xffffffff805ae2c2] __down_read+18
[0xffffffff8026c246] __do_page_cache_readahead+230
[0xffffffff8026c576] ondemand_readahead+278
[0xffffffff80264185] do_generic_mapping_read+629
[0xffffffff802635f0] file_read_actor+0
[0xffffffff80265bbe] generic_file_aio_read+254
[0xffffffff8037a98b] xfs_read+347
[0xffffffff8036b793] xfs_access+67

33008 times:
Page allocated via order 0, mask 0x1201d2
[0xffffffff8026c246] __do_page_cache_readahead+230
[0xffffffff8026c576] ondemand_readahead+278
[0xffffffff8026404e] do_generic_mapping_read+318
[0xffffffff802635f0] file_read_actor+0
[0xffffffff80265bbe] generic_file_aio_read+254
[0xffffffff8037a98b] xfs_read+347
[0xffffffff8036b793] xfs_access+67
[0xffffffff80292569] do_sync_read+217


> Thanks for testing -mm and for reporting this.

:-)

Torsten
