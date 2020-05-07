From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/2] libmultipath: create libdir on install
Date: Thu, 07 May 2020 23:13:12 +0200
Message-ID: <858eb4ffcd9405ba7c10ed11f1d4c720a8ed496f.camel@suse.com>
References: <20200506073548.41756-1-list@eworm.de>
	<20200506073548.41756-2-list@eworm.de> <20200506094828.727f1d3a@leda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200506094828.727f1d3a@leda>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christian Hesse <list@eworm.de>, dm-devel@redhat.com
Cc: Christian Hesse <mail@eworm.de>
List-Id: dm-devel.ids

On Wed, 2020-05-06 at 09:48 +0200, Christian Hesse wrote:
> Christian Hesse <list@eworm.de> on Wed, 2020/05/06 09:35:
> > From: Christian Hesse <mail@eworm.de>
> > 
> > Without this installation fails with:
> > 
> > install: target '$DESTDIR/usr/lib/multipath' is not a directory
> > Signed-off-by: Christian Hesse <mail@eworm.de>
> > ---
> >  libmultipath/prioritizers/Makefile | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/libmultipath/prioritizers/Makefile
> > b/libmultipath/prioritizers/Makefile index 9d0fe03c..11da5be2
> > 100644
> > --- a/libmultipath/prioritizers/Makefile
> > +++ b/libmultipath/prioritizers/Makefile
> > @@ -35,6 +35,7 @@ libprio%.so: %.o
> >  	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
> >  
> >  install: $(LIBS)
> > +	$(INSTALL_PROGRAM) -d $(DESTDIR)$(libdir)
> >  	$(INSTALL_PROGRAM) -m 755 libprio*.so $(DESTDIR)$(libdir)
> >  
> >  uninstall:
> 
> Ignore this one... It does not fix the issue. The build system has to
> be
> fixed for simultaneous jobs when installing.
> 
> For now installing with just one job (`make -j1`).

Right. Feel free to send patches for this. I've never felt the urge to
run "make install" parallelized; it takes less then 1s on my laptop.

Martin
