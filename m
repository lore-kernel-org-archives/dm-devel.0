From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: change default configuration
 parameters
Date: Wed, 16 Jan 2013 22:24:22 +0100
Message-ID: <1358371462.8351.18.camel@lapoo.opensvc.com>
References: <20130108053459.GU19059@ether.msp.redhat.com>
	<50EEFB87.1060707@gmail.com>
	<1358283765.3854.1.camel@lapoo.opensvc.com>
	<50F5D4B1.5070508@gmail.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50F5D4B1.5070508@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mar., 2013-01-15 at 23:14 +0100, Xose Vazquez Perez wrote:
...
> scsi_id is going to be replaced in systemd(recently udev was
> included in systemd).
> 
> See sg_inq(--export option) from sg3_utils.

We will need to patch sg_inq to report a denser id than the documented
SCSI_IDENT_<assoc>_<type>=<ident>

Time to launch a debate over the pertinence to maintain the '3' prefix
scsi_id insisted on prepending to the wwids ... Lennart will take the
blame without flinching I'm sure ;)

Regards,
Christophe Varoqui
www.opensvc.com
