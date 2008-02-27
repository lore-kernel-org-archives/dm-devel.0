From: malahal@us.ibm.com
Subject: Re: UDEV with DM-MULTIPATH issue in RHEL 5.1....
Date: Wed, 27 Feb 2008 10:28:03 -0800
Message-ID: <20080227182803.GA18357@us.ibm.com>
References: <508552.23576.qm@web90611.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <508552.23576.qm@web90611.mail.mud.yahoo.com>
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

The kernel names of DM devices show up as /dev/dm-X where X is some
integer. The /dev/mapper/XXX are created by the DM/MULTIPATH software
without any help from udev as far as I know.

So, use dm-X pattern instead. It may work.

--Malahal.

Dharmesh Kamdar [kamdard71@yahoo.com] wrote:
> Hi,
> 
> The UDEV rules are as follows:
> /etc/udev/rules.d/51-oracle-raw.rules
> ACTION=="add", KERNEL="/dev/mpath/OCR1p1",
> RUN+="/bin/raw /dev/raw/rawX %N"
> ACTION=="add", KERNEL="/dev/mpath/OCR2p1",
> RUN+="/bin/raw /dev/raw/rawX %N"
> ACTION=="add", KERNEL="/dev/mpath/VOTE1p1",
> RUN+="/bin/raw /dev/raw/rawX %N"
> ACTION=="add", KERNEL="/dev/mpath/VOTE2p1",
> RUN+="/bin/raw /dev/raw/rawX %N"
> ACTION=="add", KERNEL="/dev/mpath/VOTE3p1",
> RUN+="/bin/raw /dev/raw/rawX %N"
> ~                                                     
> 2) /etc/udev/rules.d/99-raw.rules
> #-------------------------#
