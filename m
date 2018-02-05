From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: [PATCH] kpartx: print "loop deleted" to stdout,
 not stderr
Date: Mon, 5 Feb 2018 15:17:20 +0100
Message-ID: <20180205141720.fdktrzne5x2cdsbo@jak-x230>
References: <20180205103645.19121-1-julian.klode@canonical.com>
	<1517839126.14196.14.camel@suse.com>
	<20180205141233.6k4pjxxf6oijmkqn@jak-x230>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180205141233.6k4pjxxf6oijmkqn@jak-x230>
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
Cc: Device-mapper development mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 05, 2018 at 03:12:33PM +0100, Julian Andres Klode wrote:
> On Mon, Feb 05, 2018 at 02:58:46PM +0100, Martin Wilck wrote:
> > On Mon, 2018-02-05 at 11:36 +0100, Julian Andres Klode wrote:
> > > Commit fa643f5d2590028a59c671b81ab41383806fd258 moved some
> > > code around and changed the print for loop deleted from stdout
> > > to stderr - but this is not an error message, and also printed
> > > to stdout in another place, so let's just use printf() again
> > > here.
> > > 
> > > Signed-off-by: Julian Andres Klode <julian.klode@canonical.com>
> > > ---
> > >  kpartx/kpartx.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> > > index c1af1c5e..2e882721 100644
> > > --- a/kpartx/kpartx.c
> > > +++ b/kpartx/kpartx.c
> > > @@ -399,7 +399,7 @@ main(int argc, char **argv){
> > >  					       loopdev);
> > >  				r = 1;
> > >  			} else
> > > -				fprintf(stderr, "loop deleted :
> > > %s\n", loopdev);
> > > +				printf("loop deleted : %s\n",
> > > loopdev);
> > >  		}
> > >  		goto end;
> > >  	}
> > 
> > 
> > Hm. This is a log message, and as such, should go to stderr. kpartx, as
> > a program primarily intended to run in udev rules, shouldn't print log
> > messages to stdout unless we have compelling reasons for it to do so.
> > 
> > I'm aware that this isn't done consistently in kpartx at the moment,
> > but IMO your patch goes in the wrong direction.
> 
> It seems very consistent for me: stderr is used for errors and warnings,
> and printf() for the rest. There are two exceptions: This one, and
> 
> kpartx/devmapper.c:             fprintf(stderr, "found map %s for uuid %s, renaming to %s\n",
> 
> But that one really is what I'd consider a log message. Stuff like
> "del devmap" and "loop deleted" seem somehow different - you tell
> it to delete a mapping, and to be verbose, and then it should tell
> you what it deleted, on stdout. Maybe people are parsing this, who
> knows? It definitely broke our tests because unexpected stderr output
> appeared.
> 

In fact, if you look at the bug mentioned in the previous patch,

https://bugs.launchpad.net/ubuntu/+source/multipath-tools/+bug/1747044

you'll see that we explicitly check the output of kpartx -v -d for
"loop deleted" apparently because kpartx was (or is?) flaky and returned
an error even when it successfully deleted the loop device, as seen in

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=860894

It seems reasonable that Debian and Ubuntu are not the only ones
relying on that output.

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
