From: Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: Re: [RFC][PATCH] dm-cache: block level disk cache
	target for device mapper
Date: Mon, 11 Dec 2006 23:31:32 +0100
Message-ID: <20061211223132.GA14495@redhat.com>
References: <200611271826.kARIQYRi032717@hera.kernel.org>
	<a4e6962a0612111054j6741c70cja1aa96ebee124e63@mail.gmail.com>
Reply-To: mauelshagen@redhat.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a4e6962a0612111054j6741c70cja1aa96ebee124e63@mail.gmail.com>
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
Cc: Eric Van Hensbergen <ericvh@hera.kernel.org>, ming@acis.ufl.edu, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Hrm,

I finally got onto one of my TODO items a while ago which is an
HSM (IOW: cache) target for device-mapper ;)
The design of my HSM target covers remote storage as well as arbitrary
slow local storage hierachies.

Let's compare our code and see if there's any mutual stuff to merge
or pros and cons of the different approaches when I post something shortly.

Heinz

On Mon, Dec 11, 2006 at 12:54:33PM -0600, Eric Van Hensbergen wrote:
> On 11/27/06, Eric Van Hensbergen <ericvh@hera.kernel.org> wrote:
> >This is the first cut of a device-mapper target which provides a write-back
> >or write-through block cache.  It is intended to be used in conjunction 
> >with
> >remote block devices such as iSCSI or ATA-over-Ethernet, particularly in
> >cluster situations.
> >
> 
> The technical paper describing our motivations and some performance
> results has finally made it through IBM's clearance process.  It is
> available here:
> 
> http://domino.research.ibm.com/library/cyberdig.nsf/1e4115aea78b6e7c85256b360066f0d4/ba52bef8b940e7438525723c006bafea?OpenDocument
> 
>               -eric
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
