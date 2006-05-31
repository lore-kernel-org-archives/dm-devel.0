From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Re: [PATCH] dm-striped device sizes must be multiple
	of chunk-size
Date: Thu, 1 Jun 2006 01:28:13 +0200
Message-ID: <20060531232813.GC2232@redhat.com>
References: <447DC1B6.7050601@free.fr>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <447DC1B6.7050601@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, May 31, 2006 at 06:17:58PM +0200, Peyrotau Yannick wrote:
> Hi, I have the same problem too when i try to upgrade to 2.6.16 kernel.
> 
> My motherbord is ASUS A8N-E with a nvidia raid chip.
> 
> I have make an archive with my metadata at this adress :
> http://crashteam1.free.fr/metadata/metadata_isw-Yannick_Peyrotau-raid0.tar.bz2
> 
> Can i resolve it ?

Pull dmraid-1.0.0.rc11 from FC5.

Heinz

> 
> 
> Thanks,
> Yannick
> 
> >Dwaine,
> >
> >can you please send me your metadata for refernence as well so
> >that I can confirm that my fix is good for bz #186842 ?
> >
> >Thanks,
> >Heinz
> >
> >On Sun, Mar 26, 2006 at 12:01:17AM +0000, Dwaine Garden wrote:
> >> Kevin Corry <kevcorry <at> us.ibm.com> writes:
> >> >
> >> > I'm thinking that this mapping would do what the BIOS is actually
> >> > intending.
> >> > It ought to be relatively straight-forward to recognize this
> >> > situation in
> >> > dmraid and set up a mapping similar to the one above.
> >> >
> >>
> >> I have the same problem.  How would you resolve this?
> >>
> >> Dwaine
> >>
> >>
> >>
> >>
> >> --
> >> dm-devel mailing list
> >> dm-devel redhat com
> >> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
