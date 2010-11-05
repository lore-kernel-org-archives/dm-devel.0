From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: fix multipath locking
Date: Fri, 05 Nov 2010 08:11:31 +0100
Message-ID: <1288941091.16233.14.camel@zezette>
References: <20101105045946.GJ13763@ether.msp.redhat.com>
	<20101105055952.GA9165@us.ibm.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101105055952.GA9165@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Applied with fix,
Thanks.

On jeu., 2010-11-04 at 22:59 -0700, Malahal Naineni wrote:
> Benjamin Marzinski [bmarzins@redhat.com] wrote:
> > @@ -294,12 +295,25 @@ lock_multipath (struct multipath * mpp, 
> >  		vector_foreach_slot(pgp->paths, pp, j) {
> >  			if (lock && flock(pp->fd, LOCK_EX | LOCK_NB) &&
> >  			    errno == EWOULDBLOCK)
> > -				return 1;
> > +				goto fail;
> >  			else if (!lock)
> >  				flock(pp->fd, LOCK_UN);
> >  		}
> >  	}
> >  	return 0;
> > +fail:
> > +	vector_foreach_slot (mpp->pg, pgp, x) {
> > +		if (x > i)
> > +			return 1;
> > +		if (!pgp->paths)
> > +			continue;
> > +		vector_foreach_slot(pgp->paths, pp, y) {
> > +			if (x == i && y > j)
> 
> Path 'j' has failed to get the lock dropping us to the fail label.
> We should NOT be unlocking for path "j", so the above if expression
> should be "(x ==i && y >= j)" instead.
> 
> Otherwise, it looks good.
> 
> > +				return 1;
> > +			flock(pp->fd, LOCK_UN);
> > +		}
> > +	}
> > +	return 1;
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
