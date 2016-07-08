From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 0/4] multipath-tools: Ceph rbd support
Date: Fri, 8 Jul 2016 10:46:19 -0500
Message-ID: <ac72c03f-1428-ed9a-ffdc-9586f2a155fa@redhat.com>
References: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
	<CABr-Gnc34cJ9oRB4J=0Rv1jgZ_Cr=uvMHwHAy_49XHGuBy33XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-Gnc34cJ9oRB4J=0Rv1jgZ_Cr=uvMHwHAy_49XHGuBy33XQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/08/2016 03:15 AM, Christophe Varoqui wrote:
> Hi Mike,
> 
> this patchset was broken by the resync with hannes rcu v2 branch.
> Can you rebase it in the light of the changes to the conf pointer access
> applied in dbd9ad6f0e555707335ec71e1c5bec1723e02f79 ?
> 

Yeah, no problem.


> Thanks.
> 
> On Tue, Jul 5, 2016 at 10:12 AM, Mike Christie <mchristi@redhat.com
> <mailto:mchristi@redhat.com>> wrote:
> 
>     The following patches add Ceph rbd support for handling
>     blacklisted devices. This does not support features like
>     multibus.
> 
>     My specific use is for exporting rbd images through multiple
>     LIO instances. In this case, we have one rbd instance that
>     has the exclusive lock and send WRITE requests. If that host
>     becomes unreachable, then another host will grab the lock,
>     and blacklist the original host to prevent it from sending stale
>     IO (when blacklisted IO will be failed by the OSD).
> 
>     To recover from this, this patchset adds a repair() callout
>     to the checker. If the path is in the PATH_DOWN state this
>     callout can be used to fix it up. For my case, I am remapping
>     the device to flush stale IO and cleanup the old lock,
>     and then unblacklisting myself.
> 
> 
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
