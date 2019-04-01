From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH v3 13/17] multipathd: handle changed wwids by
 removal and addition
Date: Mon, 01 Apr 2019 15:31:36 +0200
Message-ID: <b2395066ce3c6f286d43f714902a52f3415aad69.camel@suse.de>
References: <1553925966-20958-1-git-send-email-bmarzins@redhat.com>
	<1553925966-20958-14-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1553925966-20958-14-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, 2019-03-30 at 01:06 -0500, Benjamin Marzinski wrote:
> If a path's WWID changes, it's not necessarily failed. But it
> certainly
> has to be removed from an existing map, otherwise data corruption is
> imminent. Instead of keeping the path in the map, failing it, and
> remembering the "changed WWID" state, this patch simply removes and
> re-adds the path.
> 
> This is patch is heavily based on the previous patch of the same name
> by Martin Wilck.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---

Reviewed-by: Martin Wilck <mwilck@suse.com>
