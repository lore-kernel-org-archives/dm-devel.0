From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 04/16] libmultipath: add wrapper function
 around pgpolicyfn
Date: Wed, 14 Aug 2019 21:39:27 +0000
Message-ID: <944d12858b6fc3660150d03f07ad1126132acaa3.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-5-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <CF9D8E04AA9C164697DFF14C5AF56C68@namprd18.prod.outlook.com>
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
> group_paths() is a wrapper around the pgpolicy functions, that pulls
> out
> the common code from the beginning and the end. However since
> one_group() didn't free the mp->paths vector, it has to set it to
> NULL,
> to avoid having the wrapper code do that. Also, the pathgroups in
> group_by_prio are now needlessly sorted afterwards.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

(Suggestion: squash this with 07/16, and possibly also 05/16 and
06/16).
