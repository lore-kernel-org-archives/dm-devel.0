From: Martin Wilck <mwilck@suse.com>
Subject: Re: Recent multipath-tools patches from Huawei
Date: Tue, 11 Aug 2020 11:49:54 +0200
Message-ID: <eba3738594596c3e7d37ae6b8c2f35e9592864a8.camel@suse.com>
References: <140e431094a118a5276f6964921cc120bda2dc49.camel@suse.com>
	<60d7ea82-22ed-16f5-de7f-8280b90eeb7f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <60d7ea82-22ed-16f5-de7f-8280b90eeb7f@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, linfeilong@huawei.com, Yanxiaodan <yanxiaodan@huawei.com>, lixiaokeng <lixiaokeng@huawei.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 2020-08-11 at 09:14 +0800, Zhiqiang Liu wrote:
> 
> On 2020/8/10 22:34, Martin Wilck wrote:
> > Hi Liu,
> > 
> > thanks again for your valuable contributions and meticulous code
> > review. I've added your patches in my upstream-queue branch now:
> > 
> > https://github.com/openSUSE/multipath-tools/commits/upstream-queue
> > 
> > Not applied yet: 
> > 
> >  - libmultipath: free pp if store_path fails in disassemble_map:
> >    As noted before, this will be merged with my series for
> >    disassemble_map().
> >  - libmultipath: fix a memory leak in set_ble_device:
> >    Please fix minor issues I mentioned
> >  - vector: return null when realloc fails in vector_alloc_slot func
> >    Needs improvement
> > 
> > Please double-check if I've missed anything. 
> > 
> > Next time, please send your patches as a series. That makes it
> > much easier for others to make sure they don't miss any.
> > And please, don't add "[dm-devel]" explicitly in your email
> > subject, mailman will take care of that.
> > 
> > Regards
> > Martin
> > 
> Thanks for your advise.
> I have checked recent patches. The following patch may be missed.
> - libmultipath: free pgp if add_pathgroup fails in disassemble_map
> func

Right. Sorry for overlooking it, I pushed it now.

Regards,
Martin
