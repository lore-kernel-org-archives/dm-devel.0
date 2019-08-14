From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 10/16] libmultipath: make pgpolicyfn take a
	paths vector
Date: Wed, 14 Aug 2019 22:05:45 +0000
Message-ID: <1f9360e75494c4597d80a08677a34441159b3af4.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-11-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-11-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <85BB8C015C96F44EBF4DD52D514C5983@namprd18.prod.outlook.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

On Fri, 2019-08-02 at 11:33 -0500, Benjamin Marzinski wrote:
> To enable future changes, mp->pgpolicyfn() now takes a vector of
> paths instead of always using mp->paths.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/pgpolicies.c | 38 +++++++++++++++++++----------------
> ---
>  libmultipath/pgpolicies.h | 10 +++++-----
>  libmultipath/structs.h    |  2 +-
>  3 files changed, 25 insertions(+), 25 deletions(-)
> 

The following applies to this patch and its successors (11-13, 15).

This is technically correct, beautiful code, but I'm not sure if this
is where we want to go. Do we really need that strict separation
between "normal" and "marginal" path groups?

As I already noted in my reply to 14/16, I'd favor an approach where
we would factor in the "marginality" of a path when calculating the
priority and the grouping. For example, when working with ALUA and
group_by_prio, rather than lumping all marginal paths together, we may
want to group like this:

 - active/optimized, healthy
 - active/non-optimized, healthy
 - active/optimized, marginal
 - active/non-optimized, marginal
 - standby
 - other

The priorities of these groups would be up to discussion. Today I'm not
even sure if "marginal" property should take precedence over
"optimized" property, or vice-versa. It might actually depend on the
situation and the degree of "shakiness" ...

OK: This is future material. But if we take this patch and its
successors, be'd have it cast in stone that "marginal/normal" is the
main distinction, taking precedence over everything else, and I'm not
convinced that that's the way to go.

We could obtain the semantics of your current patch set by assigning a
negative prio bias to marginal paths, and changing the grouping
algorithms (except group_by_prio) such that they take the marginal
property into account (e.g. group_by_node_name would pretend that all
marginal paths have a common "node name" and lump them together). This
would allow us to keep our current simple mpp->pg vector and represent
the marginal paths simply by one (the last) PG in this vector. 

The benefit would be that this model would be more flexible for more
sophisticated priority models in the future.

Regards,
Martin
