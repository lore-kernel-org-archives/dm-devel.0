From: Brian Long <brilong@cisco.com>
Subject: RE: Clariion CX600 automatic failback support
Date: Thu, 03 Nov 2005 15:55:54 -0500
Message-ID: <1131051354.4436.63.camel@brilong-lnx>
References: <C2EEB4E538D3DC48BF57F391F422779321ADA0@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ADA0@SRMANNING.eng.emc.com>
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

On Thu, 2005-11-03 at 13:16 -0500, goggin, edward wrote:
> On Date: Thu, 3 Nov 2005 14:58:36 +0100
> Christophe Varoqui <christophe.varoqui@free.fr> wrote
> 
> > > Once the distributors pick up both this single line change and the
> > > change in hwtable.c, immediate path group failback for CLARiiON
> > > will just work.
> > > 
> > > -------------------------------------------------------------------
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -146,6 +146,7 @@ adopt_paths (struct vectors * vecs, stru
> > >  		if (!strncmp(mpp->wwid, pp->wwid, WWID_SIZE)) {
> > >  			condlog(4, "%s ownership set", pp->dev_t);
> > >  			pp->mpp = mpp;
> > > +			mpp->hwe = pp->hwe;
> > >  		}
> > >  	}
> > >  }
> > > 
> > Upstream has had a patch for that. It plug the mpp->hwe refresh in
> > setup_multipath().
> > 
> > Can you check it has no regression wrt your suggested fix ?
> > 
> > Regards,
> > cvaroqui
> 
> Looks good, except the call to extract_hwe_from_path in setup_multipath
> must be before the call to select_pgfailback.

Ed,

So it sounds like I need Red Hat to issue me a hotfix for device-mapper-
multipath that includes the upstream patch or your patch for get
Clariion fallback working properly.

I'll ask Red Hat about this in my existing support case.

/Brian/

-- 
       Brian Long                      |         |           |
       IT Data Center Systems          |       .|||.       .|||.
       Cisco Linux Developer           |   ..:|||||||:...:|||||||:..
       Phone: (919) 392-7363           |   C i s c o   S y s t e m s
