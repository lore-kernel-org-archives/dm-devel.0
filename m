From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: [PATCH] kpartx: Improve finding loopback device by
 file
Date: Mon, 5 Feb 2018 15:41:21 +0100
Message-ID: <20180205144121.27ruwyewpkm3a4kd@jak-x230>
References: <20180205085831.23923-1-julian.klode@canonical.com>
	<1517826733.14196.3.camel@suse.com>
	<20180205104500.n5rrw6nqzamwijvl@jak-x230>
	<1517838787.14196.10.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1517838787.14196.10.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 05, 2018 at 02:53:07PM +0100, Martin Wilck wrote:
> On Mon, 2018-02-05 at 11:45 +0100, Julian Andres Klode wrote:
> > On Mon, Feb 05, 2018 at 11:32:13AM +0100, Martin Wilck wrote:
> > > On Mon, 2018-02-05 at 09:58 +0100, Julian Andres Klode wrote:
> > > > C
> > > >  		close (fd);
> > > >  
> > > > -		if (0 == strcmp(filename, loopinfo.lo_name)) {
> > > > +		if (0 == strcmp(filename, loopinfo.lo_name) ||
> > > > +		    0 == strcmp(rfilename, loopinfo.lo_name) ||
> > > > +		    (realpath(loopinfo.lo_name, rloopfilename)
> > > > &&
> > > > +		     0 == strcmp(rfilename, rloopfilename))) {
> > > >  			found = realpath(path, NULL);
> > > >  			break;
> > > >  		}
> > > 
> > > That "if x matches y or x matches y' or x' matches y" feels like
> > > guesswork. Can't we simply call realpath() on both loopinfo.lo_name
> > > and
> > > filename, and compare the two? 
> > 
> > Probably yes. That said there might be some corner cases:
> > 
> > (1) What happens if the backing file of a loopback is deleted -
> > realpath
> >     can fail with ENOENT.
> > (2) A path could be longer than PATH_MAX and it would fail with
> > ENAMETOOLONG
> >     - this is a "problem" with the initial realpath as well, but less
> > so, because
> >     the user can control that.
> 
> Both are scenarios in which kpartx would have good reason to fail (with
> a meaningful error message). That's better than guessing, IMO.

(1) Definitely not. Just because one of your (potentially other) loopback devices
has a deleted file you should not fail. (2) I don't really know.

But the problem here is that you are looking at loopback devices created by
stuff other than kpartx, and they might not be in a "good" state. But you
don't want to abort just because some _other_ loopback device is broken.

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
