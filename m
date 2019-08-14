From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 05/16] libmultipath: fix double free in
 pgpolicyfn error paths
Date: Wed, 14 Aug 2019 21:21:18 +0000
Message-ID: <aec80dc201ee2db91cc8316529cabba4082690bd.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-6-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-6-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <881CB4E977944742B58FA2F89EAACC94@namprd18.prod.outlook.com>
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
> In the pgpolicy functions, if an error is encountered after
> alloc_pathgroup() is called, but before the path group is added to a
> multipath device with add_pathgroup(), the pathgroup needs to be
> cleaned
> up by calling free_pathgroup(). However, after the pathgroup has been
> added to the multipath device, calling free_pgvec() will clean it up.
> In
> this case, if free_pathgroup() is called first, the recently added
> pathgroup will be freed twice.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/pgpolicies.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

This is correct, but the code remains quite horrible. One day I'd love
to see "pgp" being a local variable inside the loop. That can be done
after your series though.

Martin
