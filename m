From: malahal@us.ibm.com
Subject: Re: [PATCH 2/7] A framework for holding bios until suspend
Date: Sun, 29 Nov 2009 18:55:45 -0800
Message-ID: <20091130025544.GA632@us.ibm.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
	<4B1165A7.3050303@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4B1165A7.3050303@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Takahiro Yasui [tyasui@redhat.com] wrote:
> On 11/18/09 07:11, Mikulas Patocka wrote:
> > @@ -760,6 +775,7 @@ static void do_mirror(struct work_struct
> >  	bio_list_init(&ms->reads);
> >  	bio_list_init(&ms->writes);
> >  	bio_list_init(&ms->failures);
> > +	bio_list_init(&ms->hold);
> >  	spin_unlock_irqrestore(&ms->lock, flags);
> 
> Initializing the hold list in do_mirror() is a problem. Some bios might
> already in it and they will never be processed. This makes device-mapper
> "stuck" when the device goes suspend. The hold list should be inizialized
> only when the mirror device is created in alloc_context().
> 
> alloc_context()
>         spin_lock_init(&ms->lock);
>         bio_list_init(&ms->reads);
>         bio_list_init(&ms->writes);
>         bio_list_init(&ms->failures);
> +        bio_list_init(&ms->hold);
> 
> Thanks,
> Taka

Good catch!
