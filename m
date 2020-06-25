From: Joe Perches <joe@perches.com>
Subject: Re: [RFC] Reed-Solomon Code: Update no_eras to the actual number of
 errors
Date: Wed, 24 Jun 2020 22:50:56 -0700
Message-ID: <51ca818443648cb25a604448dea022d6ac2ea09f.camel@perches.com>
References: <20200625041141.8053-1-aiden.leong@aibsd.com>
         <202006242231.E17DAB2@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <202006242231.E17DAB2@keescook>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Aiden Leong <aiden.leong@aibsd.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Thomas Gleixner <tglx@linutronix.de>, Ferdinand Blomqvist <ferdinand.blomqvist@gmail.com>, YueHaibing <yuehaibing@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-Id: dm-devel.ids

On Wed, 2020-06-24 at 22:35 -0700, Kees Cook wrote:
> On Wed, Jun 24, 2020 at 09:10:53PM -0700, Aiden Leong wrote:
> > Corr and eras_pos are updated to actual correction pattern and erasure
> > positions, but no_eras is not.
[]
> > @@ -312,14 +313,21 @@
> >  				eras_pos[j++] = loc[i] - pad;
> >  			}
> >  		}
> > +		if (no_eras > 0)
> > +			*no_eras = j;
> 
> Is this meant to be "if (j > 0)" or "if (no_eras != NULL)" ? It's
> uncommon to use > 0 for a pointer value.
> 
> >  	} else if (data && par) {
> >  		/* Apply error to data and parity */
> > +		j = 0;
> >  		for (i = 0; i < count; i++) {
> >  			if (loc[i] < (nn - nroots))
> >  				data[loc[i] - pad] ^= b[i];
> >  			else
> >  				par[loc[i] - pad - len] ^= b[i];
> > +			if (b[i])
> > +				j++;
> >  		}
> > +		if (no_eras > 0)
> > +			*no_eras = j;
> 
> I assume it's a pointer test, so both would be:
> 
> 		if (no_eras_ptr != NULL)
> 			*no_eras_ptr = j;

More common still would be

		if (no_eras_ptr)
			*no_eras_ptr = j;

though I think using _ptr is too Hungarian.
