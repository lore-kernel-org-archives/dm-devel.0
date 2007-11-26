From: malahal@us.ibm.com
Subject: Re: user defined device name and table
Date: Mon, 26 Nov 2007 11:46:24 -0800
Message-ID: <20071126194624.GA23541@us.ibm.com>
References: <474ADDCF.8030703@fccn.pt>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <474ADDCF.8030703@fccn.pt>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: pedro.faustino@fccn.pt, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Pedro Bandim Faustino [pedro.faustino@fccn.pt] wrote:
> Hi All,
>
> I have a working multipath on root, but some questions still unanswered.
> I'm hoping you can help me out ;)
>
> But this is what I really would like to have:
>
> Output of multipath -ll:
> SRV07_BOOT (3600a0b8000295d64000009304742b4c8) dm-0 IBM,1814      FAStT
> [size=4.0G][features=1 queue_if_no_path][hwhandler=0]
> \_ round-robin 0 [prio=0][enabled]
> \_ 2:0:0:0 sda 8:0   [active][ready]
> \_ 3:0:0:0 sdc 8:32  [active][ready]
> \_ round-robin 0 [prio=6][active]
> \_ 2:0:1:0 sdb 8:16  [active][ready]
> \_ 3:0:1:0 sdd 8:48  [active][ready]
>
>
> I can modify the table by modifying the init script in the initrd image and 
> then booting with the modified initrd image but I don't know how to change 
> the name from mpath0 to SRV07_BOOT.

I don't know how Fedora Core 7 handles this in the initrd. Old RHEL
systems (prior to RHEL5.1) have nash commands to construct hard coded
multipath devices. You probably supply the name as part those commands.
If Fedora Core 7 uses something similar to RHEL5.2, then you could
probably use aliases in the multipath.conf file and rebuild initrd???
