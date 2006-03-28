From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Re: [PATCH] dm-striped device sizes must be
	multiple	of chunk-size
Date: Tue, 28 Mar 2006 16:06:12 +0200
Message-ID: <20060328140612.GD3218@redhat.com>
References: <e3538fbd0603222128o525b4608h84b4004fc4ca0a61@mail.gmail.com>
	<200603242246.25314.kevcorry@us.ibm.com>
	<loom.20060326T005919-664@post.gmane.org>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <loom.20060326T005919-664@post.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dwaine Garden <DwaineGarden@rogers.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Dwaine,

can you please send me your metadata for refernence as well so
that I can confirm that my fix is good for bz #186842 ?

Thanks,
Heinz

On Sun, Mar 26, 2006 at 12:01:17AM +0000, Dwaine Garden wrote:
> Kevin Corry <kevcorry <at> us.ibm.com> writes:
> > 
> > I'm thinking that this mapping would do what the BIOS is actually intending. 
> > It ought to be relatively straight-forward to recognize this situation in 
> > dmraid and set up a mapping similar to the one above.
> > 
> 
> I have the same problem.  How would you resolve this?
> 
> Dwaine
> 
> 
> 
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
