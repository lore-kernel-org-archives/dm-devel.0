From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: latest multipath-tools from git breaks EMC CX
Date: Fri, 3 Jun 2005 11:43:55 +0200
Message-ID: <20050603094355.GA10178@averon.dyndns.org>
References: <20050602204630.GK22633@marowsky-bree.de>
	<1117748565.15294.106.camel@zezette>
	<20050603065422.GA29496@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050603065422.GA29496@us.ibm.com>
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
List-Id: dm-devel.ids

> 
> I was hitting the same problem on my system (the sysfs_get_bus function
> leaving bus a none) the hack below fix it for me, but I only tested the
> bus code against scsi YMMV.
> 
Works for me too with iSCSI (scsi sysfs bus too).

Thanks, commited.
