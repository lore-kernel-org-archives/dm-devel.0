From: "Domenico Viggiani" <dviggiani@tiscali.it>
Subject: RE: Reloading multipathd?
Date: Wed, 7 Nov 2007 16:44:16 +0100
Message-ID: <000301c82155$0de88c60$cf42e3c1@pitagora.it>
References: <940B4FF1F5958E4F96FC83C055A2F2611B8B8C@exch-2003.incipient.waltham>
	<1194448727.6012.18.camel@sanderbal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1194448727.6012.18.camel@sanderbal>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'device-mapper development' <dm-devel@redhat.com>
List-Id: dm-devel.ids

> -----Original Message-----
> From: dm-devel-bounces@redhat.com 
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of S. J. van Harmelen
> Sent: Wednesday, November 07, 2007 4:19 PM
> 
> On Wed, 2007-11-07 at 08:33 -0500, Paul Cote wrote:
> > Did you do a rescan so that the O/S "sees" the new LUN? 
> 
> Nope... Could you tell me how to do that? And does a rescan 
> have any effect on already active LUN's?

# Send a LIP (loop initialization primitive) to the fabric 0
echo "1" > /sys/class/fc_host/host0/issue_lip 

# Scan SCSI bus 0:
echo "- - -" > /sys/class/scsi_host/host0/scan

# Send a LIP (loop initialization primitive) to the fabric 1
echo "1" > /sys/class/fc_host/host1/issue_lip 

# Scan SCSI bus 1:
echo "- - -" > /sys/class/scsi_host/host1/scan

# sometime is needed to repeat above steps two times?

# Check /var/log/messages and /proc/scsi/scsi

# Create multipath
multipath -v2
multipath -ll
