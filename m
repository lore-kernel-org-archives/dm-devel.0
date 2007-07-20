From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: RE: Question about dmevents
Date: Fri, 20 Jul 2007 09:57:28 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC0122633A@orsmsx418.amr.corp.intel.com>
References: <20070720162626.GA459@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20070720162626.GA459@agk.fab.redhat.com>
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

Hi Alasdair, I also read in the definition of DM_DEV_CREATE that the
uuid is optional. Since that is the case shouldn't the failure for not
having a uuid in "_alloc_thread_status()" be taken out?

Thank you,=20

Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com

>-----Original Message-----
>From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On
>Behalf Of Alasdair G Kergon
>Sent: Friday, July 20, 2007 9:26 AM
>To: device-mapper development
>Subject: Re: [dm-devel] Question about dmevents
>
>See http://people.redhat.com/agk/talks/FOSDEM_2005/text41.html for info
>about
>how devices are referenced.
>
>Alasdair
>--
>agk@redhat.com
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
