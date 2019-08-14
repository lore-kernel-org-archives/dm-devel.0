From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 08/16] libmultipath: consolidate group_by_*
	functions
Date: Wed, 14 Aug 2019 21:40:52 +0000
Message-ID: <650838594337c447eff0a136ecccc67efd29e71d.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-9-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-9-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <6BA1B38FFFFC1C45B7C8BBC4EF299931@namprd18.prod.outlook.com>
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
> group_by_node_name() and group_by_serial() are exactly the same
> except
> for how the paths are compared. group_by_prio() is different but its
> pathvec solves the same issue as the bitmap from the other two
> functions, and since we are always running sort_pathgroups() after
> calling pgpriorityfn, there is no need to sort the pathgroups in
> group_by_prio(). This means that all three functions can be replaced
> with one function, group_by_match() that takes a match function as an
> argument.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
