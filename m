From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2 v2] dm mpath: allow table load with 0
	priority groups
Date: Thu, 10 Feb 2011 16:13:14 -0500
Message-ID: <20110210211313.GA13083@redhat.com>
References: <1296490458-12910-2-git-send-email-snitzer@redhat.com>
	<1297371970-13313-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1297371970-13313-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 10 2011 at  4:06pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> If an mpath device is held open when all paths in the last priority
> group have failed userspace multipathd will attempt to reload the
> associated DM table to reflect that the device no longer has any
> priority groups.  But the reload attempt always failed because the
> multipath target did not allow 0 priority groups.
> 
> Adjust multipath target to allow a table with both 0 priority groups
> and 0 for the initial priority group number.
> 
> All multipath target messages related to priority group (enable_group,
> disable_group, switch_group) will properly handle a priority group of
> 0 (will cause error).
> 
> When reloading a multipath table with 0 priority groups, userspace
> multipathd must be updated to specify an initial priority group number
> of 0 (rather than 1).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Acked-by: Babu Moger <babu.moger@lsi.com>

Forgot Hannes':

Acked-by: Hannes Reinecke <hare@suse.de>
