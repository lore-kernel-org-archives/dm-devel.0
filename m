From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/1] update to v2 Fix false removes
Date: Tue, 11 Dec 2018 17:47:48 -0600
Message-ID: <20181211234748.GB11315@octiron.msp.redhat.com>
References: <1544563384-9721-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1544563384-9721-1-git-send-email-bmarzins@redhat.com>
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

On Tue, Dec 11, 2018 at 03:23:03PM -0600, Benjamin Marzinski wrote:
> I accidentally didn't include Christophe in my
> 
> [PATCH v2 0/1] Fix false removes

Clearly, something is wrong with my git send-mail setup, since you got
ignored again.  Sorry. I'll figure out what's going on.

-Ben
 
> patchset, so v1 of "libmultipath: fix false removes in dmevents polling   
> code" went in.  This commit just patches the code to my v2 version.
> Sorry for the confusion. I've included Martin's Reviewed-by as the end
> result is the same as what he reviewed, and no intervening commits have
> touched libmultipath/devmapper.c or multipathd/dmevents.c
> 
> Benjamin Marzinski (1):
>   libmultipath: dm_is_mpath cleanup
> 
>  libmultipath/devmapper.c | 21 ++++++++++++---------
>  multipathd/dmevents.c    |  4 +++-
>  2 files changed, 15 insertions(+), 10 deletions(-)
> 
> -- 
> 2.7.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
