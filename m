From: Thomas Deutschmann <whissi@gentoo.org>
Subject: Re: [PATCH] multipath-tools: Makefile: Respect standard
 toolchain related envvars
Date: Fri, 12 Jan 2018 16:46:52 +0100
Message-ID: <f1e426e3-9d78-e08d-1e1c-ea1c4277d264@gentoo.org>
References: <20171129232311.95483-1-whissi@gentoo.org>
	<1515709465.18410.6.camel@suse.com>
	<bb9b8db3-5a40-99f6-258b-1d0b81a25da7@gentoo.org>
	<1515751362.3409.3.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1515751362.3409.3.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Hi,

On 2018-01-12 11:02, Martin Wilck wrote:
> make OPTFLAGS="-g -O3 -fsanitize=address"

Thanks, this works for me.

OK, I am now pulling my patch suggestion. No longer required.

Regarding Bart's patch: Still not sure how important things like

  -D_FORTIFY_SOURCE=2 $(STACKPROT) --param=ssp-buffer-size=4

are. We (Gentoo) will now probably set

  make OPTFLAGS="${CFLAGS}"

so we will lose this per default. Bart's patch would preserve these
defaults...


-- 
Regards,
Thomas Deutschmann / Gentoo Linux Developer
C4DD 695F A713 8F24 2AA1 5638 5849 7EE5 1D5D 74A5
