From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 1/1] dm raid: fix compat_features validation
Date: Tue, 11 Oct 2016 16:38:08 +0100
Message-ID: <20161011153808.nmyf6hafjaadcemw@brain>
References: <20161011142835.11620-1-apw@canonical.com>
	<1c517f14-1234-7844-fc6a-cd1b9698fb8b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1c517f14-1234-7844-fc6a-cd1b9698fb8b@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 11, 2016 at 05:04:34PM +0200, Heinz Mauelshagen wrote:
> 
> Andy,
> 
> good catch.
> 
> We should rather check for  V190 support only in case any
> compat feature flags are actually set.
> 
> {
> +       if (le32_to_cpu(sb->compat_features) &&
> +           le32_to_cpu(sb->compat_features) != FEATURE_FLAG_SUPPORTS_V190)
> {
>                 rs->ti->error = "Unable to assemble array: Unknown flag(s)
> in compatible feature flags";
>                 return -EINVAL;
>         }

If the feature flags are single bit combinations then I believe the
below does check exactly that.  Checking for no 1s outside of the
expected features, caring not for the value of the valid bits:

+     if (le32_to_cpu(sb->compat_features) & ~(FEATURE_FLAG_SUPPORTS_V190)) {

with the possibilty to or in additional feature bits as they are added.

-apw
