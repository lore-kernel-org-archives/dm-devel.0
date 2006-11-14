From: John Little <jslittl@hendricks.org>
Subject: RE: multipath and san fabric
Date: Tue, 14 Nov 2006 08:09:20 -0500
Message-ID: <200611140809.21110.jslittl@hendricks.org>
Reply-To: jslittl@hendricks.org,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: James.Smart@emulex.com, egoggin@emc.com
List-Id: dm-devel.ids

Hi all

Wow.  thanks for the responses...

James Smart <James.Smart@Emulex.Com> wrote on 11/13/2006 02:54:15 PM:

> >>> Example 2:
> >>>    Fabric A contains HBA1, TargetPort1, and TargetPort3. 
> >>> Typically a zone
> >>>      would exist within Fabric A that contains these 3 ports.
> >>>    Fabric B contains HBA2, TargetPort2, and TargetPort4. 
> >>> Typically a zone
> >>>      would exist within Fabric B that contains these 3 ports.
> >>>    The storage array contains 2 controllers, with 2 ports per 
> >>> controller.
> >>>      Meaning TargetPort1 and TargetPort2 are on controller A, 
> >>> and TargetPort3
> >>>      and TargetPort4 are on controller B. The ports are cross 
> >>> connected on
> >>>      the fabrics for redundancy. All storage can be seen from 
> >>> any port.
> >>>    --
> >>>    This would ahve 4 DM paths
> >>>    The I_T nexus's are:
> >>>       HBA1_TargetPort1
> >>>       HBA1_TargetPort3
> >>>       HBA2_TargetPort2
> >>>       HBA2_TargetPort4

Ok I'm new to SAN and multipathing so maybe it's just the way it is worded.  
Here is what we have and the instructions that were given to me.
####
FCSW00 xxx.xxx.xxx.233 Fabric A 
FCSW01 xxx.xxx.xxx.234 Fabric B
FCSW02 xxx.xxx.xxx.235 Fabric A
FCSW03 xxx.xxx.xxx.236 Fabric B

Summary: One HBA is attached to each fabric; two zones per HBA. One is zoned 
to a port on SPA and one is zoned to a port on SPB We have a CX600 which has 
4 ports per SP. So, it could be zoned to SPA0 (0-3)and SPB0(0-3)
####

If I understand correctly what I have is Example 2 (typo corrected).  Then I 
would, for an hba connected to Fabric A on a port on FCSW00, setup a zone on 
FCSW00 and another on FCSW02.  The same would apply for the hba in Fabric B 
using FCSW01 and FCSW03.

Is this correct or am I still lost?

Thanks,
John
