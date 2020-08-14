From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 41/42] libmultipath: refuse reloading an
 existing map with different WWID
Date: Fri, 14 Aug 2020 09:51:10 +0200
Message-ID: <cff0150ba981151a9db33bc6f1d4dd2982e0c425.camel@suse.com>
References: <20200812113405.26206-1-mwilck@suse.com>
	<20200812113405.26206-3-mwilck@suse.com>
	<20200813222359.GY19233@octiron.msp.redhat.com>
	<c8468d0333f188f652de5c437baf91978ffcd432.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <c8468d0333f188f652de5c437baf91978ffcd432.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2020-08-14 at 09:48 +0200, Martin Wilck wrote:
> Hi Ben,
> 
> On Thu, 2020-08-13 at 17:23 -0500, Benjamin Marzinski wrote:
> > 
> > I'm
> > also open to convinced that it would be o.k. to rename a device
> > that
> > we
> > weren't planing on reloading, because it has a wrong alias, which
> > messes
> > with the device that we were supposed to reload (I assume this
> > makes
> > the
> > code easier). Does that sound like a reasonable solution?
> 
> I sounds ok.

s/I/It/ - sorry.
