From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] dm raid: fix compat_features validation
Date: Tue, 11 Oct 2016 13:44:22 -0400
Message-ID: <20161011174421.GA25738@redhat.com>
References: <20161011142835.11620-1-apw@canonical.com>
	<1c517f14-1234-7844-fc6a-cd1b9698fb8b@redhat.com>
	<20161011153808.nmyf6hafjaadcemw@brain>
	<591b9d8d-2036-2d0f-14f2-af176b5beaea@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <591b9d8d-2036-2d0f-14f2-af176b5beaea@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Andy Whitcroft <apw@canonical.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 11 2016 at 11:44am -0400,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> 
> 
> On 10/11/2016 05:38 PM, Andy Whitcroft wrote:
> >On Tue, Oct 11, 2016 at 05:04:34PM +0200, Heinz Mauelshagen wrote:
> >>Andy,
> >>
> >>good catch.
> >>
> >>We should rather check for  V190 support only in case any
> >>compat feature flags are actually set.
> >>
> >>{
> >>+       if (le32_to_cpu(sb->compat_features) &&
> >>+           le32_to_cpu(sb->compat_features) != FEATURE_FLAG_SUPPORTS_V190)
> >>{
> >>                 rs->ti->error = "Unable to assemble array: Unknown flag(s)
> >>in compatible feature flags";
> >>                 return -EINVAL;
> >>         }
> >If the feature flags are single bit combinations then I believe the
> >below does check exactly that.  Checking for no 1s outside of the
> >expected features, caring not for the value of the valid bits:
> >
> >+     if (le32_to_cpu(sb->compat_features) & ~(FEATURE_FLAG_SUPPORTS_V190)) {
> >
> >with the possibilty to or in additional feature bits as they are added.
> 
> Thanks,
> I prefer this to be easier readable.

Readable or not, the code with the != is _not_ future-proof.  Whereas
Andy's solution is.  If/when a new compat feature comes along then
FEATURE_FLAG_SUPPORTS_V190 would be replaced to be a macro that ORs all
the new compat features together (e.g. FEATURE_FLAG_COMPAT).  E.g. how
dm-thin-metadata.c:__check_incompat_features() does.

We can go with the != code for now, since any future changes would
likely cause this test to be changed.  Or we could fix it now _for
real_.

Mike
