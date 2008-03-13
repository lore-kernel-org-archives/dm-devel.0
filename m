From: malahal@us.ibm.com
Subject: Re: Linux utility to determine WWN from a LUN number
Date: Thu, 13 Mar 2008 14:43:52 -0700
Message-ID: <20080313214352.GA18433@us.ibm.com>
References: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <B6FF36386FC9AC4BB098A4528811409F022309BE@CORPUSMX40A.corp.emc.com>
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

lemons_terry@emc.com [lemons_terry@emc.com] wrote:
> Hi
> 
> I want to have multipath manage only the CLARiiON LUN that I boot from (LUN 0).  So I know that I can specify the following in /etc/multipath.conf:
> 
> blacklist {
> 	wwid *
> 	}
> blacklist_exceptions {
> 	wwid nnnnnnnnnn
> 	}
> 
> The wwid value is different for every CLARiiON LUN.  So, if I want to automate the process of adding the 'wwid' value to the blacklist, what utility can I use to specify a LUN number, and find the WWN of the LUN?
> 
> Thanks!
> tl

lsscsi, lists all your SCSI devices. It should have LUN number and
device name. You can use scsi_id to get WWN. lsscsi uses "sysfs" file
system (/sys/class/scsi_device/ etc), so you should be able to write
your own to suite your exact needs.
