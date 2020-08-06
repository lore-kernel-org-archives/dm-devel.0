From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 3/6] libmultipath: remove code duplication in
 path counting
Date: Thu, 6 Aug 2020 10:48:12 +0000
Message-ID: <a8190af67d89edb0819b231417b349e56c3deff1.camel@suse.com>
References: <1595877868-5595-1-git-send-email-bmarzins@redhat.com>
	<1595877868-5595-4-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1595877868-5595-4-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <ECE4D8CCF58B2042902527C39C71B5C3@eurprd04.prod.outlook.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2020-07-27 at 14:24 -0500, Benjamin Marzinski wrote:
> pathcountgr() is never used except by pathcount(), and neither is the
> special case for PATH_WILD. Simplify this and make one function that
> is
> used by both pathcount() and count_active_paths(). This will be used
> again in a future patch.
> 
> Also use count_active_paths() in mpath_persist.

The patch looks correct. I had thought about something like it as well
when I first introduced count_active_paths(). But count_active_paths()
is used a *lot*, and often in critical situations. I wonder whether it
deserves an optimized version. The compiler can surely optimize better
with two constant expressions than with the additional for-loop over an
array with variable size. That's why back then I decided against
implementing it as a special case of a generic function. I actually
considered inlining count_active_paths().

It's hard to quantify the effect, and I haven't done any benchmarks. 
But still, can we perhaps keep the optimized version of
count_active_paths() itself?

Martin
