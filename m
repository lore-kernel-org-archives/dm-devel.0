From: "Scott Moseman" <scmoseman@gmail.com>
Subject: Re: NIC and HBA based multipathing
Date: Thu, 15 Nov 2007 14:40:39 -0600
Message-ID: <342d47870711151240q4789e31dy8e9c97a953ad34b2@mail.gmail.com>
References: <342d47870711061746s64daeaa0wcb6adf060506686c@mail.gmail.com>
	<342d47870711070707s7ac0fca2w1fdda12fb73fc548@mail.gmail.com>
	<342d47870711120954p56f41b30ob2c0956d11740244@mail.gmail.com>
	<20071112201835.GB23668@linux.vnet.ibm.com>
	<342d47870711121234o3aa82f95vc248308ef30097a3@mail.gmail.com>
	<342d47870711130852x4352d55axd2a0759cba9aa79@mail.gmail.com>
	<342d47870711151000o8bc5e6aw31394e039370c42c@mail.gmail.com>
	<473C939E.10609@cs.wisc.edu>
	<20071115191638.GB29968@linux.vnet.ibm.com>
	<342d47870711151226r77e754e9n78a6491bdc30fd56@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <342d47870711151226r77e754e9n78a6491bdc30fd56@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Nov 15, 2007 2:26 PM, Scott Moseman <scmoseman@gmail.com> wrote:
>
> # cat /etc/udev/rules.d/20-local.rules
> BUS="scsi", SYSFS{vendor}="EQLOGIC", SYSFS{model}="100E-00",
> PROGRAM="/sbin/scsi_id -g -u -s /block/%k",
> RESULT="30690a018f015191a6472441d1500f057", NAME=""
>
> Should I comment out that line, reboot (or restart iscsi) and see what happens?
>

It's a lab box, so I went ahead and gave it a try... success!

# multipath -l
30690a018f015191a6472441d1500f057
[size=4 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [enabled]
 \_ 1:0:1:0     sdb 8:16 [active][ready]
\_ round-robin 0 [enabled]
 \_ 7:0:0:0     sdc 8:32 [active][ready]

I guess I can start to play around with it now to see if it works!

Thanks for all your help so far, folks.
Scott
