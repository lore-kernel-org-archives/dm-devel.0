From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 04/22] multipath -u -i: respect entries in
	WWIDs file
Date: Mon, 16 Apr 2018 08:09:26 +0200
Message-ID: <20180416080926.6d8d42cc@pentland.suse.de>
References: <20180413220015.7032-1-mwilck@suse.com>
	<20180413220015.7032-5-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180413220015.7032-5-mwilck@suse.com>
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

On Fri, 13 Apr 2018 23:59:57 +0200
Martin Wilck <mwilck@suse.com> wrote:

> Previously, if find_multipaths was set, devices listed in the WWIDs
> file weren't classified as multipath members by "multipath -u -i"
> unless they also met the "find_multipaths" criteria (at least two
> paths, or existing map with this WWID). Now we classify all paths in
> the WWIDs file as multipath members, too.
> 
> The rationale for this patch is to match the logic that multipathd
> applies by default (i.e. without "-n").
> 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
