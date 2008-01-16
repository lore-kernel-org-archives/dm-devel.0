From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: Packages for DMRAID Eventing posted to Redhat wiki page
Date: Wed, 16 Jan 2008 14:52:15 -0800
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CC01C57075@orsmsx418.amr.corp.intel.com>
References: <42247.10.10.5.59.1198008837.squirrel@telstar.systemsbiology.net><4768393F.3080807@cfl.rr.com><20071221154017.GA6306@redhat.com>
	<D44F48C7D79D2943A073C8FA0F49A3CC01BF6C2D@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC01BF6C2D@orsmsx418.amr.corp.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>, device-mapper development <dm-devel@redhat.com>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: dm-devel.ids

Hi everyone,=20

Alasdair pointed me to a wiki that is hosted by Redhat that I could post
my eventing code on. I've made a page called DMRAID_Eventing:
http://sources.redhat.com/lvm2/wiki/DMRAID_Eventing=20

I would appreciate feedback on the wiki page (don't be too rough on me
since it's my first attempt at a wiki page). Also any feedback from
people trying out the eventing packages would be greatly appreciated.=20

Thanks,=20

Brian Wood
Software Engineer
Intel Corp., Manageability & Platform Software Division
brian.j.wood@intel.com

>-----Original Message-----
>From: ataraid-list-bounces@redhat.com
[mailto:ataraid-list-bounces@redhat.com] On Behalf Of Wood,
>Brian J
>Sent: Wednesday, January 09, 2008 8:48 AM
>To: ATARAID (eg, Promise Fasttrak, Highpoint 370) related discussions
>Subject: RE: Adaptec HostRAID ddf1 on Supermicro X7DBR-i+
>
>>-----Original Message-----
>>From: ataraid-list-bounces@redhat.com
>[mailto:ataraid-list-bounces@redhat.com] On Behalf Of Heinz
>>Mauelshagen
>>Sent: Friday, December 21, 2007 7:40 AM
>>To: ATARAID (eg, Promise Fasttrak, Highpoint 370) related discussions
>>Subject: Re: Adaptec HostRAID ddf1 on Supermicro X7DBR-i+
>>
>>On Tue, Dec 18, 2007 at 04:18:55PM -0500, Phillip Susi wrote:
>>> Andrew Peabody wrote:
>>>> Hi Everyone,
>>>>
>>>> First I want to say that dmraid was been a wonderful tool for use.
>We use
>>>> it with many Sun X2100s, and other motherboards with great success.
>The
>>>> only feature we really miss is an option like mdmonitor to notify
us
>if
>>>> there is a problem with an array.
>>>
>>> Currently dmraid has no error handling capability, so you probably
>don't
>>> want to use it on a server needing fault tolerance.
>>
>>This is being implemeted with the kind help of Intel
>>and will be released ASAP next year.
>
>I have some packages for event monitoring available, but no where to
>host it at the moment (no outward facing Intel site to post it too that
>is). I also have a number of documents I've written that help a user
new
>to dmraid setup everything they will need to get raid array event
>monitoring running. :)
>
>Here is a sample of what will be reported to the syslog using these
>packages when an I/O error is encountered:
>
>Jan 7 06:40:55 dmraid-devhost dmeventd[3254]: Processing Raid Volume
>"isw_eecebgiia_raid0" for Events
>Jan 7 06:40:55 dmraid-devhost dmeventd[3254]:   Stripe device, 8:16
>(/dev/sdb) has reported an I/O
>error.
>Jan 7 06:40:55 dmraid-devhost dmeventd[3254]:   The kernel has recorded
>7 event(s) against this
>device.
>Jan 7 06:40:55 dmraid-devhost dmeventd[3254]:   Associated Userspace
>Names: /dev/sdb=3DDisabled /dev/sdc=3DActive
>Jan 7 06:40:55 dmraid-devhost dmeventd[3254]:   Associated SATA Port
>Mapping: /dev/sdb=3D2 /dev/sdc=3D3
>Jan 7 06:40:55 dmraid-devhost dmeventd[3254]:   Associated UUID:
>DMRAID-isw_eecebgiia_raid0
>Jan 7 06:40:55 dmraid-devhost dmeventd[3254]: End of event processing
>for Raid Volume
>"isw_eecebgiia_raid0"
>
>It will tell you the specific hardware device in the raid set that is
>failing using three ways: the major:minor number, the associated
>userspace name, and finally the port number on the mainboard that the
>SATA device is connected to.
>
>All of this is done using kernel driver patches (Jonathan Brassow's
>mirror patches, Heinz Mauelshagen's raid 4/5 patch, and my raid 0
>patches) along with a DSO and a registration tool that I've put
>together. (The utility is used to load/register the DSO with the
>dmeventd monitoring daemon.)
>
>I've also written special logwatch scripts to be used with this setup
>(for use by system admins and have documents to help with complete
setup
>for that also). Here is a sample of what an email alert would look like
>when a dmraid I/O error is encountered:
>
>################### Logwatch 7.3.4 (02/17/07) ####################
>Processing Initiated: Mon Jan 7 06:41:01 2008
>Date Range Processed: today
>( 2008-Jan-07 )
>Period is day.
>Detail Level of Output: 5
>Type of Output: unformatted
>Logfiles for Host: dmraid-devhost.localdomain
>##################################################################
>--------------------- Dmeventd Errors Begin ------------------------
>There were a total of 7 new log entries
>Date Message
>------------------------
>Jan 7 06:40:55: Processing Raid Volume "isw_eecebgiia_raid0" for Events
>Jan 7 06:40:55:   Stripe device, 8:16 (/dev/sdb) has reported an I/O
>error.
>Jan 7 06:40:55:   The kernel has recorded 7 event(s) against this
>device.
>Jan 7 06:40:55:   Associated Userspace Names: /dev/sdb=3DDisabled
>/dev/sdc=3DActive
>Jan 7 06:40:55:   Associated SATA Port Mapping: /dev/sdb=3D2 /dev/sdc=3D=
3
>Jan 7 06:40:55:   Associated UUID: DMRAID-isw_eecebgiia_raid0
>Jan 7 06:40:55: End of event processing for Raid Volume
>"isw_eecebgiia_raid0"
>---------------------- Dmeventd Errors End -------------------------
>###################### Logwatch End #########################
>
>I'm hoping that this is something that users of dmraid will find
useful.
>(Note: this is beta software that has had quite a bit of internal
>testing, but your mileage may vary out in the real world.)
>
>Thanks,
>
>Brian W.
>
>>
>>Heinz
>>
>>>
>>> _______________________________________________
>>> Ataraid-list mailing list
>>> Ataraid-list@redhat.com
>>> https://www.redhat.com/mailman/listinfo/ataraid-list
>>
>>=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D
>-=3D-=3D-=3D-
>>
>>Heinz Mauelshagen                                 Red Hat GmbH
>>Consulting Development Engineer                   Am Sonnenhang 11
>>Storage Development                               56242 Marienrachdorf
>>                                                  Germany
>>Mauelshagen@RedHat.com                            PHONE +49  171
>7803392
>>                                                  FAX   +49 2626
924446
>>=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
=3D
>-=3D-=3D-=3D-
>>
>>_______________________________________________
>>Ataraid-list mailing list
>>Ataraid-list@redhat.com
>>https://www.redhat.com/mailman/listinfo/ataraid-list
>
>_______________________________________________
>Ataraid-list mailing list
>Ataraid-list@redhat.com
>https://www.redhat.com/mailman/listinfo/ataraid-list
