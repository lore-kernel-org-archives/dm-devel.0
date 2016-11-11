From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] multipathd: deferred device adding
Date: Fri, 11 Nov 2016 03:21:44 +0000
Message-ID: <BLUPR02MB16838FD500AD57DA92DF4C0A81BB0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1478790321-8539-1-git-send-email-gi-oh.kim@profitbricks.com>
	<5a8c5ffb-2dae-0e5c-3341-1f02ab3cd4dc@suse.de>
	<8806d3b0-c507-3e2b-a7ff-fed6fbdfcb0a@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gioh Kim <gi-oh.kim@profitbricks.com>, Hannes Reinecke <hare@suse.de>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "benjamin.drung@profitbricks.com" <benjamin.drung@profitbricks.com>
List-Id: dm-devel.ids

On 11/10/16 07:54, Gioh Kim wrote:
> And new sdX device is created when the remote storage volume is connected via SCST.
> I don't want to create a dm device when sdX is created because there are other jobs before export the volume.
> For example, I need to change the size or format or copy data into sdb.
> I want to create the dm device when I finished the setup.
> I could disabled the socket in multipath udev rule file with v0.4.9.
> But I cannot find a way to ignore the uevent.

Hello Gioh,

Are you familiar with the SCST "enabled" target driver attribute? Have 
you considered to force initiators to log out while making changes at 
the target side be changing that attribute into 0 temporarily?

Bart.
