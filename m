From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath -f/-F exit status
Date: Sat, 13 Dec 2008 12:59:37 +0100
Message-ID: <20081213125937.2ddc34d6@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bmr@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

> Hi Folks,
> 
> Older versions of multipath-tools would always exit with status 0
> (success) when flushing multipath device maps (-f/-F). This was never
> guaranteed but happened because the "r" local in multipath/main.c was
> used uninitialised in these code paths (by chance, it always lands on
> a freshly zeroed stack page, so although undefined the behaviour was
> pretty reliable).
> 
> This was changed by commit 8497928514aa3df6d46f24d8d9b70b086e9fcfbd:
>
Then by a9a6c71592d4e2271a38c3d334bee7cbce963cff.

Does the upstream version works as you expect in this regard ?
 
> multipath -F
> ------------
> 
> -F     flush all unused multipath device maps
> 
> Exit status
>        0 At least one unused multipath device map was flushed
>        1 No unused maps were found or no maps could be flushed
> 
> The alternative for -F seems to be to return 0 if all unused maps were
> flushed and 1 if there were unused maps that could not be flushed.
> This doesn't seem like a very likely occurrence, but maybe it should
> be handled separately?
> 
I guess the current implementation return r as the number failures.

Regards,
cvaroqui
