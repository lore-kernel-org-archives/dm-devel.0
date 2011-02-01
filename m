From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] dm mpath: allow table load with 0
 priority groups
Date: Tue, 01 Feb 2011 16:40:30 +0100
Message-ID: <4D48296E.2070205@suse.de>
References: <1296490458-12910-1-git-send-email-snitzer@redhat.com>
	<1296490458-12910-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1296490458-12910-2-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 01/31/2011 05:14 PM, Mike Snitzer wrote:
> If an mpath device is held open when all paths in the last priority
> group have failed userspace multipathd will attempt to reload the
> associated DM table to reflect that the device no longer has any
> priority groups.  But the reload attempt always failed because the
> multipath target did not allow 0 priority groups.
> =

> Adjust multipath target to allow a table with both 0 priority groups
> and 0 for the initial priority group number.
> =

> All multipath target messages related to priority group (enable_group,
> disable_group, switch_group) will properly handle a priority group of
> 0 (will cause error).
> =

> When reloading a multipath table with 0 priority groups, userspace
> multipathd must be updated to specify an initial priority group number
> of 0 (rather than 1).
> =

I actually send a similar patch way back, but Alasdair refused to
take it as he still had to mull them over.

And, as mentioned in my other mail, to properly support maps with no
paths there are quite a few changes required in multipath-tools itself.

But other than that: Congrats. One patchset less in my queue.

> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Babu Moger <babu.moger@lsi.com>
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
