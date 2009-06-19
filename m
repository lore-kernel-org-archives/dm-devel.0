From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 2/6] dm raid45 target: introduce memory cache
Date: Fri, 19 Jun 2009 11:45:39 -0500
Message-ID: <E9C76B34-11CA-4533-8CEC-44A623C4AD77@redhat.com>
References: <4a368304.ChlIzzc+4MKVMZmr%heinzm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: multipart/mixed; boundary="===============2025293631=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4a368304.ChlIzzc+4MKVMZmr%heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============2025293631==
Content-Type: multipart/alternative; boundary=Apple-Mail-43-834767133


--Apple-Mail-43-834767133
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

This patch looks good to me.  Just a couple questions about object  
accounting...

  brassow

On Jun 15, 2009, at 12:21 PM, heinzm@redhat.com wrote:

> +int dm_mem_cache_grow(struct dm_mem_cache_client *cl, unsigned  
> objects)
> +{
> +	unsigned pages = objects * cl->chunks * cl->pages_per_chunk;
> +	struct page_list *pl, *last;
> +
> +	BUG_ON(!pages);
> +	pl = alloc_cache_pages(pages);
> +	if (!pl)
> +		return -ENOMEM;
> +
> +	last = pl;
> +	while (last->next)
> +		last = last->next;
> +
> +	spin_lock_irq(&cl->lock);
> +	last->next = cl->free_list;
> +	cl->free_list = pl;
> +	cl->free_pages += pages;
> +	cl->total_pages += pages;
> +	cl->objects++;

Should this be 'cl->objects += objects'?

> +	spin_unlock_irq(&cl->lock);
> +
> +	mempool_resize(cl->objs_pool, cl->objects, GFP_NOIO);

Do we need to check return value here?

> +	return 0;
> +}
> +EXPORT_SYMBOL(dm_mem_cache_grow);
> +
> +/* Shrink a clients cache by an amount of pages */
> +int dm_mem_cache_shrink(struct dm_mem_cache_client *cl, unsigned  
> objects)
> +{
> +	int r;
> +	unsigned pages = objects * cl->chunks * cl->pages_per_chunk, p =  
> pages;
> +	unsigned long flags;
> +	struct page_list *last = NULL, *pl, *pos;
> +
> +	BUG_ON(!pages);
> +
> +	spin_lock_irqsave(&cl->lock, flags);
> +	pl = pos = cl->free_list;
> +	while (p-- && pos->next) {
> +		last = pos;
> +		pos = pos->next;
> +	}
> +
> +	if (++p)
> +		r = -ENOMEM;
> +	else {
> +		r = 0;
> +		cl->free_list = pos;
> +		cl->free_pages -= pages;
> +		cl->total_pages -= pages;
> +		cl->objects--;

'cl->objects -= objects'?

> +		last->next = NULL;
> +	}
> +	spin_unlock_irqrestore(&cl->lock, flags);
> +
> +	if (!r) {
> +		free_cache_pages(pl);
> +		mempool_resize(cl->objs_pool, cl->objects, GFP_NOIO);

When shrinking, 'mempool_resize' will not fail... no need to check  
return value?

> +	}
> +
> +	return r;
> +}
> +EXPORT_SYMBOL(dm_mem_cache_shrink);
> +
> +/*
> + * Allocate/free a memory object
> + *
> + * Can be called from interrupt context
> + */
> +struct dm_mem_cache_object *dm_mem_cache_alloc(struct  
> dm_mem_cache_client *cl)
> +{
> +	int r = 0;
> +	unsigned pages = cl->chunks * cl->pages_per_chunk;
> +	unsigned long flags;
> +	struct dm_mem_cache_object *obj;
> +
> +	obj = mempool_alloc(cl->objs_pool, GFP_NOIO);
> +	if (!obj)
> +		return ERR_PTR(-ENOMEM);
> +
> +	spin_lock_irqsave(&cl->lock, flags);
> +	if (pages > cl->free_pages)
> +		r = -ENOMEM;
> +	else
> +		cl->free_pages -= pages;
> +	spin_unlock_irqrestore(&cl->lock, flags);

It's not important, but 'free_chunks' adjusts the 'cl->free_pages'  
count for us...  That made me look for where 'cl->free_pages' was  
adjusted in 'alloc_chunks', but that is done here.  Could we push this  
critical section into alloc_chunks and then just check the return code  
of that?

> +
> +	if (r) {
> +		mempool_free(obj, cl->objs_pool);
> +		return ERR_PTR(r);
> +	}
> +
> +	alloc_chunks(cl, obj);
> +	return obj;
> +}
> +EXPORT_SYMBOL(dm_mem_cache_alloc);
> +
> +void dm_mem_cache_free(struct dm_mem_cache_client *cl,
> +		       struct dm_mem_cache_object *obj)
> +{
> +	free_chunks(cl, obj);
> +	mempool_free(obj, cl->objs_pool);
> +}
> +EXPORT_SYMBOL(dm_mem_cache_free);
> +
> +MODULE_DESCRIPTION(DM_NAME " dm memory cache");
> +MODULE_AUTHOR("Heinz Mauelshagen <hjm@redhat.com>");
> +MODULE_LICENSE("GPL");



--Apple-Mail-43-834767133
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div>This patch looks good to =
me. &nbsp;Just a couple questions about object =
accounting...</div><div><br></div><div>&nbsp;brassow</div><br><div><div>On=
 Jun 15, 2009, at 12:21 PM, <a =
href=3D"mailto:heinzm@redhat.com">heinzm@redhat.com</a> wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: medium; font-style: =
normal; font-variant: normal; font-weight: normal; letter-spacing: =
normal; line-height: normal; orphans: 2; text-align: auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; ">+int dm_mem_cache_grow(struct =
dm_mem_cache_client *cl, unsigned objects)<br>+{<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>unsigned =
pages =3D objects * cl-&gt;chunks * cl-&gt;pages_per_chunk;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>struct =
page_list *pl, *last;<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>BUG_ON(!pages);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>pl =3D =
alloc_cache_pages(pages);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>if (!pl)<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>return =
-ENOMEM;<br>+<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span>last =3D pl;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>while (last-&gt;next)<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>last =3D =
last-&gt;next;<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	=
</span>spin_lock_irq(&amp;cl-&gt;lock);<br>+<span class=3D"Apple-tab-span"=
 style=3D"white-space: pre; ">	</span>last-&gt;next =3D =
cl-&gt;free_list;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:=
 pre; ">	</span>cl-&gt;free_list =3D pl;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>cl-&gt;free_pages +=3D pages;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>cl-&gt;total_pages +=3D =
pages;<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>cl-&gt;objects++;<br></span></blockquote><div><br></div><div>Should=
 this be 'cl-&gt;objects +=3D objects'?</div><br><blockquote =
type=3D"cite"><span class=3D"Apple-style-span" style=3D"border-collapse: =
separate; color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
medium; font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-align: =
auto; text-indent: 0px; text-transform: none; white-space: normal; =
widows: 2; word-spacing: 0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; ">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	=
</span>spin_unlock_irq(&amp;cl-&gt;lock);<br>+<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>mempool_resize(cl-&gt;objs_pool, cl-&gt;objects, =
GFP_NOIO);<br></span></blockquote><div><br></div><div>Do we need to =
check return value here?</div><br><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: medium; font-style: =
normal; font-variant: normal; font-weight: normal; letter-spacing: =
normal; line-height: normal; orphans: 2; text-align: auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; ">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>return =
0;<br>+}<br>+EXPORT_SYMBOL(dm_mem_cache_grow);<br>+<br>+/* Shrink a =
clients cache by an amount of pages */<br>+int =
dm_mem_cache_shrink(struct dm_mem_cache_client *cl, unsigned =
objects)<br>+{<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span>int r;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>unsigned pages =3D objects * =
cl-&gt;chunks * cl-&gt;pages_per_chunk, p =3D pages;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>unsigned =
long flags;<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span>struct page_list *last =3D NULL, *pl, =
*pos;<br>+<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>BUG_ON(!pages);<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	=
</span>spin_lock_irqsave(&amp;cl-&gt;lock, flags);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>pl =3D =
pos =3D cl-&gt;free_list;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>while (p-- &amp;&amp; =
pos-&gt;next) {<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span><span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>last =3D pos;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>pos =3D pos-&gt;next;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>}<br>+<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span>if (++p)<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>r =3D -ENOMEM;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>else =
{<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>r =3D 0;<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span><span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>cl-&gt;free_list =3D pos;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>cl-&gt;free_pages -=3D pages;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>cl-&gt;total_pages -=3D =
pages;<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>cl-&gt;objects--;<br></span></blockquote><div><br></div><div>'cl-&g=
t;objects -=3D objects'?</div><br><blockquote type=3D"cite"><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: medium; font-style: =
normal; font-variant: normal; font-weight: normal; letter-spacing: =
normal; line-height: normal; orphans: 2; text-align: auto; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; ">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>last-&gt;next =3D NULL;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>}<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>spin_unlock_irqrestore(&amp;cl-&gt;lock, =
flags);<br>+<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span>if (!r) {<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>free_cache_pages(pl);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>mempool_resize(cl-&gt;objs_pool, cl-&gt;objects, =
GFP_NOIO);<br></span></blockquote><div><br></div><div>When shrinking, =
'mempool_resize' will not fail... no need to check return =
value?</div><br><blockquote type=3D"cite"><span class=3D"Apple-style-span"=
 style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: medium; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; ">+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>}<br>+<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>return =
r;<br>+}<br>+EXPORT_SYMBOL(dm_mem_cache_shrink);<br>+<br>+/*<br>+ * =
Allocate/free a memory object<br>+ *<br>+ * Can be called from interrupt =
context<br>+ */<br>+struct dm_mem_cache_object =
*dm_mem_cache_alloc(struct dm_mem_cache_client *cl)<br>+{<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>int r =3D =
0;<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>unsigned pages =3D cl-&gt;chunks * =
cl-&gt;pages_per_chunk;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>unsigned long flags;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>struct =
dm_mem_cache_object *obj;<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>obj =3D =
mempool_alloc(cl-&gt;objs_pool, GFP_NOIO);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>if =
(!obj)<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>return ERR_PTR(-ENOMEM);<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	=
</span>spin_lock_irqsave(&amp;cl-&gt;lock, flags);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>if (pages =
&gt; cl-&gt;free_pages)<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>r =3D -ENOMEM;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>else<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span><span class=3D"Apple-tab-span" style=3D"white-space: pre; =
">	</span>cl-&gt;free_pages -=3D pages;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>spin_unlock_irqrestore(&amp;cl-&gt;lock, =
flags);<br></span></blockquote><div><br></div><div>It's not important, =
but 'free_chunks' adjusts the 'cl-&gt;free_pages' count for us... =
&nbsp;That made me look for where 'cl-&gt;free_pages' was adjusted in =
'alloc_chunks', but that is done here. &nbsp;Could we push this critical =
section into alloc_chunks and then just check the return code of =
that?</div><br><blockquote type=3D"cite"><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: medium; font-style: normal; font-variant: normal; =
font-weight: normal; letter-spacing: normal; line-height: normal; =
orphans: 2; text-align: auto; text-indent: 0px; text-transform: none; =
white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; ">+<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>if (r) =
{<br>+<span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>mempool_free(obj, cl-&gt;objs_pool);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>return =
ERR_PTR(r);<br>+<span class=3D"Apple-tab-span" style=3D"white-space: =
pre; ">	</span>}<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>alloc_chunks(cl, obj);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span>return =
obj;<br>+}<br>+EXPORT_SYMBOL(dm_mem_cache_alloc);<br>+<br>+void =
dm_mem_cache_free(struct dm_mem_cache_client *cl,<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	</span><span =
class=3D"Apple-converted-space">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;struct dm_mem_cache_object *obj)<br>+{<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space: pre; ">	=
</span>free_chunks(cl, obj);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space: pre; ">	</span>mempool_free(obj, =
cl-&gt;objs_pool);<br>+}<br>+EXPORT_SYMBOL(dm_mem_cache_free);<br>+<br>+MO=
DULE_DESCRIPTION(DM_NAME " dm memory cache");<br>+MODULE_AUTHOR("Heinz =
Mauelshagen &lt;<a =
href=3D"mailto:hjm@redhat.com">hjm@redhat.com</a>&gt;");<br>+MODULE_LICENS=
E("GPL");<br></span></blockquote></div><br><div><br></div></body></html>=

--Apple-Mail-43-834767133--


--===============2025293631==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2025293631==--
