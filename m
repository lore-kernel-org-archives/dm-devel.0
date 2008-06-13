From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] NetBSD libdevmapper port
Date: Fri, 13 Jun 2008 20:25:28 +0200
Message-ID: <1213381528.5057.0.camel@localhost>
References: <7F5B52C7-1511-49C8-B81A-D4D58E6B12F3@gmail.com>
	 <Pine.LNX.4.64.0806131236500.32455@engineering.redhat.com>
	 <20080613173413.GO20826@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <bounces-tech-kern-owner-netbsd-tech-kern=m.gmane.org@NetBSD.org>
In-Reply-To: <20080613173413.GO20826@agk.fab.redhat.com>
Sender: tech-kern-owner@NetBSD.org
To: device-mapper development <dm-devel@redhat.com>
Cc: tech-kern@netbsd.org, Adam Hamsik <haaaad@gmail.com>
List-Id: dm-devel.ids

On Fri, 2008-06-13 at 18:34 +0100, Alasdair G Kergon wrote:
> On Fri, Jun 13, 2008 at 12:51:48PM -0400, Mikulas Patocka wrote:
> > This suspend thing was a big misdesign and if you are writing it from 
> > scratch, try to avoid it.
>  
> Despite how things might seem, we gained some substantial
> simplifications by doing things this way and I reject the term
> 'misdesign':-)  If writing this from scratch under similar time
> constraints, we would still handle this a similar way.
> 
> But this suspend/resume mechanism was never intended to last as long as
> it has

Right, I remember we had technical discussions about it ~3y ago ;-)

Heinz

>  - it was meant to be a stepping stone to a more-sophisticated
> transaction mechanism that we have still not found time to develop,
> mostly because this existing mechanism is "good enough" most of the
> time.
> 
> Alasdair
-- 

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Red Hat GmbH
Consulting Development Engineer                   Am Sonnenhang 11
Storage Development                               56242 Marienrachdorf
                                                  Germany
Mauelshagen@RedHat.com                            PHONE +49  171 7803392
                                                  FAX   +49 2626 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
