From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 4/6] libmultipath: check blist before calling
 MALLOC in alloc_ble_device func
Date: Tue, 18 Aug 2020 01:51:40 -0500
Message-ID: <20200818065140.GN19233@octiron.msp.redhat.com>
References: <351fa23b-b730-ce22-7e89-24f26a693a6a@huawei.com>
	<4127cfc2-413f-32d9-cf76-0c0453524aeb@huawei.com>
	<dbe521bcacbc746969437612d639387663898f88.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <dbe521bcacbc746969437612d639387663898f88.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Zhiqiang Liu <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Mon, Aug 17, 2020 at 10:51:49AM +0200, Martin Wilck wrote:
> On Sun, 2020-08-16 at 09:45 +0800, Zhiqiang Liu wrote:
> > In alloc_ble_device func, ble is firstly allocated by calling MALLOC,
> > and then input blist is checked whether it is valid. If blist is not
> > valid, ble will be freed without using.
> > 
> > Here, we should check blist firstly.
> > 
> > Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> > Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> > ---
> >  libmultipath/blacklist.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> This patch isn't wrong, but it fixes code which isn't buggy. It's
> rather a style thing, an optimization for an extremely unlikely error
> case. I agree with you in the sense that I prefer the "new" style over
> the old (I generally dislike expressions that can fail, like malloc()
> calls, being used as variable initializers), but I'm not sure if we
> should start applying patches for cases like this. So far we've been
> rather conservative with "style" patches, because they tend to make it
> unnecessarily hard to track code history.
> 
> Ben, Christophe, what's your take on this matter?

While I'm not really a fan of whitespace tweaking patches, I'm fine with
this. All things being equal, I really do prefer it when functions check
their arguments first, instead of doing possibly unnecessary work.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> Regards,
> Martin
> 
> 
> > 
> > diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
> > index db58ccc..bedcc7e 100644
> > --- a/libmultipath/blacklist.c
> > +++ b/libmultipath/blacklist.c
> > @@ -66,12 +66,16 @@ out:
> > 
> >  int alloc_ble_device(vector blist)
> >  {
> > -	struct blentry_device * ble = MALLOC(sizeof(struct
> > blentry_device));
> > +	struct blentry_device *ble;
> > 
> > +	if (!blist)
> > +		return 1;
> > +
> > +	ble = MALLOC(sizeof(struct blentry_device));
> >  	if (!ble)
> >  		return 1;
> > 
> > -	if (!blist || !vector_alloc_slot(blist)) {
> > +	if (!vector_alloc_slot(blist)) {
> >  		FREE(ble);
> >  		return 1;
> >  	}
> 
