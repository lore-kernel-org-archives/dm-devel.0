From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-mm1
Date: Sun, 14 Oct 2007 12:26:13 -0700
Message-ID: <20071014122613.5bbe4fc3.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<4710B7C5.5050403@garzik.org>
	<64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>
	<64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>
	<64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
	<47110500.8050503@garzik.org>
	<64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
	<20071013111853.7e67c6c3.akpm@linux-foundation.org>
	<64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com>
	<20071014113914.7654759d.akpm@linux-foundation.org>
	<64bb37e0710141212k58c5fc66s620d1f28e80bb40@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <64bb37e0710141212k58c5fc66s620d1f28e80bb40@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: dm-devel@redhat.com, Alasdair@redhat.com, linux-kernel@vger.kernel.org, Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, 14 Oct 2007 21:12:08 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> On 10/14/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sun, 14 Oct 2007 13:54:26 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> >
> > > > The page-owner code can pinpoint a leak source.  See
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/broken-out/page-owner-tracking-leak-detector.patch
> > > >
> > > > Enable CONFIG_DEBUG_SLAB_LEAK, check out /proc/slab_allocators
> > >
> > > Did that. The output of /proc/page_owner is ~350Mb, gzipped still ~7Mb.
> > >
> > > Taking only the first line from each stackdump it shows the following counts:
> > >
> > > ...
> > >
> > >  354042 [0xffffffff80266373] mempool_alloc+83
> >
> > This one is suspicious.  Can you find the whole record for it?
> 
> I still have all 354042 records of it. ;)
> The first column is the times I found this line in page_owner.

err, take another look at the changelog in
page-owner-tracking-leak-detector.patch.  It directs you to
Documentation/page_owner.c which aggregates the contents of
/proc/page_owner.

> I divided the counts for the duplicate lines (mempool_alloc+83 and
> kcryptd_do_crypt+0) by two, so normalize them. There still are some
> false positive counts in there, so it does not match the 354042
> precisely.
> 
> 354036 Page allocated via order 0, mask 0x11202
>             1 (PFN/Block always differ) PFN 3072 Block 6 type 0          Flags
> 354338 [0xffffffff80266373] mempool_alloc+83
> 354338 [0xffffffff80266373] mempool_alloc+83
> 354025 [0xffffffff802bb389] bio_alloc_bioset+185
> 354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
> 354052 [0xffffffff804d2cc7] kcryptd_do_crypt+391
> 354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
> 354052 [0xffffffff80245d3c] run_workqueue+204
> 354062 [0xffffffff802467b0] worker_thread+0
> 
> I'm using dm-crypt with CONFIG_CRYPTO_TWOFISH_X86_64
> 
> > The other info shows a tremendous memory leak, not via slab.  Looks like
> > someone is running alloc_pages() directly and isnb't giving them back.
> 
> Blaming it on dm-crypt looks right, as the leak seems to happens, if
> there is (heavy) disk activity.
> (updatedb just ate ~500 Mb)
> 

Yup, it does appear that dm-crypt is leaking.  Let's add some cc's.

Thanks for testing -mm and for reporting this.
