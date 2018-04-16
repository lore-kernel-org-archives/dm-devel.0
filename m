From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 22/22] multipath.rules: find_multipaths
	"smart" logic
Date: Mon, 16 Apr 2018 08:40:47 +0200
Message-ID: <20180416084047.58fd6796@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-23-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-23-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, 14 Apr 2018 00:00:15 +0200
Martin Wilck <mwilck@suse.com> wrote:

> When the first path to a device appears, we don't know if more paths
> are going to follow. find_multipath "smart" logic attempts to solve
> this dilemma by waiting for additional paths for a configurable time
> before giving up and releasing single paths to upper layers.
> 
> These rules apply only if both find_multipaths is set to "smart" in
> multipath.conf. In this mode, multipath -u sets
> DM_MULTIPATH_DEVICE_PATH=2 if there's no clear evidence wheteher a
> given device should be a multipath member (not blacklisted, not
> listed as "failed", not in WWIDs file, not member of an existing map,
> only one path seen yet). In this case, "multipath -u" also sets the
> variable FIND_MULTIPATHS_WAIT_UNIL to a relative time stamp (we need
> to use relative "monotonic" time stamps because this may be triggered
> early during boot, before system "calendar" time is correctly
> initialized).
> 
> In the DM_MULTIPATH_DEVICE_PATH=2 case, pretend that the path is
> multipath member, disallow further processing by systemd (allowing
> multipathd some time to grab the path), and set a systemd timer to
> check again after the given timeout. If the path is still not
> multipathed by then, pass it on to systemd for further processing.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipath/multipath.rules | 61
> ++++++++++++++++++++++++++++++++++++++++++++--- 1 file changed, 58
> insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
