From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] libmultipath: fix memory API logic error
Date: Mon, 15 Aug 2016 14:11:12 +0200
Message-ID: <ee311fa6-305e-f3a9-b4c2-a81b31bdd732@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "tang.junhui " <tang.junhui@zte.com.cn>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

tang.junhui wrote:

> Memroy API use mem_allocated to record the total size of used memory,
> however, it's wrong to use size(p) as the length of freed memory in xfree(),
> and memory may also be allocated by STRDUP() or REALLOC(), which is
> not calculated into mem_allocated, so the total size of used memory is
> not correctly. For these reasons, we removed these incorrectly code to keep
> the code clean.

>  libmpathpersist/mpath_updatepr.c |  1 -
>  libmultipath/memory.c            | 31 -------------------------------
>  libmultipath/memory.h            | 13 ++-----------

libmultipath/memory.[ch] files along with libmultipath/parser.[ch] and
libmultipath/vector.[ch] come from keepalived/lib/ [1] .

Maybe it's worth to backport their fixes and new features.


[1] https://github.com/acassen/keepalived
