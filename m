From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 02/16] libmultipath: add marginal paths and
 groups infrastructure
Date: Wed, 14 Aug 2019 21:37:40 +0000
Message-ID: <2f3d72b3fe768050047e7ee60b5e4fe9dcfb253e.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-3-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <6A0C23FE1B2FFC44A302CBA8B8B36B6C@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-08-02 at 11:33 -0500, Benjamin Marzinski wrote:
> This commit adds a marginal variable ot the paths and pathgroups
> structs.
> The marginal paths variable can be set by
> 
> multipathd path <path> setmarginal
> 
> and cleared by
> 
> multipathd path <path> unsetmarginal
> 
> All of the marginal paths on a multipath device can be cleared by
> 
> multipathd map <map> unsetmarginal
> 
> Currently, the marginal variable of a pathgroup will not change. This
> will be added by a future commit. The marginal state of a path or
> pathgroup is printable with the %M wildcard, and is displayed in the
> json output.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

(I'd like different semantics for these commands, but that doesn't
affect this patch).
