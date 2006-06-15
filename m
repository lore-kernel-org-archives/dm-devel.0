From: "Singh, Santosh (STSD)" <santosh.singh3@hp.com>
Subject: RE: Next set of device-mapper  patches
Date: Thu, 15 Jun 2006 20:42:59 +0530
Message-ID: <3EC60E80D9AA7C4E910ACC9DA2003AC305FEAF1B@BGEEXC02.asiapacific.cpqcorp.net>
References: <20060615145639.GJ27639@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20060615145639.GJ27639@agk.surrey.redhat.com>
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
Cc: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>
List-Id: dm-devel.ids

 I am testing  the device-mapper ioctl support.
  Which all the  patches required for this and can I I apply those
patches on linux-2.6.16.=20

Regards
Santosh


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Alasdair G Kergon
Sent: Thursday, June 15, 2006 8:27 PM
To: P S, Suresh (STSD)
Cc: device-mapper development
Subject: Re: [dm-devel] Next set of device-mapper patches

On Thu, Jun 15, 2006 at 08:22:02PM +0530, Singh, Santosh (STSD) wrote:
> below) in  order as given in the "series" file on linux-2.6.16.16. I=20
> think the patch is not being applied ,since it prompts many times e.g

You need to look at the comments against the patches and decide which
ones to apply.

For example, if you're starting from 2.6.16.16 you cannot apply:
  patch-2.6.17-rc4
  patch-2.6.17-rc4-rc5
  patch-2.6.17-rc5-rc6

Nor the section of kgdb patches (which may need tweaking if you did want
kgdb against a different kernel).

Alasdair
--
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
