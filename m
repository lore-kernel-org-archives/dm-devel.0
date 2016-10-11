From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/1] dm raid: fix compat_features validation
Date: Tue, 11 Oct 2016 17:04:34 +0200
Message-ID: <1c517f14-1234-7844-fc6a-cd1b9698fb8b@redhat.com>
References: <20161011142835.11620-1-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161011142835.11620-1-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>
List-Id: dm-devel.ids


Andy,

good catch.

We should rather check for  V190 support only in case any
compat feature flags are actually set.

I.e.:

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8abde6b..2a39700 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2258,7 +2258,8 @@ static int super_validate(struct raid_set *rs, 
struct md_rdev *rdev)
         if (!mddev->events && super_init_validation(rs, rdev))
                 return -EINVAL;

-       if (le32_to_cpu(sb->compat_features) != 
FEATURE_FLAG_SUPPORTS_V190) {
+       if (le32_to_cpu(sb->compat_features) &&
+           le32_to_cpu(sb->compat_features) != 
FEATURE_FLAG_SUPPORTS_V190) {
                 rs->ti->error = "Unable to assemble array: Unknown 
flag(s) in compatible feature flags";
                 return -EINVAL;
         }

On 10/11/2016 04:28 PM, Andy Whitcroft wrote:
> In commit ecbfb9f118bce4 ("dm raid: add raid level takeover support") a new
> compatible feature flag was added.  Validation for these compat_features
> was added but this only passes for new raid mappings with this feature
> flag.  This causes previously created raid mappings to be failed at import.
>
> Check compat_features for any valid combinations.
>
> Fixes: ecbfb9f118bce4 ("dm raid: add raid level takeover support")
> BugLink: http://bugs.launchpad.net/bugs/1631298
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>   drivers/md/dm-raid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> It very much looks like these are intended to be optional extended feature
> flags.  That we should be accepting any valid flag and rejecting any bit
> not in that set.  We should however not be ensuring that specific bits
> are actually set.  Certainly as things stand raid sets built on previous
> kernel versions cannot be assembled.
>
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 8abde6b..6ddea60 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -2258,7 +2258,7 @@ static int super_validate(struct raid_set *rs, struct md_rdev *rdev)
>   	if (!mddev->events && super_init_validation(rs, rdev))
>   		return -EINVAL;
>   
> -	if (le32_to_cpu(sb->compat_features) != FEATURE_FLAG_SUPPORTS_V190) {
> +	if (le32_to_cpu(sb->compat_features) & ~(FEATURE_FLAG_SUPPORTS_V190)) {
>   		rs->ti->error = "Unable to assemble array: Unknown flag(s) in compatible feature flags";
>   		return -EINVAL;
>   	}
