From: Oren Held <oren@held.org.il>
Subject: Re: [PATCH] Add default values for IBM XIV Storage
	System.
Date: Thu, 12 Jan 2012 09:37:16 +0200
Message-ID: <20120112073714.GA4362@orenhe-laptop>
References: <20111228175920.GA29764@orenhe-laptop>
	<1325245568.6564.0.camel@lapoo.opensvc.com>
	<CAEnAntiX-ub=xBi34=iU6e_neY6aOU0ViVNjY7sU6g4iEZD2kA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAEnAntiX-ub=xBi34=iU6e_neY6aOU0ViVNjY7sU6g4iEZD2kA@mail.gmail.com>
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

2812 is an internal IBM model number, which means 'longer warranty' (so it doesn't actually replace 2810).
(http://rogerluethy.wordpress.com/2011/07/12/ibm-xiv-storage-system-gen3-offers-a-new-high-performance-model-114-for-machine-types-2810-and-2812/)

What matters is that this internal IBM model number is *not* exposed by SCSI inquiry.
To this day, all IBM XIV models report 'IBM'/'2810XIV' in the vendor/product fields of SCSI inquiry, regardless of being internally known as 2810, 2812 or 2814. It's deliberate, and there's no plan to change this, AFAIK.

Thanks

Oren H
XIV Host Software team

On Wed, Jan 11, 2012 at 05:39:12PM -0500, August Sodora wrote:
> The new XIV machine code is actually 2812, not sure if this matters.
> 
> August Sodora
> augsod@gmail.com
> (201) 280-8138
> 
> 
> 
> On Fri, Dec 30, 2011 at 6:46 AM, Christophe Varoqui
> <christophe.varoqui@gmail.com> wrote:
> > On mer., 2011-12-28 at 19:59 +0200, Oren Held wrote:
> >> Add default values for IBM XIV Storage System.
> >
> > Applied and pushed.
> >
> > Thanks.
> > --
> > Christophe Varoqui
> > OpenSVC - Tools to scale
> > http://www.opensvc.com/
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
