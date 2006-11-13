From: James Smart <James.Smart@Emulex.Com>
Subject: Re: multipath and san fabric
Date: Mon, 13 Nov 2006 14:18:01 -0500
Message-ID: <4558C4E9.9020901@emulex.com>
References: <200611131135.32473.jslittl@hendricks.org>
Reply-To: James.Smart@Emulex.Com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200611131135.32473.jslittl@hendricks.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jslittl@hendricks.org, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

If the hba's are on different fabrics - why would you ever put an hba
that is not in the fabric in a zone in that fabric ?  (e.g. your second
option makes no sense).

If you are stating that the 2hba's are on different fabrics (and in zones
within those fabric) - but they are seeing the same Storage device on both
fabrics - then the dm config (note: I'm not talking about zoning anymore)
would have a path per I_T nexus. I state it this way to account for dual-ported
controllers, which may appear as separate targets, may exist within the fabric.

Example 1:
   Fabric A contains HBA1 and TargetPort1. Typically a zone would exist
     within Fabric A that contains these 2 ports.
   Fabric B contains HBA2 and TargetPort2. Typically a zone would exist
     within Fabric B that contains these 2 ports.
   The storage array contains 2 controllers with 1 port per controller, or
     is a single controller with 2 ports. Either way, the two ports are
     TargetPort1 and TargetPort2, are on the same array, and all storage
     can be seen from any port.
   --
   This would have 2 DM paths.
   The I_T nexus's are:
      HBA1_TargetPort1
      HBA2_TargetPort2

Example 2:
   Fabric A contains HBA1, TargetPort1, and TargetPort3. Typically a zone
     would exist within Fabric A that contains these 3 ports.
   Fabric B contains HBA2, TargetPort2, and TargetPort4. Typically a zone
     would exist within Fabric B that contains these 3 ports.
   The storage array contains 2 controllers, with 2 ports per controller.
     Meaning TargetPort1 and TargetPort2 are on controller A, and TargetPort3
     and TargetPort4 are on controller B. The ports are cross connected on
     the fabrics for redundancy. All storage can be seen from any port.
   --
   This would ahve 4 DM paths
   The I_T nexus's are:
      HBA1_TargetPort1
      HBA1_TargetPort2
      HBA2_TargetPort3
      HBA2_TargetPort4

-- james

John Little wrote:
> Hi all
> 
> Admittedly this is not the correct forum for this question but I have googled 
> this and the only people I have to ask around here are people who won't touch 
> it because it is Linux.
> 
> My question is this:  I'm using SLES10 with two emulex hbas, one connected to 
> fabric a and one to fabric b.  When zoning the switch for the hbas do I put 
> in only one path to the fabric per hba or do I put in two, one to each of the 
> separate fabrics?
> 
> Again I realize this is not exactly the correct forum but since I couldn't 
> find an answer anywhere else I figured you guys would be the most 
> knowledgeable.  If there are some docs somewhere that you could point me to I 
> would appreciate it.
> 
> John
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
