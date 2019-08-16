From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v12 0/4] crypto: switch to crypto API for
	ESSIV generation
Date: Fri, 16 Aug 2019 11:18:42 +0300
Message-ID: <CAKv+Gu9CtMMAjtjfR=uuB-+x0Lhy8gnme2HhExckW+eVZ8B_Ow@mail.gmail.com>
References: <20190815192858.28125-1-ard.biesheuvel@linaro.org>
	<1463bca3-77dc-42be-7624-e8eaf5cfbf32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1463bca3-77dc-42be-7624-e8eaf5cfbf32@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Eric Biggers <ebiggers@google.com>, linux-fscrypt@vger.kernel.org, Gilad Ben-Yossef <gilad@benyossef.com>, device-mapper development <dm-devel@redhat.com>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>
List-Id: dm-devel.ids

On Fri, 16 Aug 2019 at 10:29, Milan Broz <gmazyland@gmail.com> wrote:
>
> Hi Ard,
>
> On 15/08/2019 21:28, Ard Biesheuvel wrote:
> > Changes since v10:
> > - Drop patches against fscrypt and dm-crypt - these will be routed via the
> >   respective maintainer trees during the next cycle
>
> I tested the previous dm-crypt patches (I also try to keep them in my kernel.org tree),
> it works and looks fine to me (and I like the final cleanup :)
>
> Once all maintainers are happy with the current state, I think it should go to
> the next release (5.4; IMO both ESSIV API and dm-crypt changes).
> Maybe you could keep sending dm-crypt patches in the end of the series (to help testing it)?
>

OK. But we'll need to coordinate a bit so that the first patch (the
one that introduces the template) is available in both branches,
otherwise ESSIV will be broken in the dm branch until it hits another
branch (-next or mainline) that also contains cryptodev.

As I suggested before, I can easily create a branch based on v5.3-rc1
containing just the first ESSIV patch (once Herbert is happy with it),
and merge that both into cryptodev and dm. That way, both will
continue to work without having too much overlap. Since adding a
template/file that has no users yet is highly unlikely to break
anything, it doesn't even matter which branch gets pulled first.

Any idea about the status of the EBOIV patch?
