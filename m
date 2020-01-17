From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 13/15] libmultipath: add new checker class
	functions
Date: Fri, 17 Jan 2020 18:41:15 +0100
Message-ID: <8b09d1ef0d4d4bf264e5e88f6ab51ebe84b0176d.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-14-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-14-git-send-email-bmarzins@redhat.com>
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

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> This commit adds the optional functions libcheck_load,
> libcheck_unload,
> and libcheck_reset. libcheck_load is called when a checker is first
> loaded, libcheck_unload is called when it is unloaded, and
> libcheck_reset is called during reconfigure, after all the current
> paths have been removed. They are designed to setup, reset, and
> destroy
> global state that all checkers of this class use. They will be used
> in future commits.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/checkers.c | 29 ++++++++++++++++++++++++++++-
>  libmultipath/checkers.h |  1 +
>  multipathd/main.c       |  1 +
>  3 files changed, 30 insertions(+), 1 deletion(-)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>
