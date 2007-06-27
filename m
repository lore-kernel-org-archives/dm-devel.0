From: "Trantow, Wayne D" <wayne.d.trantow@intel.com>
Subject: RAID1 Recovery
Date: Wed, 27 Jun 2007 11:16:26 -0700
Message-ID: <4AFE4AEEFA305C4BB82F73F4D819506001D9A10E@orsmsx420.amr.corp.intel.com>
References: <20070626160032.0337973E8D@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-reply-to: <20070626160032.0337973E8D@hormel.redhat.com>
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

Hello,
I am studying the dmraid-1.0.0.rc14, device-mapper_CVS Latest, and
Fedora 6 (2.6.18-1.2798) kernel dmraid code to understand the recovery
logic for a RAID1 set.  The usage scenario is where one disk in a mirror
dies, the user swaps in a clean disk and then invokes dmraid app to
copy/sync data to the new disk.

Within this context I have a couple questions:

- In kernel space, it looks like a recovery operation (RH_RECOVERING)
will take place if the mirror_target.resume (mirror_resume) handler is
called.  In user space, in dmraid/reconfig.c add_dev_to_set() func sets
up handler add_dev_to_raid1() which should start the recovery.  However,
as far as I can see, add_dev_to_set is not wired in to the rest of the
dmraid code (i.e., nothing calls it).  What was the intent here? =20

- If you follow the call chain from add_dev_to_raid1 into device-mapper
it sets up a 'resume' call via an DM_DEV_RESUME ioctl dm_task, however,
in the device-mapper _cmd_data_v4 struct (in libdm-iface.c) the 'resume'
handler func is associated with the DM_DEV_SUSPEND ioctl not
DM_DEV_RESUME. Hence, even if you invoked add_dev_to_raid1, a direct
ioctl call to the kernel mirror_target.resume func is not possible.  Is
this a bug or intentional? Or am I not seeing it correctly?

Regards,
Skip Trantow
Manageability and Platform Software Division
Intel Corporation
Email: wayne.d.trantow@intel.com
