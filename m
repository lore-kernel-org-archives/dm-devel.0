From: "Singh, Santosh (STSD)" <santosh.singh3@hp.com>
Subject: RE: Next set of device-mapper  patches
Date: Fri, 16 Jun 2006 20:06:40 +0530
Message-ID: <3EC60E80D9AA7C4E910ACC9DA2003AC30602831A@BGEEXC02.asiapacific.cpqcorp.net>
References: <20060615161658.GL27639@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20060615161658.GL27639@agk.surrey.redhat.com>
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

Hi,

 With the uploaded patches I am able to apply the patches and build the
kernel, but on boot=20
it displays the following messages & kernel panics.

Insmod: error inserting '/lib/scsi_mod.o' : -1 invalid format=20
ERROR:/bin/insmod exited abnormally! (pid 327)

I am getting these messages for all these modules
sd_mod.o,cciss.o, sg.o ide-disk.o,jbd.o and ext3.o .


I have patched the 2.6.16 kernel and my development system is having
2.6.9-22.0.2.Elsmp.

Any  advice on this.

TIA
Santosh





-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Alasdair G Kergon
Sent: Thursday, June 15, 2006 9:47 PM
To: device-mapper development
Subject: Re: [dm-devel] Next set of device-mapper patches

On Thu, Jun 15, 2006 at 09:16:56PM +0530, Singh, Santosh (STSD) wrote:
> I tried to patch on 2.6.16 as following and got the error below
=20
Strange.  That file got truncated.  I've uploaded it again.

Alasdair
--
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
