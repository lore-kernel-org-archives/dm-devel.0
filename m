From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath: add find_multipaths feature.
Date: Thu, 14 Jul 2011 20:53:03 -0400
Message-ID: <20110715005302.GA26472@redhat.com>
References: <20101116232546.GU13763@ether.msp.redhat.com>
	<1291762849.4430.6.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1291762849.4430.6.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@opensvc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Dec 07 2010 at  6:00pm -0500,
Christophe Varoqui <christophe.varoqui@gmail.com> wrote:

> On mar., 2010-11-16 at 17:25 -0600, Benjamin Marzinski wrote:
> > This adds a new default feature, find_multipaths. When this is set to yes,
> > multipath will no longer try to create multipath devices using every
> > non-blacklisted device. Instead, it will only create a device when one of
> > three conditions are met.
> > 
> > 1. Three are at least two non-blacklisted paths with the same wwid
> > 2. The user manually forces the creation, by specifying a device with the
> >    multipath command.
> > 3. A path has the same wwid as a multipath device that was previously crreated
> >    (even if that multipath device doesn't currently exist).
> > 
> > To do 3, multipath stores the wwid of every path that it creates in
> > /etc/multipath/wwids. Whenever a path is added, its wwid is checked against
> > this file.  If there's a match, it is multipathed, even if it's the only path.
> > This should allow multipath to automatically choose the correct paths to make
> > into multipath devics in most cases, without needing the user to edit the
> > blacklist.
> > 
> Hi Ben,
> 
> I just merged the patches you queued for upstream the last weeks, except
> this one. I'm still not convinced, but that may be because I have not
> understood yet. I'll try and give it more brain.

find_multipaths is quite useful for avoiding the issue that was just
reported where multipath grabs the root device even though it doesn't
have multiple paths.

Any chance you could reevaluate Ben's patch for inclusion?
