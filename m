From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: RE: Question about dmevents
Date: Fri, 20 Jul 2007 09:44:29 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC01226316@orsmsx418.amr.corp.intel.com>
References: <20070720162209.GZ459@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20070720162209.GZ459@agk.fab.redhat.com>
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

Hi Alasdair, I just checked using "dmsetup info" and my mirrored logical
volume I created yesterday shows a UUID, but the raid1 my system runs on
doesn't? Just curious, should this UUID have been created during system
OS installation by device-mapper?

Thank you,    =20

Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com

>-----Original Message-----
>From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On
>Behalf Of Alasdair G Kergon
>Sent: Friday, July 20, 2007 9:22 AM
>To: device-mapper development
>Subject: Re: [dm-devel] Question about dmevents
>
>Obvious question - but first check your device actually has a uuid.
>(Does 'dmsetup info' report it?)
>
>Kernel-side, uuids are optional, but userspace applications are likely
>to find it difficult to function reliably without them.
>
>Alasdair
>--
>agk@redhat.com
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
