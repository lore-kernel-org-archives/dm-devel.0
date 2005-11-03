From: "goggin, edward" <egoggin@emc.com>
Subject: RE: Clariion CX600 automatic failback support
Date: Thu, 3 Nov 2005 13:16:32 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADA0@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Date: Thu, 3 Nov 2005 14:58:36 +0100
Christophe Varoqui <christophe.varoqui@free.fr> wrote

> > Once the distributors pick up both this single line change and the
> > change in hwtable.c, immediate path group failback for CLARiiON
> > will just work.
> > 
> > -------------------------------------------------------------------
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -146,6 +146,7 @@ adopt_paths (struct vectors * vecs, stru
> >  		if (!strncmp(mpp->wwid, pp->wwid, WWID_SIZE)) {
> >  			condlog(4, "%s ownership set", pp->dev_t);
> >  			pp->mpp = mpp;
> > +			mpp->hwe = pp->hwe;
> >  		}
> >  	}
> >  }
> > 
> Upstream has had a patch for that. It plug the mpp->hwe refresh in
> setup_multipath().
> 
> Can you check it has no regression wrt your suggested fix ?
> 
> Regards,
> cvaroqui

Looks good, except the call to extract_hwe_from_path in setup_multipath
must be before the call to select_pgfailback.
