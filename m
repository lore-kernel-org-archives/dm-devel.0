From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 1/4] mpathpersist: remove broken/unused code
Date: Fri, 13 Sep 2019 07:37:31 +0000
Message-ID: <689575ae61b252c9233e65df1382bf3a7673fdae.camel@suse.com>
References: <1568155161-9343-1-git-send-email-bmarzins@redhat.com>
	<1568155161-9343-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1568155161-9343-2-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <A931A6F833013740AAD7CEDD31D089CE@namprd18.prod.outlook.com>
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

On Tue, 2019-09-10 at 17:39 -0500, Benjamin Marzinski wrote:
> The test for an empty pp->dev in updatepaths() dates back to when
> disassemble_map() didn't fill in pp->dev for newly added paths, and
> it
> was meant to catch paths that got added by disassemble_map().  With
> the
> mpathpersist speedup code, all paths get added by disassemble_map().
> However, disassemble_map() now calls devt2devname() to set pp->dev if
> possible.  This means that there is no point in calling
> devt2devname()
> again in updatepaths(). If for some reason it did return success, the
> current code would still fail, since it doesn't set pp->udev in this
> code path. The best thing to do if disassemble_map() couldn't set
> pp->dev is simply to fail the path.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmpathpersist/mpath_persist.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
