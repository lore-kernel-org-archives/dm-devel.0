From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] multipath-tools: Makefile: Respect standard
 toolchain related envvars
Date: Tue, 12 Dec 2017 16:30:00 +0000
Message-ID: <1513096198.2999.4.camel@wdc.com>
References: <20171129232311.95483-1-whissi@gentoo.org>
	<1513092491.3704.2.camel@wdc.com>
	<b6780fff-ecc4-2b7a-bfcb-51bbf6b654a1@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b6780fff-ecc4-2b7a-bfcb-51bbf6b654a1@gentoo.org>
Content-Language: en-US
Content-ID: <E1A475EF09BCEE47944A3E0FBEB98F72@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "whissi@gentoo.org" <whissi@gentoo.org>
List-Id: dm-devel.ids

On Tue, 2017-12-12 at 17:09 +0100, Thomas Deutschmann wrote:
> On 2017-12-12 16:28, Bart Van Assche wrote:
> > I agree that we need a way to specify additional compilation flags. However, is
> > OPTFLAGS really a standard? Aren't most developers used to set CFLAGS to specify
> > additional compilation flags?
> 
> When I created the patch I searched in the source code of other projects
> after "OPTFLAGS" usage and came to the conclusion that this isn't a
> standard.
> 
> However, my patch shouldn't break any existing use cases.
> 
> So my understanding was that "OPTFLAGS" is used like the default set of
> flags in case the user hasn't set any flags on its own. However, the
> project may still need to add a special flag which should be set everywhere.
> 
> That's why I created the patch the way I did:
> 
> 1) User can provide own CFLAGS in which case the default set of flags
> (OPTFLAGS) aren't used.
> 
> 2) We now extend set CFLAGS by adding our additional flags (-DRUN_DIR..)
> we want to be set everywhere.
> 
> Your patch will do the same but require downstream to unset/negate
> default flags. I don't really care if we pick your patch or my patch.

Hello Thomas,

I'm fine with dropping my patch and proceeding with your patch. However, I think
that any CFLAGS specified on the make command line or in the environment should
be appended at the end of the CFLAGS/OPTFLAGS specified by the Makefile. Otherwise
it's not possible to override e.g. the -W... flags specified in the Makefile from
the command line.

Thanks,

Bart.
