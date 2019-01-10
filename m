From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: Fix parsing of extended IV arguments.
Date: Thu, 10 Jan 2019 14:18:25 -0500
Message-ID: <20190110191825.GA936@redhat.com>
References: <20190109105714.3606-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190109105714.3606-1-gmazyland@gmail.com>
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On Wed, Jan 09 2019 at  5:57am -0500,
Milan Broz <gmazyland@gmail.com> wrote:

> The dm-crypt cipher specification in a mapping table is defined as
>   cipher[:keycount]-chainmode-ivmode[:ivopts] or with the new crypt API format
>   capi:cipher_api_spec-ivmode[:ivopts].
> 
> For ESSIV, the parameter includes hash specification, for example aes-cbc-essiv:sha256.
> 
> The implementation expected that additional IV option never includes another dash '-' character
> 
> Unfortunately, with SHA3, we have now names like sha3-256, so the mapping table parser fails:
> 
> dmsetup create test --table "0 8 crypt aes-cbc-essiv:sha3-256 9c1185a5c5e9fc54612808977ee8f5b9e 0 /dev/sdb 0"
>   or (new format)
> dmsetup create test --table "0 8 crypt capi:cbc(aes)-essiv:sha3-256 9c1185a5c5e9fc54612808977ee8f5b9e 0 /dev/sdb 0"
> 
>   device-mapper: crypt: Ignoring unexpected additional cipher options
>   device-mapper: table: 253:0: crypt: Error creating IV
>   device-mapper: ioctl: error adding target to table
> 
> This patch fixes the dm-crypt constructor to ignore additional dash in IV options and also removes
> bogus warning (that is ignored anyway).
> 
> [This patch should go into stable tree as well.]

Rather than this it'd be useful to just be more explicit, e.g.:

Fixes: XXXXXXXX ("commit subject")
Cc: stable@vger.kernel.org # > 4.x?

Once I know which commit exposed us to this problem I can take care of
getting this fix staged for 5.0-rcX inclussion.

Thanks,
Mike
