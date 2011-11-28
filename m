From: Gianluca Cecchi <gianluca.cecchi@gmail.com>
Subject: Re: info on enabling only one path with rdac and DS4700
Date: Mon, 28 Nov 2011 21:13:55 +0100
Message-ID: <CAG2kNCxeqXFy1i_-hET2zgf5sq==quNQt7MREKj-_0NS=9QnHQ@mail.gmail.com>
References: <CAG2kNCx2FSBFcKQQ5qRNNdY8c8OZ6iR+WY4XPUy21mttYn-wuw@mail.gmail.com>
	<1321389505.23295.4.camel@lapoo.opensvc.com>
	<CAG2kNCyHk+vosO1+TtNwLUcH5AJP-cPn8m5nCDhVkenXFFxfjw@mail.gmail.com>
	<201111161424.50911.hirtejs@idmt.fraunhofer.de>
	<CAG2kNCw9ZdWrk1Ai6xQ=gDeMeV22verUQWw8+18yWNMjscuPMg@mail.gmail.com>
	<47D23AD8469A2B448F33C24BD7A39BD9109D07FE@RTPMVEXC1-PRD.hq.netapp.com>
	<CAG2kNCxrA7twm2k7k8VWQGnWaADEog8iiyjEwfCiJj=OWCvqjQ@mail.gmail.com>
	<47D23AD8469A2B448F33C24BD7A39BD9109D090A@RTPMVEXC1-PRD.hq.netapp.com>
	<CAG2kNCzRbMQydCm4UQBX+fO6L1F5_jt7O3JWv-vCwgqE5Qkuww@mail.gmail.com>
	<47D23AD8469A2B448F33C24BD7A39BD9109D0977@RTPMVEXC1-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD9109D0977@RTPMVEXC1-PRD.hq.netapp.com>
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

On Mon, Nov 28, 2011 at 7:05 PM, Moger, Babu wrote:

>>
>>
>> the kernel is latest from RH EL 5.7 + updates:
>> 2.6.18-274.7.1.el5
>>
>> I'm going to check with its kernel-source to see it the patch is
>> applied or not...
>
> RHEL 5.7 has the patch already as I know. You can check to be sure. Can you also add "scsi_mod.scsi_logging_level=5056" in kernel line to get more information on what else is going on.

Ok, I have verified that the patch should be applied.
Downloaded kernel-2.6.18-274.7.1.el5.src.rpm
and in spec file I can find referral to
kernel-2.6.18-redhat.patch
that contains this inside section
--- linux-2.6.18.4/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ linux-2.6.18-redhat/drivers/scsi/device_handler/scsi_dh_rdac.c
...
+static int check_ownership(struct scsi_device *sdev, struct rdac_dh_data *h)
+{
+       int err;
+       struct c9_inquiry *inqp;
+
+       h->lun_state = RDAC_LUN_UNOWNED;
+       h->state = RDAC_STATE_ACTIVE;
+       err = submit_inquiry(sdev, 0xC9, sizeof(struct c9_inquiry), h);
+       if (err == SCSI_DH_OK) {
+               inqp = &h->inq.c9;
+               if ((inqp->avte_cvp >> 7) == 0x1) {
+                       /* LUN in AVT mode */
+                       sdev_printk(KERN_NOTICE, sdev,
+                                   "%s: AVT mode detected\n",
+                                   RDAC_NAME);
+                       h->lun_state = RDAC_LUN_AVT;
+               } else if ((inqp->avte_cvp & 0x1) != 0) {
+                       /* LUN was owned by the controller */
+                       h->lun_state = RDAC_LUN_OWNED;
+               }
+       }
+
+       if (h->lun_state == RDAC_LUN_UNOWNED)
+               h->state = RDAC_STATE_PASSIVE;
+       return err;
+}
+

So I'm going to add the scsi logging parameter you suggested and see.
