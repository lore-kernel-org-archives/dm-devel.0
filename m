From: Christian May <cmay@linux.vnet.ibm.com>
Subject: Re: ERROR: asr: reading /dev/sdo[Input/output error]
Date: Thu, 08 Dec 2011 10:46:52 +0100
Message-ID: <4EE0878C.4030200@linux.vnet.ibm.com>
References: <4EDF8497.7080508@linux.vnet.ibm.com>
	<4EDF9265.7080806@redhat.com>	<4EDFCC8E.2030801@linux.vnet.ibm.com>
	<4EE07801.8060504@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EE07801.8060504@redhat.com>
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

Am 08.12.2011 09:40, schrieb Heinz Mauelshagen:
> Should read:
>
>         kernel /boot/vmlinuz-2.6.32-131.0.15.el6.i686 ro 
> root=UUID=ad6570c8-5e2d-41f9-a228-85f9d68f00ce rd_NO_LUKS rd_NO_LVM 
> rd_NO_MD rd_NO_DM LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 
> KEYBOARDTYPE=pc KEYTABLE=de crashkernel=auto 
> rdloaddriver=scsi_dh_alua,scsi_dh_rdac  nodmraid
>
>


Thanks Heinz for helping...problem solved!

Christian
