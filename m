From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow:	ide-cd
 related? dm-related?
Date: Tue, 26 Feb 2008 12:37:17 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802261230510.30955@jikos.suse.cz>
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
 <m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
 <20080225123041.401da103.akpm@linux-foundation.org>
 <20080225224807.GA15700@atrey.karlin.mff.cuni.cz>
 <Pine.LNX.4.64.0802261207140.30955@jikos.suse.cz> <20080226112932.GB10996@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761353AbYBZLha@vger.kernel.org>
In-Reply-To: <20080226112932.GB10996@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Nix <nix@esperi.org.uk>, Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jan Kara <jack@ucw.cz>
List-Id: dm-devel.ids

On Tue, 26 Feb 2008, Ingo Molnar wrote:

> > +	name = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> > +	fname = kmalloc(sizeof(char) * UDF_NAME_LEN, GFP_KERNEL);
> > +
> > +	if (!name || !fname) {
> > +		*err = -ENOMEM;
> > +		return NULL;
> > +	}
> > +
> >  	if (dentry) {
> >  		if (!dentry->d_name.len) {
> >  			*err = -EINVAL;
> this bit is missing i think:
> 	if (name)
> 		kfree(name);
> 	if (fname)
> 		kfree(fname);

Ergh, of course, stupid me, sorry, it should be freed on all exit paths. I 
am not sending updated patch, as Jan is probably working on complete 
removal of one of those fields ... ?

Thanks,

-- 
Jiri Kosina
