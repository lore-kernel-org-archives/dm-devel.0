From: egoggin@emc.com
Subject: RE: dm-emc doesn't works with vanilla kernel
Date: Mon, 10 Jul 2006 11:07:04 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4149186@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I suspect that the problem is with multipath-tools not the
dm-emc code.  You may need to upgrade your multipath-tools
package to a version 0.4.7 base.  Could you try this and
let me know the status?

I have no problem of this sort with my CX series CLARiiONs
with version 2.6.(13,14,15,16) linux kernels.

> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Nicola Murino
> Sent: Saturday, July 08, 2006 5:09 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] dm-emc doesn't works with vanilla kernel
> 
> Hi all,
> 
> I'm successfully running multipath-tools on a gentoo server 
> since almost
> a year, only a problem:
> 
> if I use a kernel different from 2.6.13 after detaching a fibre path
> dm-emc doesn't send trespass and the cx300 luns are not accessible, I
> got this problem with kernel-2.6.14 and kernel-2.6.16.19, 
> kernel-2.6.13
> works ok. 
> 
> On another installation with centos, last kernel 
> (2.6.9-34.01EL) and the
> same storage all is fine.
> 
> Would be great if dm-emc works properly with the upstream kernels,
> 
> thanks
> Nicola
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
