From: "Cetnerowski, Adam" <adam.cetnerowski@intel.com>
Subject: RE: RAID5 compatibility.
Date: Tue, 26 Feb 2008 08:48:00 -0000
Message-ID: <708F8794D464F346B28DF53E5CDD805F0343E4FA@swsmsx412.ger.corp.intel.com>
References: <6696311.1515961203966402993.JavaMail.www@wwinf4623>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <6696311.1515961203966402993.JavaMail.www@wwinf4623>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: silentphoebus@voila.fr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On > Behalf Of silentphoebus
> Sent: Monday, February 25, 2008 8:07 PM
> To: dm-devel@redhat.com
> Subject: [dm-devel] RAID5 compatibility.
>
> Hi all,
> i found a lot of informations on the internet for intel software raid5
> with ICH controler.
> So, the best is maybe to ask here.
> Is it compatible with the dmraid mapper or not ?
> Thank you for taking time to read.

Hi,

The software RAID 5 does indeed use device mapper. I would like to note
that at the moment it is in the experimental stage, while we work on
some of the features.

Adam Cetnerowski
Intel Technology Poland
