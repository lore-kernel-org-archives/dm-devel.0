From: "shahid shaikh" <shahid.shaikh@patni.com>
Subject: RE: LVM Multipathing
Date: Mon, 14 Feb 2005 10:36:04 +0530
Message-ID: <003701c51252$e2b8d770$11051aac@pcp41116>
References: <420F3F9C.3050809@free.fr>
Reply-To: shahid.shaikh@patni.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="----------=_1108357250-30155-2"
In-Reply-To: <420F3F9C.3050809@free.fr>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: 'Christophe Varoqui' <christophe.varoqui@free.fr>
Cc: "Dm-Devel (E-mail)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format...

------------=_1108357250-30155-2
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I tried it previously and now also. But it doesnt get me out of trouble.

That's why i tried the 1st FAQ. 
Can you please elaborate what can be wrong in all this stuff?

Thanks and Regards, 
Shahid Shaikh. 

-----Original Message-----
From: Christophe Varoqui [mailto:christophe.varoqui@free.fr]
Sent: Sunday, February 13, 2005 5:23 PM
To: shahid.shaikh@patni.com; device-mapper development
Subject: Re: [dm-devel] LVM Multipathing


I was thinking about that part :

---


      3. LVM2 doesn't see my multipathed devices as PV, what's up ?

By default, lvm2 does not consider device-mapper block devices (such as 
a dm-crypt device) for use as physical volumes.

In order to use a dm-crypt device as an lvm2 pv, add this line to the 
devices block in /etc/lvm/lvm.conf:

types = [ "device-mapper", 16 ]

If /etc/lvm/lvm.conf does not exist, you can create one based on your 
current/default config like so:

lvm dumpconfig > /etc/lvm/lvm.conf

(tip from Christophe Saout)
---

... then again,

"you need to exclude the paths from the scaning"


regards,
cvaroqui

shahid shaikh wrote:

>Hello,
>
>I seen FAQ. Part relevant to me from FAQ (copied below) consist semething
>related to files /etc/mkinitrd/modules and
>/etc/mkinitrd/scripts.
>But these files are not peresnt at the given location on my system.
>I have installed udev-021-36.32 and multipath-tools-0.2.1 ( one which come
>bundled with SLES9).
>Please let me know why they are not present over. is there something still
>missing?
>Or i need install something else ( obviously excluding OS)?
>  
>



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

------------=_1108357250-30155-2
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
------------=_1108357250-30155-2--
