From: "Paul Cote" <paul.cote@incipient.com>
Subject: RE: performance considerations with IO schedulers
	andDMmultipathing
Date: Thu, 29 Nov 2007 18:33:58 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F2611B8D1C@exch-2003.incipient.waltham>
References: <1D80D4F6D179BD4D869FE807A5BF8336012DCA51@EXCNYSM0A1AN.nysemail.nyenet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1D80D4F6D179BD4D869FE807A5BF8336012DCA51@EXCNYSM0A1AN.nysemail.nyenet>
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


John,

Interesting and thanks. Our customer will be doing throughput intensive
I/O (both reads and writes) ... So your observation may indeed be
helpful (deadline-25).

Paul

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Romanowski, John (OFT)
Sent: Thursday, November 29, 2007 6:12 PM
To: device-mapper development
Subject: RE: [dm-devel] performance considerations with IO schedulers
andDMmultipathing


Here's some links:

Google cache of this article:
"The basis for my test was to determine the best possible performance
combination of elevator tuning AND /etc/multipath.conf rr_min_io
setting."
http://72.14.209.104/search?q=3Dcache:q2p5HOwGxHwJ:www.techyblog.com/cont=
e
nt/view/45/28/+Multipath+rr_min_io+Oracle+Elevator+Benchmarks&hl=3Den&ct=3D=
c
lnk&cd=3D1&gl=3Dus

"The short summary of our study indicates that there is no SINGLE answer
to which I/O scheduler is best."
http://www.redhat.com/magazine/008jun05/features/schedulers/

Oracle and linux I/O Scheduler
part 1- http://www.nextre.it/oracledocs/ioscheduler_01.html
part 2- http://www.nextre.it/oracledocs/ioscheduler_02.html
part 3- http://www.nextre.it/oracledocs/ioscheduler_03.html


--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged
or otherwise legally protected. It is intended only for the addressee.
If you received this e-mail in error or from someone who was not
authorized to send it to you, do not disseminate, copy or otherwise use
this e-mail or its attachments.  Please notify the sender immediately by
reply e-mail and delete the e-mail from your system.


-----Original Message-----

From: dm-devel-bounces@redhat.com on behalf of Stefan Bader
Sent: Tue 11/27/2007 4:42 PM
To: device-mapper development
Subject: Re: [dm-devel] performance considerations with IO schedulers
and DMmultipathing
=20
Hi Paul,

the device-mapper target itself doe not use any queue and so there is no
scheduler used at all. Only the real devices that are used as paths will
be using a scheduler. Whether there might be a performance gain by
changing these, I do not know.

Stefan

2007/11/27, Paul Cote <paul.cote@incipient.com>:
>
>  Hi,
>
> Is there any advantage to one specific IO scheduler (below) that may=20
> improve IO performance / throughput when running with a round-robin=20
> failover policy? Has anyone done testing with this ... and willing to=20
> share results?
>
> thanks,
> Paul
>
> Completely Fair Queuing-elevator=3Dcfq (default)=20
> Deadline-elevator=3Ddeadline NOOP-elevator=3Dnoop
> Anticipatory-elevator=3Das
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com https://www.redhat.com/mailman/listinfo/dm-devel
>


--
dm-devel mailing list
dm-devel@redhat.com https://www.redhat.com/mailman/listinfo/dm-devel
