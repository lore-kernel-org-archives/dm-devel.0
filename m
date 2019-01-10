From: Milan Broz <gmazyland@gmail.com>
Subject: Re: dm-crypt: Fix parsing of extended IV arguments.
Date: Thu, 10 Jan 2019 20:50:46 +0100
Message-ID: <43e7c378-b87e-03d9-ceb7-348ba84c71e1@gmail.com>
References: <20190109105714.3606-1-gmazyland@gmail.com>
	<20190110191825.GA936@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190110191825.GA936@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com
List-Id: dm-devel.ids

On 10/01/2019 20:18, Mike Snitzer wrote:
> On Wed, Jan 09 2019 at  5:57am -0500,
> Milan Broz <gmazyland@gmail.com> wrote:

>> This patch fixes the dm-crypt constructor to ignore additional dash in IV options and also removes
>> bogus warning (that is ignored anyway).
>>
>> [This patch should go into stable tree as well.]
> 
> Rather than this it'd be useful to just be more explicit, e.g.:

There is no single reference commit.

The new capi: was introduced in
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/md/dm-crypt.c?id=33d2f09fcb357fd1861c4959d1d3505492bf91f8

but I think the second part applies even to older kernel, but not sure it makes sense to fix it there (I guess not)...

So perhaps the best is to apply it to stable kernel >= 4.12

Milan
