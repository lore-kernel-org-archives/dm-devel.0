From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v4 0/6] crypto: switch to crypto API for
	ESSIV generation
Date: Mon, 24 Jun 2019 08:52:11 +0200
Message-ID: <5ebd992b-cb01-6dcc-f571-55afbb05c03b@gmail.com>
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
	<CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
	<20190623101241.6cr4sbxyviigu3sz@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190623101241.6cr4sbxyviigu3sz@gondor.apana.org.au>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

On 23/06/2019 12:12, Herbert Xu wrote:
> On Sun, Jun 23, 2019 at 11:30:41AM +0200, Ard Biesheuvel wrote:
>>
>> So with that in mind, I think we should decouple the multi-sector
>> discussion and leave it for a followup series, preferably proposed by
>> someone who also has access to some hardware to prototype it on.
> 
> Yes that makes sense.

Yes.

And TBH, the most important optimization for dm-crypt in this case
is processing 8 512-bytes sectors in 4k encryption block (because page
cache will generate page-sized bios) and with XTS mode and linear IV (plain64),
not ESSIV.

Dm-crypt can use 4k sectors directly, there are only two
blockers - you need LUKS2 to support it, and many devices
just do not advertise physical 4k sectors (many SSDs).
So switching to 4k could cause some problems with partial 4k writes
(after a crash or power-fail).

The plan for the dm-crypt side is more to focus on using 4k native
sectors than this micro-optimization in HW.

Milan
