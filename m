From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v12 0/4] crypto: switch to crypto API for
	ESSIV generation
Date: Fri, 16 Aug 2019 09:29:39 +0200
Message-ID: <1463bca3-77dc-42be-7624-e8eaf5cfbf32@gmail.com>
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
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
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-crypto@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com, linux-fscrypt@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

Hi Ard,

On 15/08/2019 21:28, Ard Biesheuvel wrote:
> Changes since v10:
> - Drop patches against fscrypt and dm-crypt - these will be routed via the
>   respective maintainer trees during the next cycle

I tested the previous dm-crypt patches (I also try to keep them in my kernel.org tree),
it works and looks fine to me (and I like the final cleanup :)

Once all maintainers are happy with the current state, I think it should go to
the next release (5.4; IMO both ESSIV API and dm-crypt changes).
Maybe you could keep sending dm-crypt patches in the end of the series (to help testing it)?

(Just for for now I am completely distracted by other urgent unrelated issues.)

Milan
