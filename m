From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: LVM Multipathing
Date: Sun, 13 Feb 2005 12:57:36 +0530
Message-ID: <000001c5119d$7dfb5c50$11051aac@pcp41116>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1108279337-10766-90"
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Dm-Devel (E-mail)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format...

------------=_1108279337-10766-90
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I am trying to test multipathing on lvm2.

Configuration that i am using is as below:

OS                     : SLES9 ( kernel 2.6.5)
lvm                     : lvm2-2.00.15-0.3
multipath-tools    : multipath-tools-0.2.1
udev                   : udev-021-36.32
sysfs                  : sblim-cmpi-sysfs-1.1.5-0.2
hotplug               : hotplug-0.44-32.21 and hotplugctl-0.08-264.1
device-mapper     : device-mapper-1.00.09-17.5

I tried following things :

When I dont have multipaths for LUNs:
1) I tried to create PVs on LUNs using pvcreate
2) Then VGs using above PVs by command vgcreate
3) Then I have created some LVs on VGs.
4) I also fire some I/O on these LVs.
All aboe commands worked succesfully reflecting changes in pvscan, vgscan
and lvscan.

When I have multiplepaths to LUNs:
I tried to create PV on one of the device but on doing pvscan it shows me
some other device.
    e.g  My LUN no 5 has for paths so I can see these four paths as
/dev/sdb, /dev/sdg, /dev/sdl and /dev/sdq.
          then i did following
	   linux# pvcreate /dev/sdb
	   /dev/sdb successfully created
         linux# pvscan
	 	Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdb not
/dev/sdq
		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdg not
/dev/sdq
  		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdl not
/dev/sdq
 		PV /dev/sdq    VG vg01   lvm2 [1.00 GB / 972.00 MB free]
  		Total: 1 [1.00 GB] / in use: 1 [1.00 GB] / in no VG: 0 [0   ]

	  linux# vgcreate vg01
		succesfully created

	  linux# vgscan
 		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdb not
/dev/sdq
		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdg not
/dev/sdq
  		Found duplicate PV owucgI06ZCWQHX6rM3Jyj6UKsr5MOt7E: using /dev/sdl not
/dev/sdq

 I tried the same thing with all permutations but i couldnt create a volume
group.

 I also have  multipath-tools-0.3.9 and  multipath-tools-0.4.2.
 But I am not sure whether they will compatible with kernel 2.6.5.

If you can help me in this scenario I will be thankfull to you.
Please let me know the steps through which I can achieve multipathing on my
configuration.

Thanks and Regards,
Shahid Shaikh.



http://www.patni.com
World-Wide Partnerships. World-Class Solutions.
_____________________________________________________________________

This e-mail message may contain proprietary, confidential or legally
privileged information for the sole use of the person or entity to
whom this message was originally addressed. Any review, e-transmission
dissemination or other use of or taking of any action in reliance upon
this information by persons or entities other than the intended
recipient is prohibited. If you have received this e-mail in error
kindly delete  this e-mail from your records. If it appears that this
mail has been forwarded to you without proper authority, please notify
us immediately at netadmin@patni.com and delete this mail. 
_____________________________________________________________________

------------=_1108279337-10766-90
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
------------=_1108279337-10766-90--
