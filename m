From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 00/80] multipath-tools series part VI:
 incomplete udev initialization
Date: Wed, 19 Aug 2020 15:30:22 +0200
Message-ID: <b15c04a46217267e9a929d82f9a0c8b45aae1cd5.camel@suse.com>
References: <20200819131747.13400-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200819131747.13400-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 2020-08-19 at 15:17 +0200, mwilck@suse.com wrote:
> 
> Changes v2 -> v3, as suggested by Ben Marzinski:
> 
>  * 76/80 "libmultipath: select_action(): force udev reload for
> uninitialized
>    maps"
>    - moved configure.c changes from 77/80 to this patch, where it
> belongs
>  * 77/80 "libmultipath: log dm_task_run() errors"
>    - moved some hunks to 76/80, see above

Note that these patches carry an Reviewed-by: from Ben from v1 already.

Except for Ben's suggestion to force reload only if active paths are
available, the hunks have indeed only been moved between the two
patches. This is necessary because otherwise 76/80 won't compile.

Martin
