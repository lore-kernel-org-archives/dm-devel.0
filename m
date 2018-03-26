From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm raid: fix parse_raid_params() variable
	range issue
Date: Mon, 26 Mar 2018 14:16:51 -0400
Message-ID: <20180326181651.GA22251@redhat.com>
References: <6386b9f02b3513bd0ba5ddccd437502313448f7d.1521738866.git.heinzm@redhat.com>
	<20180322194144.GA32294@redhat.com>
	<ac064103-c40b-544a-ef33-e0eaba9a8070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <ac064103-c40b-544a-ef33-e0eaba9a8070@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 22 2018 at  5:13pm -0400,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> On 03/22/2018 08:41 PM, Mike Snitzer wrote:
> >On Thu, Mar 22 2018 at  1:21pm -0400,
> >Heinz Mauelshagen <heinzm@redhat.com> wrote:
> >
> >>This v2 addresses Mikulas' point about the variable range and folds in
> >>"[PATCH] dm raid: use __within_range() more in parse_raid_params()":
> >>
> >>parse_raid_parames() compared variable "int value" with
> >>INT_MAX to prevent overflow of mddev variables set.
> >>
> >>Change type to "long long value".
> >Can you elaborate on the risk/issue that is being fixed here?
> =

> Fix addresses a coverity finding supporting the full,
> positive range of the "struct mddev" int members
> set here.=A0 I.e. the "int" cast is compared with INT_MAX.

Can you cut and paste the relevant portions of the coverity report?


> >>Whilst on it, use __within_range() throughout and
> >>add a sync min/max rate check.
> >>
> >>Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> >>---
> >>  drivers/md/dm-raid.c | 16 +++++++++++-----
> >>  1 file changed, 11 insertions(+), 5 deletions(-)
> >>
> >>diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >>index c1d1034ff7b7..c0e3d2aa9346 100644
> >>--- a/drivers/md/dm-raid.c
> >>+++ b/drivers/md/dm-raid.c
> >>@@ -1141,7 +1141,7 @@ static int validate_raid_redundancy(struct raid_s=
et *rs)
> >>  static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *=
as,
> >>  			     unsigned int num_raid_params)
> >>  {
> >>-	int value, raid10_format =3D ALGORITHM_RAID10_DEFAULT;
> >>+	long long value, raid10_format =3D ALGORITHM_RAID10_DEFAULT;
> >>  	unsigned int raid10_copies =3D 2;
> >>  	unsigned int i, write_mostly =3D 0;
> >>  	unsigned int region_size =3D 0;
> >>@@ -1153,7 +1153,7 @@ static int parse_raid_params(struct raid_set *rs,=
 struct dm_arg_set *as,
> >>  	arg =3D dm_shift_arg(as);
> >>  	num_raid_params--; /* Account for chunk_size argument */
> >>-	if (kstrtoint(arg, 10, &value) < 0) {
> >>+	if (kstrtoll(arg, 10, &value) < 0) {
> >>  		rs->ti->error =3D "Bad numerical argument given for chunk_size";
> >>  		return -EINVAL;
> >>  	}
> >>@@ -1315,7 +1315,7 @@ static int parse_raid_params(struct raid_set *rs,=
 struct dm_arg_set *as,
> >>  		/*
> >>  		 * Parameters with number values from here on.
> >>  		 */
> >>-		if (kstrtoint(arg, 10, &value) < 0) {
> >>+		if (kstrtoll(arg, 10, &value) < 0) {
> >>  			rs->ti->error =3D "Bad numerical argument given in raid params";
> >>  			return -EINVAL;
> >>  		}
> >>@@ -1430,7 +1430,7 @@ static int parse_raid_params(struct raid_set *rs,=
 struct dm_arg_set *as,
> >>  				rs->ti->error =3D "Only one min_recovery_rate argument pair allow=
ed";
> >>  				return -EINVAL;
> >>  			}
> >>-			if (value > INT_MAX) {
> >>+			if (!__within_range(value, 0, INT_MAX)) {
> >>  				rs->ti->error =3D "min_recovery_rate out of range";
> >>  				return -EINVAL;
> >>  			}
> >>@@ -1440,7 +1440,7 @@ static int parse_raid_params(struct raid_set *rs,=
 struct dm_arg_set *as,
> >>  				rs->ti->error =3D "Only one max_recovery_rate argument pair allow=
ed";
> >>  				return -EINVAL;
> >>  			}
> >>-			if (value > INT_MAX) {
> >>+			if (!__within_range(value, 0, INT_MAX)) {
> >>  				rs->ti->error =3D "max_recovery_rate out of range";
> >>  				return -EINVAL;
> >>  			}
> >>@@ -1472,6 +1472,12 @@ static int parse_raid_params(struct raid_set *rs=
, struct dm_arg_set *as,
> >>  		}
> >>  	}
> >>+	if (rs->md.sync_speed_max &&
> >>+	    rs->md.sync_speed_max < rs->md.sync_speed_min) {
> >>+		rs->ti->error =3D "sync speed max smaller than min";
> >>+		return -EINVAL;
> >>+	}
> >>+
> >>  	if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags) &&
> >>  	    test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags)) {
> >>  		rs->ti->error =3D "sync and nosync are mutually exclusive";
> >>-- =

> >>2.14.3
> >>
> >Isn't this last hunk unrelated?
> =

> No, once using __within_range to ensure positive values
> for sync min/max, this hunk ensures that those are sane
> if both are set.

OK, but pretty much unrelated.  I'll leave it foled in but at least
mention it in the header.

Mike
