From: Milan Broz <mbroz@redhat.com>
Subject: Re: 2.6.23-mm1
Date: Mon, 15 Oct 2007 00:03:27 +0200
Message-ID: <4712922F.6010005@redhat.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>	<4710B7C5.5050403@garzik.org>	<64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>	<64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>	<64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>	<47110500.8050503@garzik.org>	<64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>	<20071013111853.7e67c6c3.akpm@linux-foundation.org>	<64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com>	<20071014113914.7654759d.akpm@linux-foundation.org>	<64bb37e0710141212k58c5fc66s620d1f28e80bb40@mail.gmail.com>
	<20071014122613.5bbe4fc3.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071014122613.5bbe4fc3.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, Torsten Kaiser <just.for.lkml@googlemail.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Andrew Morton wrote:
> On Sun, 14 Oct 2007 21:12:08 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
...
>> 354036 Page allocated via order 0, mask 0x11202
>>             1 (PFN/Block always differ) PFN 3072 Block 6 type 0          Flags
>> 354338 [0xffffffff80266373] mempool_alloc+83
>> 354338 [0xffffffff80266373] mempool_alloc+83
>> 354025 [0xffffffff802bb389] bio_alloc_bioset+185
>> 354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
>> 354052 [0xffffffff804d2cc7] kcryptd_do_crypt+391
>> 354058 [0xffffffff804d2b40] kcryptd_do_crypt+0
>> 354052 [0xffffffff80245d3c] run_workqueue+204
>> 354062 [0xffffffff802467b0] worker_thread+0
>>
>> I'm using dm-crypt with CONFIG_CRYPTO_TWOFISH_X86_64
>>
>>> The other info shows a tremendous memory leak, not via slab.  Looks like
>>> someone is running alloc_pages() directly and isnb't giving them back.
>> Blaming it on dm-crypt looks right, as the leak seems to happens, if
>> there is (heavy) disk activity.
>> (updatedb just ate ~500 Mb)
>>
> 
> Yup, it does appear that dm-crypt is leaking.  Let's add some cc's.

More precisely - change below from git-block.patch update
caused that pages are not deallocated at all.
(cc-ing Jens)

-static int crypt_endio(struct bio *clone, unsigned int done, int error)
+static void crypt_endio(struct bio *clone, int error)
...
-	 * free the processed pages, even if
-	 * it's only a partially completed write
+	 * free the processed pages
 	 */
-	if (!read_io)
-		crypt_free_buffer_pages(cc, clone, done);
-
-	/* keep going - not finished yet */
-	if (unlikely(clone->bi_size))
-		return 1;
-
-	if (!read_io)
+	if (!read_io) {
+		crypt_free_buffer_pages(cc, clone, clone->bi_size);
 		goto out;
+	}

clone->bi_size is zero here now, so crypt_free_buffer_pages will not
work correctly (previously there was count of processed bytes).

But because it seems that bio cannot be processed partially now, we can
simplify crypt_free_buffer_pages to always remove all allocated pages.

Milan
--
mbroz@redhat.com
