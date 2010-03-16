From: David Huffman <dm-devel@storix.com>
Subject: Determine partition prefix used for mpath devices
Date: Tue, 16 Mar 2010 13:28:48 -0700
Message-ID: <4B9FEA00.2040703@storix.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

In a script, I need to somehow determine what prefix is being used for 
partitions as set by UDEV. It seems that the naming convention is in 
flux and could change frequently. When using user_friendly_names the 
prefix is set using kpartx within udev rules. My problem is I need to 
know what the prefix is so my scripts know what device naming convention 
to look for.

Here are the different iterations of naming schemes:

mpath0p1
mpath0-part1
mpathap1
mpatha-part1

Is there a way other than grepping through the udev rules to determine 
what the prefix is? The partitions may not exist so I cannot just look 
to see what they are. I need to know BEFORE I create partitions. I know 
this is a strange request, but I am working with a lot of code that was 
designed before multipath was available and using the sys naming is not 
an option (i.e. /disk/by-id/wwid).

Thanks in advance,
David
