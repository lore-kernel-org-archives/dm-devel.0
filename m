From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 1/6] checker: remove useless name check in
 checker_get func
Date: Mon, 17 Aug 2020 17:25:16 +0200
Message-ID: <708dd1bae5ec1c7c2b477a1b3f6f2b05318399dd.camel@suse.com>
References: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
	<2d9db95b-bb88-0d22-1c2d-df459415ee3d@huawei.com>
	<71d49c03470fbb70cc37f757e4804380566fba12.camel@suse.com>
	<dd79ea15-f7fd-81a9-8e3d-4840f2d94422@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <dd79ea15-f7fd-81a9-8e3d-4840f2d94422@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, bmarzins@redhat.com, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids

On Mon, 2020-08-17 at 23:12 +0800, Zhiqiang Liu wrote:
> On 2020/8/17 16:05, Martin Wilck wrote:
> > On Sun, 2020-08-16 at 09:42 +0800, Zhiqiang Liu wrote:
> > > In checker_get func, input name will be checked before
> > > calling checker_class_lookup func, in which name will
> > > also be checked.
> > > 
> > > Here, we just remove useless input name check in checker_get
> > > func.
> > > 
> > > Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > > Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> > > ---
> > >  libmultipath/checkers.c | 9 ++++-----
> > >  1 file changed, 4 insertions(+), 5 deletions(-)
> > 
> > Nack. Better safe than sorry. If you look at the generated
> > assembly,
> > you'll see that the compiler optimizes this double check away, so
> > doesn't inflict runtime overhead, while it makes it easier to
> > verify
> > the code.
> > 
> > I'd ack this if we had a solid convention in the multipath-tools
> > code
> > to check parameters always (only) in the callee. But so far we
> > don't.
> > I guess if we want to do that, we'd first need to agree on and
> > implement a common convention for return values, too.
> > 
> I agree with you.
> The location of the parameter check is not uniform.
> Are we dealing with it now? or add it in your TODO list?

We don't have an official todo list. I tend to handle such "style"
things incrementally - when I touch some code for some non-trivial
reason, I also add "style" changes as appropriate (look at "constify"
changes in recent multipath-tools commits, for example).

I believe that most functions in multipath-tools already check the
passed arguments (in the callee), and I believe that this is where it
should be done. Let's have an eye on this for some time to come.
Eventually we can audit the entire code to make sure all functions do
this properly, and once that's done, we can start removing the
respective checks in callers, at least some.

Does that make sense?

Cheers,
Martin






> 
> 
> > If checker_class_lookup() was non-static and/or the code was
> > executed
> > very often, things would also look different to me. But both is not
> > the
> > case.
> > 
> 
> 
> > Regards,
> > Martin
> > 
> > 
> > 
> > > diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> > > index f7ddd53..ac41d64 100644
> > > --- a/libmultipath/checkers.c
> > > +++ b/libmultipath/checkers.c
> > > @@ -361,11 +361,10 @@ void checker_get(const char *multipath_dir,
> > > struct checker *dst,
> > >  	if (!dst)
> > >  		return;
> > > 
> > > -	if (name && strlen(name)) {
> > > -		src = checker_class_lookup(name);
> > > -		if (!src)
> > > -			src = add_checker_class(multipath_dir, name);
> > > -	}
> > > +	src = checker_class_lookup(name);
> > > +	if (!src)
> > > +		src = add_checker_class(multipath_dir, name);
> > > +
> > >  	dst->cls = src;
> > >  	if (!src)
> > >  		return;
> > 
> > .
> > 
